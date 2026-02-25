<?php
/**
 * check-auth.php - Verifica status de autenticação do utilizador atual
 * GET - retorna dados do utilizador autenticado ou erro 401
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

initSession();

if (isAuthenticated()) {
    echo json_encode([
        'success' => true,
        'user' => [
            'id' => $_SESSION['user_id'],
            'email' => $_SESSION['user_email'],
            'role' => $_SESSION['user_role']
        ]
    ]);
} else {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Não autenticado']);
}
?>
