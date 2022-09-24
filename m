Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B275E8764
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiIXCXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiIXCXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:23:48 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3B2137E41
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 19:23:46 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id l84-20020a6b3e57000000b006a3fe90910cso960846ioa.16
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 19:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=iz4SpeekBIJ6mcUOFkDpRdMn//fGtHsOE2OkYsfPsek=;
        b=8HKF8udIwrV6lAUq7cga6lApCKqz1wvwfrwULJSy3ZVecm9EGUxwqIxgRXPHOQTLX0
         s44DPPWsl0kixYBEkQhcTGiNyJGnjm617K7I4UpYLOb6faFDXt1QNxJ0FTTvIpMHGMU2
         xfnq6RvHP46cailmPLk1CAzkB1pRz5cJozpFKKGBEp/UER0pY1mut2eTT2fl45ntWiGh
         MpOblaxO7h7XyQDu0LwtlkrMnX/U0ctgObXPHeRgG4+SG3y71KUXfr34bWBsSBvXtDxd
         y4gYBo9qblvRH+HDd0rZYxh+o1Q42F85KZ7p478qDNzLQjcx+NLuntFUD1muJatAWKO2
         gK4Q==
X-Gm-Message-State: ACrzQf3/3PuowPlKS5jjL/cGs6UqvuxhWvomTu8nSThyC9JLXnfwVpPj
        dj8U86C2/Fn1gp+iaYhcEr6eHvO3WIQTSKyBAeR9pw+sqHkE
X-Google-Smtp-Source: AMsMyM5IWqDUjjDRCdW9oAhx3pIQH0OOqSZwx+upe3hNKoDhLGdsWgR57SzDDevsc3kXgl/wpNyeHGsgqqBIGFh70ouM2emRoE4r
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aaa:b0:2f0:2408:40cb with SMTP id
 l10-20020a056e021aaa00b002f0240840cbmr5606556ilv.45.1663986225921; Fri, 23
 Sep 2022 19:23:45 -0700 (PDT)
Date:   Fri, 23 Sep 2022 19:23:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e848fb05e962fb56@google.com>
Subject: [syzbot] WARNING: held lock freed in l2cap_conn_del
From:   syzbot <syzbot+f5f14f5e9e2df9920b98@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    1707c39ae309 Merge tag 'driver-core-6.0-rc7' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e55cdf080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=122d7bd4fc8e0ecb
dashboard link: https://syzkaller.appspot.com/bug?extid=f5f14f5e9e2df9920b98
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f5f14f5e9e2df9920b98@syzkaller.appspotmail.com

Bluetooth: hci5: hardware error 0x00
=========================
WARNING: held lock freed!
6.0.0-rc6-syzkaller-00281-g1707c39ae309 #0 Not tainted
-------------------------
kworker/u5:2/3640 is freeing memory ffff88807d9da000-ffff88807d9da7ff, with a lock still held there!
ffff88807d9da520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_chan_lock include/net/bluetooth/l2cap.h:855 [inline]
ffff88807d9da520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_conn_del+0x3b5/0x7b0 net/bluetooth/l2cap_core.c:1920
7 locks held by kworker/u5:2/3640:
 #0: ffff88807be9a938 ((wq_completion)hci5){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88807be9a938 ((wq_completion)hci5){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88807be9a938 ((wq_completion)hci5){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88807be9a938 ((wq_completion)hci5){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88807be9a938 ((wq_completion)hci5){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88807be9a938 ((wq_completion)hci5){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90003d2fda8 ((work_completion)(&hdev->error_reset)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff888077cd4fd0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x25/0x70 net/bluetooth/hci_core.c:552
 #3: ffff888077cd4078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_close_sync+0x268/0x1130 net/bluetooth/hci_sync.c:4463
 #4: ffffffff8d9d3e28 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1776 [inline]
 #4: ffffffff8d9d3e28 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0xd5/0x260 net/bluetooth/hci_conn.c:2366
 #5: ffff8880207a42d8 (&conn->chan_lock){+.+.}-{3:3}, at: l2cap_conn_del+0x2ef/0x7b0 net/bluetooth/l2cap_core.c:1915
 #6: ffff88807d9da520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_chan_lock include/net/bluetooth/l2cap.h:855 [inline]
 #6: ffff88807d9da520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_conn_del+0x3b5/0x7b0 net/bluetooth/l2cap_core.c:1920

stack backtrace:
CPU: 0 PID: 3640 Comm: kworker/u5:2 Not tainted 6.0.0-rc6-syzkaller-00281-g1707c39ae309 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Workqueue: hci5 hci_error_reset
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_freed_lock_bug kernel/locking/lockdep.c:6422 [inline]
 debug_check_no_locks_freed.cold+0x9d/0xa9 kernel/locking/lockdep.c:6455
 slab_free_hook mm/slub.c:1731 [inline]
 slab_free_freelist_hook+0x73/0x1c0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xe2/0x580 mm/slub.c:4567
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:503 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x22a/0x2d0 net/bluetooth/l2cap_core.c:527
 l2cap_conn_del+0x3fc/0x7b0 net/bluetooth/l2cap_core.c:1924
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8212 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x96/0x130 net/bluetooth/hci_core.c:1050
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/linux/atomic/atomic-instrumented.h:1265 [inline]
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0xa6/0x5e0 kernel/locking/mutex.c:916
Read of size 8 at addr ffff88807d9da4b8 by task kworker/u5:2/3640

CPU: 0 PID: 3640 Comm: kworker/u5:2 Not tainted 6.0.0-rc6-syzkaller-00281-g1707c39ae309 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Workqueue: hci5 hci_error_reset
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:1265 [inline]
 __mutex_unlock_slowpath+0xa6/0x5e0 kernel/locking/mutex.c:916
 l2cap_chan_unlock include/net/bluetooth/l2cap.h:860 [inline]
 l2cap_conn_del+0x404/0x7b0 net/bluetooth/l2cap_core.c:1926
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8212 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x96/0x130 net/bluetooth/hci_core.c:1050
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 3641:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 l2cap_chan_create+0x40/0x570 net/bluetooth/l2cap_core.c:463
 a2mp_chan_open net/bluetooth/a2mp.c:771 [inline]
 amp_mgr_create+0x8f/0x960 net/bluetooth/a2mp.c:862
 a2mp_channel_create+0x7d/0x150 net/bluetooth/a2mp.c:894
 l2cap_data_channel net/bluetooth/l2cap_core.c:7569 [inline]
 l2cap_recv_frame+0x48e3/0x8d90 net/bluetooth/l2cap_core.c:7724
 l2cap_recv_acldata+0xaa6/0xc00 net/bluetooth/l2cap_core.c:8429
 hci_acldata_packet net/bluetooth/hci_core.c:3777 [inline]
 hci_rx_work+0x705/0x1230 net/bluetooth/hci_core.c:4012
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Freed by task 3640:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:367 [inline]
 ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xe2/0x580 mm/slub.c:4567
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:503 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x22a/0x2d0 net/bluetooth/l2cap_core.c:527
 l2cap_conn_del+0x3fc/0x7b0 net/bluetooth/l2cap_core.c:1924
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8212 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x96/0x130 net/bluetooth/hci_core.c:1050
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
 qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1083
 shutdown_scheduler_queue net/sched/sch_generic.c:1136 [inline]
 netdev_for_each_tx_queue include/linux/netdevice.h:2437 [inline]
 dev_shutdown+0x11a/0x520 net/sched/sch_generic.c:1468
 unregister_netdevice_many+0x907/0x1980 net/core/dev.c:10853
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10793
 unregister_netdevice include/linux/netdevice.h:3032 [inline]
 __tun_detach+0x111d/0x1480 drivers/net/tun.c:684
 tun_detach drivers/net/tun.c:701 [inline]
 tun_chr_close+0xc4/0x180 drivers/net/tun.c:3455
 __fput+0x277/0x9d0 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad5/0x29b0 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 get_signal+0x238c/0x2610 kernel/signal.c:2857
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807d9da000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1208 bytes inside of
 2048-byte region [ffff88807d9da000, ffff88807d9da800)

The buggy address belongs to the physical page:
page:ffffea0001f67600 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807d9dd000 pfn:0x7d9d8
head:ffffea0001f67600 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0000848e08 ffffea0001ef0a08 ffff888011842000
raw: ffff88807d9dd000 0000000000080003 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 3711, tgid 3711 (syz-executor.5), ts 145774079788, free_ts 145768624011
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
 __alloc_pages_node include/linux/gfp.h:243 [inline]
 alloc_slab_page mm/slub.c:1831 [inline]
 allocate_slab+0x80/0x3d0 mm/slub.c:1974
 new_slab mm/slub.c:2034 [inline]
 ___slab_alloc+0x7f1/0xe10 mm/slub.c:3036
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3123
 slab_alloc_node mm/slub.c:3214 [inline]
 kmem_cache_alloc_node_trace+0x185/0x410 mm/slub.c:3312
 kmalloc_node include/linux/slab.h:618 [inline]
 kzalloc_node include/linux/slab.h:744 [inline]
 alloc_mem_cgroup_per_node_info mm/memcontrol.c:5132 [inline]
 mem_cgroup_alloc mm/memcontrol.c:5201 [inline]
 mem_cgroup_css_alloc+0x1d9/0x14e0 mm/memcontrol.c:5245
 css_create kernel/cgroup/cgroup.c:5384 [inline]
 cgroup_apply_control_enable+0x4b8/0xc00 kernel/cgroup/cgroup.c:3204
 cgroup_mkdir+0x5ba/0x12f0 kernel/cgroup/cgroup.c:5602
 kernfs_iop_mkdir+0x146/0x1d0 fs/kernfs/dir.c:1185
 vfs_mkdir+0x489/0x740 fs/namei.c:4013
 do_mkdirat+0x28c/0x310 fs/namei.c:4038
 __do_sys_mkdirat fs/namei.c:4053 [inline]
 __se_sys_mkdirat fs/namei.c:4051 [inline]
 __x64_sys_mkdirat+0x115/0x170 fs/namei.c:4051
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slub.c:3248 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 __kmalloc+0x28a/0x340 mm/slub.c:4425
 kmalloc include/linux/slab.h:605 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path2_perm+0x316/0x6b0 security/tomoyo/file.c:923
 security_sb_pivotroot+0x48/0xa0 security/security.c:987
 __do_sys_pivot_root+0x1f9/0x1610 fs/namespace.c:3889
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88807d9da380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d9da400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807d9da480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff88807d9da500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d9da580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
