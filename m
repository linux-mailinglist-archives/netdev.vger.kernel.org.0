Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E497E37B968
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 11:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhELJla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 05:41:30 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44014 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhELJl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 05:41:29 -0400
Received: by mail-il1-f197.google.com with SMTP id l7-20020a9229070000b0290164314f61f5so19062970ilg.10
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kAFJXEj6R1YyVGGWuYrx55ynefPjAlVy8y5PgHVQ5L8=;
        b=VI7LJlAdpRIIbOyXZTRsyR0zLn5guiNAQ2CKYuQD7WZMTXFcAzeaB9+hdrQLHgSkrm
         hsW6Ro9Q3Jv001xSulf7LBo3Y7X06UmCqP4ccrBHAIqXIuWwZCB3gONE2Q28xn8UDuIo
         2JWOq/WIC+TVyBGyCHAhUShG1LM7UXoeOuQQ+TeqTDEzh929rXKtOxxnzSMNdusQBUE2
         Y5gquvtHVMpqNuGfq4WuPd0ResAzcsSBJy+dvJG0cf/thEPD9kcPfMNm7JKbW6ponmGB
         Zk98dXP2pS8NzhXNvS5ZbA648RO3fpqrmics8SrMt9VXz3ZcXmXmH/kwisgT5lpdzXvr
         NllQ==
X-Gm-Message-State: AOAM532abyrdShVXbhhpAYcIE8DAvv5GbJ6XlZnhIIPiB3J0/cVB2OWh
        y6bfroL53QKQ9A7BSftlV0+S7O3r4LlckKh1oRe9nE1VomQq
X-Google-Smtp-Source: ABdhPJwJ6dKcbyNXmvcHETLFX33nIlIUxtt5kpHGgGNzsHs7iJKcf6AE03Dj9j8bABfiyj2geSQHNjLGAPUt9GUYupx0M7AZ0IwO
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4d:: with SMTP id u13mr3504117ilv.64.1620812421262;
 Wed, 12 May 2021 02:40:21 -0700 (PDT)
Date:   Wed, 12 May 2021 02:40:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009df1b605c21ecca8@google.com>
Subject: [syzbot] WARNING in rtl8152_probe
From:   syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hayeswang@realtek.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d665ea6e Merge tag 'for-linus-5.13-rc1' of git://git.kerne..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=10ae6ff5d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f635d6ce17da8a68
dashboard link: https://syzkaller.appspot.com/bug?extid=95afd23673f5dd295c57
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a35733d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1621d7b9d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com

usb 1-1: New USB device found, idVendor=045e, idProduct=0927, bcdDevice=89.4f
usb 1-1: New USB device strings: Mfr=0, Product=4, SerialNumber=0
usb 1-1: Product: syz
usb 1-1: config 0 descriptor??
------------[ cut here ]------------
WARNING: CPU: 1 PID: 32 at drivers/net/usb/r8152.c:8138 rtl_vendor_mode drivers/net/usb/r8152.c:8138 [inline]
WARNING: CPU: 1 PID: 32 at drivers/net/usb/r8152.c:8138 rtl8152_probe+0x248/0x3050 drivers/net/usb/r8152.c:9381
Modules linked in:
CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:rtl_vendor_mode drivers/net/usb/r8152.c:8138 [inline]
RIP: 0010:rtl8152_probe+0x248/0x3050 drivers/net/usb/r8152.c:9381
Code: c3 a8 02 00 00 89 ee e8 26 bf c5 fd 41 39 ed 0f 85 40 ff ff ff e8 58 b9 c5 fd 44 89 ee 44 89 ef e8 0d bf c5 fd e8 48 b9 c5 fd <0f> 0b 41 bc ed ff ff ff e8 3b b9 c5 fd 44 89 e0 48 83 c4 40 5b 5d
RSP: 0018:ffffc900001a7178 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8881191ceaa8 RCX: 0000000000000000
RDX: ffff888107fe8000 RSI: ffffffff837b33c8 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000002
R10: ffffffff837b33c3 R11: 00000000ffffffff R12: dffffc0000000000
R13: 0000000000000001 R14: ffff8881191660a8 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8881f6b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b30f0 CR3: 000000010a0c8000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbe0/0x2100 drivers/base/core.c:3319
 usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbe0/0x2100 drivers/base/core.c:3319
 usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
 hub_port_connect drivers/usb/core/hub.c:5276 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5416 [inline]
 port_event drivers/usb/core/hub.c:5562 [inline]
 hub_event+0x2357/0x4320 drivers/usb/core/hub.c:5644
 process_one_work+0x98d/0x1580 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
