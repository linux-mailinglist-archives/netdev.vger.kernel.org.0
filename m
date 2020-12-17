Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6E2DD5A5
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgLQRD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:03:56 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:49370 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728705AbgLQRDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:03:51 -0500
Received: by mail-io1-f70.google.com with SMTP id m19so27530947iow.16
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 09:03:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pxFfrTkIii6iJjyvF009RrzuDe3n5utIm9WDPVKtgGg=;
        b=e7HuEIavZcLHydsKGgSqEJEhsXLZHi3FZj+0Me1Dm0nUTeexKEfdvKYmtLiVoNUape
         J3ApwXB9aomrL8yoA5Jprr1+n+iWmQ4THOvseYcYxS/RZzyF7YXHxd96QJ3Q1JbGBxfM
         TLGvFvPi43AcMTTXA0AXmDcGWobcJkSvRLJ8fmjsD1CetuEhbdtuUDhdCel0nK9YtYke
         mjGq8UPV4jbBK+vsUWamRGRu4sXQOUBgaCOH4eaJZ1/5qie4ML11fme+zH0qooYxChX4
         gjHg1quJ9JSgJKN63N08Tz/WE+IZRZ8/gm+ZSd08ieGbzthIpWuh3jbr1x1ECGtNw2ab
         h15Q==
X-Gm-Message-State: AOAM530S6sZ7oqLz2ITPZoHJs1HAzlrW+LdODCdYjfoFULgWIN8Ikwrb
        iaLm7kYy2AYylJdL5IjzLU4gT+//U+KHX9VtapU2sqeS9jYb
X-Google-Smtp-Source: ABdhPJxqR3ejZ43331MFX9g47oKWaI79oYRHV//M9fr5YfFFU9oGUJkfsG/FNkdZk9dJJoqH5l+ELqKb/RrIyR37uB47tGG2WqIn
MIME-Version: 1.0
X-Received: by 2002:a92:cb82:: with SMTP id z2mr51635770ilo.195.1608224590079;
 Thu, 17 Dec 2020 09:03:10 -0800 (PST)
Date:   Thu, 17 Dec 2020 09:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000692e2f05b6abf7c5@google.com>
Subject: general protection fault in bond_ipsec_add_sa
From:   syzbot <syzbot+cfd446c119a93741a3c2@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6bff9bb8 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14aba80f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a438b63f5a7f3806
dashboard link: https://syzkaller.appspot.com/bug?extid=cfd446c119a93741a3c2
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfd446c119a93741a3c2@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 3 PID: 10570 Comm: syz-executor.0 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:bond_ipsec_add_sa+0x9e/0x240 drivers/net/bonding/bond_main.c:396
Code: 04 31 ff 89 c3 89 c6 e8 f0 2c d8 fc 85 db 0f 85 f6 00 00 00 e8 93 34 d8 fc 4c 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 5f 01 00 00 48 8d bd d0 02 00 00 49 8b 5d 00 48
RSP: 0018:ffffc90002e47498 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffc90006ee9000
RDX: 0000000000000000 RSI: ffffffff8497d16d RDI: 0000000000000001
RBP: ffff888016539c00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88806c230000
R13: 0000000000000000 R14: ffff888016539ee0 R15: ffff888016539ee4
FS:  00007f5eca4f9700(0000) GS:ffff88802cd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000007120d0 CR3: 0000000050d1d000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xfrm_dev_state_add+0x2da/0x7b0 net/xfrm/xfrm_device.c:268
 xfrm_state_construct net/xfrm/xfrm_user.c:655 [inline]
 xfrm_add_sa+0x2166/0x34f0 net/xfrm/xfrm_user.c:684
 xfrm_user_rcv_msg+0x42f/0x8b0 net/xfrm/xfrm_user.c:2752
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dcd9
Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5eca4f8c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045dcd9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004aae00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf40
R13: 00007ffcc1582edf R14: 00007f5eca4d9000 R15: 0000000000000003
Modules linked in:
---[ end trace f71849d5db08409b ]---
RIP: 0010:bond_ipsec_add_sa+0x9e/0x240 drivers/net/bonding/bond_main.c:396
Code: 04 31 ff 89 c3 89 c6 e8 f0 2c d8 fc 85 db 0f 85 f6 00 00 00 e8 93 34 d8 fc 4c 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 5f 01 00 00 48 8d bd d0 02 00 00 49 8b 5d 00 48
RSP: 0018:ffffc90002e47498 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffc90006ee9000
RDX: 0000000000000000 RSI: ffffffff8497d16d RDI: 0000000000000001
RBP: ffff888016539c00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88806c230000
R13: 0000000000000000 R14: ffff888016539ee0 R15: ffff888016539ee4
FS:  00007f5eca4f9700(0000) GS:ffff88802cd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
