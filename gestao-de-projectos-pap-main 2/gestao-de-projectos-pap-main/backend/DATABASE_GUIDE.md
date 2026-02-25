-- ═══════════════════════════════════════════════════════════════════════════════════
-- GUIA DE IMPLEMENTAÇÃO - BASE DE DADOS
-- Gestão de Projectos Académicos v2.0
-- ═══════════════════════════════════════════════════════════════════════════════════

## ÍNDICE

1. Estrutura do Banco de Dados
2. Como Implementar
3. Dados de Teste
4. Queries Críticas
5. Integridade de Dados
6. Performance
7. Backup e Restore
8. Troubleshooting

---

## 1. ESTRUTURA DO BANCO DE DADOS

### Tabelas Principais (9 tabelas):

#### Core Tables (Essenciais):
- **users**: Utilizadores (admin, advisor, student)
- **projects**: Projectos académicos
- **courses**: Catálogo de cursos
- **project_types**: Tipos de projectos

#### Relacionamentos:
- **project_members**: Alunos/membros de cada projecto
- **project_files**: Ficheiros (PDFs, relatórios, código)
- **defenses**: Informações de defesa/apresentação
- **defense_members**: Banca avaliadora

#### Auditoria:
- **audit_log**: Registo de todas as operações (opcional)

### Relacionamentos:

```
users (1) ────────→ (N) projects [orientador]
users (1) ────────→ (N) projects [criador]
users (1) ────────→ (N) project_members [membro]
users (1) ────────→ (N) project_files [uploader]
users (1) ────────→ (N) defense_members [avaliador]

courses (1) ──────→ (N) projects
project_types (1) → (N) projects

projects (1) ─────→ (N) project_members
projects (1) ─────→ (N) project_files
projects (1) ─────→ (1) defenses

defenses (1) ──────→ (N) defense_members
```

---

## 2. COMO IMPLEMENTAR

### PASSO 1: Criar Base de Dados

```bash
# SSH para servidor ou GUI do MySQL

# Opção A: MySQL CLI
mysql -u root -p < /path/to/backend/schema.sql

# Opção B: phpMyAdmin
1. Abrir phpMyAdmin
2. New → Database → "gestao_projects" → UTF8MB4
3. Seleccionar DB e importar schema.sql
```

### PASSO 2: Verificar Estructura

```sql
-- Verificar tabelas criadas
SHOW TABLES;

-- Verificar estrutura de uma tabela
DESCRIBE projects;

-- Verificar foreign keys
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, 
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'gestao_projects';
```

### PASSO 3: Carregar Dados de Teste

```bash
# Opção A: MySQL CLI
mysql -u root -p gestao_projects < /path/to/backend/seed_data.sql

# Opção B: phpMyAdmin
1. Seleccionar DB "gestao_projects"
2. Import → Seleccionar seed_data.sql → Go
```

### PASSO 4: Gerar Hashes de Password

```bash
# CRÍTICO: Substituir placeholders com hashes reais
php -r "echo password_hash('admin123', PASSWORD_DEFAULT) . PHP_EOL;"
# Output: $2y$10$abcdefghijklmnop... (copiar)

php -r "echo password_hash('advisor123', PASSWORD_DEFAULT) . PHP_EOL;"
php -r "echo password_hash('student123', PASSWORD_DEFAULT) . PHP_EOL;"
```

Depois executar:
```sql
UPDATE users 
SET password_hash = '$2y$10$HASH_AQUI'
WHERE email = 'admin@santaana.ao';
```

### PASSO 5: Configurar backend/config.php

```php
// .env ou directamente em config.php
DB_HOST=localhost
DB_PORT=3306
DB_NAME=gestao_projects
DB_USER=seu_usuario
DB_PASS=sua_password
APP_ENV=development  // ou 'production'
```

### PASSO 6: Testar Conexão

```php
<?php
require_once 'backend/db.php';

try {
    $pdo = getPDO();
    $stmt = $pdo->query("SELECT COUNT(*) as total FROM users");
    $result = $stmt->fetch();
    echo "✓ Conexão OK. Total users: " . $result['total'];
} catch (Exception $e) {
    echo "✗ Erro: " . $e->getMessage();
}
?>
```

---

## 3. DADOS DE TESTE

### Utilizadores Pré-carregados:

| Email | Password | Role | Função |
|-------|----------|------|--------|
| admin@santaana.ao | admin123 | admin | Administrador do sistema |
| joao.silva@santaana.ao | advisor123 | advisor | Prof. Informática |
| paulo.costa@santaana.ao | advisor123 | advisor | Eng. Redes |
| helena.santos@santaana.ao | advisor123 | advisor | Dra. Saúde |
| manuel.rocha@santaana.ao | advisor123 | advisor | Dr. Gestão |
| nuno.oliveira@santaana.ao | advisor123 | advisor | Prof. Contabilidade |
| carlos.mendes@santaana.ao | advisor123 | advisor | Eng. Segurança |
| lukeny.bastos@student.ao | student123 | student | Aluno |
| ... (7 mais alunos) | student123 | student | Alunos |

### Cursos:
- Informática
- Gestão Empresarial
- Enfermagem
- Contabilidade & Gestão
- Telecomunicações

### Projectos (6 exemplos):
- Sistema de Gestão de Projectos (2025, Defendido, Grade: 18.5)
- Rede Corporativa TCP/IP (2025, Defendido, Grade: 19.0)
- App Hotelaria (2025, Defendido, Grade: 19.5)
- Sistema Hospitalar (2024, Defendido, Grade: 17.5)
- Plataforma Contabilidade (2024, Defendido, Grade: 18.0)
- Segurança em Redes (2025, Em Progresso, Defesa: 15/Mar)

---

## 4. QUERIES CRÍTICAS

### Listar Projectos Defendidos (para página pública):
```php
$stmt = $pdo->prepare("
  SELECT p.id, p.title, p.year, c.name as course, u.name as advisor,
         COUNT(pm.id) as member_count, d.grade
  FROM projects p
  INNER JOIN courses c ON p.course_id = c.id
  LEFT JOIN project_types pt ON p.type_id = pt.id
  LEFT JOIN users u ON p.advisor_id = u.id
  LEFT JOIN project_members pm ON p.id = pm.project_id
  LEFT JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
  WHERE p.is_deleted = FALSE AND p.status IN ('defended', 'completed')
    AND (c.id = ? OR ? IS NULL)
    AND (pt.id = ? OR ? IS NULL)
    AND (p.year = ? OR ? IS NULL)
  GROUP BY p.id
  ORDER BY p.created_at DESC
  LIMIT 20
");

$stmt->execute([$courseId, $courseId, $typeId, $typeId, $year, $year]);
$projects = $stmt->fetchAll();
```

### Obter Detalhes de um Projecto:
```php
// Informações do projecto
$stmt = $pdo->prepare("
  SELECT p.*, c.name as course_name, pt.name as type_name, u.name as advisor_name
  FROM projects p
  INNER JOIN courses c ON p.course_id = c.id
  LEFT JOIN project_types pt ON p.type_id = pt.id
  LEFT JOIN users u ON p.advisor_id = u.id
  WHERE p.id = ? AND p.is_deleted = FALSE
");
$stmt->execute([$projectId]);
$project = $stmt->fetch();

// Membros do projecto
$stmt = $pdo->prepare("
  SELECT pm.*, u.name, u.email
  FROM project_members pm
  INNER JOIN users u ON pm.user_id = u.id
  WHERE pm.project_id = ?
  ORDER BY pm.is_lead DESC, u.name
");
$stmt->execute([$projectId]);
$members = $stmt->fetchAll();

// Ficheiros
$stmt = $pdo->prepare("
  SELECT * FROM project_files
  WHERE project_id = ? AND is_deleted = FALSE
  ORDER BY is_primary DESC, uploaded_at DESC
");
$stmt->execute([$projectId]);
$files = $stmt->fetchAll();
```

### Dashboard - Estatísticas:
```php
// Projectos por curso
$stmt = $pdo->query("
  SELECT c.name, COUNT(p.id) as count
  FROM courses c
  LEFT JOIN projects p ON c.id = p.course_id AND p.is_deleted = FALSE
  WHERE c.is_active = TRUE
  GROUP BY c.id
");
$courseStats = $stmt->fetchAll();

// Total projectos por status
$stmt = $pdo->query("
  SELECT status, COUNT(*) as count
  FROM projects
  WHERE is_deleted = FALSE
  GROUP BY status
");
$statusStats = $stmt->fetchAll();

// Média de grades
$stmt = $pdo->query("
  SELECT AVG(d.grade) as avg_grade
  FROM defenses d
  WHERE d.status = 'completed'
");
$avgGrade = $stmt->fetch();
```

---

## 5. INTEGRIDADE DE DADOS

### Constraints Implementadas:

| Tipo | Descrição | SQL |
|------|-----------|-----|
| **FK** | Foreign Keys | `FOREIGN KEY ... REFERENCES` |
| **UNIQUE** | Email, Project-Member | `UNIQUE KEY` |
| **CHECK** | Validação de range | `CHECK (year BETWEEN 2000 AND 2100)` |
| **NOT NULL** | Campos obrigatórios | `NOT NULL` |
| **DEFAULT** | Valores por defeito | `DEFAULT CURRENT_TIMESTAMP` |

### Triggers Implementados:

1. **update_users_timestamp**: Actualiza `updated_at` em users
2. **update_projects_timestamp**: Actualiza `updated_at` em projects
3. **update_project_members_timestamp**: Actualiza `updated_at` em project_members
4. **update_defenses_timestamp**: Actualiza `updated_at` em defenses

### Validações em PHP (add_project.php):

```php
// Validar ano
if ($year < 2000 || $year > 2100) {
    throw new Exception("Ano inválido");
}

// Validar grade (0-20)
if ($grade < 0 || $grade > 20) {
    throw new Exception("Grade deve estar entre 0 e 20");
}

// Validar email
$email = filter_var($email, FILTER_VALIDATE_EMAIL);
if (!$email) {
    throw new Exception("Email inválido");
}

// Validar tamanho de ficheiro
if ($fileSize > 5242880) {  // 5MB
    throw new Exception("Ficheiro muito grande");
}
```

---

## 6. PERFORMANCE

### Índices Criados:

Todas as colunas usadas em:
- WHERE clauses
- JOIN conditions
- ORDER BY
- GROUP BY

Têm índices para performance.

```sql
-- Exemplos de índices:
KEY idx_email (email)
KEY idx_course_id (course_id)
KEY idx_year_course (year, course_id)  -- Índice composto
FULLTEXT KEY ft_title_summary (title, summary)  -- Full-text search
```

### Queries Otimizadas:

```sql
-- ✓ BOM: Usa índices
SELECT * FROM projects
WHERE course_id = ? AND year = ?
ORDER BY created_at DESC;

-- ✗ MÁU: Não usa índices
SELECT * FROM projects
WHERE CONCAT(course_id, year) = ?
ORDER BY YEAR(created_at) DESC;
```

### EXPLAIN - Verificar Query Plan:

```sql
EXPLAIN SELECT * FROM projects
WHERE course_id = 1 AND year = 2025;

-- Procura por:
-- - type: ref ou const (bom), range ou ALL (mau)
-- - key: deve mostrar idx_* (está usando índice)
-- - rows: deve ser baixo
```

---

## 7. BACKUP E RESTORE

### Backup (MySQL Dump):

```bash
# Backup completo
mysqldump -u user -p gestao_projects > backup_$(date +%Y%m%d_%H%M%S).sql

# Apenas estrutura
mysqldump -u user -p --no-data gestao_projects > structure_only.sql

# Apenas dados
mysqldump -u user -p --no-create-info gestao_projects > data_only.sql
```

### Restore:

```bash
# Restaurar completo
mysql -u user -p gestao_projects < backup_20250225_150000.sql

# Via phpMyAdmin:
1. Database → Import
2. Seleccionar arquivo .sql
3. Go
```

### Backup Automático (Linux Cron):

```bash
# Abrir crontab
crontab -e

# Adicionar linha para backup diário às 2:00 AM
0 2 * * * mysqldump -u user -p'password' gestao_projects > /backups/db_$(date +\%Y\%m\%d).sql
```

---

## 8. TROUBLESHOOTING

### Problema: "Access denied for user"

**Causa**: Credenciais DB incorrectas em config.php

**Solução**:
```php
// Verificar credenciais em backend/config.php
DB_USER=seu_usuario_mysql
DB_PASS=sua_password_mysql

// Testar no MySQL:
mysql -u seu_usuario_mysql -p
// Digitar password
SHOW DATABASES;  // Deve mostrar gestao_projects
```

### Problema: "Table doesn't exist"

**Causa**: schema.sql não foi executado

**Solução**:
```bash
mysql -u root -p < backend/schema.sql
```

### Problema: "Foreign key constraint fails"

**Causa**: Tentando inserir valor que não existe em tabela relacionada

**Solução**:
```php
// Verificar se FK existe antes de inserir
$stmt = $pdo->prepare("SELECT id FROM courses WHERE id = ?");
$stmt->execute([$courseId]);
if (!$stmt->fetch()) {
    throw new Exception("Curso não existe");
}
```

### Problema: "Duplicate entry for key 'email'"

**Causa**: Email já existe na tabela users

**Solução**:
```php
// Verificar antes de inserir
$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    throw new Exception("Email já registado");
}
```

### Problema: Queries lentas

**Solução**:
```sql
-- Analisar query
EXPLAIN SELECT ...;

-- Adicionar índices se necessário
CREATE INDEX idx_novo ON tabela(coluna);

-- Usar ANALYZE TABLE para actualizar estatísticas
ANALYZE TABLE projects;
```

### Problema: Ficheiros não aparecem no public/project-details.html

**Causa**: File path incorrecta ou ficheiro não existe no disco

**Solução**:
```php
// Em project_files, verificar file_path
SELECT file_path FROM project_files WHERE id = ?;

// Ficheiro deve estar em: /uploads/caminho_relativo
ls -la /var/www/html/uploads/

// Se não existir, copiar para: /uploads/1_relatorio.pdf
```

---

## PRÓXIMOS PASSOS

1. ✅ Schema.sql criado e testado
2. ✅ Dados de exemplo carregados (seed_data.sql)
3. ✅ Queries de suporte documentadas (queries_support.sql)
4. ⏳ Integrar queries em PHP (add_project.php, list_projects.php, etc)
5. ⏳ Testes de integridade de dados
6. ⏳ Performance tuning se necessário
7. ⏳ Deploy em produção com backups

---

**Versão**: 2.0
**Data**: 25 de Fevereiro de 2026
**Autor**: GitHub Copilot (Database Specialist)

═══════════════════════════════════════════════════════════════════════════════════
