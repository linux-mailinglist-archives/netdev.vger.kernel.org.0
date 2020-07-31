Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E89233D9A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 05:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgGaDNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 23:13:25 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:57273 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731298AbgGaDNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 23:13:24 -0400
Received: by mail-io1-f70.google.com with SMTP id f21so19939730ioo.23
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 20:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wX4UxClPuPiSj/FUSxb7K5H0GkdpHs3QFxD4LPSNLqA=;
        b=O1LDTYts7PGDhbm6BlunOpWu/6bsTAmnWWn06NSFPS5bDFJAXSgzYwd3Ts+S99RWB9
         N0s3n3svWPomb9NGZLeBCHlnhgk81HLEej/JTWYbvqI9ewEh9D6ziUuUZGlaxgjlUiWT
         0NwmKI/z4/Y9JnSRbRsL3QQ5acrOG1N/xi/q2jYGoKG8ig3GVd7hQK/e+mHITpZS51yp
         gaK2/jCUg457ZYhn2KLh4xu3sjF+4sFsrWbGMOnadovz5+OUvneDdJuF8pEsZ0ZhA9W9
         r825oE93GiCM3js6HEgcMOxfIbsoj2cizuUABpvhjrktOgPP44cU3b17PpvPkD79J6QZ
         vMLA==
X-Gm-Message-State: AOAM532dhdn9V59qiRs6eHYI6uESWFwXB8gaKMQsVuimr84FjEIGjkuK
        2Q2rVNOgUVs2/9l4Us8Afa9wEVcSjSKEW3RMgLz4SHwh0zUz
X-Google-Smtp-Source: ABdhPJwwXeZjCISUCoDvHg+GBVSC0YtBkDu6ONKcAkrSJGzoKHuoinf8LqGYz/vtMMcNSmMI7chfpv+l8rlLTtfpCN5AQvrvvTv3
MIME-Version: 1.0
X-Received: by 2002:a92:8b11:: with SMTP id i17mr1662247ild.212.1596165203611;
 Thu, 30 Jul 2020 20:13:23 -0700 (PDT)
Date:   Thu, 30 Jul 2020 20:13:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6d80505abb42b60@google.com>
Subject: WARNING in cancel_delayed_work
From:   syzbot <syzbot+35e70efb794757d7e175@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    83bdc727 random32: remove net_rand_state from the latent e..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10479f12900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=35e70efb794757d7e175
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1160faa2900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11816098900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+35e70efb794757d7e175@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 6889 at lib/debugobjects.c:488 debug_print_object lib/debugobjects.c:485 [inline]
WARNING: CPU: 0 PID: 6889 at lib/debugobjects.c:488 debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:870
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6889 Comm: syz-executor259 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
RIP: 0010:debug_print_object lib/debugobjects.c:485 [inline]
RIP: 0010:debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:870
Code: e8 ab ec 11 fe 4c 8b 45 00 48 c7 c7 0f b7 14 89 48 c7 c6 09 b6 14 89 48 c7 c2 22 30 2c 89 31 c9 49 89 d9 31 c0 e8 16 9e a4 fd <0f> 0b ff 05 02 ca eb 05 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
RSP: 0018:ffffc90001477828 EFLAGS: 00010046
RAX: 8d1db38e33234900 RBX: 0000000000000000 RCX: ffff888091cfe200
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffffff894edb20 R08: ffffffff815dd389 R09: ffffed1015d041c3
R10: ffffed1015d041c3 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880a687e200 R14: 0000000000000002 R15: ffffffff8ba2a2a0
 debug_timer_assert_init kernel/time/timer.c:737 [inline]
 debug_assert_init kernel/time/timer.c:782 [inline]
 del_timer+0x2f/0x340 kernel/time/timer.c:1208
 try_to_grab_pending+0xba/0x9f0 kernel/workqueue.c:1249
 __cancel_work kernel/workqueue.c:3221 [inline]
 cancel_delayed_work+0x37/0x2b0 kernel/workqueue.c:3250
 l2cap_clear_timer include/net/bluetooth/l2cap.h:879 [inline]
 l2cap_chan_del+0x5bf/0x760 net/bluetooth/l2cap_core.c:661
 l2cap_chan_close+0x7bf/0xae0 net/bluetooth/l2cap_core.c:824
 l2cap_sock_shutdown+0x39f/0x700 net/bluetooth/l2cap_sock.c:1339
 l2cap_sock_release+0x63/0x190 net/bluetooth/l2cap_sock.c:1382
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1278
 __fput+0x2f0/0x750 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0x601/0x1f80 kernel/exit.c:805
 do_group_exit+0x161/0x2d0 kernel/exit.c:903
 get_signal+0x139b/0x1d30 kernel/signal.c:2743
 do_signal+0x33/0x610 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:235 [inline]
 __prepare_exit_to_usermode+0xd7/0x1e0 arch/x86/entry/common.c:269
 do_syscall_64+0x7f/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446d69
Code: Bad RIP value.
RSP: 002b:00007ffc9b702c28 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 0000000000000003 RCX: 0000000000446d69
RDX: 000000000000000e RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00007ffc9b702c60 R08: 0000000000000000 R09: 00000000000000ff
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
