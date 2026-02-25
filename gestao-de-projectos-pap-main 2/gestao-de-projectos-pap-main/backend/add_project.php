<?php
/**
 * add_project.php - Criar novo projeto (POST multipart/form-data)
 * Requer autenticação e token CSRF válido
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

// Validação de inputs
$name = trim($_POST['name'] ?? '');
$year = intval($_POST['year'] ?? 0);
$course = trim($_POST['course'] ?? '');
$type = trim($_POST['type'] ?? '');
$advisor = trim($_POST['advisor'] ?? '');
$summary = trim($_POST['summary'] ?? '');
$description = trim($_POST['description'] ?? '');

if ($name === '' || $year <= 0 || $year > 2100) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Campos obrigatórios inválidos']);
    exit;
}

// Valida comprimento dos campos
$maxLengths = [
    'name' => 255,
    'course' => 255,
    'type' => 100,
    'advisor' => 255,
    'summary' => 1000,
    'description' => 5000,
];

if (strlen($name) > $maxLengths['name'] || 
    strlen($course) > $maxLengths['course'] ||
    strlen($type) > $maxLengths['type'] ||
    strlen($advisor) > $maxLengths['advisor'] ||
    strlen($summary) > $maxLengths['summary'] ||
    strlen($description) > $maxLengths['description']) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Alguns campos excedem o comprimento máximo']);
    exit;
}

$uploadCfg = getUploadConfig();
$uploadPath = __DIR__ . '/../uploads';
if (!is_dir($uploadPath)) {
    mkdir($uploadPath, 0755, true);
}

$pdfPath = null;
if (!empty($_FILES['project_pdf']) && $_FILES['project_pdf']['error'] === UPLOAD_ERR_OK) {
    $file = $_FILES['project_pdf'];
    
    // Valida tamanho
    if ($file['size'] > $uploadCfg['max_size']) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Ficheiro demasiado grande']);
        exit;
    }
    
    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($ext, $uploadCfg['allowed_types'], true)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Tipo de ficheiro não permitido']);
        exit;
    }
    
    // Valida MIME type
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mimeType = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);
    
    $allowedMimes = ['application/pdf'];
    if (!in_array($mimeType, $allowedMimes, true)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'MIME type inválido']);
        exit;
    }
    
    // Gera nome seguro
    $safeName = bin2hex(random_bytes(16)) . '.' . $ext;
    $dest = $uploadPath . '/' . $safeName;
    
    if (!move_uploaded_file($file['tmp_name'], $dest)) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Erro ao guardar ficheiro']);
        exit;
    }
    
    $pdfPath = 'uploads/' . $safeName;
}

try {
    $pdo = getPDO();
    $stmt = $pdo->prepare(
        'INSERT INTO projects (name, year, course, type, advisor, summary, description, pdf_path, created_by) 
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $name,
        $year,
        $course,
        $type,
        $advisor,
        $summary,
        $description,
        $pdfPath,
        $_SESSION['user_id']
    ]);
    
    echo json_encode([
        'success' => true,
        'id' => $pdo->lastInsertId(),
        'message' => 'Projeto criado com sucesso'
    ]);
    exit;
} catch (Exception $e) {
    if (isDebug()) {
        error_log('Add project error: ' . $e->getMessage());
    } else {
        error_log('Add project error: ' . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Erro ao criar projeto']);
    exit;
}
?>
