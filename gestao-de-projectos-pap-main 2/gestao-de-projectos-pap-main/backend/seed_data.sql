-- ═══════════════════════════════════════════════════════════════════════════════════
-- DADOS DE EXEMPLO: Gestão de Projectos
-- Execute após executar schema.sql
-- Nota: Passwords são hashes bcrypt gerados com PHP: password_hash('password', PASSWORD_DEFAULT)
-- ═══════════════════════════════════════════════════════════════════════════════════

USE gestao_projects;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 1. CURSOS
-- ═══════════════════════════════════════════════════════════════════════════════════

INSERT INTO courses (name, description, code, department, is_active) VALUES
('Informática', 'Curso de Informática com foco em desenvolvimento de software e sistemas', 'INFO', 'Tecnologia', TRUE),
('Gestão Empresarial', 'Curso de Gestão Empresarial com foco em administração e negócios', 'GEST', 'Administração', TRUE),
('Enfermagem', 'Curso de Enfermagem com foco em cuidados de saúde', 'ENFERM', 'Saúde', TRUE),
('Contabilidade & Gestão', 'Curso de Contabilidade e Gestão Financeira', 'CONTAB', 'Administração', TRUE),
('Telecomunicações', 'Curso de Telecomunicações e Redes', 'TELE', 'Tecnologia', TRUE);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 2. TIPOS DE PROJECTOS
-- ═══════════════════════════════════════════════════════════════════════════════════

INSERT INTO project_types (name, description, icon, is_active) VALUES
('Programação', 'Projecto de desenvolvimento de software e aplicações', 'bi-code-square', TRUE),
('Redes', 'Projecto de redes de computadores e infraestrutura', 'bi-diagram-3', TRUE),
('Infraestrutura', 'Projecto de infraestrutura de TI', 'bi-server', TRUE),
('Análise de Dados', 'Projecto de análise e tratamento de dados', 'bi-graph-up', TRUE),
('Segurança', 'Projecto de segurança de sistemas', 'bi-shield-lock', TRUE);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 3. UTILIZADORES (Admin, Advisors, Students)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Admin (password: admin123)
INSERT INTO users (name, email, password_hash, phone, department, role, is_active, email_verified) VALUES
('Admin Sistema', 'admin@santaana.ao', '$2y$10$YourHashedPasswordHere1', '+244-923-456-789', 'Administração', 'admin', TRUE, TRUE);

-- Advisors/Orientadores (password: advisor123)
INSERT INTO users (name, email, password_hash, phone, department, role, is_active, email_verified, bio) VALUES
('Prof. João Silva', 'joao.silva@santaana.ao', '$2y$10$YourHashedPasswordHere2', '+244-923-000-001', 'Informática', 'advisor', TRUE, TRUE, 'Orientador especializado em programação web'),
('Eng. Paulo Costa', 'paulo.costa@santaana.ao', '$2y$10$YourHashedPasswordHere3', '+244-923-000-002', 'Informática', 'advisor', TRUE, TRUE, 'Especialista em redes e infraestrutura'),
('Dra. Helena Santos', 'helena.santos@santaana.ao', '$2y$10$YourHashedPasswordHere4', '+244-923-000-003', 'Saúde', 'advisor', TRUE, TRUE, 'Orientadora em projectos de enfermagem'),
('Dr. Manuel Rocha', 'manuel.rocha@santaana.ao', '$2y$10$YourHashedPasswordHere5', '+244-923-000-004', 'Administração', 'advisor', TRUE, TRUE, 'Especialista em gestão e empreendedorismo'),
('Prof. Nuno Oliveira', 'nuno.oliveira@santaana.ao', '$2y$10$YourHashedPasswordHere6', '+244-923-000-005', 'Administração', 'advisor', TRUE, TRUE, 'Orientador em contabilidade e finanças'),
('Eng. Carlos Mendes', 'carlos.mendes@santaana.ao', '$2y$10$YourHashedPasswordHere7', '+244-923-000-006', 'Informática', 'advisor', TRUE, TRUE, 'Especialista em segurança de sistemas');

-- Alunos (password: student123)
INSERT INTO users (name, email, password_hash, phone, department, role, is_active, email_verified) VALUES
('Lukeny Bastos', 'lukeny.bastos@student.ao', '$2y$10$YourHashedPasswordHere8', '+244-923-100-001', 'Informática', 'student', TRUE, FALSE),
('Belmiro Damião', 'belmiro.damiao@student.ao', '$2y$10$YourHashedPasswordHere9', '+244-923-100-002', 'Informática', 'student', TRUE, FALSE),
('Epandi Andrade', 'epandi.andrade@student.ao', '$2y$10$YourHashedPasswordHere10', '+244-923-100-003', 'Informática', 'student', TRUE, FALSE),
('José André Suende', 'jose.andre@student.ao', '$2y$10$YourHashedPasswordHere11', '+244-923-100-004', 'Informática', 'student', TRUE, FALSE),
('Ana Silva', 'ana.silva@student.ao', '$2y$10$YourHashedPasswordHere12', '+244-923-100-005', 'Gestão Empresarial', 'student', TRUE, FALSE),
('Miguel Santos', 'miguel.santos@student.ao', '$2y$10$YourHashedPasswordHere13', '+244-923-100-006', 'Gestão Empresarial', 'student', TRUE, FALSE),
('Clara Fernandes', 'clara.fernandes@student.ao', '$2y$10$YourHashedPasswordHere14', '+244-923-100-007', 'Enfermagem', 'student', TRUE, FALSE),
('João Mateus', 'joao.mateus@student.ao', '$2y$10$YourHashedPasswordHere15', '+244-923-100-008', 'Contabilidade & Gestão', 'student', TRUE, FALSE);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 4. PROJECTOS
-- ═══════════════════════════════════════════════════════════════════════════════════

INSERT INTO projects (
  title, subtitle, year, course_id, type_id, advisor_id, created_by,
  summary, description, objectives, languages, database_type,
  duration_months, work_hours, status, grade
) VALUES

-- Projecto 1: Sistema de Gestão Escolar
(
  'Sistema de Gestão de Projectos Académicos',
  'Plataforma web para centralizar e gerir projectos académicos',
  2025, 1, 1, 1, 1,
  'Desenvolvimento de uma aplicação web para gestão centralizada de projectos académicos, permitindo visualização, filtragem e consulta dos trabalhos de fim de curso.',
  'A aplicação foi desenvolvida utilizando tecnologias web modernas (PHP, JavaScript, MySQL). Permite que alunos, professores e gestores académicos tenham acesso centralizado às informações dos projectos defendidos.',
  '[\"Desenvolver interface intuitiva\", \"Implementar sistema de autenticação\", \"Criar dashboard de estatísticas\", \"Permitir visualização e filtragem de projectos\", \"Gerar relatórios e estatísticas\"]',
  'PHP, JavaScript, HTML/CSS', 'MySQL',
  3, 120, 'defended', 18.50
),

-- Projecto 2: Rede Corporativa TCP/IP
(
  'Rede Corporativa TCP/IP',
  'Implementação de rede corporativa com protocolos TCP/IP avançados',
  2025, 1, 2, 2, 1,
  'Projecto de implementação de uma rede corporativa complexa utilizando protocolos TCP/IP, com foco em segurança e performance.',
  'Análise de requisitos de rede, design da arquitetura, implementação e testes. Inclui configuração de servidores, switches, firewalls e VPN.',
  '[\"Desenhar arquitetura de rede\", \"Configurar equipamentos\", \"Implementar segurança\", \"Documentar procedimentos\"]',
  'Cisco IOS, Linux Networking', 'MySQL',
  4, 160, 'defended', 19.00
),

-- Projecto 3: App Gestão Hotelaria
(
  'Aplicação Móvel de Gestão Hotelaria',
  'App Android e iOS para operações de hotelaria',
  2025, 2, 1, 4, 1,
  'Desenvolviment de uma aplicação móvel completa para gestão de operações hoteleiras.',
  'Aplicação Android e iOS para controle de reservas, ocupação e operações de hotelaria. Interface intuitiva com sincronização em tempo real.',
  '[\"Desenvolver interface mobile\", \"Integrar sistema de reservas\", \"Implementar módulo financeiro\", \"Sincronização em tempo real\"]',
  'Java, Kotlin, Swift', 'Firebase',
  5, 200, 'defended', 19.50
),

-- Projecto 4: Sistema de Enfermagem Hospitalar
(
  'Sistema de Informação Hospitalar',
  'Sistema de gestão de pacientes e cuidados em ambiente hospitalar',
  2024, 3, 3, 3, 1,
  'Sistema integrado para gestão de pacientes, cuidados e recursos hospitalares.',
  'Desenvolvimento de plataforma para registo de pacientes, tratamentos, medicação e acompanhamento de cuidados de enfermagem.',
  '[\"Coletar requisitos médicos\", \"Desenhar fluxos de trabalho\", \"Implementar segurança HIPAA\", \"Treinar pessoal\"]',
  'C#, SQL Server, Azure', 'SQL Server',
  6, 240, 'defended', 17.50
),

-- Projecto 5: Plataforma de Contabilidade
(
  'Plataforma Integrada de Contabilidade',
  'Software de contabilidade com módulos de facturação e relatórios',
  2024, 4, 1, 5, 1,
  'Plataforma completa de contabilidade com suporte a facturação, gestão de contas, e relatórios financeiros.',
  'Sistema web para gestão contabilística de pequenas e médias empresas. Inclui módulos de facturas, recibos, livro diário e declarações.',
  '[\"Implementar contabilidade de dupla entrada\", \"Gerar relatórios financeiros\", \"Integrar com sistemas bancários\", \"Compliance fiscal\"]',
  'Python, Django, PostgreSQL', 'PostgreSQL',
  4, 160, 'defended', 18.00
),

-- Projecto 6: Segurança em Redes
(
  'Análise e Implementação de Segurança em Redes',
  'Auditoria e implementação de medidas de segurança',
  2025, 1, 5, 6, 1,
  'Projecto de análise de vulnerabilidades e implementação de soluções de segurança em redes corporativas.',
  'Realização de testes de penetração, análise de vulnerabilidades, configuração de firewalls e implementação de VPN segura.',
  '[\"Realizar testes de penetração\", \"Implementar IDS/IPS\", \"Configurar firewall avançado\", \"Documentar políticas de segurança\"]',
  'Linux, Bash, Python', 'MySQL',
  4, 160, 'in_progress', NULL
);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 5. MEMBROS DOS PROJECTOS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Projecto 1: Sistema de Gestão de Projectos
INSERT INTO project_members (project_id, user_id, role, responsibilities, is_lead) VALUES
(1, 8, 'Backend', 'Desenvolvimento de APIs PHP e lógica de negócio', TRUE),
(1, 9, 'Frontend', 'Interface web, JavaScript, CSS', FALSE),
(1, 10, 'Database', 'Design de base de dados, optimizações SQL', FALSE),
(1, 11, 'Documentation', 'Documentação do projecto e relatório final', FALSE);

-- Projecto 2: Rede Corporativa
INSERT INTO project_members (project_id, user_id, role, responsibilities, is_lead) VALUES
(2, 9, 'Network Design', 'Desenho e arquitectura de rede', TRUE),
(2, 10, 'Configuration', 'Configuração de equipamentos', FALSE),
(2, 11, 'Testing', 'Testes de segurança e performance', FALSE);

-- Projecto 3: App Hotelaria
INSERT INTO project_members (project_id, user_id, role, responsibilities, is_lead) VALUES
(3, 12, 'Project Lead', 'Gestão do projecto', TRUE),
(3, 13, 'Android Dev', 'Desenvolvimento Android', FALSE),
(3, 8, 'iOS Dev', 'Desenvolvimento iOS', FALSE);

-- Projecto 4: Sistema Hospitalar
INSERT INTO project_members (project_id, user_id, role, responsibilities, is_lead) VALUES
(4, 14, 'Lead Nurse', 'Coordenação de requisitos médicos', TRUE),
(4, 15, 'Developer', 'Desenvolvimento do sistema', FALSE);

-- Projecto 5: Plataforma Contabilidade
INSERT INTO project_members (project_id, user_id, role, responsibilities, is_lead) VALUES
(5, 16, 'Accountant Lead', 'Requisitos contabilísticos', TRUE),
(5, 11, 'Developer', 'Implementação do sistema', FALSE);

-- Projecto 6: Segurança em Redes
INSERT INTO project_members (project_id, user_id, role, responsibilities, is_lead) VALUES
(6, 9, 'Security Lead', 'Coordenação de segurança', TRUE),
(6, 10, 'Penetration Tester', 'Testes de penetração', FALSE),
(6, 11, 'Documentation', 'Relatórios de segurança', FALSE);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 6. DEFESAS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Projecto 1: Defendido em Fevereiro
INSERT INTO defenses (project_id, scheduled_date, actual_date, location, status, grade) VALUES
(1, '2025-02-20 14:00:00', '2025-02-20 14:30:00', 'Sala de Conferências A', 'completed', 18.50);

-- Projecto 2: Defendido em Fevereiro
INSERT INTO defenses (project_id, scheduled_date, actual_date, location, status, grade) VALUES
(2, '2025-02-18 10:00:00', '2025-02-18 10:45:00', 'Auditório Principal', 'completed', 19.00);

-- Projecto 3: Defendido em Fevereiro
INSERT INTO defenses (project_id, scheduled_date, actual_date, location, status, grade) VALUES
(3, '2025-02-21 15:00:00', '2025-02-21 15:30:00', 'Sala de Conferências B', 'completed', 19.50);

-- Projecto 4: Defendido em Dezembro do ano anterior
INSERT INTO defenses (project_id, scheduled_date, actual_date, location, status, grade) VALUES
(4, '2024-12-15 09:00:00', '2024-12-15 09:30:00', 'Sala de Conferências C', 'completed', 17.50);

-- Projecto 5: Defendido em Novembro
INSERT INTO defenses (project_id, scheduled_date, actual_date, location, status, grade) VALUES
(5, '2024-11-28 11:00:00', '2024-11-28 11:45:00', 'Auditório Secundário', 'completed', 18.00);

-- Projecto 6: Agendado para Março
INSERT INTO defenses (project_id, scheduled_date, actual_date, location, status, grade) VALUES
(6, '2025-03-15 14:00:00', NULL, 'Sala de Conferências D', 'scheduled', NULL);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 7. BANCA AVALIADORA
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Defesa 1: Sistema de Gestão
INSERT INTO defense_members (defense_id, user_id, role, individual_grade) VALUES
(1, 1, 'presidente', 18.5),
(1, 2, 'avaliador', 19.0),
(1, 7, 'avaliador', 18.0);

-- Defesa 2: Rede Corporativa
INSERT INTO defense_members (defense_id, user_id, role, individual_grade) VALUES
(2, 2, 'presidente', 19.0),
(2, 1, 'avaliador', 19.5),
(2, 7, 'avaliador', 18.5);

-- Defesa 3: App Hotelaria
INSERT INTO defense_members (defense_id, user_id, role, individual_grade) VALUES
(3, 4, 'presidente', 19.5),
(3, 1, 'avaliador', 20.0),
(3, 2, 'avaliador', 19.0);

-- Defesa 4: Sistema Hospitalar
INSERT INTO defense_members (defense_id, user_id, role, individual_grade) VALUES
(4, 3, 'presidente', 17.5),
(4, 1, 'avaliador', 17.0),
(4, 5, 'avaliador', 18.0);

-- Defesa 5: Contabilidade
INSERT INTO defense_members (defense_id, user_id, role, individual_grade) VALUES
(5, 5, 'presidente', 18.0),
(5, 1, 'avaliador', 18.5),
(5, 4, 'avaliador', 17.5);

-- Defesa 6: Segurança (ainda agendada)
INSERT INTO defense_members (defense_id, user_id, role) VALUES
(6, 7, 'presidente'),
(6, 2, 'avaliador'),
(6, 1, 'avaliador');

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 8. FICHEIROS DE PROJECTOS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Nota: Em ambiente real, os ficheiros devem estar no disco
-- Aqui apenas registamos os metadados

-- Projecto 1
INSERT INTO project_files (
  project_id, uploaded_by, original_filename, stored_filename, file_path,
  file_size, file_type, mime_type, description, is_primary
) VALUES
(1, 1, 'Relatorio_Final_Gestao_Projectos.pdf', '1_relatorio_gestao_projectos_20250220.pdf',
  '/uploads/1_relatorio_gestao_projectos_20250220.pdf', 2458624, 'pdf', 'application/pdf',
  'Relatório final do projecto', TRUE),
(1, 1, 'Apresentacao_Defesa.pdf', '1_apresentacao_defesa_20250220.pdf',
  '/uploads/1_apresentacao_defesa_20250220.pdf', 1572864, 'pdf', 'application/pdf',
  'Apresentação da defesa', FALSE),
(1, 1, 'Codigo_Fonte.zip', '1_codigo_fonte_20250220.zip',
  '/uploads/1_codigo_fonte_20250220.zip', 5242880, 'zip', 'application/zip',
  'Código fonte da aplicação', FALSE);

-- Projecto 2
INSERT INTO project_files (
  project_id, uploaded_by, original_filename, stored_filename, file_path,
  file_size, file_type, mime_type, description, is_primary
) VALUES
(2, 2, 'Relatorio_Rede_Corporativa.pdf', '2_relatorio_rede_corporativa_20250218.pdf',
  '/uploads/2_relatorio_rede_corporativa_20250218.pdf', 3145728, 'pdf', 'application/pdf',
  'Relatório técnico da rede', TRUE),
(2, 2, 'Diagrama_Arquitetura.pdf', '2_diagrama_arquitetura_20250218.pdf',
  '/uploads/2_diagrama_arquitetura_20250218.pdf', 892960, 'pdf', 'application/pdf',
  'Diagrama de arquitectura de rede', FALSE);

-- Projecto 3
INSERT INTO project_files (
  project_id, uploaded_by, original_filename, stored_filename, file_path,
  file_size, file_type, mime_type, description, is_primary
) VALUES
(3, 4, 'Relatorio_App_Hotelaria.pdf', '3_relatorio_app_hotelaria_20250221.pdf',
  '/uploads/3_relatorio_app_hotelaria_20250221.pdf', 4194304, 'pdf', 'application/pdf',
  'Relatório da aplicação móvel', TRUE);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- NOTAS IMPORTANTES
-- ═══════════════════════════════════════════════════════════════════════════════════
/*
1. PASSWORDS COM HASH:
   Os hashes bcrypt acima são placeholders: $2y$10$YourHashedPasswordHere...
   
   Para gerar hashes reais em PHP, execute:
   php -r "echo password_hash('admin123', PASSWORD_DEFAULT) . PHP_EOL;"
   php -r "echo password_hash('advisor123', PASSWORD_DEFAULT) . PHP_EOL;"
   php -r "echo password_hash('student123', PASSWORD_DEFAULT) . PHP_EOL;"
   
   Depois substitua na tabela users.

2. FICHEIROS:
   Os registos de ficheiros são apenas metadados. Os ficheiros reais devem ser 
   colocados em /uploads/ no servidor.
   
   Exemplo:
   /uploads/1_relatorio_gestao_projectos_20250220.pdf
   /uploads/2_relatorio_rede_corporativa_20250218.pdf
   etc.

3. DATAS:
   Defesas realizadas em fevereiro de 2025 (mês actual)
   Algumas defesas de 2024 (projectos anteriores)
   Uma defesa agendada para março (projecto em progresso)

4. MEMBROS:
   Cada projecto tem 3-4 membros com diferentes papéis
   Um membro é designado como líder (is_lead = TRUE)

5. BANCA AVALIADORA:
   Cada defesa tem um presidente e 2 avaliadores
   Algumas têm notas individuais já registadas
*/

-- ═══════════════════════════════════════════════════════════════════════════════════
