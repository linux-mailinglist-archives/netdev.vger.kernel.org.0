Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5186A3E0B32
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 02:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhHEAbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 20:31:32 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33534 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhHEAbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 20:31:32 -0400
Received: by mail-il1-f197.google.com with SMTP id d6-20020a056e020506b0290208fe58bd16so1832869ils.0
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 17:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TzhBp9lwKEy0vU08GWUBMtKPPyabEbnU7H1ncbPlilY=;
        b=KBSQZlpnC2douFPqxX1Gk3knU0uyQe4BxLZ9CMDHTREVfSPiTRSJoLjjs64/ALKA1x
         FBLohHKhhQbqyPsX7IsZczBUFaijORO0ad48a6G2oKD8ZoXQkFAb/zd00pk3k8xI4PM/
         FW1OuLyx8laXQG/5pZDeuse+TQCT6gNXazgRzt0pZGs2GrpDI0oLrYqdNSJpASoMxt4C
         fB7Xs7UpvFp1kdqrEBHhzgDaWmMCoSf6C86VsmKtCC5Lu02xewzfWfHPIWRtC2zLgTai
         TaT1dAEIBt0xotW7ai+tOLi3NqsNlUuhtzpsBLxnOuwGTfqD/fj4kOur5TA8KJTu6YsI
         5RpA==
X-Gm-Message-State: AOAM531Zzq8mrXMKUKZQRU6LsdxT5lWHz/LqUxju808nX75psa/a1QS8
        SpV24n9PkzNgTYRZSjZECWGalvA9i1Dmiabs4oFA/4kO7BX9
X-Google-Smtp-Source: ABdhPJzg2Oo0b/7zSDsHoqoXsBjybiMLrIObPvfasJjZaMXlkxAARHGfJl71xxYAAew6Vha8WVoW60x5tBf5pyLdzNrqBH2tdsQs
MIME-Version: 1.0
X-Received: by 2002:a05:6638:35aa:: with SMTP id v42mr1956961jal.21.1628123477537;
 Wed, 04 Aug 2021 17:31:17 -0700 (PDT)
Date:   Wed, 04 Aug 2021 17:31:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000877ae505c8c5092d@google.com>
Subject: [syzbot] WARNING in netlink_sock_destruct
From:   syzbot <syzbot+987e85fbd9c71706c130@syzkaller.appspotmail.com>
To:     0x7f454c46@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f3438b4c4e69 Merge tag '5.14-rc3-smb3-fixes' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127416d4300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bfd78f4abd4edaa6
dashboard link: https://syzkaller.appspot.com/bug?extid=987e85fbd9c71706c130
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+987e85fbd9c71706c130@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1042 at net/netlink/af_netlink.c:410 netlink_sock_destruct+0x230/0x2b0 net/netlink/af_netlink.c:410
Modules linked in:
CPU: 0 PID: 1042 Comm: syz-executor.0 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:netlink_sock_destruct+0x230/0x2b0 net/netlink/af_netlink.c:410
Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 8a 00 00 00 48 83 bd d8 04 00 00 00 75 15 5b 5d 41 5c e9 a5 3a 22 fa e8 a0 3a 22 fa <0f> 0b e9 68 ff ff ff e8 94 3a 22 fa 0f 0b 5b 5d 41 5c e9 89 3a 22
RSP: 0018:ffffc90000007d90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000407 RCX: 0000000000000100
RDX: ffff88808faa8000 RSI: ffffffff875360c0 RDI: 0000000000000003
RBP: ffff888000170000 R08: 0000000000000000 R09: ffff88800017020b
R10: ffffffff87536027 R11: 0000000000000000 R12: ffff888000170208
R13: ffff888000170030 R14: 0000000000000002 R15: ffff888000170688
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0063) knlGS:00000000f552db40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002e826000 CR3: 00000000938ef000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __sk_destruct+0x4b/0x900 net/core/sock.c:1900
 sk_destruct+0xbd/0xe0 net/core/sock.c:1944
 __sk_free+0xef/0x3d0 net/core/sock.c:1955
 sk_free+0x78/0xa0 net/core/sock.c:1966
 deferred_put_nlk_sk+0x151/0x2f0 net/netlink/af_netlink.c:740
 rcu_do_batch kernel/rcu/tree.c:2550 [inline]
 rcu_core+0x7ab/0x1380 kernel/rcu/tree.c:2785
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 do_softirq.part.0+0xde/0x130 kernel/softirq.c:459
 </IRQ>
 do_softirq kernel/softirq.c:451 [inline]
 __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:383
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:757 [inline]
 __dev_queue_xmit+0x1b04/0x3620 net/core/dev.c:4312
 __netlink_deliver_tap_skb net/netlink/af_netlink.c:303 [inline]
 __netlink_deliver_tap net/netlink/af_netlink.c:321 [inline]
 netlink_deliver_tap+0x9b5/0xbc0 net/netlink/af_netlink.c:334
 netlink_deliver_tap_kernel net/netlink/af_netlink.c:343 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
 netlink_unicast+0x5e5/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2959
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3673
 kernel_sendpage net/socket.c:3670 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1002
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __ia32_sys_splice+0x195/0x250 fs/splice.c:1332
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f54549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f552d5fc EFLAGS: 00000296 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 000000000004ffe0
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
