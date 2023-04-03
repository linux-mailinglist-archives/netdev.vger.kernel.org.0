Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288FF6D3CC9
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 07:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjDCFVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 01:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjDCFVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 01:21:52 -0400
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F94CAF1A
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 22:21:46 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id d204-20020a6bb4d5000000b00758cfdd36c3so17238358iof.0
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 22:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680499305; x=1683091305;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dv+2frttXTU3NWLfhJnBGhy7gxt5HtqKCqWM01Z2kds=;
        b=R6cCoGQPX2A2Sq7j/T/s414diUtZD7ANknfoLuwf3SmA8j2zIw1hfWb/NHc6cnpMVX
         frYLvv2s1fPZbEWPlDROYKjqfQztRgf/nNtg3Z9QTqCCpDmpvnpsf28IovohW+/aDQXx
         0LgGTKNYlE8JICvCumCnDblI/M1SNz3NYPT0K89ciBvaqaCpcwvY2dMqXQ+wiTui61Fj
         Sh8JCFzS49x79WiKnkBW4/t7ZikGtywPIRuEmL5aPFYiQLsIW/mueUXTSz2lIz62UDHu
         /r8Oezv96jpwukdWIMb+OkpvjnzdWVWZFaqH9Ar7FZ2XReRYnqAax/iDMLZ92OAAQqQo
         9DqQ==
X-Gm-Message-State: AO0yUKV/sftCeQS0b00IPuKNZ5tbQgI4SfEDoJH+42940tiNP5AIdLp9
        0Cnph1iYbRagWNNTFMdIo3tC308QYg90dQhO9t2XyeKgYJAV
X-Google-Smtp-Source: AK7set8rpnYxVU72ZUgrdonY/O885dNXCFSNOdwFsjuS0vfX0Ni7GxcjsfmYtmHdvk7EreIRtB2YjCM//wae3JkEdfd2xNAT1a4D
MIME-Version: 1.0
X-Received: by 2002:a05:6638:10ce:b0:3a9:5ec2:ef41 with SMTP id
 q14-20020a05663810ce00b003a95ec2ef41mr13159678jad.3.1680499305731; Sun, 02
 Apr 2023 22:21:45 -0700 (PDT)
Date:   Sun, 02 Apr 2023 22:21:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029dba105f867bccc@google.com>
Subject: [syzbot] [kernel?] KASAN: slab-use-after-free Write in tty_port_put
From:   syzbot <syzbot+272f2d65fb7a568dbf07@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, jirislaby@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3b064f541be8 net: hns3: support wake on lan configuration ..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1264d059c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0d03464fc6baf71
dashboard link: https://syzkaller.appspot.com/bug?extid=272f2d65fb7a568dbf07
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/188a922efb8a/disk-3b064f54.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0eb0cb154a54/vmlinux-3b064f54.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7f8063cc4a33/bzImage-3b064f54.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+272f2d65fb7a568dbf07@syzkaller.appspotmail.com

RBP: 00007f8f69d971d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe88eac02f R14: 00007f8f69d97300 R15: 0000000000022000
 </TASK>
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
BUG: KASAN: slab-use-after-free in atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:176 [inline]
BUG: KASAN: slab-use-after-free in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
BUG: KASAN: slab-use-after-free in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
BUG: KASAN: slab-use-after-free in refcount_dec_and_test include/linux/refcount.h:333 [inline]
BUG: KASAN: slab-use-after-free in kref_put include/linux/kref.h:64 [inline]
BUG: KASAN: slab-use-after-free in tty_port_put+0x33/0x1c0 drivers/tty/tty_port.c:311
Write of size 4 at addr ffff88807abfa38c by task syz-executor.1/17298

CPU: 0 PID: 17298 Comm: syz-executor.1 Not tainted 6.3.0-rc3-syzkaller-00882-g3b064f541be8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
 print_report mm/kasan/report.c:430 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:536
 check_region_inline mm/kasan/generic.c:181 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:187
 instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
 atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:176 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 kref_put include/linux/kref.h:64 [inline]
 tty_port_put+0x33/0x1c0 drivers/tty/tty_port.c:311
 rfcomm_get_dev_info net/bluetooth/rfcomm/tty.c:577 [inline]
 rfcomm_dev_ioctl+0x431/0x1c00 net/bluetooth/rfcomm/tty.c:596
 rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
 sock_do_ioctl+0xcc/0x230 net/socket.c:1199
 sock_ioctl+0x1f8/0x680 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f8f6908c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8f69d97168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f8f691abf80 RCX: 00007f8f6908c0f9
RDX: 0000000020000100 RSI: 00000000800452d3 RDI: 0000000000000004
RBP: 00007f8f69d971d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe88eac02f R14: 00007f8f69d97300 R15: 0000000000022000
 </TASK>

Allocated by task 17287:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 __rfcomm_dev_add net/bluetooth/rfcomm/tty.c:224 [inline]
 rfcomm_dev_add net/bluetooth/rfcomm/tty.c:325 [inline]
 __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:424 [inline]
 rfcomm_create_dev net/bluetooth/rfcomm/tty.c:485 [inline]
 rfcomm_dev_ioctl+0x9f2/0x1c00 net/bluetooth/rfcomm/tty.c:587
 rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
 sock_do_ioctl+0xcc/0x230 net/socket.c:1199
 sock_ioctl+0x1f8/0x680 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 17291:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3800
 rfcomm_dev_destruct+0x2b3/0x3a0 net/bluetooth/rfcomm/tty.c:102
 tty_port_destructor drivers/tty/tty_port.c:296 [inline]
 kref_put include/linux/kref.h:65 [inline]
 tty_port_put+0x15c/0x1c0 drivers/tty/tty_port.c:311
 __rfcomm_release_dev net/bluetooth/rfcomm/tty.c:476 [inline]
 rfcomm_release_dev net/bluetooth/rfcomm/tty.c:496 [inline]
 rfcomm_dev_ioctl+0x27d/0x1c00 net/bluetooth/rfcomm/tty.c:590
 rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
 sock_do_ioctl+0xcc/0x230 net/socket.c:1199
 sock_ioctl+0x1f8/0x680 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 __call_rcu_common.constprop.0+0x99/0x7e0 kernel/rcu/tree.c:2622
 netlink_release+0xcde/0x1e40 net/netlink/af_netlink.c:828
 __sock_release+0xcd/0x290 net/socket.c:653
 sock_close+0x1c/0x20 net/socket.c:1395
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 __call_rcu_common.constprop.0+0x99/0x7e0 kernel/rcu/tree.c:2622
 netlink_release+0xcde/0x1e40 net/netlink/af_netlink.c:828
 __sock_release+0xcd/0x290 net/socket.c:653
 sock_close+0x1c/0x20 net/socket.c:1395
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807abfa000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 908 bytes inside of
 freed 2048-byte region [ffff88807abfa000, ffff88807abfa800)

The buggy address belongs to the physical page:
page:ffffea0001eafe00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7abf8
head:ffffea0001eafe00 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012442000 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 7933, tgid 7930 (syz-executor.1), ts 219784968500, free_ts 217797582270
 prep_new_page mm/page_alloc.c:2552 [inline]
 get_page_from_freelist+0x1190/0x2e20 mm/page_alloc.c:4325
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:5591
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2283
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x390 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3491
 kmalloc_trace+0x26/0xe0 mm/slab_common.c:1061
 kmalloc include/linux/slab.h:580 [inline]
 rtnl_newlink+0x4a/0xa0 net/core/rtnetlink.c:3669
 rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6388
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2572
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1453 [inline]
 free_pcp_prepare+0x5d5/0xa50 mm/page_alloc.c:1503
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:769 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 kmem_cache_alloc_node+0x185/0x3e0 mm/slub.c:3497
 __alloc_skb+0x288/0x330 net/core/skbuff.c:594
 alloc_skb include/linux/skbuff.h:1269 [inline]
 nlmsg_new include/net/netlink.h:1003 [inline]
 inet_netconf_notify_devconf+0xe1/0x260 net/ipv4/devinet.c:2105
 __devinet_sysctl_unregister net/ipv4/devinet.c:2617 [inline]
 devinet_sysctl_unregister net/ipv4/devinet.c:2641 [inline]
 inetdev_destroy net/ipv4/devinet.c:328 [inline]
 inetdev_event+0x10c3/0x1720 net/ipv4/devinet.c:1606
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1937
 call_netdevice_notifiers_extack net/core/dev.c:1975 [inline]
 call_netdevice_notifiers net/core/dev.c:1989 [inline]
 unregister_netdevice_many_notify+0x77c/0x1910 net/core/dev.c:10843
 ip6gre_exit_batch_net+0x3ea/0x580 net/ipv6/ip6_gre.c:1639
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613

Memory state around the buggy address:
 ffff88807abfa280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807abfa300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807abfa380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88807abfa400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807abfa480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
