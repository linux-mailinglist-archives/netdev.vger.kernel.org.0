Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7118F5BBCBC
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiIRJUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIRJUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:20:39 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727DB1ADBB
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:20:37 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id u9-20020a5edd49000000b006a0f03934e9so11371042iop.4
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=L5SUndDwyUZuIG+usGyoweCNzBEWOypbnrSMrVHZVOk=;
        b=Ws+YO1f/CzOZVKRTwPwDWxDsLfYV6zt82X62kdWpc9HjV2NtNWceui/1hMevLA0rUC
         +KEFizXYLU1TN/pXUOl6Yyjd8I8QwAexWGTuFGBFQBKDeYxu5FFqkLtdeNpGiNmDmaXs
         tEqmbqk4kiS2Qb4RJz/4SkAl2ANhPzCu21SZBDuZ7M6n/ZgRmrtalHakbSTt15HrWhM0
         D7FJBrIfOKAdB4IXCRDjjnToUFUHAxqd4RWeB76g/bY7IyfFyZl5f8clBZx3IFvu2fGl
         kgMkNZVwOydkyqjZBeI5GYLpkUDTuyb0bKcx4vUdwql4luTn+tBX83dNatClVp2sMEwV
         2oGA==
X-Gm-Message-State: ACrzQf0JRAtPcQTUKg/7VznotjSTFBA58+UhoS2VNbvxX2UfzIkBI0Re
        A+qkseeGMzYbniI6/fKfS5hoE8ARkarcH67PfSb+hUhR1acT
X-Google-Smtp-Source: AMsMyM6gdu4x/5bAlakX7vYcRys1/S1NVjBzkDnhfhGa55RdB44z5krHc9TSuCyRnzxkHkba3NWYEWtUy3DgxxsEyXlda/iHnzEH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1bc9:b0:2f1:9ee8:246d with SMTP id
 x9-20020a056e021bc900b002f19ee8246dmr5164757ilv.246.1663492836767; Sun, 18
 Sep 2022 02:20:36 -0700 (PDT)
Date:   Sun, 18 Sep 2022 02:20:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f3f2505e8f01b7a@google.com>
Subject: [syzbot] WARNING: locking bug in tee_netdev_event
From:   syzbot <syzbot+68f4b631890adeb054ae@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a6b443748715 Merge branch 'for-next/core', remote-tracking..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=167bf2d5080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=14bf9ec0df433b27
dashboard link: https://syzkaller.appspot.com/bug?extid=68f4b631890adeb054ae
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/81b491dd5861/disk-a6b44374.raw.xz
vmlinux: https://storage.googleapis.com/69c979cdc99a/vmlinux-a6b44374.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+68f4b631890adeb054ae@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 3067 at kernel/locking/lockdep.c:231 check_wait_context kernel/locking/lockdep.c:4727 [inline]
WARNING: CPU: 0 PID: 3067 at kernel/locking/lockdep.c:231 __lock_acquire+0x2b0/0x30a4 kernel/locking/lockdep.c:5003
Modules linked in:
CPU: 0 PID: 3067 Comm: syz-executor.0 Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : check_wait_context kernel/locking/lockdep.c:4727 [inline]
pc : __lock_acquire+0x2b0/0x30a4 kernel/locking/lockdep.c:5003
lr : hlock_class kernel/locking/lockdep.c:231 [inline]
lr : check_wait_context kernel/locking/lockdep.c:4727 [inline]
lr : __lock_acquire+0x298/0x30a4 kernel/locking/lockdep.c:5003
sp : ffff80001286b820
x29: ffff80001286b900 x28: 0000000000000001 x27: ffff0000cb301aa8
x26: ffff0000fe4b8178 x25: ffff0000cb3024d8 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000001 x21: 0000000000000000
x20: 0000000000000000 x19: 555554aaabeb6ffe x18: 000000000000039a
x17: 0000000000000008 x16: ffff80000db78658 x15: ffff0000cb301a80
x14: 0000000000000000 x13: 0000000000000012 x12: ffff80000d61f8a0
x11: ff808000081c1fa0 x10: ffff80000dd3a698 x9 : 47cf821c4953b000
x8 : 0000000000000000 x7 : 4e5241575f534b43 x6 : ffff8000081965e0
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000100000001 x0 : 0000000000000016
Call trace:
 check_wait_context kernel/locking/lockdep.c:4727 [inline]
 __lock_acquire+0x2b0/0x30a4 kernel/locking/lockdep.c:5003
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
 __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 tee_netdev_event+0x54/0x1a8 net/netfilter/xt_TEE.c:68
 notifier_call_chain kernel/notifier.c:87 [inline]
 raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
 call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10250 [inline]
 netdev_run_todo+0x340/0x6f0 net/core/dev.c:10364
 rtnl_unlock+0x14/0x20 net/core/rtnetlink.c:147
 tun_detach drivers/net/tun.c:704 [inline]
 tun_chr_close+0xe8/0xfc drivers/net/tun.c:3455
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x26c/0xbe0 kernel/exit.c:795
 do_group_exit+0x60/0xe8 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __wake_up_parent+0x0/0x40 kernel/exit.c:934
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:624
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
irq event stamp: 6465499
hardirqs last  enabled at (6465499): [<ffff8000081029e0>] __local_bh_enable_ip+0x13c/0x1a4 kernel/softirq.c:401
hardirqs last disabled at (6465497): [<ffff800008102968>] __local_bh_enable_ip+0xc4/0x1a4 kernel/softirq.c:378
softirqs last  enabled at (6465498): [<ffff80000b598ccc>] spin_unlock_bh include/linux/spinlock.h:394 [inline]
softirqs last  enabled at (6465498): [<ffff80000b598ccc>] rt_flush_dev+0x32c/0x374 net/ipv4/route.c:1557
softirqs last disabled at (6465496): [<ffff80000b598ab4>] spin_lock_bh include/linux/spinlock.h:354 [inline]
softirqs last disabled at (6465496): [<ffff80000b598ab4>] rt_flush_dev+0x114/0x374 net/ipv4/route.c:1548
---[ end trace 0000000000000000 ]---
Unable to handle kernel NULL pointer dereference at virtual address 00000000000000b8
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109391000
[00000000000000b8] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 3067 Comm: syz-executor.0 Tainted: G        W          6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : check_wait_context kernel/locking/lockdep.c:4727 [inline]
pc : __lock_acquire+0x2d0/0x30a4 kernel/locking/lockdep.c:5003
lr : hlock_class kernel/locking/lockdep.c:231 [inline]
lr : check_wait_context kernel/locking/lockdep.c:4727 [inline]
lr : __lock_acquire+0x298/0x30a4 kernel/locking/lockdep.c:5003
sp : ffff80001286b820
x29: ffff80001286b900 x28: 0000000000000001 x27: ffff0000cb301aa8
x26: ffff0000fe4b8178 x25: ffff0000cb3024d8 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000001 x21: 0000000000000000
x20: 0000000000000000 x19: 555554aaabeb6ffe x18: 000000000000039a
x17: 0000000000000008 x16: ffff80000db78658 x15: ffff0000cb301a80
x14: 0000000000000000 x13: 0000000000000012 x12: ffff80000d61f8a0
x11: ff808000081c1fa0 x10: ffff80000dd3a698 x9 : 0000000000040ffe
x8 : 0000000000000000 x7 : 4e5241575f534b43 x6 : ffff8000081965e0
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000100000001 x0 : 0000000000000016
Call trace:
 hlock_class kernel/locking/lockdep.c:222 [inline]
 check_wait_context kernel/locking/lockdep.c:4728 [inline]
 __lock_acquire+0x2d0/0x30a4 kernel/locking/lockdep.c:5003
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
 __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 tee_netdev_event+0x54/0x1a8 net/netfilter/xt_TEE.c:68
 notifier_call_chain kernel/notifier.c:87 [inline]
 raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
 call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10250 [inline]
 netdev_run_todo+0x340/0x6f0 net/core/dev.c:10364
 rtnl_unlock+0x14/0x20 net/core/rtnetlink.c:147
 tun_detach drivers/net/tun.c:704 [inline]
 tun_chr_close+0xe8/0xfc drivers/net/tun.c:3455
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x26c/0xbe0 kernel/exit.c:795
 do_group_exit+0x60/0xe8 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __wake_up_parent+0x0/0x40 kernel/exit.c:934
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:624
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
Code: f002dcea 91196210 911a614a b9400329 (3942e114) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f002dcea 	adrp	x10, 0x5b9f000
   4:	91196210 	add	x16, x16, #0x658
   8:	911a614a 	add	x10, x10, #0x698
   c:	b9400329 	ldr	w9, [x25]
* 10:	3942e114 	ldrb	w20, [x8, #184] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
