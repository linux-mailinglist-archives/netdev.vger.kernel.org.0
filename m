Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775F3265459
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgIJVmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:42:45 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:44831 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730771AbgIJMiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 08:38:23 -0400
Received: by mail-il1-f200.google.com with SMTP id j11so4381586ilr.11
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 05:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=VwrlinUd9kcwoUzQiQFmPRuCi3c6IG53KKTkPvCrpzw=;
        b=a4+7j8ckCBOZvmhs3IXT8YVx8gqX0+042DvfpUJCPQ8tD/z0pAtIT9ehWbhu7Z5XTh
         2uluTko+7TkE/VA+NRl53gIhD8SYqWgyb0LWdFud2nJzlMmi6Xdl2dcGJvVrenK0MDZ7
         WAv/oiHWIEsgIRGQADFgHDSj9ttI9Xouu/jAGGUwAJJ1CoJO6Kf7+qLePK4yiHcKXi7i
         PJ/BLuS9eIZYlAaWebeOC6JWfm6Nk1Nn0J2ToZxrQtSvC14amQJvRc/waLSEZfDDJ2g5
         SR5xzHjjRKHxAbD05QLggtDYpITIQykQbRmweJ14ib2ZI6RXfBF942p52Gi1xgoDcuuy
         AwTw==
X-Gm-Message-State: AOAM532ISjIScopfpsRDeRTKqdIeCNz4USQcFiw3v2ZE0OrfQgGwb6vE
        sbFiROv4hQnkN4R6/Ky+GGvZWjiWfOYgLOma2NjzznaPC0i6
X-Google-Smtp-Source: ABdhPJyjTYvh1M3ybPxkFS58uNVt6Y64hVVYzYW7pgEStSABBQd+BfOcqLa5rX1BCN4hHSH1erBwZ1TTwM4QYfGq6hWE7lc4nO1t
MIME-Version: 1.0
X-Received: by 2002:a92:d07:: with SMTP id 7mr4985339iln.243.1599741499410;
 Thu, 10 Sep 2020 05:38:19 -0700 (PDT)
Date:   Thu, 10 Sep 2020 05:38:19 -0700
In-Reply-To: <000000000000a74731059f545387@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce0feb05aef4d7a1@google.com>
Subject: Re: WARNING in tracepoint_probe_register_prio (4)
From:   syzbot <syzbot+1b2f76c6fb6f549f728b@syzkaller.appspotmail.com>
To:     allison@lohutok.net, gregkh@linuxfoundation.org,
        gustavo@embeddedor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        netdev@vger.kernel.org, rfontana@redhat.com, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    34d4ddd3 Merge tag 'linux-kselftest-5.9-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ab2b7d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f5c353182ed6199
dashboard link: https://syzkaller.appspot.com/bug?extid=1b2f76c6fb6f549f728b
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145c4735900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d31621900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1b2f76c6fb6f549f728b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6978 at kernel/tracepoint.c:243 func_add kernel/tracepoint.c:147 [inline]
WARNING: CPU: 1 PID: 6978 at kernel/tracepoint.c:243 tracepoint_add_func kernel/tracepoint.c:241 [inline]
WARNING: CPU: 1 PID: 6978 at kernel/tracepoint.c:243 tracepoint_probe_register_prio+0x4ac/0x590 kernel/tracepoint.c:315
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6978 Comm: syz-executor432 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 panic+0x2c0/0x800 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:tracepoint_add_func kernel/tracepoint.c:147 [inline]
RIP: 0010:tracepoint_probe_register_prio+0x4ac/0x590 kernel/tracepoint.c:315
Code: 48 89 df e8 16 b2 1f 00 89 c5 31 ff 89 c6 e8 1b 7c fe ff 85 ed 7e 1a e8 02 78 fe ff eb 20 e8 fb 77 fe ff 49 c7 c7 ef ff ff ff <0f> 0b 44 89 fd eb 4f e8 e8 77 fe ff 48 89 df e8 30 b8 1f 00 31 ed
RSP: 0018:ffffc900055a7c38 EFLAGS: 00010293
RAX: ffffffff81768595 RBX: dffffc0000000000 RCX: ffff88808d43e1c0
RDX: 0000000000000000 RSI: 000000000000000a RDI: 000000000000000a
RBP: ffff88809d603660 R08: ffffffff8176831e R09: fffffbfff13164de
R10: fffffbfff13164de R11: 0000000000000000 R12: 000000000000000a
R13: 0000000000000003 R14: 00000000ffffffff R15: ffffffffffffffef
 bpf_raw_tracepoint_open kernel/bpf/syscall.c:2741 [inline]
 __do_sys_bpf+0x63ae/0x11060 kernel/bpf/syscall.c:4220
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446bd9
Code: e8 8c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6d31c3eda8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446bd9
RDX: 0000000000000010 RSI: 00000000200001c0 RDI: 0000000000000011
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0000000020000100 R14: 00000000004aebc0 R15: 0000000000000064
Kernel Offset: disabled
Rebooting in 86400 seconds..

