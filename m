Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC43002B2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbhAVMRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:17:33 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47511 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbhAVMRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:17:02 -0500
Received: by mail-io1-f69.google.com with SMTP id t15so8296105ioi.14
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 04:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8TT39RX0FYSmfRR7lvWKPjQfZTrWM5VQMDI38J31U3o=;
        b=hkgXkgwHSx4MYawLU4lTjlkUFNgno3fW6dFFV/EyWCyCeepBOK73J3imd+8l5aoTx5
         6AKPV7bEyNW5KJr+v2TNZNmm4ytXS3Am55q5VrPquzvb7sWH7viRmuLpffMvcWQnJuKe
         jzDyq6V6OoOgpvULM0Zizgbu6jvkvpv6nRlEln9UyPMjcCqyFAsKl0d+1meUb4EBXE8X
         RnRplBn0kAsmA13e+fLbsoozGDSrwWZ8LD4ZOm3vLqnB0B1/0GgGqQ4oXasuW5fHjT8v
         pVf3Ec7zMe98guaE9gte7GYPoBiYaXNzHnNPV5M6m6A+6GfLkXMyVHthixhUhBn4M9dr
         Kdaw==
X-Gm-Message-State: AOAM530qJND6ETEhqeVCjP3qAlO4b1+pB98LmnbjBt/5go/QKhhvMRiK
        FL4GLdJx3f5WILJhb7XnDSprcqYZHoxwJGn9ClFRWNPQwbu1
X-Google-Smtp-Source: ABdhPJywamJZ/g0TFEXqdIsKfSoFNaL2D0YBdvoksVdfsi6faaesaTFLaYak7IvWgRNV2eVm7qBG6JazlN00wnuWqNeEVf9N7yrt
MIME-Version: 1.0
X-Received: by 2002:a6b:7704:: with SMTP id n4mr3125873iom.159.1611317780507;
 Fri, 22 Jan 2021 04:16:20 -0800 (PST)
Date:   Fri, 22 Jan 2021 04:16:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed6ff305b97c2755@google.com>
Subject: linux-next test error: WARNING in cfg80211_netdev_notifier_call
From:   syzbot <syzbot+8b083f465893fa214377@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    226871e2 Add linux-next specific files for 20210122
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1076afe7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40930d62519ae2bd
dashboard link: https://syzkaller.appspot.com/bug?extid=8b083f465893fa214377
compiler:       gcc (GCC) 10.1.0-syz 20200507

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b083f465893fa214377@syzkaller.appspotmail.com

device veth1_macvtap left promiscuous mode
device veth0_macvtap left promiscuous mode
device veth1_vlan left promiscuous mode
device veth0_vlan left promiscuous mode
------------[ cut here ]------------
WARNING: CPU: 0 PID: 270 at net/wireless/core.c:1455 cfg80211_netdev_notifier_call+0xd48/0x1460 net/wireless/core.c:1455
Modules linked in:
CPU: 0 PID: 270 Comm: kworker/u4:7 Not tainted 5.11.0-rc4-next-20210122-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:cfg80211_netdev_notifier_call+0xd48/0x1460 net/wireless/core.c:1455
Code: ce e4 3c f9 49 8d 7d 68 be ff ff ff ff e8 b0 cd c6 00 31 ff 89 c3 89 c6 e8 35 ec 3c f9 85 db 0f 85 64 f9 ff ff e8 a8 e4 3c f9 <0f> 0b e9 58 f9 ff ff e8 9c e4 3c f9 49 8d 7d 68 be ff ff ff ff e8
RSP: 0018:ffffc900016af720 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801135b800 RSI: ffffffff883638b8 RDI: 0000000000000003
RBP: ffff888035622000 R08: 0000000000000000 R09: ffffffff88362ccd
R10: ffffffff883638ab R11: 0000000000000006 R12: 1ffff920002d5ee9
R13: ffff888144628580 R14: ffff888035630000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000a9b158 CR3: 00000000111dc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 unregister_netdevice_many+0x943/0x1750 net/core/dev.c:10704
 default_device_exit_batch+0x2fa/0x3c0 net/core/dev.c:11224
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
