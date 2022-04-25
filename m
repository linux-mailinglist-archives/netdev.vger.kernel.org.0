Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49AE50DA21
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiDYHdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 03:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiDYHd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 03:33:29 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D33FBF57
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:30:22 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so5711142ilu.14
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QykV03u6nFhry1/I30b5ziX5l1KwwQpypiDvgy7yARw=;
        b=FuS96oSnuVXd9kA3RwvU8mMWtgBVeYkJPhNi8ZLr49Oj9HgjQelH+BFjWx5dcDiUP8
         93I1HYvVHfQYEqIko88ij9FDQGRdmHBUq6b/dYGGolcTWyf9p1lqv0DnsrxN03a3jcGP
         rBvVANJspqbHFAlaQ7ytMh1J9MIQERyyQVLYBFpxNaBT1BoC+OETwJtLz2XM50RrggFW
         6+NukEWc53QQtwARazfBe+UlvD9D54ejgnSdRx9VpnlhpPYOT7EuiG2Gv1qRbuYrWFVI
         beRWk6+WIKAGXgzFYOHF97Oj8Q6vLrjdu760pV5woJEeUj2k5JPnHUYlVRDHAjwffA73
         z0Fw==
X-Gm-Message-State: AOAM530EEX0dBd4V/5T3GCYoHRVoo36DCabSSmG1kk/kChCNaYhunnJB
        daQqQoo+3mDHTgtrUq5SnAbImLitt2zvjDih4POX2nYGXo8c
X-Google-Smtp-Source: ABdhPJyUptAXJmyMNSQZHPki7bBkeftyzk0lXm0zjEynsq9GLZp6WoVjwQH0u6JjsS0SJFgP/GFLb0uGeIGN5kzOxwXdQtS8ni9p
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1450:b0:32a:8386:c9cd with SMTP id
 l16-20020a056638145000b0032a8386c9cdmr7221579jad.249.1650871822045; Mon, 25
 Apr 2022 00:30:22 -0700 (PDT)
Date:   Mon, 25 Apr 2022 00:30:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085d75405dd758caa@google.com>
Subject: [syzbot] INFO: task hung in tls_sw_sendmsg (3)
From:   syzbot <syzbot+baad3750d52fcc56930b@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
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

HEAD commit:    b253435746d9 Merge tag 'xtensa-20220416' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=109cf862f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4cdc9619f45633df
dashboard link: https://syzkaller.appspot.com/bug?extid=baad3750d52fcc56930b
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+baad3750d52fcc56930b@syzkaller.appspotmail.com

INFO: task syz-executor.3:5663 blocked for more than 143 seconds.
      Not tainted 5.18.0-rc3-syzkaller-00016-gb253435746d9 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:28856 pid: 5663 ppid:  3623 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5073 [inline]
 __schedule+0x939/0xea0 kernel/sched/core.c:6388
 schedule+0xeb/0x1b0 kernel/sched/core.c:6460
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6519
 __mutex_lock_common+0xecf/0x26e0 kernel/locking/mutex.c:673
 __mutex_lock kernel/locking/mutex.c:733 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:785
 tls_sw_sendmsg+0x297/0x1830 net/tls/tls_sw.c:957
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 __sys_sendto+0x42e/0x5b0 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0xda/0xf0 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd7940890e9
RSP: 002b:00007fd79523f168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fd79419c030 RCX: 00007fd7940890e9
RDX: feffffff00000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fd7940e308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffdf66ea5f R14: 00007fd79523f300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/28:
 #0: ffffffff8cb1ae60 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
2 locks held by syslogd/2945:
 #0: ffff8880b9b39c18 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x25/0x110 kernel/sched/core.c:554
 #1: ffff8880b9b277c8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x567/0x820 kernel/sched/psi.c:889
2 locks held by getty/3270:
 #0: ffff88814c440098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002b832e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ad/0x1c90 drivers/tty/n_tty.c:2075
3 locks held by kworker/0:3/3316:
 #0: ffff888011464d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc90002f9fd00 ((work_completion)(&(&sw_ctx_tx->tx_work.work)->work)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff88807cb9a0d8 (&ctx->tx_lock){+.+.}-{3:3}, at: tx_work_handler+0x111/0x150 net/tls/tls_sw.c:2300
5 locks held by kworker/u4:6/3749:
1 lock held by syz-executor.3/5663:
 #0: ffff88807cb9a0d8 (&ctx->tx_lock){+.+.}-{3:3}, at: tls_sw_sendmsg+0x297/0x1830 net/tls/tls_sw.c:957

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: khungtaskd Not tainted 5.18.0-rc3-syzkaller-00016-gb253435746d9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 nmi_cpu_backtrace+0x473/0x4a0 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x168/0x280 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xcf9/0xd40 kernel/hung_task.c:369
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 45 Comm: kworker/u4:2 Not tainted 5.18.0-rc3-syzkaller-00016-gb253435746d9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy7 ieee80211_iface_work
RIP: 0010:preempt_count_add+0x4e/0x180 kernel/sched/core.c:5537
Code: e3 00 00 00 83 3d b1 70 5c 0f 00 75 07 65 8b 05 90 39 a7 7e 65 01 1d 89 39 a7 7e 48 c7 c0 a0 a6 b7 90 48 c1 e8 03 42 8a 04 38 <84> c0 0f 85 db 00 00 00 83 3d 83 70 5c 0f 00 75 11 65 8b 05 62 39
RSP: 0018:ffffc9000115f2e0 EFLAGS: 00000a06
RAX: 1ffffffff216f404 RBX: 0000000000000001 RCX: ffffffff90b7a603
RDX: dffffc0000000000 RSI: ffffffff81d6a418 RDI: 0000000000000001
RBP: 1ffff9200022be78 R08: 0000000000000002 R09: ffffc9000115f4b0
R10: fffff5200022be84 R11: 1ffff9200022be82 R12: ffffc9000115f798
R13: ffffc9000115f3c0 R14: ffffffff81d6a418 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c014c8aa20 CR3: 000000007e96d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unwind_next_frame+0xae/0x1dc0 arch/x86/kernel/unwind_orc.c:428
 arch_stack_walk+0x112/0x140 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x12d/0x1f0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0xd8/0x110 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kfree+0xc6/0x210 mm/slub.c:4552
 ieee80211_bss_info_update+0x96c/0xc30 net/mac80211/scan.c:232
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x1659/0x28c0 net/mac80211/ibss.c:1639
 ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
 ieee80211_iface_work+0x757/0xcd0 net/mac80211/iface.c:1581
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
----------------
Code disassembly (best guess):
   0:	e3 00                	jrcxz  0x2
   2:	00 00                	add    %al,(%rax)
   4:	83 3d b1 70 5c 0f 00 	cmpl   $0x0,0xf5c70b1(%rip)        # 0xf5c70bc
   b:	75 07                	jne    0x14
   d:	65 8b 05 90 39 a7 7e 	mov    %gs:0x7ea73990(%rip),%eax        # 0x7ea739a4
  14:	65 01 1d 89 39 a7 7e 	add    %ebx,%gs:0x7ea73989(%rip)        # 0x7ea739a4
  1b:	48 c7 c0 a0 a6 b7 90 	mov    $0xffffffff90b7a6a0,%rax
  22:	48 c1 e8 03          	shr    $0x3,%rax
  26:	42 8a 04 38          	mov    (%rax,%r15,1),%al
* 2a:	84 c0                	test   %al,%al <-- trapping instruction
  2c:	0f 85 db 00 00 00    	jne    0x10d
  32:	83 3d 83 70 5c 0f 00 	cmpl   $0x0,0xf5c7083(%rip)        # 0xf5c70bc
  39:	75 11                	jne    0x4c
  3b:	65                   	gs
  3c:	8b                   	.byte 0x8b
  3d:	05                   	.byte 0x5
  3e:	62                   	.byte 0x62
  3f:	39                   	.byte 0x39


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
