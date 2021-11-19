Param(
    $oldVersion,
    $newVersion = "D:\Mass Effect Modding\ME3TweaksModManager\mods\LE1\LE1 Community Patch\DLC_MOD_LE1CP\CookedPCConsole",
    $updateName = 'Update'
)

# Compares the MD5 Hashes of old version files and new version files
# To compile a list of new files in this update, and changed files in this update

$newFileOut = ".\$($updateName)_NewFiles.txt"
$changedFileOut = ".\$($updateName)_ChangedFiles.txt"

$hashes = @{}

$oldVerFiles = Get-ChildItem -Recurse -File $oldVersion
$newVerFiles = Get-ChildItem -Recurse -File $newVersion

foreach($file in $oldVerFiles)
{
    $hashes.Add($file.Name, (Get-FileHash $file -Algorithm MD5).Hash)
}

foreach($file in $newVerFiles)
{
    $filehash = (Get-FileHash $file -Algorithm MD5).Hash
    if($hashes.ContainsKey($file.Name))
    {
        if($hashes[$file.Name] -ne $filehash)
        {
            $file.Name | Out-File $changedFileOut -Append
        }
    }
    else
    {
        $file.Name | Out-File $newFileOut -Append
    }
}