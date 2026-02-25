<?php
/**
 * edit_project.php - Editar projeto existente
 * POST id (no URL ou POST) com dados a atualizar
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

// Obtém projeto para verificar permissão
try {
    $pdo = getPDO();
    $stmt = $pdo->prepare('SELECT id, created_by FROM projects WHERE id = ?');
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
        echo json_encode(['success' => false, 'error' => 'Sem permissão para editar este projeto']);
        exit;
    }
    
    // Valida e coleta dados para atualização
    $updates = [];
    $values = [];
    
    if (!empty($_POST['name'])) {
        $name = trim($_POST['name']);
        if (strlen($name) <= 255) {
            $updates[] = 'name = ?';
            $values[] = $name;
        }
    }
    
    if (!empty($_POST['year'])) {
        $year = intval($_POST['year']);
        if ($year > 0 && $year <= 2100) {
            $updates[] = 'year = ?';
            $values[] = $year;
        }
    }
    
    if (isset($_POST['course'])) {
        $course = trim($_POST['course']);
        if (strlen($course) <= 255) {
            $updates[] = 'course = ?';
            $values[] = $course;
        }
    }
    
    if (isset($_POST['type'])) {
        $type = trim($_POST['type']);
        if (strlen($type) <= 100) {
            $updates[] = 'type = ?';
            $values[] = $type;
        }
    }
    
    if (isset($_POST['advisor'])) {
        $advisor = trim($_POST['advisor']);
        if (strlen($advisor) <= 255) {
            $updates[] = 'advisor = ?';
            $values[] = $advisor;
        }
    }
    
    if (isset($_POST['summary'])) {
        $summary = trim($_POST['summary']);
        if (strlen($summary) <= 1000) {
            $updates[] = 'summary = ?';
            $values[] = $summary;
        }
    }
    
    if (isset($_POST['description'])) {
        $description = trim($_POST['description']);
        if (strlen($description) <= 5000) {
            $updates[] = 'description = ?';
            $values[] = $description;
        }
    }
    
    if (!empty($updates)) {
        $values[] = $projectId;
        $sql = 'UPDATE projects SET ' . implode(', ', $updates) . ', updated_at = NOW() WHERE id = ?';
        $stmt = $pdo->prepare($sql);
        $stmt->execute($values);
        
        echo json_encode([
            'success' => true,
            'message' => 'Projeto atualizado com sucesso'
        ]);
    } else {
        echo json_encode([
            'success' => true,
            'message' => 'Nenhum campo para atualizar'
        ]);
    }
    
} catch (Exception $e) {
    if (isDebug()) {
        error_log('Edit project error: ' . $e->getMessage());
    } else {
        error_log('Edit project error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro ao atualizar projeto']);
    exit;
}
?>