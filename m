Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927D46AA0EB
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 22:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjCCVQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 16:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCCVQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 16:16:47 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1937F61507
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 13:16:46 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i8-20020a056e02054800b00318a7211804so2003235ils.5
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 13:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iZMq3I524LZ3LyFG/4UrcrlRiCRLs/dbIEgvULqsulE=;
        b=I97+D445jiK+c23TvQP8BHnDoubUipyFMKFpdVLs7hmNphnJq9Q/UXNhUQ9bHOJ3qC
         r/gc3t/Gx9KxaGanDl/JNL1XLypRQhbInM9yrZ5nkzM6NzFVcKDwgqORAm64dv1okzCx
         YPjjdWxnfn0M/BO2fUZDeTr82LYhJzSVZbvKB6gbvjomM7mWEDTdu1FMYvRDX3uovnZP
         bFs2CBbQSBbxvttDpXWlM1564GeG75kEZ2EyG3tfSpklWQvYLvU+y1ghusGSQyF2mn2k
         58Ybdi9aQ5u4yzfmCBftloWKaCCpgZzOTBl55uQ4kgCTdgwA3pyEzc6R1XNkwSV773rs
         9cHg==
X-Gm-Message-State: AO0yUKXm5lXxJJZq84fwLlXd4PxFpgms0Y1qprhkZr8LeWlXQlc0nliC
        9/Jb6S+paUMxn/79dBKEq2OfLJHYQdSb3rfbkf2aXMh3yOcE
X-Google-Smtp-Source: AK7set+mfsbnChKExhVMU5JwTUXJdUffgj3MzkjSGFSmdbTqAwHH5ibRwTuY/I/0xe0RTcrqAcy/xKgvNy+eTZ13UWsMdkUfXvJ8
MIME-Version: 1.0
X-Received: by 2002:a02:94ab:0:b0:3c4:d4b2:f72 with SMTP id
 x40-20020a0294ab000000b003c4d4b20f72mr1362791jah.3.1677878205481; Fri, 03 Mar
 2023 13:16:45 -0800 (PST)
Date:   Fri, 03 Mar 2023 13:16:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a07d505f60576b3@google.com>
Subject: [syzbot] [bluetooth?] WARNING in hci_send_acl
From:   syzbot <syzbot+90c0638c7b912d27bfe7@syzkaller.appspotmail.com>
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

HEAD commit:    2ebd1fbb946d Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12aad518c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3519974f3f27816d
dashboard link: https://syzkaller.appspot.com/bug?extid=90c0638c7b912d27bfe7
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/16985cc7a274/disk-2ebd1fbb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fd3452567115/vmlinux-2ebd1fbb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c75510922212/Image-2ebd1fbb.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+90c0638c7b912d27bfe7@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 22417 at kernel/workqueue.c:1438 __queue_work+0x11e0/0x1484 kernel/workqueue.c:1438
Modules linked in:
CPU: 1 PID: 22417 Comm: syz-executor.0 Not tainted 6.2.0-syzkaller-18300-g2ebd1fbb946d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __queue_work+0x11e0/0x1484 kernel/workqueue.c:1438
lr : __queue_work+0x11e0/0x1484 kernel/workqueue.c:1438
sp : ffff80002bf37250
x29: ffff80002bf37290 x28: 0000000000000008 x27: 0000000000002000
x26: ffff0000ce923800 x25: dfff800000000000 x24: ffff0000ce9239c0
x23: 0000000000000000 x22: ffff00012c509b48 x21: 1fffe000258a1369
x20: 00000000000b0012 x19: ffff00012df8cd10 x18: ffff80002bf372e0
x17: ffff800015b8d000 x16: ffff80000804d18c x15: 0000000000000000
x14: 1ffff00002b720af x13: dfff800000000000 x12: 0000000000000001
x11: ff80800008220790 x10: 0000000000000000 x9 : ffff800008220790
x8 : ffff00012c509b40 x7 : ffff8000105bcce8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff80000821f4ec
x2 : ffff00012df8cd10 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 __queue_work+0x11e0/0x1484 kernel/workqueue.c:1438
 queue_work_on+0x9c/0x128 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 hci_send_acl+0x86c/0xb54 net/bluetooth/hci_core.c:3183
 l2cap_do_send+0x238/0x350
 l2cap_chan_send+0x36c/0x2044
 l2cap_sock_sendmsg+0x184/0x2a8 net/bluetooth/l2cap_sock.c:1172
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x558/0x844 net/socket.c:2479
 ___sys_sendmsg net/socket.c:2533 [inline]
 __sys_sendmmsg+0x318/0x7d8 net/socket.c:2619
 __do_sys_sendmmsg net/socket.c:2648 [inline]
 __se_sys_sendmmsg net/socket.c:2645 [inline]
 __arm64_sys_sendmmsg+0xa0/0xbc net/socket.c:2645
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
 el0_svc_common+0x138/0x258 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
 el0_svc+0x58/0x168 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
irq event stamp: 524
hardirqs last  enabled at (523): [<ffff80001243d19c>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (523): [<ffff80001243d19c>] _raw_spin_unlock_irqrestore+0x44/0xa4 kernel/locking/spinlock.c:194
hardirqs last disabled at (524): [<ffff80000821f4d8>] queue_work_on+0x50/0x128 kernel/workqueue.c:1542
softirqs last  enabled at (514): [<ffff80001058d02c>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (514): [<ffff80001058d02c>] release_sock+0x178/0x1cc net/core/sock.c:3497
softirqs last disabled at (512): [<ffff80001058cef0>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (512): [<ffff80001058cef0>] release_sock+0x3c/0x1cc net/core/sock.c:3484
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
