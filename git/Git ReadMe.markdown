
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

> ###其他 GUI

实在搞不定，请直接使用各种 GUI 工具！

1. 使用 eclipse IDE的，可以安装 EGit 插件

2. 不使用 IDE 的，可以搜索一个叫做 SmartGit 的 GUI 客户端

