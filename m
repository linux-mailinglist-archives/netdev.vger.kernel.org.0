Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ECC468388
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384455AbhLDJWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:22:50 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41914 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354944AbhLDJWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:22:50 -0500
Received: by mail-il1-f199.google.com with SMTP id r1-20020a92cd81000000b002a3ae5f6ad9so3646540ilb.8
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 01:19:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YLnHcb4u/Rbh+CEAOHev0nwUvyI4FI+70xSJiBr2up0=;
        b=KlqIx8shyxOgx7mBR0vpObOAwNCFGEBSbp481cBx+5XRYRV/pVqvNz4a1tJa8eSSKu
         d/+bGR4O0CODkqHULi9bwXCzXrNCCsSCe7DVHcnJbNQysgH3a+JY3frVXdYKzqtVGygu
         EYboJ2Hbo22ce2N5WMzc/kprBsf4WqK7R3+/aSeRycZVzEIgIM4+diQcB2QnGrGB43DT
         U8Ug0+uYytu6ZeLrKkCVKvu9KJDOBXWNC4nvYiHZWJHu+M797RNVykdp8LMFz/Nkk1uT
         2xG4nPxXSL/iQmVe9yDO3bAsHY3MH7/mks2xIQD1IfLHlRSjTs4brM/XFACZElUyU6bT
         DSRw==
X-Gm-Message-State: AOAM532//FzjWcZMWBEaHwPtvEYzuF0SjIoQkKEwy/svwuTgc/GgqNR5
        pQxpbRrIaE9GrZ+vUgChRsLX4ZG4GhjPBzrUfcbAbST/6rik
X-Google-Smtp-Source: ABdhPJyz8Nn/75pCswmwvFmWYk2DkjipATdABkX8lZ6OzsFgcoD88eXtLlBVd/11rki5AQYMU1AR/dFo/CswyF4RcOtkSl0zWmBL
MIME-Version: 1.0
X-Received: by 2002:a92:d992:: with SMTP id r18mr23049436iln.224.1638609565033;
 Sat, 04 Dec 2021 01:19:25 -0800 (PST)
Date:   Sat, 04 Dec 2021 01:19:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ca79b05d24e85fd@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in cancel_delayed_work (2)
From:   syzbot <syzbot+4b140c35e652626b77ba@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3498e7f2bb41 Merge tag '5.16-rc2-ksmbd-fixes' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fcfb5eb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=21797a5d93964cce
dashboard link: https://syzkaller.appspot.com/bug?extid=4b140c35e652626b77ba
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4b140c35e652626b77ba@syzkaller.appspotmail.com

WARNING: CPU: 2 PID: 13842 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 2 PID: 13842 Comm: syz-executor.1 Not tainted 5.16.0-rc2-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 40 29 05 8a 4c 89 ee 48 c7 c7 40 1d 05 8a e8 cc c1 21 05 <0f> 0b 83 05 55 a1 b2 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90007e9f710 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815f0c28 RDI: fffff52000fd3ed4
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ea9ce R11: 0000000000000000 R12: ffffffff89adf660
R13: ffffffff8a0523c0 R14: ffffffff81660140 R15: 1ffff92000fd3eed
FS:  0000000000000000(0000) GS:ffff88802cc00000(0063) knlGS:00000000f44efb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7401004 CR3: 0000000062c7d000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:895 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
 debug_timer_assert_init kernel/time/timer.c:739 [inline]
 debug_assert_init kernel/time/timer.c:784 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1204
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1271
 __cancel_work kernel/workqueue.c:3259 [inline]
 cancel_delayed_work+0x79/0x340 kernel/workqueue.c:3288
 sco_sock_clear_timer+0x54/0xf0 net/bluetooth/sco.c:120
 sco_conn_del+0x139/0x2c0 net/bluetooth/sco.c:198
 sco_disconn_cfm+0x71/0xb0 net/bluetooth/sco.c:1374
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1543 [inline]
 hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1742
 hci_dev_do_close+0x57d/0x1150 net/bluetooth/hci_core.c:1672
 hci_rfkill_set_block+0x19c/0x1d0 net/bluetooth/hci_core.c:2113
 rfkill_set_block+0x1f9/0x540 net/rfkill/core.c:344
 rfkill_fop_write+0x267/0x500 net/rfkill/core.c:1268
 do_loop_readv_writev fs/read_write.c:749 [inline]
 do_loop_readv_writev fs/read_write.c:733 [inline]
 do_iter_write+0x4f8/0x710 fs/read_write.c:853
 vfs_writev+0x1aa/0x630 fs/read_write.c:924
 do_writev+0x27f/0x300 fs/read_write.c:967
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf6ef5549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f44ef5fc EFLAGS: 00000296 ORIG_RAX: 0000000000000092
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000000
RDX: 0000000000000300 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	03 74 c0 01          	add    0x1(%rax,%rax,8),%esi
   4:	10 05 03 74 b8 01    	adc    %al,0x1b87403(%rip)        # 0x1b8740d
   a:	10 06                	adc    %al,(%rsi)
   c:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
  10:	10 07                	adc    %al,(%rdi)
  12:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
  16:	10 08                	adc    %cl,(%rax)
  18:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1c:	00 00                	add    %al,(%rax)
  1e:	00 00                	add    %al,(%rax)
  20:	00 51 52             	add    %dl,0x52(%rcx)
  23:	55                   	push   %rbp
  24:	89 e5                	mov    %esp,%ebp
  26:	0f 34                	sysenter
  28:	cd 80                	int    $0x80
* 2a:	5d                   	pop    %rbp <-- trapping instruction
  2b:	5a                   	pop    %rdx
  2c:	59                   	pop    %rcx
  2d:	c3                   	retq
  2e:	90                   	nop
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  39:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
