Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C50159FA3
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 04:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgBLDri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 22:47:38 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46890 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgBLDri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 22:47:38 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so392880pll.13;
        Tue, 11 Feb 2020 19:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o1gSab9RBGNfpznRkEWgvvHyPClD+d3PTeto/J31Aq8=;
        b=sKBNp/v65rgHLyB09Gbi4HKDZ9blv+TALxDjSgDvA4zS241J0lPevhsPfHYug0CI3m
         Ercqdl0DJOKA9IsPsi1CT2ydW16yQ8E6SmpkNn71FqfKhpo4YiSyeSxDoSTjG1E0URTG
         S3xzrH9FpzFM+eTbmNDJCDKUu/XreeGrerlbR/meB0CylDffd7yr1SWAULNbVV7sHLuf
         mWh5Z5mQqeuoLAH5UxPJMfFQSUMk7XwPgmJiT0QLeQaKPkKEksgmxMigHqrUkUEil5N2
         uCRAWOq3PhpKuSFJsh7dIDPU17zc+au+VEbuF5z+XA1/Nn0eCi/SQCi9KVMTJGU0HL9L
         gKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o1gSab9RBGNfpznRkEWgvvHyPClD+d3PTeto/J31Aq8=;
        b=eS4JY2lJHproGh0IPmbtCbI+lTHIdeV9jFTR5lKzLKsAPjFnQ6nkFFfwWgljIRFds6
         UVSUywXbhWH6PE5lpRxQ1bATSoQ3kiW7dIv4w3+7jJv7jsBAD91L470Mp7ZutYK6DsTd
         ASaZiMreVQBf0M5rIBzkWSjRKAcPTmt5IYHBGQoZUKkxr1yDrf+GMPwjhFrm7fsb4k8W
         OiTgRC0/5oPcRLL31Ld/Nnm2uTq5+aGaJaYsfRjxO0El8WOBmExCkDv0L2azhIGTauC6
         RBnpfqj3GbXzJTso/RUJeOpHKRzJUOhvTJaVRxSIWBRtyEOQekcoUXIJBdAqxiyNSobo
         ECaQ==
X-Gm-Message-State: APjAAAUnwqS2oIWOkcsTB4yxbhEHWhS1btCgr4f4UJ80iwE+wdYsjMeg
        HLHcFvTRG2S0ha/5oHuMSPY=
X-Google-Smtp-Source: APXvYqxasg/0tk5uqs+VWcv6twHsKUdyMQdmCMfs2+Di4v1VB7GTidqB2uDeCP8ACAdlnFJgXKcYKg==
X-Received: by 2002:a17:902:7d86:: with SMTP id a6mr6446571plm.212.1581479256000;
        Tue, 11 Feb 2020 19:47:36 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t16sm1361433pgo.80.2020.02.11.19.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 19:47:35 -0800 (PST)
Subject: Re: warning messages for net/ipv4/tcp_output.c
To:     Neal Cardwell <ncardwell@google.com>,
        Vieri Di Paola <vieridipaola@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <CABLYT9ixWZu2NckMg689NdCTO08=-+UOHbALYrQFHCY26Bw91Q@mail.gmail.com>
 <CADVnQyn8t7EiorqHjGQe7wqH6jQy_sgK=M=gieb7JMjWqvbBHw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b390a9ed-84a7-d6ef-0647-107259fbd787@gmail.com>
Date:   Tue, 11 Feb 2020 19:47:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CADVnQyn8t7EiorqHjGQe7wqH6jQy_sgK=M=gieb7JMjWqvbBHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 7:17 PM, Neal Cardwell wrote:
> On Tue, Feb 11, 2020 at 5:54 PM Vieri Di Paola <vieridipaola@gmail.com> wrote:
>>
>> Hi,
>>
>> I get a lot of messages regarding net/ipv4/tcp_output.c in syslog.
>> The OS works "as expected" (network router/firewall), but these
>> messages are very frequent when there's enough network traffic. Only
>> in one case I've seen a system freeze after one week uptime. The last
>> recorded message was related to net/ipv4/tcp_output.c, but I have not
>> been able to reproduce it again (kernel panic).
>>
>> Feb 11 16:53:40 kernel: ------------[ cut here ]------------
>> Feb 11 16:53:40 kernel: WARNING: CPU: 6 PID: 0 at
>> net/ipv4/tcp_output.c:915 tcp_wfree.cold+0xc/0x13
>> Feb 11 16:53:40 kernel: Modules linked in: autofs4 nfnetlink_queue
>> xt_mac xt_REDIRECT xt_limit xt_nat xt_recent xt_statistic xt_connmark
>> xt_comment xt_iprange l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel
>> xt_set xt_NFQUEUE xt_AUDIT ipt_REJECT nf_reject_ipv4 xt_addrtype
>> bridge stp llc xt_mark xt_TCPMSS xt_hashlimit xt_CT xt_multiport
>> nfnetlink_log xt_NFLOG nf_log_ipv4 nf_log_common xt_LOG nf_nat_tftp
>> nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
>> nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda
>> ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp
>> nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre
>> nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast
>> nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp pppoe pppox
>> ppp_generic slhc ip_set_hash_mac ip_set_bitmap_port
>> Feb 11 16:53:40 kernel:  ip_set_hash_net ip_set_hash_ip ip_set
>> nfnetlink ip6table_filter ip6_tables arptable_filter arp_tables
>> xt_conntrack iptable_mangle iptable_nat nf_nat_ipv4 nf_nat
>> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_raw sch_fq tcp_cdg
>> tcp_bbr iptable_filter ip_tables bpfilter mlx5_ib ipmi_ssif ib_uverbs
>> edac_mce_amd kvm_amd kvm ast ttm irqbypass crct10dif_pclmul efi_pstore
>> ghash_clmulni_intel drm_kms_helper pcspkr efivars ixgbe igb sp5100_tco
>> mlx5_core drm joydev bnxt_en i2c_algo_bit mdio i2c_piix4 mlxfw ccp dca
>> i2c_core ipmi_si ipmi_devintf ipmi_msghandler pinctrl_amd pcc_cpufreq
>> acpi_cpufreq mac_hid efivarfs aesni_intel crypto_simd cryptd
>> glue_helper aes_x86_64 algif_rng algif_aead algif_hash algif_skcipher
>> af_alg crc32c_intel crc32_pclmul crc32_generic msdos fat cramfs
>> overlay squashfs
>> Feb 11 16:53:40 kernel:  loop fuse f2fs xfs nfs lockd grace sunrpc
>> fscache jfs reiserfs btrfs ext4 mbcache jbd2 multipath linear raid10
>> raid1 raid0 dm_zero dm_verity reed_solomon dm_thin_pool dm_switch
>> dm_snapshot dm_raid raid456 md_mod async_raid6_recov async_memcpy
>> async_pq raid6_pq dm_mirror dm_region_hash dm_log_writes
>> dm_log_userspace dm_log dm_integrity async_xor async_tx xor dm_flakey
>> dm_delay dm_crypt dm_cache_smq dm_cache dm_persistent_data libcrc32c
>> dm_bufio dm_bio_prison dm_mod firewire_core crc_itu_t hid_sunplus
>> hid_sony hid_samsung hid_pl hid_petalynx hid_monterey hid_microsoft
>> hid_logitech_dj hid_logitech ff_memless hid_gyration hid_ezkey
>> hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech
>> sl811_hcd ohci_hcd uhci_hcd uas usb_storage xhci_plat_hcd
>> pata_sl82c105 pata_via pata_jmicron
>> Feb 11 16:53:40 kernel:  pata_marvell pata_netcell pata_pdc202xx_old
>> pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213
>> pata_pcmcia pcmcia pcmcia_core pata_ns87415 pata_ns87410
>> pata_serverworks pata_oldpiix pata_artop pata_it821x pata_optidma
>> pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar
>> pata_sil680 pata_pdc2027x pata_mpiix lpfc nvmet_fc qla2xxx
>> megaraid_mbox megaraid_mm aacraid sx8 hpsa 3w_9xxx 3w_xxxx 3w_sas
>> mptsas mptfc scsi_transport_fc atp870u dc395x qla1280 dmx3191d
>> sym53c8xx gdth initio BusLogic arcmsr aic7xxx aic79xx sr_mod cdrom sg
>> sd_mod mpt3sas raid_class scsi_transport_sas megaraid megaraid_sas
>> mptspi mptscsih mptbase scsi_transport_spi pdc_adma sata_inic162x
>> sata_mv sata_qstor sata_vsc sata_uli sata_sis pata_sis sata_sx4
>> sata_nv sata_via sata_svw sata_sil24
>> Feb 11 16:53:40 kernel:  sata_sil sata_promise ata_piix ahci libahci
>> nvme_fc nvme_loop nvmet nvme_rdma rdma_cm iw_cm ib_cm ib_core configfs
>> ipv6 crc_ccitt nvme_fabrics nvme nvme_core
>> Feb 11 16:53:40 kernel: CPU: 6 PID: 0 Comm: swapper/6 Not tainted
>> 4.19.97-gentoo-x86_64 #1
>> Feb 11 16:53:40 kernel: Hardware name: Supermicro AS
>> -1114S-WTRT/H12SSW-NT, BIOS 1.0b 11/15/2019
>> Feb 11 16:53:40 kernel: RIP: 0010:tcp_wfree.cold+0xc/0x13
>> Feb 11 16:53:40 kernel: Code: 9d 04 00 00 00 5b c6 85 9b 04 00 00 00
>> 5d c3 48 c7 c7 70 93 06 b0 e8 f7 f7 94 ff 0f 0b c3 48 c7 c7 70 93 06
>> b0 e8 e8 f7 94 ff <0f> 0b e9 46 a5 ff ff 48 c7 c7 70 93 06 b0 e8 d5 f7
>> 94 ff 0f 0b b8
>> Feb 11 16:53:40 kernel: RSP: 0018:ffff9e9c2b183d90 EFLAGS: 00010246
>> Feb 11 16:53:40 kernel: RAX: 0000000000000024 RBX: ffff9e9bc099cee8
>> RCX: 0000000000000000
>> Feb 11 16:53:40 kernel: RDX: 0000000000000000 RSI: 00000000000000f6
>> RDI: 0000000000000300
>> Feb 11 16:53:40 kernel: RBP: ffff9e9bbef09980 R08: ffff9e9c2b1968b8
>> R09: 0000000000000001
>> Feb 11 16:53:40 kernel: R10: 0000000000000000 R11: 0000000000000001
>> R12: ffff9e9bc099cee8
>> Feb 11 16:53:40 kernel: R13: ffff9e9a900100a8 R14: ffff9e9c0155a8c0
>> R15: 0000000000000026
>> Feb 11 16:53:40 kernel: FS:  0000000000000000(0000)
>> GS:ffff9e9c2b180000(0000) knlGS:0000000000000000
>> Feb 11 16:53:40 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Feb 11 16:53:40 kernel: CR2: 00007f90cb702820 CR3: 00000007d41b2000
>> CR4: 0000000000340ee0
>> Feb 11 16:53:40 kernel: Call Trace:
>> Feb 11 16:53:40 kernel:  <IRQ>
>> Feb 11 16:53:40 kernel:  skb_release_head_state+0x64/0xb0
>> Feb 11 16:53:40 kernel:  skb_release_all+0xe/0x30
>> Feb 11 16:53:40 kernel:  consume_skb+0x27/0x80
>> Feb 11 16:53:40 kernel:  bnxt_tx_int+0xd0/0x360 [bnxt_en]
>> Feb 11 16:53:40 kernel:  bnxt_poll+0x20f/0x870 [bnxt_en]
>> Feb 11 16:53:40 kernel:  net_rx_action+0x148/0x3b0
>> Feb 11 16:53:40 kernel:  __do_softirq+0xe8/0x2f1
>> Feb 11 16:53:40 kernel:  irq_exit+0x100/0x110
>> Feb 11 16:53:40 kernel:  do_IRQ+0x81/0xe0
>> Feb 11 16:53:40 kernel:  common_interrupt+0xf/0xf
>> Feb 11 16:53:40 kernel:  </IRQ>
>> Feb 11 16:53:40 kernel: RIP: 0010:cpuidle_enter_state+0xc3/0x320
>> Feb 11 16:53:40 kernel: Code: e8 82 68 a0 ff 80 7c 24 0b 00 74 17 9c
>> 58 0f 1f 44 00 00 f6 c4 02 0f 85 30 02 00 00 31 ff e8 84 55 a6 ff fb
>> 66 0f 1f 44 00 00 <48> ba cf f7 53 e3 a5 9b c4 20 4c 29 f5 48 89 e8 48
>> c1 fd 3f 48 f7
>> Feb 11 16:53:40 kernel: RSP: 0018:ffffb4440021fe80 EFLAGS: 00000246
>> ORIG_RAX: ffffffffffffffd6
>> Feb 11 16:53:40 kernel: RAX: ffff9e9c2b1a2200 RBX: ffff9e9c02dfe800
>> RCX: 000000000000001f
>> Feb 11 16:53:40 kernel: RDX: 0000000000000000 RSI: 000000002c234d74
>> RDI: 0000000000000000
>> Feb 11 16:53:40 kernel: RBP: 000002de50bf72ea R08: 000002de50bf72ea
>> R09: 0000000000000035
>> Feb 11 16:53:40 kernel: R10: 00000000ffffffff R11: ffff9e9c2b1a12e8
>> R12: 0000000000000002
>> Feb 11 16:53:40 kernel: R13: ffffffffb03954a0 R14: 000002de4de20c75
>> R15: ffff9e95044bcc80
>> Feb 11 16:53:40 kernel:  do_idle+0x1dc/0x270
>> Feb 11 16:53:40 kernel:  cpu_startup_entry+0x6f/0x80
>> Feb 11 16:53:40 kernel:  start_secondary+0x1a7/0x200
>> Feb 11 16:53:40 kernel:  secondary_startup_64+0xb6/0xc0
>> Feb 11 16:53:40 kernel: ---[ end trace 828aa59c66af655f ]---
>>
>> My distribution is Gentoo. I've reported this to the Gentoo Linux
>> devs, but unfortunately there hasn't been much progress.
>>
>> # grep CONFIG_KALLSYMS .config
>> CONFIG_KALLSYMS=y
>> CONFIG_KALLSYMS_ALL=y
>> CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
>> CONFIG_KALLSYMS_BASE_RELATIVE=y
>>
>> # emerge --info
>> Portage 2.3.84 (python 3.6.9-final-0, default/linux/amd64/17.1,
>> gcc-9.2.0, glibc-2.29-r7, 4.19.97-gentoo-x86_64 x86_64)
>> =================================================================
>> System uname: Linux-4.19.97-gentoo-x86_64-x86_64-AMD_EPYC_7272_12-Core_Processor-with-gentoo-2.6
>> KiB Mem:    32800832 total,  26904664 free
>> KiB Swap:   37007292 total,  37007292 free
>> Timestamp of repository gentoo: Thu, 06 Feb 2020 00:45:01 +0000
>> Head commit of repository gentoo: e358b025b6215c284de6047b54dca1e9b981126a
>> sh bash 4.4_p23-r1
>> ld GNU ld (Gentoo 2.32 p2) 2.32.0
>> app-shells/bash:          4.4_p23-r1::gentoo
>> dev-java/java-config:     2.2.0-r4::gentoo
>> dev-lang/perl:            5.30.1::gentoo
>> dev-lang/python:          2.7.17::gentoo, 3.6.9::gentoo, 3.7.5-r1::gentoo
>> dev-util/cmake:           3.14.6::gentoo
>> sys-apps/baselayout:      2.6-r1::gentoo
>> sys-apps/openrc:          0.42.1::gentoo
>> sys-apps/sandbox:         2.13::gentoo
>> sys-devel/autoconf:       2.69-r5::gentoo
>> sys-devel/automake:       1.11.6-r3::gentoo, 1.15.1-r2::gentoo,
>> 1.16.1-r1::gentoo
>> sys-devel/binutils:       2.32-r1::gentoo
>> sys-devel/gcc:            9.2.0-r2::gentoo
>> sys-devel/gcc-config:     2.1::gentoo
>> sys-devel/libtool:        2.4.6-r6::gentoo
>> sys-devel/make:           4.2.1-r4::gentoo
>> sys-kernel/linux-headers: 4.19::gentoo (virtual/os-headers)
>> sys-libs/glibc:           2.29-r7::gentoo
>> Repositories:
>>
>> gentoo
>>     location: /var/db/repos/gentoo
>>     sync-type: rsync
>>     sync-uri: rsync://rsync.gentoo.org/gentoo-portage
>>     priority: -1000
>>     sync-rsync-verify-metamanifest: yes
>>     sync-rsync-verify-max-age: 24
>>     sync-rsync-extra-opts:
>>     sync-rsync-verify-jobs: 1
>>
>> CustomOverlay
>>     location: /usr/local/portage
>>     masters: gentoo
>>
>> ACCEPT_KEYWORDS="amd64"
>> ACCEPT_LICENSE="*"
>> CBUILD="x86_64-pc-linux-gnu"
>> CFLAGS="-O2 -pipe"
>> CHOST="x86_64-pc-linux-gnu"
>> CONFIG_PROTECT="/etc /etc/stunnel/stunnel.conf /usr/lib64/fax
>> /usr/share/easy-rsa /usr/share/gnupg/qualified.txt
>> /usr/share/maven-bin-3.6/conf /var/bind /var/spool/fax/etc"
>> CONFIG_PROTECT_MASK="/etc/ca-certificates.conf /etc/env.d
>> /etc/fonts/fonts.conf /etc/gconf /etc/gentoo-release
>> /etc/php/apache2-php7.3/ext-active/ /etc/php/cgi-php7.3/ext-active/
>> /etc/php/cli-php7.3/ext-active/ /etc/revdep-rebuild /etc/sandbox.d
>> /etc/terminfo /var/spool/fax/etc/xferfaxlog"
>> CXXFLAGS="-O2 -pipe"
>> DISTDIR="/var/cache/distfiles"
>> ENV_UNSET="DBUS_SESSION_BUS_ADDRESS DISPLAY GOBIN PERL5LIB PERL5OPT
>> PERLPREFIX PERL_CORE PERL_MB_OPT PERL_MM_OPT XAUTHORITY XDG_CACHE_HOME
>> XDG_CONFIG_HOME XDG_DATA_HOME XDG_RUNTIME_DIR"
>> FCFLAGS="-O2 -pipe"
>> FEATURES="assume-digests binpkg-docompress binpkg-dostrip binpkg-logs
>> buildpkg config-protect-if-modified distlocks ebuild-locks fixlafiles
>> ipc-sandbox merge-sync multilib-strict network-sandbox news nostrip
>> parallel-fetch pid-sandbox preserve-libs protect-owned sandbox sfperms
>> strict unknown-features-warn unmerge-logs unmerge-orphans userfetch
>> userpriv usersandbox usersync xattr"
>> FFLAGS="-O2 -pipe"
>> GENTOO_MIRRORS="http://distfiles.gentoo.org"
>> LDFLAGS="-Wl,-O1 -Wl,--as-needed"
>> MAKEOPTS="-j25"
>> PKGDIR="/var/cache/binpkgs"
>> PORTAGE_BINHOST="http://inf-bl07/gentoo/binary-amd64"
>> PORTAGE_CONFIGROOT="/"
>> PORTAGE_RSYNC_OPTS="--recursive --links --safe-links --perms --times
>> --omit-dir-times --compress --force --whole-file --delete --stats
>> --human-readable --timeout=180 --exclude=/distfiles --exclude=/local
>> --exclude=/packages --exclude=/.git"
>> PORTAGE_TMPDIR="/var/tmp"
>> USE="acl ads amd64 apache2 berkdb bzip2 cli cluster crypt cxx dri
>> fortran freetds gdbm iconv ipv6 jbig kerberos ldap libtirpc logrotate
>> multilib ncurses nls nptl odbc openmp openrc pam pcre python radius
>> readline samba seccomp split-usr ssl tcpd unicode winbind xattr zlib"
>> ABI_X86="64" ADA_TARGET="gnat_2018" ALSA_CARDS="ali5451 als4000 atiixp
>> atiixp-modem bt87x ca0106 cmipci emu10k1x ens1370 ens1371 es1938
>> es1968 fm801 hda-intel intel8x0 intel8x0m maestro3 trident usb-audio
>> via82xx via82xx-modem ymfpci" APACHE2_MODULES="authn_core authz_core
>> socache_shmcb unixd actions alias auth_basic authn_alias authn_anon
>> authn_dbm authn_default authn_file authz_dbm authz_default
>> authz_groupfile authz_host authz_owner authz_user autoindex cache cgi
>> cgid dav dav_fs dav_lock deflate dir disk_cache env expires ext_filter
>> file_cache filter headers include info log_config logio mem_cache mime
>> mime_magic negotiation rewrite setenvif speling status unique_id
>> userdir usertrack vhost_alias" APACHE2_MPMS="prefork"
>> CALLIGRA_FEATURES="karbon sheets words" COLLECTD_PLUGINS="df interface
>> irq load memory rrdtool swap syslog" CPU_FLAGS_X86="aes avx avx2 f16c
>> fma3 mmx mmxext pclmul popcnt sha sse sse2 sse3 sse4_1 sse4_2 sse4a
>> ssse3" ELIBC="glibc" GPSD_PROTOCOLS="ashtech aivdm earthmate evermore
>> fv18 garmin garmintxt gpsclock greis isync itrax mtk3301 nmea ntrip
>> navcom oceanserver oldstyle oncore rtcm104v2 rtcm104v3 sirf skytraq
>> superstar2 timing tsip tripmate tnt ublox ubx" GRUB_PLATFORMS="efi-64
>> pc" INPUT_DEVICES="libinput keyboard mouse" KERNEL="linux"
>> LCD_DEVICES="bayrad cfontz cfontz633 glk hd44780 lb216 lcdm001 mtxorb
>> ncurses text" LIBREOFFICE_EXTENSIONS="presenter-console
>> presenter-minimizer" OFFICE_IMPLEMENTATION="libreoffice"
>> PHP_TARGETS="php7-2" POSTGRES_TARGETS="postgres10 postgres11"
>> PYTHON_SINGLE_TARGET="python3_6" PYTHON_TARGETS="python2_7 python3_6"
>> RUBY_TARGETS="ruby24 ruby25" USERLAND="GNU" VIDEO_CARDS="amdgpu fbdev
>> intel nouveau radeon radeonsi vesa dummy v4l" XTABLES_ADDONS="quota2
>> psd pknock lscan length2 ipv4options ipset ipp2p iface geoip fuzzy
>> condition tee tarpit sysrq steal rawnat logmark ipmark dhcpmac delude
>> chaos account"
>> Unset:  CC, CPPFLAGS, CTARGET, CXX, EMERGE_DEFAULT_OPTS, INSTALL_MASK,
>> LANG, LC_ALL, LINGUAS, PORTAGE_BUNZIP2_COMMAND, PORTAGE_COMPRESS,
>> PORTAGE_COMPRESS_FLAGS, PORTAGE_RSYNC_EXTRA_OPTS
>>
>> I've also tested kernel 5.5 with the same behavior.
>>
>> I believe kernel 4.12.12 did not have this issue, but I was running it
>> on different hardware. I have not yet tried 4.12.12 on this particular
>> hardware.
>> Please note that the same issue (net/ipv4/tcp_output.c:915) ocurrs on
>> different hardware with different NIC drivers (eg. e1000/e1000e) but
>> with the same kernel version.
>>
>> Please let me know if I can provide more information or make more
>> specific tests.
>>
>> Regards,
>>
>> Vieri
> 
> Thanks for the report. Please cc the Linux networking (netdev) list on
> networking issues like this (I have cc-ed that e-mail list).
> 
> This seems to be the code in question:
>   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/ipv4/tcp_output.c?h=v4.19.97#n915
> 
> And this seems to be the warning:
>   WARN_ON(refcount_sub_and_test(skb->truesize - 1, &sk->sk_wmem_alloc));
> 

Thanks Neal

Nothing comes to mind really.

If older kernels were fine, then a bisection might be the fastest way to find the root cause.

There are too many changes between 4.12.12 and 5.5 to even try something else than brute force.
