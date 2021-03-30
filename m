Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0629734F2C6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhC3VIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:08:51 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:47867 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhC3VIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:08:24 -0400
Received: by mail-io1-f69.google.com with SMTP id t25so57179iog.14
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Lzi5bMKkls9Xd2UZQOCL76vuZtMRxKtuq8CWVbFaDwU=;
        b=rHRebFsbXDB+HNQmp3/+l11Zlik/YvQw53r5Lc6/ZsviqlY2zAykXnMnBEy99yX1cO
         SZRaHUHp7EJOJm7KjM4VJCNR7oc3SOBSx0c2hEODqzlcfrKb2548xdqv22APzIF4IgXU
         8cjGbTGG/3ZroXA/y9hyaxpKLXqnTAbs818g3dzmlN3qwQUyqOJMm8p0IDovRaHclUKv
         6PXjWLEDzWclxhGunDYVe06iTxB3SvDwBv2Egr11kJFWY3E5/xJxxm9LAzWxr2FoQPcG
         +k/huGJXNiKSYAnBCy+vCq/aVc6S5VnbBbbt/EQC621bKK0NRMMG3rpz4AQA/kpgcOJQ
         fzDA==
X-Gm-Message-State: AOAM532k8iwzM2wKVmNxd8mvgDW/YT3LicIOmzDkgRsbC3ng4PAcIncG
        44HhoqAiNYcFgpg5Mjc+WlIqeRLc+HEVETWklLUzAStzS/Va
X-Google-Smtp-Source: ABdhPJxj/cahfDX/Wrs5v8qHwLjSug1dsd7i2JNx264ZuSNHlwc4fNN+7j7Zxgj7fElQQLIMmGfwtAxqJMmwo+izYrOgnlk2QYCT
MIME-Version: 1.0
X-Received: by 2002:a02:6654:: with SMTP id l20mr196612jaf.55.1617138504084;
 Tue, 30 Mar 2021 14:08:24 -0700 (PDT)
Date:   Tue, 30 Mar 2021 14:08:24 -0700
In-Reply-To: <00000000000073afff05bbe9a54d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000016afc505bec766d3@google.com>
Subject: Re: [syzbot] WARNING in ieee802154_del_seclevel
From:   syzbot <syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, info@sophiescuban.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    37f368d8 lan743x: remove redundant intializations of point..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11ede3bed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=fbf4fc11a819824e027b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d31a11d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ca3611d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 1 PID: 8394 at kernel/locking/mutex.c:931 __mutex_lock_common kernel/locking/mutex.c:931 [inline]
WARNING: CPU: 1 PID: 8394 at kernel/locking/mutex.c:931 __mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1096
Modules linked in:
CPU: 1 PID: 8394 Comm: syz-executor533 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:931 [inline]
RIP: 0010:__mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1096
Code: 08 84 d2 0f 85 a3 04 00 00 8b 05 18 cb be 04 85 c0 0f 85 12 f5 ff ff 48 c7 c6 20 8b 6b 89 48 c7 c7 e0 88 6b 89 e8 b2 3b bd ff <0f> 0b e9 f8 f4 ff ff 65 48 8b 1c 25 00 f0 01 00 be 08 00 00 00 48
RSP: 0018:ffffc90002a2f3f8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888020b554c0 RSI: ffffffff815c51f5 RDI: fffff52000545e71
RBP: ffff8880195a4c90 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdf8e R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffc90002a2f5a8 R15: ffff888014580014
FS:  0000000001f49300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc43046ba8 CR3: 0000000011a5a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee802154_del_seclevel+0x3f/0x70 net/mac802154/cfg.c:382
 rdev_del_seclevel net/ieee802154/rdev-ops.h:284 [inline]
 nl802154_del_llsec_seclevel+0x1a7/0x250 net/ieee802154/nl802154.c:2093
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
RIP: 0033:0x440909
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc43047c38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 0000000000440909
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc43047dd8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403c10
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 00000000004004a0

