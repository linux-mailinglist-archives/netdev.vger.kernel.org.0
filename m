Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FE162A015
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKORSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiKORSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:18:43 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DAAFDF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:18:42 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id q6-20020a056e020c2600b00302664fc72cso3407860ilg.14
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:18:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SZYFdepLdLLBz3kuYnNkUTI8QvLao2m+qSUsVMEEUrU=;
        b=vRBKURi6fYAEGWhuxmmZu3XpBy9H3lI9ewExz+n/RpsyC52LBwrXkN+WvvYIudQ5gR
         uhXO57jEF7uJ0garjsMJ7Ip/fW9UgtB42bijkzAKRamlX9VH+FniH7Sgrjy4r2OH0zYd
         W2u3kbK4co2WAWATCLH3csmKjvR566cxB5BGJxXmQ3sXCKvrdE3NGjeSSukUBTeuww+0
         9Xi2UNxeWCBnqE6QueF+6PcKw+Vw4Pn+R9f64lLcJGG4VosHwVs0PP9ZH1HmIaHcjJxu
         kyxGFU80rw/0suAwqWl/wslteXj8k9YeDI3TXgEtMfilX7hMOpty58xhdbRgbsiIun41
         WuNQ==
X-Gm-Message-State: ANoB5plWGdMZ2yywbnV4AIurODHsqON4GwXnk3hQyQKsXYUGquqX5Qer
        ldUjJPLCoHWCFFAUe3y6WVu/QkSvF6VrHY+FpBN8GisB78Dg
X-Google-Smtp-Source: AA0mqf7YGSOSV8bw4F7p48hxW/QP4J8XYNwR0R91MzpkeuCp7a+F+lrldyiJjwZOXxU0Mb7kJVOF+oghAnw+j6iUZsWvlcW867Sf
MIME-Version: 1.0
X-Received: by 2002:a02:a61a:0:b0:374:4af4:8630 with SMTP id
 c26-20020a02a61a000000b003744af48630mr8423411jam.89.1668532721621; Tue, 15
 Nov 2022 09:18:41 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:18:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b1f7d05ed858cb7@google.com>
Subject: [syzbot] WARNING in send_hsr_supervision_frame (3)
From:   syzbot <syzbot+3ae0a3f42c84074b7c8e@syzkaller.appspotmail.com>
To:     bigeasy@linutronix.de, brianvv@google.com, claudiajkang@gmail.com,
        davem@davemloft.net, edumazet@google.com, ennoerlangen@gmail.com,
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

HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14146fc6880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
dashboard link: https://syzkaller.appspot.com/bug?extid=3ae0a3f42c84074b7c8e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d967e5d91fa/disk-55be6084.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9a8cffcbc089/vmlinux-55be6084.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ae0a3f42c84074b7c8e@syzkaller.appspotmail.com

------------[ cut here ]------------
HSR: Could not send supervision frame
WARNING: CPU: 0 PID: 3593 at net/hsr/hsr_device.c:293 send_hsr_supervision_frame+0x66d/0x8d0 net/hsr/hsr_device.c:293
Modules linked in:
CPU: 0 PID: 3593 Comm: syz-fuzzer Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:send_hsr_supervision_frame+0x66d/0x8d0 net/hsr/hsr_device.c:293
Code: 1d 90 9c 9a 04 31 ff 89 de e8 9f bf 4a f8 84 db 75 b6 e8 16 c3 4a f8 48 c7 c7 20 f0 21 8b c6 05 70 9c 9a 04 01 e8 12 a7 0d 00 <0f> 0b eb 9a e8 fa c2 4a f8 41 be 3c 00 00 00 ba 01 00 00 00 4c 89
RSP: 0018:ffffc90000007c60 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801cd93b00 RSI: ffffffff81612e28 RDI: fffff52000000f7e
RBP: ffff8880445b8c80 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000100 R11: 000000003a525348 R12: ffff888020fe8f80
R13: 0000000000000000 R14: ffff888020fe8f98 R15: 0000000000000017
FS:  000000c000052090(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c001ab66b0 CR3: 000000002091d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 hsr_announce+0x10c/0x330 net/hsr/hsr_device.c:382
 call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:__syscall_enter_from_user_work kernel/entry/common.c:89 [inline]
RIP: 0010:syscall_enter_from_user_mode+0x2c/0xb0 kernel/entry/common.c:110
Code: 49 89 f4 55 48 89 fd 53 48 8b 7c 24 18 e8 4c fa ff ff eb 28 eb 2c e8 13 fa fe f7 e8 ce f7 fe f7 fb 65 48 8b 04 25 80 6f 02 00 <48> 8b 70 08 40 f6 c6 3f 75 1a 5b 4c 89 e0 5d 41 5c c3 eb 1c 0f 0b
RSP: 0018:ffffc90003baff20 EFLAGS: 00000246
RAX: ffff88801cd93b00 RBX: 0000000000000002 RCX: 1ffffffff1bc1f51
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8982c992
RBP: ffffc90003baff58 R08: 0000000000000000 R09: 0000000000000000
R10: fffffbfff1bc18da R11: 0000000000000001 R12: 0000000000000023
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 do_syscall_64+0x16/0xb0 arch/x86/entry/common.c:76
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x46703d
Code: 8b 44 24 20 b9 40 42 0f 00 f7 f1 48 89 04 24 b8 e8 03 00 00 f7 e2 48 89 44 24 08 48 89 e7 be 00 00 00 00 b8 23 00 00 00 0f 05 <48> 8b 6c 24 10 48 83 c4 18 c3 cc cc cc cc cc cc cc cc cc cc cc cc
RSP: 002b:000000c000061f10 EFLAGS: 00000202 ORIG_RAX: 0000000000000023
RAX: ffffffffffffffda RBX: 0000000000002710 RCX: 000000000046703d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000c000061f10
RBP: 000000c000061f20 R08: 0000000000080d9f R09: 00007fff7a533080
R10: 0000000000000000 R11: 0000000000000202 R12: 000000c000061950
R13: 000000c016676000 R14: 000000c0000004e0 R15: 00007f1b6b42021a
 </TASK>
----------------
Code disassembly (best guess):
   0:	49 89 f4             	mov    %rsi,%r12
   3:	55                   	push   %rbp
   4:	48 89 fd             	mov    %rdi,%rbp
   7:	53                   	push   %rbx
   8:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   d:	e8 4c fa ff ff       	callq  0xfffffa5e
  12:	eb 28                	jmp    0x3c
  14:	eb 2c                	jmp    0x42
  16:	e8 13 fa fe f7       	callq  0xf7fefa2e
  1b:	e8 ce f7 fe f7       	callq  0xf7fef7ee
  20:	fb                   	sti
  21:	65 48 8b 04 25 80 6f 	mov    %gs:0x26f80,%rax
  28:	02 00
* 2a:	48 8b 70 08          	mov    0x8(%rax),%rsi <-- trapping instruction
  2e:	40 f6 c6 3f          	test   $0x3f,%sil
  32:	75 1a                	jne    0x4e
  34:	5b                   	pop    %rbx
  35:	4c 89 e0             	mov    %r12,%rax
  38:	5d                   	pop    %rbp
  39:	41 5c                	pop    %r12
  3b:	c3                   	retq
  3c:	eb 1c                	jmp    0x5a
  3e:	0f 0b                	ud2


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
