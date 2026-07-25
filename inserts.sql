-- =====================================================================
-- 1. POPULATE USERS TABLE
-- =====================================================================
INSERT INTO "users" ("name", "password_hash", "email", "username") VALUES
('Carlos Silva', hex(randomblob(8)), 'carlos@email.com', 'carlos'),
('Joao Pereira', hex(randomblob(8)), 'joao@email.com', 'joao'),
('Pedro Alves', hex(randomblob(8)), 'pedro@email.com', 'pedro'),
('Lucas Souza', hex(randomblob(8)), 'lucas@email.com', 'lucas'),
('Mateus Lima', hex(randomblob(8)), 'mateus@email.com', 'mateus'),
('Ana Costa', hex(randomblob(8)), 'ana@email.com', 'ana'),
('Fernanda Rocha', hex(randomblob(8)), 'fernanda@email.com', 'fernanda'),
('Mariana Gomes', hex(randomblob(8)), 'mariana@email.com', 'mariana'),
('Renata Dias', hex(randomblob(8)), 'renata@email.com', 'renata'),
('Beatriz Melo', hex(randomblob(8)), 'beatriz@email.com', 'beatriz');

-- =====================================================================
-- 2. POPULATE PASSWORD RESETS TABLE
-- =====================================================================
INSERT INTO "resets" ("token", "user_id", "ip", "expires") VALUES
(hex(randomblob(8)), 1, '123.1.1.1', strftime('%s', 'now', '+12 hours')),
(hex(randomblob(8)), 4, '123.1.1.2', strftime('%s', 'now', '+12 hours')),
(hex(randomblob(8)), 8, '123.1.1.3', strftime('%s', 'now', '+12 hours'));

-- =====================================================================
-- 3. POPULATE USER SESSIONS TABLE
-- =====================================================================
INSERT INTO "sessions" ("token", "user_id", "ip", "expires") VALUES
(hex(randomblob(8)), 1, '123.1.1.1', strftime('%s', 'now', '+30 days')),
(hex(randomblob(8)), 4, '123.1.1.2', strftime('%s', 'now', '+30 days')),
(hex(randomblob(8)), 8, '123.1.1.3', strftime('%s', 'now', '+30 days'));

-- =====================================================================
-- 4. POPULATE COURSES TABLE
-- =====================================================================
INSERT INTO "courses" ("slug", "title", "description", "lessons", "hours") VALUES
('html-para-iniciantes', 'HTML para Iniciantes', 'Aprenda a linguagem de marcaçao que e a base da web.', 5, 4),
('css-animacoes', 'CSS Animacoes', 'Domine transicoes, transforms e keyframes.', 3, 8),
('javascript-completo', 'JavaScript Completo', 'Sintaxe, DOM, ES modules, APIs Web e Async/Await.', 4, 25),
('sqlite-fundamentos', 'SQLite Fundamentos', 'Aprenda create table, insert, select e mais.', 5, 12);

-- =====================================================================
-- 5. POPULATE LESSONS TABLE
-- =====================================================================
INSERT INTO "lessons" (
  "course_id", "slug", "title", "materia", "materia_slug", 
  "seconds", "video", "description", "order", "free"
) VALUES
-- Course 1: HTML
(1, 'introducao-ao-html', 'Introducao ao HTML', 'Fundamentos', 'fundamentos', 300, 'html01.mp4', 'Visao geral do curso', 1, 1),
(1, 'tags-basicas', 'Tags Basicas', 'Fundamentos', 'fundamentos', 420, 'html02.mp4', 'Uso das principais tags', 2, 0),
(1, 'atributos-e-semantica', 'Atributos e Semantica', 'Fundamentos', 'fundamentos', 360, 'html03.mp4', 'Atributos globais', 3, 0),
(1, 'imagens-e-links', 'Imagens e Links', 'Multimidia', 'multimidia', 480, 'html04.mp4', 'Inserindo imagens e links', 4, 0),
(1, 'conclusao', 'Conclusao', 'Estrutura', 'estrutura', 540, 'html05.mp4', 'Criando tabelas acessiveis', 5, 0),

-- Course 2: CSS
(2, 'transicoes-css', 'Transicoes CSS', 'Fundamentos', 'fundamentos', 360, 'css01.mp4', 'Introducao as propriedades', 1, 1),
(2, 'transforms-2d-e-3d', 'Transforms 2D e 3D', 'Fundamentos', 'fundamentos', 420, 'css02.mp4', 'Aplicando transforms', 2, 0),
(2, 'keyframes-na-pratica', '@keyframes na pratica', 'Animacoes', 'animacoes', 480, 'css03.mp4', 'Criando animacoes', 3, 0),

-- Course 3: JavaScript
(3, 'variaveis-e-tipos', 'Variaveis e Tipos', 'Fundamentos', 'fundamentos', 420, 'js02.mp4', 'let, const, tipos de dados', 1, 1),
(3, 'funcoes-e-escopo', 'Funcoes e Escopo', 'Fundamentos', 'fundamentos', 480, 'js03.mp4', 'Declaracao, arrow functions', 2, 0),
(3, 'dom-manipulation', 'DOM Manipulation', 'DOM', 'dom', 540, 'js04.mp4', 'Selecionando elementos', 3, 0),
(3, 'fetch-api', 'Fetch API', 'Async', 'async', 600, 'js05.mp4', 'Requisicoes assincronas', 4, 0),

-- Course 4: SQLite
(4, 'introducao-ao-sqlite', 'Introducao ao SQLite', 'Fundamentos', 'fundamentos', 300, 'sqlite01.mp4', 'O que e SQLite', 1, 1),
(4, 'criacao-de-tabelas', 'Criacao de Tabelas', 'DDL', 'ddl', 420, 'sqlite02.mp4', 'Sintaxe CREATE TABLE', 2, 0),
(4, 'select-e-where', 'SELECT e WHERE', 'DML', 'dml', 480, 'sqlite03.mp4', 'Consultas basicas e filtros.', 3, 0),
(4, 'insert-update-delete', 'INSERT, UPDATE, DELETE', 'DML', 'dml', 540, 'sqlite04.mp4', 'Manipulacao de dados', 4, 0),
(4, 'indices-e-otimizacao', 'Indices e Otimizacao', 'Performance', 'performance', 600, 'sqlite05.mp4', 'Criacao e consultas', 5, 0);

-- =====================================================================
-- 6. POPULATE COMPLETED LESSONS (EXACTLY 85 ENTRIES)
-- =====================================================================
INSERT INTO "lessons_completed" ("user_id", "course_id", "lesson_id") VALUES
-- User 1 (Carlos Silva) - Completed all 17 lessons (17)
(1, 1, 1), (1, 1, 2), (1, 1, 3), (1, 1, 4), (1, 1, 5), (1, 2, 6), (1, 2, 7), (1, 2, 8), (1, 3, 9), (1, 3, 10), (1, 3, 11), (1, 3, 12), (1, 4, 13), (1, 4, 14), (1, 4, 15), (1, 4, 16), (1, 4, 17),

-- User 2 (Joao Pereira) - Completed all 17 lessons (17) -> Cumulative: 34
(2, 1, 1), (2, 1, 2), (2, 1, 3), (2, 1, 4), (2, 1, 5), (2, 2, 6), (2, 2, 7), (2, 2, 8), (2, 3, 9), (2, 3, 10), (2, 3, 11), (2, 3, 12), (2, 4, 13), (2, 4, 14), (2, 4, 15), (2, 4, 16), (2, 4, 17),

-- User 3 (Pedro Alves) - Completed all 17 lessons (17) -> Cumulative: 51
(3, 1, 1), (3, 1, 2), (3, 1, 3), (3, 1, 4), (3, 1, 5), (3, 2, 6), (3, 2, 7), (3, 2, 8), (3, 3, 9), (3, 3, 10), (3, 3, 11), (3, 3, 12), (3, 4, 13), (3, 4, 14), (3, 4, 15), (3, 4, 16), (3, 4, 17),

-- User 4 (Lucas Souza) - Completed all 17 lessons (17) -> Cumulative: 68
(4, 1, 1), (4, 1, 2), (4, 1, 3), (4, 1, 4), (4, 1, 5), (4, 2, 6), (4, 2, 7), (4, 2, 8), (4, 3, 9), (4, 3, 10), (4, 3, 11), (4, 3, 12), (4, 4, 13), (4, 4, 14), (4, 4, 15), (4, 4, 16), (4, 4, 17),

-- User 8 (Mariana Gomes) - Custom adjusted history (9) -> Cumulative: 77
(8, 3, 9), (8, 3, 10), (8, 3, 11), (8, 3, 12), (8, 4, 13), (8, 4, 14), (8, 4, 15), (8, 4, 16), (8, 4, 17),

-- User 5 (Mateus Lima) - Completed 8 lessons to complete the total (8) -> Exact Total: 85
(5, 1, 1), (5, 1, 2), (5, 1, 3), (5, 1, 4), (5, 1, 5), (5, 2, 6), (5, 2, 7), (5, 2, 8);

-- =====================================================================
-- 7. POPULATE CERTIFICATES TABLE
-- =====================================================================
INSERT INTO "certificates" ("user_id", "course_id") VALUES
-- Carlos (User 1) - Completed all 4 courses
(1, 1), (1, 2), (1, 3), (1, 4),

-- João (User 2) - Completed all 4 courses
(2, 1), (2, 2), (2, 3), (2, 4),

-- Pedro (User 3) - Completed all 4 courses
(3, 1), (3, 2), (3, 3), (3, 4),

-- Lucas (User 4) - Completed all 4 courses
(4, 1), (4, 2), (4, 3), (4, 4),

-- Mateus (User 5) - Completed HTML (1) and CSS (2)
(5, 1), (5, 2),

-- Mariana (User 8) - Completed JavaScript (3) and SQLite (4)
(8, 3), (8, 4);