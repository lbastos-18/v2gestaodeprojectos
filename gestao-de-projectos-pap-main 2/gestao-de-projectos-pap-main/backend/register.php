<?php
/**
 * register.php - Endpoint de registo de novos utilizadores
 * POST: name, email, password, role, csrf_token
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

// Valida CSRF token
try {
    requireCSRFToken();
} catch (Exception $e) {
    http_response_code(403);
    echo json_encode(['success' => false, 'error' => 'Token CSRF inválido']);
    exit;
}

$name = trim($_POST['name'] ?? '');
$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
$password = $_POST['password'] ?? '';
$role = trim($_POST['role'] ?? 'student');

// Validações
if (!$name || strlen($name) < 2) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Nome inválido']);
    exit;
}

if (!$email) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Email inválido']);
    exit;
}

if (!$password || strlen($password) < 6) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Password deve ter no mínimo 6 caracteres']);
    exit;
}

// Apenas student e advisor podem se registar
if (!in_array($role, ['student', 'advisor'])) {
    $role = 'student';
}

try {
    $pdo = getPDO();
    
    // Verifica se email já existe
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        http_response_code(409);
        echo json_encode(['success' => false, 'error' => 'Email já registado']);
        exit;
    }
    
    // Hash da password
    $password_hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
    
    // Cria novo utilizador
    $stmt = $pdo->prepare('
        INSERT INTO users (name, email, password_hash, role, created_at)
        VALUES (?, ?, ?, ?, NOW())
    ');
    $stmt->execute([$name, $email, $password_hash, $role]);
    
    // Login automático após registo
    $userId = $pdo->lastInsertId();
    setAuthUser($userId, $email, $role);
    
    http_response_code(201);
    echo json_encode([
        'success' => true,
        'message' => 'Registo bem-sucedido',
        'role' => $role
    ]);
    
} catch (Exception $e) {
    error_log('Register error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro no servidor']);
    exit;
}
?>
