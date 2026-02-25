<?php
/**
 * session.php - Gerenciamento seguro de sessões e CSRF
 */

require_once __DIR__ . '/config.php';

// Inicia sessão com configurações seguras
function initSession() {
    if (session_status() === PHP_SESSION_NONE) {
        $cfg = getSessionConfig();
        
        session_set_cookie_params([
            'lifetime' => $cfg['lifetime'],
            'path' => '/',
            'domain' => $_SERVER['HTTP_HOST'] ?? 'localhost',
            'secure' => $cfg['secure'],
            'httponly' => $cfg['httponly'],
            'samesite' => $cfg['samesite'],
        ]);
        
        session_start();
        
        // Regenera ID na primeira vez
        if (empty($_SESSION['initialized'])) {
            session_regenerate_id(true);
            $_SESSION['initialized'] = true;
        }
    }
}

// Verifica se utilizador está autenticado
function isAuthenticated() {
    initSession();
    return !empty($_SESSION['user_id']) && !empty($_SESSION['user_email']);
}

// Verifica se utilizador tem papel específico
function hasRole($role) {
    initSession();
    return isset($_SESSION['user_role']) && $_SESSION['user_role'] === $role;
}

// Requer autenticação (erro 401 se não autenticado)
function requireAuth() {
    if (!isAuthenticated()) {
        http_response_code(401);
        echo json_encode(['success' => false, 'error' => 'Não autenticado']);
        exit;
    }
}

// Requer papel específico (erro 403 se sem permissão)
function requireRole($role) {
    requireAuth();
    if (!hasRole($role)) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Sem permissão']);
        exit;
    }
}

// Gera token CSRF
function generateCSRFToken() {
    initSession();
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes((int)getConfig('CSRF_TOKEN_LENGTH', '32') / 2));
    }
    return $_SESSION['csrf_token'];
}

// Obtém token CSRF (para HTML)
function getCSRFToken() {
    return generateCSRFToken();
}

// Valida token CSRF
function validateCSRFToken($token) {
    initSession();
    if (empty($_SESSION['csrf_token']) || empty($token)) {
        return false;
    }
    return hash_equals($_SESSION['csrf_token'], $token);
}

// Requer token CSRF válido
function requireCSRFToken() {
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
    if (!validateCSRFToken($token)) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Token CSRF inválido']);
        exit;
    }
}

// Faz logout
function logout() {
    initSession();
    session_destroy();
    setcookie(session_name(), '', time() - 3600, '/');
}

// Define utilizador na sessão (após autenticação bem-sucedida)
function setAuthUser($userId, $email, $role) {
    initSession();
    $_SESSION['user_id'] = $userId;
    $_SESSION['user_email'] = $email;
    $_SESSION['user_role'] = $role;
    session_regenerate_id(true);
}

?>
