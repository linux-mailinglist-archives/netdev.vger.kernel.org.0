Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5F0595875
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbiHPKfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiHPKer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:34:47 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76A5D9E83
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:37:22 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id c7-20020a056e020bc700b002e59be6ce85so4100879ilu.12
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=cRiGHi7V0E16Zd9yaFOspAnkEj0IBBJulLv08cYCilo=;
        b=oy438aY12jN+C/kxwrVRm6TnPtfTz/YFMJWn29oWzqE4NVEA3u96NgXUvoUU80K/Bw
         GKcq6xkrUwSm4IMN8kr7Qvt3Ge6xG0OAoekNeIgbrrRc8ruW+apznAwSRG/uhe/B8lTy
         uMkbHepQdHNIDxrxiWKkGgWOe+5CFlspaBy0q9a7P1QlRKT2aXHfYEzYM5mLmdT5Oiwy
         HuFP/zL+jdiBxJ/4GHMpG1YDz1Bp5Rx0al3zzVuCYvrfbN+JJ4aPu8M7eQaLBRyOrsPz
         yHtvXn5DDK9UpBOQOhoJQsNOxCaHIjwnQmugiXD5lst0OLWrj/emX32JPbNXlh9uHrbC
         5FIg==
X-Gm-Message-State: ACgBeo0r2EA9O3ISJr6atHrA9WpGh3wrec9NuoR/UqnP3SLuXQ2qiobt
        JKkdqHSLXPBmoWJeBUaADaOfxLUvTy7hFwde4kXavEPudmgT
X-Google-Smtp-Source: AA6agR4jjixZvDXts2iGrdDyrmDIr5NpqGJ4hJbjX7lpRVkElOGgZyfKx5n7fn3TLinYYkjtDVbrx00C8szJFLRbUBlx2JLHyzrj
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e09:b0:2de:f22:9cca with SMTP id
 g9-20020a056e021e0900b002de0f229ccamr9461855ila.36.1660639042014; Tue, 16 Aug
 2022 01:37:22 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:37:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033169005e657a852@google.com>
Subject: [syzbot] upstream boot error: general protection fault in nl80211_put_iface_combinations
From:   syzbot <syzbot+684d4ca200fda0b2141e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    568035b01cfb Linux 6.0-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145d8a47080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=126b81cc3ce4f07e
dashboard link: https://syzkaller.appspot.com/bug?extid=684d4ca200fda0b2141e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+684d4ca200fda0b2141e@syzkaller.appspotmail.com

usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
scsi host0: Virtio SCSI HBA
st: Version 20160209, fixed bufsize 32768, s/g segs 256
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
MACsec IEEE 802.1AE
tun: Universal TUN/TAP device driver, 1.6
vcan: Virtual CAN interface driver
vxcan: Virtual CAN Tunnel driver
slcan: serial line CAN interface driver
CAN device driver interface
usbcore: registered new interface driver usb_8dev
usbcore: registered new interface driver ems_usb
usbcore: registered new interface driver gs_usb
usbcore: registered new interface driver kvaser_usb
usbcore: registered new interface driver mcba_usb
usbcore: registered new interface driver peak_usb
e100: Intel(R) PRO/100 Network Driver
e100: Copyright(c) 1999-2006 Intel Corporation
e1000: Intel(R) PRO/1000 Network Driver
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver
e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
AX.25: 6pack driver, Revision: 0.3.0
AX.25: bpqether driver version 004
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
PPP MPPE Compression module registered
NET: Registered PF_PPPOX protocol family
PPTP driver version 0.8.5
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
hdlc: HDLC support module revision 1.22
LAPB Ethernet driver version 0.02
usbcore: registered new interface driver ath9k_htc
usbcore: registered new interface driver carl9170
usbcore: registered new interface driver ath6kl_usb
usbcore: registered new interface driver ar5523
usbcore: registered new interface driver ath10k_usb
usbcore: registered new interface driver rndis_wlan
mac80211_hwsim: initializing netlink
general protection fault, probably for non-canonical address 0xffff000000000000: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:nl80211_put_iface_combinations+0x19d/0x4b0 net/wireless/nl80211.c:1632
Code: 00 00 e8 a6 5b 2d fd 48 85 ed 0f 84 d4 00 00 00 e8 98 5b 2d fd 49 8b 06 ba 04 00 00 00 48 89 df 48 8d 4c 24 2c be 01 00 00 00 <42> 0f b7 04 28 89 44 24 2c e8 d5 81 3d fe 31 ff 41 89 c7 89 c6 e8
RSP: 0000:ffffc90000273a50 EFLAGS: 00010293
RAX: ffff000000000000 RBX: ffff888102235800 RCX: ffffc90000273a7c
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffff888102235800
RBP: ffff88810283494c R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000002f8b8 R12: 0000000000000001
R13: 0000000000000000 R14: ffff888106d14c88 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 0000000005a29000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nl80211_send_wiphy+0x9b4/0x4170 net/wireless/nl80211.c:2648
 nl80211_notify_wiphy+0x8f/0x140 net/wireless/nl80211.c:17164
 wiphy_register+0x112f/0x1400 net/wireless/core.c:942
 ieee80211_register_hw+0x11c9/0x1590 net/mac80211/main.c:1379
 mac80211_hwsim_new_radio+0xc3f/0x1520 drivers/net/wireless/mac80211_hwsim.c:4129
 init_mac80211_hwsim+0x43d/0x5ae drivers/net/wireless/mac80211_hwsim.c:5379
 do_one_initcall+0x5e/0x2e0 init/main.c:1296
 do_initcall_level init/main.c:1369 [inline]
 do_initcalls init/main.c:1385 [inline]
 do_basic_setup init/main.c:1404 [inline]
 kernel_init_freeable+0x255/0x2cf init/main.c:1611
 kernel_init+0x1a/0x1c0 init/main.c:1500
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nl80211_put_iface_combinations+0x19d/0x4b0 net/wireless/nl80211.c:1632
Code: 00 00 e8 a6 5b 2d fd 48 85 ed 0f 84 d4 00 00 00 e8 98 5b 2d fd 49 8b 06 ba 04 00 00 00 48 89 df 48 8d 4c 24 2c be 01 00 00 00 <42> 0f b7 04 28 89 44 24 2c e8 d5 81 3d fe 31 ff 41 89 c7 89 c6 e8
RSP: 0000:ffffc90000273a50 EFLAGS: 00010293
RAX: ffff000000000000 RBX: ffff888102235800 RCX: ffffc90000273a7c
RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffff888102235800
RBP: ffff88810283494c R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000002f8b8 R12: 0000000000000001
R13: 0000000000000000 R14: ffff888106d14c88 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 0000000005a29000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	e8 a6 5b 2d fd       	callq  0xfd2d5bad
   7:	48 85 ed             	test   %rbp,%rbp
   a:	0f 84 d4 00 00 00    	je     0xe4
  10:	e8 98 5b 2d fd       	callq  0xfd2d5bad
  15:	49 8b 06             	mov    (%r14),%rax
  18:	ba 04 00 00 00       	mov    $0x4,%edx
  1d:	48 89 df             	mov    %rbx,%rdi
  20:	48 8d 4c 24 2c       	lea    0x2c(%rsp),%rcx
  25:	be 01 00 00 00       	mov    $0x1,%esi
* 2a:	42 0f b7 04 28       	movzwl (%rax,%r13,1),%eax <-- trapping instruction
  2f:	89 44 24 2c          	mov    %eax,0x2c(%rsp)
  33:	e8 d5 81 3d fe       	callq  0xfe3d820d
  38:	31 ff                	xor    %edi,%edi
  3a:	41 89 c7             	mov    %eax,%r15d
  3d:	89 c6                	mov    %eax,%esi
  3f:	e8                   	.byte 0xe8


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
