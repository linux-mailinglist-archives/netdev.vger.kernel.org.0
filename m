Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A91632C3B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiKUSnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKUSno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:43:44 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70134C6D34
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:43:40 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id bf14-20020a056602368e00b006ce86e80414so5871356iob.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:43:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0FUJFxLBlQCBs69/0FAENpTM4j7iOUMfMikefBqpRUw=;
        b=wK2aJVKHxcX1gFE54A348oibwQm40HIWhwLTOjEmSCHxBOkyixDGZJq/dwi+EyRHjs
         wufNrwdZyymC5wV62AG2h4KizVmg5LWc9zVv69fyBL+lFCwZYXH1EzUL8kGkvTYyJej9
         0qG9esmlJGS3rw4Np8fcREBHy98WnvuVt2BDjgB4D1D9O0zJpTkW5qh5UqFjeYPrcPT/
         GLVQH8Tpcrjal94T5linqzDylm6+lqCmXCZgI1M21HIDIbYdDAzciU93utULgZnOsB/u
         6BZPkmM6dFVKSoEy5mHr9Q8iqutQuxwS1EuFdyKKa77r3hXX6X8ut1qyJoqbazxT/K+l
         dyjA==
X-Gm-Message-State: ANoB5pkS6m4fTmzOK5cdOXB5G6u0oFBE6YmOB9k5T24zRSjzuRfURdRC
        FTOOkmGBSV0WovrqJflKw57p73qODA2n95PhWNaquhXud3lM
X-Google-Smtp-Source: AA0mqf7b77Bj/XWNQmzZ87izvboC1kHE9ihLCeFu8/9F2RV1ms/Wgmt/QNWCvRjWUlbLhwILcZX9agxoh49o0A0m+cfTENrYa2pc
MIME-Version: 1.0
X-Received: by 2002:a92:cc09:0:b0:302:58d0:24fe with SMTP id
 s9-20020a92cc09000000b0030258d024femr259928ilp.79.1669056219814; Mon, 21 Nov
 2022 10:43:39 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:43:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017a21a05edff6f07@google.com>
Subject: [syzbot] WARNING: locking bug in netdev_unregister_kobject
From:   syzbot <syzbot+079faa8639c56206a713@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        wangyufen@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9500fc6e9e60 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13d5f501880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b25c9f218686dd5e
dashboard link: https://syzkaller.appspot.com/bug?extid=079faa8639c56206a713
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1363e60652f7/disk-9500fc6e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fcc4da811bb6/vmlinux-9500fc6e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b554298f1fa/Image-9500fc6e.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+079faa8639c56206a713@syzkaller.appspotmail.com

bond5 (unregistering): Released all slaves
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 3637 at kernel/locking/lockdep.c:231 check_wait_context kernel/locking/lockdep.c:4729 [inline]
WARNING: CPU: 1 PID: 3637 at kernel/locking/lockdep.c:231 __lock_acquire+0x2b0/0x3084 kernel/locking/lockdep.c:5005
Modules linked in:
CPU: 1 PID: 3637 Comm: kworker/u4:12 Not tainted 6.1.0-rc5-syzkaller-32269-g9500fc6e9e60 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: netns cleanup_net
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : check_wait_context kernel/locking/lockdep.c:4729 [inline]
pc : __lock_acquire+0x2b0/0x3084 kernel/locking/lockdep.c:5005
lr : hlock_class kernel/locking/lockdep.c:231 [inline]
lr : check_wait_context kernel/locking/lockdep.c:4729 [inline]
lr : __lock_acquire+0x298/0x3084 kernel/locking/lockdep.c:5005
sp : ffff800013ac38d0
x29: ffff800013ac39b0 x28: 0000000000000004 x27: ffff000105793520
x26: ffff000100eab228 x25: ffff000105793f28 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000001 x21: 0000000000000000
x20: 0000000000000000 x19: aac6ab555542fdfe x18: 0000000000000000
x17: 0000000000000000 x16: ffff80000dc18158 x15: ffff000105793480
x14: 0000000000000000 x13: 0000000000000012 x12: ffff80000d96cfd0
x11: ff808000081c6510 x10: ffff80000ddda198 x9 : 9396706c2ea69400
x8 : 0000000000000000 x7 : 4e5241575f534b43 x6 : ffff80000c0b2b74
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000100000001 x0 : 0000000000000016
Call trace:
 check_wait_context kernel/locking/lockdep.c:4729 [inline]
 __lock_acquire+0x2b0/0x3084 kernel/locking/lockdep.c:5005
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x54/0x6c kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:350 [inline]
 kobj_kset_leave lib/kobject.c:174 [inline]
 __kobject_del+0x9c/0x1f8 lib/kobject.c:592
 kobject_cleanup+0xfc/0x280 lib/kobject.c:664
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x94/0xf8 lib/kobject.c:721
 net_rx_queue_update_kobjects net/core/net-sysfs.c:1128 [inline]
 remove_queue_kobjects net/core/net-sysfs.c:1829 [inline]
 netdev_unregister_kobject+0x168/0x1d4 net/core/net-sysfs.c:1983
 unregister_netdevice_many+0x730/0xa0c net/core/dev.c:10874
 default_device_exit_batch+0x3c0/0x424 net/core/dev.c:11341
 ops_exit_list net/core/net_namespace.c:174 [inline]
 cleanup_net+0x3cc/0x648 net/core/net_namespace.c:601
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 8362613
hardirqs last  enabled at (8362613): [<ffff80000c0b7c04>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (8362613): [<ffff80000c0b7c04>] _raw_spin_unlock_irqrestore+0x48/0x8c kernel/locking/spinlock.c:194
hardirqs last disabled at (8362612): [<ffff80000c0b7a40>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (8362612): [<ffff80000c0b7a40>] _raw_spin_lock_irqsave+0xa4/0xb4 kernel/locking/spinlock.c:162
softirqs last  enabled at (8362594): [<ffff80000b2a05fc>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (8362594): [<ffff80000b2a05fc>] netif_addr_unlock_bh include/linux/netdevice.h:4454 [inline]
softirqs last  enabled at (8362594): [<ffff80000b2a05fc>] dev_mc_flush+0xd4/0xec net/core/dev_addr_lists.c:1036
softirqs last disabled at (8362592): [<ffff80000b2a0660>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---
Unable to handle kernel NULL pointer dereference at virtual address 00000000000000b8
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000107c45000
[00000000000000b8] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 3637 Comm: kworker/u4:12 Tainted: G        W          6.1.0-rc5-syzkaller-32269-g9500fc6e9e60 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: netns cleanup_net
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : check_wait_context kernel/locking/lockdep.c:4729 [inline]
pc : __lock_acquire+0x2d0/0x3084 kernel/locking/lockdep.c:5005
lr : hlock_class kernel/locking/lockdep.c:231 [inline]
lr : check_wait_context kernel/locking/lockdep.c:4729 [inline]
lr : __lock_acquire+0x298/0x3084 kernel/locking/lockdep.c:5005
sp : ffff800013ac38d0
x29: ffff800013ac39b0 x28: 0000000000000004 x27: ffff000105793520
x26: ffff000100eab228 x25: ffff000105793f28 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000001 x21: 0000000000000000
x20: 0000000000000000 x19: aac6ab555542fdfe x18: 0000000000000000
x17: 0000000000000000 x16: ffff80000dc18158 x15: ffff000105793480
x14: 0000000000000000 x13: 0000000000000012 x12: ffff80000d96cfd0
x11: ff808000081c6510 x10: ffff80000ddda198 x9 : 0000000000041dfe
x8 : 0000000000000000 x7 : 4e5241575f534b43 x6 : ffff80000c0b2b74
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000100000001 x0 : 0000000000000016
Call trace:
 hlock_class kernel/locking/lockdep.c:222 [inline]
 check_wait_context kernel/locking/lockdep.c:4730 [inline]
 __lock_acquire+0x2d0/0x3084 kernel/locking/lockdep.c:5005
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x54/0x6c kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:350 [inline]
 kobj_kset_leave lib/kobject.c:174 [inline]
 __kobject_del+0x9c/0x1f8 lib/kobject.c:592
 kobject_cleanup+0xfc/0x280 lib/kobject.c:664
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x94/0xf8 lib/kobject.c:721
 net_rx_queue_update_kobjects net/core/net-sysfs.c:1128 [inline]
 remove_queue_kobjects net/core/net-sysfs.c:1829 [inline]
 netdev_unregister_kobject+0x168/0x1d4 net/core/net-sysfs.c:1983
 unregister_netdevice_many+0x730/0xa0c net/core/dev.c:10874
 default_device_exit_batch+0x3c0/0x424 net/core/dev.c:11341
 ops_exit_list net/core/net_namespace.c:174 [inline]
 cleanup_net+0x3cc/0x648 net/core/net_namespace.c:601
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
Code: d002e1ca 91056210 9106614a b9400329 (3942e114) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	d002e1ca 	adrp	x10, 0x5c3a000
   4:	91056210 	add	x16, x16, #0x158
   8:	9106614a 	add	x10, x10, #0x198
   c:	b9400329 	ldr	w9, [x25]
* 10:	3942e114 	ldrb	w20, [x8, #184] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
