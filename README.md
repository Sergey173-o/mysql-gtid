Настройка репликации

| ВМ | IP во внутренней сети `mysql-gtid-lab` | Назначение |
|---|---|---|
| `master` | `192.168.57.10` | MySQL 8.0, полный дамп, binlog |
| `replica` | `192.168.57.11` | MySQL 8.0, пять таблиц, доступ на чтение |


```bash
root@nfsc:~/mysql-gtid-hw# vagrant halt master &&
vagrant up master --provider=virtualbox --no-provision &&
vagrant ssh master -c '
  getent ahostsv4 mirrors.edge.kernel.org &&
  sudo apt-get -o APT::Update::Error-Mode=any update
'
==> master: Attempting graceful shutdown of VM...
    master: Guest communication could not be established! This is usually because
    master: SSH is not running, the authentication information was changed,
    master: or some other networking issue. Vagrant will force halt, if
    master: capable.
==> master: Forcing shutdown of VM...
Bringing machine 'master' up with 'virtualbox' provider...
==> master: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> master: Clearing any previously set forwarded ports...
==> master: Fixed port collision for 22 => 2222. Now on port 2200.
==> master: Clearing any previously set network interfaces...
==> master: Preparing network interfaces based on configuration...
    master: Adapter 1: nat
    master: Adapter 2: intnet
==> master: Forwarding ports...
    master: 22 (guest) => 2200 (host) (adapter 1)
==> master: Running 'pre-boot' VM customizations...
==> master: Booting VM...
==> master: Waiting for machine to boot. This may take a few minutes...
    master: SSH address: 127.0.0.1:2200
    master: SSH username: vagrant
    master: SSH auth method: private key
    master: Warning: Connection reset. Retrying...
    master: Warning: Connection reset. Retrying...
==> master: Machine booted and ready!
==> master: Checking for guest additions in VM...
    master: The guest additions on this VM do not match the installed version of
    master: VirtualBox! In most cases this is fine, but in rare cases it can
    master: prevent things such as shared folders from working properly. If you see
    master: shared folder errors, please make sure the guest additions within the
    master: virtual machine match the version of VirtualBox you have installed on
    master: your host and reload your VM.
    master:
    master: Guest Additions Version: 6.1.38
    master: VirtualBox Version: 7.0
==> master: Setting hostname...
==> master: Configuring and enabling network interfaces...
==> master: Machine not provisioned because `--no-provision` is specified.
root@nfsc:~/mysql-gtid-hw#

root@nfsc:~/mysql-gtid-hw# vagrant ssh master -c 'sudo apt-get -o APT::Update::Error-Mode=any update && echo APT_OK' &&
vagrant provision master
Hit:1 https://mirrors.edge.kernel.org/ubuntu jammy InRelease
Get:2 https://mirrors.edge.kernel.org/ubuntu jammy-updates InRelease [128 kB]
Get:3 https://mirrors.edge.kernel.org/ubuntu jammy-backports InRelease [127 kB]
Get:4 https://mirrors.edge.kernel.org/ubuntu jammy-security InRelease [129 kB]
Get:5 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 Packages [3,983 kB]
Get:6 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main Translation-en [585 kB]
Get:7 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 c-n-f Metadata [20.1 kB]
Get:8 https://mirrors.edge.kernel.org/ubuntu jammy-updates/restricted amd64 Packages [6,848 kB]
Get:9 https://mirrors.edge.kernel.org/ubuntu jammy-updates/restricted Translation-en [1,316 kB]
Get:10 https://mirrors.edge.kernel.org/ubuntu jammy-updates/restricted amd64 c-n-f Metadata [584 B]
Get:11 https://mirrors.edge.kernel.org/ubuntu jammy-updates/universe amd64 Packages [1,290 kB]
Get:12 https://mirrors.edge.kernel.org/ubuntu jammy-updates/universe Translation-en [326 kB]
Get:13 https://mirrors.edge.kernel.org/ubuntu jammy-updates/universe amd64 c-n-f Metadata [30.8 kB]
Get:14 https://mirrors.edge.kernel.org/ubuntu jammy-updates/multiverse amd64 Packages [86.1 kB]
Get:15 https://mirrors.edge.kernel.org/ubuntu jammy-updates/multiverse Translation-en [16.5 kB]
Get:16 https://mirrors.edge.kernel.org/ubuntu jammy-updates/multiverse amd64 c-n-f Metadata [756 B]
Get:17 https://mirrors.edge.kernel.org/ubuntu jammy-backports/main amd64 Packages [70.2 kB]
Get:18 https://mirrors.edge.kernel.org/ubuntu jammy-backports/main Translation-en [11.4 kB]
Get:19 https://mirrors.edge.kernel.org/ubuntu jammy-backports/main amd64 c-n-f Metadata [412 B]
Get:20 https://mirrors.edge.kernel.org/ubuntu jammy-backports/universe amd64 Packages [30.8 kB]
Get:21 https://mirrors.edge.kernel.org/ubuntu jammy-backports/universe Translation-en [16.9 kB]
Get:22 https://mirrors.edge.kernel.org/ubuntu jammy-backports/universe amd64 c-n-f Metadata [676 B]
Get:23 https://mirrors.edge.kernel.org/ubuntu jammy-security/main amd64 Packages [3,718 kB]
Get:24 https://mirrors.edge.kernel.org/ubuntu jammy-security/main Translation-en [519 kB]
Get:25 https://mirrors.edge.kernel.org/ubuntu jammy-security/main amd64 c-n-f Metadata [14.7 kB]
Get:26 https://mirrors.edge.kernel.org/ubuntu jammy-security/restricted amd64 Packages [6,613 kB]
Get:27 https://mirrors.edge.kernel.org/ubuntu jammy-security/restricted Translation-en [1,272 kB]
Get:28 https://mirrors.edge.kernel.org/ubuntu jammy-security/restricted amd64 c-n-f Metadata [600 B]
Get:29 https://mirrors.edge.kernel.org/ubuntu jammy-security/universe amd64 Packages [1,057 kB]
Get:30 https://mirrors.edge.kernel.org/ubuntu jammy-security/universe Translation-en [238 kB]
Get:31 https://mirrors.edge.kernel.org/ubuntu jammy-security/universe amd64 c-n-f Metadata [23.2 kB]
Get:32 https://mirrors.edge.kernel.org/ubuntu jammy-security/multiverse amd64 Packages [79.6 kB]
Get:33 https://mirrors.edge.kernel.org/ubuntu jammy-security/multiverse Translation-en [13.6 kB]
Get:34 https://mirrors.edge.kernel.org/ubuntu jammy-security/multiverse amd64 c-n-f Metadata [544 B]
Fetched 28.6 MB in 50s (566 kB/s)
Reading package lists... Done
APT_OK
==> master: Running provisioner: shell...
    master: Running: inline script
==> master: Running provisioner: file...
    master: conf/master.cnf => /home/vagrant/.mysql-gtid-lab/mysql.cnf
==> master: Running provisioner: file...
    master: .local/repl-password => /home/vagrant/.mysql-gtid-lab/repl-password
==> master: Running provisioner: file...
    master: .local/bet.dmp => /home/vagrant/.mysql-gtid-lab/bet.dmp
==> master: Running provisioner: shell...
    master: Running: /tmp/vagrant-shell20261116-664949-velr2o.sh
    master: Hit:1 https://mirrors.edge.kernel.org/ubuntu jammy InRelease
    master: Hit:2 https://mirrors.edge.kernel.org/ubuntu jammy-updates InRelease
    master: Hit:3 https://mirrors.edge.kernel.org/ubuntu jammy-backports InRelease
    master: Hit:4 https://mirrors.edge.kernel.org/ubuntu jammy-security InRelease
    master: Reading package lists...
    master: Reading package lists...
    master: Building dependency tree...
    master: Reading state information...
    master: The following additional packages will be installed:
    master:   libcgi-fast-perl libcgi-pm-perl libclone-perl libencode-locale-perl
    master:   libevent-core-2.1-7 libevent-pthreads-2.1-7 libfcgi-bin libfcgi-perl
    master:   libfcgi0ldbl libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
    master:   libhttp-date-perl libhttp-message-perl libio-html-perl
    master:   liblwp-mediatypes-perl libmecab2 libprotobuf-lite23 libtimedate-perl
    master:   liburi-perl mecab-ipadic mecab-ipadic-utf8 mecab-utils mysql-client-8.0
    master:   mysql-client-core-8.0 mysql-common mysql-server-core-8.0
    master: Suggested packages:
    master:   libdata-dump-perl libipc-sharedcache-perl libbusiness-isbn-perl libwww-perl
    master:   mailx tinyca
    master: The following NEW packages will be installed:
    master:   libcgi-fast-perl libcgi-pm-perl libclone-perl libencode-locale-perl
    master:   libevent-pthreads-2.1-7 libfcgi-bin libfcgi-perl libfcgi0ldbl
    master:   libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
    master:   libhttp-date-perl libhttp-message-perl libio-html-perl
    master:   liblwp-mediatypes-perl libmecab2 libprotobuf-lite23 libtimedate-perl
    master:   liburi-perl mecab-ipadic mecab-ipadic-utf8 mecab-utils mysql-client-8.0
    master:   mysql-client-core-8.0 mysql-common mysql-server-8.0 mysql-server-core-8.0
    master: The following packages will be upgraded:
    master:   libevent-core-2.1-7
    master: 1 upgraded, 27 newly installed, 0 to remove and 298 not upgraded.
    master: Need to get 29.9 MB of archives.
    master: After this operation, 244 MB of additional disk space will be used.
    master: Get:1 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mysql-common all 5.8+1.0.8 [7,212 B]
    master: Get:2 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-client-core-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [2,721 kB]
    master: Get:3 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-client-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [22.7 kB]
    master: Get:4 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libevent-core-2.1-7 amd64 2.1.12-stable-1ubuntu0.2 [94.8 kB]
    master: Get:5 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libevent-pthreads-2.1-7 amd64 2.1.12-stable-1ubuntu0.2 [7,644 B]
    master: Get:6 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libmecab2 amd64 0.996-14build9 [199 kB]
    master: Get:7 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libprotobuf-lite23 amd64 3.12.4-1ubuntu7.22.04.6 [209 kB]
    master: Get:8 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-server-core-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [17.8 MB]
    master: Get:9 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-server-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [1,452 kB]
    master: Get:10 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libhtml-tagset-perl all 3.20-4 [12.5 kB]
    master: Get:11 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 liburi-perl all 5.10-1 [78.8 kB]
    master: Get:12 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libhtml-parser-perl amd64 3.76-1ubuntu0.1 [88.6 kB]
    master: Get:13 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libcgi-pm-perl all 4.54-1 [188 kB]
    master: Get:14 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libfcgi0ldbl amd64 2.4.2-2ubuntu0.1 [28.1 kB]
    master: Get:15 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libfcgi-perl amd64 0.82+ds-1build1 [22.8 kB]
    master: Get:16 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libcgi-fast-perl all 1:2.15-1 [10.5 kB]
    master: Get:17 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libclone-perl amd64 0.45-1build3 [11.0 kB]
    master: Get:18 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libencode-locale-perl all 1.05-1.1 [11.8 kB]
    master: Get:19 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libfcgi-bin amd64 2.4.2-2ubuntu0.1 [11.1 kB]
    master: Get:20 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libhtml-template-perl all 2.97-1.1 [59.1 kB]
    master: Get:21 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libtimedate-perl all 2.3300-2 [34.0 kB]
    master: Get:22 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libhttp-date-perl all 6.05-1ubuntu0.1 [10.8 kB]
    master: Get:23 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libio-html-perl all 1.004-2 [15.4 kB]
    master: Get:24 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 liblwp-mediatypes-perl all 6.04-1 [19.5 kB]
    master: Get:25 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libhttp-message-perl all 6.36-1 [76.8 kB]
    master: Get:26 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mecab-utils amd64 0.996-14build9 [4,850 B]
    master: Get:27 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mecab-ipadic all 2.7.0-20070801+main-3 [6,718 kB]
    master: Get:28 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mecab-ipadic-utf8 all 2.7.0-20070801+main-3 [4,384 B]
    master: Preconfiguring packages ...
    master: Fetched 29.9 MB in 35s (852 kB/s)
    master: Selecting previously unselected package mysql-common.
(Reading database ... 76324 files and directories currently installed.)
    master: Preparing to unpack .../0-mysql-common_5.8+1.0.8_all.deb ...
    master: Unpacking mysql-common (5.8+1.0.8) ...
    master: Selecting previously unselected package mysql-client-core-8.0.
    master: Preparing to unpack .../1-mysql-client-core-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    master: Unpacking mysql-client-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Selecting previously unselected package mysql-client-8.0.
    master: Preparing to unpack .../2-mysql-client-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    master: Unpacking mysql-client-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Preparing to unpack .../3-libevent-core-2.1-7_2.1.12-stable-1ubuntu0.2_amd64.deb ...
    master: Unpacking libevent-core-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) over (2.1.12-stable-1build3) ...
    master: Selecting previously unselected package libevent-pthreads-2.1-7:amd64.
    master: Preparing to unpack .../4-libevent-pthreads-2.1-7_2.1.12-stable-1ubuntu0.2_amd64.deb ...
    master: Unpacking libevent-pthreads-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) ...
    master: Selecting previously unselected package libmecab2:amd64.
    master: Preparing to unpack .../5-libmecab2_0.996-14build9_amd64.deb ...
    master: Unpacking libmecab2:amd64 (0.996-14build9) ...
    master: Selecting previously unselected package libprotobuf-lite23:amd64.
    master: Preparing to unpack .../6-libprotobuf-lite23_3.12.4-1ubuntu7.22.04.6_amd64.deb ...
    master: Unpacking libprotobuf-lite23:amd64 (3.12.4-1ubuntu7.22.04.6) ...
    master: Selecting previously unselected package mysql-server-core-8.0.
    master: Preparing to unpack .../7-mysql-server-core-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    master: Unpacking mysql-server-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Setting up mysql-common (5.8+1.0.8) ...
    master: update-alternatives: using /etc/mysql/my.cnf.fallback to provide /etc/mysql/my.cnf (my.cnf) in auto mode
    master: Selecting previously unselected package mysql-server-8.0.
(Reading database ... 76538 files and directories currently installed.)
    master: Preparing to unpack .../00-mysql-server-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    master: Unpacking mysql-server-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Selecting previously unselected package libhtml-tagset-perl.
    master: Preparing to unpack .../01-libhtml-tagset-perl_3.20-4_all.deb ...
    master: Unpacking libhtml-tagset-perl (3.20-4) ...
    master: Selecting previously unselected package liburi-perl.
    master: Preparing to unpack .../02-liburi-perl_5.10-1_all.deb ...
    master: Unpacking liburi-perl (5.10-1) ...
    master: Selecting previously unselected package libhtml-parser-perl:amd64.
    master: Preparing to unpack .../03-libhtml-parser-perl_3.76-1ubuntu0.1_amd64.deb ...
    master: Unpacking libhtml-parser-perl:amd64 (3.76-1ubuntu0.1) ...
    master: Selecting previously unselected package libcgi-pm-perl.
    master: Preparing to unpack .../04-libcgi-pm-perl_4.54-1_all.deb ...
    master: Unpacking libcgi-pm-perl (4.54-1) ...
    master: Selecting previously unselected package libfcgi0ldbl:amd64.
    master: Preparing to unpack .../05-libfcgi0ldbl_2.4.2-2ubuntu0.1_amd64.deb ...
    master: Unpacking libfcgi0ldbl:amd64 (2.4.2-2ubuntu0.1) ...
    master: Selecting previously unselected package libfcgi-perl:amd64.
    master: Preparing to unpack .../06-libfcgi-perl_0.82+ds-1build1_amd64.deb ...
    master: Unpacking libfcgi-perl:amd64 (0.82+ds-1build1) ...
    master: Selecting previously unselected package libcgi-fast-perl.
    master: Preparing to unpack .../07-libcgi-fast-perl_1%3a2.15-1_all.deb ...
    master: Unpacking libcgi-fast-perl (1:2.15-1) ...
    master: Selecting previously unselected package libclone-perl.
    master: Preparing to unpack .../08-libclone-perl_0.45-1build3_amd64.deb ...
    master: Unpacking libclone-perl (0.45-1build3) ...
    master: Selecting previously unselected package libencode-locale-perl.
    master: Preparing to unpack .../09-libencode-locale-perl_1.05-1.1_all.deb ...
    master: Unpacking libencode-locale-perl (1.05-1.1) ...
    master: Selecting previously unselected package libfcgi-bin.
    master: Preparing to unpack .../10-libfcgi-bin_2.4.2-2ubuntu0.1_amd64.deb ...
    master: Unpacking libfcgi-bin (2.4.2-2ubuntu0.1) ...
    master: Selecting previously unselected package libhtml-template-perl.
    master: Preparing to unpack .../11-libhtml-template-perl_2.97-1.1_all.deb ...
    master: Unpacking libhtml-template-perl (2.97-1.1) ...
    master: Selecting previously unselected package libtimedate-perl.
    master: Preparing to unpack .../12-libtimedate-perl_2.3300-2_all.deb ...
    master: Unpacking libtimedate-perl (2.3300-2) ...
    master: Selecting previously unselected package libhttp-date-perl.
    master: Preparing to unpack .../13-libhttp-date-perl_6.05-1ubuntu0.1_all.deb ...
    master: Unpacking libhttp-date-perl (6.05-1ubuntu0.1) ...
    master: Selecting previously unselected package libio-html-perl.
    master: Preparing to unpack .../14-libio-html-perl_1.004-2_all.deb ...
    master: Unpacking libio-html-perl (1.004-2) ...
    master: Selecting previously unselected package liblwp-mediatypes-perl.
    master: Preparing to unpack .../15-liblwp-mediatypes-perl_6.04-1_all.deb ...
    master: Unpacking liblwp-mediatypes-perl (6.04-1) ...
    master: Selecting previously unselected package libhttp-message-perl.
    master: Preparing to unpack .../16-libhttp-message-perl_6.36-1_all.deb ...
    master: Unpacking libhttp-message-perl (6.36-1) ...
    master: Selecting previously unselected package mecab-utils.
    master: Preparing to unpack .../17-mecab-utils_0.996-14build9_amd64.deb ...
    master: Unpacking mecab-utils (0.996-14build9) ...
    master: Selecting previously unselected package mecab-ipadic.
    master: Preparing to unpack .../18-mecab-ipadic_2.7.0-20070801+main-3_all.deb ...
    master: Unpacking mecab-ipadic (2.7.0-20070801+main-3) ...
    master: Selecting previously unselected package mecab-ipadic-utf8.
    master: Preparing to unpack .../19-mecab-ipadic-utf8_2.7.0-20070801+main-3_all.deb ...
    master: Unpacking mecab-ipadic-utf8 (2.7.0-20070801+main-3) ...
    master: Setting up libmecab2:amd64 (0.996-14build9) ...
    master: Setting up mysql-client-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Setting up libfcgi0ldbl:amd64 (2.4.2-2ubuntu0.1) ...
    master: Setting up libclone-perl (0.45-1build3) ...
    master: Setting up libhtml-tagset-perl (3.20-4) ...
    master: Setting up liblwp-mediatypes-perl (6.04-1) ...
    master: Setting up libfcgi-bin (2.4.2-2ubuntu0.1) ...
    master: Setting up libencode-locale-perl (1.05-1.1) ...
    master: Setting up libprotobuf-lite23:amd64 (3.12.4-1ubuntu7.22.04.6) ...
    master: Setting up mecab-utils (0.996-14build9) ...
    master: Setting up libevent-core-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) ...
    master: Setting up libio-html-perl (1.004-2) ...
    master: Setting up libtimedate-perl (2.3300-2) ...
    master: Setting up mysql-client-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Setting up libfcgi-perl:amd64 (0.82+ds-1build1) ...
    master: Setting up liburi-perl (5.10-1) ...
    master: Setting up libevent-pthreads-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) ...
    master: Setting up libhttp-date-perl (6.05-1ubuntu0.1) ...
    master: Setting up mecab-ipadic (2.7.0-20070801+main-3) ...
    master: Compiling IPA dictionary for Mecab.  This takes long time...
    master: reading /usr/share/mecab/dic/ipadic/unk.def ... 40
emitting double-array: 100% |###########################################|           |
    master: /usr/share/mecab/dic/ipadic/model.def is not found. skipped.
    master: reading /usr/share/mecab/dic/ipadic/Noun.place.csv ... 72999
    master: reading /usr/share/mecab/dic/ipadic/Others.csv ... 2
    master: reading /usr/share/mecab/dic/ipadic/Noun.csv ... 60477
    master: reading /usr/share/mecab/dic/ipadic/Adj.csv ... 27210
    master: reading /usr/share/mecab/dic/ipadic/Interjection.csv ... 252
    master: reading /usr/share/mecab/dic/ipadic/Conjunction.csv ... 171
    master: reading /usr/share/mecab/dic/ipadic/Noun.demonst.csv ... 120
    master: reading /usr/share/mecab/dic/ipadic/Filler.csv ... 19
    master: reading /usr/share/mecab/dic/ipadic/Postp.csv ... 146
    master: reading /usr/share/mecab/dic/ipadic/Symbol.csv ... 208
    master: reading /usr/share/mecab/dic/ipadic/Auxil.csv ... 199
    master: reading /usr/share/mecab/dic/ipadic/Noun.org.csv ... 16668
    master: reading /usr/share/mecab/dic/ipadic/Prefix.csv ... 221
    master: reading /usr/share/mecab/dic/ipadic/Noun.nai.csv ... 42
    master: reading /usr/share/mecab/dic/ipadic/Noun.adverbal.csv ... 795
    master: reading /usr/share/mecab/dic/ipadic/Adverb.csv ... 3032
    master: reading /usr/share/mecab/dic/ipadic/Adnominal.csv ... 135
    master: reading /usr/share/mecab/dic/ipadic/Noun.verbal.csv ... 12146
    master: reading /usr/share/mecab/dic/ipadic/Noun.adjv.csv ... 3328
    master: reading /usr/share/mecab/dic/ipadic/Noun.name.csv ... 34202
    master: reading /usr/share/mecab/dic/ipadic/Noun.proper.csv ... 27328
    master: reading /usr/share/mecab/dic/ipadic/Verb.csv ... 130750
    master: reading /usr/share/mecab/dic/ipadic/Noun.number.csv ... 42
    master: reading /usr/share/mecab/dic/ipadic/Suffix.csv ... 1393
    master: reading /usr/share/mecab/dic/ipadic/Postp-col.csv ... 91
    master: reading /usr/share/mecab/dic/ipadic/Noun.others.csv ... 151
emitting double-array:  66% |############################               |           |
emitting double-array: 100% |###########################################|           |
    master: reading /usr/share/mecab/dic/ipadic/matrix.def ... 1316x1316
emitting matrix      :  66% |############################               |           |
emitting matrix      : 100% |###########################################|           |
    master:
    master: done!
    master: update-alternatives: using /var/lib/mecab/dic/ipadic to provide /var/lib/mecab/dic/debian (mecab-dictionary) in auto mode
    master: Setting up mysql-server-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: Setting up mecab-ipadic-utf8 (2.7.0-20070801+main-3) ...
    master: Compiling IPA dictionary for Mecab.  This takes long time...
    master: reading /usr/share/mecab/dic/ipadic/unk.def ... 40
emitting double-array: 100% |###########################################|           |
    master: /usr/share/mecab/dic/ipadic/model.def is not found. skipped.
    master: reading /usr/share/mecab/dic/ipadic/Noun.place.csv ... 72999
    master: reading /usr/share/mecab/dic/ipadic/Others.csv ... 2
    master: reading /usr/share/mecab/dic/ipadic/Noun.csv ... 60477
    master: reading /usr/share/mecab/dic/ipadic/Adj.csv ... 27210
    master: reading /usr/share/mecab/dic/ipadic/Interjection.csv ... 252
    master: reading /usr/share/mecab/dic/ipadic/Conjunction.csv ... 171
    master: reading /usr/share/mecab/dic/ipadic/Noun.demonst.csv ... 120
    master: reading /usr/share/mecab/dic/ipadic/Filler.csv ... 19
    master: reading /usr/share/mecab/dic/ipadic/Postp.csv ... 146
    master: reading /usr/share/mecab/dic/ipadic/Symbol.csv ... 208
    master: reading /usr/share/mecab/dic/ipadic/Auxil.csv ... 199
    master: reading /usr/share/mecab/dic/ipadic/Noun.org.csv ... 16668
    master: reading /usr/share/mecab/dic/ipadic/Prefix.csv ... 221
    master: reading /usr/share/mecab/dic/ipadic/Noun.nai.csv ... 42
    master: reading /usr/share/mecab/dic/ipadic/Noun.adverbal.csv ... 795
    master: reading /usr/share/mecab/dic/ipadic/Adverb.csv ... 3032
    master: reading /usr/share/mecab/dic/ipadic/Adnominal.csv ... 135
    master: reading /usr/share/mecab/dic/ipadic/Noun.verbal.csv ... 12146
    master: reading /usr/share/mecab/dic/ipadic/Noun.adjv.csv ... 3328
    master: reading /usr/share/mecab/dic/ipadic/Noun.name.csv ... 34202
    master: reading /usr/share/mecab/dic/ipadic/Noun.proper.csv ... 27328
    master: reading /usr/share/mecab/dic/ipadic/Verb.csv ... 130750
    master: reading /usr/share/mecab/dic/ipadic/Noun.number.csv ... 42
    master: reading /usr/share/mecab/dic/ipadic/Suffix.csv ... 1393
    master: reading /usr/share/mecab/dic/ipadic/Postp-col.csv ... 91
    master: reading /usr/share/mecab/dic/ipadic/Noun.others.csv ... 151
emitting double-array:  66% |############################               |           |
emitting double-array: 100% |###########################################|           |
    master: reading /usr/share/mecab/dic/ipadic/matrix.def ... 1316x1316
emitting matrix      :  66% |############################               |           |
emitting matrix      : 100% |###########################################|           |
    master:
    master: done!
    master: update-alternatives: using /var/lib/mecab/dic/ipadic-utf8 to provide /var/lib/mecab/dic/debian (mecab-dictionary) in auto mode
    master: Setting up libhtml-parser-perl:amd64 (3.76-1ubuntu0.1) ...
    master: Setting up libhttp-message-perl (6.36-1) ...
    master: Setting up mysql-server-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    master: update-alternatives: using /etc/mysql/mysql.cnf to provide /etc/mysql/my.cnf (my.cnf) in auto mode
    master: Renaming removed key_buffer and myisam-recover options (if present)
    master: mysqld will log errors to /var/log/mysql/error.log
    master: mysqld is running as pid 3276
    master: Created symlink /etc/systemd/system/multi-user.target.wants/mysql.service → /lib/systemd/system/mysql.service.
    master: Setting up libcgi-pm-perl (4.54-1) ...
    master: Setting up libhtml-template-perl (2.97-1.1) ...
    master: Setting up libcgi-fast-perl (1:2.15-1) ...
    master: Processing triggers for man-db (2.10.2-1) ...
    master: Processing triggers for libc-bin (2.35-0ubuntu3.6) ...
    master: NEEDRESTART-VER: 3.5
    master: NEEDRESTART-KCUR: 5.15.0-91-generic
    master: NEEDRESTART-KEXP: 5.15.0-91-generic
    master: NEEDRESTART-KSTA: 1
    master: 1   ON      ON
root@nfsc:~/mysql-gtid-hw#

#реплика
root@nfsc:~/mysql-gtid-hw# cd ~/mysql-gtid-hw
vagrant up replica --provider=virtualbox --no-provision &&
vagrant ssh replica -c 'getent ahostsv4 mirrors.edge.kernel.org && echo DNS_OK'
Bringing machine 'replica' up with 'virtualbox' provider...
==> replica: Importing base box 'generic/ubuntu2204'...
==> replica: Matching MAC address for NAT networking...
==> replica: Checking if box 'generic/ubuntu2204' version '4.3.12' is up to date...
==> replica: Setting the name of the VM: mysql-gtid-replica
==> replica: Fixed port collision for 22 => 2222. Now on port 2200.
==> replica: Clearing any previously set network interfaces...
==> replica: Preparing network interfaces based on configuration...
    replica: Adapter 1: nat
    replica: Adapter 2: intnet
==> replica: Forwarding ports...
    replica: 22 (guest) => 2200 (host) (adapter 1)
==> replica: Running 'pre-boot' VM customizations...
==> replica: Booting VM...
==> replica: Waiting for machine to boot. This may take a few minutes...
    replica: SSH address: 127.0.0.1:2200
    replica: SSH username: vagrant
    replica: SSH auth method: private key
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica: Warning: Connection reset. Retrying...
    replica:
    replica: Vagrant insecure key detected. Vagrant will automatically replace
    replica: this with a newly generated keypair for better security.
    replica:
    replica: Inserting generated public key within guest...
    replica: Removing insecure key from the guest if it's present...
    replica: Key inserted! Disconnecting and reconnecting using new SSH key...
==> replica: Machine booted and ready!
==> replica: Checking for guest additions in VM...
    replica: The guest additions on this VM do not match the installed version of
    replica: VirtualBox! In most cases this is fine, but in rare cases it can
    replica: prevent things such as shared folders from working properly. If you see
    replica: shared folder errors, please make sure the guest additions within the
    replica: virtual machine match the version of VirtualBox you have installed on
    replica: your host and reload your VM.
    replica:
    replica: Guest Additions Version: 6.1.38
    replica: VirtualBox Version: 7.0
==> replica: Setting hostname...
==> replica: Configuring and enabling network interfaces...
==> replica: Machine not provisioned because `--no-provision` is specified.
root@nfsc:~/mysql-gtid-hw#

```


```bash
root@nfsc:~/mysql-gtid-hw# set -o pipefail
vagrant provision replica &&
bash verify.sh 2>&1 | tee verification.log
==> replica: Running provisioner: shell...
    replica: Running: inline script
==> replica: Running provisioner: file...
    replica: conf/replica.cnf => /home/vagrant/.mysql-gtid-lab/mysql.cnf
==> replica: Running provisioner: file...
    replica: .local/repl-password => /home/vagrant/.mysql-gtid-lab/repl-password
==> replica: Running provisioner: shell...
    replica: Running: /tmp/vagrant-shell20261116-673957-uzlyz7.sh
    replica: Hit:1 https://mirrors.edge.kernel.org/ubuntu jammy InRelease
    replica: Get:2 https://mirrors.edge.kernel.org/ubuntu jammy-updates InRelease [128 kB]
    replica: Get:3 https://mirrors.edge.kernel.org/ubuntu jammy-backports InRelease [127 kB]
    replica: Get:4 https://mirrors.edge.kernel.org/ubuntu jammy-security InRelease [129 kB]
    replica: Get:5 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 Packages [3,983 kB]
    replica: Get:6 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main Translation-en [585 kB]
    replica: Get:7 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 c-n-f Metadata [20.1 kB]
    replica: Get:8 https://mirrors.edge.kernel.org/ubuntu jammy-updates/restricted amd64 Packages [6,848 kB]
    replica: Get:9 https://mirrors.edge.kernel.org/ubuntu jammy-updates/restricted Translation-en [1,316 kB]
    replica: Get:10 https://mirrors.edge.kernel.org/ubuntu jammy-updates/restricted amd64 c-n-f Metadata [584 B]
    replica: Get:11 https://mirrors.edge.kernel.org/ubuntu jammy-updates/universe amd64 Packages [1,290 kB]
    replica: Get:12 https://mirrors.edge.kernel.org/ubuntu jammy-updates/universe Translation-en [326 kB]
    replica: Get:13 https://mirrors.edge.kernel.org/ubuntu jammy-updates/universe amd64 c-n-f Metadata [30.8 kB]
    replica: Get:14 https://mirrors.edge.kernel.org/ubuntu jammy-updates/multiverse amd64 Packages [86.1 kB]
    replica: Get:15 https://mirrors.edge.kernel.org/ubuntu jammy-updates/multiverse Translation-en [16.5 kB]
    replica: Get:16 https://mirrors.edge.kernel.org/ubuntu jammy-updates/multiverse amd64 c-n-f Metadata [756 B]
    replica: Get:17 https://mirrors.edge.kernel.org/ubuntu jammy-backports/main amd64 Packages [70.2 kB]
    replica: Get:18 https://mirrors.edge.kernel.org/ubuntu jammy-backports/main Translation-en [11.4 kB]
    replica: Get:19 https://mirrors.edge.kernel.org/ubuntu jammy-backports/main amd64 c-n-f Metadata [412 B]
    replica: Get:20 https://mirrors.edge.kernel.org/ubuntu jammy-backports/universe amd64 Packages [30.8 kB]
    replica: Get:21 https://mirrors.edge.kernel.org/ubuntu jammy-backports/universe Translation-en [16.9 kB]
    replica: Get:22 https://mirrors.edge.kernel.org/ubuntu jammy-backports/universe amd64 c-n-f Metadata [676 B]
    replica: Get:23 https://mirrors.edge.kernel.org/ubuntu jammy-security/main amd64 Packages [3,718 kB]
    replica: Get:24 https://mirrors.edge.kernel.org/ubuntu jammy-security/main Translation-en [519 kB]
    replica: Get:25 https://mirrors.edge.kernel.org/ubuntu jammy-security/main amd64 c-n-f Metadata [14.7 kB]
    replica: Get:26 https://mirrors.edge.kernel.org/ubuntu jammy-security/restricted amd64 Packages [6,613 kB]
    replica: Get:27 https://mirrors.edge.kernel.org/ubuntu jammy-security/restricted Translation-en [1,272 kB]
    replica: Get:28 https://mirrors.edge.kernel.org/ubuntu jammy-security/restricted amd64 c-n-f Metadata [600 B]
    replica: Get:29 https://mirrors.edge.kernel.org/ubuntu jammy-security/universe amd64 Packages [1,057 kB]
    replica: Get:30 https://mirrors.edge.kernel.org/ubuntu jammy-security/universe Translation-en [238 kB]
    replica: Get:31 https://mirrors.edge.kernel.org/ubuntu jammy-security/universe amd64 c-n-f Metadata [23.2 kB]
    replica: Get:32 https://mirrors.edge.kernel.org/ubuntu jammy-security/multiverse amd64 Packages [79.6 kB]
    replica: Get:33 https://mirrors.edge.kernel.org/ubuntu jammy-security/multiverse Translation-en [13.6 kB]
    replica: Get:34 https://mirrors.edge.kernel.org/ubuntu jammy-security/multiverse amd64 c-n-f Metadata [544 B]
    replica: Fetched 28.6 MB in 44s (651 kB/s)
    replica: Reading package lists...
    replica: Reading package lists...
    replica: Building dependency tree...
    replica: Reading state information...
    replica: The following additional packages will be installed:
    replica:   libcgi-fast-perl libcgi-pm-perl libclone-perl libencode-locale-perl
    replica:   libevent-core-2.1-7 libevent-pthreads-2.1-7 libfcgi-bin libfcgi-perl
    replica:   libfcgi0ldbl libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
    replica:   libhttp-date-perl libhttp-message-perl libio-html-perl
    replica:   liblwp-mediatypes-perl libmecab2 libprotobuf-lite23 libtimedate-perl
    replica:   liburi-perl mecab-ipadic mecab-ipadic-utf8 mecab-utils mysql-client-8.0
    replica:   mysql-client-core-8.0 mysql-common mysql-server-core-8.0
    replica: Suggested packages:
    replica:   libdata-dump-perl libipc-sharedcache-perl libbusiness-isbn-perl libwww-perl
    replica:   mailx tinyca
    replica: The following NEW packages will be installed:
    replica:   libcgi-fast-perl libcgi-pm-perl libclone-perl libencode-locale-perl
    replica:   libevent-pthreads-2.1-7 libfcgi-bin libfcgi-perl libfcgi0ldbl
    replica:   libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
    replica:   libhttp-date-perl libhttp-message-perl libio-html-perl
    replica:   liblwp-mediatypes-perl libmecab2 libprotobuf-lite23 libtimedate-perl
    replica:   liburi-perl mecab-ipadic mecab-ipadic-utf8 mecab-utils mysql-client-8.0
    replica:   mysql-client-core-8.0 mysql-common mysql-server-8.0 mysql-server-core-8.0
    replica: The following packages will be upgraded:
    replica:   libevent-core-2.1-7
    replica: 1 upgraded, 27 newly installed, 0 to remove and 298 not upgraded.
    replica: Need to get 29.9 MB of archives.
    replica: After this operation, 244 MB of additional disk space will be used.
    replica: Get:1 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mysql-common all 5.8+1.0.8 [7,212 B]
    replica: Get:2 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-client-core-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [2,721 kB]
    replica: Get:3 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-client-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [22.7 kB]
    replica: Get:4 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libevent-core-2.1-7 amd64 2.1.12-stable-1ubuntu0.2 [94.8 kB]
    replica: Get:5 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libevent-pthreads-2.1-7 amd64 2.1.12-stable-1ubuntu0.2 [7,644 B]
    replica: Get:6 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libmecab2 amd64 0.996-14build9 [199 kB]
    replica: Get:7 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libprotobuf-lite23 amd64 3.12.4-1ubuntu7.22.04.6 [209 kB]
    replica: Get:8 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-server-core-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [17.8 MB]
    replica: Get:9 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 mysql-server-8.0 amd64 8.0.46-0ubuntu0.22.04.5 [1,452 kB]
    replica: Get:10 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libhtml-tagset-perl all 3.20-4 [12.5 kB]
    replica: Get:11 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 liburi-perl all 5.10-1 [78.8 kB]
    replica: Get:12 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libhtml-parser-perl amd64 3.76-1ubuntu0.1 [88.6 kB]
    replica: Get:13 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libcgi-pm-perl all 4.54-1 [188 kB]
    replica: Get:14 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libfcgi0ldbl amd64 2.4.2-2ubuntu0.1 [28.1 kB]
    replica: Get:15 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libfcgi-perl amd64 0.82+ds-1build1 [22.8 kB]
    replica: Get:16 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libcgi-fast-perl all 1:2.15-1 [10.5 kB]
    replica: Get:17 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libclone-perl amd64 0.45-1build3 [11.0 kB]
    replica: Get:18 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libencode-locale-perl all 1.05-1.1 [11.8 kB]
    replica: Get:19 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libfcgi-bin amd64 2.4.2-2ubuntu0.1 [11.1 kB]
    replica: Get:20 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libhtml-template-perl all 2.97-1.1 [59.1 kB]
    replica: Get:21 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libtimedate-perl all 2.3300-2 [34.0 kB]
    replica: Get:22 https://mirrors.edge.kernel.org/ubuntu jammy-updates/main amd64 libhttp-date-perl all 6.05-1ubuntu0.1 [10.8 kB]
    replica: Get:23 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libio-html-perl all 1.004-2 [15.4 kB]
    replica: Get:24 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 liblwp-mediatypes-perl all 6.04-1 [19.5 kB]
    replica: Get:25 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 libhttp-message-perl all 6.36-1 [76.8 kB]
    replica: Get:26 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mecab-utils amd64 0.996-14build9 [4,850 B]
    replica: Get:27 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mecab-ipadic all 2.7.0-20070801+main-3 [6,718 kB]
    replica: Get:28 https://mirrors.edge.kernel.org/ubuntu jammy/main amd64 mecab-ipadic-utf8 all 2.7.0-20070801+main-3 [4,384 B]
    replica: Preconfiguring packages ...
    replica: Fetched 29.9 MB in 22s (1,333 kB/s)
    replica: Selecting previously unselected package mysql-common.
(Reading database ... 76324 files and directories currently installed.)
    replica: Preparing to unpack .../0-mysql-common_5.8+1.0.8_all.deb ...
    replica: Unpacking mysql-common (5.8+1.0.8) ...
    replica: Selecting previously unselected package mysql-client-core-8.0.
    replica: Preparing to unpack .../1-mysql-client-core-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    replica: Unpacking mysql-client-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Selecting previously unselected package mysql-client-8.0.
    replica: Preparing to unpack .../2-mysql-client-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    replica: Unpacking mysql-client-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Preparing to unpack .../3-libevent-core-2.1-7_2.1.12-stable-1ubuntu0.2_amd64.deb ...
    replica: Unpacking libevent-core-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) over (2.1.12-stable-1build3) ...
    replica: Selecting previously unselected package libevent-pthreads-2.1-7:amd64.
    replica: Preparing to unpack .../4-libevent-pthreads-2.1-7_2.1.12-stable-1ubuntu0.2_amd64.deb ...
    replica: Unpacking libevent-pthreads-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) ...
    replica: Selecting previously unselected package libmecab2:amd64.
    replica: Preparing to unpack .../5-libmecab2_0.996-14build9_amd64.deb ...
    replica: Unpacking libmecab2:amd64 (0.996-14build9) ...
    replica: Selecting previously unselected package libprotobuf-lite23:amd64.
    replica: Preparing to unpack .../6-libprotobuf-lite23_3.12.4-1ubuntu7.22.04.6_amd64.deb ...
    replica: Unpacking libprotobuf-lite23:amd64 (3.12.4-1ubuntu7.22.04.6) ...
    replica: Selecting previously unselected package mysql-server-core-8.0.
    replica: Preparing to unpack .../7-mysql-server-core-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    replica: Unpacking mysql-server-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Setting up mysql-common (5.8+1.0.8) ...
    replica: update-alternatives: using /etc/mysql/my.cnf.fallback to provide /etc/mysql/my.cnf (my.cnf) in auto mode
    replica: Selecting previously unselected package mysql-server-8.0.
(Reading database ... 76538 files and directories currently installed.)
    replica: Preparing to unpack .../00-mysql-server-8.0_8.0.46-0ubuntu0.22.04.5_amd64.deb ...
    replica: Unpacking mysql-server-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Selecting previously unselected package libhtml-tagset-perl.
    replica: Preparing to unpack .../01-libhtml-tagset-perl_3.20-4_all.deb ...
    replica: Unpacking libhtml-tagset-perl (3.20-4) ...
    replica: Selecting previously unselected package liburi-perl.
    replica: Preparing to unpack .../02-liburi-perl_5.10-1_all.deb ...
    replica: Unpacking liburi-perl (5.10-1) ...
    replica: Selecting previously unselected package libhtml-parser-perl:amd64.
    replica: Preparing to unpack .../03-libhtml-parser-perl_3.76-1ubuntu0.1_amd64.deb ...
    replica: Unpacking libhtml-parser-perl:amd64 (3.76-1ubuntu0.1) ...
    replica: Selecting previously unselected package libcgi-pm-perl.
    replica: Preparing to unpack .../04-libcgi-pm-perl_4.54-1_all.deb ...
    replica: Unpacking libcgi-pm-perl (4.54-1) ...
    replica: Selecting previously unselected package libfcgi0ldbl:amd64.
    replica: Preparing to unpack .../05-libfcgi0ldbl_2.4.2-2ubuntu0.1_amd64.deb ...
    replica: Unpacking libfcgi0ldbl:amd64 (2.4.2-2ubuntu0.1) ...
    replica: Selecting previously unselected package libfcgi-perl:amd64.
    replica: Preparing to unpack .../06-libfcgi-perl_0.82+ds-1build1_amd64.deb ...
    replica: Unpacking libfcgi-perl:amd64 (0.82+ds-1build1) ...
    replica: Selecting previously unselected package libcgi-fast-perl.
    replica: Preparing to unpack .../07-libcgi-fast-perl_1%3a2.15-1_all.deb ...
    replica: Unpacking libcgi-fast-perl (1:2.15-1) ...
    replica: Selecting previously unselected package libclone-perl.
    replica: Preparing to unpack .../08-libclone-perl_0.45-1build3_amd64.deb ...
    replica: Unpacking libclone-perl (0.45-1build3) ...
    replica: Selecting previously unselected package libencode-locale-perl.
    replica: Preparing to unpack .../09-libencode-locale-perl_1.05-1.1_all.deb ...
    replica: Unpacking libencode-locale-perl (1.05-1.1) ...
    replica: Selecting previously unselected package libfcgi-bin.
    replica: Preparing to unpack .../10-libfcgi-bin_2.4.2-2ubuntu0.1_amd64.deb ...
    replica: Unpacking libfcgi-bin (2.4.2-2ubuntu0.1) ...
    replica: Selecting previously unselected package libhtml-template-perl.
    replica: Preparing to unpack .../11-libhtml-template-perl_2.97-1.1_all.deb ...
    replica: Unpacking libhtml-template-perl (2.97-1.1) ...
    replica: Selecting previously unselected package libtimedate-perl.
    replica: Preparing to unpack .../12-libtimedate-perl_2.3300-2_all.deb ...
    replica: Unpacking libtimedate-perl (2.3300-2) ...
    replica: Selecting previously unselected package libhttp-date-perl.
    replica: Preparing to unpack .../13-libhttp-date-perl_6.05-1ubuntu0.1_all.deb ...
    replica: Unpacking libhttp-date-perl (6.05-1ubuntu0.1) ...
    replica: Selecting previously unselected package libio-html-perl.
    replica: Preparing to unpack .../14-libio-html-perl_1.004-2_all.deb ...
    replica: Unpacking libio-html-perl (1.004-2) ...
    replica: Selecting previously unselected package liblwp-mediatypes-perl.
    replica: Preparing to unpack .../15-liblwp-mediatypes-perl_6.04-1_all.deb ...
    replica: Unpacking liblwp-mediatypes-perl (6.04-1) ...
    replica: Selecting previously unselected package libhttp-message-perl.
    replica: Preparing to unpack .../16-libhttp-message-perl_6.36-1_all.deb ...
    replica: Unpacking libhttp-message-perl (6.36-1) ...
    replica: Selecting previously unselected package mecab-utils.
    replica: Preparing to unpack .../17-mecab-utils_0.996-14build9_amd64.deb ...
    replica: Unpacking mecab-utils (0.996-14build9) ...
    replica: Selecting previously unselected package mecab-ipadic.
    replica: Preparing to unpack .../18-mecab-ipadic_2.7.0-20070801+main-3_all.deb ...
    replica: Unpacking mecab-ipadic (2.7.0-20070801+main-3) ...
    replica: Selecting previously unselected package mecab-ipadic-utf8.
    replica: Preparing to unpack .../19-mecab-ipadic-utf8_2.7.0-20070801+main-3_all.deb ...
    replica: Unpacking mecab-ipadic-utf8 (2.7.0-20070801+main-3) ...
    replica: Setting up libmecab2:amd64 (0.996-14build9) ...
    replica: Setting up mysql-client-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Setting up libfcgi0ldbl:amd64 (2.4.2-2ubuntu0.1) ...
    replica: Setting up libclone-perl (0.45-1build3) ...
    replica: Setting up libhtml-tagset-perl (3.20-4) ...
    replica: Setting up liblwp-mediatypes-perl (6.04-1) ...
    replica: Setting up libfcgi-bin (2.4.2-2ubuntu0.1) ...
    replica: Setting up libencode-locale-perl (1.05-1.1) ...
    replica: Setting up libprotobuf-lite23:amd64 (3.12.4-1ubuntu7.22.04.6) ...
    replica: Setting up mecab-utils (0.996-14build9) ...
    replica: Setting up libevent-core-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) ...
    replica: Setting up libio-html-perl (1.004-2) ...
    replica: Setting up libtimedate-perl (2.3300-2) ...
    replica: Setting up mysql-client-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Setting up libfcgi-perl:amd64 (0.82+ds-1build1) ...
    replica: Setting up liburi-perl (5.10-1) ...
    replica: Setting up libevent-pthreads-2.1-7:amd64 (2.1.12-stable-1ubuntu0.2) ...
    replica: Setting up libhttp-date-perl (6.05-1ubuntu0.1) ...
    replica: Setting up mecab-ipadic (2.7.0-20070801+main-3) ...
    replica: Compiling IPA dictionary for Mecab.  This takes long time...
    replica: reading /usr/share/mecab/dic/ipadic/unk.def ... 40
emitting double-array: 100% |###########################################|            |
    replica: /usr/share/mecab/dic/ipadic/model.def is not found. skipped.
    replica: reading /usr/share/mecab/dic/ipadic/Noun.place.csv ... 72999
    replica: reading /usr/share/mecab/dic/ipadic/Others.csv ... 2
    replica: reading /usr/share/mecab/dic/ipadic/Noun.csv ... 60477
    replica: reading /usr/share/mecab/dic/ipadic/Adj.csv ... 27210
    replica: reading /usr/share/mecab/dic/ipadic/Interjection.csv ... 252
    replica: reading /usr/share/mecab/dic/ipadic/Conjunction.csv ... 171
    replica: reading /usr/share/mecab/dic/ipadic/Noun.demonst.csv ... 120
    replica: reading /usr/share/mecab/dic/ipadic/Filler.csv ... 19
    replica: reading /usr/share/mecab/dic/ipadic/Postp.csv ... 146
    replica: reading /usr/share/mecab/dic/ipadic/Symbol.csv ... 208
    replica: reading /usr/share/mecab/dic/ipadic/Auxil.csv ... 199
    replica: reading /usr/share/mecab/dic/ipadic/Noun.org.csv ... 16668
    replica: reading /usr/share/mecab/dic/ipadic/Prefix.csv ... 221
    replica: reading /usr/share/mecab/dic/ipadic/Noun.nai.csv ... 42
    replica: reading /usr/share/mecab/dic/ipadic/Noun.adverbal.csv ... 795
    replica: reading /usr/share/mecab/dic/ipadic/Adverb.csv ... 3032
    replica: reading /usr/share/mecab/dic/ipadic/Adnominal.csv ... 135
    replica: reading /usr/share/mecab/dic/ipadic/Noun.verbal.csv ... 12146
    replica: reading /usr/share/mecab/dic/ipadic/Noun.adjv.csv ... 3328
    replica: reading /usr/share/mecab/dic/ipadic/Noun.name.csv ... 34202
    replica: reading /usr/share/mecab/dic/ipadic/Noun.proper.csv ... 27328
    replica: reading /usr/share/mecab/dic/ipadic/Verb.csv ... 130750
    replica: reading /usr/share/mecab/dic/ipadic/Noun.number.csv ... 42
    replica: reading /usr/share/mecab/dic/ipadic/Suffix.csv ... 1393
    replica: reading /usr/share/mecab/dic/ipadic/Postp-col.csv ... 91
    replica: reading /usr/share/mecab/dic/ipadic/Noun.others.csv ... 151
emitting double-array:  66% |############################               |            |
emitting double-array: 100% |###########################################|            |
    replica: reading /usr/share/mecab/dic/ipadic/matrix.def ... 1316x1316
emitting matrix      :  66% |############################               |            |
emitting matrix      : 100% |###########################################|            |
    replica:
    replica: done!
    replica: update-alternatives: using /var/lib/mecab/dic/ipadic to provide /var/lib/mecab/dic/debian (mecab-dictionary) in auto mode
    replica: Setting up mysql-server-core-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: Setting up mecab-ipadic-utf8 (2.7.0-20070801+main-3) ...
    replica: Compiling IPA dictionary for Mecab.  This takes long time...
    replica: reading /usr/share/mecab/dic/ipadic/unk.def ... 40
emitting double-array: 100% |###########################################|            |
    replica: /usr/share/mecab/dic/ipadic/model.def is not found. skipped.
    replica: reading /usr/share/mecab/dic/ipadic/Noun.place.csv ... 72999
    replica: reading /usr/share/mecab/dic/ipadic/Others.csv ... 2
    replica: reading /usr/share/mecab/dic/ipadic/Noun.csv ... 60477
    replica: reading /usr/share/mecab/dic/ipadic/Adj.csv ... 27210
    replica: reading /usr/share/mecab/dic/ipadic/Interjection.csv ... 252
    replica: reading /usr/share/mecab/dic/ipadic/Conjunction.csv ... 171
    replica: reading /usr/share/mecab/dic/ipadic/Noun.demonst.csv ... 120
    replica: reading /usr/share/mecab/dic/ipadic/Filler.csv ... 19
    replica: reading /usr/share/mecab/dic/ipadic/Postp.csv ... 146
    replica: reading /usr/share/mecab/dic/ipadic/Symbol.csv ... 208
    replica: reading /usr/share/mecab/dic/ipadic/Auxil.csv ... 199
    replica: reading /usr/share/mecab/dic/ipadic/Noun.org.csv ... 16668
    replica: reading /usr/share/mecab/dic/ipadic/Prefix.csv ... 221
    replica: reading /usr/share/mecab/dic/ipadic/Noun.nai.csv ... 42
    replica: reading /usr/share/mecab/dic/ipadic/Noun.adverbal.csv ... 795
    replica: reading /usr/share/mecab/dic/ipadic/Adverb.csv ... 3032
    replica: reading /usr/share/mecab/dic/ipadic/Adnominal.csv ... 135
    replica: reading /usr/share/mecab/dic/ipadic/Noun.verbal.csv ... 12146
    replica: reading /usr/share/mecab/dic/ipadic/Noun.adjv.csv ... 3328
    replica: reading /usr/share/mecab/dic/ipadic/Noun.name.csv ... 34202
    replica: reading /usr/share/mecab/dic/ipadic/Noun.proper.csv ... 27328
    replica: reading /usr/share/mecab/dic/ipadic/Verb.csv ... 130750
    replica: reading /usr/share/mecab/dic/ipadic/Noun.number.csv ... 42
    replica: reading /usr/share/mecab/dic/ipadic/Suffix.csv ... 1393
    replica: reading /usr/share/mecab/dic/ipadic/Postp-col.csv ... 91
    replica: reading /usr/share/mecab/dic/ipadic/Noun.others.csv ... 151
emitting double-array:  66% |############################               |            |
emitting double-array: 100% |###########################################|            |
    replica: reading /usr/share/mecab/dic/ipadic/matrix.def ... 1316x1316
emitting matrix      :  66% |############################               |            |
emitting matrix      : 100% |###########################################|            |
    replica:
    replica: done!
    replica: update-alternatives: using /var/lib/mecab/dic/ipadic-utf8 to provide /var/lib/mecab/dic/debian (mecab-dictionary) in auto mode
    replica: Setting up libhtml-parser-perl:amd64 (3.76-1ubuntu0.1) ...
    replica: Setting up libhttp-message-perl (6.36-1) ...
    replica: Setting up mysql-server-8.0 (8.0.46-0ubuntu0.22.04.5) ...
    replica: update-alternatives: using /etc/mysql/mysql.cnf to provide /etc/mysql/my.cnf (my.cnf) in auto mode
    replica: Renaming removed key_buffer and myisam-recover options (if present)
    replica: mysqld will log errors to /var/log/mysql/error.log
    replica: mysqld is running as pid 4288
    replica: Created symlink /etc/systemd/system/multi-user.target.wants/mysql.service → /lib/systemd/system/mysql.service.
    replica: Setting up libcgi-pm-perl (4.54-1) ...
    replica: Setting up libhtml-template-perl (2.97-1.1) ...
    replica: Setting up libcgi-fast-perl (1:2.15-1) ...
    replica: Processing triggers for man-db (2.10.2-1) ...
    replica: Processing triggers for libc-bin (2.35-0ubuntu3.6) ...
    replica: NEEDRESTART-VER: 3.5
    replica: NEEDRESTART-KCUR: 5.15.0-91-generic
    replica: NEEDRESTART-KEXP: 5.15.0-91-generic
    replica: NEEDRESTART-KSTA: 1
    replica: 2  ON      ON
=== GTID и идентификаторы серверов ===
master
@@server_id     @@gtid_mode     @@enforce_gtid_consistency
1       ON      ON
replica
@@server_id     @@gtid_mode     @@enforce_gtid_consistency
2       ON      ON
=== Состояние репликации ===
Реплика не применила GTID-набор за 60 секунд.
root@nfsc:~/mysql-gtid-hw#

```

проверки:

```bash
root@nfsc:~/mysql-gtid-hw# set -o pipefail
vagrant ssh replica -c '
  timeout 5 bash -c "true < /dev/tcp/192.168.57.10/3306" &&
  echo TCP_3306_OK &&
  sudo mysql -e "STOP REPLICA IO_THREAD; START REPLICA IO_THREAD;"
' &&
bash verify.sh 2>&1 | tee verification.log
TCP_3306_OK
=== GTID и идентификаторы серверов ===
master
@@server_id     @@gtid_mode     @@enforce_gtid_consistency
1       ON      ON
replica
@@server_id     @@gtid_mode     @@enforce_gtid_consistency
2       ON      ON
=== Состояние репликации ===
Реплика применила GTID-набор мастера.
                  Source_Host: 192.168.57.10
           Replica_IO_Running: Yes
          Replica_SQL_Running: Yes
           Replicate_Do_Table: bet.bookmaker,bet.competition,bet.market,bet.odds,bet.outcome
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
           Retrieved_Gtid_Set: 8cc68328-e1c6-11f1-abfe-0800278c6941:1-36
            Executed_Gtid_Set: 8cc68328-e1c6-11f1-abfe-0800278c6941:1-36
                Auto_Position: 1
=== SHOW TABLES FROM bet на мастере ===
Tables_in_bet
bookmaker
competition
events_on_demand
market
odds
outcome
v_same_event
=== SHOW TABLES FROM bet на реплике ===
Tables_in_bet
bookmaker
competition
market
odds
outcome
=== Число строк в исходных таблицах ===
bookmaker master=4 replica=4
competition master=335 replica=335
market master=7 replica=7
odds master=345 replica=345
outcome master=15 replica=15
=== INSERT на мастере: gtid_20261117161750_766 ===
Реплика применила GTID-набор мастера.
Строка на реплике после INSERT: 7 gtid_20261117161750_766
=== UPDATE на мастере: id=7 ===
Реплика применила GTID-набор мастера.
Строка на реплике после UPDATE: 7 gtid_20261117161750_766_updated
GTID, фильтрация, INSERT и UPDATE подтверждены.
root@nfsc:~/mysql-gtid-hw#


```

```bash
root@nfsc:~/mysql-gtid-hw# vagrant ssh master -c 'sudo mysql -e "SHOW TABLES FROM bet"'
vagrant ssh replica -c 'sudo mysql -e "SHOW TABLES FROM bet"'
vagrant ssh replica -c 'sudo mysql -e "SHOW REPLICA STATUS\G"'
+------------------+
| Tables_in_bet    |
+------------------+
| bookmaker        |
| competition      |
| events_on_demand |
| market           |
| odds             |
| outcome          |
| v_same_event     |
+------------------+
+---------------+
| Tables_in_bet |
+---------------+
| bookmaker     |
| competition   |
| market        |
| odds          |
| outcome       |
+---------------+
*************************** 1. row ***************************
             Replica_IO_State: Waiting for source to send event
                  Source_Host: 192.168.57.10
                  Source_User: repl
                  Source_Port: 3306
                Connect_Retry: 60
              Source_Log_File: mysql-bin.000002
          Read_Source_Log_Pos: 861
               Relay_Log_File: mysql-relay.000004
                Relay_Log_Pos: 1077
        Relay_Source_Log_File: mysql-bin.000002
           Replica_IO_Running: Yes
          Replica_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table: bet.bookmaker,bet.competition,bet.market,bet.odds,bet.outcome
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Source_Log_Pos: 861
              Relay_Log_Space: 1539
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Source_SSL_Allowed: Yes
           Source_SSL_CA_File:
           Source_SSL_CA_Path:
              Source_SSL_Cert:
            Source_SSL_Cipher:
               Source_SSL_Key:
        Seconds_Behind_Source: 0
Source_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Source_Server_Id: 1
                  Source_UUID: 8cc68328-e1c6-11f1-abfe-0800278c6941
             Source_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
    Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Source_Retry_Count: 86400
                  Source_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Source_SSL_Crl:
           Source_SSL_Crlpath:
           Retrieved_Gtid_Set: 8cc68328-e1c6-11f1-abfe-0800278c6941:1-38
            Executed_Gtid_Set: 8cc68328-e1c6-11f1-abfe-0800278c6941:1-38
                Auto_Position: 1
         Replicate_Rewrite_DB:
                 Channel_Name:
           Source_TLS_Version:
       Source_public_key_path:
        Get_Source_public_key: 0
            Network_Namespace:
root@nfsc:~/mysql-gtid-hw#

```
