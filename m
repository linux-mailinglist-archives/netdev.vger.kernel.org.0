Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2139B9C5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFDNZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:25:17 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:39723 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhFDNZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 09:25:17 -0400
Received: by mail-il1-f199.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so6456989ilc.6
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 06:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Fh24XHn46QTE70Fu59zKbxgTcJCyyRl/2Zjm/XtlHpE=;
        b=Kfpl6e6trWv8DRysFadhxcK1wO2fe2daxtc/7NoFqXOI+IM0Ui1TsFWjDagUguiE5W
         aFfNc99dzQ/BdHXFMuWWKV3t2CPfl0ANvJGCEZehq4+XXYMNCwrvAKFD2E4u57qZ0mWP
         YkaVnmuFu/dyZjJ3mdwsTxRKPKZH78jD/f5WzKiSkl/KXsssivV8Lqlze5q3kQIq/Ocf
         iLtnFJZpN7wOlgBOYE+1bAQj+oST4q9fxDlF68VFHZXEPTP4Kiz2nt4sdqY4cLYOtnPw
         XlefWJkWLhr9hOlrXfFHgdc/p5uspCus+36rxdt4KqiUlypKJqGJ7MjoM7zm9OFeiX+N
         w6sg==
X-Gm-Message-State: AOAM531HRXIjTOjMDuHQgqn0kMM7kqd7r/3/S1YzIRqCKMoClpkYkrXN
        9KaED+oQlDcmyGm1X5qV1NtgZ165h+AdOOgzM7hjIUqYXnkA
X-Google-Smtp-Source: ABdhPJxWXuAhWz8YN5zGxhVMy7R/J0EnN7+wawXQeUd+tZuHM5Xi61MX38v2juDYAsq9D4/IFOzNvIe4IXdEfR/XlXIxAxF8jD2b
MIME-Version: 1.0
X-Received: by 2002:a5e:c708:: with SMTP id f8mr3818934iop.198.1622813010489;
 Fri, 04 Jun 2021 06:23:30 -0700 (PDT)
Date:   Fri, 04 Jun 2021 06:23:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006f82905c3f099be@google.com>
Subject: [syzbot] WARNING in ieee80211_vif_release_channel
From:   syzbot <syzbot+c299bc8bf2c766623e9c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a729b8e6 Merge branch 'fixes-for-yt8511-phy-driver'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17bbd313d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=52fb5f4163b9aa88
dashboard link: https://syzkaller.appspot.com/bug?extid=c299bc8bf2c766623e9c

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c299bc8bf2c766623e9c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 22187 at net/mac80211/chan.c:1830 ieee80211_vif_release_channel+0x1ad/0x220 net/mac80211/chan.c:1830
Modules linked in:
CPU: 1 PID: 22187 Comm: syz-executor.4 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_vif_release_channel+0x1ad/0x220 net/mac80211/chan.c:1830
Code: c1 ea 03 80 3c 02 00 0f 85 82 00 00 00 48 8b ab 48 06 00 00 e9 60 ff ff ff e8 6f b1 fa f8 0f 0b e9 e2 fe ff ff e8 63 b1 fa f8 <0f> 0b 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02
RSP: 0018:ffffc9000a837050 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff88802739cc00 RCX: ffffc90012325000
RDX: 0000000000040000 RSI: ffffffff887a2b1d RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff887a2adc R11: 0000000000000000 R12: ffff88802739d248
R13: 0000000000000001 R14: 00000000fffffff4 R15: 0000000000000000
FS:  00007fe9d16b1700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c71cee000 CR3: 0000000077555000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee80211_start_ap+0x18ed/0x24e0 net/mac80211/cfg.c:1200
 rdev_start_ap net/wireless/rdev-ops.h:158 [inline]
 nl80211_start_ap+0x1c17/0x2920 net/wireless/nl80211.c:5515
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe9d16b1188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00007fe9d16b11d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe90e7d1bf R14: 00007fe9d16b1300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
