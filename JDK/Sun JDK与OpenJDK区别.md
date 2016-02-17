Oracle/Sun JDK 和开源项目 OpenJDK 包含的 JVM 区别？

	1. 在2006年的JavaOne大会上，Sun公司宣布最终会把Java开源，并在随后的一年，陆续将JDK的各个部分（其中当然也包括了 HotSpot VM ） 在 GPL 协议下公开了源码，并在此基础上建立了 OpenJDK ， HotSpot VM 便成为了 Sun JDK 和 OpenJDK 两个实现极度接近的 JDK 项目的共同虚拟机 VM 。
	2. 从JDK7开始，Oracle JDK 里的 HotSpot VM ，在研发的时候放在 http://openjdk.java.net 上 OpenJDK 的Mercurial代码库， Sun JDK 包含私有部分不涉及 JVM 的核心功能。
	3. Sun JDK只发布二进制安装包，而OpenJDK只发布源码， Sun 的 JVM 只公开了src.zip部分api，而 OpenJDK 可以看到 JVM 源码，可以自己编译。