Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810FC15F7D9
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgBNUkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:40:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37875 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730112AbgBNUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:40:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id a6so12149596wme.2
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 12:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDp1bNuPFdouANRALNAotB4A/yC2vN/wL89fA/twLX4=;
        b=wZCkh9hwAfMiMvS9KVgqLCmwN+IkqpfU3e196X7U/jblwfUYO7I8Wxx4crMBDv7kUp
         lVygezei53GehjCnjeCqu034aQZPuvmtsnH2tnw45K/BKNR9rbgO1La2A34qW1Xia5pH
         Jkfo/5nWedRC0TkZj1Cuxk7gXOrjAVkdatA8Fv7qMD9g6a6GUecgF00oTNzgLKdEBhDd
         YUBYY+2Ja/IIPnXGNSyuzg3sQiVrfykfNv0xQ2CiETlU+hAcTquWzQYtsodNQ505NQdD
         JTR3M6SRRFi1mk9c+SpWeYZaSilinke0QBKwQDcDJ+cL4RzSdWjBKKt4yn+HGsqjdumb
         PdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDp1bNuPFdouANRALNAotB4A/yC2vN/wL89fA/twLX4=;
        b=ZCooPyZ9QWaTL+50G5JxxvFIAz70RxHuZOY6xBP5B5VXYOVVUaxzw5FdXtJgSjQF6V
         1F5kkhfZHBPRQVg2J4nLuxO7l1xnfIgmONGPriP4NkN9joiwzXJTx+nVxlch4xdQgXdW
         DxAbIIpZovnnD+vpIMwSUTdabLbV8hsHVOziVsGZfFcnfU8ti2Z1JAYnyOyF7NERjbZm
         zAOG14b1qaSugWQF+L6/pXrOxSfbTtj7t50F10Y2wig4KVtHh+1UwLjZP3n6B3CkkU32
         7E/eOF6VcEpm+oX+FbinCkxhHeca83QMS2AOzOTHvdfA6t2UFZKlZy5zFXOKGKJjoGk5
         MNxA==
X-Gm-Message-State: APjAAAXgXLiKKJX3KpkDtntq+3fmRSaJFynqbXiVWz3yubTexVbznQhE
        z/aYNZj0+uraNJknzja8+vwfGg==
X-Google-Smtp-Source: APXvYqxD9ShPnujJeilEDrb7vaByWaf6PFWI8yhBfg7JOoFi9QTUcSvEkPYWk7t8GDl//ERl/hj8oQ==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr6433691wmc.65.1581712833935;
        Fri, 14 Feb 2020 12:40:33 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x17sm8081567wrt.74.2020.02.14.12.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:40:33 -0800 (PST)
Date:   Fri, 14 Feb 2020 21:40:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net] net: add strict checks in
 netdev_name_node_alt_destroy()
Message-ID: <20200214204032.GB2247@nanopsycho.orion>
References: <20200214155353.71062-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214155353.71062-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 14, 2020 at 04:53:53PM CET, edumazet@google.com wrote:
>netdev_name_node_alt_destroy() does a lookup over all
>device names of a namespace.
>
>We need to make sure the name belongs to the device
>of interest, and that we do not destroy its primary
>name, since we rely on it being not deleted :
>dev->name_node would indeed point to freed memory.
>
>syzbot report was the following :
>
>BUG: KASAN: use-after-free in dev_net include/linux/netdevice.h:2206 [inline]
>BUG: KASAN: use-after-free in mld_force_mld_version net/ipv6/mcast.c:1172 [inline]
>BUG: KASAN: use-after-free in mld_in_v2_mode_only net/ipv6/mcast.c:1180 [inline]
>BUG: KASAN: use-after-free in mld_in_v1_mode+0x203/0x230 net/ipv6/mcast.c:1190
>Read of size 8 at addr ffff88809886c588 by task swapper/1/0
>
>CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc1-syzkaller #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>Call Trace:
> <IRQ>
> __dump_stack lib/dump_stack.c:77 [inline]
> dump_stack+0x197/0x210 lib/dump_stack.c:118
> print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
> __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
> kasan_report+0x12/0x20 mm/kasan/common.c:641
> __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
> dev_net include/linux/netdevice.h:2206 [inline]
> mld_force_mld_version net/ipv6/mcast.c:1172 [inline]
> mld_in_v2_mode_only net/ipv6/mcast.c:1180 [inline]
> mld_in_v1_mode+0x203/0x230 net/ipv6/mcast.c:1190
> mld_send_initial_cr net/ipv6/mcast.c:2083 [inline]
> mld_dad_timer_expire+0x24/0x230 net/ipv6/mcast.c:2118
> call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
> expire_timers kernel/time/timer.c:1449 [inline]
> __run_timers kernel/time/timer.c:1773 [inline]
> __run_timers kernel/time/timer.c:1740 [inline]
> run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
> __do_softirq+0x262/0x98c kernel/softirq.c:292
> invoke_softirq kernel/softirq.c:373 [inline]
> irq_exit+0x19b/0x1e0 kernel/softirq.c:413
> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
> smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1146
> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> </IRQ>
>RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
>Code: 68 73 c5 f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 94 be 59 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 84 be 59 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 de 2a 74 f9 e8 09
>RSP: 0018:ffffc90000d3fd68 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
>RAX: 1ffffffff136761a RBX: ffff8880a99fc340 RCX: 0000000000000000
>RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a99fcbd4
>RBP: ffffc90000d3fd98 R08: ffff8880a99fc340 R09: 0000000000000000
>R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
>R13: ffffffff8aa5a1c0 R14: 0000000000000000 R15: 0000000000000001
> arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:686
> default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
> cpuidle_idle_call kernel/sched/idle.c:154 [inline]
> do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
> cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
> start_secondary+0x2f4/0x410 arch/x86/kernel/smpboot.c:264
> secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
>
>Allocated by task 10229:
> save_stack+0x23/0x90 mm/kasan/common.c:72
> set_track mm/kasan/common.c:80 [inline]
> __kasan_kmalloc mm/kasan/common.c:515 [inline]
> __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
> kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
> __do_kmalloc_node mm/slab.c:3616 [inline]
> __kmalloc_node+0x4e/0x70 mm/slab.c:3623
> kmalloc_node include/linux/slab.h:578 [inline]
> kvmalloc_node+0x68/0x100 mm/util.c:574
> kvmalloc include/linux/mm.h:645 [inline]
> kvzalloc include/linux/mm.h:653 [inline]
> alloc_netdev_mqs+0x98/0xe40 net/core/dev.c:9797
> rtnl_create_link+0x22d/0xaf0 net/core/rtnetlink.c:3047
> __rtnl_newlink+0xf9f/0x1790 net/core/rtnetlink.c:3309
> rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3377
> rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5438
> netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
> rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
> netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
> netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
> netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
> sock_sendmsg_nosec net/socket.c:652 [inline]
> sock_sendmsg+0xd7/0x130 net/socket.c:672
> __sys_sendto+0x262/0x380 net/socket.c:1998
> __do_compat_sys_socketcall net/compat.c:771 [inline]
> __se_compat_sys_socketcall net/compat.c:719 [inline]
> __ia32_compat_sys_socketcall+0x530/0x710 net/compat.c:719
> do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
> do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
> entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
>
>Freed by task 10229:
> save_stack+0x23/0x90 mm/kasan/common.c:72
> set_track mm/kasan/common.c:80 [inline]
> kasan_set_free_info mm/kasan/common.c:337 [inline]
> __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
> kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
> __cache_free mm/slab.c:3426 [inline]
> kfree+0x10a/0x2c0 mm/slab.c:3757
> __netdev_name_node_alt_destroy+0x1ff/0x2a0 net/core/dev.c:322
> netdev_name_node_alt_destroy+0x57/0x80 net/core/dev.c:334
> rtnl_alt_ifname net/core/rtnetlink.c:3518 [inline]
> rtnl_linkprop.isra.0+0x575/0x6f0 net/core/rtnetlink.c:3567
> rtnl_dellinkprop+0x46/0x60 net/core/rtnetlink.c:3588
> rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5438
> netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
> rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
> netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
> netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
> netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
> sock_sendmsg_nosec net/socket.c:652 [inline]
> sock_sendmsg+0xd7/0x130 net/socket.c:672
> ____sys_sendmsg+0x753/0x880 net/socket.c:2343
> ___sys_sendmsg+0x100/0x170 net/socket.c:2397
> __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
> __compat_sys_sendmsg net/compat.c:642 [inline]
> __do_compat_sys_sendmsg net/compat.c:649 [inline]
> __se_compat_sys_sendmsg net/compat.c:646 [inline]
> __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
> do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
> do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
> entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
>
>The buggy address belongs to the object at ffff88809886c000
> which belongs to the cache kmalloc-4k of size 4096
>The buggy address is located 1416 bytes inside of
> 4096-byte region [ffff88809886c000, ffff88809886d000)
>The buggy address belongs to the page:
>page:ffffea0002621b00 refcount:1 mapcount:0 mapping:ffff8880aa402000 index:0x0 compound_mapcount: 0
>flags: 0xfffe0000010200(slab|head)
>raw: 00fffe0000010200 ffffea0002610d08 ffffea0002607608 ffff8880aa402000
>raw: 0000000000000000 ffff88809886c000 0000000100000001 0000000000000000
>page dumped because: kasan: bad access detected
>
>Memory state around the buggy address:
> ffff88809886c480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809886c500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>ffff88809886c580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                      ^
> ffff88809886c600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809886c680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>
>Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Reported-by: syzbot <syzkaller@googlegroups.com>
>Cc: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks Eric!
