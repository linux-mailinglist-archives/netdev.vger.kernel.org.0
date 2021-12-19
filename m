Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9418247A037
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 11:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhLSKgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 05:36:12 -0500
Received: from mail-0301.mail-europe.com ([188.165.51.139]:51354 "EHLO
        mail-0301.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhLSKgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 05:36:11 -0500
Date:   Sun, 19 Dec 2021 10:36:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1639910167;
        bh=WhJ6NoEqm9gkzkbmZsBeuF30GXSrOzaHS4Hsqt4tJVg=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc;
        b=WAq4cLfPS7qfcsKDZEuzPX2jYXBElOhWQzH3vz9or3T/MzZhfBQQx8Ru1ZFyNtlbN
         XWgE9yZ9OUeQVaOtWpTUV8dJar8LSCHWiHWGE8zs+4+ZjjRvdzskafXQG1WQsP+20A
         lKRW4pGZL9EhDY8mlY5CTUlPYUQY2vz9jsEglNVC/NUNKxjz0sSgT04AsRukDrTVLP
         yATyyaWYGgbIb/Qn9JiKiWmAymG9Gco5nOlnPF45b0LgWO7g07E9WlkvbWwIaWj6t8
         0EaWgTOsXCMq8zftuAHdVQmQsNRpnQzzSDz04cEjtmNmBpgCeoqQOHC46SjBrnwg7r
         n3IzPe7a4emQA==
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc:     "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Reply-To: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Subject: Running adilsoybali log4j tester resets virtual network adapter in Ubuntu 21.10 Linux virtual machine
Message-ID: <U-14mS6_LpnbfmKXe3Y6bgDsk_l-ET44qYU79c9hWGjEet5lahAbRkfHk2pTAU8JWdi5u0EE0kBH82MQymzI5G34jmnIC3I1b4eBqG_4u1s=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: Running adilsoybali log4j tester resets virtual network adapter in=
 Ubuntu 21.10 Linux virtual machine

Good day from Singapore,

I have an Ubuntu 21.10 Linux virtual machine running under Oracle VM Virtua=
lBox 6.1. Host operating system is Windows 10 Pro. The virtual network card=
 is operating in NAT mode.

Recently I have installed Log4j/Log4shell remote command execution security=
 scanner developed by Adil Soybali. His github link is https://github.com/a=
dilsoybali/Log4j-RCE-Scanner/

When I run adilsoybali log4j tester, it keeps resetting the virtual network=
 adapter. The internet connection inside the Ubuntu 21.10 Linux virtual mac=
hine keeps going down from time to time. I can't ping machines on the inter=
net from time to time. Ping tests show Destination Host Unreachable. The ho=
st operating system which is Windows 10 Pro never loses network connection.=
 Only the virtual machine loses network connection.

The dmesg output is as follows:

[  816.349293] ------------[ cut here ]------------
[  816.349296] NETDEV WATCHDOG: enp0s3 (e1000): transmit queue 0 timed out
[  816.349367] WARNING: CPU: 0 PID: 2931 at net/sched/sch_generic.c:467 dev=
_watchdog+0x24c/0x250
[  816.349373] Modules linked in: nls_iso8859_1 snd_intel8x0 snd_ac97_codec=
 ac97_bus snd_pcm snd_seq_midi intel_rapl_msr snd_seq_midi_event snd_rawmid=
i snd_seq snd_seq_device snd_timer joydev snd intel_rapl_common soundcore v=
boxguest rapl input_leds mac_hid serio_raw sch_fq_codel vmwgfx ttm drm_kms_=
helper cec rc_core fb_sys_fops syscopyarea sysfillrect sysimgblt msr parpor=
t_pc ppdev lp parport drm ip_tables x_tables autofs4 hid_generic psmouse ah=
ci libahci i2c_piix4 usbhid hid e1000 pata_acpi video
[  816.349398] CPU: 0 PID: 2931 Comm: amass Not tainted 5.13.0-22-generic #=
22-Ubuntu
[  816.349400] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS Virt=
ualBox 12/01/2006
[  816.349401] RIP: 0010:dev_watchdog+0x24c/0x250
[  816.349403] Code: aa 31 fd ff eb ab 4c 89 ff c6 05 f3 eb 6b 01 01 e8 39 =
03 fa ff 44 89 e9 4c 89 fe 48 c7 c7 68 2c 0a bd 48 89 c2 e8 3b 77 17 00 <0f=
> 0b eb 8c 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 4c 8d b7 80 00
[  816.349404] RSP: 0000:ffffb7b080003e80 EFLAGS: 00010282
[  816.349406] RAX: 0000000000000000 RBX: ffff9554820b5a00 RCX: 00000000000=
00027
[  816.349407] RDX: ffff95549bc189c8 RSI: 0000000000000001 RDI: ffff95549bc=
189c0
[  816.349407] RBP: ffffb7b080003eb0 R08: 0000000000000000 R09: ffffb7b0800=
03c70
[  816.349409] R10: ffffb7b080003c68 R11: ffffffffbd955268 R12: ffff9554820=
b5a80
[  816.349409] R13: 0000000000000000 R14: ffff95548260c480 R15: ffff9554826=
0c000
[  816.349410] FS:  00007fc35d636700(0000) GS:ffff95549bc00000(0000) knlGS:=
0000000000000000
[  816.349411] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  816.349412] CR2: 000000c010336008 CR3: 0000000059f74006 CR4: 00000000000=
306f0
[  816.349414] Call Trace:
[  816.349415]  <IRQ>
[  816.349418]  ? pfifo_fast_enqueue+0x150/0x150
[  816.349420]  call_timer_fn+0x2e/0x100
[  816.349423]  __run_timers.part.0+0x1da/0x250
[  816.349425]  ? ktime_get+0x3e/0xa0
[  816.349426]  ? clockevents_program_event+0x94/0xf0
[  816.349428]  run_timer_softirq+0x2a/0x50
[  816.349430]  __do_softirq+0xcb/0x27c
[  816.349433]  irq_exit_rcu+0xa2/0xd0
[  816.349435]  sysvec_apic_timer_interrupt+0x7c/0x90
[  816.349437]  </IRQ>
[  816.349438]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  816.349439] RIP: 0010:clear_page_rep+0x7/0x10
[  816.349442] Code: b5 eb ad 79 a0 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f =
5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc b9 00 02 00 00 31 c0 <f3=
> 48 ab c3 0f 1f 44 00 00 31 c0 b9 40 00 00 00 66 0f 1f 84 00 00
[  816.349443] RSP: 0000:ffffb7b08250fc28 EFLAGS: 00010246
[  816.349444] RAX: 0000000000000000 RBX: ffffb7b08250fcc0 RCX: 00000000000=
00200
[  816.349445] RDX: fffff72ac240b740 RSI: ffff955393d71700 RDI: ffff9554102=
dd000
[  816.349446] RBP: ffffb7b08250fc30 R08: fffff72ac240b780 R09: 00000000000=
00001
[  816.349447] R10: 00000000000049b1 R11: 0000000000000000 R12: ffff95549ff=
d65c0
[  816.349448] R13: 0000000000000000 R14: 0000000000000001 R15: 00000000000=
00901
[  816.349450]  ? kernel_init_free_pages+0x4a/0x60
[  816.349452]  get_page_from_freelist+0x347/0x4c0
[  816.349453]  __alloc_pages+0x17e/0x330
[  816.349455]  alloc_pages_vma+0x87/0x270
[  816.349458]  do_anonymous_page+0xee/0x3b0
[  816.349460]  handle_pte_fault+0x1fe/0x230
[  816.349461]  __handle_mm_fault+0x5de/0x770
[  816.349464]  handle_mm_fault+0xda/0x2c0
[  816.349465]  do_user_addr_fault+0x1bb/0x660
[  816.349467]  ? do_syscall_64+0x6e/0xb0
[  816.349469]  exc_page_fault+0x7d/0x170
[  816.349471]  ? asm_exc_page_fault+0x8/0x30
[  816.349472]  asm_exc_page_fault+0x1e/0x30
[  816.349473] RIP: 0033:0xcc4e54
[  816.349475] Code: 48 89 5c 24 40 48 8b 44 24 60 e8 87 4b 87 ff 48 89 44 =
24 68 48 89 5c 24 38 48 8d 05 d6 98 2e 00 e8 f1 a6 74 ff 48 8b 54 24 40 <48=
> 89 50 08 83 3d 51 1e 4a 01 00 90 75 0a 48 8b 4c 24 70 48 89 08
[  816.349476] RSP: 002b:000000c0014f7ac8 EFLAGS: 00010206
[  816.349477] RAX: 000000c010336000 RBX: 0000000000000007 RCX: 00000000000=
00008
[  816.349478] RDX: 000000000000000c RSI: 00000000000000a8 RDI: 00000000000=
00000
[  816.349479] RBP: 000000c0014f7b40 R08: 0000000000000001 R09: 00000000000=
000a0
[  816.349479] R10: 0000000000000018 R11: 00000000018aaeba R12: 00000000002=
03004
[  816.349480] R13: 0000000000203004 R14: 000000c0000001a0 R15: 00007fc347d=
18b05
[  816.349482] ---[ end trace cccc5ad6f6d3c719 ]---
[  816.349534] e1000 0000:00:03.0 enp0s3: Reset adapter
[  818.493000] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[  844.257494] e1000 0000:00:03.0 enp0s3: Reset adapter
[  846.361841] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 1030.993965] e1000 0000:00:03.0 enp0s3: Detected Tx Unit Hang
                 Tx Queue             <0>
                 TDH                  <a2>
                 TDT                  <10>
                 next_to_use          <10>
                 next_to_clean        <9e>
               buffer_info[next_to_clean]
                 time_stamp           <10002aef9>
                 next_to_watch        <9f>
                 jiffies              <10002c89e>
                 next_to_watch.status <1>
[ 1040.353982] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 1042.496138] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 1296.346524] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 1298.459626] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 1355.227155] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 1357.340061] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 1488.347267] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 1490.492641] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 1547.238537] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 1549.376157] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 4512.236859] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 4514.420399] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 4875.255275] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 4877.425201] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[ 5088.241049] e1000 0000:00:03.0 enp0s3: Reset adapter
[ 5090.394812] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
teo-en-ming@ubuntu-2110:/var/log$

Please advise what is wrong.

Thank you very much for your kind assistance.

Mr. Turritopsis Dohrnii Teo En Ming, 43 years old as of 19 Dec 2021, is a T=
ARGETED INDIVIDUAL living in Singapore. He is an IT Consultant with a Syste=
ms Integrator (SI)/computer firm in Singapore. He is an IT enthusiast.





-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of U.S. Em=
bassy Workers

Link:

https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwave.html

***************************************************************************=
*****************

Singaporean Targeted Individual Mr. Turritopsis Dohrnii Teo En Ming's Acade=
mic Qualifications as at 14 Feb 2019 and refugee seeking attempts at the Un=
ited Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan (5 Aug 2019) a=
nd Australia (25 Dec 2019 to 9 Jan 2020):

[1] https://tdtemcerts.wordpress.com/

[2] https://tdtemcerts.blogspot.sg/

[3] https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----

Sent with ProtonMail Secure Email.
