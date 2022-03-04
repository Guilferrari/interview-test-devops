
Write-Host  "================="

Write-Host  "Starting the Backup..."

$Server = 'LAPTOP-J8I2GRUB' # Add Server Instance Name
$Database = 'DBTest' # Add DB name
$BackupDestination = 'C:\Users\Test\Desktop\Backup\' # Add the backup path destination
$Date = get-date -format dd-MM-yyyy
$FilePath = "$($BackupDestination)$($Database)_db_$($Date).bak"

Backup-SqlDatabase -ServerInstance $Server -Database $Database -BackupFile $FilePath

Write-Host  "================="

Write-Host  "Backup completed."

Write-Host  "================="

Write-Host  "Upload file to Azure Blob Storage."

Write-Host  "================="

#Upload to Azure Blob Storage

# Get File Name

$Name = (Get-Item $FilePath).name

Write-Host  "The Backup name is: " $Name

# Storage Account

$StorageAccount = "http://mystorageaccount.blob.core.windows.net" # Add the Storage Account


# Container 

$ContainerName = "BackupDB" # Add Container name


# Shared Access Signature (SAS) Token ( before that need to create the token with the Permissions / Expiry date and time )
$SASToken = "?sv=..................."


# Blob service REST API URI to upload the file

$URI = "$($StorageAccount)/$($ContainerName)/$($Name)$($SASToken)"

# Header

$header = @{
    'x-ms-blob-type' = 'BlockBlob'
}

# Upload to Blob

Invoke-RestMethod -Method PUT -$URI -Headers $header -InFile $FilePath

Write-Host  "Completed."