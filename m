Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632681376B4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgAJTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:10:11 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:41062 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbgAJTKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:10:10 -0500
Received: by mail-il1-f198.google.com with SMTP id k9so2193511ili.8
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 11:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Fpulm56jnIDKor22tcvA1eRJbZCimtEL4pawhkUJ8ck=;
        b=AMYiPiAqMPG4bA4L7I8nJWDMCFrfuZT/DKd8wT7CNkMa/H2HcpqSRq2XWvpOo2z8A2
         XWKUADLf1i4btakoypRCQbD/HxMEWxdDoKUrENmTyJmiv5HXLk1WFZPYvb0XEd8ciEh7
         37w6eaOFwzScu5c5d6SwSqFurtWGWxAzgppZe/53ZIGgmn+gO0G0+CyWba4uZ8vFYXjT
         JyoD2Qr6qA1MxORHpBNcBNuHD5qIO3RRbtYyTZao2ijxzwVQ4qbXl3X9YAI5cNVVZVij
         En/ch1azRDKD8L0Zsp/bfAz9zW0hxYQK7xdAXMeUS8tsd+n7OUvOCoB5SOAs9cmGpoHH
         8vLA==
X-Gm-Message-State: APjAAAXXe9okMmiGE4zXzkISVaRm3FPuy1q2bBCitFc2yoYoYHpdf6jJ
        PDn09JSKt6XzDaPXVv9/HK+M77eillPIvWCofZRmjv2oqM6l
X-Google-Smtp-Source: APXvYqxo7Txz3ieDkwBzYiYJ0uqOK7z8Em12aZpe8cSMm1Zupf8b1SsbdDges4f7ruezhYpk20vKlSYSeT7RmvwfJNOfqZbinBwK
MIME-Version: 1.0
X-Received: by 2002:a5d:85ce:: with SMTP id e14mr3629651ios.181.1578683410026;
 Fri, 10 Jan 2020 11:10:10 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:10:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de1d10059bcddf2b@google.com>
Subject: WARNING in xfrm_policy_inexact_insert (2)
From:   syzbot <syzbot+f9c439e84c4337e80301@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9f120e76 Merge branch 'mptcp-prereq'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17bdd5c6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c9f1de9846a3cafd
dashboard link: https://syzkaller.appspot.com/bug?extid=f9c439e84c4337e80301
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f9c439e84c4337e80301@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 15165 at net/xfrm/xfrm_policy.c:1508  
xfrm_policy_insert_inexact_list net/xfrm/xfrm_policy.c:1508 [inline]
WARNING: CPU: 0 PID: 15165 at net/xfrm/xfrm_policy.c:1508  
xfrm_policy_inexact_insert+0x4cc/0xba0 net/xfrm/xfrm_policy.c:1197
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 15165 Comm: syz-executor.2 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
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
RIP: 0010:xfrm_policy_insert_inexact_list net/xfrm/xfrm_policy.c:1508  
[inline]
RIP: 0010:xfrm_policy_inexact_insert+0x4cc/0xba0 net/xfrm/xfrm_policy.c:1197
Code: b2 fa 48 8b 7d b8 31 f6 e8 41 8b ff ff e8 6c dc b2 fa 48 8b 45 d0 48  
83 c4 70 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 54 dc b2 fa <0f> 0b 44 8b 6d  
ac 8b 5d a4 44 89 ee 89 df e8 41 dd b2 fa 44 39 eb
RSP: 0018:ffffc90001857378 EFLAGS: 00010212
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc9000e2de000
RDX: 0000000000001fc2 RSI: ffffffff86c2554c RDI: ffff88808c310220
RBP: ffffc90001857410 R08: ffff88804d7801c0 R09: ffff88804d780a50
R10: fffffbfff14f7c30 R11: ffffffff8a7be187 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88808c310000 R15: dffffc0000000000
  xfrm_policy_insert+0x597/0x7f0 net/xfrm/xfrm_policy.c:1576
  xfrm_add_policy+0x28f/0x580 net/xfrm/xfrm_user.c:1670
  xfrm_user_rcv_msg+0x459/0x770 net/xfrm/xfrm_user.c:2676
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  xfrm_netlink_rcv+0x70/0x90 net/xfrm/xfrm_user.c:2684
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:672
  ____sys_sendmsg+0x753/0x880 net/socket.c:2343
  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
  __do_sys_sendmsg net/socket.c:2439 [inline]
  __se_sys_sendmsg net/socket.c:2437 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f56bf01bc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f56bf01c6d4
R13: 00000000004caa15 R14: 00000000004e3e90 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
