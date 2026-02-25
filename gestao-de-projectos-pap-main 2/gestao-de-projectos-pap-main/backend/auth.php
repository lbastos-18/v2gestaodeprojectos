<?php
/**
 * auth.php - Endpoint de autenticação com sessões seguras e rate limiting
 * POST: email, password, csrf_token
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/session.php';
require_once __DIR__ . '/ratelimit.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

// Valida CSRF token
try {
    requireCSRFToken();
} catch (Exception $e) {
    // Token CSRF ausente/inválido é tratado em requireCSRFToken()
}

$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
$password = $_POST['password'] ?? '';

if (!$email || !$password) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Email e password obrigatórios']);
    exit;
}

// Rate limiting
validateLoginRateLimit($email);

try {
    $pdo = getPDO();
    $stmt = $pdo->prepare('SELECT id, email, password_hash, role FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password_hash'])) {
        // Autenticação bem-sucedida
        setAuthUser($user['id'], $user['email'], $user['role']);
        resetRateLimit("login_$email");
        
        echo json_encode([
            'success' => true,
            'message' => 'Autenticação bem-sucedida',
            'role' => $user['role']
        ]);
        exit;
    } else {
        // Falha na autenticação (não revela se email existe)
        http_response_code(401);
        echo json_encode(['success' => false, 'error' => 'Email ou password inválidos']);
        exit;
    }
} catch (Exception $e) {
    if (isDebug()) {
        error_log('Auth error: ' . $e->getMessage());
    } else {
        error_log('Auth error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro na autenticação']);
    exit;
}
?>
