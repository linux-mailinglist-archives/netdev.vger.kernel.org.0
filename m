Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF69F68B922
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjBFJ56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjBFJ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:57:55 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07331BC4
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:57:52 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id 9-20020a056e0220c900b0030f1b0dfa9dso7652280ilq.4
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 01:57:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=citm/9S3TGtyrGlQSsmTLTPTlHeTSMnVnGMuE9JTzxU=;
        b=6nSeFgfsF5u+fvLMHr6p762amrzLjAtbZ6Kkx/BmFPGsdqKshwB1DAcLT7Nk4YM2EV
         oWme/pnvuXvlOOd7KFxk5R9of8uTSIrkq1UXIsqVIjm6di7mmxeszHTArAGTdPBYx1C0
         c4Eli5VQnIBTPoIoIa3m9HCvqFZecVAj/g9rKbJvVblPJ5uL3y9OZLulc612gPrjcl90
         cDa1KSKbAEvX+sB4oaAVMhhnyP7pDYJnSPKawUJmd6hR8AwZxMgWBSMdUqA+IDDjj8AX
         ghMpprKaCJRDAJky4LZR/U7uoEFrHP4qPn+wTIQ4NDA1uI91ECKcHF1XN/Z8aAms70aA
         b0Cw==
X-Gm-Message-State: AO0yUKU3vH8oBUdwhbt03z1vgNivArN/ISNBwrvAx6dXmFgPkN5IXyJT
        VskZakWeGj0P14d3A1yghLRaWN9fXHuohPlDzszyCb26r0Tb
X-Google-Smtp-Source: AK7set+oKOdyaFd7xRXpZFEVUH/i7p9A3UoQ7b2/dulMUjjdxt76qqOBk4a8wu40NfJP0NvjS4W+S9BvyPDBoql23UkyBpBkgBmJ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1104:b0:3aa:3a40:eff1 with SMTP id
 n4-20020a056638110400b003aa3a40eff1mr4717579jal.106.1675677472248; Mon, 06
 Feb 2023 01:57:52 -0800 (PST)
Date:   Mon, 06 Feb 2023 01:57:52 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007dd9cf05f40510eb@google.com>
Subject: [syzbot] WARNING in l2cap_do_send
From:   syzbot <syzbot+a4a0e2f4827c045b6ee8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    64466c407a73 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15c40b0d480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23330449ad10b66f
dashboard link: https://syzkaller.appspot.com/bug?extid=a4a0e2f4827c045b6ee8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1923043fad30/disk-64466c40.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/16ffd43dda86/vmlinux-64466c40.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3937fdc798ac/bzImage-64466c40.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4a0e2f4827c045b6ee8@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8068 at kernel/workqueue.c:1438 __queue_work+0xf70/0x13b0 kernel/workqueue.c:1438
Modules linked in:
CPU: 1 PID: 8068 Comm: syz-executor.4 Not tainted 6.2.0-rc5-syzkaller-00144-g64466c407a73 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
RIP: 0010:__queue_work+0xf70/0x13b0 kernel/workqueue.c:1438
Code: e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 28 e5 7c 00 8b 5b 2c 31 ff 83 e3 20 89 de e8 b9 d3 2e 00 85 db 75 42 e8 00 d7 2e 00 <0f> 0b e9 7e f7 ff ff e8 f4 d6 2e 00 0f 0b e9 10 f7 ff ff e8 e8 d6
RSP: 0018:ffffc90003717750 EFLAGS: 00010012
RAX: 00000000000005a3 RBX: 0000000000000000 RCX: ffffc9000cc31000
RDX: 0000000000040000 RSI: ffffffff81528af0 RDI: 0000000000000005
RBP: 0000000000000008 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88802a7f0d10
R13: 0000000000000000 R14: ffff888020bd0000 R15: ffff888020bd0000
FS:  00007f6fd3c8b700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555573e2708 CR3: 000000001c8e9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
 l2cap_do_send+0x318/0x480 net/bluetooth/l2cap_core.c:1018
 l2cap_chan_send+0xd3c/0x2cb0 net/bluetooth/l2cap_core.c:2746
 l2cap_sock_sendmsg+0x220/0x300 net/bluetooth/l2cap_sock.c:1172
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x334/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmmsg+0x18f/0x460 net/socket.c:2616
 __do_sys_sendmmsg net/socket.c:2645 [inline]
 __se_sys_sendmmsg net/socket.c:2642 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2642
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6fd2e8c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6fd3c8b168 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f6fd2fabf80 RCX: 00007f6fd2e8c0c9
RDX: 0400000000000140 RSI: 00000000200039c0 RDI: 0000000000000004
RBP: 00007f6fd2ee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000048048 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc66d827ff R14: 00007f6fd3c8b300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
