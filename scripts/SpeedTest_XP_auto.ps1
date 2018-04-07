$posh = Get-WmiObject win32_process | Where-Object {$_.name -eq "powershell.exe" -and $_.Processid -ne $pid} | Select-Object CommandLine
if (($posh -match "SpeedTest_XP_new.ps1") -or ($posh -match "SpeedTest_XP_auto.ps1")) {Stop-Process -Id $pid}

Set-Location C:\iperf

$a = "-c ping.online.net -p 5209","-c ping.online.net -p 5208","-c ping.online.net -p 5207","-c ping.online.net -p 5206","-c ping.online.net -p 5205","-c ping.online.net -p 5204","-c ping.online.net -p 5203","-c ping.online.net -p 5202","-c ping.online.net -p 5201","-c ping.online.net -p 5200","-c bouygues.iperf.fr -p 5209","-c bouygues.iperf.fr -p 5208","-c bouygues.iperf.fr -p 5207","-c bouygues.iperf.fr -p 5206","-c bouygues.iperf.fr -p 5205","-c bouygues.iperf.fr -p 5204","-c bouygues.iperf.fr -p 5203","-c bouygues.iperf.fr -p 5202","-c bouygues.iperf.fr -p 5201","-c bouygues.iperf.fr -p 5200","-c speedtest.serverius.net -p 5002"
$bdcom_network = "@PCI\VEN_1106&DEV_3065&SUBSYS_30651849&REV_78\3&267A616A&0&90"
$huawei_network = "@PCI\VEN_10EC&DEV_8139&SUBSYS_813910EC&REV_10\3&267A616A&0&58"
$iskratel_network = "@PCI\VEN_1106&DEV_3106&SUBSYS_14051186&REV_8B\3&267A616A&0&48"
$stream = 10
$seconds = 5

function BDCOM () {
    $connection = "BDCOM"
    devcon disable $bdcom_network
    devcon disable $huawei_network
    devcon disable $iskratel_network
    devcon enable $bdcom_network
    Start-Sleep -Seconds 10
    $internetaccess = Test-Connection -ComputerName 8.8.8.8,77.88.8.8 -Quiet

    if ($internetaccess -eq $True) {
        $i = 0
        $server_port = $a[$i]
        $serv = -split $server_port
        .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
        while ((Select-String "server is busy" -Path ".\$connection download.json") -or (Select-String "Connection reset by peer" -Path ".\$connection download.json") -or (Select-String "unable to connect to server" -Path ".\$connection download.json")) {
            if ($i -lt $a.Length) {
                $i++
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
            }
            else {
                $i = 0
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
            }
        }
        $i = 0
        $server_port = $a[$i]
        $serv = -split $server_port
        Write-Host ".\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P 10 -t 20 -J"
        .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
        while ((Select-String "server is busy" -Path ".\$connection upload.json") -or (Select-String "Connection reset by peer" -Path ".\$connection upload.json") -or (Select-String "unable to connect to server" -Path ".\$connection upload.json")) {
            if ($i -lt $a.Length) {
                $i++
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
            }
            else {
                $i = 0
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
            }
        }
        $bdcom_up = Get-Content ".\$connection upload.json" | .\jq '.end.sum_sent.bits_per_second'
        $bdcom_down = Get-Content ".\$connection download.json" | .\jq '.end.sum_sent.bits_per_second'
        $bdcom_up_sum = $bdcom_up/1024/1024
        $bdcom_up_sum = [math]::Round($bdcom_up_sum, 2)
        $bdcom_down_sum = $bdcom_down/1024/1024
        $bdcom_down_sum = [math]::Round($bdcom_down_sum, 2)
        $bdcom_up_sum = "$bdcom_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
        $bdcom_down_sum = "$bdcom_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }

    elseif ($internetaccess -eq $False) {
        $bdcom_down_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
        $bdcom_up_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }

    Huawei
}

function Huawei () {
    $connection = "Huawei"
    devcon disable $bdcom_network
    devcon disable $iskratel_network
    devcon enable $huawei_network
    Start-Sleep -Seconds 10
    $internetaccess = Test-Connection -ComputerName 8.8.8.8,77.88.8.8 -Quiet

    if ($internetaccess -eq $True) {
        $i = 0
        $server_port = $a[$i]
        $serv = -split $server_port
        .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
        while ((Select-String "server is busy" -Path ".\$connection download.json") -or (Select-String "Connection reset by peer" -Path ".\$connection download.json") -or (Select-String "unable to connect to server" -Path ".\$connection download.json")) {
            if ($i -lt $a.Length) {
                $i++
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
            }
            else {
                $i = 0
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
            }
        }
        $i = 0
        $server_port = $a[$i]
        $serv = -split $server_port
        Write-Host ".\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P 10 -t 20 -J"
        .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
        while ((Select-String "server is busy" -Path ".\$connection upload.json") -or (Select-String "Connection reset by peer" -Path ".\$connection upload.json") -or (Select-String "unable to connect to server" -Path ".\$connection upload.json")) {
            if ($i -lt $a.Length) {
                $i++
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
            }
            else {
                $i = 0
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
            }
        }
        $huawei_up = Get-Content ".\$connection upload.json" | .\jq '.end.sum_sent.bits_per_second'
        $huawei_down = Get-Content ".\$connection download.json" | .\jq '.end.sum_sent.bits_per_second'
        $huawei_up_sum = $huawei_up/1024/1024
        $huawei_up_sum = [math]::Round($huawei_up_sum, 2)
        $huawei_down_sum = $huawei_down/1024/1024
        $huawei_down_sum = [math]::Round($huawei_down_sum, 2)
        $huawei_up_sum = "$huawei_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
        $huawei_down_sum = "$huawei_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }

    if ($internetaccess -eq $False) {
        $huawei_down_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
        $huawei_up_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }

    Iskratel
}

function Iskratel () {
    $connection = "Iskratel"
    devcon disable $bdcom_network
    devcon disable $huawei_network
    devcon enable $iskratel_network
    Start-Sleep -Seconds 10
    $internetaccess = Test-Connection -ComputerName 8.8.8.8,77.88.8.8 -Quiet

    if ($internetaccess -eq $True) {
        $i = 0
        $server_port = $a[$i]
        $serv = -split $server_port
        .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
        while ((Select-String "server is busy" -Path ".\$connection download.json") -or (Select-String "Connection reset by peer" -Path ".\$connection download.json") -or (Select-String "unable to connect to server" -Path ".\$connection download.json")) {
            if ($i -lt $a.Length) {
                $i++
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
            }
            else {
                $i = 0
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J -R > "$connection download.json"
            }
        }
        $i = 0
        $server_port = $a[$i]
        $serv = -split $server_port
        Write-Host ".\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P 10 -t 20 -J"
        .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
        while ((Select-String "server is busy" -Path ".\$connection upload.json") -or (Select-String "Connection reset by peer" -Path ".\$connection upload.json") -or (Select-String "unable to connect to server" -Path ".\$connection upload.json")) {
            if ($i -lt $a.Length) {
                $i++
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
            }
            else {
                $i = 0
                $server_port = $a[$i]
                $serv = -split $server_port
                .\iperf3.exe $serv[0] $serv[1] $serv[2] $serv[3] -P $stream -t $seconds -J > "$connection upload.json"
            }
        }
        $iskratel_up = Get-Content ".\$connection upload.json" | .\jq '.end.sum_sent.bits_per_second'
        $iskratel_down = Get-Content ".\$connection download.json" | .\jq '.end.sum_sent.bits_per_second'
        $iskratel_up_sum = $iskratel_up/1024/1024
        $iskratel_up_sum = [math]::Round($iskratel_up_sum, 2)
        $iskratel_down_sum = $iskratel_down/1024/1024
        $iskratel_down_sum = [math]::Round($iskratel_down_sum, 2)
        $iskratel_up_sum = "$iskratel_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
        $iskratel_down_sum = "$iskratel_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }

    if ($internetaccess -eq $False) {
        $iskratel_down_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
        $iskratel_up_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }

    AllConnection
}

function AllConnection () {
    devcon enable $bdcom_network
    devcon enable $huawei_network
    devcon enable $iskratel_network
    Start-Sleep 10
    Telegram
}
function Telegram () {
    $bot_token = "526576550:AAEYqJfKYaaGhxXRvbyIZgrzsQheCoFfbko"
    #$chatid = "-256698582"
    $chatid = "371175128"
    $speed = "%d0%98%d0%b7%d0%bc%d0%b5%d1%80%d0%b5%d0%bd%d0%b8%d0%b5%20%d1%81%d0%ba%d0%be%d1%80%d0%be%d1%81%d1%82%d0%b8%20%d0%b8%d0%bd%d1%82%d0%b5%d1%80%d0%bd%d0%b5%d1%82%20%d1%81%d0%be%d0%b5%d0%b4%d0%b8%d0%bd%d0%b5%d0%bd%d0%b8%d0%b9%0a%0a"
    $bdcom_zagruzka = "%42%44%43%4f%4d%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $bdcom_otdacha = "%42%44%43%4f%4d%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    $huawei_zagruzka = "%48%75%61%77%65%69%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $huawei_otdacha = "%48%75%61%77%65%69%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    $iskratel_zagruzka = "%49%73%6b%72%61%74%65%6c%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $iskratel_otdacha = "%49%73%6b%72%61%74%65%6c%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    .\curl.exe -d "chat_id=$chatid&text=*$speed**$bdcom_zagruzka*$bdcom_down_sum*$bdcom_otdacha*$bdcom_up_sum*$huawei_zagruzka*$huawei_down_sum*$huawei_otdacha*$huawei_up_sum*$iskratel_zagruzka*$iskratel_down_sum*$iskratel_otdacha*$iskratel_up_sum&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    Escape
}

function Escape () {
    if (Select-String '"ok":true' -Path ".\response.txt") {
        Remove-Item -Path .\*.json
        Remove-Item -Path .\*.txt
        Exit
    }
    else {
        Start-Sleep 180
        Telegram
    }
}

BDCOM