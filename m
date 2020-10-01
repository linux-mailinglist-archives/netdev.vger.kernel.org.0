Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB46628096E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbgJAVcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:32:17 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56644 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730147AbgJAVcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:32:16 -0400
Received: by mail-il1-f198.google.com with SMTP id d16so117305ila.23
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 14:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ZmmhCPSV2yuVdiNMfX2E/gWsiasW2ZIKGSc1ceHT8IA=;
        b=sCxQE9amLRiX1XiJe2u3zn2lctjB5kSzsLhvai6RmpiiBos6dDCEXbWtmDZMgWWZVz
         PAz7eaC+4CDjvCnFyvrI4D9AVwoejCujsIyzQs6QLbUvBia0jCd4cy3sCvQo0y2uDMQ4
         2Lp+tmtc/2lQxcp4ifgkM24GjgiriO7FMOurN7ru9SbUUbudk1oC54zgFuip0D6KLYgF
         8swb9LAuCoZAj5OtEMGW+eaCQA7ODpA+emAJlMYKfAwnkbkUKn6fc/R+1hiFFKr6AukN
         IZcpVy907vpnwizgQ0naloErtkskHf3osy6mHt4zGvMrbbTcWftXRXLfcDON10lpuqJF
         howQ==
X-Gm-Message-State: AOAM531+RXXqZ0LL4K/HFPEDgIO6yFj8XuB3zbkliO+0zDOWLmNCHLtW
        ihY/47Z7AWNPBCMK/6q8kUGyBONxMbpi85FfSCohqKjlaD+s
X-Google-Smtp-Source: ABdhPJy/AYl890p55pbZI0m5U9ns3Irtm4NtzihUovqDGpGYM6HicnCoHbnVTOXfYcZeSyBjsb8Mik29hIVzL6YD8wv+svCNCsNJ
MIME-Version: 1.0
X-Received: by 2002:a92:849a:: with SMTP id y26mr502397ilk.38.1601587935781;
 Thu, 01 Oct 2020 14:32:15 -0700 (PDT)
Date:   Thu, 01 Oct 2020 14:32:15 -0700
In-Reply-To: <0000000000007b357405b099798f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd29d205b0a2bf28@google.com>
Subject: Re: WARNING in cfg80211_connect
From:   syzbot <syzbot+5f9392825de654244975@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    87d5034d Merge tag 'mlx5-updates-2020-09-30' of git://git...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=121d2313900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b5cc8ec2218e99d
dashboard link: https://syzkaller.appspot.com/bug?extid=5f9392825de654244975
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1100d333900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1414c997900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f9392825de654244975@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6914 at net/wireless/sme.c:533 cfg80211_sme_connect net/wireless/sme.c:533 [inline]
WARNING: CPU: 0 PID: 6914 at net/wireless/sme.c:533 cfg80211_connect+0x1432/0x2010 net/wireless/sme.c:1258
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6914 Comm: syz-executor935 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:cfg80211_sme_connect net/wireless/sme.c:533 [inline]
RIP: 0010:cfg80211_connect+0x1432/0x2010 net/wireless/sme.c:1258
Code: 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 a2 0a 00 00 49 83 bd 48 01 00 00 00 0f 84 b6 f7 ff ff e8 7e 1e b5 f9 <0f> 0b e8 77 1e b5 f9 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90005667360 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888093bdc380 RSI: ffffffff87c166d2 RDI: ffffffff896172c0
RBP: ffff888088cf8d30 R08: 0000000000000001 R09: ffff888088cf8d35
R10: ffffed101119f1a6 R11: 0000000000000000 R12: ffffc90005667500
R13: ffff888088cf8c10 R14: ffff888088cf8d58 R15: ffffffff89617180
 nl80211_connect+0x1646/0x2220 net/wireless/nl80211.c:10615
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
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
RIP: 0033:0x442139
Code: e8 ac 00 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff18327468 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442139
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000002000000000 R09: 0000002000000000
R10: 0000002000000000 R11: 0000000000000246 R12: 000000000000f7cb
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004
Kernel Offset: disabled
Rebooting in 86400 seconds..

