Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE054322B8E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhBWNgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:36:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:56186 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhBWNgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:36:05 -0500
Received: by mail-il1-f197.google.com with SMTP id f2so5415382ils.22
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 05:35:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9b4tdGcjeYO+dcjhUmgTVdKPzbsa8NdN3vEboNTOw+k=;
        b=DLON3L/nYaBGtutfG5njByXnzr5Z1oSF365TZl/8ID6MrJC2tF+Q7HuB64t4NzmZUE
         jbeYPHiWT9mQq0Uw8opGwgwWtsk4zOHBtOkxo35JWhivXo9b2qtzYr3LaG8ann2rwqC5
         tI1pMg59jvEqCdEkipDCd8djYTIOeMS6u1vEE1LyG48mv7sg2yR64u3rKJSkQeEcxvuY
         qMyqFUI8H6uRfAhWPgOT4L+v96VkhIGh3G13ktIKYM7A0JHz0KSSjvAES8x+j1EYbgSK
         svQJgP/GNuHUFhFugTr+hLC5iMEqc7KmSlxO90gs0xaPLv4eS8OuK17IOrNfZ3kv9AyJ
         0AGg==
X-Gm-Message-State: AOAM532tI3uz30gd/nLPGT5/93mxXkUpDld+4apjGR+QToYl5YANdM5b
        7gmjo4RgIl7v+uyJWHw3Pssptm+QC1CDlgSeKVBwlQRaNG61
X-Google-Smtp-Source: ABdhPJzcZ42NDAXIQAbJiG8EO1nZuAkPTd+FJOhS07mjmWHDhOM1UnVV/Tp7nhuMNrdfqt7S5M2CwttqKSCqk8yXDeyVfO+YcwK4
MIME-Version: 1.0
X-Received: by 2002:a6b:4109:: with SMTP id n9mr445500ioa.43.1614087324381;
 Tue, 23 Feb 2021 05:35:24 -0800 (PST)
Date:   Tue, 23 Feb 2021 05:35:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b387305bc00fda6@google.com>
Subject: WARNING in ieee802154_get_llsec_params
From:   syzbot <syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144bedf2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a875029a795d230
dashboard link: https://syzkaller.appspot.com/bug?extid=cde43a581a8e5f317bc2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 1 PID: 11257 at kernel/locking/mutex.c:928 __mutex_lock_common kernel/locking/mutex.c:928 [inline]
WARNING: CPU: 1 PID: 11257 at kernel/locking/mutex.c:928 __mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1093
Modules linked in:
CPU: 1 PID: 11257 Comm: syz-executor.1 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:928 [inline]
RIP: 0010:__mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1093
Code: 08 84 d2 0f 85 a3 04 00 00 8b 05 b8 7c c2 04 85 c0 0f 85 12 f5 ff ff 48 c7 c6 00 8c 6b 89 48 c7 c7 c0 89 6b 89 e8 96 eb bc ff <0f> 0b e9 f8 f4 ff ff 65 48 8b 1c 25 00 f0 01 00 be 08 00 00 00 48
RSP: 0018:ffffc90002697068 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815be2a5 RDI: fffff520004d2dff
RBP: ffff8880125b8c50 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b74be R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffffff8a898fa0 R15: 0000000000000000
FS:  00007f12c496b700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000053e038 CR3: 000000002947b000 CR4: 0000000000350ee0
Call Trace:
 ieee802154_get_llsec_params+0x3f/0x70 net/mac802154/cfg.c:321
 rdev_get_llsec_params net/ieee802154/rdev-ops.h:241 [inline]
 nl802154_get_llsec_params+0xce/0x390 net/ieee802154/nl802154.c:745
 nl802154_send_iface+0x7cf/0xa70 net/ieee802154/nl802154.c:823
 nl802154_dump_interface+0x294/0x490 net/ieee802154/nl802154.c:860
 genl_lock_dumpit+0x60/0x90 net/netlink/genetlink.c:623
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2276
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2381
 genl_family_rcv_msg_dumpit+0x2af/0x310 net/netlink/genetlink.c:686
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f12c496b188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffffb9a9dcf R14: 00007f12c496b300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
