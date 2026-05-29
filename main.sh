#!/bin/bash
# İsim SOYİSİM: Özgür Sulhan
# Öğrenci Numarası: 2420171011
# Sertifika Bağlantıları 
# 1. Docker Temelleri: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=D2xhEe6Wo0
# 2. Siber Güvenlikte Linux İşletim Sistemleri: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=AJaS70n2wJ
# 3. Linux Bash Script: https://credsverse.com/credentials/cc0038cf-de0e-422b-963a-4dd3a57b7ed1

# ISO formatında tarih/saat yazdırılarak log dosyasının oluşturulması
echo "Başlangıç: $(date +"%Y-%m-%dT%H:%M:%S%z")" > report.log

# İşletim sistemini tespit edip uygun komutları çalıştıran IF bloğu
OSTYPE=$(uname -s)

if [[ "$OSTYPE" == *"MINGW"* ]] || [[ "$OSTYPE" == *"MSYS"* ]] || [[ "$OSTYPE" == *"CYGWIN"* ]]; then
    
    echo "=== Windows Donanım Bilgileri ===" >> report.log
    
    echo "--- İşlemci Bilgisi (Marka, Model) ---" >> report.log
    wmic cpu get Name, Manufacturer >> report.log
    
    echo "--- RAM Bilgisi (Kapasite, Marka, Model/Parça No, Seri No) ---" >> report.log
    wmic memorychip get Capacity, Manufacturer, PartNumber, SerialNumber >> report.log
    
    echo "--- Anakart Bilgisi (Marka, Ürün/Model, Seri No) ---" >> report.log
    wmic baseboard get Manufacturer, Product, SerialNumber >> report.log
    
    echo "--- Anakart UUID Değeri ---" >> report.log
    wmic csproduct get UUID >> report.log
    
    echo "--- Disk Bilgisi (Kapasite, Medya Türü-SSD/HDD, Model, Seri No) ---" >> report.log
    wmic diskdrive get Size, MediaType, Model, SerialNumber >> report.log
    
    echo "--- MAC Adresi ---" >> report.log
    getmac >> report.log

elif [[ "$OSTYPE" == *"Darwin"* ]]; then
    
    echo "=== MacOS Donanım Bilgileri ===" >> report.log
    system_profiler SPHardwareDataType >> report.log
    ifconfig >> report.log
else
    echo "=== Desteklenmeyen OS ===" >> report.log
fi

# Kullanıcıdan parola isteme
echo -n "Şifreleme için parolayı giriniz: "
read PAROLA

# Kullanıcıdan alınan PAROLA değişkeniyle GPG AES256 algoritması kullanılarak arka planda şifreleme
gpg --batch --yes --passphrase "$PAROLA" --symmetric --cipher-algo AES256 -o report.log.gpg report.log

# İşlem bittiğinde orijinal (şifresiz) dosyayı kalıcı olarak silme
rm -f report.log

echo "İşlem başarıyla tamamlandı. report.log.gpg oluşturuldu ve orijinal dosya silindi."
