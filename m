Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35C52AB4C
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 18:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfEZQtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 12:49:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42641 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfEZQtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 12:49:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id 33so4747475pgv.9
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 09:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9Htl/d8mwvPZFQVaZRn/PBMFX+Y6NjQtamGqUPpp/Hs=;
        b=NcWmR5ZL8B/P8ETH405Re4xwhny01FNntIH47hRRxQhuqQ6cYW6c/9hiO5fv0jmWF6
         ze/n3Xxvl1zBqTAU76FDiWvDllsDiAYzffA/EthamQOhW9lXknEGvmZGesUcbCaydSFN
         +XnWacioveRw9cWxz2rGvuVqVa2z15nxk79uIQdK8fuOJekaYFzQluIRfqg38pCTe+zG
         py/n0ugqFRhSUODD8K7CPUjbFlKfpBCS2GqeI+hxhyCVhPU+IAOTydECR0RGeGPaU4pe
         K5Qd1km3bErOAUScdoyVkOmx8pXSG7dO0/Qpq+rqREk91KvqA462N5NiiGRsYjmt2Plv
         3ihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9Htl/d8mwvPZFQVaZRn/PBMFX+Y6NjQtamGqUPpp/Hs=;
        b=EJ6+I5MvGh8rC+s9BiYrxWFj+2brSm3AI7o18ZuTqe0wMI1ZI2f3ZBOiVA1FmPJJAB
         RBw+CIo+wBEpuK/E7QXCTHpEnjS7uNl/JKLAq4w48kOl230l9zyRuBdxWzzFOiS/QbEf
         ZfDycM8LJlCrRkIVIzuovBb500VMU/SLg4a5YwhguPyTzcZ+SRlbz2fCj4SuqJQWZeII
         BMDvRvuQTYbe9yoOrDz28BASNWRQ3AjilBLpq9E82rnwA5xdqJxnXFfvtQk0Dnu6C8ba
         /lfCwSO75EHtTdg8W/U2T1r0nn8FZuPY36xp8sKLuVxp35u+2PNtbMMY8/P5Hyq49k75
         ayhQ==
X-Gm-Message-State: APjAAAU80HGCdJHVpi7MdEU3xcHbrGdJSIY2aTG7N1TsEPIMnYhilyMh
        mdbSOY1hRuJlcrTlzXmNRGcH6lw9dv8=
X-Google-Smtp-Source: APXvYqziBEC/X4frUVaejIGoVS2/AjBuVEJirdI5jxJDcfdgR4VzY1OAwzd4ySgwO8RaPL9dSAgLUA==
X-Received: by 2002:a62:e117:: with SMTP id q23mr129858600pfh.60.1558889356902;
        Sun, 26 May 2019 09:49:16 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f13sm9231184pje.11.2019.05.26.09.49.16
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 26 May 2019 09:49:16 -0700 (PDT)
Date:   Sun, 26 May 2019 09:49:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 203703] New: 5.1 regression makes r8169 Ethernet
 connection inoperable if fq_codel qdisc is used
Message-ID: <20190526094914.34a53c3a@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 25 May 2019 04:55:19 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203703] New: 5.1 regression makes r8169 Ethernet connection inoperable if fq_codel qdisc is used


https://bugzilla.kernel.org/show_bug.cgi?id=203703

            Bug ID: 203703
           Summary: 5.1 regression makes r8169 Ethernet connection
                    inoperable if fq_codel qdisc is used
           Product: Networking
           Version: 2.5
    Kernel Version: 5.1.4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: virtuousfox@gmail.com
        Regression: No

Created attachment 282937
  --> https://bugzilla.kernel.org/attachment.cgi?id=282937&action=edit  
kernel config

After updating from 5.0.x to 5.1.x my network started halting less than hour
after boot with "network unreachable" messages for any connection attempt. With
these lines in kernel log:
[34441.731088] NETDEV WATCHDOG: enp4s0 (r8169): transmit queue 0 timed out
[34441.731126] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:461
dev_watchdog+0x21a/0x220
[34441.731128] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq af_packet ts_bm xt_pkttype xt_string nf_nat_ftp nf_conntrack_ftp
xt_tcpudp ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat
ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
iptable_mangle iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables scsi_transport_iscsi
ip6table_filter ip6_tables iptable_filter ip_tables x_tables bpfilter rfcomm
bnep zram msr it87 hwmon_vid snd_hda_codec_hdmi snd_usb_audio snd_usbmidi_lib
rc_avermedia btusb snd_rawmidi snd_hda_codec_realtek btrtl
snd_hda_codec_generic snd_seq_device btbcm ledtrig_audio tuner_simple
tuner_types ath9k btintel tuner tda7432 ath9k_common ath9k_hw bluetooth tvaudio
msp3400 ath amd64_edac_mod bttv snd_hda_intel edac_mce_amd kvm_amd
snd_hda_codec snd_hda_core mac80211 snd_hwdep tea575x kvm tveeprom
videobuf_dma_sg videobuf_core snd_pcm_oss
[34441.731180]  rc_core snd_mixer_oss v4l2_common videodev irqbypass mxm_wmi
wmi_bmof amdgpu media pcspkr k10temp snd_pcm cfg80211 r8169 fam15h_power
realtek sp5100_tco i2c_piix4 chash libphy gpu_sched ttm rfkill mac_hid
hid_generic usbhid uas usb_storage sd_mod ohci_pci serio_raw ohci_hcd xhci_pci
ehci_pci ehci_hcd xhci_hcd wmi exfat(O) l2tp_ppp l2tp_netlink l2tp_core
ip6_udp_tunnel udp_tunnel pppox ppp_generic slhc vhba(O) uinput sg nbd
dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua ecryptfs
[34441.731218] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G          IO     
5.1.4-1320.g0739fa4-HSF #1 openSUSE Tumbleweed (unreleased)
[34441.731220] Hardware name: Gigabyte Technology Co., Ltd.
GA-990XA-UD3/GA-990XA-UD3, BIOS F14e 09/09/2014
[34441.731224] RIP: 0010:dev_watchdog+0x21a/0x220
[34441.731227] Code: 49 63 4c 24 e0 eb 8c 4c 89 ef c6 05 a7 8d 0e 01 01 e8 9a
dd fa ff 89 d9 4c 89 ee 48 c7 c7 c0 51 9b 9a 48 89 c2 e8 1a e2 44 ff <0f> 0b eb
be 66 90 0f 1f 44 00 00 48 c7 47 08 00 00 00 00 48 c7 07
[34441.731230] RSP: 0018:ffff8c1cede03e40 EFLAGS: 00010286
[34441.731233] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[34441.731235] RDX: 0000000000000007 RSI: ffff8c19c5d14dc8 RDI:
0000000000000001
[34441.731238] RBP: ffff8c1cdcd8e4a0 R08: 0000000000000103 R09:
0000000000000000
[34441.731240] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8c1cdcd8e508
[34441.731243] R13: ffff8c1cdcd8e000 R14: 0000000000000001 R15:
ffff8c1cdc31d080
[34441.731246] FS:  0000000000000000(0000) GS:ffff8c1cede00000(0000)
knlGS:0000000000000000
[34441.731248] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34441.731251] CR2: 00007fec8043aa48 CR3: 00000004067d4000 CR4:
00000000000406e0
[34441.731253] Call Trace:
[34441.731256]  <IRQ>
[34441.731263]  ? qdisc_put_unlocked+0x30/0x30
[34441.731269]  call_timer_fn+0xaa/0x300
[34441.731279]  ? qdisc_put_unlocked+0x30/0x30
[34441.731283]  run_timer_softirq+0x1df/0x530
[34441.731291]  ? read_hpet+0x124/0x140
[34441.731302]  __do_softirq+0xf3/0x4c5
[34441.731315]  irq_exit+0xef/0x100
[34441.731319]  smp_apic_timer_interrupt+0xb5/0x270
[34441.731324]  apic_timer_interrupt+0xf/0x20
[34441.731327]  </IRQ>
[34441.731331] RIP: 0010:native_safe_halt+0xe/0x10
[34441.731334] Code: f0 80 48 02 20 48 8b 00 a8 08 75 c3 e9 7c ff ff ff 90 90
90 90 90 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d 86 40 52 00 fb f4 <c3> 90 e9
07 00 00 00 0f 00 2d 76 40 52 00 f4 c3 90 90 0f 1f 44 00
[34441.731337] RSP: 0018:ffffb835c196beb0 EFLAGS: 00000206 ORIG_RAX:
ffffffffffffff13
[34441.731340] RAX: ffff8c19c5d14440 RBX: 0000000000000001 RCX:
0000000000000000
[34441.731342] RDX: ffff8c19c5d14440 RSI: 0000000000000006 RDI:
ffff8c19c5d14440
[34441.731344] RBP: ffffffff9ae3f360 R08: 0000000000000001 R09:
0000000000000000
[34441.731347] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[34441.731349] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[34441.731367]  default_idle+0x1f/0x180
[34441.731374]  default_idle_call+0x31/0x40
[34441.731378]  do_idle+0x211/0x2b0
[34441.731386]  cpu_startup_entry+0x19/0x20
[34441.731391]  start_secondary+0x185/0x1e0
[34441.731397]  secondary_startup_64+0xa4/0xb0
[34441.731415] irq event stamp: 422277267
[34441.731419] hardirqs last  enabled at (422277266): [<ffffffff991e1b58>]
console_unlock.part.14+0x438/0x5a0
[34441.731423] hardirqs last disabled at (422277267): [<ffffffff9900383b>]
trace_hardirqs_off_thunk+0x1a/0x1c
[34441.731426] softirqs last  enabled at (422277248): [<ffffffff99165d97>]
irq_enter+0x67/0x70
[34441.731430] softirqs last disabled at (422277249): [<ffffffff99165e8f>]
irq_exit+0xef/0x100
[34441.731432] ---[ end trace 05ead7daf10a5f51 ]---

Reloading the r8169 doesn't fix that but I was able to work around the issue by
changing qdisc from fq_codel to "safe default" of pfifo_fast. With that,
network continues to work as if nothing has happened. The only seemingly
relevant info that I could gather is this discussion:
https://lkml.org/lkml/2019/2/9/44

I set qdisc by CONFIG_DEFAULT_NET_SCH="fq_codel" in kernel config and `tc qdisc
replace dev ${interface} root fq_codel limit 500000 flows 50000 target 25ms
interval 200ms` in tuned's script.sh.

-- 
You are receiving this mail because:
You are the assignee for the bug.
