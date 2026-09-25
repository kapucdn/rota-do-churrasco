# Rota do Churrasco — Cardápio Digital

Site do cardápio + painel administrativo, pra hospedar de graça no Vercel.

## O que tem aqui
- `index.html` — cardápio público (o que o cliente ve ao escanear o QR code)
- `admin.html` — painel pra você adicionar/editar/remover pratos (protegido por senha)
- `api/admin.js` — função que roda no servidor, confere a senha antes de gravar no banco
- `config.js` — onde você cola a URL e a chave pública do seu banco de dados
- `supabase-schema.sql` — comando pra criar a tabela de pratos no banco

## Passo 1 — Criar o banco de dados (Supabase, gratuito)
1. Crie uma conta em https://supabase.com e um novo projeto (escolha uma senha de banco, guarde ela)
2. Espere o projeto terminar de criar (leva ~2 minutos)
3. No menu lateral, vá em **SQL Editor** → **New query**
4. Abra o arquivo `supabase-schema.sql` daqui, copie tudo, cole lá e clique em **Run**
   - Isso cria a tabela `pratos` e já coloca 5 pratos de exemplo pra você ver funcionando
5. Vá em **Project Settings** (ícone de engrenagem) → **API**
   - Copie a **Project URL**
   - Copie a chave **anon public**
   - Copie a chave **service_role** (⚠️ essa é secreta, não vaza)

## Passo 2 — Preencher a configuração pública
Abra `config.js` e cole:
```js
const SUPABASE_URL = "https://xxxxxxxxxxxxx.supabase.co";
const SUPABASE_ANON_KEY = "eyJxxxxxxxxxxxxxxxxxxxxxxxxxxx";
```

## Passo 3 — Subir pro GitHub
1. Crie um repositório novo no GitHub
2. Suba esses arquivos todos pra ele (pelo site do GitHub mesmo, "Add file" → "Upload files", ou via git se preferir)

## Passo 4 — Deploy no Vercel
1. Crie conta em https://vercel.com (pode entrar direto com sua conta do GitHub)
2. **Add New** → **Project** → escolha o repositório que você acabou de subir
3. Antes de clicar em Deploy, abra **Environment Variables** e adicione 3:
   | Nome | Valor |
   |---|---|
   | `ADMIN_PASSWORD` | a senha que você quer usar pra entrar no `/admin.html` |
   | `SUPABASE_URL` | a mesma Project URL do Passo 1 |
   | `SUPABASE_SERVICE_ROLE_KEY` | a chave `service_role` do Passo 1 (a secreta) |
4. Clique em **Deploy**
5. Em ~1 minuto seu site está no ar, num link tipo `rota-do-churrasco.vercel.app`

## Passo 5 — Testar
1. Acesse `seu-site.vercel.app` — deve mostrar os 5 pratos de exemplo
2. Acesse `seu-site.vercel.app/admin.html`, entra com a senha que você definiu
3. Edita/adiciona/remove pratos — o cardápio público atualiza na hora

## Passo 6 — QR code pra mesa
Depois que o site estiver no ar, usa a aba **QR Code 3D** ou **Tag Chaveiro** do
`ferramentas_stl_gui.py` (ou qualquer gerador de QR) apontando pro link do
Vercel (ex: `https://rota-do-churrasco.vercel.app`), e imprime/cola na placa
de mesa.

## Trocar a senha depois
Vercel → seu projeto → **Settings** → **Environment Variables** → edita
`ADMIN_PASSWORD` → **Redeploy** (o site pede pra reimplantar depois de mudar
uma variável).

## Domínio próprio (opcional)
Se quiser um endereço tipo `cardapio.rotadochurrasco.com.br` em vez do
`.vercel.app`, isso também é de graça pra configurar no Vercel — só precisa
comprar o domínio em algum registrador (Registro.br pra `.com.br`, por
exemplo) e apontar pro Vercel em **Settings → Domains**.
