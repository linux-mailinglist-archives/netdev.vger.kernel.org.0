Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1101C35A274
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhDIP6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:58:31 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:34699 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhDIP6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:58:30 -0400
Received: by mail-il1-f197.google.com with SMTP id l7so3757051iln.1
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 08:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GIohHUbCgzTSJND56+4iG4z/4sF+r+F4DISktHzbcmM=;
        b=YqAQ3mz8AQZ5axbxvcGAjJmMN/kdqgMQFopnOcb/5nxOdSnJtsXugPV3K8y7iiDHJa
         HZfPkhB/yrqPHS3jrO4dsVmWm9k7MuARyeHZQu/AkOYyc4iKmg0xolSoqgwTBa2Xip+s
         JuMEBSPk2ZdwqXWmGlAE0Nm4aIiYW553m0O1cGWq7av+tc2yETV04G3V6JywCuihCWyO
         O/kZYxY29NhsZQilynPSbFRr8Tt0RyzpyxXKB9rYxeHVnsb8Nq56pHB+cOZgrm0LsF5f
         AVW4AY5CYXPiFegFX22iV+EACwLYJ5smLgU7X31MlqdRKVBjtyS0K1d6vC3QaWvxGlZz
         46UQ==
X-Gm-Message-State: AOAM532HAw+aajIzO03XQhLnGbQ1kGBttl5uJI/xGDQlkbB9qZDikHjv
        A1/av+B/FLQ+rCiZMYe8RJMLTMhLJAnPP0Xr+ycm8fhKOHF2
X-Google-Smtp-Source: ABdhPJyxdIgsSf4hTenIxLpv1fZfb7HUrW3oz28Sm+d+/95yeWOMDn0i9TZCsUY+Zn3rMDogMIDoQSkdZnbnMnTlE1azOLGlT98a
MIME-Version: 1.0
X-Received: by 2002:a92:c549:: with SMTP id a9mr12177389ilj.300.1617983897560;
 Fri, 09 Apr 2021 08:58:17 -0700 (PDT)
Date:   Fri, 09 Apr 2021 08:58:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000776f4105bf8c3bca@google.com>
Subject: [syzbot] WARNING in ieee802154_del_device
From:   syzbot <syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com>
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

HEAD commit:    08c27f33 batman-adv: initialize "struct batadv_tvlv_tt_vla..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=111688fcd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=bf8b5834b7ec229487ce
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176af0e2d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11fcb16ed00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 0 PID: 8389 at kernel/locking/mutex.c:931 __mutex_lock_common kernel/locking/mutex.c:931 [inline]
WARNING: CPU: 0 PID: 8389 at kernel/locking/mutex.c:931 __mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1096
Modules linked in:
CPU: 1 PID: 8389 Comm: syz-executor116 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:931 [inline]
RIP: 0010:__mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1096
Code: 08 84 d2 0f 85 a3 04 00 00 8b 05 78 80 c0 04 85 c0 0f 85 12 f5 ff ff 48 c7 c6 20 8b 6b 89 48 c7 c7 e0 88 6b 89 e8 12 3d bd ff <0f> 0b e9 f8 f4 ff ff 65 48 8b 1c 25 00 f0 01 00 be 08 00 00 00 48
RSP: 0018:ffffc90001aaf3d8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801ac8d4c0 RSI: ffffffff815c4d15 RDI: fffff52000355e6d
RBP: ffff888022324c90 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdaae R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffc90001aaf8b0 R15: 0000000000000000
FS:  000000000082e300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000088 CR3: 0000000018643000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee802154_del_device+0x3f/0x70 net/mac802154/cfg.c:412
 rdev_del_device net/ieee802154/rdev-ops.h:299 [inline]
 nl802154_del_llsec_dev+0x22f/0x310 net/ieee802154/nl802154.c:1767
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43fd19
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcff3b4778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fd19
RDX: 0000000000040000 RSI: 00000000200002c0 RDI: 0000000000000004
RBP: 0000000000403780 R08: 0000000000000008 R09: 00000000004004a0
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000403810
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
