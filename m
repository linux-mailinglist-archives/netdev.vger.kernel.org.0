Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DE16B6CBF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 01:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCMAIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 20:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCMAIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 20:08:54 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE1B2BED0
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 17:08:52 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id t16-20020a92c0d0000000b00319bb6f4282so5698909ilf.20
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 17:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678666131;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tw5uPPh0BTYO11T7zbOL0CDLetAIImIpVwkeUqAmlWU=;
        b=JHYlHDQx/Nng3uREp48PPraTnJCUOYy6MM5bT3resYOxmVlTvAl5gJ0UenNB3o07AO
         sD3Hr6L1c0eiW0lb8E/fa0CXJkrqtimhltARyzByuJ9T0vgpOp4VF32ynE9wY8JjPUre
         AMQmPVmDOzL4HdKjGnGdbRX5Ztqc8IHtOD6IFYkyvTs3PBbSZWTsPXGFPZ7HnykPAs3A
         BGO0JAHjjj83ADa9oxWYWsgvx0qlCacCy+/MtO90m2fnMzO83BENHEkT6votgC7jbmsi
         ePXNRs8DTI0ZxefoiD/3DKpmmjABGxryNnUQfagMy9JTwpqXS5YdZmTD0bmITm4gHP3Q
         nL1w==
X-Gm-Message-State: AO0yUKUWWzmEEQzkBKB07HtDlbDUlqWASwIBj7LbmRc63x2eyxhFKbHm
        ljY+fXJORk6LTR2GUOiN4fvV90uG7AxYAmhc6OLIVhBXmphM
X-Google-Smtp-Source: AK7set9nsrOrfkpiScoUQN5xa6SJXX04+SSVIMh9QK9AOSQjeePSuMrH5TOobjTuEM9EDiaJEl/PM9qbN54e2fze0yuWm76GPqu6
MIME-Version: 1.0
X-Received: by 2002:a5e:d60c:0:b0:74d:13bc:e9e6 with SMTP id
 w12-20020a5ed60c000000b0074d13bce9e6mr14934879iom.3.1678666131326; Sun, 12
 Mar 2023 17:08:51 -0700 (PDT)
Date:   Sun, 12 Mar 2023 17:08:51 -0700
In-Reply-To: <000000000000750a0205f62abbf1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000744de105f6bcea41@google.com>
Subject: Re: [syzbot] [net?] INFO: task hung in del_device_store
From:   syzbot <syzbot+6d10ecc8a97cc10639f9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    134231664868 Merge tag 'staging-6.3-rc2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c8f12ac80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aef547e348b1ab8
dashboard link: https://syzkaller.appspot.com/bug?extid=6d10ecc8a97cc10639f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1064db24c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/810b18cfd92d/disk-13423166.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/49409dbd680c/vmlinux-13423166.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c4a589bbe527/bzImage-13423166.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d10ecc8a97cc10639f9@syzkaller.appspotmail.com

INFO: task syz-executor.2:5255 blocked for more than 143 seconds.
      Not tainted 6.3.0-rc1-syzkaller-00274-g134231664868 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:25064 pid:5255  ppid:1      flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xc91/0x57d0 kernel/sched/core.c:6622
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
RIP: 0033:0x7fe9c963de7f
RSP: 002b:00007fe9c98cf220 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe9c963de7f
RDX: 0000000000000001 RSI: 00007fe9c98cf270 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007fe9c98cf1c0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007fe9c96e76fe
R13: 00007fe9c98cf270 R14: 0000000000000000 R15: 00007fe9c98cf940
 </TASK>
INFO: task syz-executor.3:5267 blocked for more than 143 seconds.
      Not tainted 6.3.0-rc1-syzkaller-00274-g134231664868 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:24864 pid:5267  ppid:1      flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xc91/0x57d0 kernel/sched/core.c:6622
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
RIP: 0033:0x7f1677c3de7f
RSP: 002b:00007f1677ecf220 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f1677c3de7f
RDX: 0000000000000001 RSI: 00007f1677ecf270 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007f1677ecf1c0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f1677ce76fe
R13: 00007f1677ecf270 R14: 0000000000000000 R15: 00007f1677ecf940
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8c7954b0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8c7951b0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
3 locks held by kworker/1:0/22:
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x87a/0x1710 kernel/workqueue.c:2361
 #1: ffffc900001c7da8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1710 kernel/workqueue.c:2365
 #2: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xf/0x70 net/core/link_watch.c:277
1 lock held by khungtaskd/28:
 #0: ffffffff8c796000 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x340 kernel/locking/lockdep.c:6495
1 lock held by dhcpcd/4657:
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: __netlink_dump_start+0x16e/0x910 net/netlink/af_netlink.c:2365
2 locks held by getty/4759:
 #0: ffff88802bf24098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x26/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc900015b02f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xef4/0x13e0 drivers/tty/n_tty.c:2177
4 locks held by kworker/u4:1/5194:
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888016617138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x87a/0x1710 kernel/workqueue.c:2361
 #1: ffffc9000432fda8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1710 kernel/workqueue.c:2365
 #2: ffffffff8e0ef810 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9f/0xb10 net/core/net_namespace.c:575
 #3: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: ppp_exit_net+0xa6/0x360 drivers/net/ppp/ppp_generic.c:1129
3 locks held by kworker/u4:2/5198:
2 locks held by kworker/0:6/5224:
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x87a/0x1710 kernel/workqueue.c:2361
 #1: ffffc900044bfda8 ((work_completion)(&rew->rew_work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1710 kernel/workqueue.c:2365
4 locks held by syz-executor.2/5255:
 #0: ffff888018b7c460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88806cd89488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff8880214e4490 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6ca8 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
4 locks held by syz-executor.3/5267:
 #0: ffff888018b7c460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88806e3d0c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff8880214e4490 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6ca8 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
6 locks held by syz-executor.0/5270:
 #0: ffff888018b7c460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88806e0c3c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff8880214e4490 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6ca8 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
 #4: ffff88807eb6e0e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:832 [inline]
 #4: ffff88807eb6e0e8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1063 [inline]
 #4: ffff88807eb6e0e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0xa4/0x610 drivers/base/dd.c:1260
 #5: ffffffff8e0ef810 (pernet_ops_rwsem){++++}-{3:3}, at: unregister_netdevice_notifier+0x22/0x180 net/core/dev.c:1759
4 locks held by syz-executor.3/5503:
 #0: ffff888018b7c460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff888070bef488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff8880214e4490 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6ca8 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
4 locks held by syz-executor.0/5506:
 #0: ffff888018b7c460 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x12b/0x250 fs/read_write.c:637
 #1: ffff88806d8dbc88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x285/0x600 fs/kernfs/file.c:325
 #2: ffff8880214e4490 (kn->active#51){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2a9/0x600 fs/kernfs/file.c:326
 #3: ffffffff8d7e6ca8 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xc9/0x4a0 drivers/net/netdevsim/bus.c:209
1 lock held by syz-executor.5/5671:
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e8/0xd50 net/core/rtnetlink.c:6171
1 lock held by syz-executor.2/5675:
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e8/0xd50 net/core/rtnetlink.c:6171
2 locks held by syz-executor.4/5682:
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e103348 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e8/0xd50 net/core/rtnetlink.c:6171
 #1: ffffffff8c7a12f8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:293 [inline]
 #1: ffffffff8c7a12f8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x64a/0x770 kernel/rcu/tree_exp.h:989

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 28 Comm: khungtaskd Not tainted 6.3.0-rc1-syzkaller-00274-g134231664868 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x29c/0x350 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x2a4/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:222 [inline]
 watchdog+0xe16/0x1150 kernel/hung_task.c:379
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 5198 Comm: kworker/u4:2 Not tainted 6.3.0-rc1-syzkaller-00274-g134231664868 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: bat_events batadv_nc_worker
RIP: 0010:mark_lock.part.0+0x0/0x1970 kernel/locking/lockdep.c:4594
Code: 78 8e e8 53 34 70 00 e9 27 fe ff ff 48 c7 c7 ec 79 78 8e e8 42 34 70 00 e9 b3 fe ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 <41> 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49
RSP: 0018:ffffc9000436fa28 EFLAGS: 00000046
RAX: 0000000000000000 RBX: 00000000000006cb RCX: ffffffff81650cf0
RDX: 0000000000000008 RSI: ffff888071ab0a88 RDI: ffff888071ab0000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff914d6c5f
R10: fffffbfff229ad8b R11: 0000000000000000 R12: ffff888071ab0a88
R13: ffff888071ab0000 R14: ffff888071ab0a38 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ed5ee93600 CR3: 000000000c571000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mark_lock kernel/locking/lockdep.c:4599 [inline]
 mark_usage kernel/locking/lockdep.c:4556 [inline]
 __lock_acquire+0x8a8/0x5d40 kernel/locking/lockdep.c:5010
 lock_acquire kernel/locking/lockdep.c:5669 [inline]
 lock_acquire+0x1af/0x5b0 kernel/locking/lockdep.c:5634
 rcu_lock_acquire include/linux/rcupdate.h:327 [inline]
 rcu_read_lock include/linux/rcupdate.h:773 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
 batadv_nc_worker+0x131/0xfe0 net/batman-adv/network-coding.c:719
 process_one_work+0x991/0x1710 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

