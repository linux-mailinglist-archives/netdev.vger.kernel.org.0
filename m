Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D696307B9C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhA1RAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:00:04 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:52010 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhA1Q7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:59:04 -0500
Received: by mail-io1-f72.google.com with SMTP id y20so4666587ioy.18
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yHR4pCE/W7QS+DPSKPkNiMts5F725B7gfmojeRI0ao4=;
        b=C7LdvvxAVt/UtIwuhw+gUHkKd5j0Bzpfv3Q5ci3nDimjy783vibMAEmAtvm3uWF/Rt
         Z2R2uAY7xQ9EFJonyxwDPKJ9qxC5ywWaNH7fwAg7MT70/zB5j/Hp/D5y0Pimb6GwexfR
         96J2pUCwX1KVO7sLBGQGRqtsMVEndz5mQFRCLBjcP9h9V+vfbyzQhr2qIKNs4kfX0SgY
         ooy0in40pQVVgCfECGVmQckgH3oCAnk5/n79Nn1KnHgyMHQ5M68qu9oD2EI3602ognz6
         x5LTiRbce4hUadE5Xj+leEnaNbwPiOGsps2aKQ1tuQ02OJw5z8CMn2xmlbbQyEZnly6k
         DbsQ==
X-Gm-Message-State: AOAM531ESTcT2AqFhUApABOTNuF4ddB/2/NW/CQAqH8wZTmeNct2oXgi
        UALNldk4RNOXSqajsow0hfAWK/m+2tzigZGrkX/9YjaAzFae
X-Google-Smtp-Source: ABdhPJwM3LuJJ/YwC8tCeeJ0Htq5Yf5bMGXJ8EBz8+wSQqjjJucZx+eIN38q39fTfDU10XTF9PyFYMEd39JFh9ZeJnsnVagIjmPP
MIME-Version: 1.0
X-Received: by 2002:a02:b38f:: with SMTP id p15mr151485jan.83.1611853103318;
 Thu, 28 Jan 2021 08:58:23 -0800 (PST)
Date:   Thu, 28 Jan 2021 08:58:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a74f5b05b9f8cb83@google.com>
Subject: WARNING in cfg80211_dev_rename
From:   syzbot <syzbot+ed107c5fa3e21cdcd86e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d1f3bdd4 net: dsa: rtl8366rb: standardize init jam tables
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15d2308cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5f48fca2e44a9a2
dashboard link: https://syzkaller.appspot.com/bug?extid=ed107c5fa3e21cdcd86e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1248bc54d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12174ad8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed107c5fa3e21cdcd86e@syzkaller.appspotmail.com

netlink: 4 bytes leftover after parsing attributes in process `syz-executor171'.
------------[ cut here ]------------
RTNL: assertion failed at net/wireless/core.c (131)
WARNING: CPU: 1 PID: 8485 at net/wireless/core.c:131 cfg80211_dev_rename+0x1f5/0x230 net/wireless/core.c:131
Modules linked in:
CPU: 1 PID: 8485 Comm: syz-executor171 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_dev_rename+0x1f5/0x230 net/wireless/core.c:131
Code: 0f 85 5b fe ff ff e8 ca 92 3e f9 ba 83 00 00 00 48 c7 c6 e0 52 61 8a 48 c7 c7 20 53 61 8a c6 05 df 5c bb 04 01 e8 88 05 86 00 <0f> 0b e9 30 fe ff ff e8 4f 70 81 f9 e9 4d fe ff ff e8 45 70 81 f9
RSP: 0018:ffffc900015ef488 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffc900015ef680 RCX: 0000000000000000
RDX: ffff888021490000 RSI: ffffffff815b6d25 RDI: fffff520002bde83
RBP: ffff88801b498000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815afefe R11: 0000000000000000 R12: 0000000000000000
R13: ffff888013a58420 R14: ffff88801b4ecbd0 R15: ffff88801b498000
FS:  0000000001f55880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faf23dcc000 CR3: 000000001c3ca000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nl80211_set_wiphy+0x22b/0x2b80 net/wireless/nl80211.c:3231
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440a29
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe71735868 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440a29
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000402010
R13: 00000000004020a0 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
