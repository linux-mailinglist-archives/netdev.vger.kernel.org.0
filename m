Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B568F1376B6
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgAJTLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:11:11 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:36714 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgAJTLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:11:10 -0500
Received: by mail-il1-f200.google.com with SMTP id t2so2238483ilp.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 11:11:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Fy/WFcnJ25iyWFvsl9r5AXVP+hcY+D0Rh4DTlOZdONM=;
        b=ADt0GHVMMTH1Z49UML4SzYvD07AdiTupKMfWzDpSg97zjNTqDUy7nzDeLlfJtjwXzS
         GuNik1kW3puTzBp9LpMxsM66y8Qm6fYa32f96eGEuMSNzCvlvxrrd5asbbKJ/XlyYJr9
         Hw7TSmP06WA51GndRQdRcj9iG/MfTyWyOXlStM3PNY8Vwkq1hSspmwUcx5HGjFHqQpyb
         Pzk9HRmz9RlTL95bIrM6xSit2H41OuRl/TfkikxKcZva1UCHlIVxP6WNhdGKQuYMDdCE
         NZvletyMII0duwT8KPLJiZDYgGgRzWg4iWW5bpvU16XRhF3r9xyIXuIx+VP4YMA1IJLa
         sQmg==
X-Gm-Message-State: APjAAAXYfBPkXe7iqOI6LXYr8mD+VRzQR1lQ7I+fYyoaRQavX0rjiznV
        /PvBZRnlMG+lvKw1LxytoHJRdpexYDH9xF0EaMx1MFHvF7+9
X-Google-Smtp-Source: APXvYqwY3GgaXVZtkAQIcr7wURVRj5PLnEFSR3Wg8Z1BDSmZIfg3rWTj3510J3NUyAXFL3aFFxXUt677cxsGvHDKy4AIRx2nqtdv
MIME-Version: 1.0
X-Received: by 2002:a5d:97c3:: with SMTP id k3mr3909079ios.38.1578683470163;
 Fri, 10 Jan 2020 11:11:10 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:11:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073b469059bcde315@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in cfg80211_wext_siwrts
From:   syzbot <syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2f806c2a Merge branch 'net-ungraft-prio'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1032069ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c90cac8f1f8c619
dashboard link: https://syzkaller.appspot.com/bug?extid=34b582cf32c1db008f8e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD a7499067 P4D a7499067 PUD 9a778067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 12180 Comm: syz-executor.2 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc90001727a78 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff888218678540 RCX: ffffc9000e5df000
RDX: 1ffffffff1148744 RSI: 0000000000000008 RDI: ffff888218678540
RBP: ffffc90001727ab8 R08: ffff8880957ac0c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffffffff88a438a0
R13: ffff88808f309000 R14: ffffc90001727bb0 R15: 0000000000000000
FS:  00007f1e9f870700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000094518000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  rdev_set_wiphy_params net/wireless/rdev-ops.h:542 [inline]
  cfg80211_wext_siwrts+0x265/0x8f0 net/wireless/wext-compat.c:267
  ioctl_standard_call+0xca/0x1d0 net/wireless/wext-core.c:1015
  wireless_process_ioctl.constprop.0+0x236/0x2b0 net/wireless/wext-core.c:953
  wext_ioctl_dispatch net/wireless/wext-core.c:986 [inline]
  wext_ioctl_dispatch net/wireless/wext-core.c:974 [inline]
  wext_handle_ioctl+0x106/0x1c0 net/wireless/wext-core.c:1047
  sock_ioctl+0x47d/0x790 net/socket.c:1112
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1e9f86fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000020000040 RSI: 0000000000008b22 RDI: 0000000000000004
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1e9f8706d4
R13: 00000000004c2837 R14: 00000000004d8b30 R15: 00000000ffffffff
Modules linked in:
CR2: 0000000000000000
---[ end trace 4579299d7d6f7d47 ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc90001727a78 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff888218678540 RCX: ffffc9000e5df000
RDX: 1ffffffff1148744 RSI: 0000000000000008 RDI: ffff888218678540
RBP: ffffc90001727ab8 R08: ffff8880957ac0c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffffffff88a438a0
R13: ffff88808f309000 R14: ffffc90001727bb0 R15: 0000000000000000
FS:  00007f1e9f870700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff5d5b8fc8 CR3: 0000000094518000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
