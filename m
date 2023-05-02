Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444FB6F3D3F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 08:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjEBGQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 02:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjEBGQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 02:16:49 -0400
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C7630CD
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 23:16:46 -0700 (PDT)
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3312915e8bcso4478325ab.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 23:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683008206; x=1685600206;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8qYJ/nFk3TPZpHUniDOSFrcfU+Xm+GBLQPw53k5s7ok=;
        b=kvzxuUxA/D3e3r+nV0q4H38r56KOsxo7RaVFKdfHVRqHxT+810NQ29OTSKHPLodm6u
         uSz5B3ezO20xeIMDQmpc8OriI+lXWPmfegO5op48aR+554sfCQYAvaKwzJpwACRE4rma
         izP9bTWl8YnVt20o4SbsTeista5b9R262nZs0We16AWVrWgVIIHeTFPPecLeSP1+F9Xg
         sXfQVeHV83W7gQ4kJT/74YkL3e0MTbMdzIoqOaojCMR5jGhsZ25oGleG622XB2efyCoW
         gS+rppZuC9gTvFvSjBPI9X1X4paWDZTPQFg/7u+afpDXt4x9/ouMajahAEnQPKAcSZki
         i9jg==
X-Gm-Message-State: AC+VfDzwkbBFnyD3c0tZUKtbJMdKcKLjdsEd+VrR/rF6WP1uiyt0o9ZS
        iivveiBmlzESI5IJj0wjC98HVe3G25u8U9ll3wgsZJb+1suT
X-Google-Smtp-Source: ACHHUZ5A6uz4+z+0WoVCXqVXSTMWqSBAZFT5Jaxk1uu/chGivZRr/2C/0VdXsRgJdTihIgpV6XRPy4pBqDEFOU5Ao8mjC+nmar2L
MIME-Version: 1.0
X-Received: by 2002:a92:c602:0:b0:317:9096:e80f with SMTP id
 p2-20020a92c602000000b003179096e80fmr6991960ilm.4.1683008206160; Mon, 01 May
 2023 23:16:46 -0700 (PDT)
Date:   Mon, 01 May 2023 23:16:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000484a8205faafe216@google.com>
Subject: [syzbot] [bluetooth?] KASAN: slab-use-after-free Read in hci_conn_del
From:   syzbot <syzbot+690b90b14f14f43f4688@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    22b8cc3e78f5 Merge tag 'x86_mm_for_6.4' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1541e08c280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12f36d7d8f9d4b6b
dashboard link: https://syzkaller.appspot.com/bug?extid=690b90b14f14f43f4688
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ffa3731397d7/disk-22b8cc3e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/efb7f348dec2/vmlinux-22b8cc3e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/955b377bed1f/bzImage-22b8cc3e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+690b90b14f14f43f4688@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in hci_conn_del+0x8b4/0x950 net/bluetooth/hci_conn.c:1114
Read of size 8 at addr ffff8880425669c8 by task syz-executor.0/12291

CPU: 0 PID: 12291 Comm: syz-executor.0 Not tainted 6.3.0-syzkaller-10656-g22b8cc3e78f5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 hci_conn_del+0x8b4/0x950 net/bluetooth/hci_conn.c:1114
 hci_conn_hash_flush+0x1a3/0x270 net/bluetooth/hci_conn.c:2480
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4941
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2703
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:669
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad3/0x2960 kernel/exit.c:869
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
 get_signal+0x2315/0x25b0 kernel/signal.c:2874
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2018eb0e91
Code: Unable to access opcode bytes at 0x7f2018eb0e67.
RSP: 002b:00007f2019c4a0b0 EFLAGS: 00000293 ORIG_RAX: 00000000000000e6
RAX: fffffffffffffdfc RBX: 00007f2018fabf80 RCX: 00007f2018eb0e91
RDX: 00007f2019c4a0f0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f2018ee7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007ffda36ad2af R14: 00007f2019c4a300 R15: 0000000000022000
 </TASK>

Allocated by task 16102:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 hci_conn_add+0xb8/0x16b0 net/bluetooth/hci_conn.c:986
 hci_conn_request_evt+0x89a/0x9c0 net/bluetooth/hci_event.c:3308
 hci_event_func net/bluetooth/hci_event.c:7477 [inline]
 hci_event_packet+0x956/0xfd0 net/bluetooth/hci_event.c:7529
 hci_rx_work+0xaeb/0x1340 net/bluetooth/hci_core.c:4062
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Freed by task 12291:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3786 [inline]
 __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3799
 device_release+0xa3/0x240 drivers/base/core.c:2484
 kobject_cleanup lib/kobject.c:683 [inline]
 kobject_release lib/kobject.c:714 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c2/0x4d0 lib/kobject.c:731
 put_device+0x1f/0x30 drivers/base/core.c:3733
 hci_conn_del+0x1e5/0x950 net/bluetooth/hci_conn.c:1162
 hci_conn_unlink+0x2ce/0x460 net/bluetooth/hci_conn.c:1109
 hci_conn_hash_flush+0x19b/0x270 net/bluetooth/hci_conn.c:2479
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4941
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2703
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:669
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad3/0x2960 kernel/exit.c:869
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
 get_signal+0x2315/0x25b0 kernel/signal.c:2874
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 insert_work+0x48/0x350 kernel/workqueue.c:1361
 __queue_work+0x625/0x1120 kernel/workqueue.c:1524
 __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1672
 queue_delayed_work_on+0x109/0x120 kernel/workqueue.c:1708
 queue_delayed_work include/linux/workqueue.h:519 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1444 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1414 [inline]
 sco_chan_del+0x1f8/0x4f0 net/bluetooth/sco.c:169
 __sco_sock_close+0x178/0x740 net/bluetooth/sco.c:454
 sco_sock_close net/bluetooth/sco.c:469 [inline]
 sco_sock_release+0x81/0x360 net/bluetooth/sco.c:1267
 __sock_release+0xcd/0x290 net/socket.c:653
 sock_close+0x1c/0x20 net/socket.c:1397
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 get_signal+0x1c7/0x25b0 kernel/signal.c:2650
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888042566000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2504 bytes inside of
 freed 4096-byte region [ffff888042566000, ffff888042567000)

The buggy address belongs to the physical page:
page:ffffea0001095800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x42560
head:ffffea0001095800 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 11782, tgid 11777 (syz-executor.1), ts 778445749670, free_ts 774583452034
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1722
 prep_new_page mm/page_alloc.c:1729 [inline]
 get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3493
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4759
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2277
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x390 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3192
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3291
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3490
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc+0x4e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 tomoyo_realpath_from_path+0xc3/0x600 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x21a/0x570 security/tomoyo/file.c:723
 tomoyo_path_mkdir+0x9c/0xe0 security/tomoyo/tomoyo.c:178
 security_path_mkdir+0xec/0x160 security/security.c:1695
 do_mkdirat+0x14d/0x310 fs/namei.c:4058
 __do_sys_mkdirat fs/namei.c:4076 [inline]
 __se_sys_mkdirat fs/namei.c:4074 [inline]
 __x64_sys_mkdirat+0x119/0x170 fs/namei.c:4074
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2555
 free_unref_page+0x33/0x370 mm/page_alloc.c:2650
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2636
 qlink_free mm/kasan/quarantine.c:166 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3451 [inline]
 slab_alloc mm/slub.c:3459 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3466 [inline]
 kmem_cache_alloc_lru+0x20a/0x600 mm/slub.c:3482
 alloc_inode_sb include/linux/fs.h:2691 [inline]
 shmem_alloc_inode+0x27/0x50 mm/shmem.c:3907
 alloc_inode+0x61/0x230 fs/inode.c:260
 new_inode_pseudo fs/inode.c:1018 [inline]
 new_inode+0x2b/0x280 fs/inode.c:1046
 shmem_get_inode+0x1a3/0xee0 mm/shmem.c:2370
 shmem_mknod+0x66/0x220 mm/shmem.c:2942
 lookup_open.isra.0+0x105a/0x1400 fs/namei.c:3416
 open_last_lookups fs/namei.c:3484 [inline]
 path_openat+0x975/0x2750 fs/namei.c:3712
 do_filp_open+0x1ba/0x410 fs/namei.c:3742
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1356

Memory state around the buggy address:
 ffff888042566880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888042566900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888042566980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff888042566a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888042566a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
