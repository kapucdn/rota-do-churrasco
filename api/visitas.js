// api/visitas.js
// Contador de visitas simples, guardado num arquivo .txt.
// Usa /tmp porque é a única pasta onde o Vercel deixa escrever.

import fs from "fs";
import path from "path";

const CAMINHO_ARQUIVO = path.join("/tmp", "contador_visitas.txt");

function lerContador() {
  try {
    const conteudo = fs.readFileSync(CAMINHO_ARQUIVO, "utf-8");
    return parseInt(conteudo.trim(), 10) || 0;
  } catch (e) {
    return 0;
  }
}

function salvarContador(valor) {
  fs.writeFileSync(CAMINHO_ARQUIVO, String(valor), "utf-8");
}

export default function handler(req, res) {
  if (req.method === "POST") {
    const total = lerContador() + 1;
    salvarContador(total);
    return res.status(200).json({ total });
  }

  if (req.method === "GET") {
    const total = lerContador();
    return res.status(200).json({ total });
  }

  res.status(405).json({ erro: "Método não permitido" });
}
