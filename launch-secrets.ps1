#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function IsFilePresent(){
    param([string]$file)
    if (Test-Path $file -PathType Leaf) {
        Write-Host "File '$file' exists! Continuing..."
    }
    else {
        throw "File '$file' does not exist! Exiting..."
    }
}

if(-Not (Test-Path "cloudkat.exe" -PathType Leaf  )){
    IsFilePresent "metadata.json"
    $METADATA = Get-Content -Raw -Path  metadata.json | ConvertFrom-Json
    $cloudkat_version = $METADATA.cloudkat_version

	Read-S3Object -BucketName ctm-software-cache -Key "cloudkat/cloudkat-windows-$cloudkat_version.zip" -File cloudkat.zip
	[io.compression.zipfile]::ExtractToDirectory("cloudkat.zip", "./" )
}

function GetSecret() {
  param([string] $secretname)
  if ([string]::IsNullOrWhiteSpace($secretname)) { throw "secretname must be a string, not null, empty, or whitespace" }
  if (!($env:ENVIRONMENT)) { throw "ENVIRONMENT env var is not set! Exiting..." }
  IsFilePresent "metadata.json"
  Try {
      .\cloudkat secret load -m metadata.json -e $env:ENVIRONMENT -n $secretname 
  }
  Catch {
      throw "Cloudkat secret download for '$secretname' failed!"
  }
}

$testKeyOne = GetSecret("TestKeyOne")
Write-Host "testKeyOne = '$testKeyOne'"

$testKeyTwo = GetSecret("TestKeyTwo")
Write-Host "testKeyTwo = '$testKeyTwo'"

$completeDifferentNamingConvention = GetSecret("CompleteDifferentNamingConvention")
Write-Host "completeDifferentNamingConvention = '$completeDifferentNamingConvention'"
