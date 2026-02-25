-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUERIES CRÍTICAS DE SUPORTE
-- Utilize estas queries nos scripts PHP para operações comuns
-- ═══════════════════════════════════════════════════════════════════════════════════

USE gestao_projects;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 1. LISTAR PROJECTOS COM FILTROS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Query: Listar projectos defendidos (para página pública)
SELECT 
  p.id,
  p.title,
  p.year,
  c.name as course,
  pt.name as type,
  u.name as advisor,
  COUNT(DISTINCT pm.id) as member_count,
  COALESCE(d.grade, NULL) as grade,
  p.status,
  p.created_at
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
LEFT JOIN project_types pt ON p.type_id = pt.id
LEFT JOIN users u ON p.advisor_id = u.id
LEFT JOIN project_members pm ON p.id = pm.project_id
LEFT JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
WHERE p.is_deleted = FALSE
  AND p.status IN ('defended', 'completed')
  AND (c.id = ? OR ? IS NULL)           -- Filtro por curso (parametrizado)
  AND (pt.id = ? OR ? IS NULL)          -- Filtro por tipo
  AND (p.year = ? OR ? IS NULL)         -- Filtro por ano
GROUP BY p.id
ORDER BY p.created_at DESC
LIMIT 20 OFFSET 0;

-- Query: Listar projectos para dashboard admin
SELECT 
  p.id,
  p.title,
  p.year,
  c.name as course,
  pt.name as type,
  u.name as advisor,
  COUNT(DISTINCT pm.id) as member_count,
  p.status,
  p.created_at,
  uc.name as created_by_name
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
LEFT JOIN project_types pt ON p.type_id = pt.id
LEFT JOIN users u ON p.advisor_id = u.id
LEFT JOIN project_members pm ON p.id = pm.project_id
LEFT JOIN users uc ON p.created_by = uc.id
WHERE p.is_deleted = FALSE
GROUP BY p.id
ORDER BY p.created_at DESC
LIMIT 10;

-- Query: Projectos do utilizador autenticado
SELECT 
  p.id,
  p.title,
  p.year,
  c.name as course,
  pt.name as type,
  u.name as advisor,
  pm.role as member_role,
  pm.is_lead,
  p.status,
  p.created_at
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
LEFT JOIN project_types pt ON p.type_id = pt.id
LEFT JOIN users u ON p.advisor_id = u.id
INNER JOIN project_members pm ON p.id = pm.project_id
WHERE p.is_deleted = FALSE
  AND pm.user_id = ?  -- ID do utilizador autenticado
ORDER BY p.created_at DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 2. DETALHE COMPLETO DE UM PROJECTO
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Query: Obter informações completas de um projecto
SELECT 
  p.id,
  p.title,
  p.subtitle,
  p.year,
  c.name as course_name,
  pt.name as type_name,
  u.name as advisor_name,
  u.email as advisor_email,
  p.summary,
  p.description,
  p.objectives,
  p.languages,
  p.database_type,
  p.duration_months,
  p.work_hours,
  p.status,
  p.grade as project_grade,
  COUNT(DISTINCT pm.id) as member_count,
  COUNT(DISTINCT CASE WHEN pf.is_deleted = FALSE THEN pf.id END) as file_count,
  COALESCE(d.grade, NULL) as defense_grade,
  COALESCE(d.status, 'pending') as defense_status,
  COALESCE(d.actual_date, NULL) as defense_date,
  p.created_at,
  p.updated_at
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
LEFT JOIN project_types pt ON p.type_id = pt.id
LEFT JOIN users u ON p.advisor_id = u.id
LEFT JOIN project_members pm ON p.id = pm.project_id
LEFT JOIN project_files pf ON p.id = pf.project_id
LEFT JOIN defenses d ON p.id = d.project_id
WHERE p.is_deleted = FALSE AND p.id = ?
GROUP BY p.id;

-- Query: Membros de um projecto
SELECT 
  pm.id,
  pm.user_id,
  u.name,
  u.email,
  pm.role,
  pm.responsibilities,
  pm.is_lead,
  pm.created_at
FROM project_members pm
INNER JOIN users u ON pm.user_id = u.id
WHERE pm.project_id = ?
ORDER BY pm.is_lead DESC, u.name ASC;

-- Query: Ficheiros de um projecto
SELECT 
  pf.id,
  pf.original_filename,
  pf.file_path,
  pf.file_size,
  pf.file_type,
  pf.mime_type,
  pf.description,
  pf.is_primary,
  pf.version,
  pf.uploaded_at,
  u.name as uploaded_by_name
FROM project_files pf
LEFT JOIN users u ON pf.uploaded_by = u.id
WHERE pf.project_id = ? AND pf.is_deleted = FALSE
ORDER BY pf.is_primary DESC, pf.uploaded_at DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 3. ESTATÍSTICAS E ANALYTICS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Query: Total de projectos por estado
SELECT 
  status,
  COUNT(*) as total
FROM projects
WHERE is_deleted = FALSE
GROUP BY status
ORDER BY total DESC;

-- Query: Projectos por curso (com contagem)
SELECT 
  c.id,
  c.name as course_name,
  COUNT(p.id) as total_projects,
  COUNT(CASE WHEN p.status = 'defended' THEN 1 END) as defended_projects,
  COUNT(CASE WHEN p.status = 'in_progress' THEN 1 END) as in_progress_projects,
  AVG(d.grade) as average_grade
FROM courses c
LEFT JOIN projects p ON c.id = p.course_id AND p.is_deleted = FALSE
LEFT JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
WHERE c.is_active = TRUE
GROUP BY c.id
ORDER BY total_projects DESC;

-- Query: Projectos por tipo
SELECT 
  pt.id,
  pt.name as type_name,
  COUNT(p.id) as total_projects,
  AVG(d.grade) as average_grade
FROM project_types pt
LEFT JOIN projects p ON pt.id = p.type_id AND p.is_deleted = FALSE
LEFT JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
WHERE pt.is_active = TRUE
GROUP BY pt.id
ORDER BY total_projects DESC;

-- Query: Estatísticas de defesas este mês
SELECT 
  COUNT(*) as total_defenses,
  COUNT(CASE WHEN d.status = 'completed' THEN 1 END) as completed,
  COUNT(CASE WHEN d.status = 'scheduled' THEN 1 END) as scheduled,
  COUNT(CASE WHEN d.status = 'postponed' THEN 1 END) as postponed,
  AVG(d.grade) as average_grade
FROM defenses d
WHERE MONTH(d.actual_date) = MONTH(NOW())
  OR (MONTH(d.scheduled_date) = MONTH(NOW()) AND d.status = 'scheduled');

-- Query: Projectos defendidos por ano
SELECT 
  p.year,
  COUNT(p.id) as total_defended,
  AVG(d.grade) as average_grade,
  MAX(d.actual_date) as last_defense
FROM projects p
INNER JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
WHERE p.is_deleted = FALSE
GROUP BY p.year
ORDER BY p.year DESC;

-- Query: Orientadores com mais projectos
SELECT 
  u.id,
  u.name,
  u.email,
  COUNT(p.id) as total_projects,
  COUNT(CASE WHEN p.status = 'defended' THEN 1 END) as defended_projects,
  AVG(d.grade) as average_grade
FROM users u
LEFT JOIN projects p ON u.id = p.advisor_id AND p.is_deleted = FALSE
LEFT JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
WHERE u.role = 'advisor'
GROUP BY u.id
ORDER BY total_projects DESC;

-- Query: Alunos mais projectados
SELECT 
  u.id,
  u.name,
  u.email,
  COUNT(DISTINCT pm.project_id) as total_projects,
  COUNT(CASE WHEN p.status = 'defended' THEN 1 END) as defended_projects
FROM users u
LEFT JOIN project_members pm ON u.id = pm.user_id
LEFT JOIN projects p ON pm.project_id = p.id AND p.is_deleted = FALSE
WHERE u.role = 'student'
GROUP BY u.id
ORDER BY total_projects DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 4. OPERAÇÕES DE AUDITORIA E INTEGRIDADE
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Query: Verificar integridade de relações (projectos órfãos)
SELECT p.id, p.title
FROM projects p
WHERE p.is_deleted = FALSE
  AND (p.course_id NOT IN (SELECT id FROM courses) OR p.type_id NOT IN (SELECT id FROM project_types));

-- Query: Membros sem informações de utilizador
SELECT pm.id, pm.project_id
FROM project_members pm
WHERE pm.user_id NOT IN (SELECT id FROM users);

-- Query: Ficheiros órfãos
SELECT pf.id, pf.file_path
FROM project_files pf
WHERE pf.project_id NOT IN (SELECT id FROM projects);

-- Query: Defesas sem projecto
SELECT d.id
FROM defenses d
WHERE d.project_id NOT IN (SELECT id FROM projects);

-- Query: Log de auditoria recente
SELECT 
  al.id,
  u.name as user_name,
  al.action,
  al.entity_type,
  al.entity_id,
  al.created_at,
  al.ip_address
FROM audit_log al
LEFT JOIN users u ON al.user_id = u.id
ORDER BY al.created_at DESC
LIMIT 50;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 5. BUSCAS AVANÇADAS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Query: Pesquisa de texto completo em projectos
SELECT 
  p.id,
  p.title,
  p.year,
  c.name as course_name,
  u.name as advisor_name,
  MATCH(p.title, p.summary) AGAINST (? IN BOOLEAN MODE) as relevance
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
LEFT JOIN users u ON p.advisor_id = u.id
WHERE p.is_deleted = FALSE
  AND MATCH(p.title, p.summary) AGAINST (? IN BOOLEAN MODE)
ORDER BY relevance DESC;

-- Query: Projectos de um aluno específico
SELECT 
  DISTINCT p.id,
  p.title,
  p.year,
  c.name as course_name,
  pm.role,
  pm.is_lead,
  p.status
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
INNER JOIN project_members pm ON p.id = pm.project_id
WHERE p.is_deleted = FALSE AND pm.user_id = ?
ORDER BY p.year DESC, p.created_at DESC;

-- Query: Projectos orientados por um professor
SELECT 
  p.id,
  p.title,
  p.year,
  c.name as course_name,
  pt.name as type_name,
  COUNT(DISTINCT pm.id) as member_count,
  p.status,
  COALESCE(d.grade, NULL) as grade
FROM projects p
INNER JOIN courses c ON p.course_id = c.id
LEFT JOIN project_types pt ON p.type_id = pt.id
LEFT JOIN project_members pm ON p.id = pm.project_id
LEFT JOIN defenses d ON p.id = d.project_id AND d.status = 'completed'
WHERE p.is_deleted = FALSE AND p.advisor_id = ?
GROUP BY p.id
ORDER BY p.year DESC, p.created_at DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 6. OPERAÇÕES DE MANUTENÇÃO
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Query: Desactivar utilizador (soft delete)
UPDATE users 
SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP
WHERE id = ?;

-- Query: Mover projecto para archive
UPDATE projects 
SET status = 'archived', updated_at = CURRENT_TIMESTAMP
WHERE id = ?;

-- Query: Limpar ficheiros antigos (soft delete)
UPDATE project_files 
SET is_deleted = TRUE, updated_at = CURRENT_TIMESTAMP
WHERE uploaded_at < DATE_SUB(NOW(), INTERVAL 1 YEAR)
  AND is_primary = FALSE;

-- Query: Contar registos por tabela (para backup/maintenance)
SELECT 
  'users' as table_name, COUNT(*) as total FROM users
UNION ALL
SELECT 'projects', COUNT(*) FROM projects WHERE is_deleted = FALSE
UNION ALL
SELECT 'project_members', COUNT(*) FROM project_members
UNION ALL
SELECT 'project_files', COUNT(*) FROM project_files WHERE is_deleted = FALSE
UNION ALL
SELECT 'defenses', COUNT(*) FROM defenses
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'project_types', COUNT(*) FROM project_types;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 7. VIEWS - QUERIES PÉPRÉ-COMPILADAS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Use estas views nas suas queries PHP para simplificar:
-- SELECT * FROM v_projects_detailed WHERE course_name = 'Informática';
-- SELECT * FROM v_stats_by_course;
-- SELECT * FROM v_defended_this_year;

-- ═══════════════════════════════════════════════════════════════════════════════════
