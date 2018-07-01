This docker image implements BIND Version 9 and includes basic internet utilities and configuration files for authoritative DNS server.

# Q&A

**What is BIND?**

BIND (Berkeley Internet Name Domain) is the most widely used DNS server on the modern Internet. Here is its official site: https://www.isc.org/downloads/bind/
You may also have heard about "named", a nameserver daemon which is a part of BIND software package.

**What is BIND9?**

BIND9 is a short name for BIND Version 9. Version 9 is the most secure and popular version of BIND.
It is open source and is actively maintained by ISC (Internet Systems Consortium).
You can download its source code here: https://www.isc.org/downloads/

**What is Conceptant, Inc.?**

Conceptant, Inc. is a business specializing on healthcare solutions. You can read about it here: http://conceptant.com/

**Why would I need this docker image?**

You may need this image if you need a quick solution that will implement an authoritative DNS server and manage it using standard text editors (vi, nano etc)
If you need a web GUI, you may want to take a look at this image: https://hub.docker.com/r/conceptant/bind9-namedmanager/

**Is this docker image production-ready?**

Yes, you can run it in production if you carefully craft secure configuration for it.

# How to run this image

```
docker run -d --restart unless-stopped -p 53:53/tcp -p 53:53/udp -v <bind_config_dir>:/etc/bind --name named conceptant/bind
```
You may also add "-v <working_dir>:/var/named" if you want to persist and have access to the logs and working directory from the docker host.

# If you need to customize the docker file

```
git clone https://github.com/conceptant/bind.git
```

Now make you customizations and build as usual:
```
docker build -t bind .
```

# How to add your DNS zones

You have fill access to the BIND configuration via mounted volume, so you can use any approach you want, but here is the recommended one.

Edit file named.conf.local and add a line that looks like this:

```
zone "test.com"      { type master; file "/etc/bind/test.com.zone"; };
```

Now create the file referred in this line, called "/etc/bind/test.com.zone". It should look approximately like this (obviously you need to put your real DNS data in the file):
```
$TTL 2d
@		IN SOA		ns1.test.com.	ns1.test.com. (
				2018062405	; serial
				3600		; refresh
				1800		; retry
				1209600		; expiry
				86400 )		; minimum

test.com.   IN NS          ns1.test.com.
test.com.   IN MX          10 test.test.com.
test.com.   IN TXT         "<your SPF record>"
ns1            IN A             127.0.0.1
test            IN CNAME    www.google.com.
```

The final step is restarting the DNS container:
```
docker restart named
```
And while you're adjusting the configuration it's a good idea to keep an eye on the container logs:
```
docker logs -f named
```
And you may also want to verify that your DNS server returns information for the domain you just added:
```
nslookup test.com localhost
```