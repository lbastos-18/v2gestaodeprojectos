#!/bin/bash
# test_api.sh - Script de teste básico da API
# Uso: bash test_api.sh

set -e

BASE_URL="http://localhost/gestao-projectos/backend"
COOKIES_FILE="cookies.txt"

echo "🧪 Iniciando testes da API..."
echo "📍 Base URL: $BASE_URL"

# Limpar cookies antigos
rm -f "$COOKIES_FILE"

# 1. Teste: Obter token CSRF
echo ""
echo "1️⃣ Obtendo token CSRF..."
CSRF_RESPONSE=$(curl -s "$BASE_URL/csrf-token.php")
CSRF_TOKEN=$(echo "$CSRF_RESPONSE" | grep -o '"csrf_token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$CSRF_TOKEN" ]; then
    echo "❌ Erro ao obter token CSRF"
    exit 1
fi

echo "✅ Token CSRF obtido: ${CSRF_TOKEN:0:20}..."

# 2. Teste: Login com credenciais inválidas
echo ""
echo "2️⃣ Testando login com credenciais inválidas..."
INVALID_LOGIN=$(curl -s -X POST "$BASE_URL/auth.php" \
    -c "$COOKIES_FILE" \
    -d "email=invalid@example.com&password=wrongpass&csrf_token=$CSRF_TOKEN")

if echo "$INVALID_LOGIN" | grep -q '"success":false'; then
    echo "✅ Login inválido rejeitado corretamente"
else
    echo "❌ Erro: Login inválido não foi rejeitado"
    exit 1
fi

# 3. Teste: Verificar autenticação (não autenticado)
echo ""
echo "3️⃣ Verificando autenticação sem login..."
AUTH_CHECK=$(curl -s -b "$COOKIES_FILE" "$BASE_URL/check-auth.php")

if echo "$AUTH_CHECK" | grep -q '401'; then
    echo "✅ Acesso negado corretamente (não autenticado)"
else
    echo "⚠️ Aviso: Esperava erro 401"
fi

# 4. Teste: Rate limiting
echo ""
echo "4️⃣ Testando rate limiting (5 tentativas em 15 min)..."
for i in {1..6}; do
    RESPONSE=$(curl -s -X POST "$BASE_URL/auth.php" \
        -d "email=test@example.com&password=test&csrf_token=$CSRF_TOKEN")
    
    if [ $i -eq 6 ]; then
        if echo "$RESPONSE" | grep -q '"error":"Muitas tentativas'; then
            echo "✅ Rate limiting ativado na tentativa $i"
        else
            echo "⚠️ Aviso: Rate limiting pode não estar funcionando"
        fi
    else
        echo "  Tentativa $i..."
    fi
done

# 5. Teste: Validação CSRF
echo ""
echo "5️⃣ Testando validação CSRF..."
CSRF_INVALID=$(curl -s -X POST "$BASE_URL/auth.php" \
    -d "email=test@example.com&password=test&csrf_token=invalid_token")

if echo "$CSRF_INVALID" | grep -q '"error":"Token CSRF'; then
    echo "✅ Token CSRF inválido rejeitado"
else
    echo "⚠️ Aviso: Validação CSRF pode não estar funcionando"
fi

# 6. Teste: Endpoint protegido sem autenticação
echo ""
echo "6️⃣ Testando acesso a endpoint protegido sem autenticação..."
LIST_RESPONSE=$(curl -s -b "$COOKIES_FILE" "$BASE_URL/list_projects.php")

if echo "$LIST_RESPONSE" | grep -q '"error":"Não autenticado'; then
    echo "✅ Acesso a endpoint protegido negado sem autenticação"
else
    echo "❌ Erro: Endpoint deveria exigir autenticação"
fi

echo ""
echo "✅ Testes completados!"
echo ""
echo "ℹ️ Notas:"
echo "  - Para testes completos, criar utilizador de teste na BD"
echo "  - Executar: mysql < backend/schema.sql"
echo "  - Criar utilizador com password_hash: password_hash('teste123', PASSWORD_DEFAULT)"
