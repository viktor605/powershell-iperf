#(Get-Host).UI.RawUI.BackgroundColor = �DarkMagenta�
Set-Location $PSScriptRoot
function FirstChoise () {
    Clear-Host
    Write-Host
    Write-Host " ��������� �������� �������� ����������"  -ForegroundColor Yellow
    Write-Host
    Write-Host " ����" -ForegroundColor Yellow
    Write-Host
    Write-Host " 1) ������ ������������ ��������" -ForegroundColor Green
    Write-Host " 2) ���������� ������������ �� ��������� �����������" -ForegroundColor Green
    Write-Host " 3) ��������� ��������� � ����������� � Telegram ������" -ForegroundColor Green
    Write-Host " 4) �����" -ForegroundColor Red
    Write-Host
    $choice = Read-Host " ������� ����� ��������"
    Switch($choice){
        1{Connections}
        2{Connections}
        3{Json}
        4{Escape}
        default {Write-Host; Write-Host " �� ����� �������� �����. ���������� �����." -ForegroundColor Red; Write-Host; Read-Host -Prompt " ������� Enter ��� �����������"; FirstChoise}
      }
}

function Connections () {
    Clear-Host
    Write-Host
    Write-Host " �������� ��� �������� ����������:" -ForegroundColor DarkYellow
    Write-Host
    Write-Host " 1) Huawei" -ForegroundColor Green
    Write-Host " 2) Iskratel" -ForegroundColor Green
    Write-Host " 3) BDCOM" -ForegroundColor Green
    Write-Host " 4) �����" -ForegroundColor Red
    Write-Host
    $connectoin = Read-Host " ��� ������? ������� ����� ����������"
    Switch($connectoin){
        1{$connection = "Huawei"; CheckFileExist}
        2{$connection = "Iskratel"; CheckFileExist}
        3{$connection = "BDCOM"; CheckFileExist}
        4{Escape}
        default {Write-Host; Write-Host " �� ����� �������� �����. ���������� �����." -ForegroundColor Red; Write-Host; Read-Host -Prompt " ������� Enter ��� �����������"; Connections}
      }
}

function CheckFileExist () {
    $FileExists1 = Test-Path ".\$connection upload.json"
    $FileExists2 = Test-Path ".\$connection download.json"
    If ($FileExists1 -eq $True) {
        Write-Host
        Write-Host " �� ��� ��� ������. �������� ������ �����������" -ForegroundColor Red
        Read-Host -Prompt " ������� Enter ��� �����������"
        Connections
    }
    elseif ($FileExists2 -eq $True) {
        Write-Host
        Write-Host " �� ��� ��� ������. �������� ������ �����������" -ForegroundColor Red
        Read-Host -Prompt " ������� Enter ��� �����������"
        Connections
    }
    Times
}

function Times () {
    Clear-Host
    Write-Host
    $seconds = Read-Host " ������� ����������������� ����� � ��������"
    $seconds = [int]::Parse($seconds)
    if ( $seconds -gt 300 ) {
        Write-Host
        Write-Host " ����� ��� �����? ������� �������� �����" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        Times
    }
    Threads
}

function Threads () {
    Clear-Host
    Write-Host
    $stream = Read-Host " ������� ���������� ������������� ���������� � ��������"
    $stream = [int]::Parse($stream)
    if ($stream -gt 25) {
        Write-Host
        Write-Host " �� ����� ������� ������� ���������� ����������. ���� ��������� ������� ������ ��� ������ �����. ���������� ��������� ��� �����." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        Threads
    }
    ChoiseServer
}

function ChoiseServer () {
    Clear-Host
    Write-Host
    Write-Host " �������� ������:" -ForegroundColor Yellow
    Write-Host
    Write-Host " 1) ������� ��� ������������ ������ PING.ONLINE.NET" -ForegroundColor Green
    Write-Host " 2) ������� ��� ������������ ������ BOUYGUES.IPERF.FR" -ForegroundColor Green
    Write-Host " 3) ������� ��� ������������ ������ SPEEDTEST.SERVERIUS.NET" -ForegroundColor Green
    Write-Host " 4) ��������� � ���������� ����" -ForegroundColor Red
    Write-Host " 5) ����� � ������� ����" -ForegroundColor Red
    Write-Host
    $choice = Read-Host " ������� ����� ��������"
    Switch($choice){
        1{$server = "ping.online.net"; Ports}
        2{$server = "bouygues.iperf.fr"; Ports}
        3{$server = "speedtest.serverius.net"; $port = "5002"; Test}
        4{Connections}
        5{FirstChoise}
        default {Write-Host; Write-Host " �� ����� �������� �����. ���������� �����." -ForegroundColor Red; Write-Host; Read-Host -Prompt " ������� Enter ��� �����������"; ChoiseServer}
      }
}

function Ports () {
    Clear-Host
    Write-Host
    $port = Read-Host " ������� ����� ����� ���������� ������� (� 5200 �� 5209)"
    $port = [int]::Parse($port)
    if ($port -lt 5200) {
        Write-Host
        Write-Host " �� ������� �������� ����. ���������� �����." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        Ports
    }
    elseif ($port -gt 5209) {
        Write-Host
        Write-Host " �� ������� �������� ����. ���������� �����." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        Ports
    }
    else {
        Test
    }
}

function Test () {
    Clear-Host
    Write-Host
    Write-Host " ������ ������������ ���������� �������" -ForegroundColor Yellow
    .\iperf3.exe -c $server -p $port -P $stream -t $seconds -J > "$connection upload.json"
    if (Select-String "server is busy" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!������ ����������!!! ���� ������ �� ������ ����� �����. ���������� ����� (��������� ������ ��� ����)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        ChoiseServer
    }
    elseif (Select-String "Connection reset by peer" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!������ ����������!!! ���� ������ �� ������ ����� �����. ���������� ����� (��������� ������ ��� ����)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        ChoiseServer
    }
    elseif (Select-String "unable to connect to server" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!��� ����� � ��������!!! �������� �� ������ ������� �����������" -ForegroundColor Red
        Write-Host " ����������� ������ � ���� ��������. ��������� ������� �����������!" -ForegroundColor Red
        Write-Host
        Write-Host " ��������� ��������:" -ForegroundColor Yellow
        Write-Host
        Write-Host " 1) ��������� ������� ������� � ���� �������� �� ������ �����������" -ForegroundColor Green
        Write-Host " 2) ������� ������ ������" -ForegroundColor Green
        Write-Host " 3) ���������� � ����� � ������� ����" -ForegroundColor Green
        Write-Host
        $connectionerror = Read-Host " ������� ����� ��������"
        Switch($connectionerror) {
            1{CheckConnection}
            2{ChoiseServer}
            3{FirstChoise}
            default {Write-Host; Write-Host " �� ����� �������� �����. ���������� �����." -ForegroundColor Red; Write-Host; Read-Host -Prompt " ������� Enter ��� �����������"; ChoiseServer}
          }
    }
    Write-Host
    Write-Host " ���������!" -ForegroundColor Green
    Write-Host
    Write-Host " ������ ������������ ��������� �������" -ForegroundColor Yellow
    .\iperf3.exe -c $server -p $port -P $stream -t $seconds -R -J > "$connection download.json"
    if (Select-String "server is busy" -Path ".\$connection download.json") {
        Write-Host
        Write-Host " !!!������ ����������!!! ���� ������ �� ������ ����� �����. ���������� ����� (��������� ������ ��� ����)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        ChoiseServer
    }
    elseif (Select-String "Connection reset by peer" -Path ".\$connection download.json") {
        Write-Host
        Write-Host " !!!������ ����������!!! ���� ������ �� ������ ����� �����. ���������� ����� (��������� ������ ��� ����)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        ChoiseServer
    }
    elseif (Select-String "unable to connect to server" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!��� ����� � ��������!!! �������� �� ������ ������� �����������" -ForegroundColor Red
        Write-Host " ����������� ������ � ���� ��������. ��������� ������� �����������!" -ForegroundColor Red
        Write-Host
        Write-Host " ��������� ��������:" -ForegroundColor Yellow
        Write-Host
        Write-Host " 1) ��������� ������� ������� � ���� �������� �� ������ �����������" -ForegroundColor Green
        Write-Host " 2) ������� ������ ������" -ForegroundColor Green
        Write-Host " 3) ���������� � ����� � ������� ����" -ForegroundColor Green
        Write-Host
        $connectionerror = Read-Host " ������� ����� ��������"
        Switch($connectionerror) {
            1{CheckConnection}
            2{ChoiseServer}
            3{FirstChoise}
            default {Write-Host; Write-Host " �� ����� �������� �����. ���������� �����." -ForegroundColor Red; Write-Host; Read-Host -Prompt " ������� Enter ��� �����������"; ChoiseServer}
          }
    }
    Write-Host
    Write-Host " ���������!" -ForegroundColor Green
    Write-Host
    Write-Host " ������������ $connection ��������� �������!" -ForegroundColor Green
    Write-Host
    Read-Host -Prompt " ������� Enter ��� �����������"
    FirstChoise
}

function CheckConnection () {
    Clear-Host
    Write-Host
    Write-Host " ��������� ������� ������� � ���� �������� � ������� Google � Yandex..." -ForegroundColor Yellow
    $internetaccess = Test-Connection -ComputerName 8.8.8.8,77.88.8.8 -Quiet
     if ($internetaccess -eq $False) {
         Write-Host
         Write-Host " !!!������!!! �� ������ ����������� ����������� ����� � ���������!" -ForegroundColor Red
         Write-Host
         Write-Host " ������� � ������� ����..."
         Write-Host
         Read-Host -Prompt " ������� Enter ��� �����������"
         FirstChoise
     }
    Write-Host
    Write-Host " �� ������ ����������� � ���������� ��� � �������." -ForegroundColor Green
    Write-Host " ���������� ������� ������ ������ ��� ������������." -ForegroundColor Green
    Write-Host
    Read-Host -Prompt " ������� Enter ��� �����������"
    ChoiseServer
}

function Json () {
    Clear-Host
    Write-Host
    Write-Host " ��������� ������ ��� �������� ���������..." -ForegroundColor Yellow
    $bdcom_up = Get-Content -Raw -Path ".\BDCOM upload.json" | ConvertFrom-Json
    $bdcom_down = Get-Content -Raw -Path ".\BDCOM download.json" | ConvertFrom-Json
    $huawei_up = Get-Content -Raw -Path ".\Huawei upload.json" | ConvertFrom-Json
    $huawei_down = Get-Content -Raw -Path ".\Huawei download.json" | ConvertFrom-Json
    $iskratel_up = Get-Content -Raw -Path ".\Iskratel upload.json" | ConvertFrom-Json
    $iskratel_down = Get-Content -Raw -Path ".\Iskratel download.json" | ConvertFrom-Json
    $bdcom_up_sum = $bdcom_up.end.sum_sent.bits_per_second
    $bdcom_down_sum = $bdcom_down.end.sum_received.bits_per_second
    $huawei_up_sum = $huawei_up.end.sum_sent.bits_per_second
    $huawei_down_sum = $huawei_down.end.sum_received.bits_per_second
    $iskratel_up_sum = $iskratel_up.end.sum_sent.bits_per_second
    $iskratel_down_sum = $iskratel_down.end.sum_received.bits_per_second
    $bdcom_up_sum = $bdcom_up_sum/1024/1024
    $bdcom_up_sum = [math]::Round($bdcom_up_sum, 2)
    $bdcom_down_sum = $bdcom_down_sum/1024/1024
    $bdcom_down_sum = [math]::Round($bdcom_down_sum, 2)
    $huawei_up_sum = $huawei_up_sum/1024/1024
    $huawei_up_sum = [math]::Round($huawei_up_sum, 2)
    $huawei_down_sum = $huawei_down_sum/1024/1024
    $huawei_down_sum = [math]::Round($huawei_down_sum, 2)
    $iskratel_up_sum = $iskratel_up_sum/1024/1024
    $iskratel_up_sum = [math]::Round($iskratel_up_sum, 2)
    $iskratel_down_sum = $iskratel_down_sum/1024/1024
    $iskratel_down_sum = [math]::Round($iskratel_down_sum, 2)
    if ($bdcom_up_sum -eq 0) {
        $bdcom_up_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    } 
    else {
        $bdcom_up_sum = "$bdcom_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($bdcom_down_sum -eq 0) {
        $bdcom_down_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $bdcom_down_sum = "$bdcom_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($huawei_up_sum -eq 0) {
        $huawei_up_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $huawei_up_sum = "$huawei_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($huawei_down_sum -eq 0) {
        $huawei_down_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $huawei_down_sum = "$huawei_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($iskratel_up_sum -eq 0) {
        $iskratel_up_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $iskratel_up_sum = "$iskratel_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($iskratel_down_sum -eq 0) {
        $iskratel_down_sum = "$connection%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $iskratel_down_sum = "$iskratel_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }    
    Telegram
}

function Telegram () {
    $bot_token = "526576550:AAEYqJfKYaaGhxXRvbyIZgrzsQheCoFfbko"
    $chatid = "371175128"
    $bdcom_zagruzka = "%42%44%4f%43%4d%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $bdcom_otdacha = "%42%44%43%4f%4d%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    $huawei_zagruzka = "%48%75%61%77%65%69%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $huawei_otdacha = "%48%75%61%77%65%69%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    $iskratel_zagruzka = "%49%73%6b%72%61%74%65%6c%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $iskratel_otdacha = "%49%73%6b%72%61%74%65%6c%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    Write-Host
    Write-Host " �������� ���������..." -ForegroundColor Yellow
    #.\curl.exe -d "chat_id=$chatid&text=*%42%44%43%4f%4d%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*%20$bdcom_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%0a*%42%44%43%4f%4d%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*%20$bdcom_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%0a*%0a%48%55%41%57%45%49%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*$huawei_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a%48%55%41%57%45%49%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*$huawei_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a%0a%49%53%4b%52%41%54%45%4c%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*$iskratel_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a*%49%53%4b%52%41%54%45%4c%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*$iskratel_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    .\curl.exe -d "chat_id=$chatid&text=*$bdcom_zagruzka*$bdcom_down_sum*$bdcom_otdacha*$bdcom_up_sum*$huawei_zagruzka*$huawei_down_sum*$huawei_otdacha*$huawei_up_sum*$iskratel_zagruzka*$iskratel_down_sum*$iskratel_otdacha*$iskratel_up_sum&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    if (Select-String '"ok":true' -Path ".\response.txt") {
        Write-Host
        Write-Host " ��������� ������� ����������! ������ ��������� ;) �� ��� ���������!" -ForegroundColor Green
        Write-Host
        Read-Host -Prompt " ������� Enter ��� �����������"
        Remove-Item -Path .\*.json
        Remove-Item -Path .\*.txt
        FirstChoise
    }
    Write-Host
    Write-Host " ���... ���-�� ����� �� ���... ��������� �� ���� ���������� :(" -ForegroundColor Red
    Write-Host " ����������� �����..." -ForegroundColor Red
}

function Escape () {
    Exit
}

FirstChoise