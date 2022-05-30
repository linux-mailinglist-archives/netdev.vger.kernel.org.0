Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D95537550
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiE3HOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiE3HOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:14:31 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5311286D0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:14:29 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id h9-20020a056e021d8900b002d39d3d2367so3020382ila.3
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vu9s7JaJsIRlCSKC6DiPcrE594Tl3l5z2UrTEmKmA5Y=;
        b=1Yok5Bork93pj4TOMI9N1YyJ5B7hJ+d7V+NPmyoSW/vC0APuytxzFFR45talhJKsIZ
         9DiN/aN6V1ZrvqnSdPc21v6ISuNEmQ9WtTwhfh/zp+h6g4LnKseefM1H/+FPBy/TNerc
         /nFxDikS2t/CG5JE+GmMizEVhg71Vt9P76blXGXyNaW3L9bn5DER+X2khSxR8ILG9kBu
         EuDkXrKzzl6MJEgfFpi+A8M/kBLmkIxt5NNAzpQykIQnPe6GqKdiPqfyYtdqdlYWgs+H
         yx5AfeBhCBJRpcRkuvY4gHc0MaGAK2Kn2xGGsQXb95P7PxsYGMaMfFSQEyE0IV70QtCJ
         TwMw==
X-Gm-Message-State: AOAM530yo/RBnD7pZgUybaFCDrwZgGZwV16wBHrsjgPBq0OVsmvpAbWH
        oZPX2tpffRMbEk1K3tO2InKrMNgcl1kDq3rPqBii4s99OEqu
X-Google-Smtp-Source: ABdhPJxQCBFuhI7Pe/Im2MLer+CVUcR3cJ+LPRPcdSPvI6fGtLCtO1AG/+ApaLPtxvXrKrM8AXzVCMT6j9/aXLxuKhovhcDSRmaI
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4985:b0:32e:ddf4:e1ed with SMTP id
 cv5-20020a056638498500b0032eddf4e1edmr16496667jab.284.1653894869077; Mon, 30
 May 2022 00:14:29 -0700 (PDT)
Date:   Mon, 30 May 2022 00:14:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ad5ee05e03568f4@google.com>
Subject: [syzbot] INFO: task can't die in vlan_ioctl_handler
From:   syzbot <syzbot+6db61674290152a463a0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, keescook@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        william.xuanziyang@huawei.com, zhudi21@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f81e94e91878 Add linux-next specific files for 20211125
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12fd3609b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be9183de0824e4d7
dashboard link: https://syzkaller.appspot.com/bug?extid=6db61674290152a463a0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6db61674290152a463a0@syzkaller.appspotmail.com

INFO: task syz-executor.1:28061 can't die for more than 143 seconds.
task:syz-executor.1  state:D stack:27480 pid:28061 ppid: 26621 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4983 [inline]
 __schedule+0xab2/0x4d90 kernel/sched/core.c:6293
 schedule+0xd2/0x260 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 vlan_ioctl_handler+0xb7/0xec0 net/8021q/vlan.c:557
 sock_ioctl+0x1d8/0x640 net/socket.c:1199
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6130d89ae9
RSP: 002b:00007f612e2ff188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6130e9cf60 RCX: 00007f6130d89ae9
RDX: 0000000020000000 RSI: 0000000000008982 RDI: 0000000000000005
RBP: 00007f6130de3f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff3c576def R14: 00007f612e2ff300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.1:28061 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc2-next-20211125-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.1  state:D stack:27480 pid:28061 ppid: 26621 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4983 [inline]
 __schedule+0xab2/0x4d90 kernel/sched/core.c:6293
 schedule+0xd2/0x260 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 vlan_ioctl_handler+0xb7/0xec0 net/8021q/vlan.c:557
 sock_ioctl+0x1d8/0x640 net/socket.c:1199
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6130d89ae9
RSP: 002b:00007f612e2ff188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6130e9cf60 RCX: 00007f6130d89ae9
RDX: 0000000020000000 RSI: 0000000000008982 RDI: 0000000000000005
RBP: 00007f6130de3f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff3c576def R14: 00007f612e2ff300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb83220 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
3 locks held by kworker/1:3/2985:
 #0: ffff88814a039d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88814a039d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88814a039d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff88814a039d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff88814a039d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff88814a039d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2270
 #1: ffffc90001acfdb0 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2274
 #2: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4595
1 lock held by in:imklog/6221:
 #0: ffff88807e445270 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
2 locks held by agetty/6296:
 #0: ffff888023ca4098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:252
 #1: ffffc9000274c2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2113
2 locks held by agetty/6327:
 #0: ffff88807b627098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:252
 #1: ffffc90001f682e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2113
3 locks held by kworker/1:2/1415:
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2270
 #1: ffffc9000b15fdb0 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2274
 #2: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
5 locks held by kworker/u4:1/22852:
 #0: ffff8880119f3138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880119f3138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8880119f3138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff8880119f3138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff8880119f3138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff8880119f3138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2270
 #1: ffffc9000e7f7db0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2274
 #2: ffffffff8d2f8850 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb00 net/core/net_namespace.c:555
 #3: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_unregistering net/core/dev.c:10879 [inline]
 #3: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xe8/0x3c0 net/core/dev.c:10917
 #4: ffffffff8bb8cb30 (rcu_state.barrier_mutex){+.+.}-{3:3}, at: rcu_barrier+0x44/0x440 kernel/rcu/tree.c:4026
3 locks held by kworker/1:4/23005:
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2270
 #1: ffffc9000ecf7db0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2274
 #2: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:251
1 lock held by syz-executor.1/27113:
 #0: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3402
2 locks held by syz-executor.1/28061:
 #0: ffffffff8d2e9a28 (vlan_ioctl_mutex){+.+.}-{3:3}, at: sock_ioctl+0x1bf/0x640 net/socket.c:1197
 #1: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: vlan_ioctl_handler+0xb7/0xec0 net/8021q/vlan.c:557
3 locks held by kworker/1:5/28145:
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2270
 #1: ffffc9000b83fdb0 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2274
 #2: ffffffff8d30cce8 (rtnl_mutex){+.+.}-{3:3}, at: reg_check_chans_work+0x83/0xe10 net/wireless/reg.c:2423

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc2-next-20211125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:256 [inline]
 watchdog+0xcb7/0xed0 kernel/hung_task.c:413
 kthread+0x405/0x4f0 kernel/kthread.c:345
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6221 Comm: in:imklog Not tainted 5.16.0-rc2-next-20211125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mark_usage kernel/locking/lockdep.c:4485 [inline]
RIP: 0010:__lock_acquire+0x77a/0x54a0 kernel/locking/lockdep.c:4981
Code: 00 00 44 8b 54 24 08 45 85 d2 0f 84 37 01 00 00 49 8d 7c 24 21 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 04 02 <48> 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 19 39 00 00 49 8d 6c 24
RSP: 0018:ffffc9000b59f770 EFLAGS: 00000806
RAX: 0000000000000000 RBX: 0000000000000552 RCX: ffffffff815c786d
RDX: 1ffff1100eecf156 RSI: 0000000000000008 RDI: ffff888077678ab1
RBP: 0000000000000003 R08: 0000000000000000 R09: ffffffff8ff819ef
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888077678a90
R13: ffff888077678000 R14: ffff888077678a68 R15: dffffc0000000000
FS:  00007fb231d4f700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f93356ac000 CR3: 0000000070edc000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __mutex_lock_common kernel/locking/mutex.c:607 [inline]
 __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:740
 syslog_print+0x39a/0x580 kernel/printk/printk.c:1557
 do_syslog.part.0+0x202/0x640 kernel/printk/printk.c:1658
 do_syslog+0x49/0x60 kernel/printk/printk.c:1643
 kmsg_read+0x90/0xb0 fs/proc/kmsg.c:40
 pde_read fs/proc/inode.c:311 [inline]
 proc_reg_read+0x119/0x300 fs/proc/inode.c:321
 vfs_read+0x1b5/0x600 fs/read_write.c:479
 ksys_read+0x12d/0x250 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb23439222d
Code: c1 20 00 00 75 10 b8 00 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 4e fc ff ff 48 89 04 24 b8 00 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 97 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fb231d2e580 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb23439222d
RDX: 0000000000001fa0 RSI: 00007fb231d2eda0 RDI: 0000000000000004
RBP: 000055ab9ea8d9d0 R08: 0000000000000000 R09: 0000000000000000
R10: 2ce33e6c02ce33e7 R11: 0000000000000293 R12: 00007fb231d2eda0
R13: 0000000000001fa0 R14: 0000000000001f9f R15: 00007fb231d2ee1e
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	44 8b 54 24 08       	mov    0x8(%rsp),%r10d
   7:	45 85 d2             	test   %r10d,%r10d
   a:	0f 84 37 01 00 00    	je     0x147
  10:	49 8d 7c 24 21       	lea    0x21(%r12),%rdi
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1c:	fc ff df
  1f:	48 89 fa             	mov    %rdi,%rdx
  22:	48 c1 ea 03          	shr    $0x3,%rdx
  26:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
* 2a:	48 89 fa             	mov    %rdi,%rdx <-- trapping instruction
  2d:	83 e2 07             	and    $0x7,%edx
  30:	38 d0                	cmp    %dl,%al
  32:	7f 08                	jg     0x3c
  34:	84 c0                	test   %al,%al
  36:	0f 85 19 39 00 00    	jne    0x3955
  3c:	49                   	rex.WB
  3d:	8d                   	.byte 0x8d
  3e:	6c                   	insb   (%dx),%es:(%rdi)
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
