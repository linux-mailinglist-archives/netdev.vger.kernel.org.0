Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00CD43F843
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhJ2H5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:57:49 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:52121 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbhJ2H5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:57:48 -0400
Received: by mail-il1-f197.google.com with SMTP id a14-20020a927f0e000000b002597075cb35so5453688ild.18
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PfWBFnPPG4lPvaMDk0IGph9b6G2FK00erXGp+Jf7TQk=;
        b=JQTV4m34uHovsTV8PQhTeEtMAQrw/Mxoqn1jIt3eli/hM9E09ziYpiI+ZY+hfqq0NP
         iwWA/jQ9k6134xcsUJxTTKJDn+gluo4tXUnCXungprKYsXNVyKQPVya7twu9xubAGOAY
         ErTZVC87q5fVGXm1At62zwj3OTw0KG4Lx5P0STc9H7G2Y1nLArDfThyPvCZseNQ7TjS7
         Azcsc0jGOo0mqm4q6U9fo37j4+eMf7GwD6IkVHKoK2Jhwm4H0W7VKgF277JHmw0Y35s3
         D66d2r91BiEBGRZO5eh7Wn2LENzSs1+w0Xliml3i1zG5ssVbBqqIY919qFq6W9o/DdKQ
         q5GA==
X-Gm-Message-State: AOAM5331COoE2DhSsVKv3jiUjto4y0d2j3MMapy5SvmER62Ld1Ie/ecU
        dQ4vuPAGPFX7xAZoXxWA39SDgzCbNYFYb7raqDX94mhMxQFx
X-Google-Smtp-Source: ABdhPJyB2ML0ggzK2VGXRURegmX0ThnVxWaa7ckmLKU//GrZIYQtK98LiuS3oW0k9ruVsqYJfzJ6TyA75jLggUKdjRQ2OqkRRapa
MIME-Version: 1.0
X-Received: by 2002:a02:cac8:: with SMTP id f8mr7054573jap.65.1635494120217;
 Fri, 29 Oct 2021 00:55:20 -0700 (PDT)
Date:   Fri, 29 Oct 2021 00:55:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000115dfe05cf7926e4@google.com>
Subject: [syzbot] WARNING in j1939_tp_txtimer
From:   syzbot <syzbot+e551332be0091d437c65@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    87066fdd2e30 Revert "mm/secretmem: use refcount_t instead ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1305869f300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59f3ef2b4077575
dashboard link: https://syzkaller.appspot.com/bug?extid=e551332be0091d437c65
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e551332be0091d437c65@syzkaller.appspotmail.com

vcan0: j1939_tp_txtimer: 0xffff888020eb8400: tx retry count reached
------------[ cut here ]------------
WARNING: CPU: 1 PID: 10368 at net/can/j1939/transport.c:1090 j1939_session_deactivate net/can/j1939/transport.c:1090 [inline]
WARNING: CPU: 1 PID: 10368 at net/can/j1939/transport.c:1090 j1939_session_deactivate_activate_next net/can/j1939/transport.c:1100 [inline]
WARNING: CPU: 1 PID: 10368 at net/can/j1939/transport.c:1090 j1939_tp_txtimer+0x25a9/0x2a80 net/can/j1939/transport.c:1169
Modules linked in:
CPU: 1 PID: 10368 Comm: syz-executor.3 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:j1939_session_deactivate net/can/j1939/transport.c:1090 [inline]
RIP: 0010:j1939_session_deactivate_activate_next net/can/j1939/transport.c:1100 [inline]
RIP: 0010:j1939_tp_txtimer+0x25a9/0x2a80 net/can/j1939/transport.c:1169
Code: 83 00 fb e9 07 ef ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 00 f0 ff ff 48 89 df e8 d1 6d bd f8 e9 f3 ef ff ff e8 a7 fe 71 f8 <0f> 0b e9 3d fa ff ff e8 9b fe 71 f8 e9 fe 01 00 00 89 d9 80 e1 07
RSP: 0018:ffffc90000dc0aa0 EFLAGS: 00010246
RAX: ffffffff8911b719 RBX: 0000000000000001 RCX: ffff88808b478000
RDX: 0000000000000302 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90000dc0c50 R08: ffffffff8911b14f R09: ffffed10041d7086
R10: ffffed10041d7086 R11: 0000000000000000 R12: ffff888020eb8400
R13: 1ffff920001b8174 R14: ffff88807ae71070 R15: dffffc0000000000
FS:  00007f32687a1700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f91a465f000 CR3: 00000000868be000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000d0eb
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x50b/0xa60 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x1b7/0x5d0 kernel/time/hrtimer.c:1766
 __do_softirq+0x392/0x7a3 kernel/softirq.c:558
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:finish_lock_switch+0x1c5/0x350 kernel/sched/core.c:4695
Code: be ff ff ff ff e8 db ca 9e 08 85 c0 74 37 4d 85 e4 75 58 0f 1f 44 00 00 4c 89 ff e8 a5 73 a1 08 e8 30 74 2e 00 fb 48 83 c4 10 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 4d 85 e4 0f 85 4a ff ff ff
RSP: 0018:ffffc9000565df28 EFLAGS: 00000286
RAX: f560f1fddc198c00 RBX: 1ffff110173a6400 RCX: ffffffff8165c2f1
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8880b9d32000 R08: dffffc0000000000 R09: fffffbfff1fa37ec
R10: fffffbfff1fa37ec R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9d32298 R14: dffffc0000000000 R15: ffff8880b9d31540
 finish_task_switch+0x140/0x630 kernel/sched/core.c:4812
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xb7a/0x1460 kernel/sched/core.c:6287
 preempt_schedule_common kernel/sched/core.c:6459 [inline]
 preempt_schedule+0x14d/0x190 kernel/sched/core.c:6484
 preempt_schedule_thunk+0x16/0x18
 unwind_next_frame+0x13fc/0x1fa0 arch/x86/kernel/unwind_orc.c:611
 arch_stack_walk+0x112/0x140 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x11b/0x1e0 kernel/stacktrace.c:121
 save_stack+0xff/0x200 mm/page_owner.c:119
 __set_page_owner+0x42/0x2f0 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0x779/0xa30 mm/page_alloc.c:4153
 __alloc_pages+0x255/0x580 mm/page_alloc.c:5375
 __page_cache_alloc+0x79/0x1c0 mm/filemap.c:1022
 page_cache_ra_unbounded+0x2ee/0x9b0 mm/readahead.c:216
 page_cache_async_readahead include/linux/pagemap.h:906 [inline]
 filemap_readahead mm/filemap.c:2520 [inline]
 filemap_get_pages+0x6b9/0xd90 mm/filemap.c:2561
 filemap_read+0x3be/0x1060 mm/filemap.c:2628
 __kernel_read+0x5d0/0xaf0 fs/read_write.c:443
 integrity_kernel_read+0xac/0xf0 security/integrity/iint.c:199
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:484 [inline]
 ima_calc_file_shash security/integrity/ima/ima_crypto.c:515 [inline]
 ima_calc_file_hash+0x1584/0x1b90 security/integrity/ima/ima_crypto.c:572
 ima_collect_measurement+0x27d/0x510 security/integrity/ima/ima_api.c:254
 process_measurement+0x101d/0x1dd0 security/integrity/ima/ima_main.c:337
 ima_file_check+0xed/0x170 security/integrity/ima/ima_main.c:516
 do_open fs/namei.c:3430 [inline]
 path_openat+0x2917/0x3670 fs/namei.c:3561
 do_filp_open+0x277/0x4f0 fs/namei.c:3588
 do_sys_openat2+0x13b/0x500 fs/open.c:1200
 do_sys_open fs/open.c:1216 [inline]
 __do_sys_open fs/open.c:1224 [inline]
 __se_sys_open fs/open.c:1220 [inline]
 __x64_sys_open+0x221/0x270 fs/open.c:1220
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f326b22ba39
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f32687a1188 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f326b32ef60 RCX: 00007f326b22ba39
RDX: 0000000000000000 RSI: 000000000014113e RDI: 0000000020000200
RBP: 00007f326b285e8f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffecc05baef R14: 00007f32687a1300 R15: 0000000000022000
----------------
Code disassembly (best guess):
   0:	be ff ff ff ff       	mov    $0xffffffff,%esi
   5:	e8 db ca 9e 08       	callq  0x89ecae5
   a:	85 c0                	test   %eax,%eax
   c:	74 37                	je     0x45
   e:	4d 85 e4             	test   %r12,%r12
  11:	75 58                	jne    0x6b
  13:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  18:	4c 89 ff             	mov    %r15,%rdi
  1b:	e8 a5 73 a1 08       	callq  0x8a173c5
  20:	e8 30 74 2e 00       	callq  0x2e7455
  25:	fb                   	sti
  26:	48 83 c4 10          	add    $0x10,%rsp
* 2a:	5b                   	pop    %rbx <-- trapping instruction
  2b:	41 5c                	pop    %r12
  2d:	41 5d                	pop    %r13
  2f:	41 5e                	pop    %r14
  31:	41 5f                	pop    %r15
  33:	5d                   	pop    %rbp
  34:	c3                   	retq
  35:	0f 0b                	ud2
  37:	4d 85 e4             	test   %r12,%r12
  3a:	0f 85 4a ff ff ff    	jne    0xffffff8a


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
