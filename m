Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38165BEBCE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiITRWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiITRWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:22:46 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF8C6D577
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:22:43 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id n4-20020a056e02100400b002f09be72a53so1990795ilj.18
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=TPpFjDdK+tXhcMGIoZNSG+9qAkjbhonLlwvMuddDuMg=;
        b=irwzz5tGItcNoakVyzDXm9bd2JOskJPG1V5YIsank0lsOQ7+I6jkuvKjsINbZgcDCA
         BU/03Ih6SocpeiPUiJA7P8Iw1t8VPo48QpgxdFbAx0En2XcslbX2zy5RXp/jPpdg+8Ni
         LJ5WBevwiruX6NzqWtNsV0vhZo/7DpQfQ48mZLdMVlkWC7xW8AaiquGNlHc5WNeeHVLu
         hAselj/eXFaY2paC8rIHETd6YJz4xkC0W6xCik+93ibPvfvX3fvfmQ3+G3wsOPOTwRth
         dq/3p5q02nu6wpRf1El/0DHlZCb3LyluUlQN7ey+j8SxF1lTlsNwL2BpDW/2quqtweIl
         R+oQ==
X-Gm-Message-State: ACrzQf1p6THxHtlAdSZjkWcF/R8e4x8sO55RQOUPAqJVZc6C3BdOE36W
        iLjv//E6ogAi505veN/K0/BFAA3rCtfWtB0DTMePfbaCKg0b
X-Google-Smtp-Source: AMsMyM6dyCOrnTYZ33Wleyed7+hZ9ahQ3n8Q5RUEObniknXSOWu8M2hBPWPOd+pHx47BkMLn2rsi3yP969ubFyx0T5IhvAgK66wS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216f:b0:2eb:9bcc:1649 with SMTP id
 s15-20020a056e02216f00b002eb9bcc1649mr10342108ilv.226.1663694562604; Tue, 20
 Sep 2022 10:22:42 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:22:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006b49ea05e91f13e2@google.com>
Subject: [syzbot] WARNING in cake_dequeue
From:   syzbot <syzbot+1a58ef288b4f7a56adbf@syzkaller.appspotmail.com>
To:     cake@lists.bufferbloat.net, davem@davemloft.net,
        edumazet@google.com, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, toke@toke.dk,
        xiyou.wangcong@gmail.com
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

HEAD commit:    521a547ced64 Linux 6.0-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1267c108880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=122d7bd4fc8e0ecb
dashboard link: https://syzkaller.appspot.com/bug?extid=1a58ef288b4f7a56adbf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a58ef288b4f7a56adbf@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 12003 at net/sched/sch_cake.c:2093 cake_dequeue+0x2188/0x3cb0 net/sched/sch_cake.c:2093
Modules linked in:
CPU: 0 PID: 12003 Comm: syz-executor.4 Not tainted 6.0.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:cake_dequeue+0x2188/0x3cb0 net/sched/sch_cake.c:2093
Code: 66 39 c5 0f 42 e8 e8 a7 a1 f1 f9 89 ee bf 00 04 00 00 e8 3b 9e f1 f9 66 81 fd 00 04 0f b7 dd 0f 86 a1 ef ff ff e8 88 a1 f1 f9 <0f> 0b e9 95 ef ff ff 31 ed e9 83 e8 ff ff e8 75 a1 f1 f9 48 8b 84
RSP: 0018:ffffc90000007cf0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000ffff RCX: 0000000000000100
RDX: ffff888033c15880 RSI: ffffffff878a6798 RDI: 0000000000000003
RBP: 000000000000ffff R08: 0000000000000003 R09: 0000000000000400
R10: 000000000000ffff R11: 0000000000000001 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff88803ef01aa0 R15: ffff88803ef00000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2eb23000 CR3: 000000000bc8e000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 dequeue_skb net/sched/sch_generic.c:292 [inline]
 qdisc_restart net/sched/sch_generic.c:397 [inline]
 __qdisc_run+0x1ae/0x1710 net/sched/sch_generic.c:415
 qdisc_run include/net/pkt_sched.h:126 [inline]
 qdisc_run include/net/pkt_sched.h:123 [inline]
 net_tx_action+0x71f/0xd20 net/core/dev.c:5086
 __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0xd/0x60 kernel/kcov.c:200
Code: 00 00 e9 86 c0 81 02 66 0f 1f 44 00 00 48 8b be a8 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 8b 05 19 66 86 7e 89 c1 48 8b 34 24 <81> e1 00 01 00 00 65 48 8b 14 25 80 6f 02 00 a9 00 01 ff 00 74 0e
RSP: 0018:ffffc9000a98f758 EFLAGS: 00000246
RAX: 0000000080000001 RBX: 00007fee55929000 RCX: 0000000080000001
RDX: ffff888033c15880 RSI: ffffffff81b45ece RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffea0001b5bac8
R13: ffffea0001b5bac0 R14: dffffc0000000000 R15: ffff888077a6a940
 zap_pte_range mm/memory.c:1508 [inline]
 zap_pmd_range mm/memory.c:1575 [inline]
 zap_pud_range mm/memory.c:1604 [inline]
 zap_p4d_range mm/memory.c:1625 [inline]
 unmap_page_range+0xd1e/0x3cc0 mm/memory.c:1646
 unmap_single_vma+0x196/0x360 mm/memory.c:1694
 unmap_vmas+0x18c/0x310 mm/memory.c:1731
 exit_mmap+0x1b8/0x490 mm/mmap.c:3116
 __mmput+0x122/0x4b0 kernel/fork.c:1187
 mmput+0x56/0x60 kernel/fork.c:1208
 exit_mm kernel/exit.c:510 [inline]
 do_exit+0x9e2/0x29b0 kernel/exit.c:782
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 get_signal+0x238c/0x2610 kernel/signal.c:2857
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fee55a89409
Code: Unable to access opcode bytes at RIP 0x7fee55a893df.
RSP: 002b:00007fee56bfb218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fee55b9bf88 RCX: 00007fee55a89409
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fee55b9bf88
RBP: 00007fee55b9bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fee55b9bf8c
R13: 00007fffab12ee9f R14: 00007fee56bfb300 R15: 0000000000022000
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	e9 86 c0 81 02       	jmpq   0x281c08d
   7:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   d:	48 8b be a8 01 00 00 	mov    0x1a8(%rsi),%rdi
  14:	e8 b4 ff ff ff       	callq  0xffffffcd
  19:	31 c0                	xor    %eax,%eax
  1b:	c3                   	retq
  1c:	90                   	nop
  1d:	65 8b 05 19 66 86 7e 	mov    %gs:0x7e866619(%rip),%eax        # 0x7e86663d
  24:	89 c1                	mov    %eax,%ecx
  26:	48 8b 34 24          	mov    (%rsp),%rsi
* 2a:	81 e1 00 01 00 00    	and    $0x100,%ecx <-- trapping instruction
  30:	65 48 8b 14 25 80 6f 	mov    %gs:0x26f80,%rdx
  37:	02 00
  39:	a9 00 01 ff 00       	test   $0xff0100,%eax
  3e:	74 0e                	je     0x4e


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
