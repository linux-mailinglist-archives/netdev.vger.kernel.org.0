Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF9E276D51
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgIXJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:27:07 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:36140 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgIXJ03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:26:29 -0400
Received: by mail-io1-f78.google.com with SMTP id h8so1957263ioa.3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=G4/jGwbnu1l2y6Jzi6EOMRaLUdbIWIbqP6WYAAaIhRA=;
        b=ISzODvCmjuMmz2WduOau0izBHgryyo/e6+mYipiGpPmTT1/Oet0UYh3aA57lfBJKH4
         hcWKSK9FcutZfvi0cSh941ZvQ1/TMEMp3AHFhE9CMgdFPlPfXxuTBvihQQVuiQ2XOnrp
         GIA6ddP0vrdbsAQQkO7+SLH50u7aLDyOArvNm4pK+kkmzshB5WtrClWsi2pfHf7zqxyF
         82cg0muTmNTFGmhXdUklQO52r9mEvbrpuTTB3n43cicIg31oS1hOCQfpMsWBM1z37oHY
         oJj0ia92b3MvQ/4efyHZeUSdNhajRFxlgxsHM8WxbmtdV9RhJ6rAYnN9xOAm6qAX2/xm
         QvXw==
X-Gm-Message-State: AOAM533Hdt0clfSbHieiDdNtO9O2vO93fSJbb42lO1pxRD8gtnD6h59S
        mhvMac9nUb8LQbkYsKkdjZtMKIdnE6j0dxhHtXofyFqLJMqf
X-Google-Smtp-Source: ABdhPJzCH79j/NuiC+W9kQ9b8UrZdjUMlgDD7CTrzBW4drN2ngmgn3gt/TxVzhCqovRZhzbDBaDeeEA07CM5dm1TSCgvGztpbOni
MIME-Version: 1.0
X-Received: by 2002:a92:d905:: with SMTP id s5mr3330966iln.224.1600939587940;
 Thu, 24 Sep 2020 02:26:27 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:26:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000072391b05b00bcb00@google.com>
Subject: WARNING in ieee80211_rx_list
From:   syzbot <syzbot+8830db5d3593b5546d2e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    12450081 libbpf: Fix native endian assumption when parsing..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1236e99b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac0d21536db480b
dashboard link: https://syzkaller.appspot.com/bug?extid=8830db5d3593b5546d2e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8830db5d3593b5546d2e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 18094 at net/mac80211/rx.c:4707 ieee80211_rx_list+0x1ba1/0x23a0 net/mac80211/rx.c:4707
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 18094 Comm: syz-executor.4 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:ieee80211_rx_list+0x1ba1/0x23a0 net/mac80211/rx.c:4707
Code: 00 00 48 89 df e8 8f 1c ef f9 e9 08 02 00 00 e8 25 59 ae f9 48 c7 84 24 c4 00 00 00 10 00 00 00 e9 cd ed ff ff e8 0f 59 ae f9 <0f> 0b e9 77 f0 ff ff e8 03 59 ae f9 44 89 e6 48 89 ef e8 e8 2e 9d
RSP: 0018:ffffc90000da8c98 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff87c7baa0
RDX: ffff888058a603c0 RSI: ffffffff87c7d3f1 RDI: 0000000000000001
RBP: ffff8880a614a580 R08: 0000000000000000 R09: ffffffff8d0b69e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88808c653148
R13: ffff88808c650580 R14: ffff88808c650c80 R15: 0000000000000001
 ieee80211_rx_napi+0xf7/0x3d0 net/mac80211/rx.c:4799
 ieee80211_rx include/net/mac80211.h:4435 [inline]
 ieee80211_tasklet_handler+0xd3/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x237/0x470 kernel/softirq.c:559
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:26 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x9/0x60 kernel/kcov.c:197
Code: 5d be 03 00 00 00 e9 b6 82 49 02 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 48 8b 14 25 c0 fe 01 00 <65> 8b 05 70 d1 8b 7e a9 00 01 ff 00 48 8b 34 24 74 0f f6 c4 01 74
RSP: 0018:ffffc900016d7748 EFLAGS: 00000202
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81a62d1d
RDX: ffff888058a603c0 RSI: ffff888058a603c0 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8b591e4f
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888069ba8a80
R13: 0000000000000001 R14: 0000000000000363 R15: 0000000001190000
 rcu_read_unlock_sched_notrace include/linux/rcupdate.h:772 [inline]
 trace_rss_stat+0x226/0x2f0 include/trace/events/kmem.h:338
 mm_trace_rss_stat mm/memory.c:160 [inline]
 add_mm_counter include/linux/mm.h:1882 [inline]
 add_mm_rss_vec mm/memory.c:490 [inline]
 zap_pte_range mm/memory.c:1141 [inline]
 zap_pmd_range mm/memory.c:1195 [inline]
 zap_pud_range mm/memory.c:1224 [inline]
 zap_p4d_range mm/memory.c:1245 [inline]
 unmap_page_range+0x16ab/0x2bf0 mm/memory.c:1266
 unmap_single_vma+0x198/0x300 mm/memory.c:1311
 unmap_vmas+0x168/0x2e0 mm/memory.c:1343
 exit_mmap+0x2b1/0x530 mm/mmap.c:3183
 __mmput+0x122/0x470 kernel/fork.c:1076
 mmput+0x53/0x60 kernel/fork.c:1097
 exit_mm kernel/exit.c:483 [inline]
 do_exit+0xa8b/0x29f0 kernel/exit.c:793
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:136 [inline]
 exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: Bad RIP value.
RSP: 002b:00007fa23411dc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffe0 RBX: 000000000002cd80 RCX: 000000000045e179
RDX: 0000000000040000 RSI: 0000000020000080 RDI: 000000000000000a
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffd868e359f R14: 00007fa23411e9c0 R15: 000000000118cf4c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
