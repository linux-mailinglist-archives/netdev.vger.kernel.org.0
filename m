Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593468F7E9
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHPALF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:11:05 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41691 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHPALF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:11:05 -0400
Received: by mail-io1-f72.google.com with SMTP id r6so1423742iog.8
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 17:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7aNOMcysliVqYix28FIAFaamW29TY9E/DIOR9SA9tVo=;
        b=RUlXjuXgW8NjKuklz3t+aDAUSNfGUMPaZWWYKg6OkV3ZdpEU+MiHd/ejnRyDBP5Ggu
         B8PXvkysziyPqB1TyVnrA39QX8mOQZn2Askeox7g4rUVCsXSSslCLkhWZ9RyerGvH1gV
         E5NRhIZcA/VGrnuVN46iv3O6Q7900002cI+uII1Ta8ycocLvPJYxS94ujnpDC5iNte+9
         8kyC1dMCL2vcQhydsyVfenpvXx5Grnae/KC1jAPhWVAswHo0CVFkf3eypvPwNI+8M5ZM
         F0igsOE8YVMfvDM3h7ENnjr8w7NmdaLgN4qRZ3xBlHJq7XBv/6BffCk9Th/wbIq3X+Ac
         zUZg==
X-Gm-Message-State: APjAAAUYZxBy/bLp6yKlmKHlTFRpUKoCKRvQz1R4My/wuVAIX4NRS2oW
        tBVjufdmXuLW/uyE+H5IS31wLheCo6tvFI4a6nQjziRhf6kg
X-Google-Smtp-Source: APXvYqz6bK5qk2bfTYB+nezTUfiQuXS7EZc0ZX1tjIAMdih8Y/x52ZzN3gyLpTW7T4oU0FyX39wPb3Le2RuodI3clWkblgMnCRcS
MIME-Version: 1.0
X-Received: by 2002:a02:4e43:: with SMTP id r64mr7978873jaa.34.1565914264167;
 Thu, 15 Aug 2019 17:11:04 -0700 (PDT)
Date:   Thu, 15 Aug 2019 17:11:04 -0700
In-Reply-To: <000000000000ab6f84056c786b93@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000076ecf3059030d3f1@google.com>
Subject: Re: WARNING in tracepoint_probe_register_prio (3)
From:   syzbot <syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com>
To:     ard.biesheuvel@linaro.org, gregkh@linuxfoundation.org,
        gustavo@embeddedor.com, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, netdev@vger.kernel.org, paulmck@linux.ibm.com,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    ecb9f80d net/mvpp2: Replace tasklet with softirq hrtimer
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=115730ac600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=774fddf07b7ab29a1e55
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b02a22600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 8824 at kernel/tracepoint.c:243 tracepoint_add_func  
kernel/tracepoint.c:243 [inline]
WARNING: CPU: 0 PID: 8824 at kernel/tracepoint.c:243  
tracepoint_probe_register_prio+0x216/0x790 kernel/tracepoint.c:315
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8824 Comm: syz-executor.4 Not tainted 5.3.0-rc3+ #133
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:219
  __warn.cold+0x20/0x4c kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:tracepoint_add_func kernel/tracepoint.c:243 [inline]
RIP: 0010:tracepoint_probe_register_prio+0x216/0x790 kernel/tracepoint.c:315
Code: 48 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 bf 04 00 00 48 8b 45 b8 49 3b  
45 08 0f 85 21 ff ff ff 41 bd ef ff ff ff e8 aa 8c fe ff <0f> 0b e8 a3 8c  
fe ff 48 c7 c7 20 44 de 88 e8 d7 1d ca 05 44 89 e8
RSP: 0018:ffff88807b5a7498 EFLAGS: 00010293
RAX: ffff8880a87a85c0 RBX: ffffffff89a1eb00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff8173fcd6 RDI: ffff88808afc4698
RBP: ffff88807b5a74f0 R08: ffff8880a87a85c0 R09: fffffbfff11bc885
R10: ffff88807b5a7488 R11: ffffffff88de4427 R12: ffff88808afc4690
R13: 00000000ffffffef R14: 00000000ffffffff R15: ffffffff8177f710
  tracepoint_probe_register+0x2b/0x40 kernel/tracepoint.c:335
  register_trace_sched_wakeup include/trace/events/sched.h:96 [inline]
  tracing_sched_register kernel/trace/trace_sched_switch.c:54 [inline]
  tracing_start_sched_switch+0xa8/0x190 kernel/trace/trace_sched_switch.c:106
  tracing_start_cmdline_record+0x13/0x20  
kernel/trace/trace_sched_switch.c:131
  trace_printk_init_buffers kernel/trace/trace.c:3050 [inline]
  trace_printk_init_buffers.cold+0xdf/0xe9 kernel/trace/trace.c:3013
  bpf_get_trace_printk_proto+0xe/0x20 kernel/trace/bpf_trace.c:338
  cgroup_base_func_proto kernel/bpf/cgroup.c:799 [inline]
  cgroup_base_func_proto.isra.0+0x10e/0x120 kernel/bpf/cgroup.c:776
  cg_sockopt_func_proto+0x53/0x70 kernel/bpf/cgroup.c:1411
  check_helper_call+0x141/0x32f0 kernel/bpf/verifier.c:3950
  do_check+0x6213/0x89f0 kernel/bpf/verifier.c:7707
  bpf_check+0x6f99/0x9948 kernel/bpf/verifier.c:9294
  bpf_prog_load+0xe68/0x1670 kernel/bpf/syscall.c:1698
  __do_sys_bpf+0xc43/0x3460 kernel/bpf/syscall.c:2849
  __se_sys_bpf kernel/bpf/syscall.c:2808 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2808
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc4bf1dec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459829
RDX: 0000000000000070 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc4bf1df6d4
R13: 00000000004bfc7c R14: 00000000004d1938 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..

