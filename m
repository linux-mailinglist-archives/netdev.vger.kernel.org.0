Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A826F2A23
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjD3SBr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 30 Apr 2023 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjD3SBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:01:46 -0400
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFCD1997
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 11:01:44 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7606d443ba6so103024439f.1
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 11:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682877704; x=1685469704;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDadGBrC8cYrhfxlw1DsFXrsWwTIvAjBIzbIM/mQs/M=;
        b=gvei7jyQO5keWMgx9etateI9jcJipMozQF6rtnTTGBpLHfIGhOJWKmr00XT9m0zQNC
         8uwYt2GgTHZtLnOcEGhJ6+FD4v74bx2+rPYmR/nRjf+WQzIBu0IY5e4cvhGBjA5oAuxq
         PSNsbkp0/2GcX6DlwDZbj/FITWBErVQYqOc6qkXHClgxKBL6JDvSUTdg0k/tLThKLmzL
         /uuK5zdyjh4KcntdURIdJEmBitYBu7g4DOFvqyR+eGPrk7Gqg1DhifcMcEQtMvX7B1uH
         LYJahT0j2SCsnTXSFi/L5LxrKkRmrQz/jL5oKamNWhjdIk0Y1wmYU6UhlgskoW8q2Q7y
         jB/g==
X-Gm-Message-State: AC+VfDwmkrRJCWdHEo69Y1FovlNoyhj1ZqC6KIgvLYqZcWzboOMm+62h
        4qR26i73/C0mW7I/tXluduahPn93SL7byXPxa+3GMSlove7+
X-Google-Smtp-Source: ACHHUZ4cpptT4WoTeCHlao2nrLWLXHqT+9TWwLzobimGNZwpHfYgB5QUEVtCIkuuzl8c9ofRK7qSnvHWlIJEQtwEN+xH3UDDTwvk
MIME-Version: 1.0
X-Received: by 2002:a05:6602:12:b0:766:4630:3268 with SMTP id
 b18-20020a056602001200b0076646303268mr5270883ioa.1.1682877704087; Sun, 30 Apr
 2023 11:01:44 -0700 (PDT)
Date:   Sun, 30 Apr 2023 11:01:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0b11d05fa917fe3@google.com>
Subject: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in enqueue_timer
From:   syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    825a0714d2b3 Merge tag 'efi-next-for-v6.4' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f56dc8280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ecbb03c21601216
dashboard link: https://syzkaller.appspot.com/bug?extid=c2775460db0e1c70018e
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/93b1af100ee7/disk-825a0714.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3579f310db81/vmlinux-825a0714.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0bd9cec144b8/bzImage-825a0714.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in hlist_add_head include/linux/list.h:945 [inline]
BUG: KASAN: slab-use-after-free in enqueue_timer+0xad/0x560 kernel/time/timer.c:605
Write of size 8 at addr ffff88801ecc1500 by task kworker/0:11/5405

CPU: 0 PID: 5405 Comm: kworker/0:11 Not tainted 6.3.0-syzkaller-11733-g825a0714d2b3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Workqueue: wg-crypt-wg1 wg_packet_decrypt_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:351 [inline]
 print_report+0x163/0x540 mm/kasan/report.c:462
 kasan_report+0x176/0x1b0 mm/kasan/report.c:572
 hlist_add_head include/linux/list.h:945 [inline]
 enqueue_timer+0xad/0x560 kernel/time/timer.c:605
 internal_add_timer kernel/time/timer.c:634 [inline]
 __mod_timer+0xa76/0xf40 kernel/time/timer.c:1131
 mod_peer_timer+0x158/0x220 drivers/net/wireguard/timers.c:37
 wg_packet_consume_data_done drivers/net/wireguard/receive.c:354 [inline]
 wg_packet_rx_poll+0xd9e/0x2250 drivers/net/wireguard/receive.c:474
 __napi_poll+0xc7/0x470 net/core/dev.c:6496
 napi_poll net/core/dev.c:6563 [inline]
 net_rx_action+0x78b/0x1010 net/core/dev.c:6696
 __do_softirq+0x2ab/0x908 kernel/softirq.c:571
 do_softirq+0x166/0x250 kernel/softirq.c:472
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x1b5/0x1f0 kernel/softirq.c:396
 spin_unlock_bh include/linux/spinlock.h:395 [inline]
 ptr_ring_consume_bh include/linux/ptr_ring.h:367 [inline]
 wg_packet_decrypt_worker+0xd40/0xde0 drivers/net/wireguard/receive.c:499
 process_one_work+0x8a0/0x10e0 kernel/workqueue.c:2405
 worker_thread+0xa63/0x1210 kernel/workqueue.c:2552
 kthread+0x2b8/0x350 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 16792:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4f/0x70 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc_node+0xb8/0x230 mm/slab_common.c:973
 kmalloc_node include/linux/slab.h:579 [inline]
 kvmalloc_node+0x72/0x180 mm/util.c:604
 kvmalloc include/linux/slab.h:697 [inline]
 kvzalloc include/linux/slab.h:705 [inline]
 alloc_netdev_mqs+0x89/0xf30 net/core/dev.c:10626
 rtnl_create_link+0x2f7/0xc00 net/core/rtnetlink.c:3315
 rtnl_newlink_create net/core/rtnetlink.c:3433 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3660 [inline]
 rtnl_newlink+0x1379/0x2010 net/core/rtnetlink.c:3673
 rtnetlink_rcv_msg+0x825/0xf40 net/core/rtnetlink.c:6395
 netlink_rcv_skb+0x1df/0x430 net/netlink/af_netlink.c:2546
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x7c3/0x990 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0xa2a/0xd60 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 __sys_sendto+0x475/0x630 net/socket.c:2144
 __do_sys_sendto net/socket.c:2156 [inline]
 __se_sys_sendto net/socket.c:2152 [inline]
 __x64_sys_sendto+0xde/0xf0 net/socket.c:2152
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 41:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4f/0x70 mm/kasan/common.c:52
 kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free+0xd6/0x120 mm/kasan/common.c:236
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook mm/slub.c:1807 [inline]
 slab_free mm/slub.c:3786 [inline]
 __kmem_cache_free+0x264/0x3c0 mm/slub.c:3799
 device_release+0x95/0x1c0
 kobject_cleanup lib/kobject.c:683 [inline]
 kobject_release lib/kobject.c:714 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x228/0x470 lib/kobject.c:731
 netdev_run_todo+0xe5a/0xf50 net/core/dev.c:10400
 default_device_exit_batch+0x5c9/0x630 net/core/dev.c:11392
 ops_exit_list net/core/net_namespace.c:175 [inline]
 cleanup_net+0x767/0xb80 net/core/net_namespace.c:614
 process_one_work+0x8a0/0x10e0 kernel/workqueue.c:2405
 worker_thread+0xa63/0x1210 kernel/workqueue.c:2552
 kthread+0x2b8/0x350 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xb0/0xc0 mm/kasan/generic.c:491
 insert_work+0x54/0x3d0 kernel/workqueue.c:1365
 __queue_work+0xb37/0xf10 kernel/workqueue.c:1526
 call_timer_fn+0x178/0x580 kernel/time/timer.c:1700
 expire_timers kernel/time/timer.c:1746 [inline]
 __run_timers+0x67a/0x860 kernel/time/timer.c:2022
 run_timer_softirq+0x67/0xf0 kernel/time/timer.c:2035
 __do_softirq+0x2ab/0x908 kernel/softirq.c:571

Second to last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xb0/0xc0 mm/kasan/generic.c:491
 insert_work+0x54/0x3d0 kernel/workqueue.c:1365
 __queue_work+0xb37/0xf10 kernel/workqueue.c:1526
 call_timer_fn+0x178/0x580 kernel/time/timer.c:1700
 expire_timers kernel/time/timer.c:1746 [inline]
 __run_timers+0x67a/0x860 kernel/time/timer.c:2022
 run_timer_softirq+0x67/0xf0 kernel/time/timer.c:2035
 __do_softirq+0x2ab/0x908 kernel/softirq.c:571

The buggy address belongs to the object at ffff88801ecc0000
 which belongs to the cache kmalloc-cg-8k of size 8192
The buggy address is located 5376 bytes inside of
 freed 8192-byte region [ffff88801ecc0000, ffff88801ecc2000)

The buggy address belongs to the physical page:
page:ffffea00007b3000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ecc0
head:ffffea00007b3000 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88807621e8c1
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff88801244f640 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000020002 00000001ffffffff ffff88807621e8c1
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d60c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 16792, tgid 16792 (syz-executor.2), ts 506275782663, free_ts 506274493341
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x1e6/0x210 mm/page_alloc.c:1722
 prep_new_page mm/page_alloc.c:1729 [inline]
 get_page_from_freelist+0x321c/0x33a0 mm/page_alloc.c:3493
 __alloc_pages+0x255/0x670 mm/page_alloc.c:4759
 alloc_slab_page+0x6a/0x160 mm/slub.c:1851
 allocate_slab mm/slub.c:1998 [inline]
 new_slab+0x84/0x2f0 mm/slub.c:2051
 ___slab_alloc+0xa85/0x10a0 mm/slub.c:3192
 __slab_alloc mm/slub.c:3291 [inline]
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 __kmem_cache_alloc_node+0x1b8/0x290 mm/slub.c:3490
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc_node+0xa7/0x230 mm/slab_common.c:973
 kmalloc_node include/linux/slab.h:579 [inline]
 kvmalloc_node+0x72/0x180 mm/util.c:604
 kvmalloc include/linux/slab.h:697 [inline]
 kvzalloc include/linux/slab.h:705 [inline]
 alloc_netdev_mqs+0x89/0xf30 net/core/dev.c:10626
 rtnl_create_link+0x2f7/0xc00 net/core/rtnetlink.c:3315
 rtnl_newlink_create net/core/rtnetlink.c:3433 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3660 [inline]
 rtnl_newlink+0x1379/0x2010 net/core/rtnetlink.c:3673
 rtnetlink_rcv_msg+0x825/0xf40 net/core/rtnetlink.c:6395
 netlink_rcv_skb+0x1df/0x430 net/netlink/af_netlink.c:2546
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x7c3/0x990 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0xa2a/0xd60 net/netlink/af_netlink.c:1913
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x903/0xa30 mm/page_alloc.c:2555
 free_unref_page+0x37/0x3f0 mm/page_alloc.c:2650
 qlist_free_all+0x22/0x60 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x14b/0x160 mm/kasan/quarantine.c:292
 ____kasan_kmalloc mm/kasan/common.c:340 [inline]
 __kasan_kmalloc+0x23/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 ref_tracker_alloc+0x140/0x470 lib/ref_tracker.c:85
 register_netdevice+0x110b/0x1790 net/core/dev.c:10105
 ipcaif_newlink+0x1f0/0x4c0 net/caif/chnl_net.c:452
 rtnl_newlink_create net/core/rtnetlink.c:3443 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3660 [inline]
 rtnl_newlink+0x1468/0x2010 net/core/rtnetlink.c:3673
 rtnetlink_rcv_msg+0x825/0xf40 net/core/rtnetlink.c:6395
 netlink_rcv_skb+0x1df/0x430 net/netlink/af_netlink.c:2546
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x7c3/0x990 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0xa2a/0xd60 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 __sys_sendto+0x475/0x630 net/socket.c:2144
 __do_sys_sendto net/socket.c:2156 [inline]
 __se_sys_sendto net/socket.c:2152 [inline]
 __x64_sys_sendto+0xde/0xf0 net/socket.c:2152
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80

Memory state around the buggy address:
 ffff88801ecc1400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801ecc1480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801ecc1500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801ecc1580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801ecc1600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
