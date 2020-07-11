Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99A621C26B
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 07:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgGKFeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 01:34:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43008 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgGKFeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 01:34:20 -0400
Received: by mail-io1-f70.google.com with SMTP id f13so4918582iok.10
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 22:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xQqkzXJSiBOJC7uDqFIe38A+OBOOU1MTrcP1CTp3drI=;
        b=g/l233gNMlFSIIKGgMD4QYeQEYjD4j1LzsaFzznQbhYJGTkI1hXdgPjnopZRuz+8ub
         0jVO2VMOzE1s+EJS1vOWtknc/c+jZUai9K/QISUblgf+1P6PVDDMP04N60K0otx5fG6G
         hjICLld3eeUH9JU8M5F60NBdLwoFzPwvHX/paBaQGNlZrIlBm2cpLWibpcBc1FeQYUEi
         F15jMDXPMX2PFDmw9Jv5/q1oy/fjyy/temBb4278dxa8gpCVVb50nl6KnW9IEgl3lCV6
         Erz45SLBIT2QgCMjiuRVQn9eUx/H697AVw3KTcnI1wM+WBFFpcT/JL4JmwFyZ5xi2jss
         K19A==
X-Gm-Message-State: AOAM533pXSbwDmIXdW9LYJhu/jnw3SU3Rywp69G5K/jSXBoktYLKrREO
        vAfkyy0eOiKJDTaB1DKzx3LjrYGhPGvV6lbJFYOdOTeszKEe
X-Google-Smtp-Source: ABdhPJy3gXGHkaStF2y9rzpoQ6EvN0VBPV0QVIj+hwYXeTq8RkWJR/T8QvD8x+5OqQMBPfG1KhEoxyJ1abEqc9VmvIrdNLoy9KEE
MIME-Version: 1.0
X-Received: by 2002:a92:a196:: with SMTP id b22mr25062377ill.303.1594445659724;
 Fri, 10 Jul 2020 22:34:19 -0700 (PDT)
Date:   Fri, 10 Jul 2020 22:34:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029663005aa23cff4@google.com>
Subject: WARNING in submit_bio_checks
From:   syzbot <syzbot+4c50ac32e5b10e4133e1@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9e50b94b Add linux-next specific files for 20200703
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=112aaa1f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f99cc0faa1476ed6
dashboard link: https://syzkaller.appspot.com/bug?extid=4c50ac32e5b10e4133e1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1111fb6d100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1218fa1f100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4c50ac32e5b10e4133e1@syzkaller.appspotmail.com

------------[ cut here ]------------
Trying to write to read-only block-device nullb0 (partno 0)
WARNING: CPU: 0 PID: 6821 at block/blk-core.c:857 bio_check_ro block/blk-core.c:857 [inline]
WARNING: CPU: 0 PID: 6821 at block/blk-core.c:857 submit_bio_checks+0x1aba/0x1f70 block/blk-core.c:985
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6821 Comm: syz-executor914 Not tainted 5.8.0-rc3-next-20200703-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x13/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:563
RIP: 0010:bio_check_ro block/blk-core.c:857 [inline]
RIP: 0010:submit_bio_checks+0x1aba/0x1f70 block/blk-core.c:985
Code: 04 00 00 45 8b a4 24 a4 05 00 00 48 8d 74 24 68 48 89 ef e8 b8 21 fe ff 48 c7 c7 e0 ce 91 88 48 89 c6 44 89 e2 e8 08 df c0 fd <0f> 0b 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 80 3c 02
RSP: 0018:ffffc90001277338 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880a0cb2240 RCX: 0000000000000000
RDX: ffff8880a8ebc180 RSI: ffffffff815d7d27 RDI: fffff5200024ee59
RBP: ffff8880a03101c0 R08: 0000000000000001 R09: ffff8880ae6318e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880a03101c8 R14: 0000000000000000 R15: ffff8880a03101e8
 submit_bio_noacct+0x89/0x12d0 block/blk-core.c:1198
 submit_bio+0x263/0x5b0 block/blk-core.c:1283
 submit_bh_wbc+0x685/0x8e0 fs/buffer.c:3105
 __block_write_full_page+0x837/0x12e0 fs/buffer.c:1848
 block_write_full_page+0x214/0x270 fs/buffer.c:3034
 __writepage+0x60/0x170 mm/page-writeback.c:2311
 write_cache_pages+0x736/0x11b0 mm/page-writeback.c:2246
 generic_writepages mm/page-writeback.c:2337 [inline]
 generic_writepages+0xe2/0x150 mm/page-writeback.c:2326
 do_writepages+0xec/0x290 mm/page-writeback.c:2352
 __filemap_fdatawrite_range+0x2a1/0x380 mm/filemap.c:422
 filemap_write_and_wait_range mm/filemap.c:655 [inline]
 filemap_write_and_wait_range+0xe1/0x1c0 mm/filemap.c:649
 filemap_write_and_wait include/linux/fs.h:2629 [inline]
 __sync_blockdev fs/block_dev.c:480 [inline]
 sync_blockdev fs/block_dev.c:489 [inline]
 __blkdev_put+0x69a/0x890 fs/block_dev.c:1863
 blkdev_close+0x8c/0xb0 fs/block_dev.c:1947
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb72/0x2a40 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:904
 __do_sys_exit_group kernel/exit.c:915 [inline]
 __se_sys_exit_group kernel/exit.c:913 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:913
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:367
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43ee48
Code: Bad RIP value.
RSP: 002b:00007ffdd4c8f808 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ee48
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004be648 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d0180 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
