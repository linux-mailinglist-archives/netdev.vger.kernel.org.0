Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D4B15C978
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgBMRe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:34:58 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39907 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgBMRe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:34:57 -0500
Received: by mail-ed1-f68.google.com with SMTP id m13so7803068edb.6;
        Thu, 13 Feb 2020 09:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFYYZX2w7N/opn7be8De2hXdsY/6X8cQjp9rcLvIFMc=;
        b=dIOqZgcOvysU31Pj1sQkLaVlT9VjM8vZfHgIOOXytpIajsGO2hO1dmQACLZPRtzZXf
         hMSC1Byt+BQ1fAI5+CHQ5BmvPzuM49hgrYbI/n1GAMNfeVavcz10zdQlYcRuMYcTH2Jz
         ch6mop+W1xUU/li7oc9GzyGbnHsts08X4RyHcK2OUGFuvhziAjAJ4zUhC76LNV4Lnkic
         /jBjjHVsB8jQOHZuVrrX1gWJjrs8wFW/9XN68Z39PeTB3fPLplNzzjrCo/rxMVHOdex9
         +1ZG2EWgogRsH3MNPNP25HPI84wnPsgIW/WKX+hqAkDERp+0b1S3Dpe6zBZEQCSfssP7
         C3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFYYZX2w7N/opn7be8De2hXdsY/6X8cQjp9rcLvIFMc=;
        b=p1XwwGwD28aXavQmUqkm5q1hwt+X2bNqYQvHNc6/T4A6jZ/RZKxKUjeYYBRatMMPns
         jslPsWGLi9I7VRdhFzfGvQ441bQ7SRexlWewF4g/Bmf6NlxqEDSsKktX7VRpUdkJmtkK
         DxhxBKM2lmAOC6Q1nbvhqyM9fOUklRoXJZYTl7gyUtqY+a53Ej4SUWvy9KpmilQC0Pru
         xGDOaQPdh8Jhd8vYbZ++RlT67fmyuQFieTKglpur2zaN3funyMltEMkWrjF/G51arymg
         voIl9LJW5HhJEWbVUH8/lohYFUPPG3o/WiI8gsFjiK6j8bzkkQY5YPhCCIuc3aRyuXcE
         mwhw==
X-Gm-Message-State: APjAAAW0eGNQlZBifr2xqCSMweLAS7DqIVAOFiVmlNkeW/iOyu6hF5tT
        AOPFvs4JU+7ggWs2Jgdpc4wXbvX9TifvZr8BWbk=
X-Google-Smtp-Source: APXvYqwBpfnyS5IivYkbUcl+BwxTBJpXym8HCot0Kn7QWT6Pomt/Z5Iy9vTPtlNuOZnGsqpAsJmW24yyEkdsUGMeqxw=
X-Received: by 2002:a17:906:344d:: with SMTP id d13mr17267565ejb.306.1581615294454;
 Thu, 13 Feb 2020 09:34:54 -0800 (PST)
MIME-Version: 1.0
References: <CABLYT9ixWZu2NckMg689NdCTO08=-+UOHbALYrQFHCY26Bw91Q@mail.gmail.com>
 <CADVnQyn8t7EiorqHjGQe7wqH6jQy_sgK=M=gieb7JMjWqvbBHw@mail.gmail.com> <b390a9ed-84a7-d6ef-0647-107259fbd787@gmail.com>
In-Reply-To: <b390a9ed-84a7-d6ef-0647-107259fbd787@gmail.com>
From:   Vieri Di Paola <vieridipaola@gmail.com>
Date:   Thu, 13 Feb 2020 18:34:42 +0100
Message-ID: <CABLYT9jvF41rEOaNob3OkwGLcZh1jE8kmJL6FBzCRuU-rdnjWA@mail.gmail.com>
Subject: Re: warning messages for net/ipv4/tcp_output.c
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 4:47 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> > This seems to be the code in question:
> >   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/ipv4/tcp_output.c?h=v4.19.97#n915
> >
> > And this seems to be the warning:
> >   WARN_ON(refcount_sub_and_test(skb->truesize - 1, &sk->sk_wmem_alloc));
>
> Nothing comes to mind really.

Hi,

I think I've found the root cause for this issue, or at least how to
reproduce it.

The warning messages I reported (which *could* lead to a system hang
after a long period running) disappear if I stop using NFQUEUE.

In my specific case I use NFQUEUE balance 0:5 with iptables-1.6.1.

As an IPS I'm using suricata 5.0.1 with the following arguments (among others):
 -q 0 -q 1 -q 2 -q 3 -q 4 -q 5

I've reproduced this behavior in several recent Linux kernel versions.

A reminder of the kernel warning message:

Feb 13 17:10:01 kernel: ------------[ cut here ]------------
Feb 13 17:10:01 kernel: WARNING: CPU: 5 PID: 0 at
net/ipv4/tcp_output.c:915 tcp_wfree.cold+0xc/0x13
Feb 13 17:10:01 kernel: Modules linked in: autofs4 nfnetlink_queue
l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel xt_mac xt_REDIRECT
xt_limit xt_nat
 xt_recent xt_statistic xt_connmark xt_comment xt_iprange xt_set
xt_NFQUEUE xt_AUDIT ipt_REJECT nf_reject_ipv4 xt_addrtype bridge stp
llc xt_mark xt_TCPMSS xt
_hashlimit xt_CT xt_multiport nfnetlink_log xt_NFLOG nf_log_ipv4
nf_log_common xt_LOG nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp
nf_nat_sip nf_nat_pptp n
f_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp
nf_conntrack_sip nf_conntrack_p
ptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp pppoe pppox
 ppp_generic slhc ip_set_hash_mac ip_set_bitmap_port
Feb 13 17:10:01 kernel:  ip_set_hash_net ip_set_hash_ip ip_set
nfnetlink ip6table_filter ip6_tables arptable_filter arp_tables
xt_conntrack iptable_ma
ngle iptable_nat nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 iptable_raw sch_fq tcp_cdg tcp_bbr iptable_filter
ip_tables bpfilter mlx5_ib ip
mi_ssif ib_uverbs edac_mce_amd ast kvm_amd ttm kvm drm_kms_helper igb
irqbypass efi_pstore crct10dif_pclmul ghash_clmulni_intel sp5100_tco
efivars pcspkr mlx5
_core drm ixgbe bnxt_en joydev i2c_algo_bit i2c_piix4 mdio ccp mlxfw
dca i2c_core ipmi_si ipmi_devintf ipmi_msghandler pinctrl_amd
pcc_cpufreq mac_hid acpi_cp
ufreq efivarfs aesni_intel crypto_simd cryptd glue_helper aes_x86_64
algif_rng algif_aead algif_hash algif_skcipher af_alg crc32c_intel
crc32_pclmul crc32_gen
eric msdos fat cramfs overlay squashfs
Feb 13 17:10:01 kernel:  loop fuse f2fs xfs nfs lockd grace sunrpc
fscache jfs reiserfs btrfs ext4 mbcache jbd2 multipath linear raid10
raid1 raid0 dm
_zero dm_verity reed_solomon dm_thin_pool dm_switch dm_snapshot
dm_raid raid456 md_mod async_raid6_recov async_memcpy async_pq
raid6_pq dm_mirror dm_region_ha
sh dm_log_writes dm_log_userspace dm_log dm_integrity async_xor
async_tx xor dm_flakey dm_delay dm_crypt dm_cache_smq dm_cache
dm_persistent_data libcrc32c dm
_bufio dm_bio_prison dm_mod firewire_core crc_itu_t hid_sunplus
hid_sony hid_samsung hid_pl hid_petalynx hid_monterey hid_microsoft
hid_logitech_dj hid_logite
ch ff_memless hid_gyration hid_ezkey hid_cypress hid_chicony
hid_cherry hid_belkin hid_apple hid_a4tech sl811_hcd ohci_hcd uhci_hcd
uas usb_storage xhci_plat_
hcd pata_sl82c105 pata_via pata_jmicron
Feb 13 17:10:01 kernel:  pata_marvell pata_netcell pata_pdc202xx_old
pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213
pata_pcmcia pcmc
ia pcmcia_core pata_ns87415 pata_ns87410 pata_serverworks pata_oldpiix
pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3
pata_hpt37x pata_hpt366 pa
ta_cmd64x pata_efar pata_sil680 pata_pdc2027x pata_mpiix lpfc nvmet_fc
qla2xxx megaraid_mbox megaraid_mm aacraid sx8 hpsa 3w_9xxx 3w_xxxx
3w_sas mptsas mptfc
scsi_transport_fc atp870u dc395x qla1280 dmx3191d sym53c8xx gdth
initio BusLogic arcmsr aic7xxx aic79xx sr_mod cdrom sg sd_mod mpt3sas
raid_class scsi_transpo
rt_sas megaraid megaraid_sas mptspi mptscsih mptbase
scsi_transport_spi pdc_adma sata_inic162x sata_mv sata_qstor sata_vsc
sata_uli sata_sis pata_sis sata_sx4
 sata_nv sata_via sata_svw sata_sil24
Feb 13 17:10:01 kernel:  sata_sil sata_promise ata_piix ahci libahci
nvme_fc nvme_loop nvmet nvme_rdma rdma_cm iw_cm ib_cm ib_core configfs
ipv6 crc_c
citt nvme_fabrics nvme nvme_core
Feb 13 17:10:01 kernel: CPU: 5 PID: 0 Comm: swapper/5 Not tainted
4.19.97-gentoo-x86_64 #1
Feb 13 17:10:01 kernel: Hardware name: Supermicro AS
-1114S-WTRT/H12SSW-NT, BIOS 1.0b 11/15/2019
Feb 13 17:10:01 kernel: RIP: 0010:tcp_wfree.cold+0xc/0x13
Feb 13 17:10:01 kernel: Code: 9d 04 00 00 00 5b c6 85 9b 04 00 00 00
5d c3 48 c7 c7 70 93 06 a2 e8 f7 f7 94 ff 0f 0b c3 48 c7 c7 70 93 06
a2 e8 e8 f7
94 ff <0f> 0b e9 46 a5 ff ff 48 c7 c7 70 93 06 a2 e8 d5 f7 94 ff 0f 0b b8
Feb 13 17:10:01 kernel: RSP: 0018:ffff9e15eb143d90 EFLAGS: 00010246
Feb 13 17:10:01 kernel: RAX: 0000000000000024 RBX: ffff9e15787094e8
RCX: 0000000000000000
Feb 13 17:10:01 kernel: RDX: 0000000000000000 RSI: ffff9e15eb1568b8
RDI: ffff9e15eb1568b8
Feb 13 17:10:01 kernel: RBP: ffff9e15011f1100 R08: ffff9e15eb1568b8
R09: 0000000000000001
Feb 13 17:10:01 kernel: R10: 0000000000000000 R11: 0000000000000001
R12: ffff9e15787094e8
Feb 13 17:10:01 kernel: R13: ffff9e0ec3ab10a8 R14: ffff9e15e39de8c0
R15: 000000000000008e
Feb 13 17:10:01 kernel: FS:  0000000000000000(0000)
GS:ffff9e15eb140000(0000) knlGS:0000000000000000
Feb 13 17:10:01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 13 17:10:01 kernel: CR2: 00007f711864a690 CR3: 0000000804968000
CR4: 0000000000340ee0
Feb 13 17:10:01 kernel: Call Trace:
Feb 13 17:10:01 kernel:  <IRQ>
Feb 13 17:10:01 kernel:  skb_release_head_state+0x64/0xb0
Feb 13 17:10:01 kernel:  skb_release_all+0xe/0x30
Feb 13 17:10:01 kernel:  consume_skb+0x27/0x80
Feb 13 17:10:01 kernel:  bnxt_tx_int+0xd0/0x360 [bnxt_en]
Feb 13 17:10:01 kernel:  bnxt_poll+0x20f/0x870 [bnxt_en]
Feb 13 17:10:01 kernel:  net_rx_action+0x148/0x3b0
Feb 13 17:10:01 kernel:  __do_softirq+0xe8/0x2f1
Feb 13 17:10:01 kernel:  irq_exit+0x100/0x110
Feb 13 17:10:01 kernel:  do_IRQ+0x81/0xe0
Feb 13 17:10:01 kernel:  common_interrupt+0xf/0xf
Feb 13 17:10:01 kernel:  </IRQ>
Feb 13 17:10:01 kernel: RIP: 0010:cpuidle_enter_state+0xc3/0x320
Feb 13 17:10:01 kernel: Code: e8 82 68 a0 ff 80 7c 24 0b 00 74 17 9c
58 0f 1f 44 00 00 f6 c4 02 0f 85 30 02 00 00 31 ff e8 84 55 a6 ff fb
66 0f 1f 44
00 00 <48> ba cf f7 53 e3 a5 9b c4 20 4c 29 f5 48 89 e8 48 c1 fd 3f 48 f7
Feb 13 17:10:01 kernel: RSP: 0018:ffffbfbac0217e80 EFLAGS: 00000246
ORIG_RAX: ffffffffffffffd6
Feb 13 17:10:01 kernel: RAX: ffff9e15eb162200 RBX: ffff9e15c4491c00
RCX: 000000000000001f
Feb 13 17:10:01 kernel: RDX: 0000000000000000 RSI: 000000002c234c74
RDI: 0000000000000000
Feb 13 17:10:01 kernel: RBP: 000000653d4d3728 R08: 000000653d4d3728
R09: 0000000000002707
Feb 13 17:10:01 kernel: R10: 0000000000003268 R11: ffff9e15eb1612e8
R12: 0000000000000002
Feb 13 17:10:01 kernel: R13: ffffffffa23954a0 R14: 000000653d200b61
R15: ffff9e0ec44a2640
Feb 13 17:10:01 kernel:  do_idle+0x1dc/0x270
Feb 13 17:10:01 kernel:  cpu_startup_entry+0x6f/0x80
Feb 13 17:10:01 kernel:  start_secondary+0x1a7/0x200
Feb 13 17:10:01 kernel:  secondary_startup_64+0xb6/0xc0
Feb 13 17:10:01 kernel: ---[ end trace 70699422f7793e3b ]---

# ethtool -a isp1
Pause parameters for isp1:
Autonegotiate:on
RX:on
TX:on
RX negotiated:on
TX negotiated:on

# ethtool -c isp1
Coalesce parameters for isp1:
Adaptive RX: off  TX: off
stats-block-usecs: 1000000
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 14
rx-frames: 15
rx-usecs-irq: 1
rx-frames-irq: 1

tx-usecs: 28
tx-frames: 30
tx-usecs-irq: 2
tx-frames-irq: 2

rx-usecs-low: 0
rx-frame-low: 0
tx-usecs-low: 0
tx-frame-low: 0

rx-usecs-high: 0
rx-frame-high: 0
tx-usecs-high: 0
tx-frame-high: 0

# ethtool -g isp1
Ring parameters for isp1:
Pre-set maximums:
RX:2047
RX Mini:0
RX Jumbo:8191
TX:2047
Current hardware settings:
RX:511
RX Mini:0
RX Jumbo:2044
TX:511

# ethtool -i isp1
driver: bnxt_en
version: 1.9.2
firmware-version: 214.0.191.0
expansion-rom-version:
bus-info: 0000:c6:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: no
supports-priv-flags: no

# ethtool -k isp1
Features for isp1:
rx-checksumming: on
tx-checksumming: on
tx-checksum-ipv4: on
tx-checksum-ip-generic: off [fixed]
tx-checksum-ipv6: on
tx-checksum-fcoe-crc: off [fixed]
tx-checksum-sctp: off [fixed]
scatter-gather: on
tx-scatter-gather: on
tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
tx-tcp-segmentation: on
tx-tcp-ecn-segmentation: off [fixed]
tx-tcp-mangleid-segmentation: off
tx-tcp6-segmentation: on
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: on
receive-hashing: on
highdma: on [fixed]
rx-vlan-filter: off [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: on
tx-gre-csum-segmentation: on
tx-ipxip4-segmentation: on
tx-ipxip6-segmentation: off [fixed]
tx-udp_tnl-segmentation: on
tx-udp_tnl-csum-segmentation: on
tx-gso-partial: on
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: off [fixed]
tx-udp-segmentation: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: on
rx-vlan-stag-hw-parse: on
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: on
esp-hw-offload: off [fixed]
esp-tx-csum-hw-offload: off [fixed]
rx-udp_tunnel-port-offload: on
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: on
tls-hw-record: off [fixed]

I was not using suricata with iptables and NFQUEUE in the earlier
kernel versions I mentioned before.

Regards,

Vieri
