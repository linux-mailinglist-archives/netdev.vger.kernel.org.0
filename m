Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2E763B465
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiK1Vqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiK1Vqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:46:38 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABAD2F01C
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:46:36 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id d19-20020a056e020c1300b00300b5a12c44so10098499ile.15
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:46:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u5DU+rzhU6BRejes6nCyeDncj5tiUDzgBpX3RJNYjxM=;
        b=ynYHIl+77Y4u5vMzlJw797Il9/H8EKfzFXde2nWQJLUPGKxfRBqACfvke6naNscW64
         wfh3BG/xb8GdNLKwfWGG3rCl2+/LX9PjhcAcaR5JH8Ad3HcnhsST2mu0ATlmGRjAV2op
         TkoShs4S5Dwmpd8EmT/EPMxKwtcvMJxfVTq6Y01ssAOu3E6KqrhXyLbIJt3m0kSBzX/J
         IW504tdjTpNPStbLB2tonXtz0s/NIm99PROdboSFXSPf9QIbK3v0s9uA5FSJCPvd2+ve
         09vNt8g3CT79HhnM0ZP0+wI5VtIgKfoeebZiNQ3g5FWTflirknk2H7pmu72b2NJ1SDQJ
         RIQg==
X-Gm-Message-State: ANoB5pmyJecHC9rZ3z1b2sj+v4/uGJ3ePSMN+TzOLPUXW64lO9SHdIji
        rz77pMRxtM8llQBisSV8jxGlC0kw/U3og6++Z33pbD79zbyw
X-Google-Smtp-Source: AA0mqf7pm9yecEFQSHKmrVw9h0hSv4T1TEqYZIAdpYdA6hfwuqh2aK2hQrT+ghZ9JYinOOvkdY4gysc6kojakW3kJtPBFhfAYg0m
MIME-Version: 1.0
X-Received: by 2002:a6b:8d87:0:b0:6dd:f2f4:b335 with SMTP id
 p129-20020a6b8d87000000b006ddf2f4b335mr15352834iod.99.1669671995941; Mon, 28
 Nov 2022 13:46:35 -0800 (PST)
Date:   Mon, 28 Nov 2022 13:46:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035aa0505ee8ece19@google.com>
Subject: [syzbot] INFO: task hung in nfnetlink_rcv_msg (3)
From:   syzbot <syzbot+9204e7399656300bf271@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    08e8a949f684 net: wwan: t7xx: Fix the ACPI memory leak
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15cc5b2d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=60808f80d41c27e5
dashboard link: https://syzkaller.appspot.com/bug?extid=9204e7399656300bf271
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15569dc5880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1437f803880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/49fbc1a069d4/disk-08e8a949.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0aadd1f9073a/vmlinux-08e8a949.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b75d62dbd582/bzImage-08e8a949.xz

The issue was bisected to:

commit 5f7b51bf09baca8e4f80cbe879536842bafb5f31
Author: Jozsef Kadlecsik <kadlec@netfilter.org>
Date:   Wed Jul 28 15:01:15 2021 +0000

    netfilter: ipset: Limit the maximal range of consecutive elements to add/delete

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e630e3880000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17e630e3880000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e630e3880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9204e7399656300bf271@syzkaller.appspotmail.com
Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")

INFO: task syz-executor291:3680 blocked for more than 143 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor291 state:D stack:27192 pid:3680  ppid:3668   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0xae9/0x53f0 kernel/sched/core.c:6503
 schedule+0xde/0x1b0 kernel/sched/core.c:6579
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6638
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 nfnetlink_rcv+0x1b0/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2298c5e0e9
RSP: 002b:00007ffc1c6fdb38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f2298c5e0e9
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 00007ffc1c6fd5b0 R11: 0000000000000246 R12: 000000000007689b
R13: 00007ffc1c6fdb4c R14: 00007ffc1c6fdb60 R15: 00007ffc1c6fdb50
 </TASK>
INFO: task syz-executor291:3681 blocked for more than 143 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor291 state:D stack:27952 pid:3681  ppid:3662   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0xae9/0x53f0 kernel/sched/core.c:6503
 schedule+0xde/0x1b0 kernel/sched/core.c:6579
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6638
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 nfnetlink_rcv+0x1b0/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2298c5e0e9
RSP: 002b:00007ffc1c6fdb38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f2298c5e0e9
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 00007ffc1c6fd5b0 R11: 0000000000000246 R12: 0000000000076893
R13: 00007ffc1c6fdb4c R14: 00007ffc1c6fdb60 R15: 00007ffc1c6fdb50
 </TASK>
INFO: task syz-executor291:3682 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor291 state:D stack:26400 pid:3682  ppid:3663   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0xae9/0x53f0 kernel/sched/core.c:6503
 schedule+0xde/0x1b0 kernel/sched/core.c:6579
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6638
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 nfnetlink_rcv+0x1b0/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2298c5e0e9
RSP: 002b:00007ffc1c6fdb38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f2298c5e0e9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000076898
R13: 00007ffc1c6fdb4c R14: 00007ffc1c6fdb60 R15: 00007ffc1c6fdb50
 </TASK>
INFO: task syz-executor291:3684 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor291 state:D stack:27000 pid:3684  ppid:3666   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0xae9/0x53f0 kernel/sched/core.c:6503
 schedule+0xde/0x1b0 kernel/sched/core.c:6579
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6638
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 nfnetlink_rcv+0x1b0/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2298c5e0e9
RSP: 002b:00007ffc1c6fdb38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f2298c5e0e9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 000000000007689e
R13: 00007ffc1c6fdb4c R14: 00007ffc1c6fdb60 R15: 00007ffc1c6fdb50
 </TASK>
INFO: task syz-executor291:3685 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor291 state:D stack:27952 pid:3685  ppid:3667   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0xae9/0x53f0 kernel/sched/core.c:6503
 schedule+0xde/0x1b0 kernel/sched/core.c:6579
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6638
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 nfnetlink_rcv+0x1b0/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2298c5e0e9
RSP: 002b:00007ffc1c6fdb38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f2298c5e0e9
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 00007ffc1c6fd5b0 R11: 0000000000000246 R12: 0000000000076899
R13: 00007ffc1c6fdb4c R14: 00007ffc1c6fdb60 R15: 00007ffc1c6fdb50
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8c58f0f0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8c58edf0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
1 lock held by khungtaskd/28:
 #0: ffffffff8c58fc40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x57/0x264 kernel/locking/lockdep.c:6494
2 locks held by getty/3309:
 #0: ffff88814afa0098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x26/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc900031262f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xef4/0x13e0 drivers/tty/n_tty.c:2177
1 lock held by syz-executor291/3680:
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
1 lock held by syz-executor291/3681:
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
1 lock held by syz-executor291/3682:
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
1 lock held by syz-executor291/3683:
1 lock held by syz-executor291/3684:
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294
1 lock held by syz-executor291/3685:
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnl_lock net/netfilter/nfnetlink.c:97 [inline]
 #0: ffffffff91d48cf8 (nfnl_subsys_ipset){+.+.}-{3:3}, at: nfnetlink_rcv_msg+0xaae/0x1430 net/netfilter/nfnetlink.c:294

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: khungtaskd Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x24/0x18a lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x333/0x3c0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xc75/0xfc0 kernel/hung_task.c:377
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 3683 Comm: syz-executor291 Not tainted 6.1.0-rc5-syzkaller-00204-g08e8a949f684 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:ip_set_hostmask include/linux/netfilter/ipset/pfxlen.h:28 [inline]
RIP: 0010:ip_set_range_to_cidr+0x4c/0x160 net/netfilter/ipset/pfxlen.c:178
Code: 01 00 00 00 53 bb 00 00 00 80 48 83 ec 10 89 74 24 04 48 89 54 24 08 eb 25 e8 70 ed 67 f9 4c 89 e0 48 c1 e8 03 42 0f b6 04 30 <84> c0 74 08 3c 03 0f 8e dd 00 00 00 41 8b 1c 24 49 83 c4 10 e8 4b
RSP: 0018:ffffc90003dcf008 EFLAGS: 00000a06
RAX: 0000000000000000 RBX: 00000000fffc0000 RCX: 0000000000000000
RDX: ffff8880783a57c0 RSI: ffffffff88182c10 RDI: 0000000000000001
RBP: 000000000000000f R08: 0000000000000001 R09: 0000000000000020
R10: 000000000000000f R11: 0000000000000000 R12: ffffffff8b638fb0
R13: 000000001aff8de1 R14: dffffc0000000000 R15: 000000001afc0000
FS:  0000555555f42300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555555f422c0 CR3: 0000000077d7d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 hash_net4_uadt+0x50c/0x9d0 net/netfilter/ipset/ip_set_hash_net.c:193
 call_ad.constprop.0+0x101/0x760 net/netfilter/ipset/ip_set_core.c:1698
 ip_set_ad.constprop.0.isra.0+0x4c7/0xac0 net/netfilter/ipset/ip_set_core.c:1787
 nfnetlink_rcv_msg+0xbca/0x1430 net/netfilter/nfnetlink.c:301
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 nfnetlink_rcv+0x1b0/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2298c5e0e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc1c6fdb38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f2298c5e0e9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 000000000007689c
R13: 00007ffc1c6fdb4c R14: 00007ffc1c6fdb60 R15: 00007ffc1c6fdb50
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.969 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
