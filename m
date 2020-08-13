Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC52437B5
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgHMJbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 05:31:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:57120 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgHMJbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 05:31:19 -0400
Received: by mail-il1-f197.google.com with SMTP id a14so41640ilt.23
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 02:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iULDNrU3wU77g15OGdBBrBKhYSuPNWFb2hnHV4cWJRI=;
        b=pewXl2uSnn46b9oyuYGuOeIyVvut2dMQYiTG9Lr4oz4D9p+J8dwmiKoolOn31cZOsI
         VGL5E+OCnRCzVodWckqW0fKWi+9V+AQDQo3vwTqxln95qlYymRYh9iovg/2n/ML/zdbb
         OX2uM1K5WJNqmbl0uSOtVYVBEp8sgPs4jfnWA+BW/lnG9RiH2AoYP+gR1xQtYtXexbk2
         RXg2tnJkHF77WW5f95z1jc2yFwGCFNIumYGAWxKdWrU/uqe3pAyU7+/w0alEtLNFDAPn
         a7/HiojE/355daPOxtBc8oKuCO8HpOOAaE0QiWtfp3MfBiN85g4/sFE8UUMNAKZ5FZVZ
         NwIA==
X-Gm-Message-State: AOAM531nO5C0N2GDQ0cJhfj1ycnAZy1At0lN2ANKbWlNnIP1pMQoBgrK
        0mSKJJwhRCoCkOPJQB4trCMsbojlGb8IlXC31LJztnfVxKAB
X-Google-Smtp-Source: ABdhPJwjSfdYpDaOLGkwv9pl55bzrhseFffwwyjVdOsbCZgO66GXdKBIkKa3cY2r0Sn28/LdveBU1dxfUpnOHtrvd3RrnxoE2n+K
MIME-Version: 1.0
X-Received: by 2002:a92:841c:: with SMTP id l28mr3742608ild.297.1597311078122;
 Thu, 13 Aug 2020 02:31:18 -0700 (PDT)
Date:   Thu, 13 Aug 2020 02:31:18 -0700
In-Reply-To: <000000000000bf4b3605ac744f22@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000068562c05acbef79d@google.com>
Subject: Re: KMSAN: uninit-value in batadv_hard_if_event (2)
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1015b616900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17837fba900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1218cc16900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com

usb 1-1: new high-speed USB device number 2 using dummy_hcd
usb 1-1: New USB device found, idVendor=07b8, idProduct=401a, bcdDevice=3d.3d
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
=====================================================
BUG: KMSAN: uninit-value in batadv_check_known_mac_addr net/batman-adv/hard-interface.c:512 [inline]
BUG: KMSAN: uninit-value in batadv_hardif_add_interface net/batman-adv/hard-interface.c:944 [inline]
BUG: KMSAN: uninit-value in batadv_hard_if_event+0x28d7/0x3bd0 net/batman-adv/hard-interface.c:1034
CPU: 1 PID: 29 Comm: kworker/1:1 Not tainted 5.8.0-rc5-syzkaller #0
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

