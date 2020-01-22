Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98573144C20
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 07:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgAVG5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 01:57:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:42711 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVG5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 01:57:09 -0500
Received: by mail-il1-f198.google.com with SMTP id c5so4128489ilo.9
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 22:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DaAO4OjrKFz8R/CBeO0tJNgxF+hhPU+pNFucr/6aoXM=;
        b=BVdVF6MXZmKGqsK81tLk08RNa1UydR/5Nz2V8sVH3TO8uUY64/9K15AehQRJ1ayEp1
         Jyx8iaJXpXMYEuz4Lbm8Lo6DVz74ESTJ7B4+8ve5Y2Ys15bOY+PLqC5Q5GJ8Ylkw6OYJ
         Pie6wR6qSMyHIASojXAqeJYgriqJmeeH/B/paes18XaP7Jknv198USoehRH7mv3vbrJ7
         QBk+kdLGZ0z3UspFAg5Zf2LKznbKTR1DFDNDxn8y2bNRn0FU1vSxBIcb6sjGdpCTTrtB
         vPHYnB+qEHDp+JavznIaYD9iJcx4mG9G9GDsuIskxh1syY91bn6557XLhwvttBnijIaJ
         +r+A==
X-Gm-Message-State: APjAAAWRq/vLxO9RO/hhuRfdxSUQT6SRz2SIw6pDPEOxTzm2aA3cwMT8
        SMy38o2Jil6/7N6R3wU0SkDR06/V8cwW2fGomGf02+gUJcev
X-Google-Smtp-Source: APXvYqwBMu6JpRpoxuoWYTHGSxoNuVl3TJEsvhwJ8YNOwZ/e2BBZAW5YXxENYOLMTaOhLpY3iZWCAPpAY6UqfmN3GG/pvEmV/Jpr
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2b7:: with SMTP id d23mr5984287jaq.108.1579676228910;
 Tue, 21 Jan 2020 22:57:08 -0800 (PST)
Date:   Tue, 21 Jan 2020 22:57:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007c3ba2059cb50843@google.com>
Subject: WARNING in cbq_destroy
From:   syzbot <syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144f7601e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=63bdb6006961d8c917c6
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a1a721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a91a95e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com

netlink: 96 bytes leftover after parsing attributes in process `syz-executor899'.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 8828 at net/sched/sch_cbq.c:1437 cbq_destroy_class net/sched/sch_cbq.c:1437 [inline]
WARNING: CPU: 1 PID: 8828 at net/sched/sch_cbq.c:1437 cbq_destroy+0x324/0x400 net/sched/sch_cbq.c:1471
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8828 Comm: syz-executor899 Not tainted 5.5.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 panic+0x264/0x7a9 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1b6/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xda/0x440 arch/x86/kernel/traps.c:267
 do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:cbq_destroy_class net/sched/sch_cbq.c:1437 [inline]
RIP: 0010:cbq_destroy+0x324/0x400 net/sched/sch_cbq.c:1471
Code: 32 3d fb eb 06 90 e8 db 85 01 fb 49 8d 5f f8 4d 85 ff 49 0f 44 df 48 85 db 74 4b e8 c6 85 01 fb e9 01 ff ff ff e8 bc 85 01 fb <0f> 0b e9 47 ff ff ff 44 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 1a ff
RSP: 0018:ffffc900078472b0 EFLAGS: 00010293
RAX: ffffffff8674f7c4 RBX: ffff8880a7ef2320 RCX: ffff8880a25a2580
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90007847308 R08: ffffffff8674f704 R09: fffffbfff13cd120
R10: fffffbfff13cd120 R11: 0000000000000000 R12: ffff8880a7ef22c0
R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000000
 qdisc_destroy+0x147/0x4c0 net/sched/sch_generic.c:958
 qdisc_put+0x83/0xf0 net/sched/sch_generic.c:985
 notify_and_destroy net/sched/sch_api.c:995 [inline]
 qdisc_graft+0xcc8/0x11f0 net/sched/sch_api.c:1076
 tc_modify_qdisc+0xddd/0x1d90 net/sched/sch_api.c:1663
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 kernel_sendmsg+0x109/0x140 net/socket.c:679
 sock_no_sendpage+0x100/0x140 net/core/sock.c:2740
 kernel_sendpage net/socket.c:3776 [inline]
 sock_sendpage+0xd3/0x120 net/socket.c:937
 pipe_to_sendpage+0x238/0x320 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x33d/0x870 fs/splice.c:636
 splice_from_pipe fs/splice.c:671 [inline]
 generic_splice_sendpage+0x114/0x180 fs/splice.c:844
 do_splice_from fs/splice.c:863 [inline]
 do_splice fs/splice.c:1170 [inline]
 __do_sys_splice fs/splice.c:1447 [inline]
 __se_sys_splice+0x719/0x1ac0 fs/splice.c:1427
 __x64_sys_splice+0xe5/0x100 fs/splice.c:1427
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446e79
Code: e8 5c b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa4f9aa3d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00000000006dcc98 RCX: 0000000000446e79
RDX: 0000000000000009 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00000000006dcc90 R08: 000000000004ffe0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc9c
R13: 00000000004aed8e R14: 54c6c2ff093a6d32 R15: 0000000000010000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
