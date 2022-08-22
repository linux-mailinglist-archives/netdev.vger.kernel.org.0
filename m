Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7C159BC1C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiHVI6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiHVI6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:58:35 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D963E60CA
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:58:27 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id g22-20020a056602249600b0067caba4f24bso5263168ioe.4
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=Tcyuj24O23vcHVhLzElBM890gQJozZlpTegCM2oZcMY=;
        b=AxcbrWiEg3xzOEpuyFu5DDYoH9KHrwhohKbcL+Sqi3R5/Z1uSyICu7pNJORaHEoVqn
         fD4FXETqXtDStTP0CVczhf2zPi3rH9vpFbLV9tfJ6LjjZ10oXwWy7K+Ie2YuhOtYoWZw
         e+ERVzodrnucXt0shN915Rsl04BW/ToqqiYfYsnDFdzCToC9VZ8fkQ8B8OAJek/u6zxm
         wWdnQvfERsncAa8mIdjS92Ppr/Rf4EbjHS20qCTVjRiBWcWeCpXyxEbNzoV7SsWo1obf
         u2RbipUgx67EcZlpNbZZuz78TWtBk09X9H8OYZ1hJbkl+oI3umrx/iy0WW8DymvJoNaW
         bMAg==
X-Gm-Message-State: ACgBeo2gFTEbtatCDZPtP6e2NaJmidcRoAgZ78PYAlo7XaCT5PQYH7aO
        9Tmn3qrBvhn9C9QMXCK2PLg6BM8Cw6Y9lGGsxZlEgPT27UXP
X-Google-Smtp-Source: AA6agR41PpDi6EtKzgHmda6SKdDcvaATTk73pKh4Co2iZTH1oHflXCqomztGn7IFsq8AQKqNn04lsg8lRIMIGxE64Z+W3LTCLzYB
MIME-Version: 1.0
X-Received: by 2002:a05:6638:25d3:b0:342:fa3d:1275 with SMTP id
 u19-20020a05663825d300b00342fa3d1275mr9511547jat.70.1661158706744; Mon, 22
 Aug 2022 01:58:26 -0700 (PDT)
Date:   Mon, 22 Aug 2022 01:58:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1943305e6d0a695@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in __access_remote_vm
From:   syzbot <syzbot+6d42e44c5d6fa154fefa@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5b6a4bf680d6 Add linux-next specific files for 20220818
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=107558eb080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ead6107a3bbe3c62
dashboard link: https://syzkaller.appspot.com/bug?extid=6d42e44c5d6fa154fefa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d42e44c5d6fa154fefa@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.0.0-rc1-next-20220818-syzkaller #0 Not tainted
-----------------------------
include/net/sock.h:592 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
4 locks held by syz-executor.3/11465:
 #0: ffff888039371a10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
 #0: ffff888039371a10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash net/ipv4/udp.c:2014 [inline]
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash+0x1d5/0x730 net/ipv4/udp.c:2004
 #2: ffffffff8d7beb78 (reuseport_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #2: ffffffff8d7beb78 (reuseport_lock){+...}-{2:2}, at: reuseport_detach_sock+0x22/0x4a0 net/core/sock_reuseport.c:346
 #3: ffff8880202a6bb8 (clock-AF_INET6){++.-}-{2:2}, at: bpf_sk_reuseport_detach+0x26/0x190 kernel/bpf/reuseport_array.c:26

stack backtrace:
CPU: 0 PID: 11465 Comm: syz-executor.3 Not tainted 6.0.0-rc1-next-20220818-syzkaller #0
BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1521
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 11465, name: syz-executor.3
preempt_count: 603, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by syz-executor.3/11465:
 #0: ffff888039371a10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
 #0: ffff888039371a10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash net/ipv4/udp.c:2014 [inline]
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash+0x1d5/0x730 net/ipv4/udp.c:2004
 #2: ffffffff8d7beb78 (reuseport_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #2: ffffffff8d7beb78 (reuseport_lock){+...}-{2:2}, at: reuseport_detach_sock+0x22/0x4a0 net/core/sock_reuseport.c:346
 #3: ffff8880202a6bb8 (clock-AF_INET6){++.-}-{2:2}, at: bpf_sk_reuseport_detach+0x26/0x190 kernel/bpf/reuseport_array.c:26
irq event stamp: 509
hardirqs last  enabled at (508): [<ffffffff816199ce>] __up_console_sem+0xae/0xc0 kernel/printk/printk.c:264
hardirqs last disabled at (509): [<ffffffff894bf6e6>] dump_stack_lvl+0x2e/0x134 lib/dump_stack.c:139
softirqs last  enabled at (206): [<ffffffff881e0a2e>] udpv6_destroy_sock+0x8e/0x230 net/ipv6/udp.c:1624
softirqs last disabled at (208): [<ffffffff87e911f5>] spin_lock_bh include/linux/spinlock.h:354 [inline]
softirqs last disabled at (208): [<ffffffff87e911f5>] udp_lib_unhash net/ipv4/udp.c:2014 [inline]
softirqs last disabled at (208): [<ffffffff87e911f5>] udp_lib_unhash+0x1d5/0x730 net/ipv4/udp.c:2004
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 PID: 11465 Comm: syz-executor.3 Not tainted 6.0.0-rc1-next-20220818-syzkaller #0

=============================
[ BUG: Invalid wait context ]
6.0.0-rc1-next-20220818-syzkaller #0 Not tainted
-----------------------------
syz-executor.3/11465 is trying to lock:
ffff88807eefc728 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_read_lock_killable include/linux/mmap_lock.h:126 [inline]
ffff88807eefc728 (&mm->mmap_lock#2){++++}-{3:3}, at: __access_remote_vm+0xac/0x6f0 mm/memory.c:5461
other info that might help us debug this:
context-{4:4}
4 locks held by syz-executor.3/11465:
 #0: ffff888039371a10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
 #0: ffff888039371a10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash net/ipv4/udp.c:2014 [inline]
 #1: ffffc900014ebf38 (&table->hash[i].lock){+...}-{2:2}, at: udp_lib_unhash+0x1d5/0x730 net/ipv4/udp.c:2004
 #2: ffffffff8d7beb78 (reuseport_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #2: ffffffff8d7beb78 (reuseport_lock){+...}-{2:2}, at: reuseport_detach_sock+0x22/0x4a0 net/core/sock_reuseport.c:346
 #3: ffff8880202a6bb8 (clock-AF_INET6){++.-}-{2:2}, at: bpf_sk_reuseport_detach+0x26/0x190 kernel/bpf/reuseport_array.c:26
stack backtrace:
CPU: 0 PID: 11465 Comm: syz-executor.3 Not tainted 6.0.0-rc1-next-20220818-syzkaller #0
syz-executor.3[11465] cmdline: /root/syz-executor.3 exec
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:122 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:140
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4705 [inline]
 check_wait_context kernel/locking/lockdep.c:4766 [inline]
 __lock_acquire.cold+0x322/0x3a7 kernel/locking/lockdep.c:5003
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 down_read_killable+0x9b/0x490 kernel/locking/rwsem.c:1522
 mmap_read_lock_killable include/linux/mmap_lock.h:126 [inline]
 __access_remote_vm+0xac/0x6f0 mm/memory.c:5461
 get_mm_cmdline.part.0+0x217/0x620 fs/proc/base.c:299
 get_mm_cmdline fs/proc/base.c:367 [inline]
 get_task_cmdline_kernel+0x1d9/0x220 fs/proc/base.c:367
 dump_stack_print_cmdline.part.0+0x82/0x150 lib/dump_stack.c:61
 dump_stack_print_cmdline lib/dump_stack.c:89 [inline]
 dump_stack_print_info+0x185/0x190 lib/dump_stack.c:97
 __dump_stack lib/dump_stack.c:121 [inline]
 dump_stack_lvl+0xc1/0x134 lib/dump_stack.c:140
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9896
 down_read_killable+0x75/0x490 kernel/locking/rwsem.c:1521
 mmap_read_lock_killable include/linux/mmap_lock.h:126 [inline]
 __access_remote_vm+0xac/0x6f0 mm/memory.c:5461
 get_mm_cmdline.part.0+0x217/0x620 fs/proc/base.c:299
 get_mm_cmdline fs/proc/base.c:367 [inline]
 get_task_cmdline_kernel+0x1d9/0x220 fs/proc/base.c:367
 dump_stack_print_cmdline.part.0+0x82/0x150 lib/dump_stack.c:61
 dump_stack_print_cmdline lib/dump_stack.c:89 [inline]
 dump_stack_print_info+0x185/0x190 lib/dump_stack.c:97
 __dump_stack lib/dump_stack.c:121 [inline]
 dump_stack_lvl+0xc1/0x134 lib/dump_stack.c:140
 __rcu_dereference_sk_user_data_with_flags include/net/sock.h:592 [inline]
 bpf_sk_reuseport_detach+0x156/0x190 kernel/bpf/reuseport_array.c:27
 reuseport_detach_sock+0x8c/0x4a0 net/core/sock_reuseport.c:362
 udp_lib_unhash net/ipv4/udp.c:2016 [inline]
 udp_lib_unhash+0x210/0x730 net/ipv4/udp.c:2004
 sk_common_release+0xba/0x390 net/core/sock.c:3600
 inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:482
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0f21689279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f22751168 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: 0000000000000004 RBX: 00007f0f2179bf80 RCX: 00007f0f21689279
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000003
RBP: 00007f0f216e3189 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc99f634ef R14: 00007f0f22751300 R15: 0000000000022000
 </TASK>
syz-executor.3[11465] cmdline: /root/syz-executor.3 exec
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:122 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:140
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9896
 down_read_killable+0x75/0x490 kernel/locking/rwsem.c:1521
 mmap_read_lock_killable include/linux/mmap_lock.h:126 [inline]
 __access_remote_vm+0xac/0x6f0 mm/memory.c:5461
 get_mm_cmdline.part.0+0x217/0x620 fs/proc/base.c:299
 get_mm_cmdline fs/proc/base.c:367 [inline]
 get_task_cmdline_kernel+0x1d9/0x220 fs/proc/base.c:367
 dump_stack_print_cmdline.part.0+0x82/0x150 lib/dump_stack.c:61
 dump_stack_print_cmdline lib/dump_stack.c:89 [inline]
 dump_stack_print_info+0x185/0x190 lib/dump_stack.c:97
 __dump_stack lib/dump_stack.c:121 [inline]
 dump_stack_lvl+0xc1/0x134 lib/dump_stack.c:140
 __rcu_dereference_sk_user_data_with_flags include/net/sock.h:592 [inline]
 bpf_sk_reuseport_detach+0x156/0x190 kernel/bpf/reuseport_array.c:27
 reuseport_detach_sock+0x8c/0x4a0 net/core/sock_reuseport.c:362
 udp_lib_unhash net/ipv4/udp.c:2016 [inline]
 udp_lib_unhash+0x210/0x730 net/ipv4/udp.c:2004
 sk_common_release+0xba/0x390 net/core/sock.c:3600
 inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:482
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0f21689279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f22751168 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: 0000000000000004 RBX: 00007f0f2179bf80 RCX: 00007f0f21689279
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000003
RBP: 00007f0f216e3189 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc99f634ef R14: 00007f0f22751300 R15: 0000000000022000
 </TASK>
syz-executor.3[11465] cmdline: /root/syz-executor.3 exec
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:122 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:140
 __rcu_dereference_sk_user_data_with_flags include/net/sock.h:592 [inline]
 bpf_sk_reuseport_detach+0x156/0x190 kernel/bpf/reuseport_array.c:27
 reuseport_detach_sock+0x8c/0x4a0 net/core/sock_reuseport.c:362
 udp_lib_unhash net/ipv4/udp.c:2016 [inline]
 udp_lib_unhash+0x210/0x730 net/ipv4/udp.c:2004
 sk_common_release+0xba/0x390 net/core/sock.c:3600
 inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:482
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0f21689279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f22751168 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: 0000000000000004 RBX: 00007f0f2179bf80 RCX: 00007f0f21689279
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000003
RBP: 00007f0f216e3189 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc99f634ef R14: 00007f0f22751300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
