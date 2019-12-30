Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF85612D020
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 13:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfL3M5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 07:57:11 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:37544 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfL3M5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 07:57:10 -0500
Received: by mail-io1-f69.google.com with SMTP id t70so21995948iof.4
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 04:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tnkYtrbdew+MN41IN97wTeyB1Jrg9T1wVOo2UqHaUeY=;
        b=iCMJT3R0pjjmiN4/yUZ84ZvXw35WH1G6zJqLtAkFB1DkGWvVkDR/YAS+gRsl10soH7
         AumimDSxaedBTmQW1C3qk2nX+nrPozt9Q7PWgoEni7BWvFff2BvJY+w6RoP1UhzXrJi4
         dmvHbaQJBwAAXPSLaLHHBTmmIhO2Qc2Ht0bl6a84CZXF4T4AiBhPovYCuHvpIXNgrCCp
         m/SvH3irMTIL1WO2i/kzSmR5rxUGRQXKKQhw/UAGA6qEjw5NT4C93i+1WvhuhD5L+M6a
         fG1AmcvwtzeQ4nAvmEonRIRWeCmPRf7xLXVOSoy+AsJKNaYwhD/Ju0YIiFaqDcSAKjg8
         8d8w==
X-Gm-Message-State: APjAAAWBO3pjbnw1snyAA0lIWxEF9ZFMkLKQrrJx+ayShogkpATECeye
        WZiw06hPxCORo7hE+xQsrGg/YYp2CoeDc/JSPkfbK1fdDW+D
X-Google-Smtp-Source: APXvYqy2Q5VkNJOxwSuSJV6v3bn4MTQHxuuQHj4AqBH+FxRx1N/r4quqH+cQlslaIsdmifjdLR4XqFQB11M0UDhmRSr/z3GMPRe1
MIME-Version: 1.0
X-Received: by 2002:a02:c988:: with SMTP id b8mr52321758jap.122.1577710630038;
 Mon, 30 Dec 2019 04:57:10 -0800 (PST)
Date:   Mon, 30 Dec 2019 04:57:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a976b0059aeb6199@google.com>
Subject: WARNING in bpf_base_func_proto (2)
From:   syzbot <syzbot+74c1db5d80df1fdaef0c@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2bbc078f Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14cb1a56e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8eefa608be32ca37
dashboard link: https://syzkaller.appspot.com/bug?extid=74c1db5d80df1fdaef0c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+74c1db5d80df1fdaef0c@syzkaller.appspotmail.com

------------[ cut here ]------------
Could not allocate percpu trace_printk buffer
WARNING: CPU: 0 PID: 9591 at kernel/trace/trace.c:3112  
alloc_percpu_trace_buffer kernel/trace/trace.c:3112 [inline]
WARNING: CPU: 0 PID: 9591 at kernel/trace/trace.c:3112  
trace_printk_init_buffers+0x5b/0x60 kernel/trace/trace.c:3126
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9591 Comm: syz-executor.2 Not tainted 5.5.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
Code: ff be 04 00 00 00 bf 04 10 00 00 e8 ef 7f 24 00 48 85 c0 0f 85 e8 37  
00 00 e8 31 58 fb ff 48 c7 c7 80 a9 2f 88 e8 94 ff cb ff <0f> 0b eb c2 90  
55 48 89 e5 41 57 49 c7 c7 80 90 2f 88 41 56 49 89
RSP: 0018:ffffc90001627500 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000701d RSI: ffffffff815e9606 RDI: fffff520002c4e92
RBP: ffffc90001627510 R08: ffff8880a3ace3c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8831d720
R13: 0000000000000006 R14: 0000000000000006 R15: dffffc0000000000
  bpf_get_trace_printk_proto+0xe/0x20 kernel/trace/bpf_trace.c:457
  bpf_base_func_proto net/core/filter.c:5977 [inline]
  bpf_base_func_proto+0x199/0x1b0 net/core/filter.c:5939
  sk_filter_func_proto+0x84/0xa0 net/core/filter.c:6054
  cg_skb_func_proto+0x8c/0x120 net/core/filter.c:6088
  check_helper_call+0x143/0x4940 kernel/bpf/verifier.c:4195
  do_check+0x6258/0x8b20 kernel/bpf/verifier.c:7972
  bpf_check+0x73d9/0xa9ef kernel/bpf/verifier.c:9771
  bpf_prog_load+0xe36/0x1960 kernel/bpf/syscall.c:1837
  __do_sys_bpf+0xa4b/0x3610 kernel/bpf/syscall.c:3073
  __se_sys_bpf kernel/bpf/syscall.c:3032 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3032
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a919
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fab38bdfc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a919
RDX: 0000000000000048 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fab38be06d4
R13: 00000000004c0f9d R14: 00000000004d4c28 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
