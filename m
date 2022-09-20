Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7C5BE672
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiITMyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiITMxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:53:52 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA075FCC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:53:34 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id u23-20020a6be917000000b0069f4854e11eso1358913iof.2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=jQJm8Z+up347I13dxWYRPWK1SdivX1s8IHwB5EA/8gk=;
        b=WuWlMjYSafPcH4Da2ZXsRSsbmZ9KHJbS4XAINxPYQDt8Ytkf8YRtz+bw+5vzY9lGyH
         RIsQlyyV1ijyJzt8jaTch8nE+aXJ4e3FBLHXUkZ/kuDGFtYWXK0rjUPD34tAbYfR/U/6
         t/YyPJF2l1be/e7/+lNr2eXmpID/420Gq8+HrWMmPtbRNYhC/EQOhu/bcIWHS02N6ZMW
         GOMVpVsk3K6ZyIgn9kq39qV9XVEJY4jIfLU5SFl52wemRfdQbBbDctm0coegt+RRD55w
         RmZ4euVGVZGmbA8yMNNK4yKzMrcNdMRYx6kdZTSBCqOmefNLUhi7+RTCSNcYpupKC1l7
         wdgw==
X-Gm-Message-State: ACrzQf3e6lESk1caqwLDZ6CWRqWSHgB2s1JSdWjgjRA+EDT5Uq/7afVz
        culYQoyF28k/8RxiJK/i1hsU5n9EAUXMQrzWSb4Owd1Orzoo
X-Google-Smtp-Source: AMsMyM6l6LLo4LWGKy1iezG8GllPNubQqkEn/HEBaG5rq+mYVV3f7Bc8lO3y7PQiTnHuHMq2nyIulejtxAPn4IVQmHIUWDcBul4c
MIME-Version: 1.0
X-Received: by 2002:a05:6638:150c:b0:35a:f7a9:c3d8 with SMTP id
 b12-20020a056638150c00b0035af7a9c3d8mr1916588jat.38.1663678413730; Tue, 20
 Sep 2022 05:53:33 -0700 (PDT)
Date:   Tue, 20 Sep 2022 05:53:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000def90305e91b5016@google.com>
Subject: [syzbot] possible deadlock in skb_queue_tail (4)
From:   syzbot <syzbot+44b38bcb874d81a15a57@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kuniyu@amazon.com, linux-kernel@vger.kernel.org,
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

HEAD commit:    3245cb65fd91 Merge tag 'devicetree-fixes-for-6.0-2' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b0c487080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=98a30118ec9215e9
dashboard link: https://syzkaller.appspot.com/bug?extid=44b38bcb874d81a15a57
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+44b38bcb874d81a15a57@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc5-syzkaller-00025-g3245cb65fd91 #0 Not tainted
------------------------------------------------------
syz-executor.4/21149 is trying to acquire lock:
ffff8880178441e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: skb_queue_tail+0x21/0x140 net/core/skbuff.c:3400

but task is already holding lock:
ffff888017844670 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock net/unix/af_unix.c:1298 [inline]
ffff888017844670 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock+0x77/0xa0 net/unix/af_unix.c:1290

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&u->lock/1){+.+.}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:378
       sk_diag_dump_icons net/unix/diag.c:87 [inline]
       sk_diag_fill+0xaaf/0x10d0 net/unix/diag.c:155
       sk_diag_dump net/unix/diag.c:193 [inline]
       unix_diag_dump+0x3a9/0x640 net/unix/diag.c:217
       netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
       __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
       netlink_dump_start include/linux/netlink.h:245 [inline]
       unix_diag_handler_dump net/unix/diag.c:315 [inline]
       unix_diag_handler_dump+0x5c2/0x830 net/unix/diag.c:304
       __sock_diag_cmd net/core/sock_diag.c:235 [inline]
       sock_diag_rcv_msg+0x31a/0x440 net/core/sock_diag.c:266
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:277
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:734
       sock_write_iter+0x291/0x3d0 net/socket.c:1108
       call_write_iter include/linux/fs.h:2187 [inline]
       do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:729
       do_iter_write+0x182/0x700 fs/read_write.c:855
       vfs_writev+0x1aa/0x630 fs/read_write.c:928
       do_writev+0x279/0x2f0 fs/read_write.c:971
       do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
       __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
       do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
       entry_SYSENTER_compat_after_hwframe+0x70/0x82

-> #0 (rlock-AF_UNIX){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5666 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       skb_queue_tail+0x21/0x140 net/core/skbuff.c:3400
       unix_dgram_sendmsg+0xf41/0x1b50 net/unix/af_unix.c:2043
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:734
       ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
       __sys_sendmsg_sock+0x26/0x30 net/socket.c:2548
       io_sendmsg+0x246/0x7d0 io_uring/net.c:289
       io_issue_sqe+0x6b6/0xd20 io_uring/io_uring.c:1577
       io_queue_sqe io_uring/io_uring.c:1755 [inline]
       io_submit_sqe io_uring/io_uring.c:2013 [inline]
       io_submit_sqes+0x94e/0x1d30 io_uring/io_uring.c:2124
       __do_sys_io_uring_enter+0xb85/0x1ea0 io_uring/io_uring.c:3054
       do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
       __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
       do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
       entry_SYSENTER_compat_after_hwframe+0x70/0x82

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
  lock(rlock-AF_UNIX);

 *** DEADLOCK ***

2 locks held by syz-executor.4/21149:
 #0: ffff88807dcb40a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0xb7a/0x1ea0 io_uring/io_uring.c:3053
 #1: ffff888017844670 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock net/unix/af_unix.c:1298 [inline]
 #1: ffff888017844670 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock+0x77/0xa0 net/unix/af_unix.c:1290

stack backtrace:
CPU: 0 PID: 21149 Comm: syz-executor.4 Not tainted 6.0.0-rc5-syzkaller-00025-g3245cb65fd91 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 skb_queue_tail+0x21/0x140 net/core/skbuff.c:3400
 unix_dgram_sendmsg+0xf41/0x1b50 net/unix/af_unix.c:2043
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
 __sys_sendmsg_sock+0x26/0x30 net/socket.c:2548
 io_sendmsg+0x246/0x7d0 io_uring/net.c:289
 io_issue_sqe+0x6b6/0xd20 io_uring/io_uring.c:1577
 io_queue_sqe io_uring/io_uring.c:1755 [inline]
 io_submit_sqe io_uring/io_uring.c:2013 [inline]
 io_submit_sqes+0x94e/0x1d30 io_uring/io_uring.c:2124
 __do_sys_io_uring_enter+0xb85/0x1ea0 io_uring/io_uring.c:3054
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x70/0x82
RIP: 0023:0xf7faf549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f7f895cc EFLAGS: 00000296 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000002a6e
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
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
