Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F5423FF37
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 18:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHIQ1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 12:27:25 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:40696 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgHIQ1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 12:27:19 -0400
Received: by mail-il1-f199.google.com with SMTP id z16so6057603ill.7
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 09:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4XSXq+pkr3PFjgGjwOy8V7S5LJrWfQdXc+zd762spFo=;
        b=WrmTHcz/EEqWPQtJdbN7JXFrxWqn3hsCpqKJHztWyTCwFWmKyOyH0SqkU2Y6w7oQPu
         ifn4qBXE9qDQLPzUyw3crCKHyAO0TkVtjFeKGjk6SPg283Xa2S1AZfiZ+z/BZ5b9itPB
         3zm4oifcVOCpFqStTI5CKjpUh75KUl3VlIPmzd0cneylHB5oEC0sc4lJezado2RaDoQl
         fZPQOTDpqM4A2/KEzeFf3gu2vHFt8d63muHYrB6Q+uGrqHR6GblxrljcVmfCFosrDqBr
         CnmT7dZxwdhVn9HRkOVihpI91QgIs3SCbKMlG3yPSE2oF1H/uEtnHP+PV86pJyB32Lya
         VP7Q==
X-Gm-Message-State: AOAM532+W1O2KNrEsE3a+aIi4sFgFXWqL93nU0bsnmxri5rbhBkcv3xU
        xuP6uS6/qgoU1KGQEp5/iTFdsWHlXV+kzwuOx4xT063JtZHK
X-Google-Smtp-Source: ABdhPJxCb8Fc9gj7xJ+738Iy5K3TiYRUKs+DEiRZYCnd9cRMmFmxLa8rdrZjOLEpssozQCq8J6+vTEW/PuRy1QsjTxu8mqAFxiNp
MIME-Version: 1.0
X-Received: by 2002:a92:480f:: with SMTP id v15mr13207248ila.123.1596990437671;
 Sun, 09 Aug 2020 09:27:17 -0700 (PDT)
Date:   Sun, 09 Aug 2020 09:27:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf4b3605ac744f22@google.com>
Subject: KMSAN: uninit-value in batadv_hard_if_event (2)
From:   syzbot <syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=106e4c3c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com

usb 1-1: config 0 descriptor??
=====================================================
BUG: KMSAN: uninit-value in batadv_check_known_mac_addr net/batman-adv/hard-interface.c:512 [inline]
BUG: KMSAN: uninit-value in batadv_hardif_add_interface net/batman-adv/hard-interface.c:944 [inline]
BUG: KMSAN: uninit-value in batadv_hard_if_event+0x28d7/0x3bd0 net/batman-adv/hard-interface.c:1034
CPU: 0 PID: 8697 Comm: kworker/0:3 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 batadv_check_known_mac_addr net/batman-adv/hard-interface.c:512 [inline]
 batadv_hardif_add_interface net/batman-adv/hard-interface.c:944 [inline]
 batadv_hard_if_event+0x28d7/0x3bd0 net/batman-adv/hard-interface.c:1034
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0x123/0x290 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2027 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 register_netdevice+0x3120/0x37d0 net/core/dev.c:9545
 register_netdev+0xbe/0x100 net/core/dev.c:9645
 rtl8150_probe+0x12d9/0x15b0 drivers/net/usb/rtl8150.c:916
 usb_probe_interface+0xece/0x1550 drivers/usb/core/driver.c:374
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_set_configuration+0x380f/0x3f10 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0x138/0x300 drivers/usb/core/generic.c:241
 usb_probe_device+0x311/0x490 drivers/usb/core/driver.c:272
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_new_device+0x1bd4/0x2a30 drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5208 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x5e7b/0x8a70 drivers/usb/core/hub.c:5576
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 set_ethernet_addr drivers/net/usb/rtl8150.c:282 [inline]
 rtl8150_probe+0x1236/0x15b0 drivers/net/usb/rtl8150.c:912
 usb_probe_interface+0xece/0x1550 drivers/usb/core/driver.c:374
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_set_configuration+0x380f/0x3f10 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0x138/0x300 drivers/usb/core/generic.c:241
 usb_probe_device+0x311/0x490 drivers/usb/core/driver.c:272
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_new_device+0x1bd4/0x2a30 drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5208 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x5e7b/0x8a70 drivers/usb/core/hub.c:5576
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Local variable ----node_id.i@rtl8150_probe created at:
 get_registers drivers/net/usb/rtl8150.c:911 [inline]
 set_ethernet_addr drivers/net/usb/rtl8150.c:281 [inline]
 rtl8150_probe+0xea7/0x15b0 drivers/net/usb/rtl8150.c:912
 get_registers drivers/net/usb/rtl8150.c:911 [inline]
 set_ethernet_addr drivers/net/usb/rtl8150.c:281 [inline]
 rtl8150_probe+0xea7/0x15b0 drivers/net/usb/rtl8150.c:912
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
