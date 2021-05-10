Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580FC37943C
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEJQka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:40:30 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:47937 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhEJQk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 12:40:28 -0400
Received: by mail-io1-f69.google.com with SMTP id q187-20020a6b8ec40000b0290431cccd987fso10953024iod.14
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 09:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2wly/O+HvIt0rcClz5QNHA4b+xTsdGSZCsHQi9If7BI=;
        b=JyrYbMAqJx2gquh4feyNClUeCr0gpqRS274bTdcQvRz4mEiXUyXU70OE/ihXjZTrdA
         nbPzcWBl1Qd8s6+UsPB8GtsUNCL0YNK+Zxn8muS+QGRJBBTVJY7SZuADfjJV+DdYNNPF
         pKY8gQQAP5qMJVFpVdOTnxuXK+M+nQreuhs3SWDlnsoKrwNEoXZQEVrWnSLJsvmZX4Wl
         XQY4nmy3Ee7p9ReE6O99J3B9I46taIXWdHzPnZpRPd8tqiqJ7gNsFOnuvC5bZT+DmNEZ
         55a9mdkdv6XlEZPngFoDkWbyhdRytzFyEdFpixS44Pb4QeV2UARDY82v21jnXwngZsCS
         teBw==
X-Gm-Message-State: AOAM5318HpI0UZdk9oMhSuvLvKxC/M99y+iyJhxBq61WpTUfX8rDsyTJ
        zU/2SvNhym95Qc0BADW4JAyTrAJpQWnPTa0vJuXw+xAeEtOd
X-Google-Smtp-Source: ABdhPJwX+GObqgnDBGYuMWbTWtPFCcAasaSVoz9SeDUx4T3ejVOiT8Wlf626BLrgqT2Ocqr+1HiFl/L8cDcoEXStGwd/6VDTrsXV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d88:: with SMTP id h8mr22800400ila.66.1620664763394;
 Mon, 10 May 2021 09:39:23 -0700 (PDT)
Date:   Mon, 10 May 2021 09:39:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085afae05c1fc6b07@google.com>
Subject: [syzbot] WARNING in bpf_bprintf_prepare
From:   syzbot <syzbot+63122d0bc347f18c1884@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3733bfbb bpf, selftests: Update array map tests for per-cp..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=126c1a1ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7668018815a66138
dashboard link: https://syzkaller.appspot.com/bug?extid=63122d0bc347f18c1884
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149d83e1d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d157a3d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63122d0bc347f18c1884@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8388 at kernel/bpf/helpers.c:712 try_get_fmt_tmp_buf kernel/bpf/helpers.c:712 [inline]
WARNING: CPU: 1 PID: 8388 at kernel/bpf/helpers.c:712 bpf_bprintf_prepare+0xeba/0x10b0 kernel/bpf/helpers.c:760
Modules linked in:
CPU: 1 PID: 8388 Comm: syz-executor545 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:try_get_fmt_tmp_buf kernel/bpf/helpers.c:712 [inline]
RIP: 0010:bpf_bprintf_prepare+0xeba/0x10b0 kernel/bpf/helpers.c:760
Code: c6 e8 3a 4d 5e 02 83 c0 01 48 98 48 01 c5 48 89 6c 24 08 e8 78 0a ed ff 8d 6b 02 83 44 24 10 01 e9 d6 f5 ff ff e8 66 0a ed ff <0f> 0b 65 ff 0d fd 12 7c 7e bf 01 00 00 00 41 bc f0 ff ff ff e8 dd
RSP: 0018:ffffc90000dc0290 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000100
RDX: ffff888013b88000 RSI: ffffffff8186ebfa RDI: 0000000000000003
RBP: 0000000000000002 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8186e794 R11: 0000000000000000 R12: ffffc90000dc03c0
R13: 0000000000000100 R14: ffffc90000dc0478 R15: 0000000000000003
FS:  00000000013d1300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b00f0 CR3: 0000000014d6b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ____bpf_trace_printk kernel/trace/bpf_trace.c:389 [inline]
 bpf_trace_printk+0xab/0x3a0 kernel/trace/bpf_trace.c:380
 bpf_prog_0605f9f479290f07+0x2f/0xfd8
 bpf_dispatcher_nop_func include/linux/bpf.h:684 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:1788 [inline]
 bpf_trace_run2+0x12f/0x390 kernel/trace/bpf_trace.c:1825
 __bpf_trace_net_dev_start_xmit+0xb1/0xe0 include/trace/events/tcp.h:238
 trace_net_dev_start_xmit include/trace/events/net.h:14 [inline]
 xmit_one net/core/dev.c:3653 [inline]
 dev_hard_start_xmit+0x57b/0x920 net/core/dev.c:3670
 sch_direct_xmit+0x2e1/0xbd0 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4ba/0x15f0 net/sched/sch_generic.c:384
 qdisc_run include/net/pkt_sched.h:136 [inline]
 qdisc_run include/net/pkt_sched.h:128 [inline]
 __dev_xmit_skb net/core/dev.c:3856 [inline]
 __dev_queue_xmit+0x142e/0x2e30 net/core/dev.c:4213
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip6_finish_output2+0x911/0x1700 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:182 [inline]
 __ip6_finish_output+0x4c1/0xe10 net/ipv6/ip6_output.c:161
 ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
 NF_HOOK_COND include/linux/netfilter.h:290 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:215
 dst_output include/net/dst.h:448 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ndisc_send_skb+0xa99/0x1750 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x12e/0x6f0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x3f2/0x820 net/ipv6/addrconf.c:3877
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
 __run_timers kernel/time/timer.c:1726 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
Code: 74 24 10 e8 6a bd 4d f8 48 89 ef e8 a2 73 4e f8 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 83 41 42 f8 65 8b 05 4c 07 f6 76 85 c0 74 0a 5b 5d c3 e8 f0 fc
RSP: 0018:ffffc9000111f9e8 EFLAGS: 00000206
RAX: 0000000000000002 RBX: 0000000000000200 RCX: 1ffffffff1b8bb31
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffffffff8bfef320 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8179e5a8 R11: 0000000000000000 R12: 0000000000000002
R13: 0000000000000293 R14: ffff888013b88000 R15: 0000000000000003
 ____bpf_trace_printk kernel/trace/bpf_trace.c:398 [inline]
 bpf_trace_printk+0x172/0x3a0 kernel/trace/bpf_trace.c:380
 bpf_prog_0605f9f479290f07+0x2f/0x7e8
 bpf_dispatcher_nop_func include/linux/bpf.h:684 [inline]
 bpf_test_run+0x45f/0xaa0 net/bpf/test_run.c:117
 bpf_prog_test_run_skb+0xabc/0x1c70 net/bpf/test_run.c:656
 bpf_prog_test_run kernel/bpf/syscall.c:3149 [inline]
 __do_sys_bpf+0x218b/0x4f40 kernel/bpf/syscall.c:4428
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ff49
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffdb8cfd68 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000011ca4 RCX: 000000000043ff49
RDX: 0000000000000048 RSI: 0000000020000180 RDI: 000000000000000a
RBP: 0000000000000000 R08: 00007fffdb8cff08 R09: 00007fffdb8cff08
R10: 00007fffdb8cff08 R11: 0000000000000246 R12: 00007fffdb8cfd7c
R13: 431bde82d7b634db R14: 00000000004b0018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
