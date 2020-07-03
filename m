Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF32141F0
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 01:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGCXbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 19:31:23 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:41994 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgGCXbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 19:31:23 -0400
Received: by mail-il1-f198.google.com with SMTP id d3so22902959ilq.9
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 16:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1FVZSI38k+r7N936rJZJCbZSeRBHiWCkBYP7utlD/mE=;
        b=TAtM8YItzoCsZAKzfCE2xBFo2S3zbP1wDcA8bRX2iaR500/uxS4m3ccpdBqgu9Wj6L
         px5i46HRNHfRqGXYTIFc/NQE+hwcDkciYeKyMGY2zlX2iauw3CHDQp/G3FLagOBv/B7e
         xfyiwaTa1tl/3ffKpLqOYOkHWFGqImrvWK+Vd+1Uincn69OZOp4lgwoGBlB8M+dNc5x8
         CP7KOw2nnvto2cc2lv42yMc0PZmvYytibiWwifX/j/sa0xKgha8F/znOhIpCoILrnq4U
         SFsppYeWVRGUs59uRTt0VNlTSJ4IcjACpktbX1AGh2NvnHtoDrj/xEEWs/2u8cRZ6jTE
         D4/A==
X-Gm-Message-State: AOAM531ZeVkXn2WW3oNkCer0ulZRfwmrJgd78GnFfloJm/f0M9AmUj99
        v4LEWVK4D+ZUKL5L0kLXiH+AOF8Zc+EEHxv2Xa/IKzHD78xo
X-Google-Smtp-Source: ABdhPJzAPIf2FeB+Lv0kxOJprK3Lg+OofkJ1FbJr9zoRaY2DLnWTYsQepJEUCuT6BkTcHOgfYx/FB0n4TprdQf718bQIb+Ud1CtF
MIME-Version: 1.0
X-Received: by 2002:a92:50f:: with SMTP id q15mr20502891ile.38.1593819082087;
 Fri, 03 Jul 2020 16:31:22 -0700 (PDT)
Date:   Fri, 03 Jul 2020 16:31:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039638605a991eca7@google.com>
Subject: WARNING in rxrpc_recvmsg
From:   syzbot <syzbot+1a68d5c4e74edea44294@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd77006e Merge tag 'hyperv-fixes-signed' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134c490f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=1a68d5c4e74edea44294
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1176e39b100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144c9e6d100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1a68d5c4e74edea44294@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 0 PID: 11007 at kernel/locking/mutex.c:1415 mutex_trylock+0x220/0x2c0 kernel/locking/mutex.c:1415
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 11007 Comm: syz-executor947 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x13/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:563
RIP: 0010:mutex_trylock+0x220/0x2c0 kernel/locking/mutex.c:1415
Code: 08 84 d2 0f 85 99 00 00 00 8b 3d cb 07 c8 02 85 ff 0f 85 6a fe ff ff 48 c7 c6 60 9c 4b 88 48 c7 c7 20 9a 4b 88 e8 82 77 5e f9 <0f> 0b e9 50 fe ff ff ff 74 24 38 48 8d 7b 68 45 31 c9 31 c9 41 b8
RSP: 0018:ffffc90008757818 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff888093a14378 RCX: 0000000000000000
RDX: ffff8880924b61c0 RSI: ffffffff815d4f47 RDI: fffff520010eaef5
RBP: ffff888093a14000 R08: 0000000000000000 R09: ffffffff89bb5ba3
R10: 000000000000059f R11: 0000000000000001 R12: ffffffff8c90d1a0
R13: ffff888093a14340 R14: 0000000000000000 R15: ffff888093a14538
 rxrpc_recvmsg+0x695/0x1a03 net/rxrpc/recvmsg.c:593
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 sock_recvmsg net/socket.c:900 [inline]
 ____sys_recvmsg+0x2c4/0x640 net/socket.c:2575
 ___sys_recvmsg+0x127/0x200 net/socket.c:2617
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2715
 __sys_recvmmsg net/socket.c:2794 [inline]
 __do_sys_recvmmsg net/socket.c:2817 [inline]
 __se_sys_recvmmsg net/socket.c:2810 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2810
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447b79
Code: Bad RIP value.
RSP: 002b:00007fdf4e75dce8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00000000006dcc48 RCX: 0000000000447b79
RDX: 0000000000000001 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 00000000006dcc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 00007ffc658e40ef R14: 00007fdf4e75e9c0 R15: 20c49ba5e353f7cf
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
