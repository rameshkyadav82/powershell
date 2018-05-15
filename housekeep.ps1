# This scrip will house keep previous 3 days files recursively
Get-ChildItem –Path "E:\OneDrive\Tender" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-3))} | Remove-Item
