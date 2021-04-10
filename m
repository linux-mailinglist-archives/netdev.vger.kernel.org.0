Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BE235AE82
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhDJOtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:49:33 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:46829 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbhDJOtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:49:32 -0400
Received: by mail-il1-f198.google.com with SMTP id u19so5312760ilj.13
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 07:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=opHa0na1CTuYC9MsrnRbiN8M/7f6oGgvd1rRpihSqxk=;
        b=V1keL9dwkJxSrp0jfS3wowzlNAC31EvN9L0f19OkgcuotOxnhEzc8YrY0C9ZN++lcU
         RfBoJSspxAIaR4hZNyv1m7yWyT1tEEZ7DRG0fQrTCiera3xPVspZ9pbkKl7FZyoffGzm
         VcMU/wXtJGOexBt8yIX7g5ySYk1/CyW0pW/rpTdU2LHeQadpAttmJWTFU9GZXoAEYACY
         S388ZXFOqf/5v+egKHsv6MBCuBTk00VaF6esIXx+Hd5PL+nMSbrgbAfLedli2RNsYbUw
         /9XVkVyFBj+sRV9HeB/gzVVP3XvpQjZwfBcBW3Bj3InHMi9ksTQgjoTWMWXwFQW3VsFa
         qiKg==
X-Gm-Message-State: AOAM531PoH32YkpZj6WFhJ56GRl3EfyVSZJ0piY+bWxE1aWbq393JgwP
        haBDb2ftOMIrHSRqBf6uiehYKgEAFAl0dz65CPOy0oISvAwC
X-Google-Smtp-Source: ABdhPJzmuxOdgQKaxS7S9qWO0NPoMt6qdJ6W4pNfEE/zt863VeL0o1dCb3hHd8Xpac2ijJbI27cozeq1zHyDFtzuGY07GEEFumJz
MIME-Version: 1.0
X-Received: by 2002:a6b:5002:: with SMTP id e2mr15370368iob.43.1618066157659;
 Sat, 10 Apr 2021 07:49:17 -0700 (PDT)
Date:   Sat, 10 Apr 2021 07:49:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ce91e05bf9f62bc@google.com>
Subject: [syzbot] WARNING in __nf_unregister_net_hook (4)
From:   syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cc0626c2 net: smsc911x: skip acpi_device_id table when !CO..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=110a3096d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=154bd5be532a63aa778b

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com

hook not found, pf 2 num 0
WARNING: CPU: 1 PID: 8144 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 1 PID: 8144 Comm: syz-executor.0 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 e0 26 6c 8a e8 72 df 87 01 <0f> 0b e9 e5 00 00 00 e8 09 1d 37 fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc9001534f418 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88802f867a00 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815c5205 RDI: fffff52002a69e75
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdf9e R11: 0000000000000000 R12: ffff8880272c8f20
R13: 0000000000000000 R14: ffff88802fa34c00 R15: 0000000000000006
FS:  00007feaf7d10700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb651f70ca0 CR3: 0000000069f31000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_unregister_net_hook+0xd5/0x110 net/netfilter/core.c:502
 nf_tables_unregister_hook.part.0+0x131/0x200 net/netfilter/nf_tables_api.c:234
 nf_tables_unregister_hook net/netfilter/nf_tables_api.c:8122 [inline]
 nf_tables_commit+0x1d9b/0x4710 net/netfilter/nf_tables_api.c:8122
 nfnetlink_rcv_batch+0x975/0x21b0 net/netfilter/nfnetlink.c:508
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:580 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:598
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feaf7d10188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 000000002000c2c0 RDI: 0000000000000003
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffe0fcaf04f R14: 00007feaf7d10300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
