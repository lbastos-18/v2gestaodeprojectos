<?php
/**
 * Script para criar um utilizador admin
 * Execute uma única vez: php create_admin.php
 * Depois elimine este ficheiro por segurança
 */

// Incluir config
require 'config.php';
require 'db.php';

// Dados do admin
$name = 'Administrador';
$email = 'admin@projectos.pt';
$password = 'Admin@123'; // MUDE ISTO DEPOIS!
$role = 'admin';

try {
    // Hash da password com bcrypt
    $password_hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
    
    // Verificar se já existe
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ?');
    $stmt->execute([$email]);
    
    if ($stmt->rowCount() > 0) {
        echo "❌ Admin já existe com este email!\n";
        exit(1);
    }
    
    // Criar admin
    $stmt = $pdo->prepare('
        INSERT INTO users (name, email, password_hash, role, created_at)
        VALUES (?, ?, ?, ?, NOW())
    ');
    
    $stmt->execute([$name, $email, $password_hash, $role]);
    
    echo "✅ Admin criado com sucesso!\n";
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    echo "Email: $email\n";
    echo "Password: $password\n";
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n";
    echo "⚠️  IMPORTANTE:\n";
    echo "1. Guarde estas credenciais num local seguro\n";
    echo "2. Mude a password após primeiro login\n";
    echo "3. Elimine este ficheiro (create_admin.php) por segurança\n";
    echo "4. Aceda a /login.html e faça login\n";
    
} catch (Exception $e) {
    echo "❌ Erro ao criar admin: " . $e->getMessage() . "\n";
    exit(1);
}
?>
