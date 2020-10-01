Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E856427FD49
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgJAK2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:28:20 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:46360 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731647AbgJAK2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:28:19 -0400
Received: by mail-io1-f79.google.com with SMTP id a2so2762695iod.13
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 03:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/gRHChS+roFslhUKPLCtpF9Kz+ORaa/x7ZKv8fOXc4o=;
        b=bDW+FYd1DURET/P9Gr1bPec/wvTVD2Hv0t3e6f80RDgCFPZ5inlMIOKL6RQleL5+Id
         Vk8mNmM8c70HxjU7ajNlXGd0fOPoKj/4sRNlAd52VTGc+DV8zaR5kI44EMhOSXJCqTgG
         7IcVyPbmcxyxfauiyTyjjlI004Mjsl7s7FyQTqGCWyYonZ6jJEv7dJwM8+u0fbn7kMa0
         nU+zP0bZ73PGtlkMnXuWTeP6j7zNrICdeLuaXov/TARl58TFMHzToZE7uL9sEryYXxga
         CMiYnMjF5ob70hsa53+gcF94gyRJUcxqDbNIbQBOeQktyJMLv/e18wOv0fAWYFLqprOt
         OgjQ==
X-Gm-Message-State: AOAM5323n8NVAD8ixA8meeyV3FpFMCaNYgj3mOXnS3U6C9UP474QAapH
        OU5lnLVlJIveJXtrOOShlLUUpth6jhCB/484obMDrCsVMIaP
X-Google-Smtp-Source: ABdhPJwLse6qUMuEyyMcPgXI+MKxUxri5krnpHdh9hdpJhZNW/Zt/4cFZSynn5O5CeOjzZGhHmk664zBigpIbmtb+iEhshOFubni
MIME-Version: 1.0
X-Received: by 2002:a92:dacb:: with SMTP id o11mr1714886ilq.67.1601548098154;
 Thu, 01 Oct 2020 03:28:18 -0700 (PDT)
Date:   Thu, 01 Oct 2020 03:28:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b357405b099798f@google.com>
Subject: WARNING in cfg80211_connect
From:   syzbot <syzbot+5f9392825de654244975@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    60e72093 Merge tag 'clk-fixes-for-linus' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12adca47900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e0df28c181f1b6d
dashboard link: https://syzkaller.appspot.com/bug?extid=5f9392825de654244975
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f9392825de654244975@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 17631 at net/wireless/sme.c:533 cfg80211_sme_connect net/wireless/sme.c:533 [inline]
WARNING: CPU: 0 PID: 17631 at net/wireless/sme.c:533 cfg80211_connect+0x1432/0x2010 net/wireless/sme.c:1258
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 17631 Comm: syz-executor.1 Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:cfg80211_sme_connect net/wireless/sme.c:533 [inline]
RIP: 0010:cfg80211_connect+0x1432/0x2010 net/wireless/sme.c:1258
Code: 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 a2 0a 00 00 49 83 bd 48 01 00 00 00 0f 84 b6 f7 ff ff e8 ce 82 c2 f9 <0f> 0b e8 c7 82 c2 f9 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90008ad7340 EFLAGS: 00010212
RAX: 0000000000000499 RBX: 0000000000000000 RCX: ffffc90002c73000
RDX: 0000000000040000 RSI: ffffffff87b3bbc2 RDI: ffffffff895f55e0
RBP: ffff8880578d0d30 R08: 0000000000000001 R09: ffff8880578d0d35
R10: ffffed100af1a1a6 R11: 0000000000000000 R12: ffffc90008ad74e0
R13: ffff8880578d0c10 R14: ffff8880578d0d58 R15: ffffffff895f54a0
 nl80211_connect+0x1646/0x2220 net/wireless/nl80211.c:10392
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x60/0x90 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fcd549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55c70bc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000340
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
