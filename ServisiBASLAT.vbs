'******************************************************************
' GoodbyeDPI Otomatik Başlatıcı
' Bu script zararsızdır ve sadece internet erişimini iyileştirmek için kullanılır
'******************************************************************

Option Explicit

'------------------------------------------------------------------
' BU PROGRAM NE YAPAR?
' 1. GoodbyeDPI programını arka planda çalıştırır
' 2. Otomatik olarak yönetici yetkisiyle başlatır
' 3. Windows başlangıcında otomatik çalışması için ayarlar
'------------------------------------------------------------------

'------------------------------------------------------------------
' GÜVENLİK NOTU:
' Bu script tamamen güvenlidir ve sisteminize zarar vermez
' Kaynak kodları açıktır
' İsterseniz Windows başlangıcından kaldırabilirsiniz
'------------------------------------------------------------------

Dim WshShell, fso, shellApp
Dim scriptFolder, exePath, arguments
Dim strStartup, oShellLink

' CreateObject’ler
Set WshShell  = CreateObject("WScript.Shell")
Set fso       = CreateObject("Scripting.FileSystemObject")
Set shellApp  = CreateObject("Shell.Application")

' 1) Script’in çalıştığı klasörü tespit et
scriptFolder = fso.GetParentFolderName(WScript.ScriptFullName)

' 2) x86_64 içindeki goodbyedpi.exe’nin tam yolunu oluştur
exePath = fso.BuildPath(scriptFolder & "\x86_64", "goodbyedpi.exe")

' 3) Komut satırı argümanları
arguments = "-5 --dns-addr 77.88.8.8 --dns-port 1253 --dnsv6-addr 2a02:6b8::feed:0ff --dnsv6-port 1253"

' 4) Yönetici (UAC) onayı isteyerek arka planda çalıştır
shellApp.ShellExecute exePath, arguments, "", "runas", 0

'------------------------------------------------------------------
' Windows başlangıcına kısayol ekleme
'------------------------------------------------------------------

strStartup = WshShell.SpecialFolders("Startup")

' Eğer zaten ekli değilse, script’i başlangıca kısayol olarak kaydet
If Not fso.FileExists(strStartup & "\GoodbyeDPI.lnk") Then
    Set oShellLink = WshShell.CreateShortcut(strStartup & "\GoodbyeDPI.lnk")
    oShellLink.TargetPath = WScript.ScriptFullName
    oShellLink.WorkingDirectory = scriptFolder
    oShellLink.Description = "GoodbyeDPI Otomatik Başlatıcı"
    oShellLink.Save
    
    MsgBox "GoodbyeDPI başarıyla başlangıca eklendi!" & vbCrLf & vbCrLf & _
           "Her açılışta otomatik olarak çalışacaktır.", 64, "Bilgi"
End If

'------------------------------------------------------------------
' NASIL KALDIRILIR?
' 1. Windows + R tuşlarına basın
' 2. shell:startup yazıp Enter'a basın
' 3. Açılan klasörden 'GoodbyeDPI.lnk' dosyasını silin
'------------------------------------------------------------------

'------------------------------------------------------------------
' SORUN GİDERME:
' - Eğer çalışmıyorsa script’i sağ tıklayıp 'Yönetici olarak çalıştır' seçin
' - Hata alırsanız x86_64 klasörünün ve goodbyedpi.exe’nin script klasöründe olduğundan emin olun
' - Sorular için: discord.gg/cortexbot
'------------------------------------------------------------------