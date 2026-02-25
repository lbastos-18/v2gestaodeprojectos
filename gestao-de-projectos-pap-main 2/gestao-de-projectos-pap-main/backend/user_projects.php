<?php
/**
 * user_projects.php - Listar projetos de um utilizador específico
 * GET/POST user_id
 * Admin pode listar qualquer utilizador; utilizadores normais veem apenas seus próprios
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

// Requer autenticação
requireAuth();

$rawUserId = null;
if (!empty($_GET['user_id'])) $rawUserId = $_GET['user_id'];
if (!$rawUserId && !empty($_POST['user_id'])) $rawUserId = $_POST['user_id'];

if (!$rawUserId) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'user_id é obrigatório']);
    exit;
}

$userId = (int)$rawUserId;

// Verifica permissão: admin ou solicitando os seus próprios projetos
if ($userId !== $_SESSION['user_id'] && !hasRole('admin')) {
    http_response_code(403);
    echo json_encode(['success' => false, 'error' => 'Sem permissão para ver projetos deste utilizador']);
    exit;
}

try {
    $pdo = getPDO();

    $stmt = $pdo->prepare(
        'SELECT p.id, p.name, p.year, p.course, p.type, p.advisor, p.summary, p.description, p.pdf_path, p.defended, p.defense_date 
         FROM projects p 
         JOIN project_members pm ON p.id = pm.project_id 
         WHERE pm.user_id = ? 
         ORDER BY p.created_at DESC'
    );
    $stmt->execute([$userId]);
    $projects = $stmt->fetchAll();

    // Obtém membros para cada projeto
    $memberStmt = $pdo->prepare(
        'SELECT u.id, u.name, u.email, pm.is_leader 
         FROM users u 
         JOIN project_members pm ON u.id = pm.user_id 
         WHERE pm.project_id = ?'
    );

    foreach ($projects as &$p) {
        $memberStmt->execute([$p['id']]);
        $p['members'] = $memberStmt->fetchAll();
    }

    echo json_encode([
        'success' => true,
        'projects' => $projects
    ]);
} catch (Exception $e) {
    if (isDebug()) {
        error_log('User projects error: ' . $e->getMessage());
    } else {
        error_log('User projects error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro ao obter projectos do utilizador']);
}

?>
