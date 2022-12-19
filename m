Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D6A650905
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiLSJEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiLSJDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:03:47 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F095AE73
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 01:03:44 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id h9-20020a92c269000000b00303494c4f3eso6227600ild.15
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 01:03:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UAyGf4Gs25uUB1w5QOh9WZNvjL4tMuXUES7atWLY7d4=;
        b=Z3iScac+fXRoCgZ7UIcPtXAhO+vzQJORF27Tumg978nMJ4LYzpkJ0f5tg6EwCBE9iR
         MHDNRGS8QlcfgL79YJy5ROcOXbsoQJW1NWe8Ji+DUm/lprekwPF6C95B1YaKWqEDMh2r
         uf9JdfUEsrcougLgYXwxda0YA43EvQvV/yb7xGDuxoJKxeE61OcZQH80+0pR0d6r7ifN
         K1EobfMKNmb1KbJVLWGhErefjEZpVwlSk7jaFDN2nhg7Oc1I/cOZXB2ifnLoAHPJmPdc
         2DoxKEGFyWkp6p73MLfDgG19Fk8xmdpyLQdn0gDEXCbYtHqt1f/ITGIG4Ge7sS3HOD30
         i+bA==
X-Gm-Message-State: AFqh2koZZ/7u5q9rzXxL5LhNSbCXzvYuI8UKMR+VIQS8x+370IXrku2w
        LJW94pNAAk48tVA6OhAXP73BwjA2u/N1eU4BbuE32bn3PXHj
X-Google-Smtp-Source: AMrXdXumXSeDtvtIgSf+iXu+i534pUA38D68nYdfZ1x6RZPGBjxRBM7AtSJhAKVXAbj05BTet2bZuV3QXD7xswNcMSAW9mWSb64e
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4902:b0:392:35f3:1ae6 with SMTP id
 cx2-20020a056638490200b0039235f31ae6mr624258jab.285.1671440623696; Mon, 19
 Dec 2022 01:03:43 -0800 (PST)
Date:   Mon, 19 Dec 2022 01:03:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3801d05f02a9826@google.com>
Subject: [syzbot] KASAN: use-after-free Read in aa_label_sk_perm
From:   syzbot <syzbot+276237fb1679fa55a29b@syzkaller.appspotmail.com>
To:     apparmor@lists.ubuntu.com, jmorris@namei.org,
        john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, serge@hallyn.com,
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

HEAD commit:    7e68dd7d07a2 Merge tag 'net-next-6.2' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12d5b793880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=276237fb1679fa55a29b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3e9423c78657/disk-7e68dd7d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3844318fc016/vmlinux-7e68dd7d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b47aaab121f4/bzImage-7e68dd7d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+276237fb1679fa55a29b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in aa_label_sk_perm+0x4ec/0x530 security/apparmor/net.c:148
Read of size 8 at addr ffff88804a765480 by task syz-executor.5/12994

CPU: 0 PID: 12994 Comm: syz-executor.5 Not tainted 6.1.0-syzkaller-07445-g7e68dd7d07a2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 aa_label_sk_perm+0x4ec/0x530 security/apparmor/net.c:148
 aa_sk_perm+0x1e9/0xab0 security/apparmor/net.c:175
 security_socket_recvmsg+0x60/0xc0 security/security.c:2311
 sock_recvmsg net/socket.c:1011 [inline]
 ____sys_recvmsg+0x23b/0x610 net/socket.c:2695
 ___sys_recvmsg+0xf2/0x180 net/socket.c:2737
 do_recvmmsg+0x25e/0x6e0 net/socket.c:2831
 __sys_recvmmsg net/socket.c:2910 [inline]
 __do_sys_recvmmsg net/socket.c:2933 [inline]
 __se_sys_recvmmsg net/socket.c:2926 [inline]
 __x64_sys_recvmmsg+0x20f/0x260 net/socket.c:2926
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f26e788c0d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f26e85c3168 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007f26e79ac2c0 RCX: 00007f26e788c0d9
RDX: 00000000000005dd RSI: 0000000020000540 RDI: 0000000000000004
RBP: 00007f26e78e7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000040012062 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc7c633f2f R14: 00007f26e85c3300 R15: 0000000000022000
 </TASK>

Allocated by task 12989:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slab_common.c:968 [inline]
 __kmalloc+0x5a/0xd0 mm/slab_common.c:981
 kmalloc include/linux/slab.h:584 [inline]
 sk_prot_alloc+0x140/0x290 net/core/sock.c:2038
 sk_alloc+0x3a/0x7a0 net/core/sock.c:2091
 nr_create+0xb6/0x5f0 net/netrom/af_netrom.c:433
 __sock_create+0x359/0x790 net/socket.c:1515
 sock_create net/socket.c:1566 [inline]
 __sys_socket_create net/socket.c:1603 [inline]
 __sys_socket_create net/socket.c:1588 [inline]
 __sys_socket+0x133/0x250 net/socket.c:1636
 __do_sys_socket net/socket.c:1649 [inline]
 __se_sys_socket net/socket.c:1647 [inline]
 __x64_sys_socket+0x73/0xb0 net/socket.c:1647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 9738:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
 sk_prot_free net/core/sock.c:2074 [inline]
 __sk_destruct+0x5df/0x750 net/core/sock.c:2166
 sk_destruct net/core/sock.c:2181 [inline]
 __sk_free+0x175/0x460 net/core/sock.c:2192
 sk_free+0x7c/0xa0 net/core/sock.c:2203
 sock_put include/net/sock.h:1987 [inline]
 nr_heartbeat_expiry+0x1d7/0x460 net/netrom/nr_timer.c:148
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1700
 expire_timers+0x2c6/0x5c0 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x820 kernel/rcu/tree.c:2753
 netlink_release+0xdcb/0x1e60 net/netlink/af_netlink.c:826
 __sock_release net/socket.c:650 [inline]
 sock_release+0x8b/0x1b0 net/socket.c:678
 netlink_kernel_release+0x4f/0x60 net/netlink/af_netlink.c:2118
 nfnetlink_net_exit_batch+0x112/0x320 net/netfilter/nfnetlink.c:782
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:606
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x820 kernel/rcu/tree.c:2753
 netlink_release+0xdcb/0x1e60 net/netlink/af_netlink.c:826
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88804a765000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1152 bytes inside of
 2048-byte region [ffff88804a765000, ffff88804a765800)

The buggy address belongs to the physical page:
page:ffffea000129d800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4a760
head:ffffea000129d800 order:3 compound_mapcount:0 compound_pincount:0
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012442000 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5354, tgid 5354 (syz-executor.3), ts 142357401536, free_ts 13035931763
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0xe9/0x310 net/core/skbuff.c:565
 alloc_skb include/linux/skbuff.h:1270 [inline]
 nlmsg_new include/net/netlink.h:1002 [inline]
 inet6_ifinfo_notify+0x76/0x150 net/ipv6/addrconf.c:6047
 addrconf_notify+0x4c5/0x1c80 net/ipv6/addrconf.c:3657
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 __dev_notify_flags+0x120/0x2d0 net/core/dev.c:8569
 dev_change_flags+0x11b/0x170 net/core/dev.c:8607
 do_setlink+0x9f1/0x3bb0 net/core/rtnetlink.c:2827
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x4d0 mm/page_alloc.c:3483
 free_contig_range+0xb5/0x180 mm/page_alloc.c:9496
 destroy_args+0xa8/0x64c mm/debug_vm_pgtable.c:1031
 debug_vm_pgtable+0x2958/0x29e9 mm/debug_vm_pgtable.c:1354
 do_one_initcall+0x141/0x790 init/main.c:1306
 do_initcall_level init/main.c:1379 [inline]
 do_initcalls init/main.c:1395 [inline]
 do_basic_setup init/main.c:1414 [inline]
 kernel_init_freeable+0x6f9/0x782 init/main.c:1634
 kernel_init+0x1e/0x1d0 init/main.c:1522
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Memory state around the buggy address:
 ffff88804a765380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804a765400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88804a765480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88804a765500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804a765580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
