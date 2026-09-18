-- Rode isso UMA VEZ no Supabase: abra seu projeto > SQL Editor > New query,
-- cole tudo isso e clique em "Run".

create extension if not exists "pgcrypto";

create table if not exists pratos (
  id uuid primary key default gen_random_uuid(),
  categoria text not null,
  nome text not null,
  descricao text,
  preco numeric(10, 2) not null,
  imagem_url text,
  ordem integer not null default 0,
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

-- protege a tabela: qualquer um pode LER os pratos ativos (pro cardapio
-- publico funcionar), mas ninguem consegue escrever direto do navegador --
-- toda escrita passa pela funcao serverless (/api/admin), que confere a
-- senha antes de usar a service_role key (essa sim tem permissao de escrita).
alter table pratos enable row level security;

create policy "Leitura publica dos pratos ativos"
  on pratos for select
  using (ativo = true);

-- alguns pratos de exemplo pra voce ver o cardapio funcionando antes de
-- cadastrar os pratos de verdade pelo painel admin
insert into pratos (categoria, nome, descricao, preco, ordem) values
  ('Petiscos', 'Coxinha', 'Recheio de frango desfiado, casquinha crocante', 8.00, 1),
  ('Petiscos', 'Carne de Sol', 'Acompanha vinagrete e farofa', 15.00, 2),
  ('Petiscos', 'Tilapia Frita', 'Porcao individual, acompanha limao', 18.00, 3),
  ('Bebidas', 'Chope 300ml', 'Gelado na hora', 8.00, 1),
  ('Bebidas', 'Cerveja Long Neck', '', 10.00, 2);
