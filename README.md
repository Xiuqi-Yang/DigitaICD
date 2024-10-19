# Digital_ICD
最主要参考的这篇blog https://blog.csdn.net/Robert_Q/article/details/127376171
因为之前被夏神搞得想自己下一个跑数字的环境，但是因为wls2下面直接弄得话要自己起license那些，感觉很麻烦，找问题的时间占了大多数，有的时候都不是自己的问题，而且ubuntu贼拉占内存。后面经过叶神和唐神的文档的指点下重新搞了下载并配置好synopsys的docker，本身是没有图形化环境的，在mac底下可以使用XQuartz，windows下可以使用vncviewer
### docker下载
首先下载docker desktop并找到要用的镜像
注册一个docker desktop的personal账号，可以去eetop上自己找一个synopsys的镜像源，
然后是在windows终端（这里我用的是powershell），跑这个命令

```
docker run -itd --gpus all --name CONTAINER-NAME --restart unless-stopped -e USER=root -v /local/directorty:/workspace -v /dev/shm:/dev/shm -p 5901:5901 [dockername]
```
```
docker run -itd --gpus all --hostname lizhen --mac-address 02:42:ac:11:00:02 --name eda --restart unless-stopped -e USER=root -v C:\Users\yangxiuqi\Digital_ICD:/mnt/Digital_ICD/ -v /dev/shm:/dev/shm -p 5901:5901 phyzli/ubuntu18.04_xfce4_vnc4server_synopsys
```
命令中的名字、目录等替换成自己的，-e USER=root、-v /dev/shm:/dev/shm、-p xxxx:5901不要改，-e USER=root是后续容器中启动vncserver所需的环境变量，5901端口是vncserver启动时默认使用的端口，-v /dev/shm:/dev/shm保证容器的内存不会不够。

[dockername]就是你下载的镜像的名称
CONTAINER-NAME是对应的容器的名字，可以自己取

首次运行这个命令的时候会说本地不存在这个镜像，会将这个镜像下载到你电脑里，同时也会load到docker desktop，你每次运行这个镜像会给你重新生成一个新的container

这个就是我对应生成的镜像容器，其中我指定了端口号是5901，并且将本机的端口和服务器端口5901做了映射。5901是每次启动vncserver的默认端口，后面使用vncserver的时候默认生成的display_number是1，在vim /usr/bin/vncserver
在这个文件中找到vncPort一行，可以看到$vncPort = 5900 + $displayNumber;因此对应的端口号就是5901

你第一次生成container的时候终端会直接进root，后面如果退了再想进入已经运行的容器可以使用命令
```
docker exec -it CONTAINER-NAME bash
```

### 安装桌面环境
在root中输入以下命令
```
apt-get install xorg openbox
```
x11是一个用于远程图形界面的程序
```
apt update
sudo apt install xfce4 xfce4-goodies vim
```
安装Xfce桌面环境，顺便装个vim，方便后续文件编辑
安装tightvncserver
```
apt install tightvncserver
```

修改xstartup文件
```
vim ~/.vnc/xstartup
```
```
#!/bin/sh

# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc


#[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
#[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
#xsetroot -solid grey
#vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &

export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
gnome-session &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
gnome-terminal &
```
为了保证VNC服务正常启动，需要配置xstartup为可执行文件。
```
chmod +x ~/.vnc/xstartup
```

所有都安装完成后可以用vncpasswd自己搞一个密码
```
vncserver//创建display
```
输入vncserver开启vnc服务，会生成一个display号，一定要是1，因为之前设置的5901端口映射，如果displaynumber不是1的话会连不上vncviewer

### 下载安装real vncviewer
安装vncviewer之后
https://www.realvnc.com/en/connect/download/viewer
输入ip:port之后就可以连接到可视化界面了（自己思考一下要怎么写）
有报警就直接continue
然后要输入你之前设置的密码
最终有图形化界面
```
ps -ef | grep vnc
vncserver -kill :1
vncserver -geometry 1920x1080 :1
```

最后跑完建议在终端里把display1删掉，不然下次有可能不能直接生成这个display number，因为和上次生成的一些文件有冲突了。要去/tmp里删掉一些东西。

nb