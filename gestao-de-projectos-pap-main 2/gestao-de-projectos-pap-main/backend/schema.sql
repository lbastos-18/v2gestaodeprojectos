-- ═══════════════════════════════════════════════════════════════════════════════════
-- Database Schema: Gestão de Projectos Académicos
-- Version: 2.0 (Expandido com relações completas e constraints)
-- Character Set: UTF-8 MB4 (suporta emojis e caracteres especiais)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS gestao_projects CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestao_projects;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: cursos (Cursos)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS cursos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL UNIQUE,
  descricao TEXT,
  codigo VARCHAR(50),
  departamento VARCHAR(255),
  esta_ativo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  KEY idx_nome (nome),
  KEY idx_ativo (esta_ativo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: tipos_projecto (Tipos de Projecto)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS tipos_projecto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL UNIQUE,
  descricao TEXT,
  icone VARCHAR(50),
  esta_ativo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  KEY idx_nome (nome),
  KEY idx_ativo (esta_ativo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: utilizadores (Utilizadores: Admin, Orientadores, Alunos)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS utilizadores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  hash_senha VARCHAR(255) NOT NULL,
  telefone VARCHAR(20),
  departamento VARCHAR(255),
  biografia TEXT,
  
  -- Papéis: admin, orientador, aluno
  papel ENUM('admin', 'orientador', 'aluno') NOT NULL DEFAULT 'aluno',
  
  -- Estado da conta
  esta_ativo BOOLEAN DEFAULT TRUE,
  email_verificado BOOLEAN DEFAULT FALSE,
  
  -- Auditoria
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  ultimo_acesso TIMESTAMP NULL,
  
  -- Índices para performance
  KEY idx_email (email),
  KEY idx_papel (papel),
  KEY idx_ativo (esta_ativo),
  KEY idx_criado_em (criado_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: projectos (Projectos Académicos)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS projectos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
  -- Informações básicas
  titulo VARCHAR(255) NOT NULL,
  subtitulo VARCHAR(255),
  ano INT NOT NULL,
  
  -- Relações (Foreign Keys)
  curso_id INT NOT NULL,
  tipo_id INT NOT NULL,
  orientador_id INT,  -- Orientador principal (pode ser NULL)
  criado_por INT NOT NULL,  -- Quem criou o registo
  
  -- Descrição e conteúdo
  resumo TEXT,  -- Resumo curto
  descricao LONGTEXT,  -- Descrição completa
  objectivos TEXT,  -- JSON array com objectivos
  
  -- Tecnologias e detalhes técnicos
  linguagens VARCHAR(255),  -- Ex: "PHP, JavaScript, MySQL"
  tipo_bd VARCHAR(100),  -- Ex: "MySQL", "Firebase"
  
  -- Estatísticas do projecto
  duracao_meses INT,
  horas_trabalho INT,
  
  -- Classificação e estado
  estado ENUM('planeamento', 'em_progresso', 'completo', 'defendido', 'arquivado') 
         DEFAULT 'planeamento',
  nota DECIMAL(5, 2),  -- Classificação final (0-20)
  
  -- Auditoria
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  apagado BOOLEAN DEFAULT FALSE,
  
  -- Constraints
  CONSTRAINT fk_projectos_curso FOREIGN KEY (curso_id) 
    REFERENCES cursos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_projectos_tipo FOREIGN KEY (tipo_id) 
    REFERENCES tipos_projecto(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_projectos_orientador FOREIGN KEY (orientador_id) 
    REFERENCES utilizadores(id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_projectos_criado_por FOREIGN KEY (criado_por) 
    REFERENCES utilizadores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  
  -- Constraints de validação
  CONSTRAINT check_ano CHECK (ano BETWEEN 2000 AND 2100),
  CONSTRAINT check_nota CHECK (nota IS NULL OR (nota >= 0 AND nota <= 20)),
  CONSTRAINT check_duracao CHECK (duracao_meses IS NULL OR duracao_meses > 0),
  CONSTRAINT check_horas_trabalho CHECK (horas_trabalho IS NULL OR horas_trabalho > 0),
  
  -- Índices para performance
  KEY idx_curso_id (curso_id),
  KEY idx_tipo_id (tipo_id),
  KEY idx_orientador_id (orientador_id),
  KEY idx_criado_por (criado_por),
  KEY idx_ano (ano),
  KEY idx_estado (estado),
  KEY idx_criado_em (criado_em),
  KEY idx_apagado (apagado),
  KEY idx_ano_curso (ano, curso_id),
  FULLTEXT KEY ft_titulo_resumo (titulo, resumo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: membros_projecto (Membros do Projecto)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS membros_projecto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
  projecto_id INT NOT NULL,
  utilizador_id INT NOT NULL,
  
  -- Papel do membro (Backend, Frontend, Database, Documentação, etc)
  papel VARCHAR(100),
  
  -- Descrição das responsabilidades
  responsabilidades TEXT,
  
  -- Indicador se é líder do projecto
  e_lider BOOLEAN DEFAULT FALSE,
  
  -- Auditoria
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Constraints
  CONSTRAINT fk_membros_projecto_projecto FOREIGN KEY (projecto_id) 
    REFERENCES projectos(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_membros_projecto_utilizador FOREIGN KEY (utilizador_id) 
    REFERENCES utilizadores(id) ON DELETE CASCADE ON UPDATE CASCADE,
  
  -- Um utilizador não pode ser membro duas vezes do mesmo projecto
  UNIQUE KEY unico_membro_projecto (projecto_id, utilizador_id),
  
  -- Índices
  KEY idx_projecto_id (projecto_id),
  KEY idx_utilizador_id (utilizador_id),
  KEY idx_e_lider (e_lider)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: ficheiros_projecto (Ficheiros do Projecto)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS ficheiros_projecto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
  projecto_id INT NOT NULL,
  enviado_por INT NOT NULL,
  
  -- Informações do ficheiro
  nome_original_ficheiro VARCHAR(255) NOT NULL,
  nome_armazenado_ficheiro VARCHAR(255) NOT NULL,  -- Nome sanitizado no servidor
  caminho_ficheiro VARCHAR(500) NOT NULL,  -- Caminho relativo
  tamanho_ficheiro BIGINT NOT NULL,  -- Tamanho em bytes
  tipo_ficheiro VARCHAR(50),  -- Extensão: pdf, doc, zip, etc
  tipo_mime VARCHAR(100),  -- MIME type para validação
  
  -- Metadados
  descricao TEXT,
  versao INT DEFAULT 1,
  e_primario BOOLEAN DEFAULT FALSE,  -- Ficheiro principal (ex: relatório final)
  
  -- Auditoria
  enviado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  apagado BOOLEAN DEFAULT FALSE,
  
  -- Constraints
  CONSTRAINT fk_ficheiros_projecto_projecto FOREIGN KEY (projecto_id) 
    REFERENCES projectos(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ficheiros_projecto_enviado_por FOREIGN KEY (enviado_por) 
    REFERENCES utilizadores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  
  CONSTRAINT check_tamanho_ficheiro CHECK (tamanho_ficheiro > 0),
  
  -- Índices
  KEY idx_projecto_id (projecto_id),
  KEY idx_enviado_por (enviado_por),
  KEY idx_tipo_ficheiro (tipo_ficheiro),
  KEY idx_enviado_em (enviado_em),
  KEY idx_apagado (apagado),
  KEY idx_e_primario (e_primario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: defesas (Defesas/Apresentações)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS defesas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
  projecto_id INT NOT NULL UNIQUE,  -- Um projecto tem uma defesa
  
  -- Datas
  data_agendada DATETIME,  -- Quando está agendada
  data_real DATETIME,  -- Quando foi de facto realizada
  
  -- Local e detalhes
  local VARCHAR(255),
  notas TEXT,
  
  -- Resultados
  nota DECIMAL(5, 2),  -- Nota da defesa (0-20)
  estado ENUM('agendada', 'concluida', 'adiada', 'cancelada') DEFAULT 'agendada',
  
  -- Auditoria
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Constraints
  CONSTRAINT fk_defesas_projecto FOREIGN KEY (projecto_id) 
    REFERENCES projectos(id) ON DELETE CASCADE ON UPDATE CASCADE,
  
  CONSTRAINT check_nota_defesa CHECK (nota IS NULL OR (nota >= 0 AND nota <= 20)),
  
  -- Índices
  KEY idx_projecto_id (projecto_id),
  KEY idx_data_agendada (data_agendada),
  KEY idx_data_real (data_real),
  KEY idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: membros_banca (Membros da Banca Avaliadora)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS membros_banca (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
  defesa_id INT NOT NULL,
  utilizador_id INT NOT NULL,  -- Avaliador/presidente de banca
  
  -- Papel na banca: presidente, avaliador1, avaliador2, etc
  papel VARCHAR(100) NOT NULL DEFAULT 'avaliador',
  
  -- Nota individual (opcional)
  nota_individual DECIMAL(5, 2),
  
  -- Auditoria
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Constraints
  CONSTRAINT fk_membros_banca_defesa FOREIGN KEY (defesa_id) 
    REFERENCES defesas(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_membros_banca_utilizador FOREIGN KEY (utilizador_id) 
    REFERENCES utilizadores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  
  -- Um avaliador não pode ser designado duas vezes para a mesma defesa
  UNIQUE KEY unico_membro_banca (defesa_id, utilizador_id),
  
  CONSTRAINT check_nota_individual CHECK (nota_individual IS NULL OR (nota_individual >= 0 AND nota_individual <= 20)),
  
  -- Índices
  KEY idx_defesa_id (defesa_id),
  KEY idx_utilizador_id (utilizador_id),
  KEY idx_papel (papel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TABELA: log_auditoria (Log de auditoria - opcional para compliance)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS log_auditoria (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
  utilizador_id INT,  -- Utilizador que fez a ação
  acao VARCHAR(100) NOT NULL,  -- Ex: 'CRIAR', 'ACTUALIZAR', 'APAGAR'
  tipo_entidade VARCHAR(100),  -- Ex: 'projecto', 'utilizador', 'defesa'
  id_entidade INT,
  
  valores_antigos JSON,  -- Valores anteriores (para updates)
  valores_novos JSON,  -- Novos valores
  endereco_ip VARCHAR(45),  -- IPv4 ou IPv6
  
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Constraints
  CONSTRAINT fk_log_auditoria_utilizador FOREIGN KEY (utilizador_id) 
    REFERENCES utilizadores(id) ON DELETE SET NULL ON UPDATE CASCADE,
  
  -- Índices
  KEY idx_utilizador_id (utilizador_id),
  KEY idx_tipo_entidade (tipo_entidade),
  KEY idx_criado_em (criado_em),
  KEY idx_acao (acao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- TRIGGERS (Integridade de Dados)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Trigger: Actualizar actualizado_em em utilizadores
DELIMITER //
CREATE TRIGGER actualizar_timestamp_utilizadores BEFORE UPDATE ON utilizadores
  FOR EACH ROW
  BEGIN
    SET NEW.actualizado_em = CURRENT_TIMESTAMP;
  END //
DELIMITER ;

-- Trigger: Actualizar actualizado_em em projectos
DELIMITER //
CREATE TRIGGER actualizar_timestamp_projectos BEFORE UPDATE ON projectos
  FOR EACH ROW
  BEGIN
    SET NEW.actualizado_em = CURRENT_TIMESTAMP;
  END //
DELIMITER ;

-- Trigger: Actualizar actualizado_em em membros_projecto
DELIMITER //
CREATE TRIGGER actualizar_timestamp_membros_projecto BEFORE UPDATE ON membros_projecto
  FOR EACH ROW
  BEGIN
    SET NEW.actualizado_em = CURRENT_TIMESTAMP;
  END //
DELIMITER ;

-- Trigger: Actualizar actualizado_em em defesas
DELIMITER //
CREATE TRIGGER actualizar_timestamp_defesas BEFORE UPDATE ON defesas
  FOR EACH ROW
  BEGIN
    SET NEW.actualizado_em = CURRENT_TIMESTAMP;
  END //
DELIMITER ;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- VIEWS (Queries pré-compiladas para simplificar)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- View: Projectos com informações completas
CREATE OR REPLACE VIEW v_projectos_detalhados AS
SELECT 
  p.id,
  p.titulo,
  p.subtitulo,
  p.ano,
  c.nome as nome_curso,
  pt.nome as nome_tipo,
  u.nome as nome_orientador,
  u.email as email_orientador,
  COUNT(DISTINCT mp.id) as quantidade_membros,
  COUNT(DISTINCT fp.id) as quantidade_ficheiros,
  p.estado,
  p.nota,
  p.criado_em,
  COALESCE(d.nota, NULL) as nota_defesa,
  COALESCE(d.estado, 'pendente') as estado_defesa
FROM projectos p
LEFT JOIN cursos c ON p.curso_id = c.id
LEFT JOIN tipos_projecto pt ON p.tipo_id = pt.id
LEFT JOIN utilizadores u ON p.orientador_id = u.id
LEFT JOIN membros_projecto mp ON p.id = mp.projecto_id
LEFT JOIN ficheiros_projecto fp ON p.id = fp.projecto_id AND fp.apagado = FALSE
LEFT JOIN defesas d ON p.id = d.projecto_id
WHERE p.apagado = FALSE
GROUP BY p.id;

-- View: Estatísticas por curso
CREATE OR REPLACE VIEW v_estatisticas_por_curso AS
SELECT 
  c.id,
  c.nome as nome_curso,
  COUNT(DISTINCT p.id) as total_projectos,
  COUNT(DISTINCT CASE WHEN p.estado = 'defendido' THEN p.id END) as projectos_defendidos,
  AVG(d.nota) as nota_media,
  MAX(p.criado_em) as data_ultimo_projecto
FROM cursos c
LEFT JOIN projectos p ON c.id = p.curso_id AND p.apagado = FALSE
LEFT JOIN defesas d ON p.id = d.projecto_id AND d.estado = 'concluida'
WHERE c.esta_ativo = TRUE
GROUP BY c.id;

-- View: Projectos defendidos este ano
CREATE OR REPLACE VIEW v_projectos_defendidos_este_ano AS
SELECT 
  p.id,
  p.titulo,
  p.ano,
  c.nome as nome_curso,
  u.nome as nome_orientador,
  d.data_real as data_defesa,
  d.nota as nota_final,
  COUNT(DISTINCT mp.id) as quantidade_membros
FROM projectos p
INNER JOIN defesas d ON p.id = d.projecto_id AND d.estado = 'concluida'
LEFT JOIN cursos c ON p.curso_id = c.id
LEFT JOIN utilizadores u ON p.orientador_id = u.id
LEFT JOIN membros_projecto mp ON p.id = mp.projecto_id
WHERE p.apagado = FALSE 
  AND YEAR(d.data_real) = YEAR(NOW())
GROUP BY p.id
ORDER BY d.data_real DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- FIM DO SCHEMA
-- ═══════════════════════════════════════════════════════════════════════════════════
