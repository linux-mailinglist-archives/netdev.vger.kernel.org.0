Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42D6A5C49
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjB1Pr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjB1Pr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:47:57 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1D81BDA
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:47:52 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id y2-20020a929502000000b0031707c6b348so6131435ilh.8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:47:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gt8lq7568+EVyUrMnPGNdffNvJYxI0gAHeVl0IuRSnE=;
        b=kuT49CC+tNKGii93TNp6BWX7SD3KvxBjgfGAlk2X7dh/XWQdRNskCe6tad3KaPulsj
         yuxFua9mkWwjl4wQAHVkKMjmEP7FiBt4iIGKSE/U2gmmRWiOPEjpXKieqBlY40sNNrIA
         XHk7eEpVrpoSUFyNsmfIWe/FUmmoojyiorUFE7R4DY1/OYlEfNScj6btJh8OvAkhcAka
         zB5F0jnYPfIDiL9D7oIh46BPt7mRDseZTRW8VtHc2cNeS9mVIrNEu61snfcQPrQ7VjKW
         c25c9mMxMqoUlQ+lCe5bQ1faHAYwqQTxMEJhTr6iaXphmy+r0Kwr41hNqD32ake6YLz1
         CuGA==
X-Gm-Message-State: AO0yUKUwlZzpS47g1L8kzPe2BMOvwESoOmq8cmzm+53zY9pyDjerzxGa
        NJwKPp6l0jxgO/Wt2i6LK67EWjYMQDhUf7HOiwesqxZW9WZI
X-Google-Smtp-Source: AK7set8yHjWVUzn9dIsXcm1TN0i2BaWYdkR2sjRr+YMpQJdX0d03vK7vnxXMsWKZvv2orygFDfT7Cah467yFPuXbGWvvuYDjURWT
MIME-Version: 1.0
X-Received: by 2002:a92:cdac:0:b0:317:6eac:97e1 with SMTP id
 g12-20020a92cdac000000b003176eac97e1mr2309027ild.0.1677599271874; Tue, 28 Feb
 2023 07:47:51 -0800 (PST)
Date:   Tue, 28 Feb 2023 07:47:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000acf9bb05f5c4848e@google.com>
Subject: [syzbot] [wireless?] WARNING in ieee80211_link_info_change_notify (2)
From:   syzbot <syzbot+de87c09cc7b964ea2e23@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    489fa31ea873 Merge branch 'work.misc' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1592ceacc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbfa7a73c540248d
dashboard link: https://syzkaller.appspot.com/bug?extid=de87c09cc7b964ea2e23
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf19a8c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bdf254c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8121ff3f8044/disk-489fa31e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ba8296ba1bf7/vmlinux-489fa31e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6459f50e23f3/bzImage-489fa31e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de87c09cc7b964ea2e23@syzkaller.appspotmail.com

netlink: 'syz-executor242': attribute type 27 has an invalid length.
------------[ cut here ]------------
wlan1: Failed check-sdata-in-driver check, flags: 0x0
WARNING: CPU: 0 PID: 5072 at net/mac80211/main.c:287 ieee80211_link_info_change_notify+0x1b6/0x220 net/mac80211/main.c:287
Modules linked in:
CPU: 0 PID: 5072 Comm: syz-executor242 Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:ieee80211_link_info_change_notify+0x1b6/0x220 net/mac80211/main.c:287
Code: e0 e4 b7 f7 49 8b 86 f8 08 00 00 49 81 c6 18 09 00 00 48 85 c0 4c 0f 45 f0 48 c7 c7 e0 57 0d 8c 4c 89 f6 89 ea e8 9a 2b 28 f7 <0f> 0b e9 3a ff ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c c9 fe ff
RSP: 0018:ffffc90003c5f348 EFLAGS: 00010246
RAX: dbfb579b07df7200 RBX: 0000000002000000 RCX: ffff88807a840000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff81536fb2 R09: ffffed101730515b
R10: 0000000000000000 R11: dffffc0000000001 R12: ffff8880763c0de0
R13: dffffc0000000000 R14: ffff88807c3cc000 R15: ffff88807c3ce230
FS:  0000555555a97300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001384 CR3: 00000000795c5000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ieee80211_set_mcast_rate+0x46/0x50 net/mac80211/cfg.c:2872
 rdev_set_mcast_rate net/wireless/rdev-ops.h:1220 [inline]
 nl80211_set_mcast_rate+0xb77/0xfb0 net/wireless/nl80211.c:11399
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0xc33/0xf90 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x1df/0x430 net/netlink/af_netlink.c:2574
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x7c3/0x990 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0xa2a/0xd60 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:722 [inline]
 sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x58f/0x890 net/socket.c:2504
 ___sys_sendmsg net/socket.c:2558 [inline]
 __sys_sendmsg+0x2ad/0x390 net/socket.c:2587
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5b7bb5d2a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc05f7c888 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f5b7bb5d2a9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000c00000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000031
R13: 00007ffc05f7c8f0 R14: 00007ffc05f7c8e0 R15: 00007f5b7bbd7410
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
