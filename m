Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6A28481F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgJFIIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:08:30 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:49805 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgJFIIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:08:25 -0400
Received: by mail-io1-f78.google.com with SMTP id 140so3834899iou.16
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 01:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vsr+coIcVgClKoMDt/6umhRFqiKF3X7GLy13qBxsSLY=;
        b=hsLyu07TWKhKd9rDHTbqVr6D1zUhCGbCOdr5+bvRI1kzziYjejXuP6OcdH+boq6tzI
         tRVBndc+UN39Hc7An/E0NwX1xEdwN3zlcAksf1TLniJmkBICzkjxszZzYxR0jZNzW2HA
         Bzxg6BWcPPNV1C7Sl7FXWQtpsykU17S87EjcY0RpaHhKo6BuiE0Ey5znApgVYhEghYTP
         C5OzB6bDwJpSTHUM8bolsTBWOWuDpNBGqKC4tLQoAeD7U8scxCv06BHxwEuYu8iihAZS
         plq5m24RRk1nop33TgKwKsAImlarKManXIrmp/zw+lqJRYkpKURjbBPCrfu8q62UPtI0
         4KKA==
X-Gm-Message-State: AOAM532EzRE6sB+1v20lD2Sbfz/4taP1GvV+LnH2GAmKfD9bwFyHgNU4
        HZTfJpU1YN8+TwveGojIuPbZkglS6f95Utdus/buRX4SI2h/
X-Google-Smtp-Source: ABdhPJwkcuklznSh8d1ENaTIB5adIDKUraspGVNC3cc2nSICp4wdmBfo9/Uss/WSm6WrakPgBuYzdmk9xBnTZjiUcjhs7FewyqNH
MIME-Version: 1.0
X-Received: by 2002:a6b:e714:: with SMTP id b20mr127393ioh.109.1601971704270;
 Tue, 06 Oct 2020 01:08:24 -0700 (PDT)
Date:   Tue, 06 Oct 2020 01:08:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005f92b905b0fc1a5d@google.com>
Subject: WARNING in ieee80211_check_rate_mask
From:   syzbot <syzbot+be0e03ca215b06199629@syzkaller.appspotmail.com>
To:     clang-built-linux@googlegroups.com, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c2568c8c Merge branch 'net-Constify-struct-genl_small_ops'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16e2fb4d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1e6c5266df853ae
dashboard link: https://syzkaller.appspot.com/bug?extid=be0e03ca215b06199629
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1790e83b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111a5bc7900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+be0e03ca215b06199629@syzkaller.appspotmail.com

netlink: 20 bytes leftover after parsing attributes in process `syz-executor823'.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6878 at net/mac80211/rate.c:281 ieee80211_check_rate_mask+0x1af/0x220 net/mac80211/rate.c:281
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6878 Comm: syz-executor823 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:ieee80211_check_rate_mask+0x1af/0x220 net/mac80211/rate.c:281
Code: 45 85 ff 0f 84 86 0c 00 00 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f e9 bf 8c a1 f9 e8 ba 8c a1 f9 0f 0b eb e4 e8 b1 8c a1 f9 <0f> 0b eb db e8 e8 4f e3 f9 e9 f6 fe ff ff 48 89 ef e8 db 4f e3 f9
RSP: 0018:ffffc900055274b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88808a7d0c00 RCX: ffffffff87d4fa14
RDX: ffff888091b2e000 RSI: ffffffff87d4faff RDI: 0000000000000005
RBP: 0000000000000000 R08: ffff88808a7d1e58 R09: ffff888091b2e900
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000ffffffff R14: ffff88808a7d0c00 R15: 0000000000000000
 ieee80211_change_bss+0x53c/0xc20 net/mac80211/cfg.c:2314
 rdev_change_bss net/wireless/rdev-ops.h:394 [inline]
 nl80211_set_bss+0x76c/0xc70 net/wireless/nl80211.c:7009
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4419c9
Code: e8 dc 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 0d fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdbf57fbe8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004419c9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 000000306e616c77 R08: 0000000000000000 R09: 0000002000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000032
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
