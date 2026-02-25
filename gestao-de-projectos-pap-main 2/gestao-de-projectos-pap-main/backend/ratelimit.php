<?php
/**
 * ratelimit.php - Proteção contra brute-force e rate limiting
 */

require_once __DIR__ . '/config.php';

// Verifica rate limit
function checkRateLimit($identifier, $attempts = null, $window = null) {
    $attempts = $attempts ?? (int)getConfig('RATE_LIMIT_ATTEMPTS', '5');
    $window = $window ?? (int)getConfig('RATE_LIMIT_WINDOW', '900'); // 15 minutos
    
    // Simples implementação em session (em produção usar Redis)
    session_start();
    
    $now = time();
    $key = "ratelimit_$identifier";
    
    if (!isset($_SESSION[$key])) {
        $_SESSION[$key] = [];
    }
    
    // Remove tentativas expiradas
    $_SESSION[$key] = array_filter($_SESSION[$key], function($ts) use ($now, $window) {
        return ($now - $ts) < $window;
    });
    
    // Verifica limite
    if (count($_SESSION[$key]) >= $attempts) {
        return false;
    }
    
    // Registra tentativa
    $_SESSION[$key][] = $now;
    return true;
}

// Reseta rate limit
function resetRateLimit($identifier) {
    session_start();
    $key = "ratelimit_$identifier";
    unset($_SESSION[$key]);
}

// Valida rate limit para login
function validateLoginRateLimit($email) {
    if (!checkRateLimit("login_$email")) {
        http_response_code(429);
        echo json_encode(['success' => false, 'error' => 'Muitas tentativas. Tente novamente mais tarde.']);
        exit;
    }
}

?>
