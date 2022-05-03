Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D57518A9B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 18:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiECRCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbiECRCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:02:52 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C6A3BA57
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 09:59:17 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id i15-20020a056e0212cf00b002cf3463ed24so1394791ilm.0
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 09:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LXfEj28WD4fslUoQufiPOJivjECGYbUeceAVFgp5+pc=;
        b=UTXI7LGLuKEqkZlawVZbhnfYLDxngKh43nCGdTDsLS9IG+GgrBDTOJ8E+Kwm5kolvS
         q4VMHVXrHa4Gig7ma9zofAjzBvDx1bfrOHDrBFinZx7nB1IRlnVQ1chlu5KtBqh72+5c
         xvUjQmoplXs4OA+hExY7cMQ4cdomsZ9DvQobeSQxIVxr5hmmQMPMvyyF9YNUQAbtXx6b
         0HWVI+ZyX0cVw/HufIbnYTNh5qIHYQeb7EF/xqh6I3ufXLBzc9eF0MzBz3mj5b19ba3u
         Rn6uBB2ADDITFODiifzsUu/fW75fK5C3DfMmRlraDIRippPvDWU9TQ4aDxTIUxNU6k5z
         wleg==
X-Gm-Message-State: AOAM5318GTPRTlhJ9FDR0JsUQQD0CTYLa1Z0wTsF/lfzUei9iELtHN0l
        IOThAaYe6aZxSnPta733z0YZnf2O6eDWllddN4XtTtRLBgWa
X-Google-Smtp-Source: ABdhPJy3l3Ou4SbsIXyKYyj9ELjDzyDzzdm1KD017rSi9scqHCueCDmqtjC7NnNx9x7Ff7Zx4XOppALOLs5q58fMw+9lAKQrtr7K
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1482:b0:32b:8a7c:bdca with SMTP id
 j2-20020a056638148200b0032b8a7cbdcamr799026jak.148.1651597156652; Tue, 03 May
 2022 09:59:16 -0700 (PDT)
Date:   Tue, 03 May 2022 09:59:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d59b7105de1e6d3a@google.com>
Subject: [syzbot] INFO: task hung in hci_dev_close_sync
From:   syzbot <syzbot+c56f6371c48cad0420f9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    9f9b9a2972eb Add linux-next specific files for 20220502
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1304f300f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db7d696bedca61f5
dashboard link: https://syzkaller.appspot.com/bug?extid=c56f6371c48cad0420f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c56f6371c48cad0420f9@syzkaller.appspotmail.com

INFO: task kworker/u5:1:3691 blocked for more than 143 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:1    state:D stack:27464 pid: 3691 ppid:     2 flags:0x00004000
Workqueue: hci4 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3098
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3185
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4092
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
INFO: task kworker/u5:2:3694 blocked for more than 143 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:2    state:D stack:27688 pid: 3694 ppid:     2 flags:0x00004000
Workqueue: hci1 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3098
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3185
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4092
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
INFO: task kworker/u5:3:3696 blocked for more than 143 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:3    state:D stack:27192 pid: 3696 ppid:     2 flags:0x00004000
Workqueue: hci2 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3098
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3185
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4092
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
INFO: task kworker/u5:5:5430 blocked for more than 144 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:5    state:D stack:27536 pid: 5430 ppid:     2 flags:0x00004000
Workqueue: hci0 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3098
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3185
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4092
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
INFO: task syz-executor.5:5786 blocked for more than 144 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:28408 pid: 5786 ppid:     1 flags:0x00000000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x44e/0x1440 kernel/workqueue.c:2884
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1131
 sock_ioctl+0x2f1/0x640 net/socket.c:1248
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f13b1488ea7
RSP: 002b:00007ffeca7dc868 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffeca7dcf28 RCX: 00007f13b1488ea7
RDX: 0000000000000000 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007f13b0bff700 R09: 00007f13b0bff700
R10: 00007f13b0bff9d0 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffeca7dc9c0 R14: 00007f13b159c9b8 R15: 000000000000000c
 </TASK>
INFO: task syz-executor.3:5903 blocked for more than 144 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:28408 pid: 5903 ppid:     1 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x44e/0x1440 kernel/workqueue.c:2884
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1131
 sock_ioctl+0x2f1/0x640 net/socket.c:1248
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ffbbf688ea7
RSP: 002b:00007fffc1092908 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fffc1092fc8 RCX: 00007ffbbf688ea7
RDX: 0000000000000001 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffbbedff700 R09: 00007ffbbedff700
R10: 00007ffbbedff9d0 R11: 0000000000000246 R12: 0000000000000003
R13: 00007fffc1092a60 R14: 00007ffbbf79c9b8 R15: 000000000000000c
 </TASK>
INFO: task syz-executor.2:6048 blocked for more than 144 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28408 pid: 6048 ppid:     1 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x44e/0x1440 kernel/workqueue.c:2884
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1131
 sock_ioctl+0x2f1/0x640 net/socket.c:1248
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff9c0e88ea7
RSP: 002b:00007ffed3e82ed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffed3e83598 RCX: 00007ff9c0e88ea7
RDX: 0000000000000004 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ff9c05ff700 R09: 00007ff9c05ff700
R10: 00007ff9c05ff9d0 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffed3e83030 R14: 00007ff9c0f9c9b8 R15: 000000000000000c
 </TASK>
INFO: task syz-executor.0:6305 blocked for more than 145 seconds.
      Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:28408 pid: 6305 ppid:     1 flags:0x00000000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5106 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6421
 schedule+0xd2/0x1f0 kernel/sched/core.c:6493
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x44e/0x1440 kernel/workqueue.c:2884
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1131
 sock_ioctl+0x2f1/0x640 net/socket.c:1248
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe7a4488ea7
RSP: 002b:00007ffcc64117a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffcc6411e68 RCX: 00007fe7a4488ea7
RDX: 0000000000000002 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007fe7a3bff700 R09: 00007fe7a3bff700
R10: 00007fe7a3bff9d0 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffcc6411900 R14: 00007fe7a459c9b8 R15: 000000000000000c
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8bd84cd0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:502
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8bd84950 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:502
1 lock held by khungtaskd/29:
 #0: ffffffff8bd85820 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6491
2 locks held by getty/3356:
 #0: ffff88814bb09098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002ce62e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xe50/0x13c0 drivers/tty/n_tty.c:2118
3 locks held by kworker/u5:1/3691:
 #0: ffff88802520a938 ((wq_completion)hci4){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802520a938 ((wq_completion)hci4){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88802520a938 ((wq_completion)hci4){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88802520a938 ((wq_completion)hci4){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88802520a938 ((wq_completion)hci4){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88802520a938 ((wq_completion)hci4){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90002f5fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff88801e529048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551
3 locks held by kworker/u5:2/3694:
 #0: ffff88807eb0f138 ((wq_completion)hci1){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88807eb0f138 ((wq_completion)hci1){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88807eb0f138 ((wq_completion)hci1){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88807eb0f138 ((wq_completion)hci1){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88807eb0f138 ((wq_completion)hci1){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88807eb0f138 ((wq_completion)hci1){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc9000307fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff88801e165048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551
3 locks held by kworker/u5:3/3696:
 #0: ffff88807ad37938 ((wq_completion)hci2){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88807ad37938 ((wq_completion)hci2){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88807ad37938 ((wq_completion)hci2){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88807ad37938 ((wq_completion)hci2){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88807ad37938 ((wq_completion)hci2){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88807ad37938 ((wq_completion)hci2){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc9000309fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff88807d985048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551
3 locks held by kworker/u5:5/5430:
 #0: ffff88805b8c0938 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88805b8c0938 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88805b8c0938 ((wq_completion)hci0){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88805b8c0938 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88805b8c0938 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88805b8c0938 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90002e3fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff888075741048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 29 Comm: khungtaskd Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xc22/0xf90 kernel/hung_task.c:378
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.18.0-rc5-next-20220502-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:__lock_acquire+0xd51/0x5660 kernel/locking/lockdep.c:5063
Code: 03 0f b6 04 02 84 c0 74 0d 3c 03 7f 09 48 8b 3c 24 e8 63 78 69 00 41 8b 85 58 0a 00 00 83 c0 01 83 f8 2f 41 89 85 58 0a 00 00 <0f> 87 eb 0b 00 00 3b 05 53 e2 1e 0e 41 be 01 00 00 00 0f 86 c8 00
RSP: 0018:ffffc900000d7748 EFLAGS: 00000097
RAX: 0000000000000006 RBX: ffffffff8f3c6c00 RCX: ffffffff815ddcee
RDX: 1ffff110021e1c5b RSI: 0000000000000001 RDI: ffffffff8f3c6c18
RBP: 000000000000f5e5 R08: 0000000000000000 R09: ffffffff9007b897
R10: fffffbfff200f712 R11: 0000000000000001 R12: ffff888010f0e3a8
R13: ffff888010f0d880 R14: 0000000000000000 R15: d4985ce4c67f0360
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c001d7d000 CR3: 000000000ba8e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:354 [inline]
 __get_locked_pte+0x154/0x270 mm/memory.c:1830
 get_locked_pte include/linux/mm.h:2127 [inline]
 __text_poke+0x1ae/0x8c0 arch/x86/kernel/alternative.c:1038
 text_poke arch/x86/kernel/alternative.c:1121 [inline]
 text_poke_bp_batch+0x433/0x6b0 arch/x86/kernel/alternative.c:1436
 text_poke_flush arch/x86/kernel/alternative.c:1542 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1539 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1549
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x32f/0x410 kernel/jump_label.c:830
 static_key_disable_cpuslocked+0x152/0x1b0 kernel/jump_label.c:207
 static_key_disable+0x16/0x20 kernel/jump_label.c:215
 toggle_allocation_gate mm/kfence/core.c:809 [inline]
 toggle_allocation_gate+0x183/0x390 mm/kfence/core.c:787
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
----------------
Code disassembly (best guess):
   0:	03 0f                	add    (%rdi),%ecx
   2:	b6 04                	mov    $0x4,%dh
   4:	02 84 c0 74 0d 3c 03 	add    0x33c0d74(%rax,%rax,8),%al
   b:	7f 09                	jg     0x16
   d:	48 8b 3c 24          	mov    (%rsp),%rdi
  11:	e8 63 78 69 00       	callq  0x697879
  16:	41 8b 85 58 0a 00 00 	mov    0xa58(%r13),%eax
  1d:	83 c0 01             	add    $0x1,%eax
  20:	83 f8 2f             	cmp    $0x2f,%eax
  23:	41 89 85 58 0a 00 00 	mov    %eax,0xa58(%r13)
* 2a:	0f 87 eb 0b 00 00    	ja     0xc1b <-- trapping instruction
  30:	3b 05 53 e2 1e 0e    	cmp    0xe1ee253(%rip),%eax        # 0xe1ee289
  36:	41 be 01 00 00 00    	mov    $0x1,%r14d
  3c:	0f                   	.byte 0xf
  3d:	86 c8                	xchg   %cl,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
