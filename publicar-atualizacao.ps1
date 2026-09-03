param(
    [string]$ArquivoAtas
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
if (-not (Test-Path (Join-Path $repo '.git'))) {
    Write-Host 'Esta pasta ainda não é um repositório Git clonado.' -ForegroundColor Yellow
    Write-Host 'Faça a publicação inicial no GitHub e execute este arquivo dentro da cópia clonada.'
    Read-Host 'Pressione Enter para fechar'
    exit 1
}

if (-not $ArquivoAtas) {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = 'Selecione o arquivo atas.html gerado pelo atualizador'
    $dialog.Filter = 'Catálogo de atas (atas.html)|atas.html|Arquivos HTML (*.html)|*.html'
    $dialog.InitialDirectory = [Environment]::GetFolderPath('UserProfile') + '\Downloads'
    if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { exit 0 }
    $ArquivoAtas = $dialog.FileName
}

$origem = (Resolve-Path -LiteralPath $ArquivoAtas).Path
$conteudo = [IO.File]::ReadAllText($origem)
if ($conteudo -notmatch 'Materiais vigentes em Atas de Registro de Preços') {
    throw 'O arquivo selecionado não parece ser o catálogo de atas.'
}

$destino = Join-Path $repo 'atas.html'
Copy-Item -LiteralPath $origem -Destination $destino -Force

Push-Location $repo
try {
    git add -- 'atas.html'
    $alterado = git diff --cached --quiet; $codigo = $LASTEXITCODE
    if ($codigo -eq 0) {
        Write-Host 'O catálogo selecionado é igual ao que já está publicado.' -ForegroundColor Yellow
    } else {
        git commit -m "Atualiza catálogo de atas $(Get-Date -Format 'yyyy-MM-dd')"
        if ($LASTEXITCODE -ne 0) { throw 'Não foi possível registrar a atualização.' }
        git push
        if ($LASTEXITCODE -ne 0) { throw 'Não foi possível enviar a atualização ao GitHub.' }
        Write-Host 'Atualização enviada ao GitHub com sucesso.' -ForegroundColor Green
    }
} finally {
    Pop-Location
}
Read-Host 'Pressione Enter para fechar'
