Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08304BA144
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbiBQNcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:32:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240863AbiBQNci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:32:38 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4CA1EE2DA
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:32:22 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id b20-20020a6b6714000000b0063daf05574cso2153084ioc.5
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:32:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BdEYcVrDaXyvLaUZtipequ/WknP6S+W/CJpk30vQdHo=;
        b=JPM7t1OeZoB+BPHY8beGqtmuVa847rPk6FAI5AER1A+CSIBOBV3IiK4tCpaUzBjOyM
         pUNtNdSOM0Fhcd4UJqzRSsQ8E7BZ1MW7C5qLQYzn21Pr75zfWxegv6KLbyNT6xB6yu2N
         MPuVMhq4ZstvC/Ao/IO137gAN7mncaIdOSPdtHHbMM0NAauDexEEWH8CdQQvkn2qppve
         88bwObouhlqUMIM+Z7n4JZVqa55/E4UDn4mDtuopJgMhbU23jvCSbkq1n+F/3X+Q1UUM
         Ny8HPQg7LV76MTgdLtvpFZSabLfaNzr1X/4wDkRCSrB//smjNU08r0WRWUKy7dVMZw6t
         aJBA==
X-Gm-Message-State: AOAM531vVBKKgxmR3J/8PSY9LYwtbh4rn4vpvbg+FD0akwqXB0ic+44q
        Mut2hsBdlc/rEvw7LDgcdb/b6Fipxalox/GGWcdiB1C83NCB
X-Google-Smtp-Source: ABdhPJwAqeDEkaOoJqTLj1S1wqKSAzfjkipZlt1owxXfJXzSkL2foNp2OUpRyU08B+d+OQdRAwbFvU92uhScJ0H29WHIeGjO15ZU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168b:b0:2be:8cfa:deb7 with SMTP id
 f11-20020a056e02168b00b002be8cfadeb7mr1894558ila.2.1645104741379; Thu, 17 Feb
 2022 05:32:21 -0800 (PST)
Date:   Thu, 17 Feb 2022 05:32:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba755205d836cbb4@google.com>
Subject: [syzbot] INFO: task hung in usbnet_disconnect
From:   syzbot <syzbot+2fc20706c90534c035a5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    9902951f536c usb: host: ehci-platform: Update brcm, xgs-ip..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1386425a700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83e40899a8923e35
dashboard link: https://syzkaller.appspot.com/bug?extid=2fc20706c90534c035a5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2fc20706c90534c035a5@syzkaller.appspotmail.com

INFO: task kworker/1:9:2122 blocked for more than 143 seconds.
      Not tainted 5.17.0-rc4-syzkaller-00063-g9902951f536c #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:9     state:D
 stack:24536 pid: 2122 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4987 [inline]
 __schedule+0x931/0x22e0 kernel/sched/core.c:6296
 schedule+0xd2/0x260 kernel/sched/core.c:6369
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6428
 __mutex_lock_common kernel/locking/mutex.c:673 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:733
 unregister_netdev+0xe/0x20 net/core/dev.c:10473
 usbnet_disconnect+0x139/0x270 drivers/net/usb/usbnet.c:1623
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x5d7/0x700 drivers/base/dd.c:1206
 device_release_driver_internal drivers/base/dd.c:1237 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1260
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5206 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5506 [inline]
 port_event drivers/usb/core/hub.c:5664 [inline]
 hub_event+0x1e39/0x44d0 drivers/usb/core/hub.c:5746
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2ef/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/1:1/23:
 #0: ffff88810dd65d38
 (
(wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
(wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
(wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
(wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
(wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
(wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: ffffc90000197db8 ((addr_chk_work).work
){+.+.}-{0:0}, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffffffff88885068
 (rtnl_mutex
){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4608
1 lock held by khungtaskd/25:
 #0: ffffffff87891580 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6460
5 locks held by dhcpcd/1206:
2 locks held by getty/1228:
 #0: ffff88810e5ed098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 #1: 
ffffc900000432e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2077
3 locks held by kworker/1:4/4061:
6 locks held by kworker/0:9/8708:
 #0: ffff888103ffb938 (
(wq_completion)usb_hub_wq
){+.+.}-{0:0}
, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
, at: set_work_data kernel/workqueue.c:631 [inline]
, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: 
ffffc9000ae4fdb8 ((work_completion)(&hub->events)){+.+.}-{0:0}
, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffff88810cfa7220 (&dev->mutex
){....}-{3:3}
, at: device_lock include/linux/device.h:767 [inline]
, at: hub_event+0x1c5/0x44d0 drivers/usb/core/hub.c:5692
 #3: ffff88813940f220 (&dev->mutex){....}-{3:3}
, at: device_lock include/linux/device.h:767 [inline]
, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:945
 #4: ffff8881162f71a8 (&dev->mutex){....}-{3:3}
, at: device_lock include/linux/device.h:767 [inline]
, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:945
 #5: ffffffff88885068 (rtnl_mutex){+.+.}-{3:3}, at: register_netdev+0x11/0x50 net/core/dev.c:9789
6 locks held by kworker/0:3/14947:
 #0: ffff888103ffb938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103ffb938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888103ffb938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888103ffb938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
 #0: ffff888103ffb938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
 #0: ffff888103ffb938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: 
ffffc90001967db8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffff88810cf8f220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:767 [inline]
 #2: ffff88810cf8f220 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x44d0 drivers/usb/core/hub.c:5692
 #3: ffff8881185d5220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:767 [inline]
 #3: ffff8881185d5220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:945
 #4: ffff888102bef1a8
 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:767 [inline]
 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:945
 #5: ffffffff88885068 (rtnl_mutex){+.+.}-{3:3}, at: register_netdev+0x11/0x50 net/core/dev.c:9789
2 locks held by kworker/0:5/22151:
3 locks held by udevd/23447:
 #0: ffff888117765488 (&of->mutex){+.+.}-{3:3}, at: kernfs_file_read_iter fs/kernfs/file.c:203 [inline]
 #0: ffff888117765488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_read_iter+0x189/0x6f0 fs/kernfs/file.c:242
 #1: 
ffff88811c10a008 (kn->active#42){++++}-{0:0}, at: kernfs_file_read_iter fs/kernfs/file.c:204 [inline]
ffff88811c10a008 (kn->active#42){++++}-{0:0}, at: kernfs_fop_read_iter+0x1ac/0x6f0 fs/kernfs/file.c:242
 #2: ffff88813940f220 (&dev->mutex){....}-{3:3}, at: device_lock_interruptible include/linux/device.h:772 [inline]
 #2: ffff88813940f220 (&dev->mutex){....}-{3:3}, at: read_descriptors+0x3c/0x2c0 drivers/usb/core/sysfs.c:873
3 locks held by udevd/25732:
 #0: ffff888114ca4488
 (&of->mutex){+.+.}-{3:3}, at: kernfs_file_read_iter fs/kernfs/file.c:203 [inline]
 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_read_iter+0x189/0x6f0 fs/kernfs/file.c:242
 #1: ffff8881045ccae8
 (kn->active#42){++++}-{0:0}, at: kernfs_file_read_iter fs/kernfs/file.c:204 [inline]
 (kn->active#42){++++}-{0:0}, at: kernfs_fop_read_iter+0x1ac/0x6f0 fs/kernfs/file.c:242
 #2: 
ffff8881185d5220 (&dev->mutex){....}-{3:3}, at: device_lock_interruptible include/linux/device.h:772 [inline]
ffff8881185d5220 (&dev->mutex){....}-{3:3}, at: read_descriptors+0x3c/0x2c0 drivers/usb/core/sysfs.c:873
3 locks held by kworker/0:6/1503:
 #0: ffff888100065d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888100065d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888100065d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888100065d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
 #0: ffff888100065d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
 #0: ffff888100065d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: 
ffffc900081b7db8
 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffffffff88885068 (rtnl_mutex
){+.+.}-{3:3}
, at: reg_check_chans_work+0x83/0xe20 net/wireless/reg.c:2451
6 locks held by kworker/1:9/2122:
 #0: ffff888103ffb938
 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: ffffc9000aa2fdb8 ((work_completion)(&hub->events)
){+.+.}-{0:0}
, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffff88810d007220 (&dev->mutex){....}-{3:3}
, at: device_lock include/linux/device.h:767 [inline]
, at: hub_event+0x1c5/0x44d0 drivers/usb/core/hub.c:5692
 #3: ffff888132b23220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:767 [inline]
 #3: ffff888132b23220 (&dev->mutex){....}-{3:3}, at: usb_disconnect.cold+0x43/0x78e drivers/usb/core/hub.c:2219
 #4: ffff88811a4b21a8 (
&dev->mutex
){....}-{3:3}, at: device_lock include/linux/device.h:767 [inline]
){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1033 [inline]
){....}-{3:3}, at: device_release_driver_internal drivers/base/dd.c:1234 [inline]
){....}-{3:3}, at: device_release_driver+0x1c/0x40 drivers/base/dd.c:1260
 #5: ffffffff88885068 (rtnl_mutex){+.+.}-{3:3}, at: unregister_netdev+0xe/0x20 net/core/dev.c:10473
6 locks held by kworker/0:7/2345:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 25 Comm: khungtaskd Not tainted 5.17.0-rc4-syzkaller-00063-g9902951f536c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:369
 kthread+0x2ef/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 1206 Comm: dhcpcd Not tainted 5.17.0-rc4-syzkaller-00063-g9902951f536c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:lock_acquire+0x23/0x510 kernel/locking/lockdep.c:5607
Code: 1f 84 00 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 41 57 41 89 f7 41 56 49 89 fe 41 55 41 89 d5 41 54 41 89 cc 55 44 89 c5 53 <48> 81 ec b0 00 00 00 48 8d 5c 24 10 4c 89 0c 24 48 c7 44 24 10 b3
RSP: 0018:ffffc90000158cf8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: 0000000000000101 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000158d70
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffc90000158d70 R15: 0000000000000000
FS:  00007f5ee0550740(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efd390a5000 CR3: 000000010a691000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 call_timer_fn+0x12b/0x6b0 kernel/time/timer.c:1418
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x288/0x9a5 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x113/0x170 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:200
Code: 48 89 ef 5d e9 c1 95 2e 00 5d be 03 00 00 00 e9 86 ee c1 00 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 <65> 8b 05 29 6a be 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
RSP: 0018:ffffc90000df72d8 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888109ba0000 RSI: ffffffff812bd891 RDI: 0000000000000003
RBP: ffffc90000df7318 R08: 0000000000000000 R09: ffffffff8a7eb7f7
R10: ffffffff812bd887 R11: 0000000000000000 R12: 0000000000000037
R13: ffff888104fa0000 R14: 0000000000000200 R15: ffffc90000df7438
 console_trylock_spinning kernel/printk/printk.c:1885 [inline]
 vprintk_emit+0x377/0x4f0 kernel/printk/printk.c:2244
 dev_vprintk_emit+0x36e/0x3b2 drivers/base/core.c:4604
 dev_printk_emit+0xba/0xf1 drivers/base/core.c:4615
 __netdev_printk+0x1c6/0x27a net/core/dev.c:10782
 netdev_err+0xd7/0x109 net/core/dev.c:10834
 asix_set_sw_mii drivers/net/usb/asix_common.c:303 [inline]
 asix_set_sw_mii drivers/net/usb/asix_common.c:297 [inline]
 asix_check_host_enable.cold+0x22/0x66 drivers/net/usb/asix_common.c:74
 asix_mdio_read+0x90/0x250 drivers/net/usb/asix_common.c:499
 asix_phy_reset+0x104/0x170 drivers/net/usb/asix_devices.c:215
 ax88178_reset+0x3f5/0x1310 drivers/net/usb/asix_devices.c:977
 usbnet_open+0xc8/0x5d0 drivers/net/usb/usbnet.c:894
 __dev_open+0x2c4/0x4d0 net/core/dev.c:1407
 __dev_change_flags+0x583/0x750 net/core/dev.c:8139
 dev_change_flags+0x93/0x170 net/core/dev.c:8210
 devinet_ioctl+0x15d1/0x1ca0 net/ipv4/devinet.c:1144
 inet_ioctl+0x1e6/0x320 net/ipv4/af_inet.c:969
 sock_do_ioctl+0xcc/0x230 net/socket.c:1122
 sock_ioctl+0x2f1/0x640 net/socket.c:1239
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f5ee063e0e7
Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 9d 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc1074d898 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5ee05506c8 RCX: 00007f5ee063e0e7
RDX: 00007ffc1075da88 RSI: 0000000000008914 RDI: 0000000000000005
RBP: 00007ffc1076dc38 R08: 00007ffc1075da48 R09: 00007ffc1075d9f8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc1075da88 R14: 0000000000000028 R15: 0000000000008914
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	84 00                	test   %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 00                	add    %al,(%rax)
   6:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
   d:	fc ff df
  10:	41 57                	push   %r15
  12:	41 89 f7             	mov    %esi,%r15d
  15:	41 56                	push   %r14
  17:	49 89 fe             	mov    %rdi,%r14
  1a:	41 55                	push   %r13
  1c:	41 89 d5             	mov    %edx,%r13d
  1f:	41 54                	push   %r12
  21:	41 89 cc             	mov    %ecx,%r12d
  24:	55                   	push   %rbp
  25:	44 89 c5             	mov    %r8d,%ebp
  28:	53                   	push   %rbx
* 29:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp <-- trapping instruction
  30:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
  35:	4c 89 0c 24          	mov    %r9,(%rsp)
  39:	48                   	rex.W
  3a:	c7                   	.byte 0xc7
  3b:	44 24 10             	rex.R and $0x10,%al
  3e:	b3                   	.byte 0xb3


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
