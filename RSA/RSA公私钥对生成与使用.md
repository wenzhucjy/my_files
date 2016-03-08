
RSA公私钥对生成与使用

	生成商户公私钥对
	1.  打开openssl密钥生成软件
	打开 openssl 文件夹下的 bin 文件夹，执行 openssl.exe 文件
	2.  生成PKCS#1编码的RSA私钥
	输入“genrsa -out rsa_private_key.pem 1024”命令，回车后，在当前 bin 文件目录中会新增一个 rsa_private_key.pem 文件，其文件为原始的商户私钥
  >密钥文件最终将数据通过Base64编码进行存储。可以看到上述密钥文件内容每一行的长度都很规律。这是由于RFC2045中规定：The encoded output stream must be represented in lines of no more than 76 characters each。也就是说Base64编码的数据每行最多不超过76字符，对于超长数据需要按行分割。

	3.  生成PKCS#8编码的RSA公钥
	输入“rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem”命令回车后，在当前 bin 文件目录中会新增一个 rsa_public_key.pem 文件，其文件为原始的商户公钥
	4.  生成PKCS#8编码的私钥
	输入命令“pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt” 或 “pkcs8 -topk8 -in rsa_private_key.pem -out pkcs8_rsa_private_key.pem -nocrypt”


	RSA 密钥使用逻辑：
	商户在使用 RSA 签名方式的接口时，真正会用到的密钥是商户私钥与第三方接口公钥。商户上传公钥给第三方接口，第三方接口把公钥给商户，是公钥互换的操作。这就
	使得商户使用自己的私钥做签名时，第三方接口会根据商户上传的公钥做验证签名。
	商户使用第三方接口公钥做验证签名时， 同理， 也是因为第三方接口用自己的私钥做了签名。
