Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79ED1145975
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgAVQJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:09:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:54802 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVQJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:09:10 -0500
Received: by mail-io1-f70.google.com with SMTP id k25so2143435ios.21
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 08:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GI2UC+EvXROYNmjkTcEuNtASvZJIsELjrqLPTni5rAA=;
        b=t+VmvRTXc3SelUms/Z1da+yqPp9POZ1GaspYVFXS/idc8wdNs20d0W4IsEgVzlTw/s
         bp20LloDSZVnSYs76hnKdggk0MxBCo0lashKlJvHE/cmoxCeSmVb4ls2nd4uHnSaweID
         WAc21CDH+lK71450u+DchNzihhLdPtRbU2Vm7NLg9QOcBiUU9RuaoufcPgM/erMPkfP7
         myZtFgEb60EY4gaKtUY2XKpDNac5SVcAYIx/c724aWs8yfXozgMj77aUEwFAalf5qEgN
         1XcvwHLaS7AzoFo+rrDyujny1norF6ZHcEsnf333bWHibDEXHZBxd+gy0FcoGveH/jVI
         /1CA==
X-Gm-Message-State: APjAAAVjXzsIhABRSTWS9hMax4qrxAY/lF3SwTdYxV4Lyg9xukZRJ0MK
        NERsIfOgD16H4218jXj/aKt587aOTlEuyF5dnhFV2cY6/Rc3
X-Google-Smtp-Source: APXvYqwy96Pw21+yzNQcbf6JHU7+E1XD4Vfq/3emwqiLloiSvNJ1sFs3swAMB/QgCSwXx5GSnMq/N+CNpQ4nTzKOfrQXkwPIOX0N
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:10d1:: with SMTP id s17mr8898273ilj.198.1579709349585;
 Wed, 22 Jan 2020 08:09:09 -0800 (PST)
Date:   Wed, 22 Jan 2020 08:09:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a16ad7059cbcbe43@google.com>
Subject: WARNING in bpf_warn_invalid_xdp_action
From:   syzbot <syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d0f41851 net, ip_tunnel: fix namespaces move
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10e94d85e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=8ce4113dadc4789fac74
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f99369e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d85601e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com

------------[ cut here ]------------
Illegal XDP return value 4294967274, expect packet loss!
WARNING: CPU: 0 PID: 9780 at net/core/filter.c:6918 bpf_warn_invalid_xdp_action net/core/filter.c:6918 [inline]
WARNING: CPU: 0 PID: 9780 at net/core/filter.c:6918 bpf_warn_invalid_xdp_action+0x77/0x90 net/core/filter.c:6914
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9780 Comm: syz-executor429 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:bpf_warn_invalid_xdp_action net/core/filter.c:6918 [inline]
RIP: 0010:bpf_warn_invalid_xdp_action+0x77/0x90 net/core/filter.c:6914
Code: 00 f9 d6 88 41 83 fc 04 48 c7 c6 40 f9 d6 88 4c 0f 46 ee e8 2b 9e 49 fb 44 89 e2 48 c7 c7 80 f9 d6 88 4c 89 ee e8 18 4e 1a fb <0f> 0b e8 12 9e 49 fb 5b 41 5c 41 5d 5d c3 90 66 2e 0f 1f 84 00 00
RSP: 0018:ffffc900000079a8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815e5326 RDI: fffff52000000f27
RBP: ffffc900000079c0 R08: ffff88809ff963c0 R09: ffffed1015d045c9
R10: ffffed1015d045c8 R11: ffff8880ae822e43 R12: 00000000ffffffea
R13: ffffffff88d6f900 R14: ffff8880927ea110 R15: ffff88809e257180
 netif_receive_generic_xdp net/core/dev.c:4564 [inline]
 do_xdp_generic.part.0+0xebb/0x1790 net/core/dev.c:4613
 do_xdp_generic net/core/dev.c:4985 [inline]
 __netif_receive_skb_core+0x68b/0x30b0 net/core/dev.c:4985
 __netif_receive_skb_one_core+0xa8/0x1a0 net/core/dev.c:5148
 __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5264
 process_backlog+0x206/0x750 net/core/dev.c:6095
 napi_poll net/core/dev.c:6532 [inline]
 net_rx_action+0x508/0x1120 net/core/dev.c:6600
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:console_unlock+0xbb8/0xf00 kernel/printk/printk.c:2481
Code: 93 89 48 c1 e8 03 42 80 3c 30 00 0f 85 e4 02 00 00 48 83 3d c1 43 35 08 00 0f 84 91 01 00 00 e8 3e 05 17 00 48 8b 7d 98 57 9d <0f> 1f 44 00 00 e9 6d ff ff ff e8 29 05 17 00 48 8b 7d 08 c7 05 1b
RSP: 0018:ffffc90001f26b38 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: ffff88809ff963c0 RBX: 0000000000000200 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffffffff815defe2 RDI: 0000000000000293
RBP: ffffc90001f26bc0 R08: 1ffffffff165e79c R09: fffffbfff165e79d
R10: fffffbfff165e79c R11: ffffffff8b2f3ce7 R12: 0000000000000000
R13: ffffffff84b35860 R14: dffffc0000000000 R15: ffffffff8a0fc990
 vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1996
 vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
 vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
 printk+0xba/0xed kernel/printk/printk.c:2056
 validate_nla lib/nlattr.c:178 [inline]
 __nla_validate_parse.cold+0x4d/0x60 lib/nlattr.c:381
 __nla_parse+0x43/0x60 lib/nlattr.c:478
 nla_parse_nested_deprecated include/net/netlink.h:1166 [inline]
 do_setlink+0x2ca2/0x3720 net/core/rtnetlink.c:2773
 rtnl_group_changelink net/core/rtnetlink.c:3089 [inline]
 __rtnl_newlink+0xdd2/0x1790 net/core/rtnetlink.c:3243
 rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3363
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442af9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd3ded00a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442af9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007ffd3ded00c0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000404090 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
