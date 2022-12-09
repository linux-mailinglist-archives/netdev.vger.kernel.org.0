Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87262647E67
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLIHTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLIHTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:19:50 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B1B262B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:19:48 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id w15-20020a056e021a6f00b00303520bff1dso3252491ilv.20
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fke5yQtt9mF4d6J9mFgP+2VXNvcG/RndOPbe7YXc6UA=;
        b=t86JB/nUH84sofXAyi9EYb/RsmYvwQalPQ1zW64mpy8UGbR/vQq+25pixXfzmhQF+q
         5IGWyWZc+WIE/kDS1LG/keXLCkfU8lVNScgUMqrg+p6+MQ5BVrK/W+H0RBfYNTJ9lfub
         O4gfCcH2ZrcbwdCuqxNpduevHsUIr1lo+G2E5tWEcEiOr94wO6TSDZKllAAxFVVYUcM5
         XMbrAF8vDJAUNlcydLRFnjdB7ACHGJPQG058GnJE8+9mLhLNaYHiPXiumV3+ZhfPOdJX
         cf/pA2999gILHaMDDi7Fu1YdkKhrwo+4oPsWtGSFoIHkBUogd1mCz7RhI43O47JTKXBa
         oSCQ==
X-Gm-Message-State: ANoB5pmkKi59r4af017RLDQRxDuznMnQ0Is3DJf6BmBh97wYbh7H2g6z
        rXx0VxevOHUlGlqM437wCbRUborRZ4VFUllTOlGC73sM9StB
X-Google-Smtp-Source: AA0mqf49cB8fqYlbqkc+fTh8D8MdRTkcL0vAymcDaiPTTLL4DTEwPeTE24YzddN3q+13fNIO6UJswotVLTXKVNJOSlhzXRNe5Tb/
MIME-Version: 1.0
X-Received: by 2002:a02:cc48:0:b0:38a:32c7:997 with SMTP id
 i8-20020a02cc48000000b0038a32c70997mr10564009jaq.139.1670570388235; Thu, 08
 Dec 2022 23:19:48 -0800 (PST)
Date:   Thu, 08 Dec 2022 23:19:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000902cda05ef5ffad3@google.com>
Subject: [syzbot] INFO: task hung in rxrpc_destroy_all_calls (3)
From:   syzbot <syzbot+2aea8e1c8e20cb27a01f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
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

HEAD commit:    59d0d52c30d4 AMerge tag 'netfs-fixes-20221115' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a2f8d9880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=378c11a9ed9a0efe
dashboard link: https://syzkaller.appspot.com/bug?extid=2aea8e1c8e20cb27a01f
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e37a2138645c/disk-59d0d52c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/15b7229edb64/vmlinux-59d0d52c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a6a9d898be4a/bzImage-59d0d52c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2aea8e1c8e20cb27a01f@syzkaller.appspotmail.com

INFO: task kworker/u4:6:12250 blocked for more than 143 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00018-g59d0d52c30d4 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:6    state:D stack:22936 pid:12250 ppid:2      flags:0x00004000
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8fc/0xda0 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 rxrpc_destroy_all_calls+0x595/0x690 net/rxrpc/call_object.c:736
 rxrpc_exit_net+0x6a/0xc0 net/rxrpc/net_ns.c:123
 ops_exit_list net/core/net_namespace.c:169 [inline]
 cleanup_net+0x758/0xc50 net/core/net_namespace.c:601
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/u4:0/9:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8d323ff0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x30/0xd00 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8d3247f0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x30/0xd00 kernel/rcu/tasks.h:507
2 locks held by ksoftirqd/0/15:
1 lock held by khungtaskd/28:
 #0: ffffffff8d323e20 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
1 lock held by khugepaged/35:
 #0: ffffffff8d3c9208 (lock#3){+.+.}-{3:3}, at: __lru_add_drain_all+0x66/0x800 mm/swap.c:873
3 locks held by kworker/1:2/156:
 #0: ffff88814abc0d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc90002f1fd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd8/0x16e0 net/ipv6/addrconf.c:4083
5 locks held by syslogd/2979:
1 lock held by klogd/2986:
1 lock held by dhcpcd/3210:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0x2cd/0x1ab0 net/ipv4/devinet.c:1070
2 locks held by getty/3306:
 #0: ffff8880282a9098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:244
 #1: ffffc900031262f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6e8/0x1e50 drivers/tty/n_tty.c:2177
4 locks held by syz-fuzzer/3649:
3 locks held by kworker/0:7/3724:
 #0: ffff888012864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc900044cfd00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xa/0x50 net/core/link_watch.c:263
3 locks held by kworker/0:10/4439:
3 locks held by kworker/u4:6/12250:
 #0: ffff8880129c3138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc900152f7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffffffff8e471b50 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0xf0/0xc50 net/core/net_namespace.c:563
1 lock held by syz-executor.2/16413:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.3/16417:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.1/16425:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.4/16427:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.5/16429:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
2 locks held by syz-executor.0/16430:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
 #1: ffffffff8d3293b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:292 [inline]
 #1: ffffffff8d3293b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x3a6/0x890 kernel/rcu/tree_exp.h:946
1 lock held by syz-executor.2/16523:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.3/16527:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.1/16531:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.4/16536:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.0/16538:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088
1 lock held by syz-executor.5/16539:
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:74 [inline]
 #0: ffffffff8e47de88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x75d/0xe90 net/core/rtnetlink.c:6088

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: khungtaskd Not tainted 6.1.0-rc5-syzkaller-00018-g59d0d52c30d4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 nmi_cpu_backtrace+0x4e3/0x560 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x19b/0x3e0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xcf5/0xd40 kernel/hung_task.c:377
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 16544 Comm: syz-executor.2 Not tainted 6.1.0-rc5-syzkaller-00018-g59d0d52c30d4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__lock_acquire+0x412/0x1f60 kernel/locking/lockdep.c:4996
Code: 6c 24 10 83 7d 00 00 0f 95 c0 09 c3 c1 e3 0d 44 09 fb 8b 44 24 44 c1 e0 0f 0f b7 c0 09 d8 8b 74 24 28 83 e6 03 c1 e6 10 09 c6 <41> 83 e4 01 41 c1 e4 12 31 c9 83 7c 24 60 00 0f 95 c1 c1 e1 13 41
RSP: 0018:ffffc900037ff4a8 EFLAGS: 00000002
RAX: 00000000000000a7 RBX: 00000000000000a7 RCX: ffffffff81d51ec5
RDX: dffffc0000000000 RSI: 00000000000000a7 RDI: ffffffff8d3f9ac0
RBP: ffff88803c732774 R08: 0000000000000001 R09: 0000000000000000
R10: fffffbfff1d2299e R11: 1ffffffff1d2299d R12: 0000000000000001
R13: ffff88803c731d40 R14: 0000000000000000 R15: 00000000000000a7
FS:  000055555575a400(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555575b6e8 CR3: 0000000034847000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
 __fs_reclaim_acquire mm/page_alloc.c:4679 [inline]
 fs_reclaim_acquire+0x82/0x120 mm/page_alloc.c:4693
 might_alloc include/linux/sched/mm.h:271 [inline]
 prepare_alloc_pages+0x145/0x5a0 mm/page_alloc.c:5325
 __alloc_pages+0x161/0x560 mm/page_alloc.c:5544
 vm_area_alloc_pages mm/vmalloc.c:2975 [inline]
 __vmalloc_area_node mm/vmalloc.c:3043 [inline]
 __vmalloc_node_range+0x8f4/0x1290 mm/vmalloc.c:3213
 alloc_thread_stack_node+0x307/0x500 kernel/fork.c:311
 dup_task_struct+0x8b/0x490 kernel/fork.c:974
 copy_process+0x637/0x3fc0 kernel/fork.c:2084
 kernel_clone+0x227/0x640 kernel/fork.c:2671
 __do_sys_clone kernel/fork.c:2812 [inline]
 __se_sys_clone kernel/fork.c:2796 [inline]
 __x64_sys_clone+0x276/0x2e0 kernel/fork.c:2796
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe498e8ca61
Code: 48 85 ff 74 3d 48 85 f6 74 38 48 83 ee 10 48 89 4e 08 48 89 3e 48 89 d7 4c 89 c2 4d 89 c8 4c 8b 54 24 08 b8 38 00 00 00 0f 05 <48> 85 c0 7c 13 74 01 c3 31 ed 58 5f ff d0 48 89 c7 b8 3c 00 00 00
RSP: 002b:00007ffcee154b08 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fe498000700 RCX: 00007fe498e8ca61
RDX: 00007fe4980009d0 RSI: 00007fe4980002f0 RDI: 00000000003d0f00
RBP: 00007ffcee154bc0 R08: 00007fe498000700 R09: 00007fe498000700
R10: 00007fe4980009d0 R11: 0000000000000206 R12: 00007ffcee154bbe
R13: 00007ffcee154bbf R14: 00007fe498000300 R15: 0000000000802000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
