Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C8F268857
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgINJ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:29:57 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:33412 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgINJ3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:29:20 -0400
Received: by mail-io1-f79.google.com with SMTP id l22so10647180iol.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XNz8rAWRwDSB4qLa5Er/aLq5jf0OHNVN8KLrKvJxLcw=;
        b=FqmTQXDYCMRdxaNDpaK1CPjiFpRaiF55SmnUvtX0NqGeh9OyCMJrMacXD91yLIWGLk
         gRIMxPyNtUjOyXEfiyiZP/FcCOLzcNQB5/pLUZ1Ki4uqqfFbCU3MzUJQme3ka2Ze1y25
         L9SY7j9JHYDEw+NE6cbtZF75wWhF2ZvCDx6BBHjWQuw56m0qkWnlADkFX3uqW/tTVZWr
         JX4u1Tm9YQBCMRzUsPcr3nHWwZbYLi7QQ+wlNcaddYbJzMOVUZD+zEtXoYux82IUtKCM
         R0CvbK0SgQdqCxPGdruaIXKsqCb562fHZCc86mt43D+1zq4w/X6OA2CK0AVv6XlHW/9K
         ePgw==
X-Gm-Message-State: AOAM532nkNYBXugZ9kr9Qb59zLgRu9Yz2SXB59xuTurR1J8vnlG51sTv
        ADT56md45gek0oQsDdm0t7a/tryzUr+WylWoGAR3t65YTD7E
X-Google-Smtp-Source: ABdhPJxHShYTCq5VPvPNidXlRLuL3r8+sKhR33reRm7KxkvGkIlMeDayTVW4ju/EQonWWkqY9K1xaW5M0mcZ0GmOLjvH0sH2Dhj8
MIME-Version: 1.0
X-Received: by 2002:a02:a047:: with SMTP id f7mr12133531jah.31.1600075758907;
 Mon, 14 Sep 2020 02:29:18 -0700 (PDT)
Date:   Mon, 14 Sep 2020 02:29:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039349f05af42abf6@google.com>
Subject: kernel BUG at net/wireless/core.h:LINE!
From:   syzbot <syzbot+c6912b3cb4479c7fa902@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e4c26faa Merge tag 'usb-5.9-rc5' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1130fc43900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
dashboard link: https://syzkaller.appspot.com/bug?extid=c6912b3cb4479c7fa902
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6912b3cb4479c7fa902@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/wireless/core.h:112!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 16597 Comm: syz-executor.2 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:wiphy_to_rdev net/wireless/core.h:112 [inline]
RIP: 0010:wiphy_to_rdev net/wireless/core.h:110 [inline]
RIP: 0010:cfg80211_mlme_unregister_socket+0x51e/0xa80 net/wireless/mlme.c:590
Code: 7f 78 0f 94 c3 31 ff 89 de e8 9e 3c f2 f9 84 db 0f 84 c4 fd ff ff e8 51 40 f2 f9 e8 cb 68 7e f9 e9 b5 fd ff ff e8 42 40 f2 f9 <0f> 0b e8 3b 40 f2 f9 65 8b 1d b4 85 7f 78 bf 3f 00 00 00 89 de e8
RSP: 0018:ffffc900160f7bc0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8880148a0000
RDX: ffff8880295e0040 RSI: ffffffff87820d9e RDI: ffff888000158c10
RBP: ffff888000158c10 R08: 0000000000000001 R09: ffffffff8c5f5a17
R10: fffffbfff18beb42 R11: 0000000000000001 R12: ffff8880295000f8
R13: 00000000d44708d8 R14: ffff888000158c10 R15: 0000000000000000
FS:  000000000195a940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000016a3b73 CR3: 00000002184e8000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nl80211_netlink_notify net/wireless/nl80211.c:17292 [inline]
 nl80211_netlink_notify+0x377/0x970 net/wireless/nl80211.c:17265
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 __blocking_notifier_call_chain kernel/notifier.c:284 [inline]
 __blocking_notifier_call_chain kernel/notifier.c:271 [inline]
 blocking_notifier_call_chain kernel/notifier.c:295 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:292
 netlink_release+0xc51/0x1cf0 net/netlink/af_netlink.c:775
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416f41
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:000000000169fbe0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000416f41
RDX: 0000000000000000 RSI: ffffffff87f73c69 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffff8134b98a R09: 00000000274ea8f8
R10: 000000000169fcd0 R11: 0000000000000293 R12: 000000000118d940
R13: 000000000118d940 R14: ffffffffffffffff R15: 000000000118d12c
Modules linked in:
---[ end trace a8a42bc9a64facd3 ]---
RIP: 0010:wiphy_to_rdev net/wireless/core.h:112 [inline]
RIP: 0010:wiphy_to_rdev net/wireless/core.h:110 [inline]
RIP: 0010:cfg80211_mlme_unregister_socket+0x51e/0xa80 net/wireless/mlme.c:590
Code: 7f 78 0f 94 c3 31 ff 89 de e8 9e 3c f2 f9 84 db 0f 84 c4 fd ff ff e8 51 40 f2 f9 e8 cb 68 7e f9 e9 b5 fd ff ff e8 42 40 f2 f9 <0f> 0b e8 3b 40 f2 f9 65 8b 1d b4 85 7f 78 bf 3f 00 00 00 89 de e8
RSP: 0018:ffffc900160f7bc0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8880148a0000
RDX: ffff8880295e0040 RSI: ffffffff87820d9e RDI: ffff888000158c10
RBP: ffff888000158c10 R08: 0000000000000001 R09: ffffffff8c5f5a17
R10: fffffbfff18beb42 R11: 0000000000000001 R12: ffff8880295000f8
R13: 00000000d44708d8 R14: ffff888000158c10 R15: 0000000000000000
FS:  000000000195a940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30e29000 CR3: 00000002184e8000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
