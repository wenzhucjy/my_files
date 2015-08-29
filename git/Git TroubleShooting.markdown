
#Git Troubleshoot

----------
##解决 Git 在 windows 下中文乱码
> ###原因


中文乱码的根源在于 windows 基于一些历史原因无法全面支持 utf-8 编码格式，并且也无法通过有效手段令其全面支持。


> ###解决方案

1. 安装

2. 设置（以下需要修改的文件，均位于 git 安装目录下的 etc/ 目录中）

2.1. 让 Git 支持 utf-8 编码

在命令行下输入以下命令：

```bash
$ git config --global core.quotepath false  		# 显示 status 编码
$ git config --global gui.encoding utf-8			# 图形界面编码
$ git config --global i18n.commit.encoding utf-8	# 提交信息编码
$ git config --global i18n.logoutputencoding utf-8	# 输出 log 编码
$ export LESSCHARSET=utf-8
# 最后一条命令是因为 git log 默认使用 less 分页，所以需要 bash 对 less 命令进行 utf-8 编码
```

2.2. 让 ls 命令可以显示中文名称

修改 git-completion.bash 文件：

```bash
# 在文件末尾处添加一行
alias ls="ls --show-control-chars --color"
```

经过以上折腾之后，基本可以解决中文显示的问题。唯一的麻烦在于输入中文字符时会显示乱码，目前还没有完美的解决方案。

以下描述一个可用的临时方案：

1. 前提条件：`git commit` 时，不用 `-m` 参数，也就是不在命令行下直接输入提交信息，而是敲回车，让 vim 来接管

2. 进入 vim 后，按 `i` 键进入编辑模式，然后输入提交信息。（可多行）

3. 输入完成后按 `esc` 退出编辑模式，然后输入 `:wq`，也就是写入+退出，即可。

4. 如果进入 vim 后发现不能输入中文，那么先按 `esc` 退出编辑模式，然后输入：`:set termencoding=GBK`，即可。（也可能是 GB2312，都试一下）

> ###乱码情景

在一个使用cygwin的bash提交的git项目中，已经完成了所有的提交，但使用TortoiseGit查看的时候，却发现仍有文件没有提交，甚至是有文件还处于未暂存的状态。于是使用TortoiseGit提交；
再次用cygwin下的git status查看，这次又发现了未提交的情况。再次用git commit命令行提交；
回到TortoiseGit下查看，问题又出现了！此时准备返回两次提交前的版本，却因为文件名乱码的问题，无法返回了！
搜索一番，发现git文件名、log乱码，是普遍问题，这其中有编码的原因，也有跨平台的原因。因为git是从linux移植过来，默认采用UTF-8编码。而Windows默认使用UTF-16编码来保存文件名，应该就是这些不同的处理方式造成了乱码。下面是解决方案：

 - 情景1

在cygwin中，使用git add添加要提交的文件的时候，如果文件名是中文，会显示形如274\232\350\256\256\346\200\273\347\273\223.png的乱码。

解决方案：

在bash提示符下输入：
```bash
git config –global core.quotepath false
#core.quotepath设为false的话，就不会对0×80以上的字符进行quote。中文显示正常。
```

 

 - 情景2


在MsysGit中，使用git log显示提交的中文log乱码。

解决方案：

设置git gui的界面编码
```bash
git config –global gui.encoding utf-8
#设置 commit log 提交时使用 utf-8 编码，可避免服务器上乱码，同时与linix上的提交保持一致！

git config –global i18n.commitencoding utf-8
#使得在 $ git log 时将 utf-8 编码转换成 gbk 编码，解决Msys bash中git log 乱码。

git config –global i18n.logoutputencoding gbk
#使得 git log 可以正常显示中文（配合i18n.logoutputencoding = gbk)，在 /etc/profile 中添加：

export LESSCHARSET=utf-8
```

 - 情景3
 
在MsysGit自带的bash中，使用ls命令查看中文文件名乱码。cygwin没有这个问题。

解决方案：
```bash
使用ls –show-control-chars命令来强制使用控制台字符编码显示文件名，即可查看中文文件名。

为了方便使用，可以编辑/etc/git-completion.bash ，新增一行 alias ls=”ls –show-control-chars”
```

使用git gui命令，在MsysGit下，看到的中文文件名为正常；而在cygwin下，看到的中文文件名为乱码。
同样的，如果一直使用TortoiseGit（实际调用MsysGit）提交，那么中文文件名没问题；一直使用cygwin提交，中文文件名也没问题。但一定不能交叉使用，这应该是两个平台默认处理中文文件名的方式不同造成的。

分别设置 **LANG、LC_CTYPE、LC_ALL** 参数为同样的编码，问题依旧。

cygwin官方网站提到了非拉丁语文件名的问题，也许研究后能解决该吧：[Chapter 2. Setting Up Cygwin](https://www.cygwin.com/cygwin-ug-net/setup-locale.html)

这里还有一篇讲解Linux系统编码文章：locale的设定及其**LANG、LC_ALL、LANGUAGE**环境变量的区别

貌似终极的解决办法是通过修改git和TortoiseGit源码实现的：[让Windows下Git和TortoiseGit支持中文文件名/UTF-8](http://www.cnblogs.com/tinyfish/archive/2010/12/17/1909463.html)

> ###相关文档


[搞定Git中文乱码、用TortoiseMerge实现Diff/Merge](http://bbs.csdn.net/topics/360008711)


[MsysGit乱码与跨平台版本管理](http://bbs.csdn.net/topics/350266540)



[Git for windows 中文乱码解决方案](http://segmentfault.com/a/1190000000578037)