<#

.SYNOPSIS
  Powershell script to backup files older than N days.
  
.DESCRIPTION
  This PowerShell script is for taking incremental backups of files modified in the last N days from the specified source to destination folder.
  
.PARAMETER <source>
   Source location where the files should be copied from.

.PARAMETER <destination>
   Target location where the files should be copied to.
    
 .PARAMETER <N days>
   Only files modified in the last N days will be copied.
     
.EXAMPLE
  FileBackup c:\source-folder d:\dest-folder 30
   
#>

Param(
  [Parameter(Mandatory=$true, position=0)][string]$source,
  [Parameter(Mandatory=$true, position=1)][string]$destination,
  [Parameter(Mandatory=$true, position=2)][Int]$days
)

$src = $source.toLower()
$dest = $destination.toLower()

Write-Host "File backup started."
Write-Host "Source: " $src 
Write-Host "Destination: " $dest 
Write-Host "Policy: Files older than" $days "days"

Write-Host "Scanning files ..."

$FilesToCopy = Get-ChildItem $src -force -recurse| where-object {($_.LastWriteTime -gt (Get-Date).AddDays(-$days))  -and  ($_.PSIsContainer -ne $True)}

Write-Host "Scanning completed."

Write-Host "Copying files..."
$count = 0
Foreach($File in $FilesToCopy)

{
    $src_file = $File.Fullname.tolower()
    $dst_file = $File.Fullname.tolower().replace($src, $dest)
    $dst_dir = Split-path -path $dst_file
 
     if (!(Test-Path -path $dst_dir) ) {
       Write-Host "`t Create directory " $dst_dir
       New-Item -path $dst_dir -type Directory | out-null
    }
    
    
    Copy-Item $src_file -Destination $dst_file
    $count++
}

Write-Host "File copy completed."
Write-Host $count "file(s) copied."

Write-Host "File backup completed."
