#(Get-Host).UI.RawUI.BackgroundColor = “DarkMagenta”
Set-Location $PSScriptRoot
function FirstChoise () {
    Clear-Host
    Write-Host
    Write-Host " ÈÇÌÅÐÅÍÈÅ ÑÊÎÐÎÑÒÈ ÑÅÒÅÂÎÃÎ ÑÎÅÄÈÍÅÍÈß"  -ForegroundColor Yellow
    Write-Host
    Write-Host " Ìåíþ" -ForegroundColor Yellow
    Write-Host
    Write-Host " 1) Íà÷àòü òåñòèðîâàíèå ñêîðîñòè" -ForegroundColor Green
    Write-Host " 2) Ïðîäîëæèòü òåñòèðîâàíèå ñî ñëåäóþùèì ñîåäèíåíèåì" -ForegroundColor Green
    Write-Host " 3) Îòïðàâèòü ñîîáùåíèå î ðåçóëüòàòàõ â Telegram ãðóïïó" -ForegroundColor Green
    Write-Host " 4) Âûõîä" -ForegroundColor Red
    Write-Host
    $choice = Read-Host " Ââåäèòå íîìåð äåéñòâèÿ"
    Switch($choice){
        1{Connections}
        2{Connections}
        3{Json}
        4{Escape}
        default {Write-Host; Write-Host " Âû ââåëè íåâåðíûé íîìåð. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"; FirstChoise}
      }
}

function Connections () {
    Clear-Host
    Write-Host
    Write-Host " Âûáåðåòå èìÿ ñåòåâîãî ñîåäèíåíèÿ:" -ForegroundColor DarkYellow
    Write-Host
    Write-Host " 1) Huawei" -ForegroundColor Green
    Write-Host " 2) Iskratel" -ForegroundColor Green
    Write-Host " 3) BDCOM" -ForegroundColor Green
    Write-Host " 4) Âûõîä" -ForegroundColor Red
    Write-Host
    $connectoin = Read-Host " ×òî ìåðÿåì? Ââåäèòå íîìåð ñîåäèíåíèÿ"
    Switch($connectoin){
        1{$connection = "Huawei"; CheckFileExist}
        2{$connection = "Iskratel"; CheckFileExist}
        3{$connection = "BDCOM"; CheckFileExist}
        4{Escape}
        default {Write-Host; Write-Host " Âû ââåëè íåâåðíûé íîìåð. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"; Connections}
      }
}

function CheckFileExist () {
    $FileExists1 = Test-Path ".\$connection upload.json"
    $FileExists2 = Test-Path ".\$connection download.json"
    If ($FileExists1 -eq $True) {
        Write-Host
        Write-Host " Ìû ýòî óæå ìåðÿëè. Âûáåðåòå äðóãîå ïîäêëþ÷åíèå" -ForegroundColor Red
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Connections
    }
    elseif ($FileExists2 -eq $True) {
        Write-Host
        Write-Host " Ìû ýòî óæå ìåðÿëè. Âûáåðåòå äðóãîå ïîäêëþ÷åíèå" -ForegroundColor Red
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Connections
    }
    Times
}

function Times () {
    Clear-Host
    Write-Host
    $seconds = Read-Host " Ââåäèòå ïðîäîëæèòåëüíîñòü òåñòà â ñåêóíäàõ"
    $seconds = [int]::Parse($seconds)
    if ( $seconds -gt 300 ) {
        Write-Host
        Write-Host " Çà÷åì òàê äîëãî? Äàâàéòå óìåíüøèì âðåìÿ" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Times
    }
    Threads
}

function Threads () {
    Clear-Host
    Write-Host
    $stream = Read-Host " Ââåäèòå êîëè÷åñòâî îäíîâðåìåííûõ ñîåäèíåíèé ñ ñåðâåðîì"
    $stream = [int]::Parse($stream)
    if ($stream -gt 25) {
        Write-Host
        Write-Host " Âû ââåëè ñëèøêîì áîëüøîå êîëè÷åñòâî ñîåäèíåíèé. Ýòîò êîìïüþòåð ñëèøêîì ñëàáûé äëÿ òàêîãî òåñòà. Ïîïðîáóéòå óìåíüøèòü ýòî ÷èñëî." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Threads
    }
    ChoiseServer
}

function ChoiseServer () {
    Clear-Host
    Write-Host
    Write-Host " Âûáåðåòå ñåðâåð:" -ForegroundColor Yellow
    Write-Host
    Write-Host " 1) Âûáðàòü äëÿ òåñòèðîâàíèÿ ñåðâåð PING.ONLINE.NET" -ForegroundColor Green
    Write-Host " 2) Âûáðàòü äëÿ òåñòèðîâàíèÿ ñåðâåð BOUYGUES.IPERF.FR" -ForegroundColor Green
    Write-Host " 3) Âûáðàòü äëÿ òåñòèðîâàíèÿ ñåðâåð SPEEDTEST.SERVERIUS.NET" -ForegroundColor Green
    Write-Host " 4) Âåðíóòñüÿ â ïðåäûäóùåå ìåíþ" -ForegroundColor Red
    Write-Host " 5) Âûõîä â ãëàâíîå ìåíþ" -ForegroundColor Red
    Write-Host
    $choice = Read-Host " Ââåäèòå íîìåð äåéñòâèÿ"
    Switch($choice){
        1{$server = "ping.online.net"; Ports}
        2{$server = "bouygues.iperf.fr"; Ports}
        3{$server = "speedtest.serverius.net"; $port = "5002"; Test}
        4{Connections}
        5{FirstChoise}
        default {Write-Host; Write-Host " Âû ââåëè íåâåðíûé íîìåð. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"; ChoiseServer}
      }
}

function Ports () {
    Clear-Host
    Write-Host
    $port = Read-Host " Ââåäèòå íîìåð ïîðòà âûáðàííîãî ñåðâåðà (ñ 5200 äî 5209)"
    $port = [int]::Parse($port)
    if ($port -lt 5200) {
        Write-Host
        Write-Host " Âû âûáðàëè íåâåðíûé ïîðò. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Ports
    }
    elseif ($port -gt 5209) {
        Write-Host
        Write-Host " Âû âûáðàëè íåâåðíûé ïîðò. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Ports
    }
    else {
        Test
    }
}

function Test () {
    Clear-Host
    Write-Host
    Write-Host " Íà÷àëî òåñòèðîâàíèÿ èñõîäÿùåãî òðàôèêà" -ForegroundColor Yellow
    .\iperf3.exe -c $server -p $port -P $stream -t $seconds -J > "$connection upload.json"
    if (Select-String "server is busy" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!ÎØÈÁÊÀ ÑÎÅÄÈÍÅÍÈß!!! Ýòîò ñåðâåð íà äàííîì ïîðòó çàíÿò. Ïîïðîáóéòå ñíîâà (ïîìåíÿéòå ñåðâåð èëè ïîðò)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        ChoiseServer
    }
    elseif (Select-String "Connection reset by peer" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!ÎØÈÁÊÀ ÑÎÅÄÈÍÅÍÈß!!! Ýòîò ñåðâåð íà äàííîì ïîðòó çàíÿò. Ïîïðîáóéòå ñíîâà (ïîìåíÿéòå ñåðâåð èëè ïîðò)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        ChoiseServer
    }
    elseif (Select-String "unable to connect to server" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!ÍÅÒ ÑÂßÇÈ Ñ ÑÅÐÂÅÐÎÌ!!! Âîçìîæíî íà äàííîì ñåòåâîì ïîäêëþ÷åíèè" -ForegroundColor Red
        Write-Host " îòñóòñòâóåò äîñòóï ê ñåòè èíòåðíåò. Ïðîâåðüòå ñåòåâîå ïîäêëþ÷åíèå!" -ForegroundColor Red
        Write-Host
        Write-Host " Âîçìîæíûå äåéñòâèÿ:" -ForegroundColor Yellow
        Write-Host
        Write-Host " 1) Ïðîâåðèòü íàëè÷èå äîñòóïà ê ñåòè èíòåðíåò íà äàííîì ïîäêëþ÷åíèè" -ForegroundColor Green
        Write-Host " 2) Âûáðàòü äðóãîé ñåðâåð" -ForegroundColor Green
        Write-Host " 3) Ïðîïóñòèòü è âûéòè â ãëàâíîå ìåíþ" -ForegroundColor Green
        Write-Host
        $connectionerror = Read-Host " Ââåäèòå íîìåð äåéñòâèÿ"
        Switch($connectionerror) {
            1{CheckConnection}
            2{ChoiseServer}
            3{FirstChoise}
            default {Write-Host; Write-Host " Âû ââåëè íåâåðíûé íîìåð. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"; ChoiseServer}
          }
    }
    Write-Host
    Write-Host " Âûïîëíåíî!" -ForegroundColor Green
    Write-Host
    Write-Host " Íà÷àëî òåñòèðîâàíèÿ âõîäÿùåãî òðàôèêà" -ForegroundColor Yellow
    .\iperf3.exe -c $server -p $port -P $stream -t $seconds -R -J > "$connection download.json"
    if (Select-String "server is busy" -Path ".\$connection download.json") {
        Write-Host
        Write-Host " !!!ÎØÈÁÊÀ ÑÎÅÄÈÍÅÍÈß!!! Ýòîò ñåðâåð íà äàííîì ïîðòó çàíÿò. Ïîïðîáóéòå ñíîâà (ïîìåíÿéòå ñåðâåð èëè ïîðò)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        ChoiseServer
    }
    elseif (Select-String "Connection reset by peer" -Path ".\$connection download.json") {
        Write-Host
        Write-Host " !!!ÎØÈÁÊÀ ÑÎÅÄÈÍÅÍÈß!!! Ýòîò ñåðâåð íà äàííîì ïîðòó çàíÿò. Ïîïðîáóéòå ñíîâà (ïîìåíÿéòå ñåðâåð èëè ïîðò)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        ChoiseServer
    }
    elseif (Select-String "unable to connect to server" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!ÍÅÒ ÑÂßÇÈ Ñ ÑÅÐÂÅÐÎÌ!!! Âîçìîæíî íà äàííîì ñåòåâîì ïîäêëþ÷åíèè" -ForegroundColor Red
        Write-Host " îòñóòñòâóåò äîñòóï ê ñåòè èíòåðíåò. Ïðîâåðüòå ñåòåâîå ïîäêëþ÷åíèå!" -ForegroundColor Red
        Write-Host
        Write-Host " Âîçìîæíûå äåéñòâèÿ:" -ForegroundColor Yellow
        Write-Host
        Write-Host " 1) Ïðîâåðèòü íàëè÷èå äîñòóïà ê ñåòè èíòåðíåò íà äàííîì ïîäêëþ÷åíèè" -ForegroundColor Green
        Write-Host " 2) Âûáðàòü äðóãîé ñåðâåð" -ForegroundColor Green
        Write-Host " 3) Ïðîïóñòèòü è âûéòè â ãëàâíîå ìåíþ" -ForegroundColor Green
        Write-Host
        $connectionerror = Read-Host " Ââåäèòå íîìåð äåéñòâèÿ"
        Switch($connectionerror) {
            1{CheckConnection}
            2{ChoiseServer}
            3{FirstChoise}
            default {Write-Host; Write-Host " Âû ââåëè íåâåðíûé íîìåð. Ïîïðîáóéòå ñíîâà." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"; ChoiseServer}
          }
    }
    Write-Host
    Write-Host " Âûïîëíåíî!" -ForegroundColor Green
    Write-Host
    Write-Host " Òåñòèðîâàíèå $connection âûïîëíåíî óñïåøíî!" -ForegroundColor Green
    Write-Host
    Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
    FirstChoise
}

function CheckConnection () {
    Clear-Host
    Write-Host
    Write-Host " Ïðîâåðÿåì íàëè÷èå äîñòóïà ê ñåòè èíòåðíåò ñ ïîìîùüþ Google è Yandex..." -ForegroundColor Yellow
    $internetaccess = Test-Connection -ComputerName 8.8.8.8,77.88.8.8 -Quiet
     if ($internetaccess -eq $False) {
         Write-Host
         Write-Host " !!!ÀÕÒÓÍÃ!!! Íà äàííîì ïîäêëþ÷åíèè îòñóòñòâóåò ñâÿçü ñ èòåðíåòîì!" -ForegroundColor Red
         Write-Host
         Write-Host " Âûõîäèì â ãëàâíîå ìåíþ..."
         Write-Host
         Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
         FirstChoise
     }
    Write-Host
    Write-Host " Íà äàííîì ïîäêëþ÷åíèè ñ èòðåðíåòîì âñå â ïîðÿäêå." -ForegroundColor Green
    Write-Host " Ïîïðîáóéòå âûáðàòü äðóãîé ñåðâåð äëÿ òåñòèðîâàíèÿ." -ForegroundColor Green
    Write-Host
    Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
    ChoiseServer
}

function Json () {
    Clear-Host
    Write-Host
    Write-Host " Ôîðìèðóåì äàííûå äëÿ îòïðàâêè ñîîáùåíèÿ..." -ForegroundColor Yellow
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
    Write-Host " Îòïðàâêà ñîîáùåíèÿ..." -ForegroundColor Yellow
    #.\curl.exe -d "chat_id=$chatid&text=*%42%44%43%4f%4d%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*%20$bdcom_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%0a*%42%44%43%4f%4d%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*%20$bdcom_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%0a*%0a%48%55%41%57%45%49%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*$huawei_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a%48%55%41%57%45%49%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*$huawei_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a%0a%49%53%4b%52%41%54%45%4c%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*$iskratel_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a*%49%53%4b%52%41%54%45%4c%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*$iskratel_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    .\curl.exe -d "chat_id=$chatid&text=*$bdcom_zagruzka*$bdcom_down_sum*$bdcom_otdacha*$bdcom_up_sum*$huawei_zagruzka*$huawei_down_sum*$huawei_otdacha*$huawei_up_sum*$iskratel_zagruzka*$iskratel_down_sum*$iskratel_otdacha*$iskratel_up_sum&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    if (Select-String '"ok":true' -Path ".\response.txt") {
        Write-Host
        Write-Host " Ñîîáùåíèå óñïåøíî îòïðàâëåíî! Ìîæåòå îòäîõíóòü ;) Âû ýòî çàñëóæèëè!" -ForegroundColor Green
        Write-Host
        Read-Host -Prompt " Íàæìèòå Enter äëÿ ïðîäîëæåíèÿ"
        Remove-Item -Path .\*.json
        Remove-Item -Path .\*.txt
        FirstChoise
    }
    Write-Host
    Write-Host " Óïñ... ×òî-òî ïîøëî íå òàê... ñîîáùåíèå íå áûëî îòïðàâëåíî :(" -ForegroundColor Red
    Write-Host " Ïîïûòàéòåñü ïîçæå..." -ForegroundColor Red
}

function Escape () {
    Exit
}

FirstChoise
