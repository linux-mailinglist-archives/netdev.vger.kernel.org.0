Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456B9F42A6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 09:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfKHI6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 03:58:09 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:48670 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730005AbfKHI6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 03:58:09 -0500
Received: by mail-il1-f199.google.com with SMTP id j68so6087844ili.15
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 00:58:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2MJ4JwOdeIflnsknF0Y5CtsGEv4aAsO6Kz3RgLYo/Zo=;
        b=D+kdYXgDfiAjRutk/f77c54K9245HjQwlCF0L1cRj0BDxfVszdBC1oUwftsO3E1IwU
         JC1DnO2roYmgN2oTGVlPfckAscjvf9wQw8dc1S/Lk8kroQMu39a6ZxB8AsbYuoSvTsbm
         OJj+ziq9ULkPdIWsliKL0kSmkIPXBjhM+DiVRCmg8iQuiQfnqtgOdwmagXakviKn9u6n
         ddem+tYJyY6vKUzbX32Nkml8YiqlmZp66xdgpP0Z5txpNVbgGc6isEWtTLb01p1bAzvc
         Awq/j4UIAfkvKMf0GLoI5hAC65Kg7kpWa/NVHxJfcm6WqJXKRVi8F6bjLQg7u6ssKPuI
         kXag==
X-Gm-Message-State: APjAAAVJU3J/wSXwyvg7H7kXM4XyrrXS3jZ55fJjtaLw9P8MnYzE+roy
        VxP66D8wACPzKFoJjHQhak0Y+WnDVS5EXZ37G6Bxod4SvlN6
X-Google-Smtp-Source: APXvYqz9BMWTyKrpiCo4kSdUfqLjyYid3sMHPZ/B5YkypwRE2tnRy3x1leIg54zjKuTWVY+Iv+TvYYuYi2QctJ7Rb8k49vbJUzoH
MIME-Version: 1.0
X-Received: by 2002:a5e:c010:: with SMTP id u16mr9018293iol.275.1573203488435;
 Fri, 08 Nov 2019 00:58:08 -0800 (PST)
Date:   Fri, 08 Nov 2019 00:58:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001677ca0596d1fb43@google.com>
Subject: WARNING in devlink_port_type_warn
From:   syzbot <syzbot+b0a18ed7b08b735d2f41@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c68c5373 Add linux-next specific files for 20191107
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10b177fae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=742545dcdea21726
dashboard link: https://syzkaller.appspot.com/bug?extid=b0a18ed7b08b735d2f41
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b0a18ed7b08b735d2f41@syzkaller.appspotmail.com

hid-generic 0000:0000:0000.0009: unknown main item tag 0x0
hid-generic 0000:0000:0000.0009: unknown main item tag 0x0
hid-generic 0000:0000:0000.0009: hidraw0: <UNKNOWN> HID v0.00 Device [syz1]  
on syz1
------------[ cut here ]------------
Type was not set for devlink port.
WARNING: CPU: 1 PID: 50 at net/core/devlink.c:6342  
devlink_port_type_warn+0x15/0x20 net/core/devlink.c:6342
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 50 Comm: kworker/1:1 Not tainted 5.4.0-rc6-next-20191107 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events devlink_port_type_warn
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:devlink_port_type_warn+0x15/0x20 net/core/devlink.c:6342
Code: 89 df e8 de 44 ec fb e9 d3 fe ff ff 66 0f 1f 84 00 00 00 00 00 55 48  
89 e5 e8 f7 19 b0 fb 48 c7 c7 e0 ef 4a 88 e8 63 2b 81 fb <0f> 0b 5d c3 0f  
1f 80 00 00 00 00 55 48 89 e5 41 55 49 89 f5 41 54
RSP: 0018:ffff8880a9b07d30 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815d0b86 RDI: ffffed1015360f98
RBP: ffff8880a9b07d30 R08: ffff8880a9b365c0 R09: fffffbfff14f374c
R10: fffffbfff14f374b R11: ffffffff8a79ba5f R12: ffff888076daecc0
R13: 0000000000000080 R14: ffff8880a99aa900 R15: ffff8880ae934540
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2263
  worker_thread+0x98/0xe40 kernel/workqueue.c:2409
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
