Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7467252ACB1
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351788AbiEQU1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350013AbiEQU1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:27:30 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF93527F3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:27:29 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id s129-20020a6b2c87000000b00657c1a3b52fso13072043ios.21
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cRFwbGYYYJrN0dgN69OptN10qmU7nYDStfYj3Rja69A=;
        b=bX7ZUPpygMhk0nhjA1z2WiKG7/dn7SYRrXbydzBapWX0BrYHQXpBQUivdBHo5ID1bl
         ZZgAiZey3Llduhu8dDO15YPJq4Nh+9+rlATgw4w20T3hWdlZSdMKiKPeWgDnhlwGyw1/
         FXIMolsmrJtb+4AA4qINQg4fv6IxgStALzPEzFYMgifVWRj5mKvTODzr5mo6pNJuLGoS
         iAeTgA2A70i0fpuNytjCRSjOLDOHxD8pK97oEFyKUwZq+3xqPeLXAdbEX24dww2H/+m5
         MHokKdFR3TR8OtxektfzqAthOgc4Srjxn7SVnyTpUc+5N1u1PFqQTcyk3cY9h1H/aH74
         EvIw==
X-Gm-Message-State: AOAM5314PAFFvTzrKQzjoROvWEYlZGS840NaUUkTQsDUEULbTdo4tF6U
        6pSJ00CSg+Od6g3gyh8V+D4HtEolD4ESZHAVZh60fjnerGH1
X-Google-Smtp-Source: ABdhPJxE11PZVRGHuTc9YY6/4wD1M/n3WhPIaE5dUdD2PTj5uKoKvDiQvKBXgpJCcrbYrkCE7MhUBGsD9En8T/m/CeEOx1CPSAoX
MIME-Version: 1.0
X-Received: by 2002:a05:6638:15c9:b0:32d:b26d:a01e with SMTP id
 i9-20020a05663815c900b0032db26da01emr13379939jat.11.1652819248466; Tue, 17
 May 2022 13:27:28 -0700 (PDT)
Date:   Tue, 17 May 2022 13:27:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ecf9805df3af808@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in cttimeout_net_exit
From:   syzbot <syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
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

HEAD commit:    65a9dedc11d6 net: phy: marvell: Add errata section 5.1 for..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16fafa9ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05eee2efc702eed
dashboard link: https://syzkaller.appspot.com/bug?extid=92968395eedbdbd3617d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com

bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves
==================================================================
BUG: KASAN: slab-out-of-bounds in __list_del_entry_valid+0xcc/0xf0 lib/list_debug.c:42
Read of size 8 at addr ffff888051af75b8 by task kworker/u4:5/1223

CPU: 1 PID: 1223 Comm: kworker/u4:5 Not tainted 5.18.0-rc6-syzkaller-01553-g65a9dedc11d6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 __list_del_entry_valid+0xcc/0xf0 lib/list_debug.c:42
 __list_del_entry include/linux/list.h:134 [inline]
 list_del include/linux/list.h:148 [inline]
 cttimeout_net_exit+0x211/0x540 net/netfilter/nfnetlink_cttimeout.c:617
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:162
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 9270:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 cttimeout_new_timeout+0x51f/0xa50 net/netfilter/nfnetlink_cttimeout.c:156
 nfnetlink_rcv_msg+0xbcd/0x13f0 net/netfilter/nfnetlink.c:297
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:655
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2460
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2514
 __sys_sendmsg net/socket.c:2543 [inline]
 __do_sys_sendmsg net/socket.c:2552 [inline]
 __se_sys_sendmsg net/socket.c:2550 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2550
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888051af7500
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 56 bytes to the right of
 128-byte region [ffff888051af7500, ffff888051af7580)

The buggy address belongs to the physical page:
page:ffffea000146bdc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888051af7100 pfn:0x51af7
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0001ed5e48 ffffea0001cf4b08 ffff888010c418c0
raw: ffff888051af7100 000000000010000b 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 7027, tgid 7027 (cmp), ts 227162348638, free_ts 227160439771
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 alloc_slab_page mm/slub.c:1801 [inline]
 allocate_slab+0x80/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 __kmalloc_node+0x2cb/0x390 mm/slub.c:4458
 kmalloc_array_node include/linux/slab.h:676 [inline]
 kcalloc_node include/linux/slab.h:681 [inline]
 memcg_alloc_slab_cgroups+0x8b/0x140 mm/memcontrol.c:2810
 account_slab mm/slab.h:652 [inline]
 allocate_slab+0x2c9/0x3c0 mm/slub.c:1960
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
 kmem_cache_alloc+0x360/0x3b0 mm/slub.c:3242
 vm_area_dup+0x88/0x3f0 kernel/fork.c:467
 __split_vma+0xa5/0x550 mm/mmap.c:2712
 split_vma+0x95/0xd0 mm/mmap.c:2770
 mprotect_fixup+0x72d/0x950 mm/mprotect.c:494
 do_mprotect_pkey+0x532/0x980 mm/mprotect.c:650
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 __vunmap+0x85d/0xd30 mm/vmalloc.c:2667
 free_work+0x58/0x70 mm/vmalloc.c:97
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Memory state around the buggy address:
 ffff888051af7480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888051af7500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc
>ffff888051af7580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 ffff888051af7600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888051af7680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
