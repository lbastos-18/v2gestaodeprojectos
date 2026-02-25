<?php
/**
 * csrf-token.php - Endpoint para obter token CSRF
 * GET - retorna token CSRF em JSON
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

$token = getCSRFToken();
echo json_encode(['success' => true, 'csrf_token' => $token]);
?>
