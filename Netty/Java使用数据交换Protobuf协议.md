### Java使用数据交换Protobuf协议

#### Google Protocol Buffer介绍

> Google Protocol Buffer又简称 `Protobuf`，一个夸平台的库，提供了用于描述、序列化、反序列化结构化的数据的简单方式，多用于数据通信、数据存储，使用protobuf很容易达到前后版本兼容且 `Protobuf`采用`varints`编码方式，屏蔽了字节对齐，大端小端对齐问题。将数据结构以.proto文件进行描述，通过代码生成工具可以生成对应数据结构的POJO对象和Protobuf相关的方法和属性，Protocol buffers更小，更快，更简单，相比XML和JSON 性能高，3.0版本支持 C++/Java/Python/Go/Ruby/C#/PHP 语言


#### 限定修饰符

+ required - 必须字段，发送之前没设置required字段或无法识别required字段都会引发编解码异常，导致消息被丢弃

+ optional - 可选字段，可选对于发送方，在发送消息时，可以有选择性的设置或者不设置该字段的值。对于接收方，如果能够识别可选字段就进行相应的处理，如果无法识别，则忽略该字段，消息中的其它字段正常处理。

+ repeated - 可以包含0~N个元素，重复的值的顺序会被保留，相当于java中的List


#### 分配标识号

+ 在消息定义中，每个字段都有唯一的一个`数字标识符`，用来在消息的`二进制格式`中识别各个字段的，一旦开始使用就不能够再改变，[1,15]之内的标识号在编码的时候会占用一个字节（频繁出现的消息元素），[16,2047]之内的标识号则占用2个字节，不可以使用其中的[19000－19999]的标识号， Protobuf协议实现中对这些进行了预留


#### 命名规则

| 选项 | 描述     |
| :------------- | :------------- |
| proto 文件       | 小写字母+下划线，并以.proto为后缀，protoc会根据目标语言的命名规则生成相应的目标文件，若为 java 语言，生成如`PlayerModule.java`，若为 C++ ，生成`player_module.pb.h`和`player_module.pb.cc`      |
| message 消息 |骆驼命名方式|
| 字段|字段名使用SnakeCase（小写字母+下划线），对于Java代码，protoc会把SnakeCase转成首字母小写的CamelCase。对于C++代码则会保留SnakeCase风格|
|repeated 字段|等同于Java里的数组或集合，在Java里，数组或集合类型的字段一般命名成复数形式，如`repeated Item items = 1`|
| 枚举 | 使用大写字母+下划线 |

#### 标量数值类型

| .proto类型 | Java类型     |备注  |
| :------------- | :------------- |:------------- |
| double      | double     |  |
| float      | float     |  |
| int32      | int     | 使用可变长编码方式。编码负数时不够高效——如果你的字段可能含有负数，那么请使用sint32|
| int64      | long     | 使用可变长编码方式。编码负数时不够高效——如果你的字段可能含有负数，那么请使用sint64|
|uint32|int[1]|Uses variable-length encoding.|
|uint64|long[1]|Uses variable-length encoding.|
|sint32|int|使用可变长编码方式。有符号的整型值。编码时比通常的int32高效|
|sint64|long|使用可变长编码方式。有符号的整型值。编码时比通常的int64高效|
|fixed32|int[1]|总是4个字节。如果数值总是比总是比228大的话，这个类型会比uint32高效|
|fixed64|long[1]|总是8个字节。如果数值总是比总是比256大的话，这个类型会比uint64高效|
|sfixed32|int|总是4个字节|
|sfixed64|long|总是8个字节|
|bool|boolean|布尔类型1字节|
|string|String|一个字符串必须是UTF-8编码或者7-bit ASCII编码的文本|
|bytes|ByteString|可能包含任意顺序的字节数据，用于处理多字节的语言字符|

#### optional 字段和默认值

```
optional int32 num = 1 [default = 2]; // 可选项 num，默认值为2
```

| 标量 | 默认值     |
| :------------- | :------------- |
| bool      | false      |
| string | 空字符串 |
|数值类型|0|
| 枚举 | 枚举类型定义的第一个值|

#### 枚举定义

```
message POJO{
required string name =1;
optional int32 id =2;
optional int32 num =3[default =1];
enum ENUM_DEMO{
 A=0;
 B=1;
 C=2;
 D=3;
 E=4;
 F=5;
 G=6;
}
optional ENUM_DEMO demo =4[default = F];
}
```

+ 枚举常量必须在32位整型值的范围内，enum值是使用可变编码方式的，对负数效率不高

+ 如果想在父消息类型的外部重用这个`ENUM_DEMO`消息类型，使用`optional POJO.ENUM_DEMO demo =1[default = A];`

#### 导入其他.proto定义

+ ` import "../project/other_protos.proto"; `指的是相对路径

+ protocol 编译器就会在一系列目录中查找需要被导入的文件，这些目录通过protocol编译器的命令行参数`-I/–import_path`指定，如果不提供参数，编译器就在其调用目录下查找


#### 更新一个消息类型

+ 不要更改任何已有的字段的数值标识，添加的任何字段都必须是optional或repeated的

+ 非required的字段可以移除（推荐在字段前添加“OBSOLETE_”前缀，使用的.proto文件的用户将来就不会无意中重新使用了那些不该使用的标识号）

+ 一个非required的字段可以转换为一个扩展（只要它的类型和标识号保持不变）

+ string和bytes是兼容的（只要bytes是有效的UTF-8编码）

#### 选项（Options）

| 选项 | 描述    |
| :------------- | :------------- |
| java_package      | 这个选项表明生成java类所在的包，若没有明确的声明java_package，就采用默认的包名，默认方式产生的 java包名并不是最好的方式，按照应用名称倒序方式进行排序的，如果不需要产生java代码，则该选项将不起任何作用`option java_package com.demo`     |
|java_outer_classname |生成Java类的名称，没有明确的java_outer_classname定义，生成的class名称将会根据.proto文件的名称采用驼峰式的命名方式进行生成，如`abc_efg.proto`会生成`AbcEfg.java`|
|optimize_for|可以被设置为 `SPEED`, `CODE_SIZE`,`LITE_RUNTIME`<br/>`SPEED` (default)，protocol buffer编译器将通过在消息类型上执行序列化、语法分析及其他通用的操作，这种代码是最优的；<br/>`CODE_SIZE` : protocol buffer编译器将会产生最少量的类，通过共享或基于反射的代码来实现序列化、语法分析及各种其它操作。采用该方式产生的代码将比SPEED要少得多， 但是操作要相对慢些。当然实现的类及其对外的API与SPEED模式都是一样的。这种方式经常用在一些包含大量的.proto文件而且并不盲目追求速度的应用中；<br/>`LITE_RUNTIME`: protocol buffer编译器依赖于运行时核心类库来生成代码（即采用libprotobuf-lite 替代libprotobuf）。这种核心类库由于忽略了一 些描述符及反射，要比全类库小得多。这种模式经常在移动手机平台应用多一些。编译器采用该模式产生的方法实现与SPEED模式不相上下，产生的类通过实现 MessageLite接口，但它仅仅是Messager接口的一个子集|
|packed |如果该选项在一个整型基本类型上被设置为真，则采用更紧凑的编码方式，使用该值并不会对数值造成任何损失|
|deprecated |如果该选项被设置为true，表明该字段已经被弃用了，在新代码中不建议使用，在java中，它将会变成一个 @Deprecated注释|

#### 原理介绍

+ `protobuf`使用一种类似 ((T)([L]V)) 的形式来组织数据的，即Tag-Length-Value（其中Length是可选的），每一个字段都是使用TLV的方式进行序列化的，一个消息就可以看成是多个字段的TLV序列拼接成的一个二进制字节流

+ `protobuf`数据类型进行了划分，`wire_type`包含：`Varint`是一种紧凑的表示数字的编码方式，可以用一个或多个字节来表示一个数字，值越小的数字需要的字节数越少，`Varint`中每一个字节的最高位bit都是有特殊含义的，若为1，表示下一个字节也是该数字的一部分，为0，表明该数字到这一个字节就结束了；`FixedXXX`是固定长度的数字类型；`Length-delimited`是可变长数据类型，常见的就是string, bytes之类的


#### `protobuf`示例

+ proto 文件

```
option java_package = "com.serial.protobuf";
option java_outer_classname = "PlayerModule";

message PBPlayer{
	required int64 playerId = 1;

	required int32 age = 2;

	required string name = 3;

	repeated int32 skills = 4;

}

message PBResource{
	required int64 gold = 1;

	required int32 energy = 2;

    // 扩展BaseData，加上一个Data类型的字段，tag为100
    extend BaseData {
        required PBResource extend_data = 100;
    }

}

// 定义一个message BaseData，100~199之间的tag可供扩展
message BaseData {
    required int32 code = 1;
    extensions 100 to 199;
}

// 定义一个message Foo，100~200之间的tag可供扩展
message Foo{
    extensions 100 to 200;
}
// 扩展Foo，加上一个 bar，tag为100
extend Foo {
    optional int32 bar = 126;
}

```

+ 创建批处理文件`build.bat`，其中`protoc.exe`版本2.5.0

```cmd
cd F:\Program\protobuf\src\main\resources
set OUT=../java

protoc.exe ./*.proto --java_out=%OUT%

pause
```

+ 测试

```java
public static void main(String[] args) throws Exception {

      PlayerModule.PBPlayer player = PlayerModule.PBPlayer.newBuilder().setPlayerId(101).setAge(20).setName("peter").addSkills(1001).build();

      byte[] byteArray = player.toByteArray();

      System.out.println(Arrays.toString(byteArray));

      PlayerModule.PBPlayer builder = PlayerModule.PBPlayer.parseFrom(byteArray);

      System.out.println("playerId:" + builder.getPlayerId());
      System.out.println("age:" + builder.getAge());
      System.out.println("name:" + builder.getName());
      System.out.println("skill:" + builder.getSkillsList());

      PlayerModule.Foo.Builder builder2 = PlayerModule.Foo.newBuilder();
      PlayerModule.Foo foo = builder2.setExtension(PlayerModule.bar, 123).build();

      // -------------- 分割线：下面是接收方，将数据接收后反序列化 ---------------
      ExtensionRegistry registry = ExtensionRegistry.newInstance();
      registry.add(PlayerModule.bar);
      PlayerModule.Foo newFoo = PlayerModule.Foo.parseFrom(foo.toByteArray(), registry);
      Integer result = newFoo.getExtension(PlayerModule.bar);
      System.out.println(result);

      // 先构造一个 message PBResource 类型对象
      PlayerModule.PBResource.Builder builder3 = PlayerModule.PBResource.newBuilder();
      PlayerModule.PBResource resource = builder3.setGold(123).setEnergy(321).build();

      // 再构造 message BaseData 对象，将 PBResource 对象通过 setExtension 设置到 BaseData 中
      PlayerModule.BaseData.Builder builder4 = PlayerModule.BaseData.newBuilder();
      builder4.setCode(456);
      PlayerModule.BaseData baseData = builder4.setExtension(PlayerModule.PBResource.extendData, resource).build();
      // -------------- 分割线：下面是接收方，将数据接收后反序列化 ---------------

      ExtensionRegistry registry2 = ExtensionRegistry.newInstance();

      registry.add(PlayerModule.PBResource.extendData); // 或者 PlayerModule.registerAllExtensions(registry2);

      PlayerModule.BaseData receiveBaseData = PlayerModule.BaseData.parseFrom(baseData.toByteArray(), registry2);
      System.out.println(receiveBaseData.getCode());
      System.out.println(receiveBaseData.getExtension(PlayerModule.PBResource.extendData).getEnergy());
  }
```

#### 参考

[Protobuf 官网](https://developers.google.com/protocol-buffers/docs/overview)

[Protobuf Github](https://github.com/google/protobuf)

[JProtobuf Github](https://github.com/jhunters/jprotobuf)

[[译]Protocol Buffer语言指南](http://colobu.com/2015/01/07/Protobuf-language-guide/)

[Google Protocol Buffer 语言指南 - IBM](https://developers.google.com/protocol-buffers/docs/proto#generating)

[Google Protocol Buffer 的使用和原理](https://www.ibm.com/developerworks/cn/linux/l-cn-gpb/)

[Protobuf 的 proto3 与 proto2 的区别](https://solicomo.com/network-dev/protobuf-proto3-vs-proto2.html?utm_source=tuicool&utm_medium=referral)
