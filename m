Return-Path: <netdev+bounces-3536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5277707CAC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 674FC2817A9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29284AD4B;
	Thu, 18 May 2023 09:20:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0C08BE8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:20:09 +0000 (UTC)
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF202113
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:20:06 -0700 (PDT)
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3379306f979so12065295ab.2
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684401606; x=1686993606;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldRtM+w8c0ezsi/wVgK+QDTkfuk9sqQrg6/3YDE4GdA=;
        b=DHdCg7KI6GQ3ev49RhlFoCFxz9glmNvHmQTWH85fzZJU46hTU33L5WMYdRoRn94kbT
         JeBfHhnJ4ToGrgR4UIJayeNV+leGa9ooxLKE0lKLEkp+sUzVAcuqcTSMNy+CDk0U+n73
         35ZRUh2bwhJZs6Bw1oyxJ3cXez9RzQmveaizBEtuR3zDSwi1WgDmq37BOvlrQHaxwhPq
         YPrjkhuTBV2/UUDRCohcpaT6yNMwUxOVqqtVPK6SZ9Yx9d57hJslMGY1INV6AdjPMuZ8
         6XtUyF0EnpiNO8Hpt5vFEIert8UjNWWa7BLS8UodnUQbUGuePHdWZvrZbentHvyZQy+j
         CYHw==
X-Gm-Message-State: AC+VfDwY8bJ+UFjnb9JJTQ87X3vCwUfT/m3mRG1Q9YhrC872CPiJJx5r
	nDPxxpA5s4Lt3zPwIwpjLpo+p0kqNCHLMF2SZqMfvH+ikKzk
X-Google-Smtp-Source: ACHHUZ4jkQj/jeB2K5GE2hlelIdQ7lF1LJSR5r+gGRbmc8FyZrjqP8ksfZquC13n534fJXcCswHTw3j/8NKG+/3P6CjWXwCswhhZ
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d084:0:b0:329:5faf:cbc0 with SMTP id
 h4-20020a92d084000000b003295fafcbc0mr2670148ilh.2.1684401606056; Thu, 18 May
 2023 02:20:06 -0700 (PDT)
Date: Thu, 18 May 2023 02:20:06 -0700
In-Reply-To: <000000000000235bce05fac5f850@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000063657005fbf44fb2@google.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
From: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot has found a reproducer for the following issue on:

HEAD commit:    ab87603b2511 net: wwan: t7xx: Ensure init is completed bef..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1157266a280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb92acf166a5d2cd
dashboard link: https://syzkaller.appspot.com/bug?extid=eba589d8f49c73d356da
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124d5da6280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ac3ed2228400/disk-ab87603b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c51b74034116/vmlinux-ab87603b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/98ab9d7ee1ee/bzImage-ab87603b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com

infiniband syz2: set active
infiniband syz2: added team0
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 5133 Comm: syz-executor.3 Not tainted 6.4.0-rc1-syzkaller-00136-gab87603b2511 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 assign_lock_key kernel/locking/lockdep.c:982 [inline]
 register_lock_class+0xdb6/0x1120 kernel/locking/lockdep.c:1295
 __lock_acquire+0x10a/0x5df0 kernel/locking/lockdep.c:4951
 lock_acquire kernel/locking/lockdep.c:5691 [inline]
 lock_acquire+0x1b1/0x520 kernel/locking/lockdep.c:5656
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
 skb_dequeue+0x20/0x180 net/core/skbuff.c:3639
 drain_resp_pkts drivers/infiniband/sw/rxe/rxe_comp.c:555 [inline]
 rxe_completer+0x250d/0x3cc0 drivers/infiniband/sw/rxe/rxe_comp.c:652
 rxe_qp_do_cleanup+0x1be/0x820 drivers/infiniband/sw/rxe/rxe_qp.c:761
 execute_in_process_context+0x3b/0x150 kernel/workqueue.c:3473
 __rxe_cleanup+0x21e/0x370 drivers/infiniband/sw/rxe/rxe_pool.c:233
 rxe_create_qp+0x3f6/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:583
 create_qp+0x5ac/0x970 drivers/infiniband/core/verbs.c:1235
 ib_create_qp_kernel+0xa1/0x310 drivers/infiniband/core/verbs.c:1346
 ib_create_qp include/rdma/ib_verbs.h:3743 [inline]
 create_mad_qp+0x177/0x380 drivers/infiniband/core/mad.c:2905
 ib_mad_port_open drivers/infiniband/core/mad.c:2986 [inline]
 ib_mad_init_device+0xf40/0x1a90 drivers/infiniband/core/mad.c:3077
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:721
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1332
 ib_register_device drivers/infiniband/core/device.c:1420 [inline]
 ib_register_device+0x8b1/0xbc0 drivers/infiniband/core/device.c:1366
 rxe_register_device+0x302/0x3e0 drivers/infiniband/sw/rxe/rxe_verbs.c:1485
 rxe_net_add+0x90/0xf0 drivers/infiniband/sw/rxe/rxe_net.c:527
 rxe_newlink+0xf0/0x1b0 drivers/infiniband/sw/rxe/rxe.c:197
 nldev_newlink+0x332/0x5e0 drivers/infiniband/core/nldev.c:1731
 rdma_nl_rcv_msg+0x371/0x6a0 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb.constprop.0.isra.0+0x2fc/0x440 drivers/infiniband/core/netlink.c:239
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7a1ee8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7a1fc76168 EFLAGS: 00000246
 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7a1efabf80 RCX: 00007f7a1ee8c169
RDX: 0000000000000040 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007f7a1eee7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffc46ccb6f R14: 00007f7a1fc76300 R15: 0000000000022000
 </TASK>
general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 PID: 5133 Comm: syz-executor.3 Not tainted 6.4.0-rc1-syzkaller-00136-gab87603b2511 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
RIP: 0010:flush_send_queue drivers/infiniband/sw/rxe/rxe_comp.c:597 [inline]
RIP: 0010:rxe_completer+0x255c/0x3cc0 drivers/infiniband/sw/rxe/rxe_comp.c:653
Code: 80 3c 02 00 0f 85 81 10 00 00 49 8b af 88 03 00 00 48 8d 45 30 48 89 c2 48 89 04 24 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 83 11 00 00 48 8d 45 2c 44 8b
RSP: 0018:ffffc9000419e938 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffed100f5fb800 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff877f3bea RDI: ffff88807afdc388
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: fffffbfff1cf4e42 R11: 205d313330355420 R12: ffff88807afdc1a0
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88807afdc000
FS:  00007f7a1fc76700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c001136000 CR3: 00000000206d3000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rxe_qp_do_cleanup+0x1be/0x820 drivers/infiniband/sw/rxe/rxe_qp.c:761
 execute_in_process_context+0x3b/0x150 kernel/workqueue.c:3473
 __rxe_cleanup+0x21e/0x370 drivers/infiniband/sw/rxe/rxe_pool.c:233
 rxe_create_qp+0x3f6/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:583
 create_qp+0x5ac/0x970 drivers/infiniband/core/verbs.c:1235
 ib_create_qp_kernel+0xa1/0x310 drivers/infiniband/core/verbs.c:1346
 ib_create_qp include/rdma/ib_verbs.h:3743 [inline]
 create_mad_qp+0x177/0x380 drivers/infiniband/core/mad.c:2905
 ib_mad_port_open drivers/infiniband/core/mad.c:2986 [inline]
 ib_mad_init_device+0xf40/0x1a90 drivers/infiniband/core/mad.c:3077
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:721
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1332
 ib_register_device drivers/infiniband/core/device.c:1420 [inline]
 ib_register_device+0x8b1/0xbc0 drivers/infiniband/core/device.c:1366
 rxe_register_device+0x302/0x3e0 drivers/infiniband/sw/rxe/rxe_verbs.c:1485
 rxe_net_add+0x90/0xf0 drivers/infiniband/sw/rxe/rxe_net.c:527
 rxe_newlink+0xf0/0x1b0 drivers/infiniband/sw/rxe/rxe.c:197
 nldev_newlink+0x332/0x5e0 drivers/infiniband/core/nldev.c:1731
 rdma_nl_rcv_msg+0x371/0x6a0 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb.constprop.0.isra.0+0x2fc/0x440 drivers/infiniband/core/netlink.c:239
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7a1ee8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7a1fc76168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7a1efabf80 RCX: 00007f7a1ee8c169
RDX: 0000000000000040 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007f7a1eee7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffc46ccb6f R14: 00007f7a1fc76300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:flush_send_queue drivers/infiniband/sw/rxe/rxe_comp.c:597 [inline]
RIP: 0010:rxe_completer+0x255c/0x3cc0 drivers/infiniband/sw/rxe/rxe_comp.c:653
Code: 80 3c 02 00 0f 85 81 10 00 00 49 8b af 88 03 00 00 48 8d 45 30 48 89 c2 48 89 04 24 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 83 11 00 00 48 8d 45 2c 44 8b
RSP: 0018:ffffc9000419e938 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffed100f5fb800 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff877f3bea RDI: ffff88807afdc388
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: fffffbfff1cf4e42 R11: 205d313330355420 R12: ffff88807afdc1a0
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88807afdc000
FS:  00007f7a1fc76700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c001136000 CR3: 00000000206d3000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	0f 85 81 10 00 00    	jne    0x108b
   a:	49 8b af 88 03 00 00 	mov    0x388(%r15),%rbp
  11:	48 8d 45 30          	lea    0x30(%rbp),%rax
  15:	48 89 c2             	mov    %rax,%rdx
  18:	48 89 04 24          	mov    %rax,(%rsp)
  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  23:	fc ff df
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 83 11 00 00    	jle    0x11bd
  3a:	48 8d 45 2c          	lea    0x2c(%rbp),%rax
  3e:	44                   	rex.R
  3f:	8b                   	.byte 0x8b


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

