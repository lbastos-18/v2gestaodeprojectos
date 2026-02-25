<?php
/**
 * logout.php - Endpoint de logout
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

logout();
echo json_encode(['success' => true, 'message' => 'Logout bem-sucedido']);
?>
