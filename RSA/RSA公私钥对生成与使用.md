
RSA公私钥对生成与使用
	
	生成商户公私钥对
	1.  打开openssl密钥生成软件
	打开 openssl 文件夹下的 bin 文件夹，执行 openssl.exe 文件
	2.  生成RSA私钥
	输入“genrsa -out rsa_private_key.pem 1024”命令，回车后，在当前 bin 文件目录中会新增一个 rsa_private_key.pem 文件，其文件为原始的商户私钥
	3.  生成RSA公钥
	输入“rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem”命令回车后，在当前 bin 文件目录中会新增一个 rsa_public_key.pem 文件，其文件为原始的商户公钥
	4.  生成PKCS8 编码的私钥
	输入命令“pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt” 或 “pkcs8 -topk8 -in rsa_private_key.pem -out pkcs8_rsa_private_key.pem -nocrypt”


	RSA 密钥使用逻辑：
	商户在使用 RSA 签名方式的接口时，真正会用到的密钥是商户私钥与第三方接口公钥。商户上传公钥给第三方接口，第三方接口把公钥给商户，是公钥互换的操作。这就
	使得商户使用自己的私钥做签名时，第三方接口会根据商户上传的公钥做验证签名。
	商户使用第三方接口公钥做验证签名时， 同理， 也是因为第三方接口用自己的私钥做了签名。