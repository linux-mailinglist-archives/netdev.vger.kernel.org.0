Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D3062F3E6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbiKRLko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiKRLkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:40:43 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B40D91534
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:40:41 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id z139-20020a6bc991000000b006dac0d359edso2434365iof.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:40:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t3yguII6knaKUcip+42pEQJBXF45AFcWcXVP/LRNy6s=;
        b=VsS2CDvr8zSqZl/xaluJmLePeqanBQ/ozhG3Lo9ItWE1S+KCgaqnKZMkc9UCq2xj8H
         PTC08lAqKtunI0OGAVNlqsLL00kMYDPcuF5OXaq68OmV3NyXMwJO4S+Y+Y67nRDk+xLw
         Q4wY/+vZonReVPd/pB2QKna1M/L9p61dq39jhu79e0pHewJ4uE9oLBVPqQXQj6Lc8Oof
         zpnouMsN/DlHI51nuYluOt728uJH5/oLZmwri1LtSR8JVW+9rRK/Ab9u5uKQ4yb8aJzF
         C7MvVfdTeY+OfAsKATXQ1irL8SQLcLwmDWNIUGcMpz9i0NOCju/wkQ712g3ikOhsu/8Y
         1Rvg==
X-Gm-Message-State: ANoB5pnCDuUv3uLpJfE0c1D/fhuyLRPTxdOSO3GLMfR5U5vfI9ZCML5W
        WaknFmM3UROsjAzsRYXX/pj6VfEyB8yPnm3iQkS6AWL7qe38
X-Google-Smtp-Source: AA0mqf6TLJ+VgbffJPFQ+hgBPFsQNVzpJ+C3V/fPwGfmUNJ+8X+uQ5hDZFLaml3ThateogQW4ID2fWQL3Tf9mw80E8AgIkE0AzR1
MIME-Version: 1.0
X-Received: by 2002:a02:a317:0:b0:363:6ef6:a52c with SMTP id
 q23-20020a02a317000000b003636ef6a52cmr2884718jai.287.1668771640639; Fri, 18
 Nov 2022 03:40:40 -0800 (PST)
Date:   Fri, 18 Nov 2022 03:40:40 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000da093705edbd2ca4@google.com>
Subject: [syzbot] general protection fault in ax25_send_frame (2)
From:   syzbot <syzbot+4643bc868f47ad276452@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jreuter@yaina.de,
        kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org,
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

HEAD commit:    0727a9a5fbc1 Documentation: mptcp: fix pm_type formatting
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=149755e8880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58826a10ff282dbf
dashboard link: https://syzkaller.appspot.com/bug?extid=4643bc868f47ad276452
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/27e66e05ee01/disk-0727a9a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/df24b686590e/vmlinux-0727a9a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4643bc868f47ad276452@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000006c: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000360-0x0000000000000367]
CPU: 1 PID: 10715 Comm: syz-executor.3 Not tainted 6.0.0-rc4-syzkaller-00136-g0727a9a5fbc1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:ax25_dev_ax25dev include/net/ax25.h:342 [inline]
RIP: 0010:ax25_send_frame+0xe4/0x640 net/ax25/ax25_out.c:56
Code: 00 48 85 c0 49 89 c4 0f 85 fb 03 00 00 e8 34 cb 2b f9 49 8d bd 60 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 b1 04 00 00 4d 8b ad 60 03 00 00 4d 85 ed 0f 84
RSP: 0000:ffffc90004c77a00 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff88814a308008 RCX: 0000000000000100
RDX: 000000000000006c RSI: ffffffff88503efc RDI: 0000000000000360
RBP: ffffffff91561460 R08: 0000000000000001 R09: ffffffff908e4a9f
R10: 0000000000000001 R11: 1ffffffff2020d9a R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000104 R15: 0000000000000000
FS:  0000555556215400(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f328000 CR3: 0000000050a64000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rose_send_frame+0xcc/0x2f0 net/rose/rose_link.c:106
 rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
 rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
 rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
 call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x45/0xc0 arch/x86/kernel/apic/apic.c:1106
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0033:0x7fe1ccc37497
Code: 75 37 b8 00 00 00 80 48 01 d0 48 3d ff ff ff 7e 0f 87 2a 02 00 00 44 89 c0 c1 e8 10 44 31 c0 83 f0 3d 8d 04 c0 89 c7 c1 ef 04 <31> f8 69 c0 2d eb d4 27 31 c5 c1 e8 0f 31 c5 80 3d e4 de 09 01 00
RSP: 002b:00007fff5e3de460 EFLAGS: 00000a06
RAX: 000000009127bfa1 RBX: 00007fe1ccd9c018 RCX: 0000001b2f320000
RDX: ffffffff81e7790e RSI: 0000001b2f324438 RDI: 0000000009127bfa
RBP: 0000000081e7790e R08: ffffffff81e77903 R09: 00000000ab355ea3
R10: 00007fff5e3de630 R11: 0000000000000246 R12: 00007fe1ccd90000
R13: 0000000000000001 R14: 00000000000165f4 R15: ffffffff81e7790e
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ax25_dev_ax25dev include/net/ax25.h:342 [inline]
RIP: 0010:ax25_send_frame+0xe4/0x640 net/ax25/ax25_out.c:56
Code: 00 48 85 c0 49 89 c4 0f 85 fb 03 00 00 e8 34 cb 2b f9 49 8d bd 60 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 b1 04 00 00 4d 8b ad 60 03 00 00 4d 85 ed 0f 84
RSP: 0000:ffffc90004c77a00 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff88814a308008 RCX: 0000000000000100
RDX: 000000000000006c RSI: ffffffff88503efc RDI: 0000000000000360
RBP: ffffffff91561460 R08: 0000000000000001 R09: ffffffff908e4a9f
R10: 0000000000000001 R11: 1ffffffff2020d9a R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000104 R15: 0000000000000000
FS:  0000555556215400(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f328000 CR3: 0000000050a64000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 48 85             	add    %cl,-0x7b(%rax)
   3:	c0 49 89 c4          	rorb   $0xc4,-0x77(%rcx)
   7:	0f 85 fb 03 00 00    	jne    0x408
   d:	e8 34 cb 2b f9       	callq  0xf92bcb46
  12:	49 8d bd 60 03 00 00 	lea    0x360(%r13),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 b1 04 00 00    	jne    0x4e5
  34:	4d 8b ad 60 03 00 00 	mov    0x360(%r13),%r13
  3b:	4d 85 ed             	test   %r13,%r13
  3e:	0f                   	.byte 0xf
  3f:	84                   	.byte 0x84


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
