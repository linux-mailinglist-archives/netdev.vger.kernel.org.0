Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CBB6D0D02
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjC3Rls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjC3Rlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:41:47 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23483E068
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:41:46 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id a19-20020a056e0208b300b003260dffae47so8041852ilt.17
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:41:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680198105; x=1682790105;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7v1YglbOtREbKuqnbHJ8UKXCGSFaDBrIC+CAndWF+04=;
        b=x9gw0PmcH3Uu0MG5d6ku1kkctESQE5plzvvXGfvpRumWK0w6/DONiDAz2BUVxiq6Hn
         JcfU0pRhrPwaq6vrjwgWVsWZhxYJLUVYTy0N8moAFKT6X5z842lnfwK7AoglbJKahqCM
         A50ymlJ65aVccmgxF3LdEaQ8FMhRbIMF4vOm8ZYjjQJaiEupm3JU+SoW7wwreb2SFqob
         8vFOGpk0qb3A27kvjDurxxFYgzj/XvG9vljzZhIKglIWc81cMWyzMAHKiEsec1SvTprm
         Uu6pMDJ1H0Lzt9S+u3utF4yMonjfEyCFDjopr1pBTvNVqkHJEK9FXvPfcol3ottrspO8
         LVIA==
X-Gm-Message-State: AO0yUKVThbNAwg/FC1wq5RQwrGFNo996jqSFUfD4IYecvHsvI0c6ymYd
        jQSzwi1T/T5rgphnLsHdZDXtXgW7mMXeM0mKECFH38wWjxMB
X-Google-Smtp-Source: AK7set9jZDw2Jg6QXOuiZOojCscA0p8uGYeC2CsaDZYKHhJqJ5G8ORq40dTupjVCf0IthB0ecMU333iN16Z0kP6w/nPvi81oHH/H
MIME-Version: 1.0
X-Received: by 2002:a02:62ce:0:b0:3c5:1971:1b7f with SMTP id
 d197-20020a0262ce000000b003c519711b7fmr9911856jac.6.1680198105347; Thu, 30
 Mar 2023 10:41:45 -0700 (PDT)
Date:   Thu, 30 Mar 2023 10:41:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000038beff05f8219be2@google.com>
Subject: [syzbot] [net?] kernel BUG in icmp_glue_bits
From:   syzbot <syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ffe78bbd5121 Merge tag 'xtensa-20230327' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13f9a03ec80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e626f76ad59b1c14
dashboard link: https://syzkaller.appspot.com/bug?extid=d373d60fddbdc915e666
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:3343!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 15766 Comm: syz-executor.0 Not tainted 6.3.0-rc4-syzkaller-00039-gffe78bbd5121 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:skb_copy_and_csum_bits+0x798/0x860 net/core/skbuff.c:3343
Code: f0 c1 c8 08 41 89 c6 e9 73 ff ff ff e8 61 48 d4 f9 e9 41 fd ff ff 48 8b 7c 24 48 e8 52 48 d4 f9 e9 c3 fc ff ff e8 c8 27 84 f9 <0f> 0b 48 89 44 24 28 e8 3c 48 d4 f9 48 8b 44 24 28 e9 9d fb ff ff
RSP: 0018:ffffc90000007620 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000001e8 RCX: 0000000000000100
RDX: ffff8880276f6280 RSI: ffffffff87fdd138 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000000001e8 R11: 0000000000000001 R12: 000000000000003c
R13: 0000000000000000 R14: ffff888028244868 R15: 0000000000000b0e
FS:  00007fbc81f1c700(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2df43000 CR3: 00000000744db000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 icmp_glue_bits+0x7b/0x210 net/ipv4/icmp.c:353
 __ip_append_data+0x1d1b/0x39f0 net/ipv4/ip_output.c:1161
 ip_append_data net/ipv4/ip_output.c:1343 [inline]
 ip_append_data+0x115/0x1a0 net/ipv4/ip_output.c:1322
 icmp_push_reply+0xa8/0x440 net/ipv4/icmp.c:370
 __icmp_send+0xb80/0x1430 net/ipv4/icmp.c:765
 ipv4_send_dest_unreach net/ipv4/route.c:1239 [inline]
 ipv4_link_failure+0x5a9/0x9e0 net/ipv4/route.c:1246
 dst_link_failure include/net/dst.h:423 [inline]
 arp_error_report+0xcb/0x1c0 net/ipv4/arp.c:296
 neigh_invalidate+0x20d/0x560 net/core/neighbour.c:1079
 neigh_timer_handler+0xc77/0xff0 net/core/neighbour.c:1166
 call_timer_fn+0x1a0/0x580 kernel/time/timer.c:1700
 expire_timers+0x29b/0x4b0 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1d4/0x905 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x114/0x190 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
RIP: 0010:finish_task_switch.isra.0+0x2bf/0xc80 kernel/sched/core.c:5186
Code: 8b 3a 4c 89 e7 48 c7 02 00 00 00 00 ff d1 4d 85 ff 75 bf 4c 89 e7 e8 60 f8 ff ff e8 5b 94 31 00 fb 65 48 8b 1c 25 c0 b8 03 00 <48> 8d bb 50 15 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1
RSP: 0018:ffffc900024174b8 EFLAGS: 00000206
RAX: 0000000000003935 RBX: ffff8880276f6280 RCX: 1ffffffff1cedbd1
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90002417500 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff1cee1da R11: 0000000000000000 R12: ffff88802ca3c2c0
R13: ffff888028392000 R14: 0000000000000000 R15: ffff88802ca3ccf8
 context_switch kernel/sched/core.c:5310 [inline]
 __schedule+0xc99/0x5770 kernel/sched/core.c:6625
 schedule+0xde/0x1a0 kernel/sched/core.c:6701
 schedule_timeout+0x276/0x2b0 kernel/time/timer.c:2143
 unix_wait_for_peer+0x244/0x280 net/unix/af_unix.c:1450
 unix_dgram_sendmsg+0x16bf/0x1950 net/unix/af_unix.c:2048
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x334/0x900 net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
 __sys_sendmmsg+0x18f/0x460 net/socket.c:2641
 __do_sys_sendmmsg net/socket.c:2670 [inline]
 __se_sys_sendmmsg net/socket.c:2667 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2667
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbc8128c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc81f1c168 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fbc813abf80 RCX: 00007fbc8128c0f9
RDX: 0000000000000318 RSI: 00000000200bd000 RDI: 0000000000000004
RBP: 00007fbc812e7b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffed3267a6f R14: 00007fbc81f1c300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_copy_and_csum_bits+0x798/0x860 net/core/skbuff.c:3343
Code: f0 c1 c8 08 41 89 c6 e9 73 ff ff ff e8 61 48 d4 f9 e9 41 fd ff ff 48 8b 7c 24 48 e8 52 48 d4 f9 e9 c3 fc ff ff e8 c8 27 84 f9 <0f> 0b 48 89 44 24 28 e8 3c 48 d4 f9 48 8b 44 24 28 e9 9d fb ff ff
RSP: 0018:ffffc90000007620 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000001e8 RCX: 0000000000000100
RDX: ffff8880276f6280 RSI: ffffffff87fdd138 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000000001e8 R11: 0000000000000001 R12: 000000000000003c
R13: 0000000000000000 R14: ffff888028244868 R15: 0000000000000b0e
FS:  00007fbc81f1c700(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2df43000 CR3: 00000000744db000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8b 3a                	mov    (%rdx),%edi
   2:	4c 89 e7             	mov    %r12,%rdi
   5:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
   c:	ff d1                	callq  *%rcx
   e:	4d 85 ff             	test   %r15,%r15
  11:	75 bf                	jne    0xffffffd2
  13:	4c 89 e7             	mov    %r12,%rdi
  16:	e8 60 f8 ff ff       	callq  0xfffff87b
  1b:	e8 5b 94 31 00       	callq  0x31947b
  20:	fb                   	sti
  21:	65 48 8b 1c 25 c0 b8 	mov    %gs:0x3b8c0,%rbx
  28:	03 00
* 2a:	48 8d bb 50 15 00 00 	lea    0x1550(%rbx),%rdi <-- trapping instruction
  31:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  38:	fc ff df
  3b:	48 89 fa             	mov    %rdi,%rdx
  3e:	48                   	rex.W
  3f:	c1                   	.byte 0xc1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
