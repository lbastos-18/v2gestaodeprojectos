<?php
/**
 * list_defended_projects.php - Listar projetos defendidos (público)
 * GET ?page=1&limit=10
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

$page = max(1, intval($_GET['page'] ?? 1));
$limit = min(100, max(1, intval($_GET['limit'] ?? 10)));
$offset = ($page - 1) * $limit;

try {
    $pdo = getPDO();

    $stmt = $pdo->prepare(
        'SELECT id, name, year, course, type, advisor, summary, description, pdf_path, defended, defense_date 
         FROM projects 
         WHERE defended = 1 
         ORDER BY defense_date DESC 
         LIMIT ? OFFSET ?'
    );
    $stmt->execute([$limit, $offset]);
    $projects = $stmt->fetchAll();

    // Obtém total
    $countStmt = $pdo->prepare('SELECT COUNT(*) as total FROM projects WHERE defended = 1');
    $countStmt->execute();
    $total = $countStmt->fetch()['total'];

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
        'projects' => $projects,
        'pagination' => [
            'page' => $page,
            'limit' => $limit,
            'total' => $total,
            'pages' => ceil($total / $limit)
        ]
    ]);
} catch (Exception $e) {
    if (isDebug()) {
        error_log('List defended projects error: ' . $e->getMessage());
    } else {
        error_log('List defended projects error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro ao obter projectos defendidos']);
}

?>
