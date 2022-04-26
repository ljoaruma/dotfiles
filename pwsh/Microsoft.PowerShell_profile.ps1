#Remove-Module PSReadLine

Set-PSReadlineOption -EditMode Emacs

# profile.ps1 配置場所
# PowerShell上でecho $PROFILE

# 自己証明書による署名手順
## 自己証明書の作成
## $cert = New-SelfSignedCertificate -Subject "CN=CodeSigningForPS"` -KeyAlgorithm RSA -KeyLength 2048 -Type CodeSigningCert ` -CertStoreLocation "Cert:\CurrentUser\My"
## 信頼されたルート証明機関に移動
## Move-Item "Cert:\CurrentUser\My\$($Cert.Thumbprint)" Cert:\CurrentUser\Root
# 署名
## 署名に使用する証明書取得
## $Cert = Get-ChildItem Cert:\CurrentUser\Root | ? {$_.Subject -eq "CN=CodeSigningForPS"}
## 署名
## Set-AuthenticodeSignature -Cert $Cert -Filepath $PROFILE

# 不要になった署名は以下のコマンドで管理プログラムを起動し、削除
# certmgr.msc

