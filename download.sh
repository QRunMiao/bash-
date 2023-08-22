#!/usr/bin/env bash

echo "====> Download Genomics related tools <===="

mkdir -p $HOME/bin
mkdir -p $HOME/.local/bin
mkdir -p $HOME/share
mkdir -p $HOME/Scripts

# make sure $HOME/bin in your $PATH
if grep -q -i homebin $HOME/.bashrc; then#-q 选项表示安静模式，只返回退出码而不输出匹配结果；-i 选项表示匹配时不区分大小写
    echo "==> .bashrc already contains homebin"
else
    echo "==> Update .bashrc"

    HOME_PATH='export PATH="$HOME/bin:$HOME/.local/bin:$PATH"'
    echo '# Homebin' >> $HOME/.bashrc
    echo $HOME_PATH >> $HOME/.bashrc
    echo >> $HOME/.bashrc#在 .bashrc 文件中插入一个空行

    eval $HOME_PATH#使用 eval 命令执行 $HOME_PATH 变量中的路径命令，将该路径命令添加到当前 shell 的环境中，使其立即生效。
fi

# Clone or pull other repos
for OP in dotfiles; do
    if [[ ! -d "$HOME/Scripts/$OP/.git" ]]; then
        if [[ ! -d "$HOME/Scripts/$OP" ]]; then
            echo "==> Clone $OP"
            git clone https://github.com/wang-q/${OP}.git "$HOME/Scripts/$OP"
        else
            echo "==> $OP exists"
        fi
    else
        echo "==> Pull $OP"
        pushd "$HOME/Scripts/$OP" > /dev/null#切换到 $HOME/Scripts/$OP 目录，并将目录栈推入栈中（记录当前目录）。
        git pull#用 git pull 命令拉取远程仓库的更新
        popd > /dev/null#将目录栈弹出，回到之前的目录，并将输出重定向到 /dev/null（屏蔽输出）。
    fi
done

# alignDB
# chmod +x $HOME/Scripts/alignDB/alignDB.pl
# ln -fs $HOME/Scripts/alignDB/alignDB.pl $HOME/bin/alignDB.pl

#下载 Jim Kent bin 工具包，并将其保存为 jkbin.tar.gz 文件。
echo "==> Jim Kent bin"
cd $HOME/bin/
RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )#获取系统发行版本信息，并将其赋值给 RELEASE 变量。
if [[ $(uname) == 'Darwin' ]]; then#如果当前系统是 Darwin（MacOS），则使用 curl 命令下载
    curl -L https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-darwin-2011.tar.gz
else
    if echo ${RELEASE} | grep CentOS > /dev/null ; then#如果不是 Darwin，则进一步判断 RELEASE 变量中是否包含 "CentOS" 关键字，如果包含则下载
        curl -L https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-centos-7-2011.tar.gz
    else
        curl -L https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-ubuntu-1404-2011.tar.gz
    fi
fi \
    > jkbin.tar.gz

#补充：
    #Jim Kent bin 工具包，也称为 UCSC Genome Browser 工具包，是由 Jim Kent 和 UCSC Genome Browser 团队开发的一组生物信息学工具。

这个工具包包含了多个用于处理基因组数据和进行生物信息学分析的实用工具。其中最著名的工具之一是 `liftOver`，它用于将基因组坐标从一个参考基因组版本转换到另一个版本。

除了 `liftOver`，还有一些其他常用的工具，如 `bigWigToBedGraph`、`bedGraphToBigWig`、`wigToBigWig`、`faToTwoBit` 等，用于转换和处理基因组注释、序列、比对、信号等数据格式。

这些工具通常在生物信息学领域的基因组研究中使用，可以在 UCSC Genome Browser 的网站上找到并下载它们。

#详解：RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
lsb_release -ds：尝试使用 lsb_release 命令来获取系统的发行版本信息（如果可用）。其中，-d 参数用于显示发行版本的描述信息，-s 参数用于禁止打印额外的输出。
cat /etc/*release：如果 lsb_release 命令不可用，则尝试使用 cat 命令读取 /etc 目录下的 *release 文件来获取发行版本信息。通常，Linux 系统中会有一些特定的发行版本文件，如 redhat-release、centos-release、ubuntu-release 等。
uname -om：如果以上两个命令都失败，则使用 uname 命令来获取操作系统的名称和版本信息。其中，-o 参数用于打印操作系统名称，-m 参数用于打印操作系统的硬件架构。
2>/dev/null：将标准错误输出重定向到 /dev/null，即丢弃错误信息。
| head -n1：通过管道将命令的输出传递给 head 命令，并只取第一行结果。这个操作是为了获取最终的发行版本信息。


#tar 命令，该命令用于在 Linux/Unix 系统中进行文件和目录的压缩和解压缩操作
echo "==> untar from jkbin.tar.gz"
tar xvfz jkbin.tar.gz x86_64/axtChain #解压缩 jkbin.tar.gz 压缩文件中的 x86_64/axtChain 文件。
tar xvfz jkbin.tar.gz x86_64/axtSort
tar xvfz jkbin.tar.gz x86_64/axtToMaf
tar xvfz jkbin.tar.gz x86_64/chainAntiRepeat
tar xvfz jkbin.tar.gz x86_64/chainMergeSort
tar xvfz jkbin.tar.gz x86_64/chainNet
tar xvfz jkbin.tar.gz x86_64/chainPreNet
tar xvfz jkbin.tar.gz x86_64/chainSplit
tar xvfz jkbin.tar.gz x86_64/chainStitchId
tar xvfz jkbin.tar.gz x86_64/faToTwoBit
tar xvfz jkbin.tar.gz x86_64/lavToPsl
tar xvfz jkbin.tar.gz x86_64/netChainSubset
tar xvfz jkbin.tar.gz x86_64/netFilter
tar xvfz jkbin.tar.gz x86_64/netSplit
tar xvfz jkbin.tar.gz x86_64/netSyntenic
tar xvfz jkbin.tar.gz x86_64/netToAxt

mv $HOME/bin/x86_64/* $HOME/bin/
rm jkbin.tar.gz

if [[ $(uname) == 'Darwin' ]]; then
    curl -L http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/faToTwoBit
else
    curl -L http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faToTwoBit
fi \
    > faToTwoBit
mv faToTwoBit $HOME/bin/
chmod +x $HOME/bin/faToTwoBit#用于更改 $HOME/bin/faToTwoBit 文件的权限.chmod 命令用于修改文件或目录的权限，+x 参数表示添加可执行权限。


#补充：
# 目录栈（directory stack）
是一个记录目录路径的数据结构，它用于在命令行环境中方便地切换当前工作目录并进行目录之间的导航。

在Unix/Linux终端中，目录栈允许用户将当前工作目录以及其他目录推入栈中，并在需要时从栈中弹出，以实现快速的目录切换。

目录栈通常由以下两个命令来管理：

1. `pushd`：将当前工作目录推入目录栈并切换到指定的目录。
2. `popd`：从目录栈中弹出最顶层的目录并切换到该目录。

目录栈的主要优点是，可以通过数字索引或使用特殊字符来指定栈中的不同目录。例如，`dirs` 命令可用于列出目录栈中的所有目录及其索引，`cd -` 命令用于切换到前一个工作目录。

使用目录栈可以快速切换到先前访问过的目录，而无需输入完整的目录路径。这在需要在多个目录之间频繁切换的情况下非常有用，提高了命令行的效率和便利性。

# `eval` 
是一个在 shell 中使用的命令，它将接收到的参数作为 Shell 命令进行解析和执行。

具体来说，`eval` 命令的作用是将参数视为一个完整的 Shell 命令，并在当前 Shell 中执行该命令。它会对参数进行变量展开、命令替换和通配符扩展等操作，然后执行最终生成的命令。

以下是几个 `eval` 命令的例子：

1. 变量展开：
```bash
command='echo Hello, $USER!'
eval $command
```
在这个示例中，`$command` 变量保存了一个命令字符串 `"echo Hello, $USER!"`，其中使用了 `$USER` 变量。通过 `eval $command` 命令，`eval` 解析了 `$command` 的值并进行了变量展开，最终执行的命令是 `echo Hello, binjie09!`。

2. 命令替换：
```bash
command='echo The date is $(date)'
eval $command
```
在这个示例中，`$command` 变量保存了一个命令字符串 `"echo The date is $(date)"`，其中使用了命令替换 `$(date)`。通过 `eval $command` 命令，`eval` 解析了 `$command` 的值并进行了命令替换，最终执行的命令是 `echo The date is <current date>`，其中 `<current date>` 是当前日期。

需要注意的是，由于 `eval` 将参数作为一个完整的 Shell 命令来执行，因此在使用 `eval` 命令时要格外小心，以确保不会执行意外或危险的命令。

# tar 命令
用于在 Linux/Unix 系统中进行文件和目录的压缩和解压缩操作

# chmod 命令
用于修改文件或目录的权限
+x 参数表示添加可执行权限。

# curl（全称为“Client for URLs”）URLs客户端
是一个广泛使用的开源命令行工具和库，用于在各种网络协议上进行数据传输。它支持多种协议，包括HTTP、HTTPS、FTP、SCP、SFTP等，并且可以通过curl命令在命令行界面进行操作。

使用curl，您可以发送HTTP请求，从Web服务器上获取数据，并将其保存到文件或输出到终端。（即curl 是一个用于发送 HTTP 请求并获取响应的工具）

以下是curl常见的用法示例：

1. 发送GET请求并将响应输出到终端：
   ```
   curl https://example.com
   ```

2. 将HTTP响应输出保存到文件：
   ```
   curl -o output.txt https://example.com/file.txt
   ```

3. 发送POST请求并传递数据：
   ```
   curl -X POST -d "name=John&age=25" https://example.com/submit
   ```

4. 下载文件并使用进度条显示下载进度：
   ```
   curl -o file.zip -# https://example.com/file.zip
   ```

5. curl -L 用于下载指定的文件；-L 参数告诉 curl 在遇到 HTTP 重定向时自动进行重定向，也就是说它会跟随重定向链接下载最终的文件。
