Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ABE5839FC
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiG1IFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiG1IFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:05:23 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1E86360
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:05:22 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id f18-20020a5d8592000000b0067289239d1dso223887ioj.22
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MilBYLzl1oiVaCjX6vP7vovoF2bfQnbPUFkg0suYOP0=;
        b=F8G7jj+uAne26T0AhN/F69ItKYyr6uoyf/Vng9d56kTlLFRpNw4XUUoMgsOA8CrMrk
         V9Pqhca6JSo2g4iy63sjnMb+H9U52wU/zPOhioFF5AZol2YE9Crb/F94RIRsqwPA/d3d
         g78RTglO5icBDPvVfI6u8b/WxHsx/UmXXunHJ3xz9rWlTSSx61VRoO4UegzMl3lkDlJO
         yxxTqho7L7/21iJ2Rd9FtIf13apj/RwJQapyzvbUumd4mFhYTcYj5W6L8MPJLjxxneF4
         vI9zK7rcA4xj65L/CICUZKarqI+Wmc5Dnn3zBBqZ2nHgjo2hlHI21lIw43cPGQBQqTiy
         FsrA==
X-Gm-Message-State: AJIora+D87GqEFzGw4D3qugEEiWiND4BS7UHgz51Px/krlVLjqgyS303
        n/KeLU+XTwwqOpFANHx3Pbx3VO9fHrqfHDvB4oFucPENqUyn
X-Google-Smtp-Source: AGRyM1vf/+GmdnUhIVmfLR0oZ8FW93Ws3Z15rZXifpI6YOhU70B2Bjq7yz7cZsnkvDuQ1RsPYw7Q3V43AZ/EBr3krrxgFNoiG1qY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2614:b0:33f:5bc2:b385 with SMTP id
 m20-20020a056638261400b0033f5bc2b385mr10245092jat.246.1658995521837; Thu, 28
 Jul 2022 01:05:21 -0700 (PDT)
Date:   Thu, 28 Jul 2022 01:05:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3644105e4d8fe7c@google.com>
Subject: [syzbot] KASAN: use-after-free Read in __ethtool_get_link_ksettings (2)
From:   syzbot <syzbot+414d11af970de2e10aac@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        john.fastabend@gmail.com, kuba@kernel.org, leon@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    70664fc10c0d Merge tag 'riscv-for-linus-5.19-rc8' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135227d6080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95c061eee05f8e15
dashboard link: https://syzkaller.appspot.com/bug?extid=414d11af970de2e10aac
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+414d11af970de2e10aac@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __ethtool_get_link_ksettings+0x162/0x180 net/ethtool/ioctl.c:457
Read of size 8 at addr ffff88802f1fe208 by task kworker/1:5/3686

CPU: 1 PID: 3686 Comm: kworker/1:5 Not tainted 5.19.0-rc7-syzkaller-00190-g70664fc10c0d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Workqueue: events smc_ib_port_event_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 __ethtool_get_link_ksettings+0x162/0x180 net/ethtool/ioctl.c:457
 __ethtool_get_link_ksettings+0xeb/0x180 net/ethtool/ioctl.c:461
 ib_get_eth_speed+0x10b/0x600 drivers/infiniband/core/verbs.c:1896
 rxe_query_port+0x13c/0x2d0 drivers/infiniband/sw/rxe/rxe_verbs.c:38
 __ib_query_port drivers/infiniband/core/device.c:2060 [inline]
 ib_query_port drivers/infiniband/core/device.c:2092 [inline]
 ib_query_port+0x42b/0x8a0 drivers/infiniband/core/device.c:2082
 smc_ib_remember_port_attr net/smc/smc_ib.c:358 [inline]
 smc_ib_port_event_work+0x14e/0xc30 net/smc/smc_ib.c:382
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 3641:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc_node include/linux/slab.h:623 [inline]
 kvmalloc_node+0x3e/0x190 mm/util.c:613
 kvmalloc include/linux/slab.h:750 [inline]
 kvzalloc include/linux/slab.h:758 [inline]
 alloc_netdev_mqs+0x98/0x1180 net/core/dev.c:10584
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3241
 rtnl_newlink_create net/core/rtnetlink.c:3353 [inline]
 __rtnl_newlink+0xf8f/0x17e0 net/core/rtnetlink.c:3580
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6089
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 __sys_sendto+0x21a/0x320 net/socket.c:2119
 __do_sys_sendto net/socket.c:2131 [inline]
 __se_sys_sendto net/socket.c:2127 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2127
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 6257:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1754 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
 slab_free mm/slub.c:3536 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4584
 kvfree+0x42/0x50 mm/util.c:655
 device_release+0x9f/0x240 drivers/base/core.c:2241
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 netdev_run_todo+0x75e/0x10f0 net/core/dev.c:10366
 rtnl_unlock net/core/rtnetlink.c:147 [inline]
 rtnetlink_rcv_msg+0x447/0xc90 net/core/rtnetlink.c:6090
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2488
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2542
 __sys_sendmsg net/socket.c:2571 [inline]
 __do_sys_sendmsg net/socket.c:2580 [inline]
 __se_sys_sendmsg net/socket.c:2578 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2578
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88802f1fe000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 520 bytes inside of
 4096-byte region [ffff88802f1fe000, ffff88802f1ff000)

The buggy address belongs to the physical page:
page:ffffea0000bc7e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2f1f8
head:ffffea0000bc7e00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff88801184c280
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3636, tgid 3636 (syz-executor.5), ts 179457705257, free_ts 0
 prep_new_page mm/page_alloc.c:2456 [inline]
 get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1824 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1969
 new_slab mm/slub.c:2029 [inline]
 ___slab_alloc+0x9c4/0xe20 mm/slub.c:3031
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
 slab_alloc_node mm/slub.c:3209 [inline]
 slab_alloc mm/slub.c:3251 [inline]
 __kmalloc_track_caller+0x2e7/0x320 mm/slub.c:4948
 kmemdup+0x23/0x50 mm/util.c:129
 kmemdup include/linux/fortify-string.h:456 [inline]
 __devinet_sysctl_register+0x98/0x280 net/ipv4/devinet.c:2574
 devinet_sysctl_register net/ipv4/devinet.c:2626 [inline]
 devinet_sysctl_register+0x160/0x230 net/ipv4/devinet.c:2616
 inetdev_init+0x286/0x580 net/ipv4/devinet.c:279
 inetdev_event+0xa8a/0x15d0 net/ipv4/devinet.c:1534
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 register_netdevice+0x10c3/0x15e0 net/core/dev.c:10084
 veth_newlink+0x4d6/0x9a0 drivers/net/veth.c:1799
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88802f1fe100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802f1fe180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802f1fe200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88802f1fe280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802f1fe300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
