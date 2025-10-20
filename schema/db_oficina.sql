CREATE DATABASE db_oficina TEMPLATE template0;
\c db_oficina;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'os_status') THEN
    CREATE TYPE os_status AS ENUM ('ABERTA','EM_EXECUCAO','CONCLUIDA','CANCELADA');
  END IF;
END$$;

CREATE TABLE cliente (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  endereco TEXT,
  telefone TEXT
);

CREATE TABLE veiculo (
  id SERIAL PRIMARY KEY,
  placa TEXT NOT NULL UNIQUE,
  modelo TEXT NOT NULL,
  marca TEXT NOT NULL,
  ano INT,
  cliente_id INT NOT NULL REFERENCES cliente(id) ON DELETE CASCADE
);

CREATE TABLE mecanico (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  endereco TEXT,
  especialidade TEXT
);

CREATE TABLE equipe (
  id SERIAL PRIMARY KEY,
  nome_equipe TEXT NOT NULL UNIQUE
);

CREATE TABLE equipe_mecanico (
  equipe_id INT NOT NULL REFERENCES equipe(id) ON DELETE CASCADE,
  mecanico_id INT NOT NULL REFERENCES mecanico(id) ON DELETE CASCADE,
  PRIMARY KEY (equipe_id, mecanico_id)
);

CREATE TABLE ordem_servico (
  id SERIAL PRIMARY KEY,
  numero_os TEXT UNIQUE NOT NULL,
  data_emissao DATE NOT NULL,
  data_conclusao_prevista DATE,
  valor_total NUMERIC(12,2),
  status os_status NOT NULL DEFAULT 'ABERTA',
  veiculo_id INT NOT NULL REFERENCES veiculo(id) ON DELETE RESTRICT,
  equipe_id INT NOT NULL REFERENCES equipe(id) ON DELETE RESTRICT
);

CREATE TABLE servico (
  id SERIAL PRIMARY KEY,
  descricao TEXT NOT NULL,
  valor_mao_obra NUMERIC(12,2) NOT NULL CHECK (valor_mao_obra >= 0)
);

CREATE TABLE peca (
  id SERIAL PRIMARY KEY,
  descricao TEXT NOT NULL,
  valor_unitario NUMERIC(12,2) NOT NULL CHECK (valor_unitario >= 0)
);

CREATE TABLE servico_os (
  id SERIAL PRIMARY KEY,
  ordem_servico_id INT NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
  servico_id INT NOT NULL REFERENCES servico(id) ON DELETE RESTRICT,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  valor_total NUMERIC(12,2) NOT NULL CHECK (valor_total >= 0)
);

CREATE TABLE peca_os (
  id SERIAL PRIMARY KEY,
  ordem_servico_id INT NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
  peca_id INT NOT NULL REFERENCES peca(id) ON DELETE RESTRICT,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  valor_total NUMERIC(12,2) NOT NULL CHECK (valor_total >= 0)
);
