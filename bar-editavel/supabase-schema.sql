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

create table if not exists configuracoes_bar (
  id integer primary key default 1,
  nome text not null default 'Rota do Churrasco',
  subtitulo text not null default 'Bar e Restaurante · Guará, Brasília-DF',
  tag_hero text not null default 'Carnes na chapa, petiscos, chopp gelado e drinks — no ponto certo, todos os dias.',
  instagram_url text not null default 'https://instagram.com/rota_dochurrasco',
  instagram_arroba text not null default '@rota_dochurrasco',
  telefone text not null default '(61) 99759-7684',
  telefone_link text not null default 'tel:+5561997597684',
  endereco text not null default 'Guará, Brasília-DF',
  ifood_url text not null default 'https://www.ifood.com.br/delivery/brasilia-df/rota-do-churrasco---carnes-e-executivos-guara-i/330e3a2c-c383-4f7f-a280-fbc1182a8848',
  ifood_banner_url text not null default 'img/ifood-banner.jpg',
  foto_fachada_url text not null default 'img/fachada.jpg',
  foto_intro_url text not null default 'img/garcom.jpg',
  sobre_titulo text not null default 'Chapa quente, mesa cheia',
  sobre_texto text not null default 'Um cantinho no Guará pra comer bem e ficar até mais tarde: carnes na chapa, petiscos pra dividir e uma carta de drinks e sucos naturais feitos na hora. Tem música em vivo em alguns dias — chega, escolhe uma mesa e peça o chopp.',
  ambiente_subtitulo text not null default 'Mesas ao ar livre, música em vivo em alguns dias e a chapa sempre quente.',
  constraint unq_id check (id = 1)
);

insert into configuracoes_bar (id) values (1) on conflict (id) do nothing;

alter table configuracoes_bar enable row level security;

create policy "Leitura publica das configuracoes"
  on configuracoes_bar for select
  using (true);
