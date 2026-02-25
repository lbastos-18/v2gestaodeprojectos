<?php
/**
 * delete_project.php - Deletar projeto
 * POST id
 * Requer autenticação e permissão (criador ou admin)
 */
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/session.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Método não permitido']);
    exit;
}

// Requer autenticação como admin
requireRole('admin');

// Requer CSRF token
requireCSRFToken();

$projectId = intval($_POST['id'] ?? 0);
if ($projectId <= 0) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'ID do projeto inválido']);
    exit;
}

try {
    $pdo = getPDO();
    
    // Obtém projeto para verificar permissão
    $stmt = $pdo->prepare('SELECT id, created_by, pdf_path FROM projects WHERE id = ?');
    $stmt->execute([$projectId]);
    $project = $stmt->fetch();
    
    if (!$project) {
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Projeto não encontrado']);
        exit;
    }
    
    // Verifica permissão: criador ou admin
    if ($project['created_by'] !== $_SESSION['user_id'] && !hasRole('admin')) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Sem permissão para deletar este projeto']);
        exit;
    }
    
    // Inicia transação
    $pdo->beginTransaction();
    
    // Deleta membros do projeto
    $stmt = $pdo->prepare('DELETE FROM project_members WHERE project_id = ?');
    $stmt->execute([$projectId]);
    
    // Deleta projeto
    $stmt = $pdo->prepare('DELETE FROM projects WHERE id = ?');
    $stmt->execute([$projectId]);
    
    // Deleta ficheiro PDF se existir
    if ($project['pdf_path'] && file_exists(__DIR__ . '/../' . $project['pdf_path'])) {
        unlink(__DIR__ . '/../' . $project['pdf_path']);
    }
    
    $pdo->commit();
    
    echo json_encode([
        'success' => true,
        'message' => 'Projeto deletado com sucesso'
    ]);
    
} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    
    if (isDebug()) {
        error_log('Delete project error: ' . $e->getMessage());
    } else {
        error_log('Delete project error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro ao deletar projeto']);
    exit;
}
?>