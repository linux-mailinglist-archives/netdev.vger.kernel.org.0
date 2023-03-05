Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D826AB19E
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 18:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCERom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 12:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCERok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 12:44:40 -0500
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5110EB74C
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 09:44:38 -0800 (PST)
Received: by mail-il1-f207.google.com with SMTP id h1-20020a92d841000000b0031b4d3294dfso3181919ilq.9
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 09:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=COKVlagSSW5Y4io8rieuDYRuth41fySumMDuD6/wKSI=;
        b=j1F2WuNcc2mFuVB141Pd939SH5AB7aNUfpFD5BC6g08pmBao6xiLCACIwztKrIAvjV
         UhfgN/7kId0NLtOVKMEOOI057Sd0lcaljPH6agvAgDOBkRHCrNrHzWdqaTvEoJ72LpRm
         ZWqKOBsJGsRDxjWjoNGcdnK3glsAEiG1h56KEA+NyVfddB9Jdd7EYGskH3D3CMS7t1Ya
         ytBheoCkiwDaD5DSa05Q0uusc3IJ2411R2//BylBs97MEJbrl+Jy84BIKaJ4da2dW1vj
         LaMaE0rSoGxhLUUMk5iefQdohmSLBLvn5nQBWR3sFmCUjUs9qcgTaQT9NF0MHXcaKXTf
         fFIg==
X-Gm-Message-State: AO0yUKXp56/Q9D5sEkw9aTF7OH8zrq8orHzgobUR80qRXb6DKSOu2/++
        v8x6+kiY3waUsiG7n1F+Q+n77+Mh5bE+1+Ze9e43WAvH4g+H
X-Google-Smtp-Source: AK7set9Qp75eez7NIH+KUMUxtxPXK6ubjtQjTixbfYmiU0/jfAVj5LYK3623OybnVwh4Y98aV/KR7lWGPdc5M+pS/4J3jcKpszJ2
MIME-Version: 1.0
X-Received: by 2002:a02:85aa:0:b0:3f6:657a:e922 with SMTP id
 d39-20020a0285aa000000b003f6657ae922mr2237387jai.5.1678038277618; Sun, 05 Mar
 2023 09:44:37 -0800 (PST)
Date:   Sun, 05 Mar 2023 09:44:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000750a0205f62abbf1@google.com>
Subject: [syzbot] [net?] INFO: task hung in del_device_store
From:   syzbot <syzbot+6d10ecc8a97cc10639f9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b01fe98d34f3 Merge tag 'i2c-for-6.3-rc1-part2' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12441638c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
dashboard link: https://syzkaller.appspot.com/bug?extid=6d10ecc8a97cc10639f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/918d4a4cfe62/disk-b01fe98d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5341ab364392/vmlinux-b01fe98d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bb74b14652fd/bzImage-b01fe98d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d10ecc8a97cc10639f9@syzkaller.appspotmail.com

INFO: task syz-executor.0:19488 blocked for more than 143 seconds.
      Not tainted 6.2.0-syzkaller-13534-gb01fe98d34f3 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:25064 pid:19488 ppid:1      flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
 bus_attr_store+0x76/0xa0 drivers/base/bus.c:170
 sysfs_kf_write+0x114/0x170 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x3f1/0x600 fs/kernfs/file.c:334
 call_write_iter include/linux/fs.h:1851 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9ed/0xe10 fs/read_write.c:584
 ksys_write+0x12b/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f40ed83de7f
RSP: 002b:00007f40edacf220 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f40ed83de7f
RDX: 0000000000000001 RSI: 00007f40edacf270 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007f40edacf1c0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f40ed8e76fe
R13: 00007f40edacf270 R14: 0000000000000000 R15: 00007f40edacf940
 </TASK>
INFO: task syz-executor.4:19495 blocked for more than 143 seconds.
      Not tainted 6.2.0-syzkaller-13534-gb01fe98d34f3 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:25024 pid:19495 ppid:1      flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
 bus_attr_store+0x76/0xa0 drivers/base/bus.c:170
 sysfs_kf_write+0x114/0x170 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x3f1/0x600 fs/kernfs/file.c:334
 call_write_iter include/linux/fs.h:1851 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9ed/0xe10 fs/read_write.c:584
 ksys_write+0x12b/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7faad3e3de7f
RSP: 002b:00007faad40cf220 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007faad3e3de7f
RDX: 0000000000000001 RSI: 00007faad40cf270 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007faad40cf1c0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007faad3ee76fe
R13: 00007faad40cf270 R14: 0000000000000000 R15: 00007faad40cf940
 </TASK>
INFO: task syz-executor.2:19500 blocked for more than 144 seconds.
      Not tainted 6.2.0-syzkaller-13534-gb01fe98d34f3 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:24352 pid:19500 ppid:1      flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
 bus_attr_store+0x76/0xa0 drivers/base/bus.c:170
 sysfs_kf_write+0x114/0x170 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x3f1/0x600 fs/kernfs/file.c:334
 call_write_iter include/linux/fs.h:1851 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9ed/0xe10 fs/read_write.c:584
 ksys_write+0x12b/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f929f83de7f
RSP: 002b:00007f929facf220 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f929f83de7f
RDX: 0000000000000001 RSI: 00007f929facf270 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007f929facf1c0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f929f8e76fe
R13: 00007f929facf270 R14: 0000000000000000 R15: 00007f929facf940
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8c794eb0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8c794bb0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
1 lock held by ksoftirqd/1/21:
1 lock held by khungtaskd/28:
 #0: ffffffff8c795a00 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x340 kernel/locking/lockdep.c:6495
4 locks held by kworker/u4:2/41:
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x86d/0x1820 kernel/workqueue.c:2361
 #1: ffffc90000b27da8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8a1/0x1820 kernel/workqueue.c:2365
 #2: ffffffff8e0ef5d0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9f/0xb10 net/core/net_namespace.c:575
 #3: ffffffff8c7a0bc0 (rcu_state.barrier_mutex){+.+.}-{3:3}, at: rcu_barrier+0x48/0x6d0 kernel/rcu/tree.c:3945
3 locks held by kworker/u4:3/47:
2 locks held by getty/4761:
 #0: ffff8880284b5098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x26/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc900015a02f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xef4/0x13e0 drivers/tty/n_tty.c:2177
3 locks held by kworker/u4:7/15346:
6 locks held by syz-executor.2/19438:
 #0: ffff88802b7b8460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88801d849c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff88802103dae8 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6a28 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
 #4: ffff8880421d80e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:832 [inline]
 #4: ffff8880421d80e8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1063 [inline]
 #4: ffff8880421d80e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0xa4/0x610 drivers/base/dd.c:1260
 #5: ffffffff8e0ef5d0 (pernet_ops_rwsem){++++}-{3:3}, at: unregister_netdevice_notifier+0x22/0x180 net/core/dev.c:1759
4 locks held by syz-executor.0/19488:
 #0: ffff88802b7b8460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88804a7c4088 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff88802103dae8 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6a28 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
4 locks held by syz-executor.4/19495:
 #0: ffff88802b7b8460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88804103ec88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff88802103dae8 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6a28 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
4 locks held by syz-executor.2/19500:
 #0: ffff88802b7b8460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff888049360c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff88802103dae8 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6a28 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
1 lock held by syz-executor.4/19931:
 #0: ffffffff8e0ef5d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x4cb/0x8e0 net/core/net_namespace.c:486
1 lock held by syz-executor.2/19936:
 #0: ffffffff8e0ef5d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x4cb/0x8e0 net/core/net_namespace.c:486
1 lock held by syz-executor.0/19948:
 #0: ffffffff8e0ef5d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x4cb/0x8e0 net/core/net_namespace.c:486

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: khungtaskd Not tainted 6.2.0-syzkaller-13534-gb01fe98d34f3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x316/0x3e0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x33f/0x460 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:222 [inline]
 watchdog+0xe94/0x11e0 kernel/hung_task.c:379
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 15346 Comm: kworker/u4:7 Not tainted 6.2.0-syzkaller-13534-gb01fe98d34f3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: bat_events batadv_nc_worker
RIP: 0010:kasan_check_range+0x12/0x190 mm/kasan/generic.c:186
Code: 24 df ff ff 89 43 08 5b 5d 41 5c c3 66 66 2e 0f 1f 84 00 00 00 00 00 90 66 0f 1f 00 48 85 f6 0f 84 3c 01 00 00 49 89 f9 41 54 <44> 0f b6 c2 49 01 f1 55 53 0f 82 18 01 00 00 48 b8 ff ff ff ff ff
RSP: 0018:ffffc9000511f9a8 EFLAGS: 00000002
RAX: 000000000000001b RBX: 00000000000006c4 RCX: ffffffff8165ea80
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff914dec58
RBP: 0000000000000004 R08: 0000000000000000 R09: ffffffff914dec58
R10: fffffbfff229bd8b R11: 0000000000000000 R12: 0000000000000001
R13: ffff888050163a80 R14: ffff8880501644b8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000d31000 CR3: 000000000c571000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 hlock_class kernel/locking/lockdep.c:228 [inline]
 check_wait_context kernel/locking/lockdep.c:4755 [inline]
 __lock_acquire+0x6f0/0x5d40 kernel/locking/lockdep.c:5006
 lock_acquire kernel/locking/lockdep.c:5669 [inline]
 lock_acquire+0x1e3/0x670 kernel/locking/lockdep.c:5634
 rcu_lock_acquire include/linux/rcupdate.h:327 [inline]
 rcu_read_lock include/linux/rcupdate.h:773 [inline]
 batadv_nc_process_nc_paths.part.0+0xec/0x3f0 net/batman-adv/network-coding.c:687
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:679 [inline]
 batadv_nc_worker+0xd20/0xfe0 net/batman-adv/network-coding.c:735
 process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
