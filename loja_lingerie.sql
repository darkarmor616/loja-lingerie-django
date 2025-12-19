-- ============================================
-- SISTEMA DE GESTÃO - LOJA DE LINGERIE
-- ============================================

-- ============================================
-- PARTE 1: DDL (Data Definition Language)
-- Criação do Banco de Dados e Tabelas
-- ============================================

DROP DATABASE IF EXISTS loja_lingerie;
CREATE DATABASE loja_lingerie CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE loja_lingerie;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL,
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_fornecedor VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    id_fornecedor INT NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    descricao TEXT,
    marca VARCHAR(50),
    preco_custo DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    margem_lucro DECIMAL(5,2) GENERATED ALWAYS AS (((preco_venda - preco_custo) / preco_custo) * 100) STORED,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
) ENGINE=InnoDB;

CREATE TABLE estoque (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    tamanho VARCHAR(10) NOT NULL,
    cor VARCHAR(30) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    estoque_minimo INT DEFAULT 5,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
    UNIQUE KEY unique_produto_tamanho_cor (id_produto, tamanho, cor)
) ENGINE=InnoDB;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    data_nascimento DATE,
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_subtotal DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM('Dinheiro', 'Débito', 'Crédito', 'PIX', 'Boleto') NOT NULL,
    status_venda ENUM('Concluída', 'Cancelada', 'Pendente') DEFAULT 'Concluída',
    observacoes TEXT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
) ENGINE=InnoDB;

CREATE TABLE itens_venda (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_estoque INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda) ON DELETE CASCADE,
    FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque)
) ENGINE=InnoDB;

CREATE TABLE compras (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status_compra ENUM('Pendente', 'Recebida', 'Cancelada') DEFAULT 'Pendente',
    data_recebimento DATE,
    observacoes TEXT,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
) ENGINE=InnoDB;

CREATE TABLE itens_compra (
    id_item_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_produto INT NOT NULL,
    tamanho VARCHAR(10) NOT NULL,
    cor VARCHAR(30) NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (id_compra) REFERENCES compras(id_compra) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

-- ============================================
-- PARTE 2: DML (Data Manipulation Language)
-- População de Dados
-- ============================================

INSERT INTO categorias (nome_categoria, descricao) VALUES
('Sutiãs', 'Sutiãs de diversos modelos e tamanhos'),
('Calcinhas', 'Calcinhas confortáveis e elegantes'),
('Conjuntos', 'Conjuntos de lingerie completos'),
('Camisolas', 'Camisolas e baby dolls'),
('Bodies', 'Bodies sensuais e confortáveis'),
('Pijamas', 'Pijamas femininos'),
('Acessórios', 'Meias, ligas e outros acessórios');

INSERT INTO fornecedores (nome_fornecedor, cnpj, email, telefone, endereco, cidade, estado, cep) VALUES
('Valisere Distribuidora', '12.345.678/0001-90', 'contato@valisere.com.br', '(11) 3456-7890', 'Rua das Flores, 100', 'São Paulo', 'SP', '01234-567'),
('Hope Lingerie Ltda', '23.456.789/0001-12', 'vendas@hope.com.br', '(11) 3567-8901', 'Av. Paulista, 500', 'São Paulo', 'SP', '01310-100'),
('Triumph Importadora', '34.567.890/0001-34', 'comercial@triumph.com.br', '(21) 2678-9012', 'Rua Bela, 250', 'Rio de Janeiro', 'RJ', '20040-020'),
('Lupo Atacado', '45.678.901/0001-56', 'atacado@lupo.com.br', '(19) 3789-0123', 'Av. Industrial, 1000', 'Araraquara', 'SP', '14800-000'),
('Zee Rucci Textil', '56.789.012/0001-78', 'pedidos@zeerucci.com.br', '(11) 3890-1234', 'Rua Conforto, 75', 'São Paulo', 'SP', '03456-789');

INSERT INTO produtos (id_categoria, id_fornecedor, nome_produto, descricao, marca, preco_custo, preco_venda) VALUES
(1, 1, 'Sutiã Meia Taça Renda', 'Sutiã com meia taça e detalhes em renda', 'Valisere', 35.00, 89.90),
(1, 2, 'Sutiã Push-up Liso', 'Sutiã push-up sem costura', 'Hope', 42.00, 109.90),
(1, 3, 'Sutiã Esportivo Conforto', 'Sutiã esportivo com alta sustentação', 'Triumph', 38.00, 95.00),
(1, 4, 'Sutiã Tomara que Caia', 'Sutiã sem alças com bojo', 'Lupo', 45.00, 119.90),
(2, 1, 'Calcinha Fio Dental Renda', 'Calcinha fio dental com renda delicada', 'Valisere', 15.00, 39.90),
(2, 2, 'Calcinha Cintura Alta', 'Calcinha de cintura alta modeladora', 'Hope', 18.00, 49.90),
(2, 4, 'Calcinha Sem Costura', 'Calcinha sem costura invisível', 'Lupo', 12.00, 35.00),
(2, 5, 'Calcinha Boyshort', 'Calcinha estilo boyshort confortável', 'Zee Rucci', 16.00, 42.90),
(3, 1, 'Conjunto Renda Floral', 'Conjunto com sutiã e calcinha em renda floral', 'Valisere', 65.00, 159.90),
(3, 2, 'Conjunto Strappy Sensual', 'Conjunto com detalhes em tiras', 'Hope', 72.00, 189.90),
(3, 3, 'Conjunto Básico Algodão', 'Conjunto básico em algodão', 'Triumph', 48.00, 119.90),
(4, 5, 'Camisola Cetim Curta', 'Camisola curta em cetim', 'Zee Rucci', 35.00, 89.90),
(4, 1, 'Baby Doll Renda', 'Baby doll com renda e laço', 'Valisere', 42.00, 109.90),
(4, 2, 'Camisola Longa Confort', 'Camisola longa para dormir', 'Hope', 38.00, 95.00),
(5, 2, 'Body Rendado Decote V', 'Body com decote V e renda', 'Hope', 52.00, 139.90),
(5, 3, 'Body Cavado Liso', 'Body cavado sem costura', 'Triumph', 48.00, 129.90);

INSERT INTO estoque (id_produto, tamanho, cor, quantidade, estoque_minimo) VALUES
(1, '38', 'Preto', 15, 5),
(1, '40', 'Preto', 20, 5),
(1, '42', 'Preto', 12, 5),
(1, '38', 'Nude', 18, 5),
(1, '40', 'Nude', 22, 5),
(1, '42', 'Nude', 10, 5),
(1, '40', 'Vermelho', 15, 3),
(2, '38', 'Branco', 25, 5),
(2, '40', 'Branco', 30, 5),
(2, '42', 'Branco', 18, 5),
(2, '38', 'Rosa', 20, 5),
(2, '40', 'Rosa', 25, 5),
(3, 'P', 'Preto', 30, 8),
(3, 'M', 'Preto', 35, 8),
(3, 'G', 'Preto', 25, 8),
(3, 'M', 'Cinza', 28, 8),
(5, 'P', 'Preto', 40, 10),
(5, 'M', 'Preto', 50, 10),
(5, 'G', 'Preto', 35, 10),
(5, 'P', 'Nude', 38, 10),
(5, 'M', 'Nude', 45, 10),
(5, 'G', 'Nude', 32, 10),
(6, 'P', 'Preto', 35, 8),
(6, 'M', 'Preto', 42, 8),
(6, 'G', 'Preto', 30, 8),
(6, 'M', 'Bege', 38, 8),
(7, 'P', 'Nude', 45, 10),
(7, 'M', 'Nude', 55, 10),
(7, 'G', 'Nude', 40, 10),
(7, 'M', 'Branco', 48, 10),
(9, '38', 'Vermelho', 12, 3),
(9, '40', 'Vermelho', 15, 3),
(9, '42', 'Vermelho', 10, 3),
(9, '40', 'Preto', 18, 3),
(10, '38', 'Preto', 10, 3),
(10, '40', 'Preto', 14, 3),
(10, '42', 'Preto', 8, 3),
(12, 'P', 'Rosa', 20, 5),
(12, 'M', 'Rosa', 25, 5),
(12, 'G', 'Rosa', 18, 5),
(12, 'M', 'Azul', 22, 5),
(13, 'M', 'Branco', 15, 4),
(13, 'M', 'Rosa', 18, 4),
(15, 'P', 'Preto', 12, 4),
(15, 'M', 'Preto', 16, 4),
(15, 'G', 'Preto', 10, 4),
(15, 'M', 'Vermelho', 14, 4);

INSERT INTO clientes (nome_cliente, cpf, email, telefone, data_nascimento, endereco, cidade, estado, cep) VALUES
('Maria Silva Santos', '123.456.789-01', 'maria.silva@email.com', '(11) 98765-4321', '1990-05-15', 'Rua das Acácias, 123', 'São Paulo', 'SP', '01234-567'),
('Ana Paula Oliveira', '234.567.890-12', 'ana.oliveira@email.com', '(11) 97654-3210', '1985-08-22', 'Av. Primavera, 456', 'São Paulo', 'SP', '02345-678'),
('Juliana Costa Ferreira', '345.678.901-23', 'juliana.costa@email.com', '(11) 96543-2109', '1992-11-30', 'Rua Flores, 789', 'Guarulhos', 'SP', '03456-789'),
('Carla Mendes Rodrigues', '456.789.012-34', 'carla.mendes@email.com', '(11) 95432-1098', '1988-03-18', 'Av. Brasil, 321', 'São Paulo', 'SP', '04567-890'),
('Beatriz Lima Souza', '567.890.123-45', 'beatriz.lima@email.com', '(11) 94321-0987', '1995-07-25', 'Rua Esperança, 654', 'Osasco', 'SP', '05678-901'),
('Fernanda Alves Martins', '678.901.234-56', 'fernanda.alves@email.com', '(11) 93210-9876', '1987-12-10', 'Av. Liberdade, 987', 'São Paulo', 'SP', '06789-012'),
('Patricia Santos Cruz', '789.012.345-67', 'patricia.cruz@email.com', '(11) 92109-8765', '1991-04-05', 'Rua Alegria, 147', 'São Paulo', 'SP', '07890-123'),
('Camila Rodrigues Dias', '890.123.456-78', NULL, '(11) 91098-7654', '1993-09-28', 'Av. Paulista, 258', 'São Paulo', 'SP', '08901-234'),
('Renata Ferreira Gomes', '901.234.567-89', 'renata.gomes@email.com', '(11) 90987-6543', '1989-06-14', 'Rua Vitória, 369', 'São Caetano', 'SP', '09012-345'),
('Luciana Pereira Silva', '012.345.678-90', 'luciana.pereira@email.com', '(11) 89876-5432', '1994-01-20', 'Av. dos Estados, 741', 'Santo André', 'SP', '09123-456');

INSERT INTO vendas (id_cliente, data_venda, valor_subtotal, desconto, valor_total, forma_pagamento, status_venda) VALUES
(1, '2025-11-15 10:30:00', 179.80, 0.00, 179.80, 'Crédito', 'Concluída'),
(2, '2025-11-16 14:20:00', 159.90, 15.99, 143.91, 'PIX', 'Concluída'),
(3, '2025-11-18 11:45:00', 89.90, 0.00, 89.90, 'Débito', 'Concluída'),
(1, '2025-11-20 16:10:00', 249.80, 24.98, 224.82, 'Crédito', 'Concluída'),
(4, '2025-11-22 09:30:00', 139.90, 0.00, 139.90, 'Dinheiro', 'Concluída'),
(5, '2025-11-23 15:50:00', 299.70, 29.97, 269.73, 'Crédito', 'Concluída'),
(6, '2025-11-25 13:20:00', 189.90, 0.00, 189.90, 'PIX', 'Concluída'),
(2, '2025-11-27 10:15:00', 109.90, 0.00, 109.90, 'Débito', 'Concluída'),
(7, '2025-11-28 17:30:00', 329.70, 32.97, 296.73, 'Crédito', 'Concluída'),
(8, '2025-11-29 12:40:00', 95.00, 0.00, 95.00, 'PIX', 'Concluída'),
(3, '2025-12-01 11:00:00', 219.80, 0.00, 219.80, 'Crédito', 'Concluída'),
(9, '2025-12-02 14:25:00', 159.90, 15.99, 143.91, 'Débito', 'Concluída'),
(10, '2025-12-03 16:45:00', 279.80, 0.00, 279.80, 'Crédito', 'Concluída'),
(4, '2025-12-04 10:20:00', 129.90, 0.00, 129.90, 'PIX', 'Concluída'),
(5, '2025-12-05 15:10:00', 399.60, 39.96, 359.64, 'Crédito', 'Concluída');

INSERT INTO itens_venda (id_venda, id_estoque, quantidade, preco_unitario) VALUES
(1, 1, 1, 89.90),
(1, 17, 2, 39.90),
(2, 31, 1, 159.90),
(3, 11, 1, 89.90),
(4, 2, 1, 89.90),
(4, 31, 1, 159.90),
(5, 44, 1, 139.90),
(6, 8, 1, 109.90),
(6, 31, 1, 159.90),
(6, 17, 1, 39.90),
(7, 35, 1, 189.90),
(8, 12, 1, 109.90),
(9, 31, 1, 159.90),
(9, 2, 1, 89.90),
(9, 18, 2, 39.90),
(10, 16, 1, 95.00),
(11, 44, 1, 139.90),
(11, 18, 2, 39.90),
(12, 31, 1, 159.90),
(13, 44, 2, 139.90),
(14, 45, 1, 129.90),
(15, 35, 1, 189.90),
(15, 31, 1, 159.90),
(15, 17, 1, 49.80);

INSERT INTO compras (id_fornecedor, data_compra, valor_total, status_compra, data_recebimento) VALUES
(1, '2025-10-01 10:00:00', 5500.00, 'Recebida', '2025-10-08'),
(2, '2025-10-15 14:30:00', 4200.00, 'Recebida', '2025-10-22'),
(3, '2025-11-01 09:15:00', 3800.00, 'Recebida', '2025-11-10'),
(4, '2025-11-15 11:20:00', 2400.00, 'Recebida', '2025-11-22'),
(5, '2025-11-28 15:45:00', 3500.00, 'Pendente', NULL);

INSERT INTO itens_compra (id_compra, id_produto, tamanho, cor, quantidade, preco_unitario) VALUES
(1, 1, '38', 'Preto', 20, 35.00),
(1, 1, '40', 'Preto', 25, 35.00),
(1, 1, '40', 'Nude', 30, 35.00),
(1, 5, 'P', 'Preto', 50, 15.00),
(1, 5, 'M', 'Preto', 60, 15.00),
(2, 2, '38', 'Branco', 30, 42.00),
(2, 2, '40', 'Branco', 35, 42.00),
(2, 2, '38', 'Rosa', 25, 42.00),
(2, 10, '38', 'Preto', 15, 72.00),
(3, 3, 'P', 'Preto', 35, 38.00),
(3, 3, 'M', 'Preto', 40, 38.00),
(3, 3, 'G', 'Preto', 30, 38.00),
(4, 7, 'P', 'Nude', 50, 12.00),
(4, 7, 'M', 'Nude', 60, 12.00),
(4, 7, 'G', 'Nude', 45, 12.00),
(5, 12, 'P', 'Rosa', 25, 35.00),
(5, 12, 'M', 'Rosa', 30, 35.00),
(5, 12, 'G', 'Rosa', 20, 35.00);

-- ============================================
-- PARTE 3: DQL (Data Query Language)
-- Consultas para Visualização de Dados
-- ============================================

SELECT 'Listando todas as categorias' AS Consulta;
SELECT * FROM categorias;

SELECT 'Listando todos os fornecedores' AS Consulta;
SELECT * FROM fornecedores;

SELECT 'Listando produtos com categoria e fornecedor' AS Consulta;
SELECT 
    p.id_produto,
    p.nome_produto,
    c.nome_categoria,
    f.nome_fornecedor,
    p.preco_venda,
    p.margem_lucro
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
INNER JOIN fornecedores f ON p.id_fornecedor = f.id_fornecedor;

SELECT 'Visualizando estoque completo' AS Consulta;
SELECT 
    p.nome_produto,
    e.tamanho,
    e.cor,
    e.quantidade,
    e.estoque_minimo
FROM estoque e
INNER JOIN produtos p ON e.id_produto = p.id_produto
ORDER BY p.nome_produto, e.tamanho, e.cor;

SELECT 'Produtos com estoque crítico (abaixo do mínimo)' AS Consulta;
SELECT 
    p.nome_produto,
    e.tamanho,
    e.cor,
    e.quantidade,
    e.estoque_minimo
FROM estoque e
INNER JOIN produtos p ON e.id_produto = p.id_produto
WHERE e.quantidade <= e.estoque_minimo;

SELECT 'Listando todos os clientes' AS Consulta;
SELECT * FROM clientes;

SELECT 'Relatório de vendas' AS Consulta;
SELECT 
    v.id_venda,
    v.data_venda,
    c.nome_cliente,
    v.valor_total,
    v.forma_pagamento,
    v.status_venda
FROM vendas v
LEFT JOIN clientes c ON v.id_cliente = c.id_cliente
ORDER BY v.data_venda DESC;

SELECT 'Detalhes de itens vendidos' AS Consulta;
SELECT 
    v.id_venda,
    v.data_venda,
    p.nome_produto,
    e.tamanho,
    e.cor,
    iv.quantidade,
    iv.preco_unitario,
    iv.subtotal
FROM itens_venda iv
INNER JOIN vendas v ON iv.id_venda = v.id_venda
INNER JOIN estoque e ON iv.id_estoque = e.id_estoque
INNER JOIN produtos p ON e.id_produto = p.id_produto
ORDER BY v.data_venda DESC;

SELECT 'Produtos mais vendidos' AS Consulta;
SELECT 
    p.nome_produto,
    SUM(iv.quantidade) AS total_vendido,
    SUM(iv.subtotal) AS receita_total
FROM itens_venda iv
INNER JOIN estoque e ON iv.id_estoque = e.id_estoque
INNER JOIN produtos p ON e.id_produto = p.id_produto
INNER JOIN vendas v ON iv.id_venda = v.id_venda
WHERE v.status_venda = 'Concluída'
GROUP BY p.id_produto
ORDER BY total_vendido DESC;

SELECT 'Top 5 clientes que mais compraram' AS Consulta;
SELECT 
    c.nome_cliente,
    COUNT(v.id_venda) AS total_compras,
    SUM(v.valor_total) AS total_gasto
FROM clientes c
INNER JOIN vendas v ON c.id_cliente = v.id_cliente
WHERE v.status_venda = 'Concluída'
GROUP BY c.id_cliente
ORDER BY total_gasto DESC
LIMIT 5;

SELECT 'Vendas por forma de pagamento' AS Consulta;
SELECT 
    forma_pagamento,
    COUNT(*) AS quantidade_vendas,
    SUM(valor_total) AS total_faturado
FROM vendas
WHERE status_venda = 'Concluída'
GROUP BY forma_pagamento
ORDER BY total_faturado DESC;

SELECT 'Vendas por categoria' AS Consulta;
SELECT 
    cat.nome_categoria,
    COUNT(DISTINCT iv.id_venda) AS num_vendas,
    SUM(iv.subtotal) AS receita_total
FROM itens_venda iv
INNER JOIN estoque e ON iv.id_estoque = e.id_estoque
INNER JOIN produtos p ON e.id_produto = p.id_produto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
INNER JOIN vendas v ON iv.id_venda = v.id_venda
WHERE v.status_venda = 'Concluída'
GROUP BY cat.id_categoria
ORDER BY receita_total DESC;

SELECT 'Compras realizadas' AS Consulta;
SELECT 
    co.id_compra,
    f.nome_fornecedor,
    co.data_compra,
    co.valor_total,
    co.status_compra
FROM compras co
INNER JOIN fornecedores f ON co.id_fornecedor = f.id_fornecedor
ORDER BY co.data_compra DESC;

SELECT 'Margem de lucro por produto' AS Consulta;
SELECT 
    nome_produto,
    preco_custo,
    preco_venda,
    margem_lucro
FROM produtos
ORDER BY margem_lucro DESC;

SELECT 'Resumo geral do sistema' AS Consulta;
SELECT 'Total de Produtos' AS metrica, COUNT(*) AS valor FROM produtos WHERE ativo = TRUE
UNION ALL
SELECT 'Total de Clientes', COUNT(*) FROM clientes WHERE ativo = TRUE
UNION ALL
SELECT 'Total de Vendas', COUNT(*) FROM vendas WHERE status_venda = 'Concluída'
UNION ALL
SELECT 'Faturamento Total', ROUND(SUM(valor_total), 2) FROM vendas WHERE status_venda = 'Concluída';
