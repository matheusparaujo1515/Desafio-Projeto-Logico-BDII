INSERT INTO cliente (nome, endereco, telefone) VALUES
('João Silva','Rua A, 123','61999998888'),
('Maria Souza','Av. Central, 45','61988887777'),
('Empresa Z Manutenções','SIA Trecho 2, Lote 10','6133332222');

INSERT INTO veiculo (placa, modelo, marca, ano, cliente_id) VALUES
('ABC1A23','Onix','Chevrolet',2018,1),
('XYZ4B56','Corolla','Toyota',2020,2),
('KLM7C89','Fiorino','Fiat',2019,3);

INSERT INTO mecanico (nome, endereco, especialidade) VALUES
('Carlos Lima','Rua das Flores, 22','Motor'),
('José Santos','Rua Azul, 88','Freios'),
('Paulo Nogueira','Av. Norte, 10','Suspensão'),
('Ana Beatriz','QS 03, 100','Elétrica');

INSERT INTO equipe (nome_equipe) VALUES
('Equipe Alfa'),('Equipe Beta');

INSERT INTO equipe_mecanico VALUES
(1,1),(1,2),(2,3),(2,4);

INSERT INTO servico (descricao, valor_mao_obra) VALUES
('Troca de óleo',100.00),
('Revisão de freios',250.00),
('Alinhamento e balanceamento',150.00),
('Diagnóstico elétrico',180.00);

INSERT INTO peca (descricao, valor_unitario) VALUES
('Filtro de óleo',40.00),
('Pastilha de freio',180.00),
('Pneu Aro 15',320.00),
('Sensor ABS',210.00);

INSERT INTO ordem_servico (numero_os, data_emissao, data_conclusao_prevista, valor_total, status, veiculo_id, equipe_id) VALUES
('OS001','2025-10-15','2025-10-18',NULL,'EM_EXECUCAO',1,1),
('OS002','2025-10-17','2025-10-20',NULL,'ABERTA',2,2),
('OS003','2025-10-18','2025-10-21',NULL,'ABERTA',3,2);

INSERT INTO servico_os (ordem_servico_id, servico_id, quantidade, valor_total) VALUES
(1,1,1,100.00),
(1,2,1,250.00),
(2,3,1,150.00),
(3,4,1,180.00);

INSERT INTO peca_os (ordem_servico_id, peca_id, quantidade, valor_total) VALUES
(1,1,1,40.00),
(1,2,1,180.00),
(2,3,2,640.00),
(3,4,1,210.00);

UPDATE ordem_servico os
SET valor_total = (
  SELECT SUM(valor_total)
  FROM (
    SELECT valor_total FROM servico_os WHERE ordem_servico_id = os.id
    UNION ALL
    SELECT valor_total FROM peca_os WHERE ordem_servico_id = os.id
  ) x
);

SELECT nome, telefone FROM cliente;
SELECT c.nome, v.placa, v.modelo
FROM cliente c
JOIN veiculo v ON v.cliente_id = c.id
ORDER BY c.nome;

SELECT os.numero_os,
  (SELECT SUM(valor_total) FROM servico_os WHERE ordem_servico_id=os.id) +
  (SELECT SUM(valor_total) FROM peca_os WHERE ordem_servico_id=os.id) AS valor_total_calculado
FROM ordem_servico os;

SELECT e.nome_equipe, COUNT(os.id) AS qtd_os
FROM equipe e
LEFT JOIN ordem_servico os ON os.equipe_id = e.id
GROUP BY e.nome_equipe
HAVING COUNT(os.id) >= 1;

SELECT c.nome AS cliente, SUM(os.valor_total) AS faturamento
FROM cliente c
JOIN veiculo v ON v.cliente_id = c.id
JOIN ordem_servico os ON os.veiculo_id = v.id
GROUP BY c.nome
HAVING SUM(os.valor_total) > 500
ORDER BY faturamento DESC;
