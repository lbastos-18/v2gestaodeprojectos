<?php
/**
 * list_projects.php - Listar projetos com paginação
 * GET ?page=1&limit=10
 * Requer autenticação (admin pode ver todos; utilizadores normais veem apenas seus)
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

// Requer autenticação
requireAuth();

$page = max(1, intval($_GET['page'] ?? 1));
$limit = min(100, max(1, intval($_GET['limit'] ?? 10)));
$offset = ($page - 1) * $limit;

try {
    $pdo = getPDO();
    
    // Se admin, lista todos; senão, lista apenas projetos do utilizador
    if (hasRole('admin')) {
        $stmt = $pdo->prepare(
            'SELECT id, name, year, course, type, advisor, summary, description, pdf_path, defended, defense_date, created_by 
             FROM projects 
             ORDER BY created_at DESC 
             LIMIT ? OFFSET ?'
        );
        $stmt->execute([$limit, $offset]);
    } else {
        $stmt = $pdo->prepare(
            'SELECT p.id, p.name, p.year, p.course, p.type, p.advisor, p.summary, p.description, p.pdf_path, p.defended, p.defense_date, p.created_by 
             FROM projects p 
             JOIN project_members pm ON p.id = pm.project_id 
             WHERE pm.user_id = ? 
             ORDER BY p.created_at DESC 
             LIMIT ? OFFSET ?'
        );
        $stmt->execute([$_SESSION['user_id'], $limit, $offset]);
    }
    
    $projects = $stmt->fetchAll();
    
    // Total de projetos
    if (hasRole('admin')) {
        $countStmt = $pdo->prepare('SELECT COUNT(*) as total FROM projects');
        $countStmt->execute();
    } else {
        $countStmt = $pdo->prepare(
            'SELECT COUNT(*) as total FROM projects p 
             JOIN project_members pm ON p.id = pm.project_id 
             WHERE pm.user_id = ?'
        );
        $countStmt->execute([$_SESSION['user_id']]);
    }
    $total = $countStmt->fetch()['total'];
    
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
        error_log('List projects error: ' . $e->getMessage());
    } else {
        error_log('List projects error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro ao listar projetos']);
    exit;
}
?>
