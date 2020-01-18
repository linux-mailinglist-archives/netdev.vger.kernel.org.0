Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC01141660
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgARHrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:47:24 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:55844 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgARHrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:47:12 -0500
Received: by mail-il1-f197.google.com with SMTP id p8so20712166ilp.22
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:47:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CRXke8eR0q6DPeLllNC24q78sVHSU9QDg6o3snEOvdM=;
        b=hWq1Zm0i6hepqL/xsio16+choEEEh1E9029WPz5pldlFO3MhAe6oyMAlgmhjH3sHY0
         qNuejjsT3YttRuOehjJAUuoyA/iv8nGxd/cLY4gYHRk9WrstckyGvn0H1qwMnVy8AT1z
         qgM2NdlMpBHJUz+V6PRtsMHzKtHrIlHxhT/5uW4QbQagjXq+hfixiD2Q7bF8Tm8t2bY2
         yToATwF9L2t59tR8DYBlk34wadaQrgqIakRbZwOR7qlJAv4i0GEZ91J2ha81AHQj5Qxg
         Uqfqy6e6x12vAxAaGWrTi7jHxewvcqLF59RH86E/7GY44FRQ3mQUngAGRPYsJjzeNMog
         iUIA==
X-Gm-Message-State: APjAAAVH7QL/NRbihND6ypnvqRykn8ELddjyQV96hM3M2IeIw7kuWejN
        TVGV05jZA7Ph5thlbJgDcBqWrsxQcBUGHoGz5KWog6D9VK5G
X-Google-Smtp-Source: APXvYqwFSQwfpvxF5wjBt+lbY90y4xNohRk2aMd/eY9kXtYHnS5IRbeq89rl7+Pmi193u2fCS/8VbbMWuy7ipQoEMd0CZO/7UMWT
MIME-Version: 1.0
X-Received: by 2002:a6b:6f07:: with SMTP id k7mr34218948ioc.174.1579333631809;
 Fri, 17 Jan 2020 23:47:11 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:47:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001b2259059c654421@google.com>
Subject: WARNING in tracing_func_proto
From:   syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    428cd523 sfc/ethtool_common: Make some function to static
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10483421e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=0c147ca7bd4352547635
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com

------------[ cut here ]------------
Could not allocate percpu trace_printk buffer
WARNING: CPU: 1 PID: 11733 at kernel/trace/trace.c:3112 alloc_percpu_trace_buffer kernel/trace/trace.c:3112 [inline]
WARNING: CPU: 1 PID: 11733 at kernel/trace/trace.c:3112 trace_printk_init_buffers+0x5b/0x60 kernel/trace/trace.c:3126
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 11733 Comm: syz-executor.2 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:alloc_percpu_trace_buffer kernel/trace/trace.c:3112 [inline]
RIP: 0010:trace_printk_init_buffers+0x5b/0x60 kernel/trace/trace.c:3126
Code: ff be 04 00 00 00 bf 04 10 00 00 e8 3f 84 24 00 48 85 c0 0f 85 e8 37 00 00 e8 d1 57 fb ff 48 c7 c7 e0 92 2f 88 e8 54 07 cc ff <0f> 0b eb c2 90 55 48 89 e5 41 57 49 c7 c7 e0 79 2f 88 41 56 49 89
RSP: 0018:ffffc900018e7528 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 00000000000070cd RSI: ffffffff815e5e56 RDI: fffff5200031ce97
RBP: ffffc900018e7538 R08: ffff8880a204c3c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff88309580
R13: ffffffff88309240 R14: 0000000000000006 R15: ffff88805a52c000
 bpf_get_trace_printk_proto kernel/trace/bpf_trace.c:457 [inline]
 tracing_func_proto.isra.0+0x150/0x1a0 kernel/trace/bpf_trace.c:794
 pe_prog_func_proto+0x69/0x90 kernel/trace/bpf_trace.c:1023
 check_helper_call+0x123/0x48f0 kernel/bpf/verifier.c:4196
 do_check+0x613a/0x8a40 kernel/bpf/verifier.c:7978
 bpf_check+0x73d9/0xa9ef kernel/bpf/verifier.c:9777
 bpf_prog_load+0xe36/0x1960 kernel/bpf/syscall.c:1837
 __do_sys_bpf+0xa4b/0x3610 kernel/bpf/syscall.c:3073
 __se_sys_bpf kernel/bpf/syscall.c:3032 [inline]
 __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3032
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f31faef6c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000048 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f31faef76d4
R13: 00000000004c1697 R14: 00000000004d66a0 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
