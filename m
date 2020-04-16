Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7748A1AC191
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636034AbgDPMn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 08:43:28 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:45453 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635975AbgDPMnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 08:43:14 -0400
Received: by mail-io1-f71.google.com with SMTP id y4so19385879ioy.12
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 05:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=v779y82BJy6MKZS+0kJTYe+V/6NgiP+kTl/bmTEDrfc=;
        b=Fs4dVU/5uBZrknMn0TsqeGs+53ggbOQ962zVE3Ya4RpI5WG1kd5ZcdNVrvUGEF//PU
         1i0+Z22MkIt6pxTpqPiC6/CW3ZbhJmC4Xm9vGbnXNKDEoY5901dgjZnbBWqQGfK7I7wh
         CX1OI81gcIexV2fgW0Oov3GP2X8BQzjv9Ww7xGwR/dCf4cGjpP5lcaUH1lYsjWEaAf4b
         6QoKDPq69MKu2aUQLJ4cH6Dx/5DsYWAOXEd2KZxkI5o0QqBwXjWJS82fdGi+b34cm9Re
         0Bw7ZGnNzrTo8l2gTDksg4UkW8DdDHCn3O9M7tsj52122aK821TfloVXAWsB3SLhZ48r
         QeFw==
X-Gm-Message-State: AGi0PuZkofoSYsGPLMwWc9khrNAXrX1n+O9p1H42TyU00qMm0fVGj+y0
        3VWnun/0C0zBHUq4hTdDptAAkiwqHE7cctaqLwwxBYgtpL9I
X-Google-Smtp-Source: APiQypKMnYxPxaGGAl2cOD7eeEOXoMXsFbWYPyW/ZxxwTU6g7/qemE6/IycCIRdOSdAIACf+ehAkYyrhfCZKrCrjeNAeOKwjcr2S
MIME-Version: 1.0
X-Received: by 2002:a92:750f:: with SMTP id q15mr10663775ilc.146.1587040993304;
 Thu, 16 Apr 2020 05:43:13 -0700 (PDT)
Date:   Thu, 16 Apr 2020 05:43:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a6661c05a367c669@google.com>
Subject: WARNING in fib6_add (4)
From:   syzbot <syzbot+5f122ebd258b7e43e492@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1a323ea5 x86: get rid of 'errret' argument to __get_user_x..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=143443b3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
dashboard link: https://syzkaller.appspot.com/bug?extid=5f122ebd258b7e43e492
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5f122ebd258b7e43e492@syzkaller.appspotmail.com

IPv6: NLM_F_REPLACE set, but no existing node found!
------------[ cut here ]------------
WARNING: CPU: 0 PID: 31420 at net/ipv6/ip6_fib.c:1501 fib6_add+0x3405/0x3df0 net/ipv6/ip6_fib.c:1501
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 31420 Comm: syz-executor.4 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:fib6_add+0x3405/0x3df0 net/ipv6/ip6_fib.c:1501
Code: df 48 8d bb d0 09 00 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 7b 08 00 00 48 8b 9b d0 09 00 00 e9 45 f6 ff ff e8 6b 67 b2 fa <0f> 0b 48 b8 00 00 00 00 00 fc ff df 48 8b 54 24 20 48 c1 ea 03 80
RSP: 0018:ffffc90015df7488 EFLAGS: 00010202
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90011987000
RDX: 00000000000069f0 RSI: ffffffff86c081f5 RDI: ffff88809a03e3a0
RBP: ffff8880952fb3a0 R08: ffff8880643820c0 R09: ffffed1013edef06
R10: ffffed1013edef05 R11: ffff88809f6f782f R12: 00000000fffffffe
R13: 0000000000000000 R14: ffff8880952fb380 R15: 0000000000000000
 __ip6_ins_rt+0x4f/0x70 net/ipv6/route.c:1313
 ip6_route_add+0x58/0x120 net/ipv6/route.c:3705
 inet6_rtm_newroute+0x152/0x160 net/ipv6/route.c:5330
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1f04409c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1f0440a6d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f5 R14: 00000000004ccb09 R15: 000000000076bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
