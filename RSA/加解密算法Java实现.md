### 加解密算法Java实现


>JDK相关包及第三方扩展
>>Java安全组成：JCA（Java安全体系结构）、JCE（Java加密的扩展包）、JSSE（Java安全套接字扩展包）、JAAS（Java鉴别与安全服务）

>>DES/AES/RSA算法通过JCE提供、JSSE提供基于SSL的加密功能，主要用于网络传输、身份验证由JAAS提供

| 包名     | 描述     |
| :------------- | :------------- |
|java.security   |     消息摘要|
|javax.crypto    |      安全消息摘要，消息认证（鉴别）码|
|java.net.ssl    |       安全套接字，如 HttpsURLConnection/SSLContext|

>第三方扩展

| 包名     | 描述     |
| :------------- | :------------- |
|Bouncy Castle   |  两种支持方案：1）配置、2）调用|
| Common Codec   |   Apache提供，Base64、二进制、十六进制、字符集编码，URL编码/解码|

#### 1. 编解码
##### 1.1 Base64

>`Base64`是一种基于64个可打印字符来表示二进制数据的表示方法，默认方法结果不换行。根据`RFC 822`规定，每76个字符，需要加上一个回车换行，源码如下：

```java
/**
    * Encodes binary data using the base64 algorithm and chunks the encoded output into 76 character blocks
    *
    * @param binaryData
    *            binary data to encode
    * @return Base64 characters chunked in 76 character blocks
    */
   public static byte[] encodeBase64Chunked(final byte[] binaryData) {
       return encodeBase64(binaryData, true);
   }
   ...
```

>算法实现： `JDK、Common Codec、Bouncy Castle`

>应用场景： E-mail、密钥、证书文件等


##### 1.2 URLEncode/URLDecode
>服务端算法实现 `java.net.URLDecoder` 与 `java.net.URLEncoder`

>页面端算法实现 `window.decodeURIComponent(param)` 与 `window.encodeURIComponent(param)`


#### 2. 散列函数的相关算法

>迪菲－赫尔曼密钥交换（Diffie–Hellman key exchange，简称“D–H”） 是一种安全协议，它可以让双方在完全没有对方任何预先信息的条件下通过不安全信道建立起一个密钥，这个密钥可以在后续的通讯中作为对称密钥来加密通讯内容

##### 2.1 几种消息摘要算法简介

>消息摘要算法`MD`（Message Digest Algorithm） (md2,md4,md5) 128位

>>加密算法MD5：以512位分组来处理输入的信息，且每一分组又被划分为16个32位子分组，经过了一系列的处理后，输出由四个32位分组组成，将这四个32位分组级联后将生成一个128位散列值。

>`MD5`算法实现：`Common Codec DigestUtils`

```java
   /**
     * Calculates the MD5 digest and returns the value as a 32 character hex string.
     *
     * @param data
     *            Data to digest
     * @return MD5 digest as a hex string
     */
    public static String md5Hex(final byte[] data) {
        return Hex.encodeHexString(md5(data));
    }
    ...
```

>安全散列算法`SHA`（Secure Hash Algorithm）(sha1,sha2)
>>安全散列算法SHA：接收一段明文，然后以一种不可逆的方式将它转换成一段（通常更小）密文，也可以简单的理解为取一串输入码（称为预映射或信息），并把它们转化为长度较短、位数固定的输出序列即散列值（也称为信息摘要或信息认证代码）的过程。

>消息认证码算法`MAC`(Message Authentication Code)

应用场景
>`MD`可以用于用户登录密码的加密

>`SHA`应用加入约定key、增加时间戳、排序

#### 3.对称加密算法
>采用单钥密码系统的加密方法，同一个密钥可以同时用作信息的加密和解密，这种加密方法称为对称加密，也称为单密钥加密。

>需要对加密和解密使用相同密钥的加密算法。由于其速度快，对称性加密通常在消息发送方需要加密大量数据时使用。对称性加密也称为密钥加密。

>所谓对称，就是采用这种加密方法的双方使用方式用同样的密钥进行加密和解密。密钥是控制加密及解密过程的指令。算法是一组规则，规定如何进行加密和解密。


>常用的对称加密有：`DES、IDEA、RC2、RC4、SKIPJACK、RC5、AES`算法等

##### 3.1 DES
>数据加密标准DES：把64位的明文输入块变为64位的密文输出块，它所使用的密钥也是64位，主要分为两步：
>>（1）初始置换，把输入的64位数据块按位重新组合，并把输出分为L0、R0两部分，每部分各长32位，其置换规则为将输入的第58位换到第一位，第50位换到第2位......依此类推，最后一位是原来的第7位。L0、R0则是换位输出后的两部分，L0是输出的左32位，R0是右32位。

>>（2）逆置换，经过16次迭代运算后，得到L16、R16,将此作为输入，进行逆置换，逆置换正好是初始置换的逆运算，由此即得到密文输出。

>3-DES：使用3条56位的密钥对数据进行三次加密，是DES向AES过渡的加密算法（1999年，NIST将3-DES指定为过渡的加密标准）。

##### 3.2 AES
>密码学中的高级加密标准（Advanced Encryption Standard，AES），又称高级加密标准Rijndael加密法，是美国联邦政府采用的一种区块加密标准。这个标准用来替代原先的DES，已经被多方分析且广为全世界所使用。经过五年的甄选流程，高级加密标准由美国国家标准与技术研究院 （NIST）于2001年11月26日发布于FIPS PUB 197，并在2002年5月26日成为有效的标准。2006年，高级加密标准已然成为对称密钥加密中最流行的算法之一。

>AES的基本要求是，采用对称分组密码体制，密钥长度的最少支持为128、192、256，分组长度128位，算法应易于各种硬件和软件实现。与其说这是一种加密算法，倒不如称其为文件信息的简单变换，将每一个数据与某给定数据进行异或操作即可完成加密或解密，如dataEncrypt = dataSource^dataSecret。

>AES加密数据块分组长度必须为128比特，密钥长度可以是128比特、192比特、256比特中的任意一个（如果数据块及密钥长度不足时，会补齐）。AES加密有很多轮的重复和变换。大致步骤如下：
>>1、密钥扩展（KeyExpansion）

>>2、初始轮（Initial Round）

>>3、重复轮（Rounds），每一轮又包括：SubBytes、ShiftRows、MixColumns、AddRoundKey

>>4、最终轮（Final Round），最终轮没有MixColumns

>ECB(Electronic Code Book电子密码本)模式
>>ECB模式是最早采用和最简单的模式，它将加密的数据分成若干组，每组的大小跟加密密钥长度相同，然后每组都用相同的密钥进行加密。
>>>优点:   1.简单；   2.有利于并行计算；  3.误差不会被扩散；

>>>缺点:   1.不能隐藏明文的模式；  2.可能对明文进行主动攻击；

>>因此，此模式适于加密小消息。

>CBC(Cipher Block Chaining，加密块链)模式
>>优点：  不容易主动攻击,安全性好于ECB,适合传输长度长的报文,是SSL、IPSec的标准。

>>缺点：  1.不利于并行计算；  2.误差传递；  3.需要初始化向量IV

>CFB(Cipher FeedBack Mode，加密反馈)模式
>>优点：1.隐藏了明文模式;  2.分组密码转化为流模式;  3.可以及时加密传送小于分组的数据;

>>缺点:  1.不利于并行计算;  2.误差传送：一个明文单元损坏影响多个单元;  3.唯一的IV;

>OFB(Output FeedBack，输出反馈)模式
>>优点:  1.隐藏了明文模式;  2.分组密码转化为流模式;  3.可以及时加密传送小于分组的数据;

>>缺点:  1.不利于并行计算;  2.对明文的主动攻击是可能的;  3.误差传送：一个明文单元损坏影响多个单元

#### 4. 非对称加密算法

>(CA机构，即证书授权中心(Certificate Authority )，或称证书授权机构)来担保非对称性加密数据传输的安全性问题。

>非对称加密非对称加密算法需要两个密钥：公开密钥（publickey）和私有密钥（privatekey）。公开密钥与私有密钥是一对，如果用公开密钥对数据进行加密，只有用对应的私有密钥才能解密；如果用私有密钥对数据进行加密，那么只有用对应的公开密钥才能解密。因为加密和解密使用的是两个不同的密钥，这种算法叫作非对称加密算法。

>非对称加密算法实现机密信息交换的基本过程是：甲方生成一对密钥并将其中的一把作为公用密钥向其它方公开；得到该公用密钥的乙方使用该密钥对机密信息进行加密后再发送给甲方；甲方再用自己保存的另一把专用密钥对加密后的信息进行解密。另一方面，甲方可以使用乙方的公钥对机密信息进行签名后再发送给乙方；乙方再用自己的私匙对数据进行验签。


##### 4.1 几种非对称加密算法

>数字签名：带有密钥（公钥，私钥）的消息摘要算法，私钥签名，公钥验证，验证数据完整性，认证数据来源，抗否认

>RSA
>>使用最广泛的数字签名算法，`MD5WithRSA`、`SHA1WithRSA` 两类

>DSA
>>DSS，数字签名标准，仅包含数字签名

>ECDSA（jdk1.7+）
>>微软，椭圆曲线数字签名算法，速度快、强度高、签名短

>加载公钥与加载私钥的不同点在于公钥加载时使用的是`X509EncodedKeySpec`（X509编码的Key指令），私钥加载时使用的是`PKCS8EncodedKeySpec`（PKCS#8编码的Key指令），若为`PKCS#1编码的key指令`，则采用如下加载方式：

```java
byte[] e = Base64.decode(privateKeyStr);
// 读取 PKCS#1的私钥
RSAPrivateKeyStructure asn1PrivateKey = new RSAPrivateKeyStructure(
                                   (ASN1Sequence) ASN1Sequence.fromByteArray(e));
RSAPrivateKeySpec rsaPrivateKeySpec = new RSAPrivateKeySpec(asn1PrivateKey.getModulus(),
                                    asn1PrivateKey.getPrivateExponent());
// 实例化KeyFactory对象，并指定 RSA 算法
KeyFactory keyFactory = KeyFactory.getInstance("RSA");
// 获得 PrivateKey 对象
PrivateKey privateKey = keyFactory.generatePrivate(rsaPrivateKeySpec);
...

```


##### 4.2 [JS端加密服务端解密](http://my.oschina.net/xiaoen/blog/121631)

>服务端

```java

  RSAPublicKey publicKey = JSRSAHelper.getDefaultPublicKey();
if (publicKey != null) {
    // RSAPublicKey 公钥的 modulus 和 exponent 传给页面
    String modulus = new String(Hex.encodeHex(publicKey.getModulus().toByteArray()));
    String exponent = new String(Hex.encodeHex(publicKey.getPublicExponent().toByteArray()));
}
```

>页面

```javascript
//1.引入security.js文件
//2.获取服务端传递到页面的 modulus 与 exponent
//3.RSA加密，服务端解密
  var modulus = $("#modulus").val();
	var exponent = $("#exponent").val();
	var key = RSAUtils.getKeyPair(exponent, '', modulus);
	var encryPwd = RSAUtils.encryptedString(key, password);

```


参考：

[关于AES256算法java端加密，ios端解密出现无法解密问题的解决方案](http://my.oschina.net/nicsun/blog/95632?fromerr=NVeab6c8)

[StackOverflow - Java Security: Illegal key size or default parameters?](http://stackoverflow.com/questions/6481627/java-security-illegal-key-size-or-default-parameters)

附件：

[生成RSA公私钥步骤](https://github.com/wenzhucjy/my_files/blob/master/RSA%2FRSA%E5%85%AC%E7%A7%81%E9%92%A5%E5%AF%B9%E7%94%9F%E6%88%90%E4%B8%8E%E4%BD%BF%E7%94%A8.md)

[RSA加解密算法实现](https://github.com/wenzhucjy/GeneralUtils/tree/master/src/main/java/com/github/mysite/common/encrypt/rsa)
