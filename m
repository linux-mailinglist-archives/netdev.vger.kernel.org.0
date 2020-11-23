Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE72C051C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgKWL61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:58:27 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:48293 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbgKWL60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:58:26 -0500
Received: by mail-il1-f197.google.com with SMTP id o5so13582674ilh.15
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GII5wb55BcGoK17FQD+D4wlIOXUNYyxXwV/VNx19JEU=;
        b=qIZW1uz7t3KAQlTKMZW9Dvecp1iqT5ZvuhZ6qmL2FR8lWKBkGgtBs8Yf9v+XivOfe3
         Gv69fI5zzJfY5f7vQtZBcD+SUlvTB8CuPpOmYIchJo+mgMASZQRADqBFst+UFbC1YTBa
         iAYe3Q1AFlTlbtwYUYfTgVLO2crjEP87eNEM3ekakhzTDhPS/n6vVhNYk3r5YEX2nL/2
         P1feO/1MAHQLMDYH/fEuQsI4NUpkqHE45lmALLTMVpk6YHLLq6Voyq9boEQqh9J3rwzj
         f1Rf8Zz5Bq3Dlot0w86E80Zyn61gxXQrszgmPbaUBGUWiNIva5/X/D2pfnbB1fblS5RT
         fClw==
X-Gm-Message-State: AOAM530FM0g93voVo1t8/nmHdCpobZ79Em06UvXschRUuvFtdi7jIBou
        AVLCKbKqJC4Znv3VgGQseoMTbMJdVGJlSItbFpsIk6vKcS21
X-Google-Smtp-Source: ABdhPJwgFiEFZPZfYE1dT256msp/xMCSnH3eB1ouYqARis1GP2XR4ux5tksYGflbQFm8tF8DUfuYah4tn1Wn81VaFNW76Woyv4AD
MIME-Version: 1.0
X-Received: by 2002:a5e:dc06:: with SMTP id b6mr33454802iok.121.1606132703402;
 Mon, 23 Nov 2020 03:58:23 -0800 (PST)
Date:   Mon, 23 Nov 2020 03:58:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041019205b4c4e9ad@google.com>
Subject: BUG: receive list entry not found for dev vxcan1, id 002, mask C00007FF
From:   syzbot <syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c2e7554e Merge tag 'gfs2-v5.10-rc4-fixes' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117f03ba500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75292221eb79ace2
dashboard link: https://syzkaller.appspot.com/bug?extid=381d06e0c8eaacb8706f
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com

------------[ cut here ]------------
BUG: receive list entry not found for dev vxcan1, id 002, mask C00007FF
WARNING: CPU: 1 PID: 12946 at net/can/af_can.c:546 can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
Modules linked in:
CPU: 1 PID: 12946 Comm: syz-executor.1 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
Code: 8b 7c 24 78 44 8b 64 24 68 49 c7 c5 20 ac 56 8a e8 01 6c 97 f9 44 89 f9 44 89 e2 4c 89 ee 48 c7 c7 60 ac 56 8a e8 66 af d3 00 <0f> 0b 48 8b 7c 24 28 e8 b0 25 0f 01 e9 54 fb ff ff e8 26 e0 d8 f9
RSP: 0018:ffffc90017e2fb38 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880147a8000 RSI: ffffffff8158f3c5 RDI: fffff52002fc5f59
RBP: 0000000000000118 R08: 0000000000000001 R09: ffff8880b9f2011b
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: ffff8880254c0000 R14: 1ffff92002fc5f6e R15: 00000000c00007ff
FS:  0000000001ddc940(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f121000 CR3: 00000000152c0000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 isotp_notifier+0x2a7/0x540 net/can/isotp.c:1303
 call_netdevice_notifier net/core/dev.c:1735 [inline]
 call_netdevice_unregister_notifiers+0x156/0x1c0 net/core/dev.c:1763
 call_netdevice_unregister_net_notifiers net/core/dev.c:1791 [inline]
 unregister_netdevice_notifier+0xcd/0x170 net/core/dev.c:1870
 isotp_release+0x136/0x600 net/can/isotp.c:1011
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x417811
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 a4 1a 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:000000000169fbf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000417811
RDX: 0000000000000000 RSI: 00000000000013b7 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00000000acabb3b7 R09: 00000000acabb3bb
R10: 000000000169fcd0 R11: 0000000000000293 R12: 000000000118c9a0
R13: 000000000118c9a0 R14: 00000000000003e8 R15: 000000000118bf2c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
