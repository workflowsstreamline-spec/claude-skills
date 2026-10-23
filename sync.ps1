# Default:  this machine -> repo -> GitHub   (run after adding or editing a skill)
# -Install: repo -> this machine             (run once on a new machine, and after git pull)
param([switch]$Install, [string]$Claude = "$HOME\.claude")

$repo = $PSScriptRoot
$agents = "$HOME\.agents\skills"   # Codex reads skills from here

function Copy-Tree($from, $to, $mode) {
    robocopy $from $to $mode /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $from -> $to" }
}

# Relative path + hash of every file, so two skill folders can be compared
function Get-TreeSignature($dir) {
    Get-ChildItem $dir -Recurse -File | Sort-Object FullName | ForEach-Object {
        "$($_.FullName.Substring($dir.Length)) $((Get-FileHash $_.FullName).Hash)"
    } | Out-String
}

if ($Install) {
    # /E, not /MIR: never delete skills that exist only on the target machine
    Copy-Tree "$repo\skills" "$Claude\skills" /E
    Copy-Tree "$repo\commands" "$Claude\commands" /E
    # Codex: shared skills come from skills\, Codex-only variants from agents-skills\
    foreach ($name in Get-Content "$repo\agents-skills.txt") {
        Copy-Tree "$repo\skills\$name" "$agents\$name" /E
    }
    Copy-Tree "$repo\agents-skills" $agents /E
    foreach ($line in Get-Content "$repo\plugins.txt") {
        $source, $plugin = $line -split ' '
        claude plugin marketplace add $source
        claude plugin install $plugin
    }
    exit 0
}

Copy-Tree "$Claude\skills" "$repo\skills" /MIR
Copy-Tree "$Claude\commands" "$repo\commands" /MIR

# Codex skills: store only what differs from the Claude copy, list the rest by name
Remove-Item "$repo\agents-skills" -Recurse -Force -ErrorAction SilentlyContinue
$shared = foreach ($dir in Get-ChildItem $agents -Directory) {
    $twin = "$Claude\skills\$($dir.Name)"
    if ((Test-Path $twin) -and (Get-TreeSignature $dir.FullName) -eq (Get-TreeSignature $twin)) {
        $dir.Name
    } else {
        Copy-Tree $dir.FullName "$repo\agents-skills\$($dir.Name)" /MIR
    }
}
$shared | Set-Content "$repo\agents-skills.txt" -Encoding ascii

# Plugins already live in their own GitHub repos, so record where they come from instead of copying them
$markets = Get-Content "$Claude\plugins\known_marketplaces.json" -Raw | ConvertFrom-Json
$plugins = Get-Content "$Claude\plugins\installed_plugins.json" -Raw | ConvertFrom-Json
$plugins.plugins.PSObject.Properties.Name | Sort-Object | ForEach-Object {
    "$($markets.($_.Split('@')[1]).source.repo) $_"
} | Set-Content "$repo\plugins.txt" -Encoding ascii

git -C $repo add -A
git -C $repo diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git -C $repo commit -q -m "Sync skills $(Get-Date -Format yyyy-MM-dd)"
    git -C $repo push
} else {
    "Nothing changed."
}
