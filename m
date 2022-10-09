Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE995F8978
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 07:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiJIFnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 01:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJIFni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 01:43:38 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFA82B187
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 22:43:35 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id i21-20020a056e021d1500b002f9e4f8eab7so6566042ila.7
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 22:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OkiLQRhmSLtuh1o8dvwMX2015uWLVIf0Afm2i0Kxr0I=;
        b=zzGzDYGmJ7xbcpfXWxKpYl4H3NLjlTsLWtYTxvfj9GtnQ4KlmKH6Tscanq5CTv9ZFo
         ci1vCbbFBkj5klBAEwjhR8O+weC/wyPvxUVCjr7Z3L3OL+Q3exkGxvoqAjngOvAt3dNg
         hASgtiSCA1p4n4FCtn6IcVJegYtq+C9MZtq8XPi7HFirh4DB+5TGPIe4T70xMNvDdpS2
         auPfCTIb7MxkQGW9xOEx9Umk1+yhLiVmXIA6r2Po8WAcSStLNn8BE6W5tz9X7r6B+vwD
         MEHXgk4SY1yxgaHX21FQPUM7wtN2agaKMuYlqqaun1Q6hA7SMDajxQ07yKgSlUH/lwwx
         KJcw==
X-Gm-Message-State: ACrzQf3ax1DUxONGotgQb8BhgBfTBmo6u/SSnrM5P0aRd1sMg1j3AL9P
        B0WLACGK48eEjcDM+KJ3t3M4+tV1vhdORUJhBhRkzShMbuVn
X-Google-Smtp-Source: AMsMyM7v1OPqx2GCvMc8TRZL35mPVQq/caKFC0BTkKYxkTlB2UZh8Cek4g7jA9i2vaVx0q1yeMd370FUGo+twQVQ8XHbLgSbGclH
MIME-Version: 1.0
X-Received: by 2002:a05:6602:98:b0:6a2:1723:bee1 with SMTP id
 h24-20020a056602009800b006a21723bee1mr5442197iob.58.1665294215268; Sat, 08
 Oct 2022 22:43:35 -0700 (PDT)
Date:   Sat, 08 Oct 2022 22:43:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000025d09b05ea9386ab@google.com>
Subject: [syzbot] general protection fault in rose_send_frame (2)
From:   syzbot <syzbot+b25099bc0c49d0c2962e@syzkaller.appspotmail.com>
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

HEAD commit:    0326074ff465 Merge tag 'net-next-6.1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1686bcdc880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=796b7c2847a6866a
dashboard link: https://syzkaller.appspot.com/bug?extid=b25099bc0c49d0c2962e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b58a97ee1509/disk-0326074f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ba3e08c86725/vmlinux-0326074f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b25099bc0c49d0c2962e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000070: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000380-0x0000000000000387]
CPU: 0 PID: 18027 Comm: syz-executor.2 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:rose_send_frame+0x1dd/0x2f0 net/rose/rose_link.c:101
Code: 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 8d bd 80 03 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ea 00 00 00 4c 8b bd 80 03 00 00 e9 77 fe ff ff
RSP: 0018:ffffc90000007b00 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88802690b800 RCX: 0000000000000100
RDX: 0000000000000070 RSI: ffffffff88514482 RDI: 0000000000000380
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88802690b800
R13: 0000000000000078 R14: ffff88802f169640 R15: 0000000000000010
FS:  00007f83f2834700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff318aaf940 CR3: 0000000063a3f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
 rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
 rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
 call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:stackdepot_memcmp lib/stackdepot.c:279 [inline]
RIP: 0010:find_stack lib/stackdepot.c:295 [inline]
RIP: 0010:__stack_depot_save+0x145/0x500 lib/stackdepot.c:435
Code: 29 48 85 ed 75 12 e9 92 00 00 00 48 8b 6d 00 48 85 ed 0f 84 85 00 00 00 39 5d 08 75 ee 44 3b 7d 0c 75 e8 31 c0 48 8b 74 c5 18 <49> 39 34 c6 75 db 48 83 c0 01 48 39 c2 75 ec 48 8b 7c 24 28 48 85
RSP: 0018:ffffc9001499eb88 EFLAGS: 00000216
RAX: 000000000000000d RBX: 0000000021011daf RCX: ffff88823b48ed78
RDX: 0000000000000016 RSI: ffffffff879583d3 RDI: 000000005430cc72
RBP: ffff8880784e7240 R08: 00000000498c1a10 R09: 0000000000000000
R10: 0000000000000001 R11: 000000000008c07c R12: 0000000000000001
R13: 0000000000008dc0 R14: ffffc9001499ebf8 R15: 0000000000000016
 kasan_save_stack+0x2e/0x40 mm/kasan/common.c:39
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 ref_tracker_alloc+0x14c/0x550 lib/ref_tracker.c:85
 __netdev_tracker_alloc include/linux/netdevice.h:3995 [inline]
 netdev_hold include/linux/netdevice.h:4024 [inline]
 netdev_hold include/linux/netdevice.h:4019 [inline]
 neigh_parms_alloc+0x255/0x5f0 net/core/neighbour.c:1707
 inetdev_init+0x133/0x580 net/ipv4/devinet.c:269
 inetdev_event+0xa85/0x1610 net/ipv4/devinet.c:1534
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 register_netdevice+0x10bb/0x1670 net/core/dev.c:10086
 veth_newlink+0x338/0x990 drivers/net/veth.c:1764
 rtnl_newlink_create net/core/rtnetlink.c:3364 [inline]
 __rtnl_newlink+0x1087/0x17e0 net/core/rtnetlink.c:3581
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3594
 rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6091
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2540
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f83f168a5a9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f83f2834168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f83f17abf80 RCX: 00007f83f168a5a9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000007
RBP: 00007f83f16e5580 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffcf014405f R14: 00007f83f2834300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rose_send_frame+0x1dd/0x2f0 net/rose/rose_link.c:101
Code: 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 8d bd 80 03 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ea 00 00 00 4c 8b bd 80 03 00 00 e9 77 fe ff ff
RSP: 0018:ffffc90000007b00 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88802690b800 RCX: 0000000000000100
RDX: 0000000000000070 RSI: ffffffff88514482 RDI: 0000000000000380
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88802690b800
R13: 0000000000000078 R14: ffff88802f169640 R15: 0000000000000010
FS:  00007f83f2834700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff318aaf940 CR3: 0000000063a3f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 06 01 00 00    	jne    0x114
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	48 8b 6b 20          	mov    0x20(%rbx),%rbp
  1c:	48 8d bd 80 03 00 00 	lea    0x380(%rbp),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 ea 00 00 00    	jne    0x11e
  34:	4c 8b bd 80 03 00 00 	mov    0x380(%rbp),%r15
  3b:	e9 77 fe ff ff       	jmpq   0xfffffeb7


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
