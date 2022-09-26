Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576885EB283
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiIZUoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiIZUnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:43:40 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4EA99D0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:43:34 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id f11-20020a5d858b000000b006a17b75af65so4583069ioj.13
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=pLjmTXZHmewF4aPdCoGzZY9q6rFdZqeVZI5qsCfnZTI=;
        b=aZv3kaSFrL4PAmU9gOtMtle1r3sCdzX1JidntD1VNTmJAL7oHzAFHkFpnOwBPl/uaS
         r2GhDPCO4vcdcUxT/rWfPLDQRsQoXOvM3+tF2yxM4vV0CE6iAUaRIWSVZj/UnEhE2Gmk
         VOCd3zkrZzajVsI2kZaGbQ6UOXIh4/kJEAOUiwnqoPNDBl8NEWSB0q6QXHsH+qJtsVxK
         gJ54aQ0MgVTxwPiB2HxyJGNS4dvMVPdzdqGnxO1QuCS0FvnajoNNNO+o8o01WL4h22wX
         w4tl7fReR3DriS/JCVB2tnptaqXw6ujBHLOG+z+owy89iIk7atdB33CLB59AigGdBKSx
         PKIg==
X-Gm-Message-State: ACrzQf2H339TPAsn4YTajd1iWB7UPcgA4eFyoFYopqBSsb0+FkoiFcdn
        mPuE1nOWSpYv4TAYjvkg+7x/atjFxAFx0+kFyk4k44X1uTMi
X-Google-Smtp-Source: AMsMyM79iVpPKKMbC3Wedw+4aVyC//cIM1fdu8F2pn6fe7d4eDJWdMFZKgAmmr7cRgn6ok9erEArQwRnUNMmClvKfGlsboHhqHQw
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160c:b0:2f1:5fe8:9ab4 with SMTP id
 t12-20020a056e02160c00b002f15fe89ab4mr11547071ilu.92.1664225013289; Mon, 26
 Sep 2022 13:43:33 -0700 (PDT)
Date:   Mon, 26 Sep 2022 13:43:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000be60a305e99a94e0@google.com>
Subject: [syzbot] INFO: trying to register non-static key in nr_accept
From:   syzbot <syzbot+831a35e4a5d7058173e2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
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

HEAD commit:    16c9f284e746 Merge branch 'for-next/core', remote-tracking..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17555c40880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=15a770deac0c935a
dashboard link: https://syzkaller.appspot.com/bug?extid=831a35e4a5d7058173e2
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fd8978a3a764/disk-16c9f284.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/73ab1c321ad6/vmlinux-16c9f284.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+831a35e4a5d7058173e2@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 10531 Comm: syz-executor.2 Not tainted 6.0.0-rc6-syzkaller-17739-g16c9f284e746 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 assign_lock_key+0x134/0x140 kernel/locking/lockdep.c:979
 register_lock_class+0xc4/0x2f8 kernel/locking/lockdep.c:1292
 __lock_acquire+0xa8/0x30a4 kernel/locking/lockdep.c:4932
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
 lock_sock_nested+0x70/0xd8 net/core/sock.c:3393
 lock_sock include/net/sock.h:1712 [inline]
 nr_accept+0x1ac/0x250 net/netrom/af_netrom.c:805
 do_accept+0x1d8/0x274 net/socket.c:1856
 __sys_accept4_file net/socket.c:1897 [inline]
 __sys_accept4+0xb4/0x12c net/socket.c:1927
 __do_sys_accept net/socket.c:1944 [inline]
 __se_sys_accept net/socket.c:1941 [inline]
 __arm64_sys_accept+0x28/0x3c net/socket.c:1941
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190
Unable to handle kernel paging request at virtual address ffff80000d282a70
Mem abort info:
  ESR = 0x0000000096000047
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x07: level 3 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000047
  CM = 0, WnR = 1
swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001c567a000
[ffff80000d282a70] pgd=100000023ffff003, p4d=100000023ffff003, pud=100000023fffe003, pmd=100000023fffa003, pte=0000000000000000
Internal error: Oops: 0000000096000047 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 10531 Comm: syz-executor.2 Not tainted 6.0.0-rc6-syzkaller-17739-g16c9f284e746 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x198/0x380 kernel/locking/qspinlock.c:474
lr : queued_spin_lock_slowpath+0x114/0x380 kernel/locking/qspinlock.c:405
sp : ffff80001703bb80
x29: ffff80001703bb80 x28: ffff0000d34eb500 x27: 0000000000000000
x26: 0000000000000000 x25: 0000000000000000 x24: ffff0001fefd0a40
x23: 0000000000000000 x22: ffff80000d31cf28 x21: ffff80000d282a40
x20: 0000000000000000 x19: ffff0000f2785898 x18: 0000000000000000
x17: 6e69676e45206574 x16: 0000000000000001 x15: 0000000000000000
x14: 0000000000000000 x13: 000000000000ffff x12: 0000000000000000
x11: ffff80000d282a70 x10: 0000000000040000 x9 : ffff0001fefd0a48
x8 : ffff0001fefd0a40 x7 : 545b5d3032343235 x6 : ffff80000b1d2b08
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : ffff80000ce367ff x0 : 0000000000000001
Call trace:
 decode_tail kernel/locking/qspinlock.c:131 [inline]
 queued_spin_lock_slowpath+0x198/0x380 kernel/locking/qspinlock.c:471
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x10c/0x110 kernel/locking/spinlock_debug.c:115
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:127 [inline]
 _raw_spin_lock_bh+0x5c/0x6c kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 lock_sock_nested+0x88/0xd8 net/core/sock.c:3396
 lock_sock include/net/sock.h:1712 [inline]
 nr_accept+0x1ac/0x250 net/netrom/af_netrom.c:805
 do_accept+0x1d8/0x274 net/socket.c:1856
 __sys_accept4_file net/socket.c:1897 [inline]
 __sys_accept4+0xb4/0x12c net/socket.c:1927
 __do_sys_accept net/socket.c:1944 [inline]
 __se_sys_accept net/socket.c:1941 [inline]
 __arm64_sys_accept+0x28/0x3c net/socket.c:1941
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190
Code: 8b2c4ecc f85f818c 1200056b 8b2b52ab (f82b6988) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	8b2c4ecc 	add	x12, x22, w12, uxtw #3
   4:	f85f818c 	ldur	x12, [x12, #-8]
   8:	1200056b 	and	w11, w11, #0x3
   c:	8b2b52ab 	add	x11, x21, w11, uxtw #4
* 10:	f82b6988 	str	x8, [x12, x11] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
