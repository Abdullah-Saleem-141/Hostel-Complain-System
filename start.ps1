$MavenUrl = "https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.6/apache-maven-3.9.6-bin.zip"
$MavenZip = "maven.zip"
$MavenDir = "apache-maven-3.9.6"

Write-Host "========================================"
Write-Host "Hostel Complaint Portal - Server Starter"
Write-Host "========================================"

if (-Not (Test-Path $MavenDir)) {
    Write-Host "[1/3] Downloading Maven (One-time setup)..."
    Invoke-WebRequest -Uri $MavenUrl -OutFile $MavenZip
    Write-Host "[2/3] Extracting Maven..."
    Expand-Archive -Path $MavenZip -DestinationPath . -Force
    Remove-Item $MavenZip
} else {
    Write-Host "[1/3] Maven already downloaded."
}

$MvnCmd = ".\$MavenDir\bin\mvn.cmd"

Write-Host "[3/3] Starting Tomcat Server on port 8080..."
Write-Host "Please wait until you see 'Starting ProtocolHandler [http-bio-8080]'"
Write-Host "Then open http://localhost:8080 in your browser."
Write-Host "========================================"

& $MvnCmd tomcat7:run
