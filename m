Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02632F8D0
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 08:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhCFHhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 02:37:50 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:36565 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhCFHhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 02:37:22 -0500
Received: by mail-io1-f71.google.com with SMTP id j1so3909418ioo.3
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 23:37:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4bIFHO7ddh1jh+cBPZ4Jmy6kzLTjnBLbQImJxnxU9v8=;
        b=XL6m65+eJsiI5TvoPP3vLBw4ldntVR+kh6fcJu1bQd7UAfnrdXiq5HYRVWn1UTIdic
         iiAGBX0i3VVm7SL7hXSE9OROBg8C9GDUWKhYDCWZgMsIu4/pO5V9Qxdnuyk0kkUu+jD0
         6+bscnit28Tg4r31EpCnyghghl+39lSEkNA8i3eFe89MpHIOyPA4qowoqP9913qKh5iH
         R7K0AS4B2nf8ASNzCZ7TqFMjgz8CE6gPsJAGAs35kDEd9WxovqxmIiNFrBkc0vaEVBTB
         OdDnf4veMF/G/kW/Std2JQqrxAzDRo2OL5lrt28lyl/G99EhkwkLfEevnnj2hMYroEJJ
         luVQ==
X-Gm-Message-State: AOAM532HuMebnz83k57YJOtx+pyU/5M8Mwo//cmpIXRHh1cnu+gs+3MQ
        66Cnikc0J7feuZnEtlHhRh29y3GJ9whf905R7ehqpZqkGFj/
X-Google-Smtp-Source: ABdhPJzDagZfJ6tYUnZUsihbS1IgMvFRAGyvSs3RGvgc1ar8zPbP5IlSg8ybvs+/VDOc+EggmsR74QbKZ9iyK4MlvBdyTZi2mqdd
MIME-Version: 1.0
X-Received: by 2002:a05:6638:58f:: with SMTP id a15mr13559444jar.35.1615016241709;
 Fri, 05 Mar 2021 23:37:21 -0800 (PST)
Date:   Fri, 05 Mar 2021 23:37:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064c71f05bcd94585@google.com>
Subject: [syzbot] net boot error: WARNING in kvm_wait
From:   syzbot <syzbot+9e58a3a510889fa4af50@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ad5d07f4 cipso,calipso: resolve a number of problems with ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12aca7cad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=402784bff477e1ac
dashboard link: https://syzkaller.appspot.com/bug?extid=9e58a3a510889fa4af50

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9e58a3a510889fa4af50@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 0 PID: 4788 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 0 PID: 4788 Comm: systemd-cryptse Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 1e 61 b0 04 00 74 01 c3 48 c7 c7 a0 8e 6b 89 c6 05 0d 61 b0 04 01 e8 57 da be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0018:ffffc90000edfc40 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff8be28b80 RCX: 0000000000000000
RDX: ffff888023441bc0 RSI: ffffffff815bea35 RDI: fffff520001dbf7a
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815b77be R11: 0000000000000000 R12: 0000000000000003
R13: fffffbfff17c5170 R14: 0000000000000001 R15: ffff8880b9c35f40
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f95c090fab4 CR3: 000000000bc8e000 CR4: 00000000001506f0
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
RIP: 0033:0x7f95c1fe8618
Code: Unable to access opcode bytes at RIP 0x7f95c1fe85ee.
RSP: 002b:00007fff576bc048 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f95c1fe8618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007f95c22c58e0 R08: 00000000000000e7 R09: fffffffffffffee8
R10: 00007f95c04a3158 R11: 0000000000000246 R12: 00007f95c22c58e0
R13: 00007f95c22cac20 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
