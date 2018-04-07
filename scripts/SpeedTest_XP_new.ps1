#(Get-Host).UI.RawUI.BackgroundColor = “DarkMagenta”
#Set-Location $PSScriptRoot
$posh = Get-WmiObject win32_process | Where-Object {$_.name -eq "powershell.exe" -and $_.Processid -ne $pid} | Select-Object CommandLine
if ($posh -match "SpeedTest_XP_new.ps1") {Stop-Process -Id $pid} elseif ($posh -match "SpeedTest_XP_auto.ps1") {Write-Host; Write-Host "Будте внимательны! В данный момент скрипт также работает в автоматическом скрытом режиме."; Read-Host -Prompt " Нажмите Enter для продолжения"}

Set-Location c:\iperf

function FirstChoise () {
    Clear-Host
    Write-Host
    Write-Host " ИЗМЕРЕНИЕ СКОРОСТИ СЕТЕВОГО СОЕДИНЕНИЯ"  -ForegroundColor Yellow
    Write-Host
    Write-Host " Меню" -ForegroundColor Yellow
    Write-Host
    Write-Host " 1) Начать тестирование скорости" -ForegroundColor Green
    Write-Host " 2) Продолжить тестирование со следующим соединением" -ForegroundColor Green
    Write-Host " 3) Отправить сообщение о результатах в Telegram группу" -ForegroundColor Green
    Write-Host " 4) Выход" -ForegroundColor Red
    Write-Host
    $choice = Read-Host " Введите номер действия"
    Switch($choice){
        1{Connections}
        2{Connections}
        3{Json}
        4{Escape}
        default {Write-Host; Write-Host " Вы ввели неверный номер. Попробуйте снова." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Нажмите Enter для продолжения"; FirstChoise}
      }
}

function Connections () {
    Clear-Host
    Write-Host
    Write-Host " Выберете имя сетевого соединения:" -ForegroundColor DarkYellow
    Write-Host
    Write-Host " 1) Huawei" -ForegroundColor Green
    Write-Host " 2) Iskratel" -ForegroundColor Green
    Write-Host " 3) BDCOM" -ForegroundColor Green
    Write-Host " 4) Выход" -ForegroundColor Red
    Write-Host
    $connectoin = Read-Host " Что меряем? Введите номер соединения"
    $bdcom_network = "@PCI\VEN_1106&DEV_3065&SUBSYS_30651849&REV_78\3&267A616A&0&90"
    $huawei_network = "@PCI\VEN_10EC&DEV_8139&SUBSYS_813910EC&REV_10\3&267A616A&0&58"
    $iskratel_network = "@PCI\VEN_1106&DEV_3106&SUBSYS_14051186&REV_8B\3&267A616A&0&48"
    Switch($connectoin){
        1{$connection = "Huawei"; devcon disable $bdcom_network; devcon disable $iskratel_network; devcon enable $huawei_network; CheckFileExist}
        2{$connection = "Iskratel"; devcon disable $bdcom_network; devcon disable $huawei_network; devcon enable $iskratel_network; CheckFileExist}
        3{$connection = "BDCOM"; devcon disable $huawei_network; devcon disable $iskratel_network; devcon enable $bdcom_network; CheckFileExist}
        4{Escape}
        default {Write-Host; Write-Host " Вы ввели неверный номер. Попробуйте снова." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Нажмите Enter для продолжения"; Connections}
      }
}

function CheckFileExist () {
    $FileExists1 = Test-Path ".\$connection upload.json"
    $FileExists2 = Test-Path ".\$connection download.json"
    If ($FileExists1 -eq $True) {
        Write-Host
        Write-Host " Мы это уже меряли. Выберете другое подключение" -ForegroundColor Red
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Connections
    }
    elseif ($FileExists2 -eq $True) {
        Write-Host
        Write-Host " Мы это уже меряли. Выберете другое подключение" -ForegroundColor Red
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Connections
    }
    Times
}

function Times () {
    Clear-Host
    Write-Host
    $seconds = Read-Host " Введите продолжительность теста в секундах"
    $seconds = [int]::Parse($seconds)
    if ( $seconds -gt 300 ) {
        Write-Host
        Write-Host " Зачем так долго? Давайте уменьшим время" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Times
    }
    Threads
}

function Threads () {
    Clear-Host
    Write-Host
    $stream = Read-Host " Введите количество одновременных соединений с сервером"
    $stream = [int]::Parse($stream)
    if ($stream -gt 25) {
        Write-Host
        Write-Host " Вы ввели слишком большое количество соединений. Этот компьютер слишком слабый для такого теста. Попробуйте уменьшить это число." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Threads
    }
    ChoiseServer
}

function ChoiseServer () {
    Clear-Host
    Write-Host
    Write-Host " Выберете сервер:" -ForegroundColor Yellow
    Write-Host
    Write-Host " 1) Выбрать для тестирования сервер PING.ONLINE.NET" -ForegroundColor Green
    Write-Host " 2) Выбрать для тестирования сервер BOUYGUES.IPERF.FR" -ForegroundColor Green
    Write-Host " 3) Выбрать для тестирования сервер SPEEDTEST.SERVERIUS.NET" -ForegroundColor Green
    Write-Host " 4) Вернутсья в предыдущее меню" -ForegroundColor Red
    Write-Host " 5) Выход в главное меню" -ForegroundColor Red
    Write-Host
    $choice = Read-Host " Введите номер действия"
    Switch($choice){
        1{$server = "ping.online.net"; Ports}
        2{$server = "bouygues.iperf.fr"; Ports}
        3{$server = "speedtest.serverius.net"; $port = "5002"; Test}
        4{Connections}
        5{FirstChoise}
        default {Write-Host; Write-Host " Вы ввели неверный номер. Попробуйте снова." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Нажмите Enter для продолжения"; ChoiseServer}
      }
}

function Ports () {
    Clear-Host
    Write-Host
    $port = Read-Host " Введите номер порта выбранного сервера (с 5200 до 5209)"
    $port = [int]::Parse($port)
    if ($port -lt 5200) {
        Write-Host
        Write-Host " Вы выбрали неверный порт. Попробуйте снова." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Ports
    }
    elseif ($port -gt 5209) {
        Write-Host
        Write-Host " Вы выбрали неверный порт. Попробуйте снова." -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Ports
    }
    else {
        Test
    }
}

function Test () {
    Clear-Host
    Write-Host
    Write-Host " Начало тестирования исходящего трафика" -ForegroundColor Yellow
    .\iperf3.exe -c $server -p $port -P $stream -t $seconds -J > "$connection upload.json"
    if (Select-String "server is busy" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!ОШИБКА СОЕДИНЕНИЯ!!! Этот сервер на данном порту занят. Попробуйте снова (поменяйте сервер или порт)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        ChoiseServer
    }
    elseif (Select-String "Connection reset by peer" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!ОШИБКА СОЕДИНЕНИЯ!!! Этот сервер на данном порту занят. Попробуйте снова (поменяйте сервер или порт)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        ChoiseServer
    }
    elseif (Select-String "unable to connect to server" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!НЕТ СВЯЗИ С СЕРВЕРОМ!!! Возможно на данном сетевом подключении" -ForegroundColor Red
        Write-Host " отсутствует доступ к сети интернет. Проверьте сетевое подключение!" -ForegroundColor Red
        Write-Host
        Write-Host " Возможные действия:" -ForegroundColor Yellow
        Write-Host
        Write-Host " 1) Проверить наличие доступа к сети интернет на данном подключении" -ForegroundColor Green
        Write-Host " 2) Выбрать другой сервер" -ForegroundColor Green
        Write-Host " 3) Пропустить и выйти в главное меню" -ForegroundColor Green
        Write-Host
        $connectionerror = Read-Host " Введите номер действия"
        Switch($connectionerror) {
            1{CheckConnection}
            2{ChoiseServer}
            3{FirstChoise}
            default {Write-Host; Write-Host " Вы ввели неверный номер. Попробуйте снова." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Нажмите Enter для продолжения"; ChoiseServer}
          }
    }
    Write-Host
    Write-Host " Выполнено!" -ForegroundColor Green
    Write-Host
    Write-Host " Начало тестирования входящего трафика" -ForegroundColor Yellow
    .\iperf3.exe -c $server -p $port -P $stream -t $seconds -R -J > "$connection download.json"
    if (Select-String "server is busy" -Path ".\$connection download.json") {
        Write-Host
        Write-Host " !!!ОШИБКА СОЕДИНЕНИЯ!!! Этот сервер на данном порту занят. Попробуйте снова (поменяйте сервер или порт)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        ChoiseServer
    }
    elseif (Select-String "Connection reset by peer" -Path ".\$connection download.json") {
        Write-Host
        Write-Host " !!!ОШИБКА СОЕДИНЕНИЯ!!! Этот сервер на данном порту занят. Попробуйте снова (поменяйте сервер или порт)" -ForegroundColor Red
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        ChoiseServer
    }
    elseif (Select-String "unable to connect to server" -Path ".\$connection upload.json") {
        Write-Host
        Write-Host " !!!НЕТ СВЯЗИ С СЕРВЕРОМ!!! Возможно на данном сетевом подключении" -ForegroundColor Red
        Write-Host " отсутствует доступ к сети интернет. Проверьте сетевое подключение!" -ForegroundColor Red
        Write-Host
        Write-Host " Возможные действия:" -ForegroundColor Yellow
        Write-Host
        Write-Host " 1) Проверить наличие доступа к сети интернет на данном подключении" -ForegroundColor Green
        Write-Host " 2) Выбрать другой сервер" -ForegroundColor Green
        Write-Host " 3) Пропустить и выйти в главное меню" -ForegroundColor Green
        Write-Host
        $connectionerror = Read-Host " Введите номер действия"
        Switch($connectionerror) {
            1{CheckConnection}
            2{ChoiseServer}
            3{FirstChoise}
            default {Write-Host; Write-Host " Вы ввели неверный номер. Попробуйте снова." -ForegroundColor Red; Write-Host; Read-Host -Prompt " Нажмите Enter для продолжения"; ChoiseServer}
          }
    }
    Write-Host
    Write-Host " Выполнено!" -ForegroundColor Green
    Write-Host
    Write-Host " Тестирование $connection выполнено успешно!" -ForegroundColor Green
    Write-Host
    Read-Host -Prompt " Нажмите Enter для продолжения"
    FirstChoise
}

function CheckConnection () {
    Clear-Host
    Write-Host
    Write-Host " Проверяем наличие доступа к сети интернет с помощью Google и Yandex..." -ForegroundColor Yellow
    $internetaccess = Test-Connection -ComputerName 8.8.8.8,77.88.8.8 -Quiet
     if ($internetaccess -eq $False) {
         Write-Host
         Write-Host " !!!АХТУНГ!!! На данном подключении отсутствует связь с итернетом!" -ForegroundColor Red
         Write-Host
         Write-Host " Выходим в главное меню..."
         Write-Host
         Read-Host -Prompt " Нажмите Enter для продолжения"
         FirstChoise
     }
    Write-Host
    Write-Host " На данном подключении с итрернетом все в порядке." -ForegroundColor Green
    Write-Host " Попробуйте выбрать другой сервер для тестирования." -ForegroundColor Green
    Write-Host
    Read-Host -Prompt " Нажмите Enter для продолжения"
    ChoiseServer
}

function Json () {
    Clear-Host
    Write-Host
    Write-Host " Формируем данные для отправки сообщения..." -ForegroundColor Yellow
    $bdcom_up = Get-Content ".\BDCOM upload.json" | .\jq '.end.sum_sent.bits_per_second'
    $bdcom_down = Get-Content ".\BDCOM download.json" | .\jq '.end.sum_sent.bits_per_second'
    $huawei_up = Get-Content ".\Huawei upload.json" | .\jq '.end.sum_sent.bits_per_second'
    $huawei_down = Get-Content ".\Huawei download.json" | .\jq '.end.sum_sent.bits_per_second'
    $iskratel_up = Get-Content ".\Iskratel upload.json" | .\jq '.end.sum_sent.bits_per_second'
    $iskratel_down = Get-Content ".\Iskratel download.json" | .\jq '.end.sum_sent.bits_per_second'
    $bdcom_up_sum = $bdcom_up/1024/1024
    $bdcom_up_sum = [math]::Round($bdcom_up_sum, 2)
    $bdcom_down_sum = $bdcom_down/1024/1024
    $bdcom_down_sum = [math]::Round($bdcom_down_sum, 2)
    $huawei_up_sum = $huawei_up/1024/1024
    $huawei_up_sum = [math]::Round($huawei_up_sum, 2)
    $huawei_down_sum = $huawei_down/1024/1024
    $huawei_down_sum = [math]::Round($huawei_down_sum, 2)
    $iskratel_up_sum = $iskratel_up/1024/1024
    $iskratel_up_sum = [math]::Round($iskratel_up_sum, 2)
    $iskratel_down_sum = $iskratel_down/1024/1024
    $iskratel_down_sum = [math]::Round($iskratel_down_sum, 2)
    if ($bdcom_up_sum -eq 0) {
        $bdcom_up_sum = "%42%44%43%4f%4d%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    } 
    else {
        $bdcom_up_sum = "$bdcom_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($bdcom_down_sum -eq 0) {
        $bdcom_down_sum = "%42%44%43%4f%4d%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $bdcom_down_sum = "$bdcom_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($huawei_up_sum -eq 0) {
        $huawei_up_sum = "%48%75%61%77%65%69%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $huawei_up_sum = "$huawei_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($huawei_down_sum -eq 0) {
        $huawei_down_sum = "%48%75%61%77%65%69%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $huawei_down_sum = "$huawei_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($iskratel_up_sum -eq 0) {
        $iskratel_up_sum = "%49%73%6b%72%61%74%65%6c%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $iskratel_up_sum = "$iskratel_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }
    if ($iskratel_down_sum -eq 0) {
        $iskratel_down_sum = "%49%73%6b%72%61%74%65%6c%20%d0%bd%d0%b5%20%d0%bc%d0%b5%d1%80%d1%8f%d0%b5%d1%82%d1%81%d1%8f%21%0a"
    }
    else {
        $iskratel_down_sum = "$iskratel_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%5c%d1%81%0a"
    }    
    Telegram
}

function Telegram () {
    $bot_token = "526576550:AAEYqJfKYaaGhxXRvbyIZgrzsQheCoFfbko"
    $chatid = "-256698582"
    #$chatid = "371175128"
    $speed = "%d0%98%d0%b7%d0%bc%d0%b5%d1%80%d0%b5%d0%bd%d0%b8%d0%b5%20%d1%81%d0%ba%d0%be%d1%80%d0%be%d1%81%d1%82%d0%b8%20%d0%b8%d0%bd%d1%82%d0%b5%d1%80%d0%bd%d0%b5%d1%82%20%d1%81%d0%be%d0%b5%d0%b4%d0%b8%d0%bd%d0%b5%d0%bd%d0%b8%d0%b9%0a%0a"
    $bdcom_zagruzka = "%42%44%43%4f%4d%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $bdcom_otdacha = "%42%44%43%4f%4d%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    $huawei_zagruzka = "%48%75%61%77%65%69%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $huawei_otdacha = "%48%75%61%77%65%69%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    $iskratel_zagruzka = "%49%73%6b%72%61%74%65%6c%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a%20"
    $iskratel_otdacha = "%49%73%6b%72%61%74%65%6c%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a%20"
    Write-Host
    Write-Host " Отправка сообщения..." -ForegroundColor Yellow
    #.\curl.exe -d "chat_id=$chatid&text=*%42%44%43%4f%4d%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*%20$bdcom_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%0a*%42%44%43%4f%4d%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*%20$bdcom_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%0a*%0a%48%55%41%57%45%49%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*$huawei_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a%48%55%41%57%45%49%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*$huawei_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a%0a%49%53%4b%52%41%54%45%4c%20%d0%b7%d0%b0%d0%b3%d1%80%d1%83%d0%b7%d0%ba%d0%b0%3a*$iskratel_down_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81%20%0a*%49%53%4b%52%41%54%45%4c%20%d0%be%d1%82%d0%b4%d0%b0%d1%87%d0%b0%3a*$iskratel_up_sum%20%d0%9c%d0%b1%d0%b8%d1%82%2f%d1%81&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    .\curl.exe -d "chat_id=$chatid&text=*$speed**$bdcom_zagruzka*$bdcom_down_sum*$bdcom_otdacha*$bdcom_up_sum*$huawei_zagruzka*$huawei_down_sum*$huawei_otdacha*$huawei_up_sum*$iskratel_zagruzka*$iskratel_down_sum*$iskratel_otdacha*$iskratel_up_sum&parse_mode=markdown" https://api.telegram.org/bot$bot_token/sendMessage -k > response.txt
    if (Select-String '"ok":true' -Path ".\response.txt") {
        Write-Host
        Write-Host " Сообщение успешно отправлено! Можете отдохнуть ;) Вы это заслужили!" -ForegroundColor Green
        Write-Host
        Read-Host -Prompt " Нажмите Enter для продолжения"
        Remove-Item -Path .\*.json
        Remove-Item -Path .\*.txt
        FirstChoise
    }
    Write-Host
    Write-Host " Упс... Что-то пошло не так... сообщение не было отправлено :(" -ForegroundColor Red
    Write-Host " Попытайтесь позже..." -ForegroundColor Red
}

function Escape () {
    Exit
}

FirstChoise