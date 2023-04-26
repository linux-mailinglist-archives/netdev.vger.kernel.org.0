Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B38A6EF260
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbjDZKnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240525AbjDZKmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:42:54 -0400
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED635C3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:42:52 -0700 (PDT)
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7664be0eb9cso38083039f.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682505772; x=1685097772;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I/MUlpUbp43WSfh7jyzDWWiZrAUNyRkJnvIcp0JJ3fU=;
        b=NXmyZxGg6mzZoST5umDViL/yx0berCXT25K//Xjvjg5zd/XOAgPp9xcOX3XiYVeobX
         o6GaQc2Q9w4Eh4ecY9W67idBh9wHIvwtyu8Qoj1aGkpQ4JPF2QyRrA7NpjnBdfFdWqAC
         QnR69ZF9+NZrYQ9qzZDKrUdjuMYHQKbnUpYcSS3EH0R6EK6ILx/no+3u+QOejxAQ5bla
         IRp72IHPERIFM1ZNQw4mRI9fgs4blh627k6NMZlFI3PWDJtDexYkzPt17yuZ6cc9lXLO
         W+lUthZ4DV0+gp03rButgB/OvUb31ixG/Cg3dyvy7T78EAQ4/F/OqXvFlpQ92c+2guRd
         flAA==
X-Gm-Message-State: AAQBX9c/PrMaRW6mn75QCM2ClAJK3NFj7pJtkJFWSmR5Qn4Yd2MUTqJN
        KxqhIlYZXZ+M/KX4ayeAS9GW6G/T41wzUMpI1bcFYHUeDwfg
X-Google-Smtp-Source: AKy350bi/inY7tXO3A/YXlv/rCgW0VdwnLoP8pDC7PfbX6BLM7vZxZcbvhhwBlvc/kDC5gfT3AHXBy63Z7+IneDTrE74wIPUOHnp
MIME-Version: 1.0
X-Received: by 2002:a5e:de05:0:b0:760:d92a:2f4a with SMTP id
 e5-20020a5ede05000000b00760d92a2f4amr8815766iok.2.1682505772236; Wed, 26 Apr
 2023 03:42:52 -0700 (PDT)
Date:   Wed, 26 Apr 2023 03:42:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3087b05fa3ae6c6@google.com>
Subject: [syzbot] [net?] kernel BUG in __phys_addr
From:   syzbot <syzbot+54744699b2023abde712@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135fa39fc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
dashboard link: https://syzkaller.appspot.com/bug?extid=54744699b2023abde712
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+54744699b2023abde712@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:28!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 12783 Comm: kworker/u4:15 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Workqueue: netns cleanup_net
RIP: 0010:__phys_addr+0xd7/0x140 arch/x86/mm/physaddr.c:28
Code: e3 44 89 e9 31 ff 48 d3 eb 48 89 de e8 e2 34 4a 00 48 85 db 75 0f e8 98 38 4a 00 4c 89 e0 5b 5d 41 5c 41 5d c3 e8 89 38 4a 00 <0f> 0b e8 82 38 4a 00 48 c7 c0 10 80 59 8c 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000bdbf410 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000200000001 RCX: 0000000000000000
RDX: ffff88807e553a80 RSI: ffffffff8139acc7 RDI: 0000000000000006
RBP: 0000000280000001 R08: 0000000000000006 R09: 0000000280000001
R10: 0000778200000001 R11: 0000000000000000 R12: 0000778200000001
R13: ffffc9000bdbf478 R14: 0000000200000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3aa188fb8 CR3: 0000000022a15000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virt_to_folio include/linux/mm.h:1215 [inline]
 virt_to_slab mm/kasan/../slab.h:174 [inline]
 qlink_to_cache mm/kasan/quarantine.c:129 [inline]
 qlist_free_all+0x86/0x170 mm/kasan/quarantine.c:182
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3451 [inline]
 kmem_cache_alloc_node+0x185/0x3e0 mm/slub.c:3496
 __alloc_skb+0x288/0x330 net/core/skbuff.c:644
 alloc_skb include/linux/skbuff.h:1288 [inline]
 nlmsg_new include/net/netlink.h:1003 [inline]
 inet6_netconf_notify_devconf+0xa4/0x1f0 net/ipv6/addrconf.c:581
 __addrconf_sysctl_unregister net/ipv6/addrconf.c:7122 [inline]
 addrconf_sysctl_unregister+0x131/0x1c0 net/ipv6/addrconf.c:7146
 addrconf_ifdown.isra.0+0x1350/0x1940 net/ipv6/addrconf.c:3908
 addrconf_notify+0x106/0x19f0 net/ipv6/addrconf.c:3678
 notifier_call_chain+0xb6/0x3c0 kernel/notifier.c:93
 call_netdevice_notifiers_info+0xb9/0x130 net/core/dev.c:1935
 call_netdevice_notifiers_extack net/core/dev.c:1973 [inline]
 call_netdevice_notifiers net/core/dev.c:1987 [inline]
 unregister_netdevice_many_notify+0x75f/0x18c0 net/core/dev.c:10871
 unregister_netdevice_many net/core/dev.c:10927 [inline]
 unregister_netdevice_queue+0x2e5/0x3c0 net/core/dev.c:10807
 unregister_netdevice include/linux/netdevice.h:3109 [inline]
 nsim_destroy+0x43/0x190 drivers/net/netdevsim/netdev.c:375
 __nsim_dev_port_del+0x189/0x240 drivers/net/netdevsim/dev.c:1428
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1440 [inline]
 nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1661
 nsim_dev_reload_down+0x6f/0xe0 drivers/net/netdevsim/dev.c:968
 devlink_reload+0x105/0x460 net/devlink/dev.c:362
 devlink_pernet_pre_exit+0x1b6/0x280 net/devlink/core.c:291
 ops_pre_exit_list net/core/net_namespace.c:160 [inline]
 cleanup_net+0x455/0xb10 net/core/net_namespace.c:602
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x33e/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0xd7/0x140 arch/x86/mm/physaddr.c:28
Code: e3 44 89 e9 31 ff 48 d3 eb 48 89 de e8 e2 34 4a 00 48 85 db 75 0f e8 98 38 4a 00 4c 89 e0 5b 5d 41 5c 41 5d c3 e8 89 38 4a 00 <0f> 0b e8 82 38 4a 00 48 c7 c0 10 80 59 8c 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000bdbf410 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000200000001 RCX: 0000000000000000
RDX: ffff88807e553a80 RSI: ffffffff8139acc7 RDI: 0000000000000006
RBP: 0000000280000001 R08: 0000000000000006 R09: 0000000280000001
R10: 0000778200000001 R11: 0000000000000000 R12: 0000778200000001
R13: ffffc9000bdbf478 R14: 0000000200000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000a97fc0 CR3: 0000000022a15000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
