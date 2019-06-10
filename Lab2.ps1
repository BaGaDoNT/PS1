#1.	Просмотреть содержимое ветви реeстра HKCU
cd hkcu:\
dir
#or
Get-ChildItem HKCU:\
#2.	Создать, переименовать, удалить каталог на локальном диске
New-Item -Path 'C:\temp\ruban' -ItemType Directory
Rename-Item -Path 'C:\temp\ruban' -NewName Ruban_rename
Remove-Item -Path 'C:\temp\ruban_rename'
#3.	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой C:\M2T2_ФАМИЛИЯ.
New-Item -Path 'C:\temp\M2T2_ruban' -ItemType Directory
subst w: C:\temp\M2T2_ruban
#4.	Сохранить в текстовый файл на созданном диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
get-service | where {$_.status -eq 'running'} | Out-File 'C:\temp\M2T2_ruban\srv_run.txt'
#5.	Просуммировать все числовые значения переменных текущего сеанса.
[int]$summ = 0;
Get-Variable | Where-Object {
    if ($_.Value -is [int]){
    $summ = $summ+$_.Value 
    }
}
Write-Output ('сумма всех переменных = ' + $summ)
#6.	Вывести список из 6 процессов занимающих дольше всего процессор.
Get-Process | where {$_.CPU} |sort cpu -Descending | Select-Object -First 6
#7.	Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.
Get-Process | foreach {
    if($_.VirtualMemorySize / 1MB -gt 100) {
        Write-Host($_.Name, $_.VirtualMemorySize) -ForegroundColor red -Separator " - "
    } else {Write-Host($_.Name, $_.VirtualMemorySize) -ForegroundColor green -Separator "- "}
}
#8.	Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp
(Get-ChildItem C:\Windows\ -File -Recurse -Exclude *.tmp -ErrorAction SilentlyContinue | Measure-Object -Sum Length).Sum / 1GB
#9.	Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem HKLM:\SOFTWARE\Microsoft | Out-File 'C:\temp\M2T2_ruban\reg.csv'
#10.	Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.
Get-History | Export-Clixml C:\temp\M2T2_ruban\history.xml
#11.	Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 5 любых (выбранных Вами) свойств.
Get-ChildItem C:\temp\M2T2_ruban\history.xml | Import-Clixml | Select CommandLine,id,EndExecutionTime,ExecutionStatus
#тут что-то не так
#12.	Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ
subst w: /d
Remove-Item C:\temp\M2T2_ruban -Recurse
