Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D3D1745AD
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 10:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgB2JBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 04:01:12 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:56336 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2JBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 04:01:12 -0500
Received: by mail-il1-f200.google.com with SMTP id p67so5750830ili.23
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 01:01:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ioHk1UP6YRjV8uw5D48y+e2vf5I7mB1YV19AJTXHHO4=;
        b=TnZmEqFWjkuy0XTPu2hCfOi5gTITddT3he2+VDhAJ6CPEqyu47KomM8dqdEkHQZBZf
         XiXcFGTXSgPeJKX1jO/3cO16q9EFH7c+IRqMQ7pcly86eZQZXUPP8AMyv1+wS4tBHg5U
         EsqnChFK/T9XJCifXJT/n4/jN4vB6FaTYx/e1EzfQXE5a7kg6luPzU9w115PkBnzRU5D
         Zcs2VqeiYpyGgtrLGAdw45dfANnUYxEZOGdHOQolUs6z19W9AQ03hGa2wd+8NQeNdAh0
         UOannDTW33yNLIY9W5AYCfB9ZX+eRao1h0Ew4TLbSIov26jr8Z6AVFAzp9yrNE4UJJg4
         NCGg==
X-Gm-Message-State: APjAAAVYiLNP5o5yopkKjyeGUNpHESYnUkRYUXRMhdRk7yliCH9jbXQL
        3O3+YFju4zr/gOcrSD4JpSVLO0mYQMXWFZPhbvkVAZFjdgK4
X-Google-Smtp-Source: APXvYqzyaRKW6se62z7GnKLo9dn60+RZU/QK1eTzeeY2eBJuBRQdxj1LGORN0sIOT7VFBcGQu40j1dH9TrhI7/5+rKvDt9bcfmJF
MIME-Version: 1.0
X-Received: by 2002:a92:4448:: with SMTP id a8mr8129718ilm.256.1582966871334;
 Sat, 29 Feb 2020 01:01:11 -0800 (PST)
Date:   Sat, 29 Feb 2020 01:01:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ea4b4059fb33201@google.com>
Subject: WARNING in geneve_exit_batch_net (2)
From:   syzbot <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jbenc@redhat.com,
        linux-kernel@vger.kernel.org, moshe@mellanox.com,
        netdev@vger.kernel.org, sd@queasysnail.net,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f8788d86 Linux 5.6-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138dd22de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=68a8ed58e3d17c700de5
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16601d31e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14fdf8f9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 304 at drivers/net/geneve.c:1849 geneve_destroy_tunnels drivers/net/geneve.c:1849 [inline]
WARNING: CPU: 0 PID: 304 at drivers/net/geneve.c:1849 geneve_exit_batch_net+0x2b1/0x300 drivers/net/geneve.c:1859
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 304 Comm: kworker/u4:4 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
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
RIP: 0010:geneve_destroy_tunnels drivers/net/geneve.c:1849 [inline]
RIP: 0010:geneve_exit_batch_net+0x2b1/0x300 drivers/net/geneve.c:1859
Code: 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 46 aa d1 fc 48 8b 1b 4c 39 fb 74 13 e8 c9 80 94 fc e9 f4 fd ff ff e8 bf 80 94 fc <0f> 0b eb cf e8 b6 80 94 fc eb 05 e8 af 80 94 fc 48 8d 7d c0 e8 c6
RSP: 0018:ffffc90001917c08 EFLAGS: 00010293
RAX: ffffffff84e288c1 RBX: ffff8880a7bc6120 RCX: ffff8880a88304c0
RDX: 0000000000000000 RSI: ffffc90001917c28 RDI: ffff8880a47da068
RBP: ffffc90001917c68 R08: ffffffff866be459 R09: fffffbfff12b21a9
R10: fffffbfff12b21a9 R11: 0000000000000000 R12: ffffc90001917c28
R13: dffffc0000000000 R14: ffff8880a1ca0dd0 R15: ffffc90001917c98
 ops_exit_list net/core/net_namespace.c:175 [inline]
 cleanup_net+0x78b/0xb80 net/core/net_namespace.c:589
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
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
