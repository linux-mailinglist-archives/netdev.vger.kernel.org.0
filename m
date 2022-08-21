Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A79959B13E
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 04:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiHUCE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 22:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiHUCE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 22:04:27 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421C117A83
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 19:04:26 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e2-20020a056e020b2200b002e1a5b67e29so5924009ilu.11
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 19:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=8DXCsqDwMlY8bkEPsMdGfPqYVLUcBI/2W2rtPo8M28Y=;
        b=f/EpHZoMvOS+ZGMmT+FdTSDN+VwW1V7cXwD+dN7zBCa7Y5ZJQmIaCh37pCHmILCOqQ
         lTwG0RPFDNPCzFlHHzfthVIZuXWySV9oQ01dDrSCuVFRTifq4pADuymsWz/NHZW+70Nq
         ZN+Xns6ndG433nlj6N0MQploROdGxxtKqkVRaaetBfcZ9pmyitPbemnBsE0UJTxAwZzk
         UZB/N7FoKqBvQTehOaeoq3gtVX4xaAG9V1qNw4DqBTPAi01hHL2OjNZyfCJk5MJ95Kol
         y9I+Jd5zKSkKDG3q/DrAkzJLXmMEZie8MCHEf9koGvek7M1sJdWTvk/bYR9D8gWbz17L
         pF7g==
X-Gm-Message-State: ACgBeo0yzzdmTR5ri2j9msMhwcO3WG51yDAj2VwEbqYk44Wanjd2RblO
        JbDYRwc9wXQVV+0tzI1WbfhZch1hT2mdRR+jblmu/clV+dOF
X-Google-Smtp-Source: AA6agR6pVg53ZXyKGtfREadSfTef7vhzkIS25thAsLMzDU8crgMXvGs7U2HlaFfQDP5oE4O+naLvwD5sJWGNFgxk4WYz12C4sZOW
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2482:b0:343:3ab0:4925 with SMTP id
 x2-20020a056638248200b003433ab04925mr6375704jat.173.1661047465474; Sat, 20
 Aug 2022 19:04:25 -0700 (PDT)
Date:   Sat, 20 Aug 2022 19:04:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002282c605e6b6c0e1@google.com>
Subject: [syzbot] upstream boot error: stack segment fault in __alloc_skb
From:   syzbot <syzbot+b8a1f71feb027c4e2f06@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
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

HEAD commit:    3cc40a443a04 Merge tag 'nios2_fixes_v6.0' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10720067080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f267ed4fb258122a
dashboard link: https://syzkaller.appspot.com/bug?extid=b8a1f71feb027c4e2f06
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b8a1f71feb027c4e2f06@syzkaller.appspotmail.com

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
stack segment: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-syzkaller-00017-g3cc40a443a04 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:__kmalloc_node_track_caller+0x17a/0x3f0 mm/slub.c:4955
Code: 00 48 c1 e8 3a 44 39 f0 0f 85 24 01 00 00 49 8b 3c 24 40 f6 c7 0f 0f 85 73 02 00 00 45 84 c0 0f 84 6c 02 00 00 41 8b 44 24 28 <48> 8b 5c 05 00 48 8d 4a 08 48 89 e8 65 48 0f c7 0f 0f 94 c0 a8 01
RSP: 0000:ffffc90000067858 EFLAGS: 00010202
RAX: 0000000000000800 RBX: 0000000000082cc0 RCX: 0000000000000000
RDX: 0000000000003088 RSI: 0000000000082cc0 RDI: 000000000003d960
RBP: ffff000000000000 R08: dffffc0000000001 R09: fffffbfff1c4ade6
R10: fffffbfff1c4ade6 R11: 1ffffffff1c4ade5 R12: ffff888012042140
R13: 0000000000082cc0 R14: 00000000ffffffff R15: 0000000000001000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000ca8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kmalloc_reserve net/core/skbuff.c:358 [inline]
 __alloc_skb+0x11d/0x620 net/core/skbuff.c:430
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 ctrl_build_mcgrp_msg net/netlink/genetlink.c:997 [inline]
 genl_ctrl_event+0x16f/0xc40 net/netlink/genetlink.c:1083
 genl_register_family+0x10df/0x1390 net/netlink/genetlink.c:432
 hwsim_init_netlink+0x21/0x9b drivers/net/wireless/mac80211_hwsim.c:4972
 init_mac80211_hwsim+0x185/0xa08 drivers/net/wireless/mac80211_hwsim.c:5285
 do_one_initcall+0xbd/0x2b0 init/main.c:1296
 do_initcall_level+0x168/0x218 init/main.c:1369
 do_initcalls+0x4b/0x8c init/main.c:1385
 kernel_init_freeable+0x43a/0x5c3 init/main.c:1611
 kernel_init+0x19/0x2b0 init/main.c:1500
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__kmalloc_node_track_caller+0x17a/0x3f0 mm/slub.c:4955
Code: 00 48 c1 e8 3a 44 39 f0 0f 85 24 01 00 00 49 8b 3c 24 40 f6 c7 0f 0f 85 73 02 00 00 45 84 c0 0f 84 6c 02 00 00 41 8b 44 24 28 <48> 8b 5c 05 00 48 8d 4a 08 48 89 e8 65 48 0f c7 0f 0f 94 c0 a8 01
RSP: 0000:ffffc90000067858 EFLAGS: 00010202
RAX: 0000000000000800 RBX: 0000000000082cc0 RCX: 0000000000000000
RDX: 0000000000003088 RSI: 0000000000082cc0 RDI: 000000000003d960
RBP: ffff000000000000 R08: dffffc0000000001 R09: fffffbfff1c4ade6
R10: fffffbfff1c4ade6 R11: 1ffffffff1c4ade5 R12: ffff888012042140
R13: 0000000000082cc0 R14: 00000000ffffffff R15: 0000000000001000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000ca8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 48 c1             	add    %cl,-0x3f(%rax)
   3:	e8 3a 44 39 f0       	callq  0xf0394442
   8:	0f 85 24 01 00 00    	jne    0x132
   e:	49 8b 3c 24          	mov    (%r12),%rdi
  12:	40 f6 c7 0f          	test   $0xf,%dil
  16:	0f 85 73 02 00 00    	jne    0x28f
  1c:	45 84 c0             	test   %r8b,%r8b
  1f:	0f 84 6c 02 00 00    	je     0x291
  25:	41 8b 44 24 28       	mov    0x28(%r12),%eax
* 2a:	48 8b 5c 05 00       	mov    0x0(%rbp,%rax,1),%rbx <-- trapping instruction
  2f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  33:	48 89 e8             	mov    %rbp,%rax
  36:	65 48 0f c7 0f       	cmpxchg16b %gs:(%rdi)
  3b:	0f 94 c0             	sete   %al
  3e:	a8 01                	test   $0x1,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
