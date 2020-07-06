Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D682155C9
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgGFKrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:47:18 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:46232 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgGFKrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:47:16 -0400
Received: by mail-il1-f198.google.com with SMTP id d8so24376367ilc.13
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 03:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=o/+nsIISRaR1UrBUB4a9yq3mmK58VS9sslSGe+mCmmE=;
        b=SqX0qXWGa7dAwDAlfj4krB5dr7CCDmPRi+6GuP01/A11yRUeq0F8Dc8tg0+OuLXPtS
         wScIeogMGARx2f8LAvLroVQ0+Xfr/qxTQN5hFqxImWq1H0Lju0kdnEmRFEldM70/RAqH
         a7icVzR+uDKXNOThz6H+GM81J0WC5TE5xuAOLyx5+7Oo1XxMRVv/rHCUJeF+xfXNj4cF
         9Xk92Vm6XlVY9zWq5zJb3MOUPhtiEyw6paawh9m3jnlACoxeDDK1b+kKKfZ1XdHQ5nW/
         4BccLuKu7Xz0rauYAdIdCWxmQYscgWATWqQAcwNnj42wp7SorY/5y2bR9SlddOHm+ZxB
         6mgg==
X-Gm-Message-State: AOAM53066c70Fh3xuqTnuTLgDN6WYwt25yjWt3WDlLFmO/2RQN3BiSvt
        V8QmGle3LaqScoUmcukG7OBDhM2LBaYlZ/CyTEa0X4nY4ARc
X-Google-Smtp-Source: ABdhPJyk+EJS6DncAZ9gMYNkHM+eSchccXnLzjXZJPLRW6EFCALsyjxejwWsDLJN4YPNct78Z7zPBLtVeU7M1lyUHeCk2wLjk3cl
MIME-Version: 1.0
X-Received: by 2002:a92:bf0c:: with SMTP id z12mr28944209ilh.151.1594032436051;
 Mon, 06 Jul 2020 03:47:16 -0700 (PDT)
Date:   Mon, 06 Jul 2020 03:47:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c866805a9c3993f@google.com>
Subject: WARNING in remove_one_compat_dev
From:   syzbot <syzbot+4e28a66bf14b987f9dee@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bdc48fa1 checkpatch/coding-style: deprecate 80-column warn..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12b3ffe2100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=129ea1e5950835e5
dashboard link: https://syzkaller.appspot.com/bug?extid=4e28a66bf14b987f9dee
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4e28a66bf14b987f9dee@syzkaller.appspotmail.com

infiniband syz1: Port 1 not found
infiniband syz1: Couldn't close port 1 for agents
infiniband syz1: Port 1 not found
infiniband syz1: Couldn't close port 1
------------[ cut here ]------------
sysfs group 'power' not found for kobject 'syz1'
WARNING: CPU: 1 PID: 3384 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
WARNING: CPU: 1 PID: 3384 at fs/sysfs/group.c:279 sysfs_remove_group+0x155/0x1b0 fs/sysfs/group.c:270
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 3384 Comm: kworker/u4:2 Not tainted 5.7.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound ib_unregister_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:sysfs_remove_group fs/sysfs/group.c:279 [inline]
RIP: 0010:sysfs_remove_group+0x155/0x1b0 fs/sysfs/group.c:270
Code: 48 89 d9 49 8b 14 24 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 01 00 75 41 48 8b 33 48 c7 c7 20 f2 39 88 e8 03 bb 5e ff <0f> 0b eb 95 e8 32 50 cb ff e9 d2 fe ff ff 48 89 df e8 25 50 cb ff
RSP: 0018:ffffc90005447b40 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff88931b20 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815cf161 RDI: fffff52000a88f5a
RBP: 0000000000000000 R08: ffff888066c68280 R09: ffffed1015ce45f1
R10: ffff8880ae722f83 R11: ffffed1015ce45f0 R12: ffff88808995c000
R13: ffffffff889320c0 R14: ffff88808eae8700 R15: ffff8880aa034800
 dpm_sysfs_remove+0x97/0xb0 drivers/base/power/sysfs.c:794
 device_del+0x18b/0xd30 drivers/base/core.c:2711
 remove_one_compat_dev+0x52/0x70 drivers/infiniband/core/device.c:940
 remove_compat_devs drivers/infiniband/core/device.c:951 [inline]
 disable_device+0x1ab/0x230 drivers/infiniband/core/device.c:1282
 __ib_unregister_device+0x91/0x180 drivers/infiniband/core/device.c:1437
 ib_unregister_work+0x15/0x30 drivers/infiniband/core/device.c:1547
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
