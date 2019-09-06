Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00114ABE4B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbfIFRIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:08:12 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38773 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730617AbfIFRIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:08:12 -0400
Received: by mail-io1-f71.google.com with SMTP id m5so8457289ioj.5
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 10:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3njUJ/0K0qrTjvC4IVkpaDi9DWyHseTccD0yHkZDLBs=;
        b=khIDEqArq1zuUFhhZ7XPXAm3GSa4enucsPvWIkOJUj3J6a7yhIZyFF0jpXA5gtTzrg
         DYQRVGAGydsoVLEYSEo3eoY73mZo4DOk10p1bVxSLIsjkEbmBV3mnrKiqZ7EI1lIjcRX
         LnsksmyHxrrGlkZDl7+DyWcu2zwCh5UC513D6BT48r++VNDmlKxGmH/Hh+LwSnuKszPy
         YsV9vWKw09XOLx7AZkHuxjyIsIvnVrttUcByYxDgU/vaeCS3949YkT116oAAYin6o+t+
         0r8geMb008g5083cosDBGY+W6A7tJVXB1a4Kw4UNB0lde4DcPNhzKoeyYGkGbPJ38peC
         iM9A==
X-Gm-Message-State: APjAAAVY2gt5SAHK/ypENUdJyOokig+yZXb33FSHr/TsZ31YPKJp73Tv
        +E1EtCqY+Fxy3RlP6Us6LXpExMFAE5N+Wp8NTLmPeQPNYFTI
X-Google-Smtp-Source: APXvYqz9DzyEOIuFEOWT1ID4gU21+TU8AcogcmcruNwfteNhsHUn/47ie2zC7VAaiNoCcRLtp+EuV9DagCJQWPfB8T4QNoRDZ2WA
MIME-Version: 1.0
X-Received: by 2002:a02:9994:: with SMTP id a20mr4651152jal.107.1567789691067;
 Fri, 06 Sep 2019 10:08:11 -0700 (PDT)
Date:   Fri, 06 Sep 2019 10:08:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e73be0591e57b89@google.com>
Subject: WARNING in xfrm_policy_insert_list (2)
From:   syzbot <syzbot+2714fa4a72156aa7e18a@syzkaller.appspotmail.com>
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

HEAD commit:    0e5b36bc r8152: adjust the settings of ups flags
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17932ec6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=67b69b427c3b2dbf
dashboard link: https://syzkaller.appspot.com/bug?extid=2714fa4a72156aa7e18a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e5cb2a600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14eba03e600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2714fa4a72156aa7e18a@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8725 at net/xfrm/xfrm_policy.c:1541  
xfrm_policy_insert_list.cold+0x11/0x90 net/xfrm/xfrm_policy.c:1541
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8725 Comm: syz-executor575 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:219
  __warn.cold+0x20/0x4c kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:xfrm_policy_insert_list.cold+0x11/0x90 net/xfrm/xfrm_policy.c:1541
Code: f0 79 fb e9 67 fa ff ff 88 55 c0 e8 e9 f0 79 fb 0f b6 55 c0 e9 83 fa  
ff ff e8 9b cc 3f fb 48 c7 c7 a0 20 52 88 e8 e3 6b 29 fb <0f> 0b 48 8b 45  
b8 42 0f b6 14 20 48 8b 45 d0 83 e0 07 83 c0 03 38
RSP: 0018:ffff88808f7ff3a0 EFLAGS: 00010282
RAX: 0000000000000024 RBX: ffff8880a1ac0040 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c26f6 RDI: ffffed1011effe66
RBP: ffff88808f7ff420 R08: 0000000000000024 R09: ffffed1015d060d1
R10: ffffed1015d060d0 R11: ffff8880ae830687 R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880a410b240
  xfrm_policy_inexact_insert+0xec/0x1000 net/xfrm/xfrm_policy.c:1188
  xfrm_policy_insert+0x530/0x750 net/xfrm/xfrm_policy.c:1574
  xfrm_add_policy+0x28f/0x530 net/xfrm/xfrm_user.c:1670
  xfrm_user_rcv_msg+0x459/0x770 net/xfrm/xfrm_user.c:2676
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  xfrm_netlink_rcv+0x70/0x90 net/xfrm/xfrm_user.c:2684
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442209
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffceda47ad8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a3298 RCX: 0000000000442209
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000000f970 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000403030
R13: 00000000004030c0 R14: 0000000000000000 R15: 0000000000000000
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
