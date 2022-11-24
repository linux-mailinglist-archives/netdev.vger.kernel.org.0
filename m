Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28432636926
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbiKWSmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238557AbiKWSmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:42:22 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62CF7DCBB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:42:20 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id j4so29486908lfk.0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WxFyGLKRm7+PEt039JHeC5BsYLpPMxcMX1UEmAz2hC8=;
        b=l4yWi75rzVp9NYb76y2LlQ6b4lcgKUxcR4fmNR6XdNagHrOfQ+n0vrfmtEr2KQupE/
         Kiv/D01Z4msGY3Ti3jY6HhbRUBiX+J5foy6+9eirdnYgbU2O4ub6215vbdHOLw9txsb6
         UtkWTZHvLB9mC4cO5EbLAMkQtYWJO5RUWdIGSsMT4VzNdxWaTBkzAKl8LUsRdLxeBu29
         L4IpQzuRwV9cA6pcUp+15dGZITrjsH8wOKXU6WyHo/jDUWuEJdOA0vDMd85/OHyrU1B+
         FjJIkdPgLBqpRI+S0zZ4aBdEGS35wbb/LNtMZz8z/mi1bobcrHDg/o+iYKhzaDYUPbqE
         eQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WxFyGLKRm7+PEt039JHeC5BsYLpPMxcMX1UEmAz2hC8=;
        b=AUbnkKGM+wByzP8akMBXVRgmliCJ59icxgCkbWXjOAv7GaQi1T0wmjs4l9ytXwrlkf
         YC9SI2QJpefaJW08M83bRdeBAIGRd1uzX6CTfeEN3eubYFgTYHhS4NMV8US8GJRJGp5V
         yicnLQMcjF695bLRPhapO1F4s45qy3LWi98Zz7bE1A2oCD4SjHVcPTlai+bXeTu9NUQo
         gpeeuyi/cPyXtgDonI8FfYbMghULv1dJEanCfQ8e2cpuLgEvJZTlZEuL6KN9BmzN4I/E
         LEP5o1sX+6psXXEIjEHMGC/g7ARZvJNztaOHNwu+aGG0G2wol1ex77pSC8kjVaDM6BlN
         i9wQ==
X-Gm-Message-State: ANoB5pm/TT1m06KStZyhPAkF3SBIUTBUhTruA9HaSG0w6qhYjnxbeuie
        PxrlxJvf3VpG2MVmfkUFPqpII5ykW3NTyiMzQYT4Lw7rHTo4RA==
X-Google-Smtp-Source: AA0mqf7o3j/Ir0XvwOjpl8ygAwFxJ9sHcWQ34sXO/oGX0huBFKR3sOQetEXL9yND+4rPSRld6/vHXUFOXpxYFsaEk44=
X-Received: by 2002:ac2:4f8e:0:b0:4b1:2190:829b with SMTP id
 z14-20020ac24f8e000000b004b12190829bmr9508395lfs.334.1669228939236; Wed, 23
 Nov 2022 10:42:19 -0800 (PST)
MIME-Version: 1.0
From:   Ioannis Barkas <jnyb.de@gmail.com>
Date:   Thu, 24 Nov 2022 20:41:10 +0200
Message-ID: <CADUzMVYi2no7rH9Va3SjWCJr-OhH3_s0fO0oZKo2FbT2g8aKyA@mail.gmail.com>
Subject: BCM4401 LAN
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello guys!

I resurrected some old PCs at job and found one with BCM4401 LAN. This
LAN had some issues as I read in various OSes so I gave it a try using
live Ubuntu 22.10. It worked fine though I got this when I plugged in
the Ethernet cable:
[  517.928052] b44 ssb0:0 eth0: Link is up at 100 Mbps, full duplex
[  517.928066] b44 ssb0:0 eth0: Flow control is off for TX and off for RX
[  517.928246] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  520.697405] ------------[ cut here ]------------
[  520.697417] b44 0000:0a:0b.0: DMA addr 0x00000000766d9402+42
overflow (mask 3fffffff, bus limit 0).
[  520.697438] WARNING: CPU: 1 PID: 1187 at kernel/dma/direct.h:97
dma_direct_map_page+0x1f1/0x200
[  520.697456] Modules linked in: ntfs3 snd_seq_dummy snd_hrtimer
binfmt_misc zfs(PO) zunicode(PO) zzstd(O) zlua(O) zavl(PO) icp(PO)
zcommon(PO) znvpair(PO) spl(O) snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq input_leds
snd_seq_device intel_powerclamp serio_raw snd_timer snd mac_hid
soundcore msr parport_pc ppdev lp parport ramoops pstore_blk
reed_solomon pstore_zone efi_pstore ip_tables x_tables autofs4 overlay
isofs dm_mirror dm_region_hash dm_log uas usb_storage i915 drm_buddy
i2c_algo_bit ttm drm_display_helper cec rc_core drm_kms_helper
gpio_ich syscopyarea sysfillrect sysimgblt fb_sys_fops hid_generic drm
b44 psmouse ssb i2c_i801 lpc_ich i2c_smbus video mii pata_acpi floppy
usbhid hid
[  520.697639] CPU: 1 PID: 1187 Comm: NetworkManager Tainted: P
   O      5.19.0-21-generic #21-Ubuntu
[  520.697648] Hardware name: LENOVO 832676G/LENOVO, BIOS 2HKT13AUS 09/08/2006
[  520.697652] RIP: 0010:dma_direct_map_page+0x1f1/0x200
[  520.697663] Code: 89 e7 48 89 55 c8 e8 be 0b 7f 00 4d 89 e9 48 8d
4d d0 48 89 da 41 56 4c 8b 45 c8 48 89 c6 48 c7 c7 28 13 80 b3 e8 04
d6 cc 00 <0f> 0b 58 eb 87 e8 15 29 d9 00 0f 1f 44 00 00 0f 1f 44 00 00
55 48
[  520.697670] RSP: 0018:ffffafd740b3b9d0 EFLAGS: 00010046
[  520.697677] RAX: 0000000000000000 RBX: ffff943701b01670 RCX: 0000000000000000
[  520.697681] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  520.697685] RBP: ffffafd740b3ba18 R08: 0000000000000000 R09: 0000000000000000
[  520.697688] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9437019d60d0
[  520.697692] R13: 000000003fffffff R14: 0000000000000000 R15: ffff94370ab25000
[  520.697697] FS:  00007fdf897554c0(0000) GS:ffff9437bc300000(0000)
knlGS:0000000000000000
[  520.697702] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  520.697707] CR2: 000055ecba997230 CR3: 00000000080b6000 CR4: 00000000000006e0
[  520.697713] Call Trace:
[  520.697718]  <TASK>
[  520.697728]  dma_map_page_attrs+0x63/0xa0
[  520.697740]  b44_start_xmit+0xd7/0x532 [b44]
[  520.697756]  dev_hard_start_xmit+0x68/0x1e0
[  520.697767]  sch_direct_xmit+0x10b/0x330
[  520.697776]  __dev_xmit_skb+0x397/0x5a0
[  520.697782]  ? _copy_from_iter+0x9a/0x6a0
[  520.697793]  __dev_queue_xmit+0x332/0x6e0
[  520.697801]  ? packet_parse_headers+0x16d/0x260
[  520.697811]  ? packet_parse_headers+0x16d/0x260
[  520.697819]  dev_queue_xmit+0xb/0x20
[  520.697825]  packet_snd+0x332/0x7b0
[  520.697834]  packet_sendmsg+0x30/0x40
[  520.697841]  sock_sendmsg+0x6d/0x70
[  520.697850]  __sys_sendto+0x142/0x1a0
[  520.697864]  __x64_sys_sendto+0x24/0x40
[  520.697872]  do_syscall_64+0x5b/0x90
[  520.697880]  ? exit_to_user_mode_prepare+0x30/0xb0
[  520.697889]  ? syscall_exit_to_user_mode+0x26/0x50
[  520.697897]  ? __x64_sys_read+0x19/0x30
[  520.697905]  ? do_syscall_64+0x67/0x90
[  520.697911]  ? do_syscall_64+0x67/0x90
[  520.697917]  ? ksys_write+0xe6/0x100
[  520.697925]  ? exit_to_user_mode_prepare+0x30/0xb0
[  520.697935]  ? syscall_exit_to_user_mode+0x26/0x50
[  520.697942]  ? __x64_sys_write+0x19/0x30
[  520.697949]  ? do_syscall_64+0x67/0x90
[  520.697956]  ? syscall_exit_to_user_mode+0x26/0x50
[  520.697962]  ? __do_sys_gettid+0x1b/0x30
[  520.697970]  ? do_syscall_64+0x67/0x90
[  520.697975]  ? sysvec_apic_timer_interrupt+0x4b/0xd0
[  520.697981]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  520.697990] RIP: 0033:0x7fdf8a8a39cc
[  520.697998] Code: 4a b8 f6 ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5
44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24
08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 90 b8 f6 ff
48 8b
[  520.698003] RSP: 002b:00007ffeaecdc9e0 EFLAGS: 00000293 ORIG_RAX:
000000000000002c
[  520.698010] RAX: ffffffffffffffda RBX: 000055ecba989780 RCX: 00007fdf8a8a39cc
[  520.698015] RDX: 000000000000001c RSI: 00007ffeaecdca40 RDI: 000000000000001a
[  520.698019] RBP: 0000000000000000 R08: 00007ffeaecdca20 R09: 0000000000000014
[  520.698023] R10: 0000000000004000 R11: 0000000000000293 R12: 000055ecba93d340
[  520.698026] R13: 000055ecba9897b0 R14: 000000793c171530 R15: 00007ffeaecdcb00
[  520.698036]  </TASK>
[  520.698039] ---[ end trace 0000000000000000 ]---

This is the LAN device:
0a:0b.0 Ethernet controller [0200]: Broadcom Inc. and subsidiaries
BCM4401-B0 100Base-TX [14e4:170c] (rev 02)
    Subsystem: Lenovo BCM4401-B0 100Base-TX [17aa:1004]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=8K]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
    Kernel driver in use: b44
    Kernel modules: b44
00: e4 14 0c 17 06 01 10 00 02 00 00 02 00 20 00 00
10: 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 04 10
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 00 02 fe 00 40 00 34 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 18 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 40 00 00 00 c0 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Does anything look awfully wrong in the trace?
