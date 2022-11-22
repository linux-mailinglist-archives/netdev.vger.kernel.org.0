Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EB1634225
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiKVREl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiKVREk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:04:40 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372A1A18F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:04:39 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so7416990ioz.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:04:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aL7f2KpoIFhdUudbIp1Tf4EkE0wboOV8Py9SX06okvQ=;
        b=VHGdDf1h5yzhqs+aqB1LVywAH+nBFeQDyhfBB1hXBipEgAXFNwPjAuT0ou7jgJWp56
         mUYA526esfioBCLvsSInQiMn2kmqgfdPIW/F045i1IZg4ft7/TsFk94q4S1qfZonCi1S
         9kb4HnLpBueG/Z0DpSVn8n2uQDE1mYfbTmgoqYZTSUPiDyo6/eh1R/H6gy2LvPdvFX5K
         m5/xheFv4lJQ0Wuf9BLLgUvIu3UEzjkQmHgD2j3OnXcDqQf0+G2sW+2eZIeaoEyYhfdb
         mdKO0SgV97YpX6Ca5UNe4zExdIGigPQfUNfnQFHYZvADe8+PaFvzZYCUJuLbyau2AFXc
         /fkQ==
X-Gm-Message-State: ANoB5pm5jmRmjG3BLnS1WGK7fpYZesn35/22So5VKvdUOjLaFBSwyeoy
        YiEKzS9VexQP7uKPfXrRvk7kfFNE71TAl4L54ehrVXHKfwV3
X-Google-Smtp-Source: AA0mqf7CTlHEGYICnLZ/gYnTCogeUbSjtGVd6aINeK8osTi2+2BecxbGyZ3bBFX65KEmG48ZhAi7MCfAPT0DSsM6oA7sp3CP278p
MIME-Version: 1.0
X-Received: by 2002:a92:ab04:0:b0:302:4675:6223 with SMTP id
 v4-20020a92ab04000000b0030246756223mr2380747ilh.3.1669136678551; Tue, 22 Nov
 2022 09:04:38 -0800 (PST)
Date:   Tue, 22 Nov 2022 09:04:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce8a9105ee122a38@google.com>
Subject: [syzbot] INFO: task hung in linkwatch_event (3)
From:   syzbot <syzbot+d4b2f8282f84f54e87a1@syzkaller.appspotmail.com>
To:     bigeasy@linutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
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

HEAD commit:    4899a36f91a9 Merge tag 'powerpc-6.1-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117cc1b2880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2021a61197ebe02
dashboard link: https://syzkaller.appspot.com/bug?extid=d4b2f8282f84f54e87a1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1541183a2063/disk-4899a36f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ec28a40cbc9c/vmlinux-4899a36f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d4b2f8282f84f54e87a1@syzkaller.appspotmail.com

INFO: task kworker/0:13:6676 blocked for more than 143 seconds.
      Not tainted 6.0.0-syzkaller-09413-g4899a36f91a9 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:13    state:D stack:23520 pid: 6676 ppid:     2 flags:0x00004000
Workqueue: events linkwatch_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5183 [inline]
 __schedule+0xadf/0x52b0 kernel/sched/core.c:6495
 schedule+0xda/0x1b0 kernel/sched/core.c:6571
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6630
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa44/0x1350 kernel/locking/mutex.c:747
 linkwatch_event+0xb/0x60 net/core/link_watch.c:263
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
INFO: task kworker/0:3:17176 blocked for more than 143 seconds.
      Not tainted 6.0.0-syzkaller-09413-g4899a36f91a9 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:3     state:D stack:26720 pid:17176 ppid:     2 flags:0x00004000
Workqueue: events switchdev_deferred_process_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5183 [inline]
 __schedule+0xadf/0x52b0 kernel/sched/core.c:6495
 schedule+0xda/0x1b0 kernel/sched/core.c:6571
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6630
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa44/0x1350 kernel/locking/mutex.c:747
 switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:75
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
INFO: task syz-executor.0:22669 blocked for more than 144 seconds.
      Not tainted 6.0.0-syzkaller-09413-g4899a36f91a9 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:28632 pid:22669 ppid:     1 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5183 [inline]
 __schedule+0xadf/0x52b0 kernel/sched/core.c:6495
 schedule+0xda/0x1b0 kernel/sched/core.c:6571
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6630
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa44/0x1350 kernel/locking/mutex.c:747
 smc_pnet_create_pnetids_list net/smc/smc_pnet.c:805 [inline]
 smc_pnet_net_init+0x214/0x460 net/smc/smc_pnet.c:874
 smc_net_init+0x31/0x40 net/smc/af_smc.c:3342
 ops_init+0xaf/0x470 net/core/net_namespace.c:134
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3181
 __do_sys_unshare kernel/fork.c:3252 [inline]
 __se_sys_unshare kernel/fork.c:3250 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3250
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f918a48bb67
RSP: 002b:00007f918aadffa8 EFLAGS: 00000206 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007fff932ac2b8 RCX: 00007f918a48bb67
RDX: 00007f918a4f761f RSI: 0000000000000000 RDI: 0000000040000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f918aadfc80
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000003
R13: 00007fff932abd50 R14: 00007f918a5ac9d8 R15: 000000000000000c
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 29 Comm: khungtaskd Not tainted 6.0.0-syzkaller-09413-g4899a36f91a9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x46/0x14f lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x206/0x250 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc18/0xf50 kernel/hung_task.c:369
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 16 Comm: ksoftirqd/0 Not tainted 6.0.0-syzkaller-09413-g4899a36f91a9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x2d/0x60 kernel/kcov.c:200
Code: 09 28 87 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b 14 25 80 6f 02 00 a9 00 01 ff 00 74 0e 85 c9 74 35 8b 82 bc 15 00 00 <85> c0 74 2b 8b 82 98 15 00 00 83 f8 02 75 20 48 8b 8a a0 15 00 00
RSP: 0018:ffffc900001572c8 EFLAGS: 00000206
RAX: 0000000000000000 RBX: 1ffff9200002ae5a RCX: 0000000000000100
RDX: ffff888011a75880 RSI: ffffffff8758bc9c RDI: 0000000000000005
RBP: ffffffff88160720 R08: 0000000000000005 R09: 0000000000000001
R10: 0000000000000000 R11: 000000000008c07c R12: 0000000000000000
R13: ffffffff8de269a0 R14: ffff88804be48000 R15: ffff888049736000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c002af8e48 CR3: 000000000bc8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 000000000000003b DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __netif_receive_skb_one_core+0x11c/0x180 net/core/dev.c:5487
 __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5599
 netif_receive_skb_internal net/core/dev.c:5685 [inline]
 netif_receive_skb+0x12f/0x8d0 net/core/dev.c:5744
 NF_HOOK include/linux/netfilter.h:302 [inline]
 NF_HOOK include/linux/netfilter.h:296 [inline]
 br_pass_frame_up+0x303/0x410 net/bridge/br_input.c:68
 br_handle_frame_finish+0x909/0x1aa0 net/bridge/br_input.c:199
 br_nf_hook_thresh+0x2f8/0x3d0 net/bridge/br_netfilter_hooks.c:1041
 br_nf_pre_routing_finish_ipv6+0x695/0xef0 net/bridge/br_netfilter_ipv6.c:207
 NF_HOOK include/linux/netfilter.h:302 [inline]
 br_nf_pre_routing_ipv6+0x417/0x7c0 net/bridge/br_netfilter_ipv6.c:237
 br_nf_pre_routing+0x1496/0x1fe0 net/bridge/br_netfilter_hooks.c:507
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:255 [inline]
 br_handle_frame+0x9c9/0x12d0 net/bridge/br_input.c:399
 __netif_receive_skb_core+0x9fe/0x38f0 net/core/dev.c:5379
 __netif_receive_skb_one_core+0xae/0x180 net/core/dev.c:5483
 __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5599
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5927
 __napi_poll+0xb3/0x6d0 net/core/dev.c:6494
 napi_poll net/core/dev.c:6561 [inline]
 net_rx_action+0x9c1/0xd90 net/core/dev.c:6672
 __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
 run_ksoftirqd kernel/softirq.c:934 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:926
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
