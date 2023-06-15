Return-Path: <netdev+bounces-11151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB372731C29
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F01A2281431
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2753312B9C;
	Thu, 15 Jun 2023 15:06:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1043EBA3A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:06:31 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECA42947
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:06:29 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7778eb7966eso853950739f.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686841588; x=1689433588;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jbAvnQlKSnFDELvEQTU/itBH23RgAeQ5EJ/SGFPEZv8=;
        b=RSsKEy+ESYKRSlxhO0sQJqfkhLgPbu269xzNFwXZWaoM3cXNzMctK0TsdCX2ZAZPIc
         Ip61T+siY83A3fljF1uP4XNWIBwS83/7SDR96AOhrm8mer6xuldGgzpEIIcbd6ZUZ/bU
         Nq47/QmBzX8OCqJbvb9rSVZJbKN5kwSW8fM5PW1d3yA/XbTVi0MVSom7sB6th3/ImFtp
         CQymPZ/K1KKXL4KmKW+Kw5lY8c1k6Qoosa9af5HPjF9sbn8fDln5xxACBNVrG7gFOdOc
         rhNrS37DaveVkwc3xCVhIV4F644sp7FmBWCYeZ2+ljapHYSejL+XN5GDop9MaTx6horE
         dyAg==
X-Gm-Message-State: AC+VfDwoyWmjgdRk3ncCJdFtXQ4+U+E2v7dSOjr9Wc2hdB4w62nVV+/B
	6e1WgVNsJ9qLrhvQRb33mStNtfNf18mzyjaka5csjZyGtlaQ
X-Google-Smtp-Source: ACHHUZ4B1oDulCwNnFJj5FW/hLBUwoVbc3vtpMk2I5Iazh8TltbwMdoz1irid8xRzwElELT0NQM6H8amJQ1Sk8Rlbqqcc8N3Sp3C
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:84e6:0:b0:423:13e1:8092 with SMTP id
 f93-20020a0284e6000000b0042313e18092mr806046jai.5.1686841588671; Thu, 15 Jun
 2023 08:06:28 -0700 (PDT)
Date: Thu, 15 Jun 2023 08:06:28 -0700
In-Reply-To: <89571.1686830867@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af6fa405fe2c690f@google.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
From: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	kuba@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-out-of-bounds Read in extract_iter_to_sg

==================================================================
BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatterlist.h:109 [inline]
BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlist.h:139 [inline]
BUG: KASAN: slab-out-of-bounds in extract_bvec_to_sg lib/scatterlist.c:1183 [inline]
BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg lib/scatterlist.c:1352 [inline]
BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg+0x17a6/0x1960 lib/scatterlist.c:1339
Read of size 8 at addr ffff888070558ff8 by task syz-executor.0/5573

CPU: 0 PID: 5573 Comm: syz-executor.0 Not tainted 6.4.0-rc5-syzkaller-01229-g97c5209b3d37-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 sg_assign_page include/linux/scatterlist.h:109 [inline]
 sg_set_page include/linux/scatterlist.h:139 [inline]
 extract_bvec_to_sg lib/scatterlist.c:1183 [inline]
 extract_iter_to_sg lib/scatterlist.c:1352 [inline]
 extract_iter_to_sg+0x17a6/0x1960 lib/scatterlist.c:1339
 af_alg_sendmsg+0x1917/0x2990 crypto/af_alg.c:1045
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 splice_to_socket+0x964/0xee0 fs/splice.c:915
 do_splice_from fs/splice.c:967 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:1155
 splice_direct_to_actor+0x34a/0x9c0 fs/splice.c:1101
 do_splice_direct+0x1ad/0x280 fs/splice.c:1207
 do_sendfile+0xb19/0x12c0 fs/read_write.c:1254
 __do_sys_sendfile64 fs/read_write.c:1316 [inline]
 __se_sys_sendfile64 fs/read_write.c:1308 [inline]
 __x64_sys_sendfile64+0x14d/0x210 fs/read_write.c:1308
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ff232a8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff2337f5168 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007ff232bac120 RCX: 00007ff232a8c169
RDX: 0000000020000180 RSI: 0000000000000003 RDI: 0000000000000005
RBP: 00007ff232ae7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffec66777f R14: 00007ff2337f5300 R15: 0000000000022000
 </TASK>

Allocated by task 5573:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc+0x5e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 sock_kmalloc+0xb2/0x100 net/core/sock.c:2674
 af_alg_alloc_tsgl crypto/af_alg.c:614 [inline]
 af_alg_sendmsg+0x17a4/0x2990 crypto/af_alg.c:1028
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 splice_to_socket+0x964/0xee0 fs/splice.c:915
 do_splice_from fs/splice.c:967 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:1155
 splice_direct_to_actor+0x34a/0x9c0 fs/splice.c:1101
 do_splice_direct+0x1ad/0x280 fs/splice.c:1207
 do_sendfile+0xb19/0x12c0 fs/read_write.c:1254
 __do_sys_sendfile64 fs/read_write.c:1316 [inline]
 __se_sys_sendfile64 fs/read_write.c:1308 [inline]
 __x64_sys_sendfile64+0x14d/0x210 fs/read_write.c:1308
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888070558000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes to the right of
 allocated 4088-byte region [ffff888070558000, ffff888070558ff8)

The buggy address belongs to the physical page:
page:ffffea0001c15600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x70558
head:ffffea0001c15600 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 5573, tgid 5567 (syz-executor.0), ts 94731634455, free_ts 69153490166
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1731
 prep_new_page mm/page_alloc.c:1738 [inline]
 get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3502
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4768
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2279
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
 sock_kmalloc+0xb2/0x100 net/core/sock.c:2674
 af_alg_alloc_tsgl crypto/af_alg.c:614 [inline]
 af_alg_sendmsg+0x17a4/0x2990 crypto/af_alg.c:1028
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 splice_to_socket+0x964/0xee0 fs/splice.c:915
 do_splice_from fs/splice.c:967 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:1155
 splice_direct_to_actor+0x34a/0x9c0 fs/splice.c:1101
 do_splice_direct+0x1ad/0x280 fs/splice.c:1207
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 __free_pages_ok+0x77f/0x1060 mm/page_alloc.c:1441
 kvfree+0x46/0x50 mm/util.c:650
 fq_reset include/net/fq_impl.h:386 [inline]
 ieee80211_txq_teardown_flows+0x165/0x270 net/mac80211/tx.c:1638
 ieee80211_remove_interfaces+0x13d/0x690 net/mac80211/iface.c:2280
 ieee80211_unregister_hw+0x4b/0x240 net/mac80211/main.c:1483
 mac80211_hwsim_del_radio drivers/net/wireless/virtual/mac80211_hwsim.c:5408 [inline]
 hwsim_exit_net+0x412/0x840 drivers/net/wireless/virtual/mac80211_hwsim.c:6284
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:170
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:614
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Memory state around the buggy address:
 ffff888070558e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888070558f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888070558f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
                                                                ^
 ffff888070559000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888070559080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


Tested on:

commit:         97c5209b leds: trigger: netdev: uninitialized variable..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=158fa0e3280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17ff78cf280000


