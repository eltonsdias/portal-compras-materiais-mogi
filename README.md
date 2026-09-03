# Portal de Consultas — Compras e Materiais

Portal estático preparado para GitHub Pages. O conteúdo público inclui apenas:

- `index.html`: página inicial;
- `atas.html`: catálogo de atas de registro de preços;
- `materiais.html`: catálogo de materiais SMAR.

## Publicação inicial

1. Crie um repositório institucional no GitHub.
2. Copie o conteúdo desta pasta para a raiz do repositório.
3. Em **Settings → Pages**, publique a branch principal pela pasta raiz.
4. Confirme internamente que os dados podem ser disponibilizados publicamente.

## Atualização mensal das atas

1. Abra `atualizador-catalogo-atas.html`, mantido fora da pasta pública.
2. Selecione o CSV mensal e gere o arquivo `atas.html`.
3. Execute `portal-github/publicar-atualizacao.ps1` na cópia clonada do repositório.
4. Selecione o `atas.html` recém-gerado. O programa substituirá o catálogo e enviará a atualização ao GitHub.

O publicador usa a autenticação já configurada no Git e não armazena senhas ou tokens.

## Atualização anual dos materiais

Substitua `materiais.html` pela nova versão anual e envie a alteração ao repositório.
