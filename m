Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DD740ABD4
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 12:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhINKkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 06:40:41 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37487 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhINKki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 06:40:38 -0400
Received: by mail-il1-f199.google.com with SMTP id w12-20020a92ad0c000000b00227fc2e6eaeso18186255ilh.4
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 03:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SXMhJrXbfSmRYQtaR0hUvN5LCQU2jsIHZIHNsTcJkxs=;
        b=CZY1LLoSUziOiU6fP3iyvnoLkASeeFRG+0KBg0pY4Tcjl20D5nWcdbBsvc4MX2UIic
         SbuywCMwkmIMvAxJ/1veBG7FQcwFW9HEVKFYscGh9+4yMgmY1DZi6DhA6rmShvWth0g8
         3bwAN0XNbbXrUtqGkcunCgZPLq47xweMyPNCfgtlZnGkzgN2D8uhkIKG8Tg1kIk7vEm0
         Sabo9rW6aToShWnwagSWZ6ZEljZngJMvY8PzWU2+bOpmsq9zGu0Hh2y04nGJGy1DhAWZ
         n9zS7J3fSF8rYTWt7be/uc+sQQ9wFnFTi1AuKwwoetuIC1X8hzIvPSeZaZQ5e6y9n5Wm
         4CPw==
X-Gm-Message-State: AOAM532792uPrlrubUdjhb7nejCrcL5WefzewefpWC7w2q9TqHDKnJri
        ih+XOmqZ7ihRmC+Atqto80ffr5DhPLlMWoyc6WTgbnx4c39C
X-Google-Smtp-Source: ABdhPJyFJrq/sk58IUwgMvAsb0UVKVgi8l2Tr4ILjptBMcyVBJnOmb2r2bGWbwxouZEP+zjmULTARJRnu1Pd9J2h4B2SuQs7cRXG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3046:: with SMTP id u6mr13906261jak.35.1631615961049;
 Tue, 14 Sep 2021 03:39:21 -0700 (PDT)
Date:   Tue, 14 Sep 2021 03:39:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4ae8805cbf23125@google.com>
Subject: [syzbot] riscv/fixes test error: BUG: unable to handle kernel NULL
 pointer dereference in corrupted
From:   syzbot <syzbot+12f4d5520532d623ba3c@syzkaller.appspotmail.com>
To:     alexanderduyck@fb.com, atenart@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        weiwan@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7d2a07b76933 Linux 5.14
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=16d900c3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8211b06020972e8
dashboard link: https://syzkaller.appspot.com/bug?extid=12f4d5520532d623ba3c
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: riscv64

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12f4d5520532d623ba3c@syzkaller.appspotmail.com

bond0: (slave bond_slave_0): Enslaving as an active interface with an up link
bond0: (slave bond_slave_1): Enslaving as an active interface with an up link
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000dc0
Oops [#1]
Modules linked in:
CPU: 0 PID: 3090 Comm: syz-executor.0 Not tainted 5.14.0-syzkaller #0
Hardware name: riscv-virtio,qemu (DT)
epc : slab_alloc_node mm/slub.c:2900 [inline]
epc : slab_alloc mm/slub.c:2967 [inline]
epc : __kmalloc+0xce/0x388 mm/slub.c:4111
 ra : slab_pre_alloc_hook mm/slab.h:494 [inline]
 ra : slab_alloc_node mm/slub.c:2880 [inline]
 ra : slab_alloc mm/slub.c:2967 [inline]
 ra : __kmalloc+0x6e/0x388 mm/slub.c:4111
epc : ffffffff803e3568 ra : ffffffff803e3508 sp : ffffffe00924f1e0
 gp : ffffffff83f967d8 tp : ffffffe00db98000 t0 : ffffffc402a0e200
 t1 : 0000000000000001 t2 : 000000005784fdac s0 : ffffffe00924f280
 s1 : ffffffe005601640 a0 : 0000000000000000 a1 : ffffffe00924f5cc
 a2 : 1ffffffff07aa51f a3 : 0000000000000dc0 a4 : 0000000000000000
 a5 : ffffffff82e4b2b0 a6 : 0000000000f00000 a7 : ffffffff8038ca52
 s2 : ffffffff83f96adc s3 : 0000000000000dc0 s4 : 0000000000000026
 s5 : ffffffff80acc382 s6 : ffffffff83f9a0d0 s7 : 0000000000000000
 s8 : 0000000000000dc0 s9 : 0000000000000001 s10: ffffffe006bcbb00
 s11: ffffffff8365bbd8 t3 : 69ec673486bf2000 t4 : ffffffc1e04a9392
 t5 : ffffffc1e04a9393 t6 : ffffffe014ff375d
status: 0000000000000120 badaddr: 0000000000000dc0 cause: 000000000000000d
[<ffffffff803e3568>] slab_alloc_node mm/slub.c:2900 [inline]
[<ffffffff803e3568>] slab_alloc mm/slub.c:2967 [inline]
[<ffffffff803e3568>] __kmalloc+0xce/0x388 mm/slub.c:4111
[<ffffffff80acc382>] kmalloc include/linux/slab.h:596 [inline]
[<ffffffff80acc382>] kzalloc include/linux/slab.h:721 [inline]
[<ffffffff80acc382>] kobject_get_path+0xac/0x16a lib/kobject.c:179
[<ffffffff80ace5d0>] kobject_uevent_env+0x1d8/0xde4 lib/kobject_uevent.c:529
[<ffffffff80acf1fe>] kobject_uevent+0x22/0x2e lib/kobject_uevent.c:642
[<ffffffff8226afec>] rx_queue_add_kobject net/core/net-sysfs.c:1020 [inline]
[<ffffffff8226afec>] net_rx_queue_update_kobjects+0xcc/0x372 net/core/net-sysfs.c:1060
[<ffffffff8226b7f4>] register_queue_kobjects net/core/net-sysfs.c:1711 [inline]
[<ffffffff8226b7f4>] netdev_register_kobject+0x166/0x208 net/core/net-sysfs.c:1959
[<ffffffff821ffac6>] register_netdevice+0x872/0xbe0 net/core/dev.c:10349
[<ffffffff82b10ce2>] hsr_dev_finalize+0x346/0x45e net/hsr/hsr_device.c:535
[<ffffffff82b1122e>] hsr_newlink+0x1ca/0x37c net/hsr/hsr_netlink.c:102
[<ffffffff82221fc2>] __rtnl_newlink+0xb04/0xe90 net/core/rtnetlink.c:3461
[<ffffffff8222239e>] rtnl_newlink+0x50/0x7c net/core/rtnetlink.c:3509
[<ffffffff82222a12>] rtnetlink_rcv_msg+0x2ce/0x90e net/core/rtnetlink.c:5575
[<ffffffff82400cc4>] netlink_rcv_skb+0x9c/0x248 net/netlink/af_netlink.c:2504
[<ffffffff8221a5da>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5593
[<ffffffff823ffb92>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
[<ffffffff823ffb92>] netlink_unicast+0x398/0x584 net/netlink/af_netlink.c:1340
[<ffffffff824001c8>] netlink_sendmsg+0x44a/0x894 net/netlink/af_netlink.c:1929
[<ffffffff821908cc>] sock_sendmsg_nosec net/socket.c:703 [inline]
[<ffffffff821908cc>] sock_sendmsg+0xa0/0xc4 net/socket.c:723
[<ffffffff8219428a>] __sys_sendto+0x170/0x230 net/socket.c:2019
[<ffffffff82194388>] __do_sys_sendto net/socket.c:2031 [inline]
[<ffffffff82194388>] sys_sendto+0x3e/0x52 net/socket.c:2027
[<ffffffff80005150>] ret_from_syscall+0x0/0x2
---[ end trace 6a349b32cfb17483 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
