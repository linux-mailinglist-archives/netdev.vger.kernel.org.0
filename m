Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2AD1BB593
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgD1E5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:57:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33688 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgD1E5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:57:17 -0400
Received: by mail-io1-f70.google.com with SMTP id w4so22925206iol.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 21:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZV01R4Rfh//ftaS9u0h5nnyPh8mGFGoEaKBqLBJ+PhA=;
        b=tJGGrtV6jqnG9kRSk1c7PxkkCQuY2qbh3w5WpE/oVfXJu9iQ0e6ijN6ResRklsKFno
         y3c9N6iexv+elx6wDpETUE8Utpkv/fs0MescJMXyEr/O1AEX630d3KAFr2BG60oi3CkX
         h+y5EKkTKFyLfUkAzgTMeEjE35vyFMRoMD0qy0AaMZ2Agj8kK2Dr8bbPT7/s4uAbeuGx
         q9B3KXhep+HP1NBkhk7qdkut9mb9Tj/J4Cec28x+BQ56tWMpT+NZSfafv7TTdOdaJrMQ
         nzbXhSUpm2nIAPYUG32o/2FaAxgLDrN2I/4ll05X38iaVy6BhAU5uMi3vnOOS8tuDixg
         xPgw==
X-Gm-Message-State: AGi0PuZN36Hslki57ixbrwDC/swXsrt2MxAwz0D90h4yyWXYpcZPW3Wg
        v2AWfL1h2LkJdh5OXyNqRNCYWieGmbCHs4tctsisIy4JUnwR
X-Google-Smtp-Source: APiQypLm4EYoiuWjEEX/tVEqbN7rQJT4JFv8IY+bt4VBDA6gSdM17q12nkYGroZZQa2EVxwUbdRIREKmbSUvGxr2K0HkPdSuIzg/
MIME-Version: 1.0
X-Received: by 2002:a92:4152:: with SMTP id o79mr25364271ila.198.1588049836233;
 Mon, 27 Apr 2020 21:57:16 -0700 (PDT)
Date:   Mon, 27 Apr 2020 21:57:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fe17f05a452aa76@google.com>
Subject: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+01d3835be1106c3083ba@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1640c1bbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=01d3835be1106c3083ba
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+01d3835be1106c3083ba@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 2 num 4
WARNING: CPU: 1 PID: 25658 at net/netfilter/core.c:413 __nf_unregister_net_hook+0x1ef/0x470 net/netfilter/core.c:413
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 25658 Comm: syz-executor.0 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
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
RIP: 0010:__nf_unregister_net_hook+0x1ef/0x470 net/netfilter/core.c:413
Code: 0f b6 14 02 4c 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 83 02 00 00 8b 53 1c 89 ee 48 c7 c7 c0 cd e1 88 e8 19 4e e5 fa <0f> 0b e9 ec 00 00 00 e8 35 19 14 fb 48 8b 04 24 48 c1 e0 04 49 8d
RSP: 0018:ffffc900056b73b8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff888094aa6600 RCX: 0000000000000000
RDX: 000000000000ad97 RSI: ffffffff815ce211 RDI: fffff52000ad6e69
RBP: 0000000000000002 R08: ffff888046f3c100 R09: fffffbfff1862745
R10: ffffffff8c313a27 R11: fffffbfff1862744 R12: ffff88808e97cfa8
R13: 0000000000000000 R14: ffff8880931a2300 R15: ffff888094aa661c
 nf_unregister_net_hook+0x59/0xa0 net/netfilter/core.c:431
 nft_unregister_basechain_hooks net/netfilter/nf_tables_api.c:206 [inline]
 nft_table_disable+0x262/0x2c0 net/netfilter/nf_tables_api.c:835
 nf_tables_table_disable net/netfilter/nf_tables_api.c:868 [inline]
 nf_tables_commit+0x2cf8/0x3a20 net/netfilter/nf_tables_api.c:7350
 nfnetlink_rcv_batch+0xcd7/0x1610 net/netfilter/nfnetlink.c:485
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
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
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd703062c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fe200 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 000000002000c2c0 RDI: 0000000000000005
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000095d R14: 00000000004cc104 R15: 00007fd7030636d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
