# Default:  this machine -> repo -> GitHub   (run after adding or editing a skill)
# -Install: repo -> this machine             (run once on a new machine, and after git pull)
param([switch]$Install, [string]$Claude = "$HOME\.claude")

$repo = $PSScriptRoot

function Copy-Tree($from, $to, $mode) {
    robocopy $from $to $mode /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $from -> $to" }
}

if ($Install) {
    # /E, not /MIR: never delete skills that exist only on the target machine
    Copy-Tree "$repo\skills" "$Claude\skills" /E
    Copy-Tree "$repo\commands" "$Claude\commands" /E
    foreach ($line in Get-Content "$repo\plugins.txt") {
        $source, $plugin = $line -split ' '
        claude plugin marketplace add $source
        claude plugin install $plugin
    }
    exit 0
}

Copy-Tree "$Claude\skills" "$repo\skills" /MIR
Copy-Tree "$Claude\commands" "$repo\commands" /MIR

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
