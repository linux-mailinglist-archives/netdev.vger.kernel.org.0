Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697C632F4D5
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 21:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCEU5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 15:57:41 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:53179 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCEU5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 15:57:17 -0500
Received: by mail-il1-f200.google.com with SMTP id e16so2788769ile.19
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 12:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=N9h4PY940X2Vdb/yMG+r/6xuF1LLW6SS3G8crYPx4nQ=;
        b=HivUN5Qq5T9gHzTgH3pJrpIb0kxWqJJSoRaJjCV3zuSWL+9cR+KrR6/P+y36b1Su24
         /Hs+Ag6j7EW7g8mLF3N8fNTgqHSb4RIc/ARk/R+dcyLDccHLGa9gFIiCX0uuiCrxyks7
         IGRE+f3W0drhFnA2y7EH5ptDDtFMljxc1eDvohR4AiG0eg6xsN9BI7jweUV6p7U8qBzm
         7qTQrVIGS4hiB0ArtdIOPTCyW5sRGqzLegTKA3NEx18qlQJ5dVWI+5PDy5BwA9A8Ah8K
         lGQAPXGR4CkQ4uvQeDU6c60ZmI/ikxo3P8F9QD75xciPwlXX9/cMYDVQL1OjgYBQv5IU
         nUrw==
X-Gm-Message-State: AOAM533KdJk491GCx3ztR9AE0wezvYGMseTZIbGJjSxUIW7GeaWfO2GR
        ZoaDv6Zy8LfPa1X7FDu9+PRe4mgaBwA6hsCXHWmRz3vOkGZm
X-Google-Smtp-Source: ABdhPJwuPfs/RQ+MRBFmjs3ZlWf8iRxe2qD/yDBCuuDqxnHW2dbFPjBuFTqWJ1MOnaMyxO4SN5g9837J/6kjBjwPuIErJvtY5mtD
MIME-Version: 1.0
X-Received: by 2002:a92:da48:: with SMTP id p8mr9941257ilq.137.1614977836989;
 Fri, 05 Mar 2021 12:57:16 -0800 (PST)
Date:   Fri, 05 Mar 2021 12:57:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b43a605bcd0545c@google.com>
Subject: [syzbot] net-next boot error: WARNING in kvm_wait
From:   syzbot <syzbot+05a8c6cb8281f23c8915@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d310ec03 Merge tag 'perf-core-2021-02-17' of git://git.ker..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1532e4c6d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66df2ca4f2dd3022
dashboard link: https://syzkaller.appspot.com/bug?extid=05a8c6cb8281f23c8915

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05a8c6cb8281f23c8915@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 0 PID: 4818 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 0 PID: 4818 Comm: selinux-autorel Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: bf ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 8a 88 b1 04 00 74 01 c3 48 c7 c7 40 a2 6b 89 c6 05 79 88 b1 04 01 e8 b8 37 bf ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0018:ffffc900015cfc40 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff8be287a0 RCX: 0000000000000000
RDX: ffff888022b31bc0 RSI: ffffffff815b6845 RDI: fffff520002b9f7a
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815af71e R11: 0000000000000000 R12: 0000000000000003
R13: fffffbfff17c50f4 R14: 0000000000000001 R15: ffff8880b9c35f40
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff7c1ccab04 CR3: 000000000bc8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 check_stack_usage kernel/exit.c:715 [inline]
 do_exit+0x1d6a/0x2ae0 kernel/exit.c:868
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff7c19e9618
Code: Unable to access opcode bytes at RIP 0x7ff7c19e95ee.
RSP: 002b:00007fff88573528 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff7c19e9618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 000055658b8146e0 R08: 00000000000000e7 R09: ffffffffffffff98
R10: 000055658bead6c0 R11: 0000000000000246 R12: 000055658b8037a0
R13: 00007fff88573810 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
