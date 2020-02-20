Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E79166502
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgBTRg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:36:29 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35448 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbgBTRg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:36:28 -0500
Received: by mail-lf1-f66.google.com with SMTP id l16so3781630lfg.2
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 09:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=a7KI3DlBjlZjTmm5ZovPPiJJo6iGx7c7eZitO5vxC/o=;
        b=Z7VfCq5mq08phU6vAFTXQ0MS+Ymf8aBwHrWrQ66jNeXFsC+q8bt2Uq73+pceW13zHp
         er1HBOUDnyR9RVhyS1i16JlD7d3HonX211rWY3sdQwh9bKIBmjHCV8nfQboCyjswG2y2
         Yn1Y8I4Lh0JZIAsmeVHGscj7qdgKpiZ4CKPHCj0jHwDfjFQK9LUbTh0WbBFXxhidbp2B
         w9ume5en8tYfz54jnxcl94n/Gi7cm4RdZ1kzsG37ETyYp5KfZeW7aW9RPQtC4WeP7qZS
         xQvM9eKuRsQVLDMxc4q8gCi9fATK99zyrc64FI0TF0VF8h+uzJUVVUwXp+8z6sZuhzKZ
         ZAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=a7KI3DlBjlZjTmm5ZovPPiJJo6iGx7c7eZitO5vxC/o=;
        b=fha1/TrVfnyLRgsOb+HLZTQcIP8vUlmEXEWDsHWhwAagfccphHaeie4qUM2EXdpFP5
         9Cav4z+D/2ppEVUJTcjVG0/Fh6ALheUdpoEQJW1/t8eiOLtGAu6JppUPXikRv85sdqxz
         Lu0KAUC306UnZaars1u4c7fd79AwyuhvUdhLQxHC6mxJokiDcGSsn/izsWveWTkylx+k
         T/TlVDDe6Tr5nS0yPBXQcNiflP33GParVPfaoK+l30JDwbnwkttN2nwkoZ/RyegZj0SQ
         pSZOMrN4Q/Ms5QZtUWGBYuoOqLyd/0Q0SebWyJSTqXkM+xCIlIkGIoi2wMW+n+GQ9E5L
         Byyg==
X-Gm-Message-State: APjAAAWosjH9z27qxNO97/tZSC+TnO1y9MCn3vk0vyPwOWduOrF7HZWy
        LWkx1e7cFL4GxyiN7YrUhNPy/wxH
X-Google-Smtp-Source: APXvYqywvAWIwtJINXtV1eIiXZO018Usfr+hNa5kMon05zFOCH79TliVAmwvZtqnaGQ9OfqODgL8mA==
X-Received: by 2002:a19:5504:: with SMTP id n4mr16253331lfe.25.1582220180747;
        Thu, 20 Feb 2020 09:36:20 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id r26sm90645lfm.82.2020.02.20.09.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 09:36:19 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
 <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
Date:   Thu, 20 Feb 2020 19:36:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------9C9987BD455004C616BE9300"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------9C9987BD455004C616BE9300
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

2020-02-19 23:54, Heiner Kallweit rašė:
> Realtek responded that they are not aware of a HW issue with RTL8411b. They will try to reproduce the error,
> in addition they ask to test whether same issue occurs with their own driver, r8168.
> Would be great if you could give r8168 a try. Most distributions provide it as an optional package.
> Worst case it can be downloaded from Realtek's website, then it needs to be compiled.
> 

I have installed r8168-dkms:

```
apt policy r8168-dkms
r8168-dkms:
   Installed: 8.048.00-1
   Candidate: 8.048.00-1
   Version table:
  *** 8.048.00-1 500
         500 http://debian.mirror.vu.lt/debian unstable/non-free amd64 Packages
         500 http://debian.mirror.vu.lt/debian unstable/non-free i386 Packages
         100 /var/lib/dpkg/status
```

Rebooted, and still (rather fast) got same timeout after maybe couple of minutes of running on same 5.4 withoyt ethtool fixes:

Feb 20 19:24:54 vinco kernel: [  228.808802] ------------[ cut here ]------------
Feb 20 19:24:54 vinco kernel: [  228.808832] NETDEV WATCHDOG: enp5s0f1 (r8168): transmit queue 0 timed out
Feb 20 19:24:54 vinco kernel: [  228.808865] WARNING: CPU: 7 PID: 0 at net/sched/sch_generic.c:447 dev_watchdog+0x248/0x250
Feb 20 19:24:54 vinco kernel: [  228.808871] Modules linked in: xt_recent ipt_REJECT nf_reject_ipv4 xt_multiport xt_conntrack xt_hashlimit xt_addrtype xt_iface(OE) xt_mark nft_chain_nat xt_comment 
xt_CT xt_owner xt_tcpudp nft_compat nft_counter xt_NFLOG nf_log_ipv4 nf_log_common xt_LOG nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_irc nf_nat_h323 nf_nat_ftp 
nf_nat_amanda ts_kmp nf_conntrack_amanda nf_nat nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast 
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfcomm vboxnetadp(OE) vboxnetflt(OE) xfrm_user xfrm_algo vboxdrv(OE) l2tp_ppp l2tp_netlink 
l2tp_core ip6_udp_tunnel udp_tunnel pppox ppp_generic slhc bnep nfnetlink_log nfnetlink ipmi_devintf ipmi_msghandler intel_rapl_msr intel_rapl_common bbswitch(OE) x86_pkg_temp_thermal intel_powerclamp 
coretemp kvm_intel kvm irqbypass btusb btrtl iwlmvm btbcm
Feb 20 19:24:54 vinco kernel: [  228.808935]  binfmt_misc btintel bluetooth crct10dif_pclmul nls_ascii ghash_clmulni_intel mac80211 nls_cp437 snd_hda_codec_realtek snd_hda_codec_generic vfat drbg 
ledtrig_audio libarc4 snd_hda_codec_hdmi fat uvcvideo aesni_intel iwlwifi videobuf2_vmalloc ansi_cprng crypto_simd videobuf2_memops videobuf2_v4l2 snd_hda_intel cryptd glue_helper snd_intel_nhlt 
videobuf2_common snd_hda_codec videodev snd_hda_core intel_cstate ecdh_generic ecc cfg80211 mc intel_uncore efi_pstore snd_hwdep snd_pcm snd_timer asus_nb_wmi joydev asus_wmi snd sparse_keymap 
iTCO_wdt rtsx_pci_ms iTCO_vendor_support pcspkr intel_rapl_perf serio_raw sg efivars soundcore memstick watchdog rfkill ie31200_edac evdev ac asus_wireless parport_pc ppdev lp parport efivarfs 
ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs xor zstd_decompress zstd_compress raid6_pq libcrc32c crc32c_generic sr_mod cdrom sd_mod hid_logitech_hidpp hid_logitech_dj hid_generic usbhid 
hid i915 rtsx_pci_sdmmc mmc_core i2c_algo_bit ahci
Feb 20 19:24:54 vinco kernel: [  228.809003]  drm_kms_helper libahci xhci_pci crc32_pclmul mxm_wmi libata xhci_hcd drm crc32c_intel ehci_pci ehci_hcd psmouse scsi_mod usbcore rtsx_pci lpc_ich i2c_i801 
mfd_core r8168(OE) usb_common video wmi battery button
Feb 20 19:24:54 vinco kernel: [  228.809025] CPU: 7 PID: 0 Comm: swapper/7 Tainted: P           OE     5.4.0-4-amd64 #1 Debian 5.4.19-1
Feb 20 19:24:54 vinco kernel: [  228.809027] Hardware name: ASUSTeK COMPUTER INC. N551JM/N551JM, BIOS N551JM.205 02/13/2015
Feb 20 19:24:54 vinco kernel: [  228.809034] RIP: 0010:dev_watchdog+0x248/0x250
Feb 20 19:24:54 vinco kernel: [  228.809038] Code: 85 c0 75 e5 eb 9f 4c 89 ef c6 05 58 1d a8 00 01 e8 0d e4 fa ff 44 89 e1 4c 89 ee 48 c7 c7 f0 cc d2 9a 48 89 c2 e8 76 40 a0 ff <0f> 0b eb 80 0f 1f 40 
00 0f 1f 44 00 00 41 57 41 56 49 89 d6 41 55
Feb 20 19:24:54 vinco kernel: [  228.809040] RSP: 0018:ffffc0e74020ce68 EFLAGS: 00010286
Feb 20 19:24:54 vinco kernel: [  228.809043] RAX: 0000000000000000 RBX: ffff9f660df8e200 RCX: 000000000000083f
Feb 20 19:24:54 vinco kernel: [  228.809044] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
Feb 20 19:24:54 vinco kernel: [  228.809046] RBP: ffff9f660d30045c R08: ffff9f661edd7688 R09: 0000000000000004
Feb 20 19:24:54 vinco kernel: [  228.809048] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
Feb 20 19:24:54 vinco kernel: [  228.809049] R13: ffff9f660d300000 R14: ffff9f660d300480 R15: 0000000000000001
Feb 20 19:24:54 vinco kernel: [  228.809052] FS:  0000000000000000(0000) GS:ffff9f661edc0000(0000) knlGS:0000000000000000
Feb 20 19:24:54 vinco kernel: [  228.809054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 20 19:24:54 vinco kernel: [  228.809055] CR2: 00005f1110bf6da4 CR3: 0000000185e0a001 CR4: 00000000001626e0
Feb 20 19:24:54 vinco kernel: [  228.809057] Call Trace:
Feb 20 19:24:54 vinco kernel: [  228.809060]  <IRQ>
Feb 20 19:24:54 vinco kernel: [  228.809068]  ? pfifo_fast_enqueue+0x150/0x150
Feb 20 19:24:54 vinco kernel: [  228.809073]  call_timer_fn+0x2d/0x130
Feb 20 19:24:54 vinco kernel: [  228.809077]  __run_timers.part.0+0x16f/0x260
Feb 20 19:24:54 vinco kernel: [  228.809084]  ? tick_sched_handle+0x22/0x60
Feb 20 19:24:54 vinco kernel: [  228.809089]  ? tick_sched_timer+0x38/0x80
Feb 20 19:24:54 vinco kernel: [  228.809093]  ? tick_sched_do_timer+0x60/0x60
Feb 20 19:24:54 vinco kernel: [  228.809096]  run_timer_softirq+0x26/0x50
Feb 20 19:24:54 vinco kernel: [  228.809102]  __do_softirq+0xe6/0x2e9
Feb 20 19:24:54 vinco kernel: [  228.809111]  irq_exit+0xa6/0xb0
Feb 20 19:24:54 vinco kernel: [  228.809115]  smp_apic_timer_interrupt+0x76/0x130
Feb 20 19:24:54 vinco kernel: [  228.809118]  apic_timer_interrupt+0xf/0x20
Feb 20 19:24:54 vinco kernel: [  228.809120]  </IRQ>
Feb 20 19:24:54 vinco kernel: [  228.809126] RIP: 0010:cpuidle_enter_state+0xc4/0x450
Feb 20 19:24:54 vinco kernel: [  228.809129] Code: e8 b1 54 ad ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 61 03 00 00 31 ff e8 a3 74 b3 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 8c 02 
00 00 49 63 cc 4c 2b 6c 24 10 48 8d 04 49 48
Feb 20 19:24:54 vinco kernel: [  228.809131] RSP: 0018:ffffc0e7400cfe68 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Feb 20 19:24:54 vinco kernel: [  228.809133] RAX: ffff9f661edea6c0 RBX: ffffffff9aeb92e0 RCX: 000000000000001f
Feb 20 19:24:54 vinco kernel: [  228.809135] RDX: 0000000000000000 RSI: 000000003351882d RDI: 0000000000000000
Feb 20 19:24:54 vinco kernel: [  228.809137] RBP: ffff9f661edf4a00 R08: 000000354610e2fa R09: 0000000000029fa0
Feb 20 19:24:54 vinco kernel: [  228.809138] R10: ffff9f661ede95a0 R11: ffff9f661ede9580 R12: 0000000000000005
Feb 20 19:24:54 vinco kernel: [  228.809140] R13: 000000354610e2fa R14: 0000000000000005 R15: ffff9f661caa8f00
Feb 20 19:24:54 vinco kernel: [  228.809145]  ? cpuidle_enter_state+0x9f/0x450
Feb 20 19:24:54 vinco kernel: [  228.809149]  cpuidle_enter+0x29/0x40
Feb 20 19:24:54 vinco kernel: [  228.809155]  do_idle+0x1dc/0x270
Feb 20 19:24:54 vinco kernel: [  228.809162]  cpu_startup_entry+0x19/0x20
Feb 20 19:24:54 vinco kernel: [  228.809168]  start_secondary+0x15f/0x1b0
Feb 20 19:24:54 vinco kernel: [  228.809174]  secondary_startup_64+0xa4/0xb0
Feb 20 19:24:54 vinco kernel: [  228.809179] ---[ end trace f2c0113df7c88e86 ]---
Feb 20 19:24:57 vinco kernel: [  231.448423] r8168: enp5s0f1: link up

Full kernl.log is attached.

Interestingly, network did started working again after some time. Does that "link up" mean card was reset successfully or something?

--------------9C9987BD455004C616BE9300
Content-Type: text/x-log; charset=UTF-8;
 name="kern.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kern.log"

Feb 20 19:21:10 vinco kernel: [    0.000000] microcode: microcode updated=
 early to revision 0x27, date =3D 2019-02-26
Feb 20 19:21:10 vinco kernel: [    0.000000] Linux version 5.4.0-4-amd64 =
(debian-kernel@lists.debian.org) (gcc version 9.2.1 20200203 (Debian 9.2.=
1-28)) #1 SMP Debian 5.4.19-1 (2020-02-13)
Feb 20 19:21:10 vinco kernel: [    0.000000] Command line: BOOT_IMAGE=3D/=
vmlinuz-5.4.0-4-amd64 root=3DUUID=3D795ee075-978f-4245-9dad-ecccd37080d8 =
ro quiet apparmor=3D1 security=3Dapparmor
Feb 20 19:21:10 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x001: 'x87 floating point registers'
Feb 20 19:21:10 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x002: 'SSE registers'
Feb 20 19:21:10 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x004: 'AVX registers'
Feb 20 19:21:10 vinco kernel: [    0.000000] x86/fpu: xstate_offset[2]:  =
576, xstate_sizes[2]:  256
Feb 20 19:21:10 vinco kernel: [    0.000000] x86/fpu: Enabled xstate feat=
ures 0x7, context size is 832 bytes, using 'standard' format.
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-provided physical RAM m=
ap:
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
000000-0x0000000000057fff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
058000-0x0000000000058fff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
059000-0x000000000009efff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
09f000-0x000000000009ffff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
100000-0x00000000b9754fff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
755000-0x00000000b975bfff] ACPI NVS
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
75c000-0x00000000b9fd4fff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
fd5000-0x00000000ba275fff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ba=
276000-0x00000000c98c5fff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
8c6000-0x00000000c9acefff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
acf000-0x00000000c9e00fff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
e01000-0x00000000cab05fff] ACPI NVS
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
b06000-0x00000000caf59fff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
f5a000-0x00000000caffefff] type 20
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
fff000-0x00000000caffffff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000cb=
c00000-0x00000000cfdfffff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000f8=
000000-0x00000000fbffffff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
c00000-0x00000000fec00fff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
d00000-0x00000000fed03fff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
d1c000-0x00000000fed1ffff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
e00000-0x00000000fee00fff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ff=
000000-0x00000000ffffffff] reserved
Feb 20 19:21:10 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000100=
000000-0x000000042f1fffff] usable
Feb 20 19:21:10 vinco kernel: [    0.000000] NX (Execute Disable) protect=
ion: active
Feb 20 19:21:10 vinco kernel: [    0.000000] efi: EFI v2.31 by American M=
egatrends
Feb 20 19:21:10 vinco kernel: [    0.000000] efi:  ACPI 2.0=3D0xc9e89000 =
 ACPI=3D0xc9e89000  SMBIOS=3D0xf04c0  MPS=3D0xfd5a0=20
Feb 20 19:21:10 vinco kernel: [    0.000000] secureboot: Secure boot coul=
d not be determined (mode 0)
Feb 20 19:21:10 vinco kernel: [    0.000000] SMBIOS 2.7 present.
Feb 20 19:21:10 vinco kernel: [    0.000000] DMI: ASUSTeK COMPUTER INC. N=
551JM/N551JM, BIOS N551JM.205 02/13/2015
Feb 20 19:21:10 vinco kernel: [    0.000000] tsc: Fast TSC calibration us=
ing PIT
Feb 20 19:21:10 vinco kernel: [    0.000000] tsc: Detected 2494.266 MHz p=
rocessor
Feb 20 19:21:10 vinco kernel: [    0.001377] e820: update [mem 0x00000000=
-0x00000fff] usable =3D=3D> reserved
Feb 20 19:21:10 vinco kernel: [    0.001378] e820: remove [mem 0x000a0000=
-0x000fffff] usable
Feb 20 19:21:10 vinco kernel: [    0.001384] last_pfn =3D 0x42f200 max_ar=
ch_pfn =3D 0x400000000
Feb 20 19:21:10 vinco kernel: [    0.001387] MTRR default type: uncachabl=
e
Feb 20 19:21:10 vinco kernel: [    0.001387] MTRR fixed ranges enabled:
Feb 20 19:21:10 vinco kernel: [    0.001388]   00000-9FFFF write-back
Feb 20 19:21:10 vinco kernel: [    0.001389]   A0000-BFFFF uncachable
Feb 20 19:21:10 vinco kernel: [    0.001389]   C0000-CFFFF write-protect
Feb 20 19:21:10 vinco kernel: [    0.001390]   D0000-DFFFF uncachable
Feb 20 19:21:10 vinco kernel: [    0.001390]   E0000-FFFFF write-protect
Feb 20 19:21:10 vinco kernel: [    0.001391] MTRR variable ranges enabled=
:
Feb 20 19:21:10 vinco kernel: [    0.001392]   0 base 0000000000 mask 7C0=
0000000 write-back
Feb 20 19:21:10 vinco kernel: [    0.001392]   1 base 0400000000 mask 7FE=
0000000 write-back
Feb 20 19:21:10 vinco kernel: [    0.001393]   2 base 0420000000 mask 7FF=
0000000 write-back
Feb 20 19:21:10 vinco kernel: [    0.001394]   3 base 00E0000000 mask 7FE=
0000000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001394]   4 base 00D0000000 mask 7FF=
0000000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001395]   5 base 00CC000000 mask 7FF=
C000000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001395]   6 base 00CBC00000 mask 7FF=
FC00000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001396]   7 base 042F800000 mask 7FF=
F800000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001396]   8 base 042F400000 mask 7FF=
FC00000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001397]   9 base 042F200000 mask 7FF=
FE00000 uncachable
Feb 20 19:21:10 vinco kernel: [    0.001661] x86/PAT: Configuration [0-7]=
: WB  WC  UC- UC  WB  WP  UC- WT =20
Feb 20 19:21:10 vinco kernel: [    0.001766] e820: update [mem 0xcbc00000=
-0xffffffff] usable =3D=3D> reserved
Feb 20 19:21:10 vinco kernel: [    0.001769] last_pfn =3D 0xcb000 max_arc=
h_pfn =3D 0x400000000
Feb 20 19:21:10 vinco kernel: [    0.007737] found SMP MP-table at [mem 0=
x000fd8a0-0x000fd8af]
Feb 20 19:21:10 vinco kernel: [    0.007751] Using GB pages for direct ma=
pping
Feb 20 19:21:10 vinco kernel: [    0.007753] BRK [0x186601000, 0x186601ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007754] BRK [0x186602000, 0x186602ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007754] BRK [0x186603000, 0x186603ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007774] BRK [0x186604000, 0x186604ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007775] BRK [0x186605000, 0x186605ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007861] BRK [0x186606000, 0x186606ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007876] BRK [0x186607000, 0x186607ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007906] BRK [0x186608000, 0x186608ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007920] BRK [0x186609000, 0x186609ff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007932] BRK [0x18660a000, 0x18660aff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.007962] BRK [0x18660b000, 0x18660bff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.008011] BRK [0x18660c000, 0x18660cff=
f] PGTABLE
Feb 20 19:21:10 vinco kernel: [    0.008166] RAMDISK: [mem 0x30e85000-0x3=
4739fff]
Feb 20 19:21:10 vinco kernel: [    0.008171] ACPI: Early table checksum v=
erification disabled
Feb 20 19:21:10 vinco kernel: [    0.008173] ACPI: RSDP 0x00000000C9E8900=
0 000024 (v02 _ASUS_)
Feb 20 19:21:10 vinco kernel: [    0.008176] ACPI: XSDT 0x00000000C9E8908=
8 00009C (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 20 19:21:10 vinco kernel: [    0.008180] ACPI: FACP 0x00000000C9E9CF3=
8 00010C (v05 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 20 19:21:10 vinco kernel: [    0.008184] ACPI: DSDT 0x00000000C9E8924=
0 013CF2 (v02 _ASUS_ Notebook 00000012 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008186] ACPI: FACS 0x00000000CAB03F8=
0 000040
Feb 20 19:21:10 vinco kernel: [    0.008188] ACPI: APIC 0x00000000C9E9D04=
8 000092 (v03 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 20 19:21:10 vinco kernel: [    0.008189] ACPI: FPDT 0x00000000C9E9D0E=
0 000044 (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 20 19:21:10 vinco kernel: [    0.008191] ACPI: ECDT 0x00000000C9E9D12=
8 0000C1 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Feb 20 19:21:10 vinco kernel: [    0.008193] ACPI: SSDT 0x00000000C9E9D1F=
0 00019D (v01 Intel  zpodd    00001000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008195] ACPI: SSDT 0x00000000C9E9D39=
0 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008197] ACPI: SSDT 0x00000000C9E9D8D=
0 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008198] ACPI: MCFG 0x00000000C9E9E3A=
8 00003C (v01 _ASUS_ Notebook 01072009 MSFT 00000097)
Feb 20 19:21:10 vinco kernel: [    0.008200] ACPI: HPET 0x00000000C9E9E3E=
8 000038 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Feb 20 19:21:10 vinco kernel: [    0.008202] ACPI: SSDT 0x00000000C9E9E42=
0 000298 (v01 SataRe SataTabl 00001000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008204] ACPI: SSDT 0x00000000C9E9E6B=
8 004541 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
Feb 20 19:21:10 vinco kernel: [    0.008205] ACPI: SSDT 0x00000000C9EA2C0=
0 001983 (v01 SgRef  SgPeg    00001000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008207] ACPI: DMAR 0x00000000C9EA458=
8 0000B8 (v01 INTEL  HSW      00000001 INTL 00000001)
Feb 20 19:21:10 vinco kernel: [    0.008209] ACPI: SSDT 0x00000000C9EA464=
0 0019CA (v01 OptRef OptTabl  00001000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.008211] ACPI: MSDM 0x00000000C9ACDE1=
8 000055 (v03 _ASUS_ Notebook 00000000 ASUS 00000001)
Feb 20 19:21:10 vinco kernel: [    0.008217] ACPI: Local APIC address 0xf=
ee00000
Feb 20 19:21:10 vinco kernel: [    0.008281] No NUMA configuration found
Feb 20 19:21:10 vinco kernel: [    0.008281] Faking a node at [mem 0x0000=
000000000000-0x000000042f1fffff]
Feb 20 19:21:10 vinco kernel: [    0.008284] NODE_DATA(0) allocated [mem =
0x42f1f9000-0x42f1fdfff]
Feb 20 19:21:10 vinco kernel: [    0.008308] Zone ranges:
Feb 20 19:21:10 vinco kernel: [    0.008309]   DMA      [mem 0x0000000000=
001000-0x0000000000ffffff]
Feb 20 19:21:10 vinco kernel: [    0.008310]   DMA32    [mem 0x0000000001=
000000-0x00000000ffffffff]
Feb 20 19:21:10 vinco kernel: [    0.008310]   Normal   [mem 0x0000000100=
000000-0x000000042f1fffff]
Feb 20 19:21:10 vinco kernel: [    0.008311]   Device   empty
Feb 20 19:21:10 vinco kernel: [    0.008311] Movable zone start for each =
node
Feb 20 19:21:10 vinco kernel: [    0.008312] Early memory node ranges
Feb 20 19:21:10 vinco kernel: [    0.008313]   node   0: [mem 0x000000000=
0001000-0x0000000000057fff]
Feb 20 19:21:10 vinco kernel: [    0.008313]   node   0: [mem 0x000000000=
0059000-0x000000000009efff]
Feb 20 19:21:10 vinco kernel: [    0.008314]   node   0: [mem 0x000000000=
0100000-0x00000000b9754fff]
Feb 20 19:21:10 vinco kernel: [    0.008314]   node   0: [mem 0x00000000b=
975c000-0x00000000b9fd4fff]
Feb 20 19:21:10 vinco kernel: [    0.008315]   node   0: [mem 0x00000000b=
a276000-0x00000000c98c5fff]
Feb 20 19:21:10 vinco kernel: [    0.008315]   node   0: [mem 0x00000000c=
9acf000-0x00000000c9e00fff]
Feb 20 19:21:10 vinco kernel: [    0.008315]   node   0: [mem 0x00000000c=
afff000-0x00000000caffffff]
Feb 20 19:21:10 vinco kernel: [    0.008316]   node   0: [mem 0x000000010=
0000000-0x000000042f1fffff]
Feb 20 19:21:10 vinco kernel: [    0.008536] Zeroed struct page in unavai=
lable ranges: 29970 pages
Feb 20 19:21:10 vinco kernel: [    0.008537] Initmem setup node 0 [mem 0x=
0000000000001000-0x000000042f1fffff]
Feb 20 19:21:10 vinco kernel: [    0.008538] On node 0 totalpages: 416433=
4
Feb 20 19:21:10 vinco kernel: [    0.008539]   DMA zone: 64 pages used fo=
r memmap
Feb 20 19:21:10 vinco kernel: [    0.008539]   DMA zone: 26 pages reserve=
d
Feb 20 19:21:10 vinco kernel: [    0.008540]   DMA zone: 3997 pages, LIFO=
 batch:0
Feb 20 19:21:10 vinco kernel: [    0.008577]   DMA32 zone: 12838 pages us=
ed for memmap
Feb 20 19:21:10 vinco kernel: [    0.008577]   DMA32 zone: 821585 pages, =
LIFO batch:63
Feb 20 19:21:10 vinco kernel: [    0.016419]   Normal zone: 52168 pages u=
sed for memmap
Feb 20 19:21:10 vinco kernel: [    0.016420]   Normal zone: 3338752 pages=
, LIFO batch:63
Feb 20 19:21:10 vinco kernel: [    0.044926] Reserving Intel graphics mem=
ory at [mem 0xcbe00000-0xcfdfffff]
Feb 20 19:21:10 vinco kernel: [    0.045094] ACPI: PM-Timer IO Port: 0x18=
08
Feb 20 19:21:10 vinco kernel: [    0.045096] ACPI: Local APIC address 0xf=
ee00000
Feb 20 19:21:10 vinco kernel: [    0.045100] ACPI: LAPIC_NMI (acpi_id[0xf=
f] high edge lint[0x1])
Feb 20 19:21:10 vinco kernel: [    0.045111] IOAPIC[0]: apic_id 8, versio=
n 32, address 0xfec00000, GSI 0-23
Feb 20 19:21:10 vinco kernel: [    0.045112] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 0 global_irq 2 dfl dfl)
Feb 20 19:21:10 vinco kernel: [    0.045113] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 9 global_irq 9 high level)
Feb 20 19:21:10 vinco kernel: [    0.045114] ACPI: IRQ0 used by override.=

Feb 20 19:21:10 vinco kernel: [    0.045115] ACPI: IRQ9 used by override.=

Feb 20 19:21:10 vinco kernel: [    0.045116] Using ACPI (MADT) for SMP co=
nfiguration information
Feb 20 19:21:10 vinco kernel: [    0.045117] ACPI: HPET id: 0x8086a701 ba=
se: 0xfed00000
Feb 20 19:21:10 vinco kernel: [    0.045120] smpboot: Allowing 8 CPUs, 0 =
hotplug CPUs
Feb 20 19:21:10 vinco kernel: [    0.045137] PM: Registered nosave memory=
: [mem 0x00000000-0x00000fff]
Feb 20 19:21:10 vinco kernel: [    0.045138] PM: Registered nosave memory=
: [mem 0x00058000-0x00058fff]
Feb 20 19:21:10 vinco kernel: [    0.045139] PM: Registered nosave memory=
: [mem 0x0009f000-0x0009ffff]
Feb 20 19:21:10 vinco kernel: [    0.045140] PM: Registered nosave memory=
: [mem 0x000a0000-0x000fffff]
Feb 20 19:21:10 vinco kernel: [    0.045141] PM: Registered nosave memory=
: [mem 0xb9755000-0xb975bfff]
Feb 20 19:21:10 vinco kernel: [    0.045142] PM: Registered nosave memory=
: [mem 0xb9fd5000-0xba275fff]
Feb 20 19:21:10 vinco kernel: [    0.045143] PM: Registered nosave memory=
: [mem 0xc98c6000-0xc9acefff]
Feb 20 19:21:10 vinco kernel: [    0.045144] PM: Registered nosave memory=
: [mem 0xc9e01000-0xcab05fff]
Feb 20 19:21:10 vinco kernel: [    0.045145] PM: Registered nosave memory=
: [mem 0xcab06000-0xcaf59fff]
Feb 20 19:21:10 vinco kernel: [    0.045145] PM: Registered nosave memory=
: [mem 0xcaf5a000-0xcaffefff]
Feb 20 19:21:10 vinco kernel: [    0.045146] PM: Registered nosave memory=
: [mem 0xcb000000-0xcbbfffff]
Feb 20 19:21:10 vinco kernel: [    0.045147] PM: Registered nosave memory=
: [mem 0xcbc00000-0xcfdfffff]
Feb 20 19:21:10 vinco kernel: [    0.045147] PM: Registered nosave memory=
: [mem 0xcfe00000-0xf7ffffff]
Feb 20 19:21:10 vinco kernel: [    0.045148] PM: Registered nosave memory=
: [mem 0xf8000000-0xfbffffff]
Feb 20 19:21:10 vinco kernel: [    0.045148] PM: Registered nosave memory=
: [mem 0xfc000000-0xfebfffff]
Feb 20 19:21:10 vinco kernel: [    0.045148] PM: Registered nosave memory=
: [mem 0xfec00000-0xfec00fff]
Feb 20 19:21:10 vinco kernel: [    0.045149] PM: Registered nosave memory=
: [mem 0xfec01000-0xfecfffff]
Feb 20 19:21:10 vinco kernel: [    0.045149] PM: Registered nosave memory=
: [mem 0xfed00000-0xfed03fff]
Feb 20 19:21:10 vinco kernel: [    0.045150] PM: Registered nosave memory=
: [mem 0xfed04000-0xfed1bfff]
Feb 20 19:21:10 vinco kernel: [    0.045150] PM: Registered nosave memory=
: [mem 0xfed1c000-0xfed1ffff]
Feb 20 19:21:10 vinco kernel: [    0.045150] PM: Registered nosave memory=
: [mem 0xfed20000-0xfedfffff]
Feb 20 19:21:10 vinco kernel: [    0.045151] PM: Registered nosave memory=
: [mem 0xfee00000-0xfee00fff]
Feb 20 19:21:10 vinco kernel: [    0.045151] PM: Registered nosave memory=
: [mem 0xfee01000-0xfeffffff]
Feb 20 19:21:10 vinco kernel: [    0.045152] PM: Registered nosave memory=
: [mem 0xff000000-0xffffffff]
Feb 20 19:21:10 vinco kernel: [    0.045153] [mem 0xcfe00000-0xf7ffffff] =
available for PCI devices
Feb 20 19:21:10 vinco kernel: [    0.045154] Booting paravirtualized kern=
el on bare hardware
Feb 20 19:21:10 vinco kernel: [    0.045157] clocksource: refined-jiffies=
: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 =
ns
Feb 20 19:21:10 vinco kernel: [    0.112576] setup_percpu: NR_CPUS:512 nr=
_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
Feb 20 19:21:10 vinco kernel: [    0.112741] percpu: Embedded 53 pages/cp=
u s178584 r8192 d30312 u262144
Feb 20 19:21:10 vinco kernel: [    0.112746] pcpu-alloc: s178584 r8192 d3=
0312 u262144 alloc=3D1*2097152
Feb 20 19:21:10 vinco kernel: [    0.112747] pcpu-alloc: [0] 0 1 2 3 4 5 =
6 7=20
Feb 20 19:21:10 vinco kernel: [    0.112766] Built 1 zonelists, mobility =
grouping on.  Total pages: 4099238
Feb 20 19:21:10 vinco kernel: [    0.112766] Policy zone: Normal
Feb 20 19:21:10 vinco kernel: [    0.112767] Kernel command line: BOOT_IM=
AGE=3D/vmlinuz-5.4.0-4-amd64 root=3DUUID=3D795ee075-978f-4245-9dad-ecccd3=
7080d8 ro quiet apparmor=3D1 security=3Dapparmor
Feb 20 19:21:10 vinco kernel: [    0.113510] Dentry cache hash table entr=
ies: 2097152 (order: 12, 16777216 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.113853] Inode-cache hash table entri=
es: 1048576 (order: 11, 8388608 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.113909] mem auto-init: stack:off, he=
ap alloc:off, heap free:off
Feb 20 19:21:10 vinco kernel: [    0.116680] Calgary: detecting Calgary v=
ia BIOS EBDA area
Feb 20 19:21:10 vinco kernel: [    0.116681] Calgary: Unable to locate Ri=
o Grande table in EBDA - bailing!
Feb 20 19:21:10 vinco kernel: [    0.152090] Memory: 16022816K/16657336K =
available (10243K kernel code, 1197K rwdata, 3736K rodata, 1672K init, 20=
48K bss, 634520K reserved, 0K cma-reserved)
Feb 20 19:21:10 vinco kernel: [    0.152190] SLUB: HWalign=3D64, Order=3D=
0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1
Feb 20 19:21:10 vinco kernel: [    0.152199] Kernel/User page tables isol=
ation: enabled
Feb 20 19:21:10 vinco kernel: [    0.152209] ftrace: allocating 33946 ent=
ries in 133 pages
Feb 20 19:21:10 vinco kernel: [    0.161759] rcu: Hierarchical RCU implem=
entation.
Feb 20 19:21:10 vinco kernel: [    0.161760] rcu: 	RCU restricting CPUs f=
rom NR_CPUS=3D512 to nr_cpu_ids=3D8.
Feb 20 19:21:10 vinco kernel: [    0.161761] rcu: RCU calculated value of=
 scheduler-enlistment delay is 25 jiffies.
Feb 20 19:21:10 vinco kernel: [    0.161761] rcu: Adjusting geometry for =
rcu_fanout_leaf=3D16, nr_cpu_ids=3D8
Feb 20 19:21:10 vinco kernel: [    0.163854] NR_IRQS: 33024, nr_irqs: 488=
, preallocated irqs: 16
Feb 20 19:21:10 vinco kernel: [    0.164030] random: crng done (trusting =
CPU's manufacturer)
Feb 20 19:21:10 vinco kernel: [    0.164046] Console: colour dummy device=
 80x25
Feb 20 19:21:10 vinco kernel: [    0.164050] printk: console [tty0] enabl=
ed
Feb 20 19:21:10 vinco kernel: [    0.164061] ACPI: Core revision 20190816=

Feb 20 19:21:10 vinco kernel: [    0.164183] clocksource: hpet: mask: 0xf=
fffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
Feb 20 19:21:10 vinco kernel: [    0.164194] APIC: Switch to symmetric I/=
O mode setup
Feb 20 19:21:10 vinco kernel: [    0.164195] DMAR: Host address width 39
Feb 20 19:21:10 vinco kernel: [    0.164196] DMAR: DRHD base: 0x000000fed=
90000 flags: 0x0
Feb 20 19:21:10 vinco kernel: [    0.164199] DMAR: dmar0: reg_base_addr f=
ed90000 ver 1:0 cap c0000020660462 ecap f0101a
Feb 20 19:21:10 vinco kernel: [    0.164200] DMAR: DRHD base: 0x000000fed=
91000 flags: 0x1
Feb 20 19:21:10 vinco kernel: [    0.164202] DMAR: dmar1: reg_base_addr f=
ed91000 ver 1:0 cap d2008020660462 ecap f010da
Feb 20 19:21:10 vinco kernel: [    0.164202] DMAR: RMRR base: 0x000000c9a=
56000 end: 0x000000c9a62fff
Feb 20 19:21:10 vinco kernel: [    0.164203] DMAR: RMRR base: 0x000000cbc=
00000 end: 0x000000cfdfffff
Feb 20 19:21:10 vinco kernel: [    0.164204] DMAR-IR: IOAPIC id 8 under D=
RHD base  0xfed91000 IOMMU 1
Feb 20 19:21:10 vinco kernel: [    0.164205] DMAR-IR: HPET id 0 under DRH=
D base 0xfed91000
Feb 20 19:21:10 vinco kernel: [    0.164205] DMAR-IR: Queued invalidation=
 will be enabled to support x2apic and Intr-remapping.
Feb 20 19:21:10 vinco kernel: [    0.164575] DMAR-IR: Enabled IRQ remappi=
ng in x2apic mode
Feb 20 19:21:10 vinco kernel: [    0.164576] x2apic enabled
Feb 20 19:21:10 vinco kernel: [    0.164581] Switched APIC routing to clu=
ster x2apic.
Feb 20 19:21:10 vinco kernel: [    0.164953] ..TIMER: vector=3D0x30 apic1=
=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
Feb 20 19:21:10 vinco kernel: [    0.184195] clocksource: tsc-early: mask=
: 0xffffffffffffffff max_cycles: 0x23f41115f43, max_idle_ns: 440795273768=
 ns
Feb 20 19:21:10 vinco kernel: [    0.184198] Calibrating delay loop (skip=
ped), value calculated using timer frequency.. 4988.53 BogoMIPS (lpj=3D99=
77064)
Feb 20 19:21:10 vinco kernel: [    0.184200] pid_max: default: 32768 mini=
mum: 301
Feb 20 19:21:10 vinco kernel: [    0.188820] LSM: Security Framework init=
ializing
Feb 20 19:21:10 vinco kernel: [    0.188825] Yama: disabled by default; e=
nable with sysctl kernel.yama.*
Feb 20 19:21:10 vinco kernel: [    0.188843] AppArmor: AppArmor initializ=
ed
Feb 20 19:21:10 vinco kernel: [    0.188878] Mount-cache hash table entri=
es: 32768 (order: 6, 262144 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.188906] Mountpoint-cache hash table =
entries: 32768 (order: 6, 262144 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.189089] mce: CPU0: Thermal monitorin=
g enabled (TM1)
Feb 20 19:21:10 vinco kernel: [    0.189101] process: using mwait in idle=
 threads
Feb 20 19:21:10 vinco kernel: [    0.189103] Last level iTLB entries: 4KB=
 1024, 2MB 1024, 4MB 1024
Feb 20 19:21:10 vinco kernel: [    0.189104] Last level dTLB entries: 4KB=
 1024, 2MB 1024, 4MB 1024, 1GB 4
Feb 20 19:21:10 vinco kernel: [    0.189106] Spectre V1 : Mitigation: use=
rcopy/swapgs barriers and __user pointer sanitization
Feb 20 19:21:10 vinco kernel: [    0.189107] Spectre V2 : Mitigation: Ful=
l generic retpoline
Feb 20 19:21:10 vinco kernel: [    0.189107] Spectre V2 : Spectre v2 / Sp=
ectreRSB mitigation: Filling RSB on context switch
Feb 20 19:21:10 vinco kernel: [    0.189107] Spectre V2 : Enabling Restri=
cted Speculation for firmware calls
Feb 20 19:21:10 vinco kernel: [    0.189108] Spectre V2 : mitigation: Ena=
bling conditional Indirect Branch Prediction Barrier
Feb 20 19:21:10 vinco kernel: [    0.189109] Spectre V2 : User space: Mit=
igation: STIBP via seccomp and prctl
Feb 20 19:21:10 vinco kernel: [    0.189110] Speculative Store Bypass: Mi=
tigation: Speculative Store Bypass disabled via prctl and seccomp
Feb 20 19:21:10 vinco kernel: [    0.189112] MDS: Mitigation: Clear CPU b=
uffers
Feb 20 19:21:10 vinco kernel: [    0.189242] Freeing SMP alternatives mem=
ory: 24K
Feb 20 19:21:10 vinco kernel: [    0.191378] TSC deadline timer enabled
Feb 20 19:21:10 vinco kernel: [    0.191380] smpboot: CPU0: Intel(R) Core=
(TM) i7-4710HQ CPU @ 2.50GHz (family: 0x6, model: 0x3c, stepping: 0x3)
Feb 20 19:21:10 vinco kernel: [    0.191453] Performance Events: PEBS fmt=
2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
Feb 20 19:21:10 vinco kernel: [    0.191466] ... version:                =
3
Feb 20 19:21:10 vinco kernel: [    0.191467] ... bit width:              =
48
Feb 20 19:21:10 vinco kernel: [    0.191467] ... generic registers:      =
4
Feb 20 19:21:10 vinco kernel: [    0.191467] ... value mask:             =
0000ffffffffffff
Feb 20 19:21:10 vinco kernel: [    0.191468] ... max period:             =
00007fffffffffff
Feb 20 19:21:10 vinco kernel: [    0.191468] ... fixed-purpose events:   =
3
Feb 20 19:21:10 vinco kernel: [    0.191468] ... event mask:             =
000000070000000f
Feb 20 19:21:10 vinco kernel: [    0.191493] rcu: Hierarchical SRCU imple=
mentation.
Feb 20 19:21:10 vinco kernel: [    0.192090] NMI watchdog: Enabled. Perma=
nently consumes one hw-PMU counter.
Feb 20 19:21:10 vinco kernel: [    0.192139] smp: Bringing up secondary C=
PUs ...
Feb 20 19:21:10 vinco kernel: [    0.192189] x86: Booting SMP configurati=
on:
Feb 20 19:21:10 vinco kernel: [    0.192190] .... node  #0, CPUs:      #1=
 #2 #3 #4
Feb 20 19:21:10 vinco kernel: [    0.193660] MDS CPU bug present and SMT =
on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-=
guide/hw-vuln/mds.html for more details.
Feb 20 19:21:10 vinco kernel: [    0.193660]  #5 #6 #7
Feb 20 19:21:10 vinco kernel: [    0.193660] smp: Brought up 1 node, 8 CP=
Us
Feb 20 19:21:10 vinco kernel: [    0.193660] smpboot: Max logical package=
s: 1
Feb 20 19:21:10 vinco kernel: [    0.193660] smpboot: Total of 8 processo=
rs activated (39908.25 BogoMIPS)
Feb 20 19:21:10 vinco kernel: [    0.196510] devtmpfs: initialized
Feb 20 19:21:10 vinco kernel: [    0.196510] x86/mm: Memory block size: 1=
28MB
Feb 20 19:21:10 vinco kernel: [    0.197362] PM: Registering ACPI NVS reg=
ion [mem 0xb9755000-0xb975bfff] (28672 bytes)
Feb 20 19:21:10 vinco kernel: [    0.197362] PM: Registering ACPI NVS reg=
ion [mem 0xc9e01000-0xcab05fff] (13651968 bytes)
Feb 20 19:21:10 vinco kernel: [    0.197362] clocksource: jiffies: mask: =
0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
Feb 20 19:21:10 vinco kernel: [    0.197362] futex hash table entries: 20=
48 (order: 5, 131072 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.197362] pinctrl core: initialized pi=
nctrl subsystem
Feb 20 19:21:10 vinco kernel: [    0.197362] NET: Registered protocol fam=
ily 16
Feb 20 19:21:10 vinco kernel: [    0.197362] audit: initializing netlink =
subsys (disabled)
Feb 20 19:21:10 vinco kernel: [    0.197362] audit: type=3D2000 audit(158=
2219265.032:1): state=3Dinitialized audit_enabled=3D0 res=3D1
Feb 20 19:21:10 vinco kernel: [    0.197362] cpuidle: using governor ladd=
er
Feb 20 19:21:10 vinco kernel: [    0.197362] cpuidle: using governor menu=

Feb 20 19:21:10 vinco kernel: [    0.197362] ACPI FADT declares the syste=
m doesn't support PCIe ASPM, so disable it
Feb 20 19:21:10 vinco kernel: [    0.197362] ACPI: bus type PCI registere=
d
Feb 20 19:21:10 vinco kernel: [    0.197362] acpiphp: ACPI Hot Plug PCI C=
ontroller Driver version: 0.5
Feb 20 19:21:10 vinco kernel: [    0.197362] PCI: MMCONFIG for domain 000=
0 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Feb 20 19:21:10 vinco kernel: [    0.197362] PCI: MMCONFIG at [mem 0xf800=
0000-0xfbffffff] reserved in E820
Feb 20 19:21:10 vinco kernel: [    0.197362] pmd_set_huge: Cannot satisfy=
 [mem 0xf8000000-0xf8200000] with a huge-page mapping due to MTRR overrid=
e.
Feb 20 19:21:10 vinco kernel: [    0.197362] PCI: Using configuration typ=
e 1 for base access
Feb 20 19:21:10 vinco kernel: [    0.197362] core: PMU erratum BJ122, BV9=
8, HSD29 worked around, HT is on
Feb 20 19:21:10 vinco kernel: [    0.197362] ENERGY_PERF_BIAS: Set to 'no=
rmal', was 'performance'
Feb 20 19:21:10 vinco kernel: [    0.197362] HugeTLB registered 1.00 GiB =
page size, pre-allocated 0 pages
Feb 20 19:21:10 vinco kernel: [    0.197362] HugeTLB registered 2.00 MiB =
page size, pre-allocated 0 pages
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(Module Devi=
ce)
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(Processor D=
evice)
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(3.0 _SCP Ex=
tensions)
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(Processor A=
ggregator Device)
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(Linux-Dell-=
Video)
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(Linux-Lenov=
o-NV-HDMI-Audio)
Feb 20 19:21:10 vinco kernel: [    0.316351] ACPI: Added _OSI(Linux-HPI-H=
ybrid-Graphics)
Feb 20 19:21:10 vinco kernel: [    0.328639] ACPI: 8 ACPI AML tables succ=
essfully acquired and loaded
Feb 20 19:21:10 vinco kernel: [    0.329146] ACPI: EC: EC started
Feb 20 19:21:10 vinco kernel: [    0.329147] ACPI: EC: interrupt blocked
Feb 20 19:21:10 vinco kernel: [    0.329946] ACPI: \: Used as first EC
Feb 20 19:21:10 vinco kernel: [    0.329947] ACPI: \: GPE=3D0x19, EC_CMD/=
EC_SC=3D0x66, EC_DATA=3D0x62
Feb 20 19:21:10 vinco kernel: [    0.329947] ACPI: EC: Boot ECDT EC used =
to handle transactions
Feb 20 19:21:10 vinco kernel: [    0.330576] ACPI: [Firmware Bug]: BIOS _=
OSI(Linux) query ignored
Feb 20 19:21:10 vinco kernel: [    0.333296] ACPI: Dynamic OEM Table Load=
:
Feb 20 19:21:10 vinco kernel: [    0.333300] ACPI: SSDT 0xFFFF9F661C7F240=
0 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.334020] ACPI: Dynamic OEM Table Load=
:
Feb 20 19:21:10 vinco kernel: [    0.334023] ACPI: SSDT 0xFFFF9F661C08A80=
0 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.334767] ACPI: Dynamic OEM Table Load=
:
Feb 20 19:21:10 vinco kernel: [    0.334769] ACPI: SSDT 0xFFFF9F661C7E920=
0 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
Feb 20 19:21:10 vinco kernel: [    0.336322] ACPI: Interpreter enabled
Feb 20 19:21:10 vinco kernel: [    0.336347] ACPI: (supports S0 S3 S4 S5)=

Feb 20 19:21:10 vinco kernel: [    0.336348] ACPI: Using IOAPIC for inter=
rupt routing
Feb 20 19:21:10 vinco kernel: [    0.336370] PCI: Using host bridge windo=
ws from ACPI; if necessary, use "pci=3Dnocrs" and report a bug
Feb 20 19:21:10 vinco kernel: [    0.336573] ACPI: Enabled 7 GPEs in bloc=
k 00 to 3F
Feb 20 19:21:10 vinco kernel: [    0.340282] ACPI: Power Resource [PG00] =
(on)
Feb 20 19:21:10 vinco kernel: [    0.343983] ACPI: PCI Root Bridge [PCI0]=
 (domain 0000 [bus 00-3e])
Feb 20 19:21:10 vinco kernel: [    0.343986] acpi PNP0A08:00: _OSC: OS su=
pports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
Feb 20 19:21:10 vinco kernel: [    0.344455] acpi PNP0A08:00: _OSC: OS no=
w controls [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR]
Feb 20 19:21:10 vinco kernel: [    0.344456] acpi PNP0A08:00: FADT indica=
tes ASPM is unsupported, using BIOS configuration
Feb 20 19:21:10 vinco kernel: [    0.344737] PCI host bridge to bus 0000:=
00
Feb 20 19:21:10 vinco kernel: [    0.344739] pci_bus 0000:00: root bus re=
source [io  0x0000-0x0cf7 window]
Feb 20 19:21:10 vinco kernel: [    0.344740] pci_bus 0000:00: root bus re=
source [io  0x0d00-0xffff window]
Feb 20 19:21:10 vinco kernel: [    0.344741] pci_bus 0000:00: root bus re=
source [mem 0x000a0000-0x000bffff window]
Feb 20 19:21:10 vinco kernel: [    0.344741] pci_bus 0000:00: root bus re=
source [mem 0x000d0000-0x000d3fff window]
Feb 20 19:21:10 vinco kernel: [    0.344742] pci_bus 0000:00: root bus re=
source [mem 0x000d4000-0x000d7fff window]
Feb 20 19:21:10 vinco kernel: [    0.344743] pci_bus 0000:00: root bus re=
source [mem 0x000d8000-0x000dbfff window]
Feb 20 19:21:10 vinco kernel: [    0.344743] pci_bus 0000:00: root bus re=
source [mem 0x000dc000-0x000dffff window]
Feb 20 19:21:10 vinco kernel: [    0.344744] pci_bus 0000:00: root bus re=
source [mem 0xcfe00000-0xfeafffff window]
Feb 20 19:21:10 vinco kernel: [    0.344745] pci_bus 0000:00: root bus re=
source [bus 00-3e]
Feb 20 19:21:10 vinco kernel: [    0.344751] pci 0000:00:00.0: [8086:0c04=
] type 00 class 0x060000
Feb 20 19:21:10 vinco kernel: [    0.344814] pci 0000:00:01.0: [8086:0c01=
] type 01 class 0x060400
Feb 20 19:21:10 vinco kernel: [    0.344846] pci 0000:00:01.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.344939] pci 0000:00:02.0: [8086:0416=
] type 00 class 0x030000
Feb 20 19:21:10 vinco kernel: [    0.344947] pci 0000:00:02.0: reg 0x10: =
[mem 0xf7400000-0xf77fffff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.344951] pci 0000:00:02.0: reg 0x18: =
[mem 0xd0000000-0xdfffffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.344954] pci 0000:00:02.0: reg 0x20: =
[io  0xf000-0xf03f]
Feb 20 19:21:10 vinco kernel: [    0.344963] pci 0000:00:02.0: BAR 2: ass=
igned to efifb
Feb 20 19:21:10 vinco kernel: [    0.345017] pci 0000:00:03.0: [8086:0c0c=
] type 00 class 0x040300
Feb 20 19:21:10 vinco kernel: [    0.345024] pci 0000:00:03.0: reg 0x10: =
[mem 0xf7a14000-0xf7a17fff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.345104] pci 0000:00:14.0: [8086:8c31=
] type 00 class 0x0c0330
Feb 20 19:21:10 vinco kernel: [    0.345123] pci 0000:00:14.0: reg 0x10: =
[mem 0xf7a00000-0xf7a0ffff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.345174] pci 0000:00:14.0: PME# suppo=
rted from D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.345232] pci 0000:00:16.0: [8086:8c3a=
] type 00 class 0x078000
Feb 20 19:21:10 vinco kernel: [    0.345251] pci 0000:00:16.0: reg 0x10: =
[mem 0xf7a1e000-0xf7a1e00f 64bit]
Feb 20 19:21:10 vinco kernel: [    0.345305] pci 0000:00:16.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.345362] pci 0000:00:1a.0: [8086:8c2d=
] type 00 class 0x0c0320
Feb 20 19:21:10 vinco kernel: [    0.345381] pci 0000:00:1a.0: reg 0x10: =
[mem 0xf7a1c000-0xf7a1c3ff]
Feb 20 19:21:10 vinco kernel: [    0.345454] pci 0000:00:1a.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.345516] pci 0000:00:1b.0: [8086:8c20=
] type 00 class 0x040300
Feb 20 19:21:10 vinco kernel: [    0.345533] pci 0000:00:1b.0: reg 0x10: =
[mem 0xf7a10000-0xf7a13fff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.345593] pci 0000:00:1b.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.345651] pci 0000:00:1c.0: [8086:8c10=
] type 01 class 0x060400
Feb 20 19:21:10 vinco kernel: [    0.345720] pci 0000:00:1c.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.345736] pci 0000:00:1c.0: Enabling M=
PC IRBNCE
Feb 20 19:21:10 vinco kernel: [    0.345738] pci 0000:00:1c.0: Intel PCH =
root port ACS workaround enabled
Feb 20 19:21:10 vinco kernel: [    0.345822] pci 0000:00:1c.1: [8086:8c12=
] type 01 class 0x060400
Feb 20 19:21:10 vinco kernel: [    0.345910] pci 0000:00:1c.1: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.345925] pci 0000:00:1c.1: Enabling M=
PC IRBNCE
Feb 20 19:21:10 vinco kernel: [    0.345927] pci 0000:00:1c.1: Intel PCH =
root port ACS workaround enabled
Feb 20 19:21:10 vinco kernel: [    0.346006] pci 0000:00:1c.2: [8086:8c14=
] type 01 class 0x060400
Feb 20 19:21:10 vinco kernel: [    0.346076] pci 0000:00:1c.2: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.346090] pci 0000:00:1c.2: Enabling M=
PC IRBNCE
Feb 20 19:21:10 vinco kernel: [    0.346092] pci 0000:00:1c.2: Intel PCH =
root port ACS workaround enabled
Feb 20 19:21:10 vinco kernel: [    0.346175] pci 0000:00:1c.3: [8086:8c16=
] type 01 class 0x060400
Feb 20 19:21:10 vinco kernel: [    0.346244] pci 0000:00:1c.3: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.346259] pci 0000:00:1c.3: Enabling M=
PC IRBNCE
Feb 20 19:21:10 vinco kernel: [    0.346261] pci 0000:00:1c.3: Intel PCH =
root port ACS workaround enabled
Feb 20 19:21:10 vinco kernel: [    0.346347] pci 0000:00:1d.0: [8086:8c26=
] type 00 class 0x0c0320
Feb 20 19:21:10 vinco kernel: [    0.346367] pci 0000:00:1d.0: reg 0x10: =
[mem 0xf7a1b000-0xf7a1b3ff]
Feb 20 19:21:10 vinco kernel: [    0.346441] pci 0000:00:1d.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.346504] pci 0000:00:1f.0: [8086:8c49=
] type 00 class 0x060100
Feb 20 19:21:10 vinco kernel: [    0.346651] pci 0000:00:1f.2: [8086:8c03=
] type 00 class 0x010601
Feb 20 19:21:10 vinco kernel: [    0.346665] pci 0000:00:1f.2: reg 0x10: =
[io  0xf0b0-0xf0b7]
Feb 20 19:21:10 vinco kernel: [    0.346671] pci 0000:00:1f.2: reg 0x14: =
[io  0xf0a0-0xf0a3]
Feb 20 19:21:10 vinco kernel: [    0.346677] pci 0000:00:1f.2: reg 0x18: =
[io  0xf090-0xf097]
Feb 20 19:21:10 vinco kernel: [    0.346683] pci 0000:00:1f.2: reg 0x1c: =
[io  0xf080-0xf083]
Feb 20 19:21:10 vinco kernel: [    0.346689] pci 0000:00:1f.2: reg 0x20: =
[io  0xf060-0xf07f]
Feb 20 19:21:10 vinco kernel: [    0.346695] pci 0000:00:1f.2: reg 0x24: =
[mem 0xf7a1a000-0xf7a1a7ff]
Feb 20 19:21:10 vinco kernel: [    0.346725] pci 0000:00:1f.2: PME# suppo=
rted from D3hot
Feb 20 19:21:10 vinco kernel: [    0.346778] pci 0000:00:1f.3: [8086:8c22=
] type 00 class 0x0c0500
Feb 20 19:21:10 vinco kernel: [    0.346794] pci 0000:00:1f.3: reg 0x10: =
[mem 0xf7a19000-0xf7a190ff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.346811] pci 0000:00:1f.3: reg 0x20: =
[io  0xf040-0xf05f]
Feb 20 19:21:10 vinco kernel: [    0.346915] pci 0000:01:00.0: [10de:1392=
] type 00 class 0x030200
Feb 20 19:21:10 vinco kernel: [    0.346939] pci 0000:01:00.0: reg 0x10: =
[mem 0xf6000000-0xf6ffffff]
Feb 20 19:21:10 vinco kernel: [    0.346954] pci 0000:01:00.0: reg 0x14: =
[mem 0xe0000000-0xefffffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.346969] pci 0000:01:00.0: reg 0x1c: =
[mem 0xf0000000-0xf1ffffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.346980] pci 0000:01:00.0: reg 0x24: =
[io  0xe000-0xe07f]
Feb 20 19:21:10 vinco kernel: [    0.346990] pci 0000:01:00.0: reg 0x30: =
[mem 0xf7000000-0xf707ffff pref]
Feb 20 19:21:10 vinco kernel: [    0.347007] pci 0000:01:00.0: Enabling H=
DA controller
Feb 20 19:21:10 vinco kernel: [    0.347158] pci 0000:00:01.0: PCI bridge=
 to [bus 01]
Feb 20 19:21:10 vinco kernel: [    0.347159] pci 0000:00:01.0:   bridge w=
indow [io  0xe000-0xefff]
Feb 20 19:21:10 vinco kernel: [    0.347161] pci 0000:00:01.0:   bridge w=
indow [mem 0xf6000000-0xf70fffff]
Feb 20 19:21:10 vinco kernel: [    0.347163] pci 0000:00:01.0:   bridge w=
indow [mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.347206] acpiphp: Slot [1] registered=

Feb 20 19:21:10 vinco kernel: [    0.347210] pci 0000:00:1c.0: PCI bridge=
 to [bus 02]
Feb 20 19:21:10 vinco kernel: [    0.347265] pci 0000:00:1c.1: PCI bridge=
 to [bus 03]
Feb 20 19:21:10 vinco kernel: [    0.347361] pci 0000:04:00.0: [8086:08b1=
] type 00 class 0x028000
Feb 20 19:21:10 vinco kernel: [    0.347437] pci 0000:04:00.0: reg 0x10: =
[mem 0xf7900000-0xf7901fff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.347702] pci 0000:04:00.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.347901] pci 0000:00:1c.2: PCI bridge=
 to [bus 04]
Feb 20 19:21:10 vinco kernel: [    0.347905] pci 0000:00:1c.2:   bridge w=
indow [mem 0xf7900000-0xf79fffff]
Feb 20 19:21:10 vinco kernel: [    0.347969] pci 0000:05:00.0: [10ec:5287=
] type 00 class 0xff0000
Feb 20 19:21:10 vinco kernel: [    0.347999] pci 0000:05:00.0: reg 0x10: =
[mem 0xf7815000-0xf7815fff]
Feb 20 19:21:10 vinco kernel: [    0.348059] pci 0000:05:00.0: reg 0x30: =
[mem 0xf7800000-0xf780ffff pref]
Feb 20 19:21:10 vinco kernel: [    0.348150] pci 0000:05:00.0: supports D=
1 D2
Feb 20 19:21:10 vinco kernel: [    0.348151] pci 0000:05:00.0: PME# suppo=
rted from D1 D2 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.348258] pci 0000:05:00.1: [10ec:8168=
] type 00 class 0x020000
Feb 20 19:21:10 vinco kernel: [    0.348287] pci 0000:05:00.1: reg 0x10: =
[io  0xd000-0xd0ff]
Feb 20 19:21:10 vinco kernel: [    0.348314] pci 0000:05:00.1: reg 0x18: =
[mem 0xf7814000-0xf7814fff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.348330] pci 0000:05:00.1: reg 0x20: =
[mem 0xf7810000-0xf7813fff 64bit]
Feb 20 19:21:10 vinco kernel: [    0.348429] pci 0000:05:00.1: supports D=
1 D2
Feb 20 19:21:10 vinco kernel: [    0.348430] pci 0000:05:00.1: PME# suppo=
rted from D0 D1 D2 D3hot D3cold
Feb 20 19:21:10 vinco kernel: [    0.348559] pci 0000:00:1c.3: PCI bridge=
 to [bus 05]
Feb 20 19:21:10 vinco kernel: [    0.348562] pci 0000:00:1c.3:   bridge w=
indow [io  0xd000-0xdfff]
Feb 20 19:21:10 vinco kernel: [    0.348564] pci 0000:00:1c.3:   bridge w=
indow [mem 0xf7800000-0xf78fffff]
Feb 20 19:21:10 vinco kernel: [    0.349132] ACPI: PCI Interrupt Link [LN=
KA] (IRQs 3 4 5 6 7 10 *11 12)
Feb 20 19:21:10 vinco kernel: [    0.349166] ACPI: PCI Interrupt Link [LN=
KB] (IRQs *3 4 5 6 7 10 12)
Feb 20 19:21:10 vinco kernel: [    0.349198] ACPI: PCI Interrupt Link [LN=
KC] (IRQs 3 *4 5 6 7 10 12)
Feb 20 19:21:10 vinco kernel: [    0.349229] ACPI: PCI Interrupt Link [LN=
KD] (IRQs 3 4 5 6 7 *10 12)
Feb 20 19:21:10 vinco kernel: [    0.349260] ACPI: PCI Interrupt Link [LN=
KE] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Feb 20 19:21:10 vinco kernel: [    0.349291] ACPI: PCI Interrupt Link [LN=
KF] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Feb 20 19:21:10 vinco kernel: [    0.349322] ACPI: PCI Interrupt Link [LN=
KG] (IRQs 3 4 *5 6 7 10 12)
Feb 20 19:21:10 vinco kernel: [    0.349352] ACPI: PCI Interrupt Link [LN=
KH] (IRQs 3 4 5 6 7 *10 12)
Feb 20 19:21:10 vinco kernel: [    0.349617] ACPI: EC: interrupt unblocke=
d
Feb 20 19:21:10 vinco kernel: [    0.349624] ACPI: EC: event unblocked
Feb 20 19:21:10 vinco kernel: [    0.349641] ACPI: \_SB_.PCI0.LPCB.EC0_: =
GPE=3D0x19, EC_CMD/EC_SC=3D0x66, EC_DATA=3D0x62
Feb 20 19:21:10 vinco kernel: [    0.349642] ACPI: \_SB_.PCI0.LPCB.EC0_: =
Boot DSDT EC used to handle transactions and events
Feb 20 19:21:10 vinco kernel: [    0.349686] iommu: Default domain type: =
Translated=20
Feb 20 19:21:10 vinco kernel: [    0.349694] pci 0000:00:02.0: vgaarb: se=
tting as boot VGA device
Feb 20 19:21:10 vinco kernel: [    0.349694] pci 0000:00:02.0: vgaarb: VG=
A device added: decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
Feb 20 19:21:10 vinco kernel: [    0.349694] pci 0000:00:02.0: vgaarb: br=
idge control possible
Feb 20 19:21:10 vinco kernel: [    0.349694] vgaarb: loaded
Feb 20 19:21:10 vinco kernel: [    0.349694] EDAC MC: Ver: 3.0.0
Feb 20 19:21:10 vinco kernel: [    0.349694] Registered efivars operation=
s
Feb 20 19:21:10 vinco kernel: [    0.349694] PCI: Using ACPI for IRQ rout=
ing
Feb 20 19:21:10 vinco kernel: [    0.349694] PCI: pci_cache_line_size set=
 to 64 bytes
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0x00058000-0x0005ffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0x0009f000-0x0009ffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0xb9755000-0xbbffffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0xb9fd5000-0xbbffffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0xc98c6000-0xcbffffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0xc9e01000-0xcbffffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0xcb000000-0xcbffffff]
Feb 20 19:21:10 vinco kernel: [    0.349694] e820: reserve RAM buffer [me=
m 0x42f200000-0x42fffffff]
Feb 20 19:21:10 vinco kernel: [    0.349902] hpet0: at MMIO 0xfed00000, I=
RQs 2, 8, 0, 0, 0, 0, 0, 0
Feb 20 19:21:10 vinco kernel: [    0.349905] hpet0: 8 comparators, 64-bit=
 14.318180 MHz counter
Feb 20 19:21:10 vinco kernel: [    0.353219] clocksource: Switched to clo=
cksource tsc-early
Feb 20 19:21:10 vinco kernel: [    0.359179] VFS: Disk quotas dquot_6.6.0=

Feb 20 19:21:10 vinco kernel: [    0.359179] VFS: Dquot-cache hash table =
entries: 512 (order 0, 4096 bytes)
Feb 20 19:21:10 vinco kernel: [    0.359179] AppArmor: AppArmor Filesyste=
m Enabled
Feb 20 19:21:10 vinco kernel: [    0.359179] pnp: PnP ACPI init
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:00: [mem 0xfed4000=
0-0xfed44fff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:00: Plug and Play =
ACPI device, IDs PNP0c01 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x0680-0x=
069f] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0xffff] h=
as been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0xffff] h=
as been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0xffff] h=
as been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x1c00-0x=
1cfe] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x1d00-0x=
1dfe] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x1e00-0x=
1efe] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x1f00-0x=
1ffe] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x1800-0x=
18fe] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: [io  0x164e-0x=
164f] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:01: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] pnp 00:02: Plug and Play ACP=
I device, IDs PNP0b00 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:03: [io  0x1854-0x=
1857] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:03: Plug and Play =
ACPI device, IDs INT3f0d PNP0c02 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:04: [io  0x04d0-0x=
04d1] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:04: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:05: [io  0x0240-0x=
0259] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.359179] system 00:05: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] pnp 00:06: Plug and Play ACP=
I device, IDs ETD0108 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
Feb 20 19:21:10 vinco kernel: [    0.359179] pnp 00:07: Plug and Play ACP=
I device, IDs ATK3001 PNP030b (active)
Feb 20 19:21:10 vinco kernel: [    0.360254] system 00:08: [mem 0xfed1c00=
0-0xfed1ffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360255] system 00:08: [mem 0xfed1000=
0-0xfed17fff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360256] system 00:08: [mem 0xfed1800=
0-0xfed18fff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360256] system 00:08: [mem 0xfed1900=
0-0xfed19fff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360257] system 00:08: [mem 0xf800000=
0-0xfbffffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360258] system 00:08: [mem 0xfed2000=
0-0xfed3ffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360259] system 00:08: [mem 0xfed9000=
0-0xfed93fff] could not be reserved
Feb 20 19:21:10 vinco kernel: [    0.360260] system 00:08: [mem 0xfed4500=
0-0xfed8ffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360261] system 00:08: [mem 0xff00000=
0-0xffffffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360262] system 00:08: [mem 0xfee0000=
0-0xfeefffff] could not be reserved
Feb 20 19:21:10 vinco kernel: [    0.360263] system 00:08: [mem 0xf7fdf00=
0-0xf7fdffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360264] system 00:08: [mem 0xf7fe000=
0-0xf7feffff] has been reserved
Feb 20 19:21:10 vinco kernel: [    0.360266] system 00:08: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 20 19:21:10 vinco kernel: [    0.360323] system 00:09: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 20 19:21:10 vinco kernel: [    0.360538] pnp: PnP ACPI: found 10 devi=
ces
Feb 20 19:21:10 vinco kernel: [    0.361314] thermal_sys: Registered ther=
mal governor 'fair_share'
Feb 20 19:21:10 vinco kernel: [    0.361314] thermal_sys: Registered ther=
mal governor 'bang_bang'
Feb 20 19:21:10 vinco kernel: [    0.361315] thermal_sys: Registered ther=
mal governor 'step_wise'
Feb 20 19:21:10 vinco kernel: [    0.361315] thermal_sys: Registered ther=
mal governor 'user_space'
Feb 20 19:21:10 vinco kernel: [    0.365806] clocksource: acpi_pm: mask: =
0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
Feb 20 19:21:10 vinco kernel: [    0.365828] pci 0000:00:1c.1: bridge win=
dow [io  0x1000-0x0fff] to [bus 03] add_size 1000
Feb 20 19:21:10 vinco kernel: [    0.365830] pci 0000:00:1c.1: bridge win=
dow [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 ad=
d_align 100000
Feb 20 19:21:10 vinco kernel: [    0.365831] pci 0000:00:1c.1: bridge win=
dow [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100=
000
Feb 20 19:21:10 vinco kernel: [    0.365836] pci 0000:00:1c.1: BAR 14: as=
signed [mem 0xcfe00000-0xcfffffff]
Feb 20 19:21:10 vinco kernel: [    0.365839] pci 0000:00:1c.1: BAR 15: as=
signed [mem 0xf2000000-0xf21fffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.365841] pci 0000:00:1c.1: BAR 13: as=
signed [io  0x2000-0x2fff]
Feb 20 19:21:10 vinco kernel: [    0.365843] pci 0000:00:01.0: PCI bridge=
 to [bus 01]
Feb 20 19:21:10 vinco kernel: [    0.365844] pci 0000:00:01.0:   bridge w=
indow [io  0xe000-0xefff]
Feb 20 19:21:10 vinco kernel: [    0.365846] pci 0000:00:01.0:   bridge w=
indow [mem 0xf6000000-0xf70fffff]
Feb 20 19:21:10 vinco kernel: [    0.365847] pci 0000:00:01.0:   bridge w=
indow [mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.365850] pci 0000:00:1c.0: PCI bridge=
 to [bus 02]
Feb 20 19:21:10 vinco kernel: [    0.365858] pci 0000:00:1c.1: PCI bridge=
 to [bus 03]
Feb 20 19:21:10 vinco kernel: [    0.365860] pci 0000:00:1c.1:   bridge w=
indow [io  0x2000-0x2fff]
Feb 20 19:21:10 vinco kernel: [    0.365864] pci 0000:00:1c.1:   bridge w=
indow [mem 0xcfe00000-0xcfffffff]
Feb 20 19:21:10 vinco kernel: [    0.365866] pci 0000:00:1c.1:   bridge w=
indow [mem 0xf2000000-0xf21fffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.365871] pci 0000:00:1c.2: PCI bridge=
 to [bus 04]
Feb 20 19:21:10 vinco kernel: [    0.365875] pci 0000:00:1c.2:   bridge w=
indow [mem 0xf7900000-0xf79fffff]
Feb 20 19:21:10 vinco kernel: [    0.365881] pci 0000:00:1c.3: PCI bridge=
 to [bus 05]
Feb 20 19:21:10 vinco kernel: [    0.365883] pci 0000:00:1c.3:   bridge w=
indow [io  0xd000-0xdfff]
Feb 20 19:21:10 vinco kernel: [    0.365886] pci 0000:00:1c.3:   bridge w=
indow [mem 0xf7800000-0xf78fffff]
Feb 20 19:21:10 vinco kernel: [    0.365893] pci_bus 0000:00: resource 4 =
[io  0x0000-0x0cf7 window]
Feb 20 19:21:10 vinco kernel: [    0.365894] pci_bus 0000:00: resource 5 =
[io  0x0d00-0xffff window]
Feb 20 19:21:10 vinco kernel: [    0.365894] pci_bus 0000:00: resource 6 =
[mem 0x000a0000-0x000bffff window]
Feb 20 19:21:10 vinco kernel: [    0.365895] pci_bus 0000:00: resource 7 =
[mem 0x000d0000-0x000d3fff window]
Feb 20 19:21:10 vinco kernel: [    0.365896] pci_bus 0000:00: resource 8 =
[mem 0x000d4000-0x000d7fff window]
Feb 20 19:21:10 vinco kernel: [    0.365896] pci_bus 0000:00: resource 9 =
[mem 0x000d8000-0x000dbfff window]
Feb 20 19:21:10 vinco kernel: [    0.365897] pci_bus 0000:00: resource 10=
 [mem 0x000dc000-0x000dffff window]
Feb 20 19:21:10 vinco kernel: [    0.365898] pci_bus 0000:00: resource 11=
 [mem 0xcfe00000-0xfeafffff window]
Feb 20 19:21:10 vinco kernel: [    0.365899] pci_bus 0000:01: resource 0 =
[io  0xe000-0xefff]
Feb 20 19:21:10 vinco kernel: [    0.365899] pci_bus 0000:01: resource 1 =
[mem 0xf6000000-0xf70fffff]
Feb 20 19:21:10 vinco kernel: [    0.365900] pci_bus 0000:01: resource 2 =
[mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.365901] pci_bus 0000:03: resource 0 =
[io  0x2000-0x2fff]
Feb 20 19:21:10 vinco kernel: [    0.365902] pci_bus 0000:03: resource 1 =
[mem 0xcfe00000-0xcfffffff]
Feb 20 19:21:10 vinco kernel: [    0.365902] pci_bus 0000:03: resource 2 =
[mem 0xf2000000-0xf21fffff 64bit pref]
Feb 20 19:21:10 vinco kernel: [    0.365903] pci_bus 0000:04: resource 1 =
[mem 0xf7900000-0xf79fffff]
Feb 20 19:21:10 vinco kernel: [    0.365904] pci_bus 0000:05: resource 0 =
[io  0xd000-0xdfff]
Feb 20 19:21:10 vinco kernel: [    0.365904] pci_bus 0000:05: resource 1 =
[mem 0xf7800000-0xf78fffff]
Feb 20 19:21:10 vinco kernel: [    0.365985] NET: Registered protocol fam=
ily 2
Feb 20 19:21:10 vinco kernel: [    0.366070] tcp_listen_portaddr_hash has=
h table entries: 8192 (order: 5, 131072 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.366087] TCP established hash table e=
ntries: 131072 (order: 8, 1048576 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.366188] TCP bind hash table entries:=
 65536 (order: 8, 1048576 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.366284] TCP: Hash tables configured =
(established 131072 bind 65536)
Feb 20 19:21:10 vinco kernel: [    0.366303] UDP hash table entries: 8192=
 (order: 6, 262144 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.366329] UDP-Lite hash table entries:=
 8192 (order: 6, 262144 bytes, linear)
Feb 20 19:21:10 vinco kernel: [    0.366381] NET: Registered protocol fam=
ily 1
Feb 20 19:21:10 vinco kernel: [    0.366384] NET: Registered protocol fam=
ily 44
Feb 20 19:21:10 vinco kernel: [    0.366391] pci 0000:00:02.0: Video devi=
ce with shadowed ROM at [mem 0x000c0000-0x000dffff]
Feb 20 19:21:10 vinco kernel: [    0.366766] PCI: CLS 64 bytes, default 6=
4
Feb 20 19:21:10 vinco kernel: [    0.366790] Trying to unpack rootfs imag=
e as initramfs...
Feb 20 19:21:10 vinco kernel: [    0.979201] Freeing initrd memory: 58068=
K
Feb 20 19:21:10 vinco kernel: [    0.979239] DMAR: No ATSR found
Feb 20 19:21:10 vinco kernel: [    0.979294] DMAR: dmar0: Using Queued in=
validation
Feb 20 19:21:10 vinco kernel: [    0.979298] DMAR: dmar1: Using Queued in=
validation
Feb 20 19:21:10 vinco kernel: [    1.052071] pci 0000:00:00.0: Adding to =
iommu group 0
Feb 20 19:21:10 vinco kernel: [    1.052119] pci 0000:00:01.0: Adding to =
iommu group 1
Feb 20 19:21:10 vinco kernel: [    1.056706] pci 0000:00:02.0: Adding to =
iommu group 2
Feb 20 19:21:10 vinco kernel: [    1.056753] pci 0000:00:02.0: Using iomm=
u direct mapping
Feb 20 19:21:10 vinco kernel: [    1.056784] pci 0000:00:03.0: Adding to =
iommu group 3
Feb 20 19:21:10 vinco kernel: [    1.056840] pci 0000:00:14.0: Adding to =
iommu group 4
Feb 20 19:21:10 vinco kernel: [    1.056885] pci 0000:00:16.0: Adding to =
iommu group 5
Feb 20 19:21:10 vinco kernel: [    1.056940] pci 0000:00:1a.0: Adding to =
iommu group 6
Feb 20 19:21:10 vinco kernel: [    1.056984] pci 0000:00:1b.0: Adding to =
iommu group 7
Feb 20 19:21:10 vinco kernel: [    1.057024] pci 0000:00:1c.0: Adding to =
iommu group 8
Feb 20 19:21:10 vinco kernel: [    1.057068] pci 0000:00:1c.1: Adding to =
iommu group 9
Feb 20 19:21:10 vinco kernel: [    1.057112] pci 0000:00:1c.2: Adding to =
iommu group 10
Feb 20 19:21:10 vinco kernel: [    1.057150] pci 0000:00:1c.3: Adding to =
iommu group 11
Feb 20 19:21:10 vinco kernel: [    1.057208] pci 0000:00:1d.0: Adding to =
iommu group 12
Feb 20 19:21:10 vinco kernel: [    1.058361] pci 0000:00:1f.0: Adding to =
iommu group 13
Feb 20 19:21:10 vinco kernel: [    1.058370] pci 0000:00:1f.2: Adding to =
iommu group 13
Feb 20 19:21:10 vinco kernel: [    1.058378] pci 0000:00:1f.3: Adding to =
iommu group 13
Feb 20 19:21:10 vinco kernel: [    1.058386] pci 0000:01:00.0: Adding to =
iommu group 1
Feb 20 19:21:10 vinco kernel: [    1.058431] pci 0000:04:00.0: Adding to =
iommu group 14
Feb 20 19:21:10 vinco kernel: [    1.058491] pci 0000:05:00.0: Adding to =
iommu group 15
Feb 20 19:21:10 vinco kernel: [    1.058511] pci 0000:05:00.1: Adding to =
iommu group 15
Feb 20 19:21:10 vinco kernel: [    1.058548] DMAR: Intel(R) Virtualizatio=
n Technology for Directed I/O
Feb 20 19:21:10 vinco kernel: [    1.060054] Initialise system trusted ke=
yrings
Feb 20 19:21:10 vinco kernel: [    1.060061] Key type blacklist registere=
d
Feb 20 19:21:10 vinco kernel: [    1.060080] workingset: timestamp_bits=3D=
40 max_order=3D22 bucket_order=3D0
Feb 20 19:21:10 vinco kernel: [    1.060917] zbud: loaded
Feb 20 19:21:10 vinco kernel: [    1.061086] Platform Keyring initialized=

Feb 20 19:21:10 vinco kernel: [    1.061087] Key type asymmetric register=
ed
Feb 20 19:21:10 vinco kernel: [    1.061088] Asymmetric key parser 'x509'=
 registered
Feb 20 19:21:10 vinco kernel: [    1.061092] Block layer SCSI generic (bs=
g) driver version 0.4 loaded (major 250)
Feb 20 19:21:10 vinco kernel: [    1.061117] io scheduler mq-deadline reg=
istered
Feb 20 19:21:10 vinco kernel: [    1.061340] pcieport 0000:00:01.0: PME: =
Signaling with IRQ 26
Feb 20 19:21:10 vinco kernel: [    1.061460] pcieport 0000:00:1c.0: PME: =
Signaling with IRQ 27
Feb 20 19:21:10 vinco kernel: [    1.061597] pcieport 0000:00:1c.1: PME: =
Signaling with IRQ 28
Feb 20 19:21:10 vinco kernel: [    1.061614] pcieport 0000:00:1c.1: pcieh=
p: Slot #1 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Int=
erlock- NoCompl+ LLActRep+
Feb 20 19:21:10 vinco kernel: [    1.061770] pcieport 0000:00:1c.2: PME: =
Signaling with IRQ 29
Feb 20 19:21:10 vinco kernel: [    1.061896] pcieport 0000:00:1c.3: PME: =
Signaling with IRQ 30
Feb 20 19:21:10 vinco kernel: [    1.061946] shpchp: Standard Hot Plug PC=
I Controller Driver version: 0.4
Feb 20 19:21:10 vinco kernel: [    1.061956] efifb: probing for efifb
Feb 20 19:21:10 vinco kernel: [    1.061970] efifb: framebuffer at 0xd000=
0000, using 3072k, total 3072k
Feb 20 19:21:10 vinco kernel: [    1.061971] efifb: mode is 1024x768x32, =
linelength=3D4096, pages=3D1
Feb 20 19:21:10 vinco kernel: [    1.061971] efifb: scrolling: redraw
Feb 20 19:21:10 vinco kernel: [    1.061972] efifb: Truecolor: size=3D8:8=
:8:8, shift=3D24:16:8:0
Feb 20 19:21:10 vinco kernel: [    1.062030] Console: switching to colour=
 frame buffer device 128x48
Feb 20 19:21:10 vinco kernel: [    1.063307] fb0: EFI VGA frame buffer de=
vice
Feb 20 19:21:10 vinco kernel: [    1.063313] intel_idle: MWAIT substates:=
 0x42120
Feb 20 19:21:10 vinco kernel: [    1.063313] intel_idle: v0.4.1 model 0x3=
C
Feb 20 19:21:10 vinco kernel: [    1.063529] intel_idle: lapic_timer_reli=
able_states 0xffffffff
Feb 20 19:21:10 vinco kernel: [    1.064261] thermal LNXTHERM:00: registe=
red as thermal_zone0
Feb 20 19:21:10 vinco kernel: [    1.064261] ACPI: Thermal Zone [THRM] (5=
6 C)
Feb 20 19:21:10 vinco kernel: [    1.064336] Serial: 8250/16550 driver, 4=
 ports, IRQ sharing enabled
Feb 20 19:21:10 vinco kernel: [    1.064651] Linux agpgart interface v0.1=
03
Feb 20 19:21:10 vinco kernel: [    1.064684] AMD-Vi: AMD IOMMUv2 driver b=
y Joerg Roedel <jroedel@suse.de>
Feb 20 19:21:10 vinco kernel: [    1.064684] AMD-Vi: AMD IOMMUv2 function=
ality not available on this system
Feb 20 19:21:10 vinco kernel: [    1.065133] i8042: PNP: PS/2 Controller =
[PNP030b:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Feb 20 19:21:10 vinco kernel: [    1.067834] i8042: Detected active multi=
plexing controller, rev 1.1
Feb 20 19:21:10 vinco kernel: [    1.070393] serio: i8042 KBD port at 0x6=
0,0x64 irq 1
Feb 20 19:21:10 vinco kernel: [    1.070395] serio: i8042 AUX0 port at 0x=
60,0x64 irq 12
Feb 20 19:21:10 vinco kernel: [    1.070410] serio: i8042 AUX1 port at 0x=
60,0x64 irq 12
Feb 20 19:21:10 vinco kernel: [    1.070421] serio: i8042 AUX2 port at 0x=
60,0x64 irq 12
Feb 20 19:21:10 vinco kernel: [    1.070431] serio: i8042 AUX3 port at 0x=
60,0x64 irq 12
Feb 20 19:21:10 vinco kernel: [    1.070485] mousedev: PS/2 mouse device =
common for all mice
Feb 20 19:21:10 vinco kernel: [    1.070514] rtc_cmos 00:02: RTC can wake=
 from S4
Feb 20 19:21:10 vinco kernel: [    1.070650] rtc_cmos 00:02: registered a=
s rtc0
Feb 20 19:21:10 vinco kernel: [    1.070660] rtc_cmos 00:02: alarms up to=
 one month, y3k, 242 bytes nvram, hpet irqs
Feb 20 19:21:10 vinco kernel: [    1.070667] intel_pstate: Intel P-state =
driver initializing
Feb 20 19:21:10 vinco kernel: [    1.071326] ledtrig-cpu: registered to i=
ndicate activity on CPUs
Feb 20 19:21:10 vinco kernel: [    1.071638] drop_monitor: Initializing n=
etwork drop monitor service
Feb 20 19:21:10 vinco kernel: [    1.072046] NET: Registered protocol fam=
ily 10
Feb 20 19:21:10 vinco kernel: [    1.091568] Segment Routing with IPv6
Feb 20 19:21:10 vinco kernel: [    1.091590] mip6: Mobile IPv6
Feb 20 19:21:10 vinco kernel: [    1.091592] NET: Registered protocol fam=
ily 17
Feb 20 19:21:10 vinco kernel: [    1.091741] mpls_gso: MPLS GSO support
Feb 20 19:21:10 vinco kernel: [    1.092258] microcode: sig=3D0x306c3, pf=
=3D0x20, revision=3D0x27
Feb 20 19:21:10 vinco kernel: [    1.092352] microcode: Microcode Update =
Driver: v2.2.
Feb 20 19:21:10 vinco kernel: [    1.092356] IPI shorthand broadcast: ena=
bled
Feb 20 19:21:10 vinco kernel: [    1.092363] sched_clock: Marking stable =
(1092004421, 195325)->(1098656859, -6457113)
Feb 20 19:21:10 vinco kernel: [    1.092471] registered taskstats version=
 1
Feb 20 19:21:10 vinco kernel: [    1.092471] Loading compiled-in X.509 ce=
rtificates
Feb 20 19:21:10 vinco kernel: [    1.110685] input: AT Translated Set 2 k=
eyboard as /devices/platform/i8042/serio0/input/input0
Feb 20 19:21:10 vinco kernel: [    1.125584] Loaded X.509 cert 'Debian Se=
cure Boot CA: 6ccece7e4c6c0d1f6149f3dd27dfcc5cbb419ea1'
Feb 20 19:21:10 vinco kernel: [    1.125596] Loaded X.509 cert 'Debian Se=
cure Boot Signer: 00a7468def'
Feb 20 19:21:10 vinco kernel: [    1.125611] zswap: loaded using pool lzo=
/zbud
Feb 20 19:21:10 vinco kernel: [    1.125777] Key type ._fscrypt registere=
d
Feb 20 19:21:10 vinco kernel: [    1.125778] Key type .fscrypt registered=

Feb 20 19:21:10 vinco kernel: [    1.125787] AppArmor: AppArmor sha1 poli=
cy hashing enabled
Feb 20 19:21:10 vinco kernel: [    1.125986] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 20 19:21:10 vinco kernel: [    1.126181] integrity: Loaded X.509 cert=
 'ASUSTeK Notebook SW Key Certificate: b8e581e4df77a5bb4282d5ccfc00c071'
Feb 20 19:21:10 vinco kernel: [    1.126181] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 20 19:21:10 vinco kernel: [    1.126372] integrity: Loaded X.509 cert=
 'ASUSTeK MotherBoard SW Key Certificate: da83b990422ebc8c441f8d8b039a65a=
2'
Feb 20 19:21:10 vinco kernel: [    1.126372] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 20 19:21:10 vinco kernel: [    1.126389] integrity: Loaded X.509 cert=
 'Microsoft Corporation UEFI CA 2011: 13adbf4309bd82709c8cd54f316ed522988=
a1bd4'
Feb 20 19:21:10 vinco kernel: [    1.126390] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 20 19:21:10 vinco kernel: [    1.126404] integrity: Loaded X.509 cert=
 'Microsoft Windows Production PCA 2011: a92902398e16c49778cd90f99e4f9ae1=
7c55af53'
Feb 20 19:21:10 vinco kernel: [    1.126404] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 20 19:21:10 vinco kernel: [    1.126595] integrity: Loaded X.509 cert=
 'Canonical Ltd. Master Certificate Authority: ad91990bc22ab1f517048c23b6=
655a268e345a63'
Feb 20 19:21:10 vinco kernel: [    1.127213] rtc_cmos 00:02: setting syst=
em clock to 2020-02-20T17:21:06 UTC (1582219266)
Feb 20 19:21:10 vinco kernel: [    1.127872] Freeing unused kernel image =
memory: 1672K
Feb 20 19:21:10 vinco kernel: [    1.164311] Write protecting the kernel =
read-only data: 16384k
Feb 20 19:21:10 vinco kernel: [    1.165125] Freeing unused kernel image =
memory: 2036K
Feb 20 19:21:10 vinco kernel: [    1.165290] Freeing unused kernel image =
memory: 360K
Feb 20 19:21:10 vinco kernel: [    1.180057] x86/mm: Checked W+X mappings=
: passed, no W+X pages found.
Feb 20 19:21:10 vinco kernel: [    1.180058] x86/mm: Checking user space =
page tables
Feb 20 19:21:10 vinco kernel: [    1.186177] x86/mm: Checked W+X mappings=
: passed, no W+X pages found.
Feb 20 19:21:10 vinco kernel: [    1.186178] Run /init as init process
Feb 20 19:21:10 vinco kernel: [    1.238391] input: Lid Switch as /device=
s/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input4
Feb 20 19:21:10 vinco kernel: [    1.238416] ACPI: Lid Switch [LID]
Feb 20 19:21:10 vinco kernel: [    1.238470] input: Sleep Button as /devi=
ces/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input5
Feb 20 19:21:10 vinco kernel: [    1.238508] ACPI: Sleep Button [SLPB]
Feb 20 19:21:10 vinco kernel: [    1.238551] input: Power Button as /devi=
ces/LNXSYSTM:00/LNXPWRBN:00/input/input6
Feb 20 19:21:10 vinco kernel: [    1.238584] ACPI: Power Button [PWRF]
Feb 20 19:21:10 vinco kernel: [    1.246740] r8168: loading out-of-tree m=
odule taints kernel.
Feb 20 19:21:10 vinco kernel: [    1.246848] r8168: module verification f=
ailed: signature and/or required key missing - tainting kernel
Feb 20 19:21:10 vinco kernel: [    1.248057] r8168 Gigabit Ethernet drive=
r 8.048.00-NAPI loaded
Feb 20 19:21:10 vinco kernel: [    1.248922] i801_smbus 0000:00:1f.3: SPD=
 Write Disable is set
Feb 20 19:21:10 vinco kernel: [    1.248961] i801_smbus 0000:00:1f.3: SMB=
us using PCI interrupt
Feb 20 19:21:10 vinco kernel: [    1.251446] ACPI Warning: SystemIO range=
 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x00000000=
00001800-0x000000000000184F (\GPIS) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251450] ACPI Warning: SystemIO range=
 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x00000000=
00001800-0x000000000000187F (\PMIO) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251454] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 20 19:21:10 vinco kernel: [    1.251457] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 20 19:21:10 vinco kernel: [    1.251460] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251463] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251466] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 20 19:21:10 vinco kernel: [    1.251467] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 20 19:21:10 vinco kernel: [    1.251469] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251472] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251475] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C3F (\GPRL) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251478] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 20 19:21:10 vinco kernel: [    1.251478] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 20 19:21:10 vinco kernel: [    1.251481] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251484] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251486] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C3F (\GPRL) (20190816/utaddress-204)
Feb 20 19:21:10 vinco kernel: [    1.251489] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 20 19:21:10 vinco kernel: [    1.251490] lpc_ich: Resource conflict(s=
) found affecting gpio_ich
Feb 20 19:21:10 vinco kernel: [    1.259793] ACPI: bus type USB registere=
d
Feb 20 19:21:10 vinco kernel: [    1.259810] usbcore: registered new inte=
rface driver usbfs
Feb 20 19:21:10 vinco kernel: [    1.259817] usbcore: registered new inte=
rface driver hub
Feb 20 19:21:10 vinco kernel: [    1.259849] usbcore: registered new devi=
ce driver usb
Feb 20 19:21:10 vinco kernel: [    1.261897] r8168: This product is cover=
ed by one or more of the following patents: US6,570,884, US6,115,776, and=
 US6,327,625.
Feb 20 19:21:10 vinco kernel: [    1.262929] SCSI subsystem initialized
Feb 20 19:21:10 vinco kernel: [    1.263911] r8168  Copyright (C) 2019  R=
ealtek NIC software team <nicfae@realtek.com>=20
Feb 20 19:21:10 vinco kernel: [    1.263911]  This program comes with ABS=
OLUTELY NO WARRANTY; for details, please see <http://www.gnu.org/licenses=
/>.=20
Feb 20 19:21:10 vinco kernel: [    1.263911]  This is free software, and =
you are welcome to redistribute it under certain conditions; see <http://=
www.gnu.org/licenses/>.=20
Feb 20 19:21:10 vinco kernel: [    1.264350] ehci_hcd: USB 2.0 'Enhanced'=
 Host Controller (EHCI) Driver
Feb 20 19:21:10 vinco kernel: [    1.265216] ehci-pci: EHCI PCI platform =
driver
Feb 20 19:21:10 vinco kernel: [    1.266411] ehci-pci 0000:00:1a.0: EHCI =
Host Controller
Feb 20 19:21:10 vinco kernel: [    1.266416] ehci-pci 0000:00:1a.0: new U=
SB bus registered, assigned bus number 1
Feb 20 19:21:10 vinco kernel: [    1.266428] ehci-pci 0000:00:1a.0: debug=
 port 2
Feb 20 19:21:10 vinco kernel: [    1.270348] ehci-pci 0000:00:1a.0: cache=
 line size of 64 is not supported
Feb 20 19:21:10 vinco kernel: [    1.270381] ehci-pci 0000:00:1a.0: irq 1=
6, io mem 0xf7a1c000
Feb 20 19:21:10 vinco kernel: [    1.276745] libata version 3.00 loaded.
Feb 20 19:21:10 vinco kernel: [    1.280523] r8168 0000:05:00.1 enp5s0f1:=
 renamed from eth0
Feb 20 19:21:10 vinco kernel: [    1.282086] ahci 0000:00:1f.2: version 3=
=2E0
Feb 20 19:21:10 vinco kernel: [    1.282252] ahci 0000:00:1f.2: AHCI 0001=
=2E0300 32 slots 4 ports 6 Gbps 0x14 impl SATA mode
Feb 20 19:21:10 vinco kernel: [    1.282255] ahci 0000:00:1f.2: flags: 64=
bit ncq pm led clo pio slum part ems apst=20
Feb 20 19:21:10 vinco kernel: [    1.284210] ehci-pci 0000:00:1a.0: USB 2=
=2E0 started, EHCI 1.00
Feb 20 19:21:10 vinco kernel: [    1.284264] usb usb1: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 20 19:21:10 vinco kernel: [    1.284265] usb usb1: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
=46eb 20 19:21:10 vinco kernel: [    1.284266] usb usb1: Product: EHCI Ho=
st Controller
Feb 20 19:21:10 vinco kernel: [    1.284267] usb usb1: Manufacturer: Linu=
x 5.4.0-4-amd64 ehci_hcd
Feb 20 19:21:10 vinco kernel: [    1.284267] usb usb1: SerialNumber: 0000=
:00:1a.0
Feb 20 19:21:10 vinco kernel: [    1.284356] hub 1-0:1.0: USB hub found
Feb 20 19:21:10 vinco kernel: [    1.284364] hub 1-0:1.0: 2 ports detecte=
d
Feb 20 19:21:10 vinco kernel: [    1.284464] xhci_hcd 0000:00:14.0: xHCI =
Host Controller
Feb 20 19:21:10 vinco kernel: [    1.284468] xhci_hcd 0000:00:14.0: new U=
SB bus registered, assigned bus number 2
Feb 20 19:21:10 vinco kernel: [    1.285544] xhci_hcd 0000:00:14.0: hcc p=
arams 0x200077c1 hci version 0x100 quirks 0x0000000000009810
Feb 20 19:21:10 vinco kernel: [    1.285550] xhci_hcd 0000:00:14.0: cache=
 line size of 64 is not supported
Feb 20 19:21:10 vinco kernel: [    1.285699] usb usb2: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 20 19:21:10 vinco kernel: [    1.285700] usb usb2: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 20 19:21:10 vinco kernel: [    1.285700] usb usb2: Product: xHCI Host=
 Controller
Feb 20 19:21:10 vinco kernel: [    1.285701] usb usb2: Manufacturer: Linu=
x 5.4.0-4-amd64 xhci-hcd
Feb 20 19:21:10 vinco kernel: [    1.285702] usb usb2: SerialNumber: 0000=
:00:14.0
Feb 20 19:21:10 vinco kernel: [    1.285800] hub 2-0:1.0: USB hub found
Feb 20 19:21:10 vinco kernel: [    1.285816] hub 2-0:1.0: 14 ports detect=
ed
Feb 20 19:21:10 vinco kernel: [    1.288300] ehci-pci 0000:00:1d.0: EHCI =
Host Controller
Feb 20 19:21:10 vinco kernel: [    1.288305] ehci-pci 0000:00:1d.0: new U=
SB bus registered, assigned bus number 3
Feb 20 19:21:10 vinco kernel: [    1.288316] ehci-pci 0000:00:1d.0: debug=
 port 2
Feb 20 19:21:10 vinco kernel: [    1.288317] xhci_hcd 0000:00:14.0: xHCI =
Host Controller
Feb 20 19:21:10 vinco kernel: [    1.288320] xhci_hcd 0000:00:14.0: new U=
SB bus registered, assigned bus number 4
Feb 20 19:21:10 vinco kernel: [    1.288322] xhci_hcd 0000:00:14.0: Host =
supports USB 3.0 SuperSpeed
Feb 20 19:21:10 vinco kernel: [    1.288350] usb usb4: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0003, bcdDevice=3D 5.04
Feb 20 19:21:10 vinco kernel: [    1.288350] usb usb4: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 20 19:21:10 vinco kernel: [    1.288351] usb usb4: Product: xHCI Host=
 Controller
Feb 20 19:21:10 vinco kernel: [    1.288352] usb usb4: Manufacturer: Linu=
x 5.4.0-4-amd64 xhci-hcd
Feb 20 19:21:10 vinco kernel: [    1.288352] usb usb4: SerialNumber: 0000=
:00:14.0
Feb 20 19:21:10 vinco kernel: [    1.288424] hub 4-0:1.0: USB hub found
Feb 20 19:21:10 vinco kernel: [    1.288436] hub 4-0:1.0: 4 ports detecte=
d
Feb 20 19:21:10 vinco kernel: [    1.292233] ehci-pci 0000:00:1d.0: cache=
 line size of 64 is not supported
Feb 20 19:21:10 vinco kernel: [    1.292245] ehci-pci 0000:00:1d.0: irq 2=
3, io mem 0xf7a1b000
Feb 20 19:21:10 vinco kernel: [    1.292663] scsi host0: ahci
Feb 20 19:21:10 vinco kernel: [    1.292802] scsi host1: ahci
Feb 20 19:21:10 vinco kernel: [    1.292892] scsi host2: ahci
Feb 20 19:21:10 vinco kernel: [    1.292965] scsi host3: ahci
Feb 20 19:21:10 vinco kernel: [    1.293019] scsi host4: ahci
Feb 20 19:21:10 vinco kernel: [    1.293044] ata1: DUMMY
Feb 20 19:21:10 vinco kernel: [    1.293045] ata2: DUMMY
Feb 20 19:21:10 vinco kernel: [    1.293047] ata3: SATA max UDMA/133 abar=
 m2048@0xf7a1a000 port 0xf7a1a200 irq 33
Feb 20 19:21:10 vinco kernel: [    1.293047] ata4: DUMMY
Feb 20 19:21:10 vinco kernel: [    1.293049] ata5: SATA max UDMA/133 abar=
 m2048@0xf7a1a000 port 0xf7a1a300 irq 33
Feb 20 19:21:10 vinco kernel: [    1.308231] ehci-pci 0000:00:1d.0: USB 2=
=2E0 started, EHCI 1.00
Feb 20 19:21:10 vinco kernel: [    1.308494] usb usb3: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 20 19:21:10 vinco kernel: [    1.308496] usb usb3: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 20 19:21:10 vinco kernel: [    1.308496] usb usb3: Product: EHCI Host=
 Controller
Feb 20 19:21:10 vinco kernel: [    1.308497] usb usb3: Manufacturer: Linu=
x 5.4.0-4-amd64 ehci_hcd
Feb 20 19:21:10 vinco kernel: [    1.308498] usb usb3: SerialNumber: 0000=
:00:1d.0
Feb 20 19:21:10 vinco kernel: [    1.308668] hub 3-0:1.0: USB hub found
Feb 20 19:21:10 vinco kernel: [    1.308692] hub 3-0:1.0: 2 ports detecte=
d
Feb 20 19:21:10 vinco kernel: [    1.342843] i915 0000:00:02.0: VT-d acti=
ve for gfx access
Feb 20 19:21:10 vinco kernel: [    1.342845] checking generic (d0000000 3=
00000) vs hw (d0000000 10000000)
Feb 20 19:21:10 vinco kernel: [    1.342846] fb0: switching to inteldrmfb=
 from EFI VGA
Feb 20 19:21:10 vinco kernel: [    1.342895] Console: switching to colour=
 dummy device 80x25
Feb 20 19:21:10 vinco kernel: [    1.342920] i915 0000:00:02.0: vgaarb: d=
eactivate vga console
Feb 20 19:21:10 vinco kernel: [    1.343131] i915 0000:00:02.0: DMAR acti=
ve, disabling use of stolen memory
Feb 20 19:21:10 vinco kernel: [    1.343529] [drm] Supports vblank timest=
amp caching Rev 2 (21.10.2013).
Feb 20 19:21:10 vinco kernel: [    1.343530] [drm] Driver supports precis=
e vblank timestamp query.
Feb 20 19:21:10 vinco kernel: [    1.343724] i915 0000:00:02.0: vgaarb: c=
hanged VGA decodes: olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
Feb 20 19:21:10 vinco kernel: [    1.357918] [drm] Initialized i915 1.6.0=
 20190822 for 0000:00:02.0 on minor 0
Feb 20 19:21:10 vinco kernel: [    1.358658] [Firmware Bug]: ACPI(PEGP) d=
efines _DOD but not _DOS
Feb 20 19:21:10 vinco kernel: [    1.360077] ACPI: Video Device [PEGP] (m=
ulti-head: yes  rom: yes  post: no)
Feb 20 19:21:10 vinco kernel: [    1.362768] input: Video Bus as /devices=
/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4f/LNXVIDEO:00/input/input9
Feb 20 19:21:10 vinco kernel: [    1.364078] ACPI: Video Device [GFX0] (m=
ulti-head: yes  rom: no  post: no)
Feb 20 19:21:10 vinco kernel: [    1.366659] input: Video Bus as /devices=
/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input10
Feb 20 19:21:10 vinco kernel: [    1.376113] fbcon: i915drmfb (fb0) is pr=
imary device
Feb 20 19:21:10 vinco kernel: [    1.457552] battery: ACPI: Battery Slot =
[BAT0] (battery present)
Feb 20 19:21:10 vinco kernel: [    1.607393] ata3: SATA link up 1.5 Gbps =
(SStatus 113 SControl 300)
Feb 20 19:21:10 vinco kernel: [    1.607416] ata5: SATA link up 6.0 Gbps =
(SStatus 133 SControl 300)
Feb 20 19:21:10 vinco kernel: [    1.608258] ata5.00: ACPI cmd ef/10:06:0=
0:00:00:00 (SET FEATURES) succeeded
Feb 20 19:21:10 vinco kernel: [    1.608261] ata5.00: ACPI cmd f5/00:00:0=
0:00:00:00 (SECURITY FREEZE LOCK) filtered out
Feb 20 19:21:10 vinco kernel: [    1.608263] ata5.00: ACPI cmd b1/c1:00:0=
0:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Feb 20 19:21:10 vinco kernel: [    1.608640] ata5.00: supports DRM functi=
ons and may not be fully accessible
Feb 20 19:21:10 vinco kernel: [    1.609722] ata5.00: disabling queued TR=
IM support
Feb 20 19:21:10 vinco kernel: [    1.609725] ata5.00: ATA-9: Samsung SSD =
850 EVO 1TB, EMT02B6Q, max UDMA/133
Feb 20 19:21:10 vinco kernel: [    1.609727] ata5.00: 1953525168 sectors,=
 multi 1: LBA48 NCQ (depth 32), AA
Feb 20 19:21:10 vinco kernel: [    1.610867] ata3.00: ATAPI: TSSTcorp CDD=
VDW SU-228FB, AS00, max UDMA/100
Feb 20 19:21:10 vinco kernel: [    1.612519] ata5.00: ACPI cmd ef/10:06:0=
0:00:00:00 (SET FEATURES) succeeded
Feb 20 19:21:10 vinco kernel: [    1.612522] ata5.00: ACPI cmd f5/00:00:0=
0:00:00:00 (SECURITY FREEZE LOCK) filtered out
Feb 20 19:21:10 vinco kernel: [    1.612524] ata5.00: ACPI cmd b1/c1:00:0=
0:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Feb 20 19:21:10 vinco kernel: [    1.612893] ata5.00: supports DRM functi=
ons and may not be fully accessible
Feb 20 19:21:10 vinco kernel: [    1.613736] ata5.00: disabling queued TR=
IM support
Feb 20 19:21:10 vinco kernel: [    1.615562] ata5.00: configured for UDMA=
/133
Feb 20 19:21:10 vinco kernel: [    1.616037] ata3.00: configured for UDMA=
/100
Feb 20 19:21:10 vinco kernel: [    1.620284] usb 1-1: new high-speed USB =
device number 2 using ehci-pci
Feb 20 19:21:10 vinco kernel: [    1.624287] usb 2-3: new full-speed USB =
device number 2 using xhci_hcd
=46eb 20 19:21:10 vinco kernel: [    1.625260] scsi 2:0:0:0: CD-ROM      =
      TSSTcorp CDDVDW SU-228FB  AS00 PQ: 0 ANSI: 5
Feb 20 19:21:10 vinco kernel: [    1.648286] usb 3-1: new high-speed USB =
device number 2 using ehci-pci
Feb 20 19:21:10 vinco kernel: [    1.649297] usb 1-1: New USB device foun=
d, idVendor=3D8087, idProduct=3D8008, bcdDevice=3D 0.05
Feb 20 19:21:10 vinco kernel: [    1.649299] usb 1-1: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 20 19:21:10 vinco kernel: [    1.649762] hub 1-1:1.0: USB hub found
Feb 20 19:21:10 vinco kernel: [    1.649960] hub 1-1:1.0: 6 ports detecte=
d
Feb 20 19:21:10 vinco kernel: [    1.662212] scsi 4:0:0:0: Direct-Access =
    ATA      Samsung SSD 850  2B6Q PQ: 0 ANSI: 5
Feb 20 19:21:10 vinco kernel: [    1.677089] usb 3-1: New USB device foun=
d, idVendor=3D8087, idProduct=3D8000, bcdDevice=3D 0.05
Feb 20 19:21:10 vinco kernel: [    1.677092] usb 3-1: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 20 19:21:10 vinco kernel: [    1.677469] hub 3-1:1.0: USB hub found
Feb 20 19:21:10 vinco kernel: [    1.677539] hub 3-1:1.0: 8 ports detecte=
d
Feb 20 19:21:10 vinco kernel: [    1.775587] usb 2-3: New USB device foun=
d, idVendor=3D046d, idProduct=3Dc52b, bcdDevice=3D12.03
Feb 20 19:21:10 vinco kernel: [    1.775589] usb 2-3: New USB device stri=
ngs: Mfr=3D1, Product=3D2, SerialNumber=3D0
Feb 20 19:21:10 vinco kernel: [    1.775591] usb 2-3: Product: USB Receiv=
er
Feb 20 19:21:10 vinco kernel: [    1.775592] usb 2-3: Manufacturer: Logit=
ech
Feb 20 19:21:10 vinco kernel: [    1.787487] hidraw: raw HID events drive=
r (C) Jiri Kosina
Feb 20 19:21:10 vinco kernel: [    1.793376] usbcore: registered new inte=
rface driver usbhid
Feb 20 19:21:10 vinco kernel: [    1.793377] usbhid: USB HID core driver
Feb 20 19:21:10 vinco kernel: [    1.795277] input: Logitech USB Receiver=
 as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.0/0003:046D:C52B.0001=
/input/input14
Feb 20 19:21:10 vinco kernel: [    1.852505] hid-generic 0003:046D:C52B.0=
001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb=
-0000:00:14.0-3/input0
Feb 20 19:21:10 vinco kernel: [    1.852912] input: Logitech USB Receiver=
 Mouse as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/0003:046D:C52=
B.0002/input/input15
Feb 20 19:21:10 vinco kernel: [    1.853072] input: Logitech USB Receiver=
 Consumer Control as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/00=
03:046D:C52B.0002/input/input16
Feb 20 19:21:10 vinco kernel: [    1.904287] usb 2-5: new full-speed USB =
device number 3 using xhci_hcd
Feb 20 19:21:10 vinco kernel: [    1.912351] input: Logitech USB Receiver=
 System Control as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/0003=
:046D:C52B.0002/input/input17
Feb 20 19:21:10 vinco kernel: [    1.912537] hid-generic 0003:046D:C52B.0=
002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n usb-0000:00:14.0-3/input1
Feb 20 19:21:10 vinco kernel: [    1.912920] hid-generic 0003:046D:C52B.0=
003: hiddev1,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb=
-0000:00:14.0-3/input2
Feb 20 19:21:10 vinco kernel: [    2.033731] psmouse serio4: elantech: as=
suming hardware version 4 (with firmware version 0x381fa2)
Feb 20 19:21:10 vinco kernel: [    2.045309] logitech-djreceiver 0003:046=
D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver=
] on usb-0000:00:14.0-3/input2
Feb 20 19:21:10 vinco kernel: [    2.051268] psmouse serio4: elantech: Sy=
naptics capabilities query result 0x10, 0x14, 0x0e.
Feb 20 19:21:10 vinco kernel: [    2.053513] usb 2-5: New USB device foun=
d, idVendor=3D8087, idProduct=3D07dc, bcdDevice=3D 0.01
Feb 20 19:21:10 vinco kernel: [    2.053516] usb 2-5: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 20 19:21:10 vinco kernel: [    2.070469] psmouse serio4: elantech: El=
an sample query result 05, 1b, 64
Feb 20 19:21:10 vinco kernel: [    2.080303] tsc: Refined TSC clocksource=
 calibration: 2494.228 MHz
Feb 20 19:21:10 vinco kernel: [    2.080316] clocksource: tsc: mask: 0xff=
ffffffffffffff max_cycles: 0x23f3ed6cc7b, max_idle_ns: 440795302954 ns
Feb 20 19:21:10 vinco kernel: [    2.080357] clocksource: Switched to clo=
cksource tsc
Feb 20 19:21:10 vinco kernel: [    2.155270] input: ETPS/2 Elantech Touch=
pad as /devices/platform/i8042/serio4/input/input13
Feb 20 19:21:10 vinco kernel: [    2.167416] input: Logitech Unifying Dev=
ice. Wireless PID:101b Mouse as /devices/pci0000:00/0000:00:14.0/usb2/2-3=
/2-3:1.2/0003:046D:C52B.0003/0003:046D:101B.0004/input/input19
Feb 20 19:21:10 vinco kernel: [    2.168253] hid-generic 0003:046D:101B.0=
004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wirele=
ss PID:101b] on usb-0000:00:14.0-3/input2:1
Feb 20 19:21:10 vinco kernel: [    2.180251] usb 2-7: new high-speed USB =
device number 4 using xhci_hcd
Feb 20 19:21:10 vinco kernel: [    2.226413] input: Logitech M705 as /dev=
ices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/0003:046D:C52B.0003/0003:04=
6D:101B.0004/input/input23
Feb 20 19:21:10 vinco kernel: [    2.226634] logitech-hidpp-device 0003:0=
46D:101B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech M705] on usb-=
0000:00:14.0-3/input2:1
Feb 20 19:21:10 vinco kernel: [    2.301552] usb 2-7: New USB device foun=
d, idVendor=3D13d3, idProduct=3D5188, bcdDevice=3D 8.14
Feb 20 19:21:10 vinco kernel: [    2.301555] usb 2-7: New USB device stri=
ngs: Mfr=3D3, Product=3D1, SerialNumber=3D2
Feb 20 19:21:10 vinco kernel: [    2.301557] usb 2-7: Product: USB2.0 UVC=
 HD Webcam
Feb 20 19:21:10 vinco kernel: [    2.301559] usb 2-7: Manufacturer: Azure=
wave
Feb 20 19:21:10 vinco kernel: [    2.301561] usb 2-7: SerialNumber: NULL
Feb 20 19:21:10 vinco kernel: [    2.651337] Console: switching to colour=
 frame buffer device 240x67
Feb 20 19:21:10 vinco kernel: [    2.678780] i915 0000:00:02.0: fb0: i915=
drmfb frame buffer device
Feb 20 19:21:10 vinco kernel: [    2.701421] sd 4:0:0:0: [sda] 1953525168=
 512-byte logical blocks: (1.00 TB/932 GiB)
Feb 20 19:21:10 vinco kernel: [    2.701440] sd 4:0:0:0: [sda] Write Prot=
ect is off
Feb 20 19:21:10 vinco kernel: [    2.701443] sd 4:0:0:0: [sda] Mode Sense=
: 00 3a 00 00
Feb 20 19:21:10 vinco kernel: [    2.701470] sd 4:0:0:0: [sda] Write cach=
e: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 20 19:21:10 vinco kernel: [    2.719105]  sda: sda1 sda2 sda3 sda4 sd=
a6
Feb 20 19:21:10 vinco kernel: [    2.720366] sd 4:0:0:0: [sda] supports T=
CG Opal
Feb 20 19:21:10 vinco kernel: [    2.720369] sd 4:0:0:0: [sda] Attached S=
CSI disk
Feb 20 19:21:10 vinco kernel: [    2.754913] sr 2:0:0:0: [sr0] scsi3-mmc =
drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb 20 19:21:10 vinco kernel: [    2.754916] cdrom: Uniform CD-ROM driver=
 Revision: 3.20
Feb 20 19:21:10 vinco kernel: [    2.788759] sr 2:0:0:0: Attached scsi CD=
-ROM sr0
Feb 20 19:21:10 vinco kernel: [    3.156221] raid6: avx2x4   gen() 31323 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.224220] raid6: avx2x4   xor() 20496 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.292220] raid6: avx2x2   gen() 28575 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.360220] raid6: avx2x2   xor() 17658 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.428220] raid6: avx2x1   gen() 24388 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.496220] raid6: avx2x1   xor() 16209 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.564221] raid6: sse2x4   gen() 17600 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.632220] raid6: sse2x4   xor() 10875 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.700221] raid6: sse2x2   gen() 14764 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.768219] raid6: sse2x2   xor()  9633 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.836222] raid6: sse2x1   gen() 12411 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.904224] raid6: sse2x1   xor()  8422 =
MB/s
Feb 20 19:21:10 vinco kernel: [    3.904225] raid6: using algorithm avx2x=
4 gen() 31323 MB/s
Feb 20 19:21:10 vinco kernel: [    3.904225] raid6: .... xor() 20496 MB/s=
, rmw enabled
Feb 20 19:21:10 vinco kernel: [    3.904226] raid6: using avx2x2 recovery=
 algorithm
Feb 20 19:21:10 vinco kernel: [    3.909997] xor: automatically using bes=
t checksumming function   avx      =20
Feb 20 19:21:10 vinco kernel: [    3.951697] Btrfs loaded, crc32c=3Dcrc32=
c-intel
Feb 20 19:21:10 vinco kernel: [    4.116179] PM: Image not found (code -2=
2)
Feb 20 19:21:10 vinco kernel: [    4.199940] EXT4-fs (sda4): mounted file=
system with ordered data mode. Opts: (null)
Feb 20 19:21:10 vinco kernel: [    4.564921] EXT4-fs (sda4): re-mounted. =
Opts: errors=3Dremount-ro
Feb 20 19:21:10 vinco kernel: [    4.573903] lp: driver loaded but no dev=
ices found
Feb 20 19:21:10 vinco kernel: [    4.578084] ppdev: user-space parallel p=
ort driver
Feb 20 19:21:10 vinco kernel: [    4.710685] input: Asus Wireless Radio C=
ontrol as /devices/LNXSYSTM:00/LNXSYBUS:00/ATK4002:00/input/input24
Feb 20 19:21:10 vinco kernel: [    4.712168] ACPI: AC Adapter [AC0] (on-l=
ine)
Feb 20 19:21:10 vinco kernel: [    4.804457] EDAC ie31200: No ECC support=

Feb 20 19:21:10 vinco kernel: [    4.806118] EFI Variables Facility v0.08=
 2004-May-17
Feb 20 19:21:10 vinco kernel: [    4.806595] sr 2:0:0:0: Attached scsi ge=
neric sg0 type 5
Feb 20 19:21:10 vinco kernel: [    4.806687] sd 4:0:0:0: Attached scsi ge=
neric sg1 type 0
Feb 20 19:21:10 vinco kernel: [    4.807197] input: PC Speaker as /device=
s/platform/pcspkr/input/input25
Feb 20 19:21:10 vinco kernel: [    4.807861] iTCO_vendor_support: vendor-=
support=3D0
Feb 20 19:21:10 vinco kernel: [    4.810605] iTCO_wdt: Intel TCO WatchDog=
 Timer Driver v1.11
Feb 20 19:21:10 vinco kernel: [    4.810643] iTCO_wdt: Found a Lynx Point=
 TCO device (Version=3D2, TCOBASE=3D0x1860)
Feb 20 19:21:10 vinco kernel: [    4.812158] iTCO_wdt: initialized. heart=
beat=3D30 sec (nowayout=3D0)
Feb 20 19:21:10 vinco kernel: [    4.814992] asus_wmi: ASUS WMI generic d=
river loaded
Feb 20 19:21:10 vinco kernel: [    4.816361] asus_wmi: Initialization: 0x=
1
Feb 20 19:21:10 vinco kernel: [    4.816396] asus_wmi: BIOS WMI version: =
7.9
Feb 20 19:21:10 vinco kernel: [    4.816442] asus_wmi: SFUN value: 0x6a08=
77
Feb 20 19:21:10 vinco kernel: [    4.816444] asus-nb-wmi asus-nb-wmi: Det=
ected ATK, not ASUSWMI, use DSTS
Feb 20 19:21:10 vinco kernel: [    4.816446] asus-nb-wmi asus-nb-wmi: Det=
ected ATK, enable event queue
Feb 20 19:21:10 vinco kernel: [    4.817884] input: Asus WMI hotkeys as /=
devices/platform/asus-nb-wmi/input/input26
Feb 20 19:21:10 vinco kernel: [    4.828773] RAPL PMU: API unit is 2^-32 =
Joules, 4 fixed counters, 655360 ms ovfl timer
Feb 20 19:21:10 vinco kernel: [    4.828774] RAPL PMU: hw unit of domain =
pp0-core 2^-14 Joules
Feb 20 19:21:10 vinco kernel: [    4.828775] RAPL PMU: hw unit of domain =
package 2^-14 Joules
Feb 20 19:21:10 vinco kernel: [    4.828775] RAPL PMU: hw unit of domain =
dram 2^-14 Joules
Feb 20 19:21:10 vinco kernel: [    4.828776] RAPL PMU: hw unit of domain =
pp1-gpu 2^-14 Joules
Feb 20 19:21:10 vinco kernel: [    4.834469] pstore: Using crash dump com=
pression: deflate
Feb 20 19:21:10 vinco kernel: [    4.839856] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.839938] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840014] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840090] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840166] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840243] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840468] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840677] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840757] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840829] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840904] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.840981] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.841052] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.841125] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.841197] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.841275] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.841633] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.841781] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.842016] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.845879] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848046] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848172] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848395] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848515] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848592] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848670] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848747] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848824] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848896] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.848969] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.849049] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.849128] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.849633] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.849704] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.850886] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.850971] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851039] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851608] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851673] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851735] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851799] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851865] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.851926] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.852750] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.854821] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.854898] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.856146] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.856234] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.857483] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.857564] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.858219] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.858870] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.858948] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859583] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859668] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859742] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859800] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859853] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859906] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 20 19:21:10 vinco kernel: [    4.859938] pstore: Registered efi as pe=
rsistent store backend
Feb 20 19:21:10 vinco kernel: [    4.865564] mc: Linux media interface: v=
0.10
Feb 20 19:21:10 vinco kernel: [    4.913726] videodev: Linux video captur=
e interface: v2.00
Feb 20 19:21:10 vinco kernel: [    4.925068] cryptd: max_cpu_qlen set to =
1000
Feb 20 19:21:10 vinco kernel: [    4.932438] Intel(R) Wireless WiFi drive=
r for Linux
Feb 20 19:21:10 vinco kernel: [    4.932439] Copyright(c) 2003- 2015 Inte=
l Corporation
Feb 20 19:21:10 vinco kernel: [    4.936380] snd_hda_intel 0000:00:03.0: =
bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
Feb 20 19:21:10 vinco kernel: [    4.937436] AVX2 version of gcm_enc/dec =
engaged.
Feb 20 19:21:10 vinco kernel: [    4.937437] AES CTR mode by8 optimizatio=
n enabled
Feb 20 19:21:10 vinco kernel: [    4.940813] uvcvideo: Found UVC 1.00 dev=
ice USB2.0 UVC HD Webcam (13d3:5188)
Feb 20 19:21:10 vinco kernel: [    4.944040] alg: No test for fips(ansi_c=
prng) (fips_ansi_cprng)
Feb 20 19:21:10 vinco kernel: [    4.944508] iwlwifi 0000:04:00.0: firmwa=
re: direct-loading firmware iwlwifi-7260-17.ucode
Feb 20 19:21:10 vinco kernel: [    4.944718] iwlwifi 0000:04:00.0: loaded=
 firmware version 17.3216344376.0 op_mode iwlmvm
Feb 20 19:21:10 vinco kernel: [    4.952173] uvcvideo 2-7:1.0: Entity typ=
e for entity Extension 4 was not initialized!
Feb 20 19:21:10 vinco kernel: [    4.952175] uvcvideo 2-7:1.0: Entity typ=
e for entity Processing 2 was not initialized!
Feb 20 19:21:10 vinco kernel: [    4.952176] uvcvideo 2-7:1.0: Entity typ=
e for entity Camera 1 was not initialized!
Feb 20 19:21:10 vinco kernel: [    4.952268] input: USB2.0 UVC HD Webcam:=
 USB2.0 UV as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/inp=
ut27
Feb 20 19:21:10 vinco kernel: [    4.952336] usbcore: registered new inte=
rface driver uvcvideo
Feb 20 19:21:10 vinco kernel: [    4.952337] USB Video Class driver (1.1.=
1)
Feb 20 19:21:10 vinco kernel: [    4.985700] Adding 15625212k swap on /de=
v/sda3.  Priority:-2 extents:1 across:15625212k SSFS
Feb 20 19:21:10 vinco kernel: [    4.997813] EXT4-fs (sda2): mounting ext=
2 file system using the ext4 subsystem
Feb 20 19:21:10 vinco kernel: [    5.000344] EXT4-fs (sda2): mounted file=
system without journal. Opts: (null)
Feb 20 19:21:10 vinco kernel: [    5.025470] EXT4-fs (sda6): mounted file=
system with ordered data mode. Opts: (null)
Feb 20 19:21:10 vinco kernel: [    5.032670] input: HDA Intel HDMI HDMI/D=
P,pcm=3D3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input28
Feb 20 19:21:10 vinco kernel: [    5.032709] input: HDA Intel HDMI HDMI/D=
P,pcm=3D7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input29
Feb 20 19:21:10 vinco kernel: [    5.032741] input: HDA Intel HDMI HDMI/D=
P,pcm=3D8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input30
Feb 20 19:21:10 vinco kernel: [    5.032774] input: HDA Intel HDMI HDMI/D=
P,pcm=3D9 as /devices/pci0000:00/0000:00:03.0/sound/card0/input31
Feb 20 19:21:10 vinco kernel: [    5.032806] input: HDA Intel HDMI HDMI/D=
P,pcm=3D10 as /devices/pci0000:00/0000:00:03.0/sound/card0/input32
Feb 20 19:21:10 vinco kernel: [    5.118744] snd_hda_codec_realtek hdaudi=
oC1D0: autoconfig for ALC668: line_outs=3D2 (0x14/0x1a/0x0/0x0/0x0) type:=
speaker
Feb 20 19:21:10 vinco kernel: [    5.118747] snd_hda_codec_realtek hdaudi=
oC1D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
Feb 20 19:21:10 vinco kernel: [    5.118759] snd_hda_codec_realtek hdaudi=
oC1D0:    hp_outs=3D1 (0x15/0x0/0x0/0x0/0x0)
Feb 20 19:21:10 vinco kernel: [    5.118760] snd_hda_codec_realtek hdaudi=
oC1D0:    mono: mono_out=3D0x0
Feb 20 19:21:10 vinco kernel: [    5.118761] snd_hda_codec_realtek hdaudi=
oC1D0:    inputs:
Feb 20 19:21:10 vinco kernel: [    5.118762] snd_hda_codec_realtek hdaudi=
oC1D0:      Headphone Mic=3D0x19
Feb 20 19:21:10 vinco kernel: [    5.118764] snd_hda_codec_realtek hdaudi=
oC1D0:      Headset Mic=3D0x1b
Feb 20 19:21:10 vinco kernel: [    5.118766] snd_hda_codec_realtek hdaudi=
oC1D0:      Internal Mic=3D0x12
Feb 20 19:21:10 vinco kernel: [    5.143037] input: HDA Intel PCH Headpho=
ne Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input33
Feb 20 19:21:10 vinco kernel: [    5.145236] Bluetooth: Core ver 2.22
Feb 20 19:21:10 vinco kernel: [    5.145246] NET: Registered protocol fam=
ily 31
Feb 20 19:21:10 vinco kernel: [    5.145246] Bluetooth: HCI device and co=
nnection manager initialized
Feb 20 19:21:10 vinco kernel: [    5.145249] Bluetooth: HCI socket layer =
initialized
Feb 20 19:21:10 vinco kernel: [    5.145250] Bluetooth: L2CAP socket laye=
r initialized
Feb 20 19:21:10 vinco kernel: [    5.145253] Bluetooth: SCO socket layer =
initialized
Feb 20 19:21:10 vinco kernel: [    5.153748] iwlwifi 0000:04:00.0: Detect=
ed Intel(R) Dual Band Wireless N 7260, REV=3D0x144
Feb 20 19:21:10 vinco kernel: [    5.172059] iwlwifi 0000:04:00.0: base H=
W address: 48:51:b7:6b:7d:3a
Feb 20 19:21:10 vinco kernel: [    5.185075] audit: type=3D1400 audit(158=
2219270.553:2): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"aatest-nvidia_modprobe" pid=3D687 comm=3D"apparmor_p=
arser"
Feb 20 19:21:10 vinco kernel: [    5.185261] audit: type=3D1400 audit(158=
2219270.553:3): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"nvidia_modprobe" pid=3D690 comm=3D"apparmor_parser"
Feb 20 19:21:10 vinco kernel: [    5.185264] audit: type=3D1400 audit(158=
2219270.553:4): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"nvidia_modprobe//kmod" pid=3D690 comm=3D"apparmor_pa=
rser"
Feb 20 19:21:10 vinco kernel: [    5.185425] audit: type=3D1400 audit(158=
2219270.553:5): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"openbazaard2" pid=3D686 comm=3D"apparmor_parser"
Feb 20 19:21:10 vinco kernel: [    5.185427] audit: type=3D1400 audit(158=
2219270.553:6): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"openbazaard2//ip" pid=3D686 comm=3D"apparmor_parser"=

Feb 20 19:21:10 vinco kernel: [    5.190214] audit: type=3D1400 audit(158=
2219270.557:7): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"mdnsd" pid=3D688 comm=3D"apparmor_parser"
Feb 20 19:21:10 vinco kernel: [    5.272643] usbcore: registered new inte=
rface driver btusb
Feb 20 19:21:10 vinco kernel: [    5.297804] Bluetooth: hci0: read Intel =
version: 3707100180012d0d00
Feb 20 19:21:10 vinco kernel: [    5.298765] bluetooth hci0: firmware: di=
rect-loading firmware intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
Feb 20 19:21:10 vinco kernel: [    5.298768] Bluetooth: hci0: Intel Bluet=
ooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
Feb 20 19:21:10 vinco kernel: [    5.378534] ieee80211 phy0: Selected rat=
e control algorithm 'iwl-mvm-rs'
Feb 20 19:21:10 vinco kernel: [    5.381318] iwlwifi 0000:04:00.0 wlp4s0:=
 renamed from wlan0
Feb 20 19:21:10 vinco kernel: [    5.471226] Bluetooth: hci0: unexpected =
event for opcode 0xfc2f
Feb 20 19:21:10 vinco kernel: [    5.486213] Bluetooth: hci0: Intel firmw=
are patch completed and activated
Feb 20 19:21:10 vinco kernel: [    5.564715] bbswitch: version 0.8
Feb 20 19:21:10 vinco kernel: [    5.564721] bbswitch: Found integrated V=
GA device 0000:00:02.0: \_SB_.PCI0.GFX0
Feb 20 19:21:10 vinco kernel: [    5.564727] bbswitch: Found discrete VGA=
 device 0000:01:00.0: \_SB_.PCI0.PEG0.PEGP
Feb 20 19:21:10 vinco kernel: [    5.564739] ACPI Warning: \_SB.PCI0.PEG0=
=2EPEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [=
Package] (20190816/nsarguments-59)
Feb 20 19:21:10 vinco kernel: [    5.564833] bbswitch: detected an Optimu=
s _DSM function
Feb 20 19:21:10 vinco kernel: [    5.564912] bbswitch: Succesfully loaded=
=2E Discrete card 0000:01:00.0 is on
Feb 20 19:21:10 vinco kernel: [    5.565565] bbswitch: disabling discrete=
 graphics
Feb 20 19:21:10 vinco kernel: [    5.570239] intel_rapl_common: Found RAP=
L domain package
Feb 20 19:21:10 vinco kernel: [    5.570241] intel_rapl_common: Found RAP=
L domain core
Feb 20 19:21:10 vinco kernel: [    5.570241] intel_rapl_common: Found RAP=
L domain uncore
Feb 20 19:21:10 vinco kernel: [    5.570242] intel_rapl_common: Found RAP=
L domain dram
Feb 20 19:21:10 vinco kernel: [    5.570245] intel_rapl_common: RAPL pack=
age-0 domain package locked by BIOS
Feb 20 19:21:10 vinco kernel: [    5.570249] intel_rapl_common: RAPL pack=
age-0 domain dram locked by BIOS
Feb 20 19:21:10 vinco kernel: [    5.577983] IPMI message handler: versio=
n 39.2
Feb 20 19:21:10 vinco kernel: [    5.580068] ipmi device interface
Feb 20 19:21:11 vinco kernel: [    5.629143] nvidia: module license 'NVID=
IA' taints kernel.
Feb 20 19:21:11 vinco kernel: [    5.629144] Disabling lock debugging due=
 to kernel taint
Feb 20 19:21:11 vinco kernel: [    5.640210] nvidia-nvlink: Nvlink Core i=
s being initialized, major device number 244
Feb 20 19:21:11 vinco kernel: [    5.640508] nvidia 0000:01:00.0: Refused=
 to change power state, currently in D3
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: This is a 64-bit BAR m=
apped above 4GB by the system
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: BIOS or the Linux kern=
el, but the PCI bridge
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: immediately upstream o=
f this GPU does not define
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: a matching prefetchabl=
e memory window.
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: This may be due to a k=
nown Linux kernel bug.  Please
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: see the README section=
 on 64-bit BARs for additional
Feb 20 19:21:11 vinco kernel: [    5.640608] NVRM: information.
Feb 20 19:21:11 vinco kernel: [    5.640614] nvidia: probe of 0000:01:00.=
0 failed with error -1
Feb 20 19:21:11 vinco kernel: [    5.640634] NVRM: The NVIDIA probe routi=
ne failed for 1 device(s).
Feb 20 19:21:11 vinco kernel: [    5.640634] NVRM: None of the NVIDIA gra=
phics adapters were initialized!
Feb 20 19:21:11 vinco kernel: [    5.649176] Bluetooth: BNEP (Ethernet Em=
ulation) ver 1.3
Feb 20 19:21:11 vinco kernel: [    5.649177] Bluetooth: BNEP filters: pro=
tocol multicast
Feb 20 19:21:11 vinco kernel: [    5.649180] Bluetooth: BNEP socket layer=
 initialized
Feb 20 19:21:11 vinco kernel: [    5.712407] nvidia-nvlink: Unregistered =
the Nvlink Core, major device number 244
Feb 20 19:21:11 vinco kernel: [    5.960180] enp5s0f1: 0xffffc0e740051000=
, 08:62:66:b3:2e:1c, IRQ 31
Feb 20 19:21:12 vinco kernel: [    7.087864] broken atomic modeset usersp=
ace detected, disabling atomic
Feb 20 19:21:14 vinco kernel: [    9.392232] r8168: enp5s0f1: link up
Feb 20 19:21:14 vinco kernel: [    9.392273] IPv6: ADDRCONF(NETDEV_CHANGE=
): enp5s0f1: link becomes ready
Feb 20 19:21:14 vinco kernel: [    9.427484] PPP generic driver version 2=
=2E4.2
Feb 20 19:21:14 vinco kernel: [    9.428159] NET: Registered protocol fam=
ily 24
Feb 20 19:21:14 vinco kernel: [    9.433710] l2tp_core: L2TP core driver,=
 V2.0
Feb 20 19:21:14 vinco kernel: [    9.435235] l2tp_netlink: L2TP netlink i=
nterface
Feb 20 19:21:14 vinco kernel: [    9.436835] l2tp_ppp: PPPoL2TP kernel dr=
iver, V2.0
Feb 20 19:21:14 vinco kernel: [    9.450166] vboxdrv: Found 8 processor c=
ores
Feb 20 19:21:14 vinco kernel: [    9.452361] Initializing XFRM netlink so=
cket
Feb 20 19:21:14 vinco kernel: [    9.468456] vboxdrv: TSC mode is Invaria=
nt, tentative frequency 2494226002 Hz
Feb 20 19:21:14 vinco kernel: [    9.468458] vboxdrv: Successfully loaded=
 version 6.1.2_Debian (interface 0x002d0001)
Feb 20 19:21:14 vinco kernel: [    9.478056] VBoxNetFlt: Successfully sta=
rted.
Feb 20 19:21:14 vinco kernel: [    9.485477] VBoxNetAdp: Successfully sta=
rted.
Feb 20 19:21:20 vinco kernel: [   15.520313] r8168: enp5s0f1: link down
Feb 20 19:21:22 vinco kernel: [   17.312543] Bluetooth: RFCOMM TTY layer =
initialized
Feb 20 19:21:22 vinco kernel: [   17.312551] Bluetooth: RFCOMM socket lay=
er initialized
Feb 20 19:21:22 vinco kernel: [   17.312555] Bluetooth: RFCOMM ver 1.11
Feb 20 19:21:24 vinco kernel: [   18.644190] r8168: enp5s0f1: link up
Feb 20 19:21:55 vinco kernel: [   50.021879] nf_conntrack: default automa=
tic helper assignment has been turned off for security reasons and CT-bas=
ed  firewall rule not found. Use the iptables CT target to attach helpers=
 instead.
Feb 20 19:22:49 vinco kernel: [  103.860161] logitech-hidpp-device 0003:0=
46D:101B.0004: HID++ 1.0 device connected.
Feb 20 19:22:49 vinco kernel: [  103.970188] logitech-hidpp-device 0003:0=
46D:101B.0004: multiplier =3D 8
Feb 20 19:23:02 vinco kernel: [  116.512801] SUPR0GipMap: fGetGipCpu=3D0x=
1b
Feb 20 19:23:02 vinco kernel: [  117.269532] vboxdrv: 00000000b709ba0f VM=
MR0.r0
Feb 20 19:23:02 vinco kernel: [  117.381615] vboxdrv: 00000000a10569cf VB=
oxDDR0.r0
Feb 20 19:23:02 vinco kernel: [  117.426700] vboxdrv: 00000000b6b7684b VB=
oxEhciR0.r0
Feb 20 19:23:02 vinco kernel: [  117.429249] VMMR0InitVM: eflags=3D246 fK=
ernelFeatures=3D0x4 (SUPKERNELFEATURES_SMAP=3D0)
Feb 20 19:24:54 vinco kernel: [  228.808802] ------------[ cut here ]----=
--------
Feb 20 19:24:54 vinco kernel: [  228.808832] NETDEV WATCHDOG: enp5s0f1 (r=
8168): transmit queue 0 timed out
Feb 20 19:24:54 vinco kernel: [  228.808865] WARNING: CPU: 7 PID: 0 at ne=
t/sched/sch_generic.c:447 dev_watchdog+0x248/0x250
Feb 20 19:24:54 vinco kernel: [  228.808871] Modules linked in: xt_recent=
 ipt_REJECT nf_reject_ipv4 xt_multiport xt_conntrack xt_hashlimit xt_addr=
type xt_iface(OE) xt_mark nft_chain_nat xt_comment xt_CT xt_owner xt_tcpu=
dp nft_compat nft_counter xt_NFLOG nf_log_ipv4 nf_log_common xt_LOG nf_na=
t_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_=
irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_na=
t nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp =
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_co=
nntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack nf_defrag_ipv=
6 nf_defrag_ipv4 nf_tables rfcomm vboxnetadp(OE) vboxnetflt(OE) xfrm_user=
 xfrm_algo vboxdrv(OE) l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp=
_tunnel pppox ppp_generic slhc bnep nfnetlink_log nfnetlink ipmi_devintf =
ipmi_msghandler intel_rapl_msr intel_rapl_common bbswitch(OE) x86_pkg_tem=
p_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass btusb btrtl i=
wlmvm btbcm
Feb 20 19:24:54 vinco kernel: [  228.808935]  binfmt_misc btintel bluetoo=
th crct10dif_pclmul nls_ascii ghash_clmulni_intel mac80211 nls_cp437 snd_=
hda_codec_realtek snd_hda_codec_generic vfat drbg ledtrig_audio libarc4 s=
nd_hda_codec_hdmi fat uvcvideo aesni_intel iwlwifi videobuf2_vmalloc ansi=
_cprng crypto_simd videobuf2_memops videobuf2_v4l2 snd_hda_intel cryptd g=
lue_helper snd_intel_nhlt videobuf2_common snd_hda_codec videodev snd_hda=
_core intel_cstate ecdh_generic ecc cfg80211 mc intel_uncore efi_pstore s=
nd_hwdep snd_pcm snd_timer asus_nb_wmi joydev asus_wmi snd sparse_keymap =
iTCO_wdt rtsx_pci_ms iTCO_vendor_support pcspkr intel_rapl_perf serio_raw=
 sg efivars soundcore memstick watchdog rfkill ie31200_edac evdev ac asus=
_wireless parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4=
 ext4 crc16 mbcache jbd2 btrfs xor zstd_decompress zstd_compress raid6_pq=
 libcrc32c crc32c_generic sr_mod cdrom sd_mod hid_logitech_hidpp hid_logi=
tech_dj hid_generic usbhid hid i915 rtsx_pci_sdmmc mmc_core i2c_algo_bit =
ahci
Feb 20 19:24:54 vinco kernel: [  228.809003]  drm_kms_helper libahci xhci=
_pci crc32_pclmul mxm_wmi libata xhci_hcd drm crc32c_intel ehci_pci ehci_=
hcd psmouse scsi_mod usbcore rtsx_pci lpc_ich i2c_i801 mfd_core r8168(OE)=
 usb_common video wmi battery button
Feb 20 19:24:54 vinco kernel: [  228.809025] CPU: 7 PID: 0 Comm: swapper/=
7 Tainted: P           OE     5.4.0-4-amd64 #1 Debian 5.4.19-1
Feb 20 19:24:54 vinco kernel: [  228.809027] Hardware name: ASUSTeK COMPU=
TER INC. N551JM/N551JM, BIOS N551JM.205 02/13/2015
Feb 20 19:24:54 vinco kernel: [  228.809034] RIP: 0010:dev_watchdog+0x248=
/0x250
Feb 20 19:24:54 vinco kernel: [  228.809038] Code: 85 c0 75 e5 eb 9f 4c 8=
9 ef c6 05 58 1d a8 00 01 e8 0d e4 fa ff 44 89 e1 4c 89 ee 48 c7 c7 f0 cc=
 d2 9a 48 89 c2 e8 76 40 a0 ff <0f> 0b eb 80 0f 1f 40 00 0f 1f 44 00 00 4=
1 57 41 56 49 89 d6 41 55
Feb 20 19:24:54 vinco kernel: [  228.809040] RSP: 0018:ffffc0e74020ce68 E=
FLAGS: 00010286
Feb 20 19:24:54 vinco kernel: [  228.809043] RAX: 0000000000000000 RBX: f=
fff9f660df8e200 RCX: 000000000000083f
Feb 20 19:24:54 vinco kernel: [  228.809044] RDX: 0000000000000000 RSI: 0=
0000000000000f6 RDI: 000000000000083f
Feb 20 19:24:54 vinco kernel: [  228.809046] RBP: ffff9f660d30045c R08: f=
fff9f661edd7688 R09: 0000000000000004
Feb 20 19:24:54 vinco kernel: [  228.809048] R10: 0000000000000000 R11: 0=
000000000000001 R12: 0000000000000000
Feb 20 19:24:54 vinco kernel: [  228.809049] R13: ffff9f660d300000 R14: f=
fff9f660d300480 R15: 0000000000000001
Feb 20 19:24:54 vinco kernel: [  228.809052] FS:  0000000000000000(0000) =
GS:ffff9f661edc0000(0000) knlGS:0000000000000000
Feb 20 19:24:54 vinco kernel: [  228.809054] CS:  0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
Feb 20 19:24:54 vinco kernel: [  228.809055] CR2: 00005f1110bf6da4 CR3: 0=
000000185e0a001 CR4: 00000000001626e0
Feb 20 19:24:54 vinco kernel: [  228.809057] Call Trace:
Feb 20 19:24:54 vinco kernel: [  228.809060]  <IRQ>
Feb 20 19:24:54 vinco kernel: [  228.809068]  ? pfifo_fast_enqueue+0x150/=
0x150
Feb 20 19:24:54 vinco kernel: [  228.809073]  call_timer_fn+0x2d/0x130
Feb 20 19:24:54 vinco kernel: [  228.809077]  __run_timers.part.0+0x16f/0=
x260
Feb 20 19:24:54 vinco kernel: [  228.809084]  ? tick_sched_handle+0x22/0x=
60
Feb 20 19:24:54 vinco kernel: [  228.809089]  ? tick_sched_timer+0x38/0x8=
0
Feb 20 19:24:54 vinco kernel: [  228.809093]  ? tick_sched_do_timer+0x60/=
0x60
Feb 20 19:24:54 vinco kernel: [  228.809096]  run_timer_softirq+0x26/0x50=

Feb 20 19:24:54 vinco kernel: [  228.809102]  __do_softirq+0xe6/0x2e9
Feb 20 19:24:54 vinco kernel: [  228.809111]  irq_exit+0xa6/0xb0
Feb 20 19:24:54 vinco kernel: [  228.809115]  smp_apic_timer_interrupt+0x=
76/0x130
Feb 20 19:24:54 vinco kernel: [  228.809118]  apic_timer_interrupt+0xf/0x=
20
Feb 20 19:24:54 vinco kernel: [  228.809120]  </IRQ>
Feb 20 19:24:54 vinco kernel: [  228.809126] RIP: 0010:cpuidle_enter_stat=
e+0xc4/0x450
Feb 20 19:24:54 vinco kernel: [  228.809129] Code: e8 b1 54 ad ff 80 7c 2=
4 0f 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 61 03 00 00 31 ff e8 a3=
 74 b3 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 8c 02 00 00 49 63 cc 4c 2=
b 6c 24 10 48 8d 04 49 48
Feb 20 19:24:54 vinco kernel: [  228.809131] RSP: 0018:ffffc0e7400cfe68 E=
FLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Feb 20 19:24:54 vinco kernel: [  228.809133] RAX: ffff9f661edea6c0 RBX: f=
fffffff9aeb92e0 RCX: 000000000000001f
Feb 20 19:24:54 vinco kernel: [  228.809135] RDX: 0000000000000000 RSI: 0=
00000003351882d RDI: 0000000000000000
Feb 20 19:24:54 vinco kernel: [  228.809137] RBP: ffff9f661edf4a00 R08: 0=
00000354610e2fa R09: 0000000000029fa0
Feb 20 19:24:54 vinco kernel: [  228.809138] R10: ffff9f661ede95a0 R11: f=
fff9f661ede9580 R12: 0000000000000005
Feb 20 19:24:54 vinco kernel: [  228.809140] R13: 000000354610e2fa R14: 0=
000000000000005 R15: ffff9f661caa8f00
Feb 20 19:24:54 vinco kernel: [  228.809145]  ? cpuidle_enter_state+0x9f/=
0x450
Feb 20 19:24:54 vinco kernel: [  228.809149]  cpuidle_enter+0x29/0x40
Feb 20 19:24:54 vinco kernel: [  228.809155]  do_idle+0x1dc/0x270
Feb 20 19:24:54 vinco kernel: [  228.809162]  cpu_startup_entry+0x19/0x20=

Feb 20 19:24:54 vinco kernel: [  228.809168]  start_secondary+0x15f/0x1b0=

Feb 20 19:24:54 vinco kernel: [  228.809174]  secondary_startup_64+0xa4/0=
xb0
Feb 20 19:24:54 vinco kernel: [  228.809179] ---[ end trace f2c0113df7c88=
e86 ]---
Feb 20 19:24:57 vinco kernel: [  231.448423] r8168: enp5s0f1: link up

--------------9C9987BD455004C616BE9300--
