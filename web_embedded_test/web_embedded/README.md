# http server in Ubuntu Embedded System

- 하드웨어 제어가 안됨...

## ENV

### Embedded system

```bash
# install yum
apt-get install python-lzma python-sqlitecachec python-pycurl python-urlgrabber -y
apt-get install yum -y

# install httpd
#yum -y install # error repo-list
apt-get install apache2
```

#### check apache2

```bash
# check apche2
apache2 -v

# check active apache2
netstat -ntlp
# Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
# tcp        0      0 127.0.0.1:44271         0.0.0.0:*               LISTEN      1369/node           
# tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      4001/systemd-resolv 
# tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      659/sshd            
# tcp6       0      0 :::80                   :::*                    LISTEN      5674/apache2        
# tcp6       0      0 :::21                   :::*                    LISTEN      638/vsftpd          
# tcp6       0      0 :::22                   :::*                    LISTEN      659/sshd     
```

## connect

- web
- address : IP:port
- ex) 192.168.1.60:80

## command

### start

```bash
# start
service apache2 start
```

### restart

```bash
# restart
service apache2 restart
```

### end

```bash
service apache2 stop
```

## flutter

### build

```bash
# build web
flutter build web
```

### set in embedded system

- flutter로 생성한 build/web 폴더를 임베디드 시스템으로 복사
- /var/www/html/ 디렉토리의 하위에 있을 때만 정상적으로 연결됨
- 이유는 아직 불명

```bash
cp -rp /flutter-web-buile-web/ /var/www/html/
```

### rewrite config

#### apache2.conf

```bash
# /etc/apache2/apache2.conf
```

- 다음 항목의 경로를 수정

```bash
# access here, or in any related virtual host.
<Directory />
 Options FollowSymLinks
 AllowOverride None
 Require all denied
</Directory>

<Directory /usr/share>
 AllowOverride None
 Require all granted
</Directory>

#<Directory /var/www/>
<Directory /var/www/html/web/>  # 경로를 복사한 파일의 경로로 변경
 Options Indexes FollowSymLinks
 AllowOverride None
 Require all granted
</Directory>

#<Directory /srv/>
# Options Indexes FollowSymLinks
# AllowOverride None
# Require all granted
#</Directory>
```

#### 000-default.conf

```bash
# /etc/apache2/sites-available/000-default.conf
```

- 다음 항목의 경로를 수정

```bash
<VirtualHost *:80>
 # The ServerName directive sets the request scheme, hostname and port that
 # the server uses to identify itself. This is used when creating
 # redirection URLs. In the context of virtual hosts, the ServerName
 # specifies what hostname must appear in the request's Host: header to
 # match this virtual host. For the default virtual host (this file) this
 # value is not decisive as it is used as a last resort host regardless.
 # However, you must set it for any further virtual host explicitly.
 #ServerName www.example.com

 ServerAdmin webmaster@localhost
 #DocumentRoot /var/www/html
 DocumentRoot /var/www/html/web  # 경로를 복사한 파일의 경로로 변경

 # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
 # error, crit, alert, emerg.
 # It is also possible to configure the loglevel for particular
 # modules, e.g.
 #LogLevel info ssl:warn

 ErrorLog ${APACHE_LOG_DIR}/error.log
 CustomLog ${APACHE_LOG_DIR}/access.log combined

 # For most configuration files from conf-available/, which are
 # enabled or disabled at a global level, it is possible to
 # include a line for only one particular virtual host. For example the
 # following line enables the CGI configuration for this host only
 # after it has been globally disabled with "a2disconf".
 #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```
