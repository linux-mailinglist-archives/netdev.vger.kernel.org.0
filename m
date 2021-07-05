Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF983BC3F0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 00:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhGEWmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 18:42:52 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:46947 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhGEWmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 18:42:52 -0400
Received: by mail-il1-f198.google.com with SMTP id p12-20020a92d28c0000b02901ee741987a7so11381857ilp.13
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 15:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qfOEpuyNTBE+GVYW9lo6hRgg5APCtYQtdq8fCYkfeQI=;
        b=eMMFLjgNHBP86mhyUch1d79Mwc2HjQMjADHuFT2PP1PKzFY5cUw/i2xYZzRZMWfJQj
         MBhnGKxBc8tshfvyl+3RmZLuqfSzsg8iP7PiNGkMlDvTQCQlr0iFmX3JAfpUpTzEJSe+
         ydmyUZkZMDlddLOwEBIUjHcxrmNqKUm53qOfq4+qez8mI2JKcnJSBTne5X3Ue2dYB5RD
         4eVZOYNor4xYafysQzUzxHY9xiIuDgsaGoY1YkBGKE4yDeGEY2j+502cwA6d4TIw4LKl
         9d1Vbogq29opcLMicz3CS/IaUhJdsRDI4eubkTGmewx1xB/Aj2V+hH45iGQWKDVVa3TF
         6TRw==
X-Gm-Message-State: AOAM533BhGnvhv+SoonmmxP6y7yHq9M/PNm5XndJNsaMBYV0oCiezuST
        Q3aGtaorAYNmx91YPjh0dEE6eR8Hn3v6RGVcoc9jppXy2uEh
X-Google-Smtp-Source: ABdhPJyu7E1m7WKG7p52vkR2GUZ59ZsaixwOKWv+VRI5JBSH7aNHJYLNXNXmeNlqQrtCInXmnTbo6hnmOlegWl8yxnRmlAVENVZ8
MIME-Version: 1.0
X-Received: by 2002:a02:6f1e:: with SMTP id x30mr14246647jab.122.1625524814194;
 Mon, 05 Jul 2021 15:40:14 -0700 (PDT)
Date:   Mon, 05 Jul 2021 15:40:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001faaf905c667fdc7@google.com>
Subject: [syzbot] net boot error: BUG: sleeping function called from invalid
 context in stack_depot_save
From:   syzbot <syzbot+ed4030a085613986c003@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b43c8909 udp: properly flush normal packet at GRO time
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17b5d3fc300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26b64b13fcecb7e1
dashboard link: https://syzkaller.appspot.com/bug?extid=ed4030a085613986c003

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed4030a085613986c003@syzkaller.appspotmail.com

vivid-012: V4L2 transmitter device registered as radio25
vivid-012: V4L2 metadata capture device registered as video53
vivid-012: V4L2 metadata output device registered as video54
vivid-012: V4L2 touch capture device registered as v4l-touch12
vivid-013: using multiplanar format API
vivid-013: CEC adapter cec26 registered for HDMI input 0
vivid-013: V4L2 capture device registered as video55
vivid-013: CEC adapter cec27 registered for HDMI output 0
vivid-013: V4L2 output device registered as video56
vivid-013: V4L2 capture device registered as vbi26, supports raw and sliced VBI
vivid-013: V4L2 output device registered as vbi27, supports raw and sliced VBI
vivid-013: V4L2 capture device registered as swradio13
vivid-013: V4L2 receiver device registered as radio26
vivid-013: V4L2 transmitter device registered as radio27
vivid-013: V4L2 metadata capture device registered as video57
vivid-013: V4L2 metadata output device registered as video58
vivid-013: V4L2 touch capture device registered as v4l-touch13
vivid-014: using single planar format API
vivid-014: CEC adapter cec28 registered for HDMI input 0
vivid-014: V4L2 capture device registered as video59
vivid-014: CEC adapter cec29 registered for HDMI output 0
vivid-014: V4L2 output device registered as video60
vivid-014: V4L2 capture device registered as vbi28, supports raw and sliced VBI
vivid-014: V4L2 output device registered as vbi29, supports raw and sliced VBI
vivid-014: V4L2 capture device registered as swradio14
vivid-014: V4L2 receiver device registered as radio28
vivid-014: V4L2 transmitter device registered as radio29
vivid-014: V4L2 metadata capture device registered as video61
vivid-014: V4L2 metadata output device registered as video62
vivid-014: V4L2 touch capture device registered as v4l-touch14
vivid-015: using multiplanar format API
vivid-015: CEC adapter cec30 registered for HDMI input 0
vivid-015: V4L2 capture device registered as video63
vivid-015: CEC adapter cec31 registered for HDMI output 0
vivid-015: V4L2 output device registered as video64
vivid-015: V4L2 capture device registered as vbi30, supports raw and sliced VBI
vivid-015: V4L2 output device registered as vbi31, supports raw and sliced VBI
vivid-015: V4L2 capture device registered as swradio15
vivid-015: V4L2 receiver device registered as radio30
vivid-015: V4L2 transmitter device registered as radio31
vivid-015: V4L2 metadata capture device registered as video65
vivid-015: V4L2 metadata output device registered as video66
vivid-015: V4L2 touch capture device registered as v4l-touch15
vim2m vim2m.0: Device registered as /dev/video0
vicodec vicodec.0: Device 'stateful-encoder' registered as /dev/video68
vicodec vicodec.0: Device 'stateful-decoder' registered as /dev/video69
vicodec vicodec.0: Device 'stateless-decoder' registered as /dev/video70
dvbdev: DVB: registering new adapter (dvb_vidtv_bridge)
i2c i2c-0: DVB: registering adapter 0 frontend 0 (Dummy demod for DVB-T/T2/C/S/S2)...
dvbdev: dvb_create_media_entity: media entity 'Dummy demod for DVB-T/T2/C/S/S2' registered.
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
2 locks held by swapper/0/1:
 #0: ffffffff8d4acda8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
 #0: ffffffff8d4acda8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1001 [inline]
 #0: ffffffff8d4acda8 (&dev->mutex){....}-{3:3}, at: device_driver_attach+0xba/0x290 drivers/base/dd.c:1032
 #1: ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291
irq event stamp: 924846
hardirqs last  enabled at (924845): [<ffffffff89226240>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (924845): [<ffffffff89226240>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (924846): [<ffffffff81b22ff7>] __alloc_pages_bulk+0x1017/0x1870 mm/page_alloc.c:5291
softirqs last  enabled at (924628): [<ffffffff8146345e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (924628): [<ffffffff8146345e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
softirqs last disabled at (924621): [<ffffffff8146345e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (924621): [<ffffffff8146345e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9153
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5179
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
 alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 vmalloc+0x67/0x80 mm/vmalloc.c:3029
 dvb_dmx_init+0x18f/0xb90 drivers/media/dvb-core/dvb_demux.c:1257
 vidtv_bridge_dmx_init drivers/media/test-drivers/vidtv/vidtv_bridge.c:328 [inline]
 vidtv_bridge_dvb_init drivers/media/test-drivers/vidtv/vidtv_bridge.c:435 [inline]
 vidtv_bridge_probe+0x8c2/0xcb0 drivers/media/test-drivers/vidtv/vidtv_bridge.c:508
 platform_probe+0xfc/0x1f0 drivers/base/platform.c:1447
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 device_driver_attach+0x228/0x290 drivers/base/dd.c:1039
 __driver_attach+0x190/0x340 drivers/base/dd.c:1117
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:305
 bus_add_driver+0x3a9/0x630 drivers/base/bus.c:622
 driver_register+0x220/0x3a0 drivers/base/driver.c:171
 vidtv_bridge_init+0x37/0x64 drivers/media/test-drivers/vidtv/vidtv_bridge.c:596
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

============================================
WARNING: possible recursive locking detected
5.13.0-syzkaller #0 Tainted: G        W        
--------------------------------------------
swapper/0/1 is trying to acquire lock:
ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: rmqueue_pcplist mm/page_alloc.c:3675 [inline]
ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: rmqueue mm/page_alloc.c:3713 [inline]
ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: get_page_from_freelist+0x486/0x2f80 mm/page_alloc.c:4175

but task is already holding lock:
ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(lock#2);
  lock(lock#2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by swapper/0/1:
 #0: ffffffff8d4acda8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
 #0: ffffffff8d4acda8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1001 [inline]
 #0: ffffffff8d4acda8 (&dev->mutex){....}-{3:3}, at: device_driver_attach+0xba/0x290 drivers/base/dd.c:1032
 #1: ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
 rmqueue_pcplist mm/page_alloc.c:3675 [inline]
 rmqueue mm/page_alloc.c:3713 [inline]
 get_page_from_freelist+0x4aa/0x2f80 mm/page_alloc.c:4175
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5386
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
 alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 vmalloc+0x67/0x80 mm/vmalloc.c:3029
 dvb_dmx_init+0x18f/0xb90 drivers/media/dvb-core/dvb_demux.c:1257
 vidtv_bridge_dmx_init drivers/media/test-drivers/vidtv/vidtv_bridge.c:328 [inline]
 vidtv_bridge_dvb_init drivers/media/test-drivers/vidtv/vidtv_bridge.c:435 [inline]
 vidtv_bridge_probe+0x8c2/0xcb0 drivers/media/test-drivers/vidtv/vidtv_bridge.c:508
 platform_probe+0xfc/0x1f0 drivers/base/platform.c:1447
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 device_driver_attach+0x228/0x290 drivers/base/dd.c:1039
 __driver_attach+0x190/0x340 drivers/base/dd.c:1117
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:305
 bus_add_driver+0x3a9/0x630 drivers/base/bus.c:622
 driver_register+0x220/0x3a0 drivers/base/driver.c:171
 vidtv_bridge_init+0x37/0x64 drivers/media/test-drivers/vidtv/vidtv_bridge.c:596
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
vidtv vidtv.0: Successfully initialized vidtv!
usbcore: registered new interface driver radioshark
usbcore: registered new interface driver radioshark2
usbcore: registered new interface driver dsbr100
usbcore: registered new interface driver radio-si470x
usbcore: registered new interface driver radio-usb-si4713
usbcore: registered new interface driver radio-mr800
usbcore: registered new interface driver radio-keene
usbcore: registered new interface driver radio-ma901
usbcore: registered new interface driver radio-raremono
general protection fault, probably for non-canonical address 0xdffffc0000000097: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000004b8-0x00000000000004bf]
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ptp_clock_register+0x5b1/0xce0 drivers/ptp/ptp_clock.c:239
Code: 0f 85 38 06 00 00 4d 89 a7 10 01 00 00 e8 f7 9c 51 fb 49 8d bd b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 06 00 00 4d 8b bd b8 04 00 00 4d 85 ff 74 51
RSP: 0000:ffffc90000c67cc8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200018cf9f RCX: 0000000000000000
RDX: 0000000000000097 RSI: ffffffff8623e789 RDI: 00000000000004b8
RBP: ffffffff90d082a8 R08: ffff8881475d4648 R09: 0000000000000000
R10: ffffed1028ebab29 R11: 0000000000000000 R12: ffff8881475d4000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff90d082a8
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000be8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ptp_kvm_init+0xe5/0x11b drivers/ptp/ptp_kvm_common.c:148
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 8cb38d1070153f11 ]---
RIP: 0010:ptp_clock_register+0x5b1/0xce0 drivers/ptp/ptp_clock.c:239
Code: 0f 85 38 06 00 00 4d 89 a7 10 01 00 00 e8 f7 9c 51 fb 49 8d bd b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 06 00 00 4d 8b bd b8 04 00 00 4d 85 ff 74 51
RSP: 0000:ffffc90000c67cc8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200018cf9f RCX: 0000000000000000
RDX: 0000000000000097 RSI: ffffffff8623e789 RDI: 00000000000004b8
RBP: ffffffff90d082a8 R08: ffff8881475d4648 R09: 0000000000000000
R10: ffffed1028ebab29 R11: 0000000000000000 R12: ffff8881475d4000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff90d082a8
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000be8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
