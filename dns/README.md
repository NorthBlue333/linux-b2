# TP DNS
## Questions

Configuration du resolver DNS de `proxy` :
```
cat /etc/resolv.conf
nameserver 192.168.33.21
nameserver 192.168.33.22
```

Dig du `wiki.lab.local` depuis `proxy` :

```
dig wiki.lab.local +short
192.168.56.11
```

Sur auth-1, les ports en écoute :
```
ss -tupl4
Local Address:Port      
            *:cadlock2  
            *:domain    # config dans /etc/pdns/pdns.conf (pdns)
    127.0.0.1:323       
            *:bootpc    
            *:bootpc    
            *:19555     
            *:sunrpc
    127.0.0.1:mysql     # config dans /etc/my.cnf (mysql)
            *:sunrpc    
192.168.33.31:http      # config dans /etc/httpd/conf/httpd.conf (httpd ou apache)
            *:domain    
            *:ssh       
    127.0.0.1:smtp  
ss -tupln4               
  Local Address:Port    
              *:1000    
              *:53      
      127.0.0.1:323     
              *:68      
              *:68      
              *:19555   
              *:111   
      127.0.0.1:3306    
              *:111     
  192.168.33.31:80      
              *:53      
              *:22      
      127.0.0.1:25      
```

Sur recursor-1 :
```
ss -tupl4
 Local Address:Port   
             *:1017   
 192.168.33.21:domain  # config dans /etc/pdns-recursor/recursor.conf
     127.0.0.1:domain 
     127.0.0.1:323    
             *:bootpc 
             *:bootpc 
             *:sunrpc
             *:sunrpc 
 192.168.33.21:domain 
     127.0.0.1:domain 
             *:ssh    
     127.0.0.1:smtp  
ss -tupln4
   Local Address:Port 
               *:1017 
   192.168.33.21:53   
       127.0.0.1:53   
       127.0.0.1:323  
               *:68   
               *:68   
               *:111 
               *:111  
   192.168.33.21:53   
       127.0.0.1:53   
               *:22   
       127.0.0.1:25   
```

Ce qui est configué sur le serveur récursif pour `lab.local` :
```
forward-zones=lab.local=192.168.56.31;192.168.56.32
```

Le serveur récursif ne répond que sur l'interface qui est dans le réseau 192.168.33.0/24 (ici 192.168.33.21) car il n'écoute que sur cette interface sur le port 53 (en plus de 127.0.0.1). Si on fait un dig depuis auth-1 :
```
[vagrant@auth-1 ~]$ dig wiki.lab.local @192.168.33.21 +short
192.168.56.11
[vagrant@auth-1 ~]$ dig wiki.lab.local @192.168.56.21 +short

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> wiki.lab.local @192.168.56.21 +short
;; global options: +cmd
;; connection timed out; no servers could be reached
```
Le serveur ne répond pas sur l'interface 192.168.56.21.
