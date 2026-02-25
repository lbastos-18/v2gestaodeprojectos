<?php
/**
 * config.php - Carrega variáveis de ambiente e fornece funções de configuração segura
 */

// Carrega variáveis de .env (alternativa: usar vlucas/phpdotenv)
function loadEnv($filePath = __DIR__ . '/../.env') {
    if (!file_exists($filePath)) {
        return;
    }
    $lines = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos($line, '=') === false || strpos($line, '#') === 0) {
            continue;
        }
        [$key, $value] = explode('=', $line, 2);
        $key = trim($key);
        $value = trim($value);
        if (!isset($_ENV[$key]) && !isset($_SERVER[$key])) {
            putenv("$key=$value");
        }
    }
}

// Carrega .env se não estiver em produção
if (getenv('APP_ENV') !== 'production') {
    loadEnv();
}

// Funções de configuração segura
function getConfig($key, $default = null) {
    return getenv($key) ?: $default;
}

function getDbConfig() {
    return [
        'host' => getConfig('DB_HOST', '127.0.0.1'),
        'port' => getConfig('DB_PORT', '3306'),
        'name' => getConfig('DB_NAME', 'gestao_projects'),
        'user' => getConfig('DB_USER', ''),
        'pass' => getConfig('DB_PASS', ''),
    ];
}

function getSessionConfig() {
    return [
        'lifetime' => (int)getConfig('SESSION_LIFETIME', '3600'),
        'secure' => getConfig('SESSION_SECURE', 'false') === 'true',
        'httponly' => getConfig('SESSION_HTTPONLY', 'true') === 'true',
        'samesite' => getConfig('SESSION_SAMESITE', 'Strict'),
    ];
}

function getUploadConfig() {
    return [
        'max_size' => (int)getConfig('UPLOAD_MAX_SIZE', '5242880'),
        'allowed_types' => explode(',', getConfig('UPLOAD_ALLOWED_TYPES', 'pdf')),
        'scan_virus' => getConfig('UPLOAD_SCAN_VIRUS', 'false') === 'true',
    ];
}

function isDebug() {
    return getConfig('APP_DEBUG', 'false') === 'true';
}

function isProduction() {
    return getConfig('APP_ENV', 'development') === 'production';
}
?>
