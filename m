Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08573D1BB0
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 04:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhGVB3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 21:29:52 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36659 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhGVB3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 21:29:50 -0400
Received: by mail-il1-f199.google.com with SMTP id j13-20020a056e02218db02902141528bc7cso2668525ila.3
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 19:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MRVdo3BP1bfGw5Jrpums3dR51jXt/diLyZxT/ln8Sgw=;
        b=nET7+Z4Sovkgx7ALax0JbyU8qwXFo+qWs3zGn+43V0IAp0oHEqEIyNQpJauQxk6KYN
         Eb4QjXz+n2P/j+4Mt17EtyqcgcaM+GU4eGCqusKgu5dK0Q1gWREylZAhkfNmB3xQBe20
         RhLRMIthZYCetYoxPNbIiiENemoYvYVK5Xo7OziWG5r/zRviRhNXO976enhNfI9HnT+i
         XhvPVrUvq+EO3LIbCD4gZOFheXzjnncIa1VsHiLoOUObCpe8NQHeXkshVPwZmWykR7F3
         FLCY1RYTgksklwjihcVtK5BYmFDCe5c+OENEkKLkK/2Ek/HePr19uGRhdRwfSLV9w2o1
         CTPA==
X-Gm-Message-State: AOAM531/QONFD7Y+Xlie9/W4Tcn/2gResMpZhdszF6H7SlCqkQ5H9VIU
        5aGDWX1hxPUGjsQ+ZporYVqCbvtOzcJv5bdXKmL6Xq71lOtb
X-Google-Smtp-Source: ABdhPJzUl8h8RWguJgP1hh4+Fa0JSzaHhsIQzPR1aO9Qmj0Wg7bfZruedIEsxwi0atJinBStdSTzaFZxsr4N2+tjyW3MAjsfaBfv
MIME-Version: 1.0
X-Received: by 2002:a02:c491:: with SMTP id t17mr28709574jam.56.1626919825473;
 Wed, 21 Jul 2021 19:10:25 -0700 (PDT)
Date:   Wed, 21 Jul 2021 19:10:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000046837e05c7acca73@google.com>
Subject: [syzbot] WARNING in ieee80211_offchannel_return
From:   syzbot <syzbot+4c10031c63f173ea1dfc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    23d2b94043ca igmp: Add ip_mc_list lock in ip_check_mc_rcu
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16cde812300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
dashboard link: https://syzkaller.appspot.com/bug?extid=4c10031c63f173ea1dfc

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c10031c63f173ea1dfc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8308 at net/mac80211/offchannel.c:136 ieee80211_offchannel_return+0x3e6/0x4a0 net/mac80211/offchannel.c:136
Modules linked in:
CPU: 0 PID: 8308 Comm: syz-executor.4 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_offchannel_return+0x3e6/0x4a0 net/mac80211/offchannel.c:136
Code: 00 48 01 c6 e8 4b 04 e9 f8 e9 0e ff ff ff e8 01 96 f9 f8 31 d2 48 89 de 4c 89 e7 e8 34 b3 15 00 e9 f7 fe ff ff e8 ea 95 f9 f8 <0f> 0b e9 6c ff ff ff e8 ae 1d 40 f9 e9 51 fc ff ff 48 89 df e8 d1
RSP: 0018:ffffc900020f7230 EFLAGS: 00010212
RAX: 00000000000006ed RBX: 0000000000000001 RCX: ffffc90012282000
RDX: 0000000000040000 RSI: ffffffff887bf386 RDI: 0000000000000003
RBP: ffff888075980d20 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff887beffc R11: 0000000000000000 R12: ffff88807443c800
R13: ffff888075982968 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f1a294ca700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f02e832aab4 CR3: 0000000081623000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __ieee80211_scan_completed+0x776/0xef0 net/mac80211/scan.c:470
 ieee80211_scan_cancel+0x165/0x9b0 net/mac80211/scan.c:1277
 ieee80211_do_stop+0x1863/0x2050 net/mac80211/iface.c:384
 ieee80211_runtime_change_iftype net/mac80211/iface.c:1656 [inline]
 ieee80211_if_change_type+0x383/0x840 net/mac80211/iface.c:1694
 ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
 rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
 cfg80211_change_iface+0x335/0xf60 net/wireless/util.c:1073
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3923
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1a294ca188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000006
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe92760a3f R14: 00007f1a294ca300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
