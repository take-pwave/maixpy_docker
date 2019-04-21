# MaixPy環境の構築

sipeedのMAIXのMicropython（MaixPy）の環境を提供するためのイメージです。

基本は、maixユーザでコマンドを実行します。


### dockerの実行
maixpyのworkspaceとファイルを共有するディレクトリに移動して、
以下のコマンを実行するとmaixpyのbashが起動します。

```bash
$ docker run -v `pwd`:/home/maix/workspace -i --name maixpyenv -t takepwave/maixpyenv

```

再度maixpyenvで作業をするには、docker execコマンドを使用します。
起動時に指定したmaixpyenvと名前で実行プロセスを指定します。

```bash
$ docker exec --user maix -it maixpyenv /bin/bash
```

maixのホームディレクトリに移動すると、MaixPyとworkspaceのディレクトリがあります。
```bash
maix@maixpyenv:/$ cd
maix@maixpyenv:~$ ls
MaixPy  workspace
```

MaixPyには、0.3.0のMaixPyのソースがgitで展開してあります。

kendryte-toolchainは、/optにインストールしてあります。

現在インストールしてあるバージョンは、以下のtarファイルを使用しました。
- kendryte-toolchain-ubuntu-amd64-8.2.0-20190213.tar.gz



### 最新のMaixPyに更新する方法

MaixPyのコンパイルには、大文字と小文字を区別するファイルシステムが必要なため、
WindowsやMacOSXのディレクトリでは正常にビルドすることができません。

ホームディレクトリのMaixPyに移動して以下のコマンドを実行してください。
詳しくは、以下のサイトを参照してください。
- https://github.com/sipeed/MaixPy/tree/master/ports/k210-freertos

```bash
$ cd ~/MaixPy
$ git pull
$ git submodule update --recursive
$ cd ports/k210-freertos
$ ./build.sh
$ ls output/
api.a      libkendryte.a  maixpy.elf     spiffs.a
drivers.a  maixpy.bin     mpy_support.a  utils.a

```

outputディレクトリのmaixpy.binを~/workspace/にコピーして、
kflashコマンドを使ってMAiXに書き込んでください。



