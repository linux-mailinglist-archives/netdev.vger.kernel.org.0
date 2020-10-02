Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321042816D1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgJBPj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:39:26 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:39476 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387977AbgJBPjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:39:25 -0400
Received: by mail-io1-f77.google.com with SMTP id y16so1306494ioy.6
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=thVz47D+ewHcCRiHqE6CZAYqmjo84dU6/XXE/EE3p70=;
        b=K6Y6zd6ms4v7BZ1xQgRioomHu+t/746KZleZBIDxROOrWoRYk2FIz9/kLXPddNJmAZ
         DN2798kbnq8ckRsOOfiNQH7RkeX6wRkBw5kpGjPFB+jt5tH6n8oGR8C5+ALmTIroE6rR
         UpMvm8d2F0/gtga4sm6OCu8A+eiiI1SHNFiwL0Rl0Z2BJBuuL3GcJVDLCFakCf0dZ5Yc
         Shj/GhEFRVXkWSz8KRbtqbrkarZvnrZAlqMxAu7PEuMRsQ/Z6StoPo+8O4QkX30UUalY
         7IZ8LxeGFwm6DUQsdSlC2czZEeZ+XCGELSa/NWH215Uw/AYaISQuMCKnUSkjUJp6ub1E
         8a8A==
X-Gm-Message-State: AOAM531z9ZYvTKnyLIEts+GNVSnY9UEaF813sDQJJhKR/oPKgIqBVAWA
        9vBLNl3osfhALsC+8FzujyPwPLPuJXhzE9DSxjwko6a69eQV
X-Google-Smtp-Source: ABdhPJwOyOJFdJJGplZ3Udge/W8beEueAnxKMjyqXHlvj1kcABpbWcvMCO+MX09MH4OuKB1RzFgb4DtgkfLu5BfobwfoXPRO0bpQ
MIME-Version: 1.0
X-Received: by 2002:a92:cc92:: with SMTP id x18mr1383199ilo.63.1601653164538;
 Fri, 02 Oct 2020 08:39:24 -0700 (PDT)
Date:   Fri, 02 Oct 2020 08:39:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed022605b0b1efaa@google.com>
Subject: WARNING in ieee80211_bss_info_change_notify
From:   syzbot <syzbot+09d1cd2f71e6dd3bfd2c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fcadab74 Merge tag 'drm-fixes-2020-10-01-1' of git://anong..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16217b5b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e672827d2ffab1f
dashboard link: https://syzkaller.appspot.com/bug?extid=09d1cd2f71e6dd3bfd2c
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161112eb900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124fc533900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+09d1cd2f71e6dd3bfd2c@syzkaller.appspotmail.com

syz-executor423 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
wlan0: Failed check-sdata-in-driver check, flags: 0x4
WARNING: CPU: 1 PID: 6893 at net/mac80211/driver-ops.h:172 drv_bss_info_changed net/mac80211/driver-ops.h:172 [inline]
WARNING: CPU: 1 PID: 6893 at net/mac80211/driver-ops.h:172 ieee80211_bss_info_change_notify+0x2f4/0x3a0 net/mac80211/main.c:210
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6893 Comm: syz-executor423 Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 panic+0x2c0/0x800 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:drv_bss_info_changed net/mac80211/driver-ops.h:172 [inline]
RIP: 0010:ieee80211_bss_info_change_notify+0x2f4/0x3a0 net/mac80211/main.c:210
Code: d1 f9 49 8b 87 40 06 00 00 49 81 c7 60 06 00 00 48 85 c0 4c 0f 45 f8 48 c7 c7 14 2b 4f 89 4c 89 fe 89 ea 31 c0 e8 3c eb 62 f9 <0f> 0b e9 f3 fe ff ff e8 00 4c 91 f9 0f 0b e9 e7 fe ff ff 44 89 e1
RSP: 0018:ffffc900055e78d0 EFLAGS: 00010246
RAX: 195afe4c76626a00 RBX: 1ffff11012590bc1 RCX: ffff88809195a180
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000004 R08: ffffffff815e2810 R09: ffffed1015d262c0
R10: ffffed1015d262c0 R11: 0000000000000000 R12: ffff888092c85e08
R13: 0000000002000000 R14: dffffc0000000000 R15: ffff888092c84000
 ieee80211_set_mcast_rate+0x38/0x40 net/mac80211/cfg.c:2453
 rdev_set_mcast_rate net/wireless/rdev-ops.h:1212 [inline]
 nl80211_set_mcast_rate+0x215/0x2c0 net/wireless/nl80211.c:9911
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0xaf5/0xd70 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x442039
Code: e8 ac 00 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcd5724568 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442039
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000002000000000 R09: 0000002000000000
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
