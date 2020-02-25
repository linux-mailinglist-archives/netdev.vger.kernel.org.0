Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA216B937
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgBYFnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:43:15 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40657 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYFnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 00:43:15 -0500
Received: by mail-il1-f198.google.com with SMTP id m18so23051587ill.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 21:43:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hMFIzaD34cEyiy4pe9ZVgsYgncv2dmIkFd8NRXrfNIw=;
        b=ar0BZEcPR5Br4GqWEFUtrCRXPemJV1afjqCwvis1P4+FV4pZ3zEQ+OvUsiR7bU9Omk
         dQNBs0VrdSKz+epKlX7LCx+jlsn/D0WJZfCuVGTwF4/KIqGXUamcJ3HUv01nFvsla1gH
         K2k6uDvMRycT4vtV05t4RnT3aF7k/0Ik9oxO+u00lsCJiiH2jBOy4ij5AuhI3gaFJIww
         uU0pYM6iljeqOQo/ToFQQzYwQSvLDQR8OiVmEUoiqsmjwCQOyoV9gwzWkbbWzxInDHSv
         dri1yb7H6P32OqNDzrGgnV1K3Odsk50PvaN9yz0wq2Q4sIbNAFzAiQMXqePZDXot3zlP
         OMaQ==
X-Gm-Message-State: APjAAAWn+vqzTX9UFwiPWXIVTVswsPaQZgYW9nNF1H90v2Tj+zspeWSr
        CTI/cCs4JkQnhgij0isqe/5VKeoZJi/BI69ppuSXwnYK7wuA
X-Google-Smtp-Source: APXvYqyX+8bh4pqGwUyfTDN7ausdfx6o3oaqgOKmF9c/aUSjuAI8sb9sMQDpMWqe/nIzsmjZWo8ldZYW7CfFCUz71Ymm9LWtZcy3
MIME-Version: 1.0
X-Received: by 2002:a02:b38f:: with SMTP id p15mr56855445jan.56.1582609393220;
 Mon, 24 Feb 2020 21:43:13 -0800 (PST)
Date:   Mon, 24 Feb 2020 21:43:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b380de059f5ff6aa@google.com>
Subject: WARNING: ODEBUG bug in tcindex_destroy_work (3)
From:   syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d2eee258 Merge tag 'for-5.6-rc2-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17fd8931e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e57a6b450fb9883
dashboard link: https://syzkaller.appspot.com/bug?extid=46f513c3033d592409d2
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint: tcindex_destroy_rexts_work+0x0/0xd0 net/sched/cls_tcindex.c:57
WARNING: CPU: 1 PID: 21 at lib/debugobjects.c:488 debug_print_object lib/debugobjects.c:485 [inline]
WARNING: CPU: 1 PID: 21 at lib/debugobjects.c:488 __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
WARNING: CPU: 1 PID: 21 at lib/debugobjects.c:488 debug_check_no_obj_freed+0x468/0x620 lib/debugobjects.c:998
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 21 Comm: kworker/u4:1 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: tc_filter_workqueue tcindex_destroy_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 panic+0x264/0x7a9 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1b6/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xcf/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object lib/debugobjects.c:485 [inline]
RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
RIP: 0010:debug_check_no_obj_freed+0x468/0x620 lib/debugobjects.c:998
Code: 08 48 89 df e8 f9 27 0f fe 4c 8b 03 48 c7 c7 75 eb f0 88 48 c7 c6 8f dc ee 88 4c 89 e2 44 89 f9 4d 89 e9 31 c0 e8 28 c4 a3 fd <0f> 0b 48 ba 00 00 00 00 00 fc ff df 4c 8b 6d b0 ff 05 b6 df c4 05
RSP: 0018:ffffc90000dd7be0 EFLAGS: 00010046
RAX: a8ee08c59d207d00 RBX: ffffffff892d11c0 RCX: ffff8880a9bf6580
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90000dd7c78 R08: ffffffff81600324 R09: ffffed1015d64592
R10: ffffed1015d64592 R11: 0000000000000000 R12: ffffffff88f4c8da
R13: ffffffff869b5000 R14: ffff88802cc7c000 R15: 0000000000000000
 kfree+0xff/0x220 mm/slab.c:3756
 tcindex_destroy_work+0x3e/0x70 net/sched/cls_tcindex.c:231
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
