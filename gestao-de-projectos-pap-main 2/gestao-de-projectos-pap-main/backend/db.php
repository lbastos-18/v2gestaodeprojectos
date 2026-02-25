<?php
/**
 * db.php - PDO connection helper com configuração segura
 */
require_once __DIR__ . '/config.php';

function getPDO() {
    static $pdo = null;
    if ($pdo === null) {
        try {
            $cfg = getDbConfig();
            $dsn = 'mysql:host=' . $cfg['host'] . 
                   ';port=' . $cfg['port'] . 
                   ';dbname=' . $cfg['name'] . 
                   ';charset=utf8mb4';
            
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ];
            
            $pdo = new PDO($dsn, $cfg['user'], $cfg['pass'], $options);
        } catch (PDOException $e) {
            http_response_code(500);
            
            // Em desenvolvimento, mostra o erro; em produção, registra e retorna mensagem genérica
            if (isDebug()) {
                error_log('PDO Error: ' . $e->getMessage());
                echo json_encode(['success' => false, 'error' => 'Database connection error: ' . $e->getMessage()]);
            } else {
                error_log('PDO Error: ' . $e->getMessage());
                echo json_encode(['success' => false, 'error' => 'Database connection error']);
            }
            exit;
        }
    }
    return $pdo;
}
