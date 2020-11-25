Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F27E2C4169
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 14:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgKYNvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 08:51:19 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:42962 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbgKYNvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 08:51:19 -0500
Received: by mail-il1-f198.google.com with SMTP id j18so1841837ilc.9
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 05:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oz91lyUj1R68WEu1dVaiKojIcWkJEytay+zVxaWFIvc=;
        b=Zu71RNwSmNBvU29i5zXRRunrAXdFDNL3V7ZiP/4bJ8K2/dQV8Sop7Y/fQZba4KHuqx
         1N1D+Hx1U4dVvet85g0v5br8pMwSh4NsmMqSeqq6yU14FEusjJB15rBHKjc6CQBJB2fO
         s5Jpo4VgliwzVJkDfx+HHl8mNfnhnhuCnQTp6dgkIMS/VZtVGC5B7i2uDdP02SxOgFvQ
         Ie3jWI0dpi1d/0KmnAMfbOD3rISSF0u9DlEpzYC7HIWBVexdmQm/o/AjP/yyzbh5nGvr
         UpPOucyYMZhwgg9EuXjg3iYUdSfhq9xoUNWDKghufO8dYEW2/j5D1tFX7AHnuSPOJyxM
         KeXA==
X-Gm-Message-State: AOAM53104Di/7jevGUYSw0p0XKbD1GTA4r8PkQTTSQVWnRC+XT+NNXte
        hx5W9eUnIkrYaLD5O3NJjxAMODJbvHDeDhBWwfC+pgIs4doU
X-Google-Smtp-Source: ABdhPJxTaZDFdE+wuyS+L4vT57rz7AKDgRPXgcLbABypoLQW9FA4vh0IYJPFYRmsuoG/Z9uqRtVzWfvvEpnBOta65UEdOkky4bJL
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d4e:: with SMTP id d14mr3446791jak.26.1606312278807;
 Wed, 25 Nov 2020 05:51:18 -0800 (PST)
Date:   Wed, 25 Nov 2020 05:51:18 -0800
In-Reply-To: <00000000000041019205b4c4e9ad@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c6d7a205b4eeb89b@google.com>
Subject: Re: BUG: receive list entry not found for dev vxcan1, id 002, mask C00007FF
From:   syzbot <syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    470dfd80 lan743x: replace polling loop by wait_event_timeo..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=107c26a5500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df65150a33f23d8c
dashboard link: https://syzkaller.appspot.com/bug?extid=381d06e0c8eaacb8706f
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bcd669500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ecad3e500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004442a9
RDX: 0000000000000018 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00007ffc870fdef0 R08: 0000000000000001 R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc870fdf00
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
BUG: receive list entry not found for dev vxcan1, id 002, mask C00007FF
WARNING: CPU: 0 PID: 8713 at net/can/af_can.c:546 can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
Modules linked in:
CPU: 0 PID: 8713 Comm: syz-executor284 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
Code: 8b 7c 24 78 44 8b 64 24 68 49 c7 c5 e0 de 56 8a e8 51 d3 95 f9 44 89 f9 44 89 e2 4c 89 ee 48 c7 c7 20 df 56 8a e8 a6 76 d3 00 <0f> 0b 48 8b 7c 24 28 e8 40 e9 0e 01 e9 54 fb ff ff e8 66 db d7 f9
RSP: 0018:ffffc90001b2fb38 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888014db8000 RSI: ffffffff8158f3c5 RDI: fffff52000365f59
RBP: 0000000000000118 R08: 0000000000000001 R09: ffff8880b9e30627
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: ffff8880261f0000 R14: 1ffff92000365f6e R15: 00000000c00007ff
FS:  0000000000807880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004bdfc4 CR3: 0000000014c7c000 CR4: 00000000001506f0
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
 sock_close+0x18/0x20 net/socket.c:1255
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x403b20
Code: 01 f0 ff ff 0f 83 40 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 6d bc 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 14 0d 00 00 c3 48 83 ec 08 e8 7a 02 00 00
RSP: 002b:00007ffc870fdee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000403b20
RDX: 0000000000000018 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00007ffc870fdef0 R08: 0000000000000001 R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc870fdf00
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

