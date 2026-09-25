-- Rode isso UMA VEZ no Supabase: abra seu projeto > SQL Editor > New query,
-- cole tudo isso e clique em "Run".
--
-- Cria um espaco de armazenamento (bucket) publico pra guardar as fotos
-- dos pratos. "Publico" aqui significa que qualquer um pode VER as fotos
-- (necessario pro cardapio aparecer pros clientes) -- so o upload/exclusao
-- e que continua protegido, feito so pela funcao serverless (/api/admin)
-- usando a service_role key.

insert into storage.buckets (id, name, public)
values ('fotos-pratos', 'fotos-pratos', true)
on conflict (id) do nothing;
