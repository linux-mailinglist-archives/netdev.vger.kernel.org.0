Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E341FB38
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 13:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhJBLvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 07:51:17 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37389 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhJBLvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 07:51:14 -0400
Received: by mail-io1-f72.google.com with SMTP id e68-20020a6bb547000000b005d06de54ab7so11298714iof.4
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 04:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TxM9Xomw4NkWnOXL5CXFszT+5JBuU4qqbJet8FXAYV4=;
        b=Pz/1q6EwgTx4TaFhtUv0bfelgH36FYSNQ5wajNLBR/cSUi9adIzEgkElbN6zO0kNdd
         +pWraaiP3ywjjT/KQFF4XQ3zzGvHiKhHkF1wMCT9yNVGUfj8Vb+FEpQ43DfCo4EpdFS1
         wu+83tEVgTImJ/ozz4GZy5BlG/YpYS529JfITO/ZSZmbm3M0jA9/19SNXObpNeYq4D6N
         1CRffcsXpiXTDoeFRV8za+x1199cqIXKrXJRmx3clXsbzIgoKk2VVGHJTIkMB+TBga17
         uEXD/wv2xHZW+hIrAaz+sqwR3uFnvnIRghS5cb/7aEgZzVDWxzazZkreNYXxO549oxfv
         yB5A==
X-Gm-Message-State: AOAM532x9yElGszOjdR7Mwo7foEGWHpXUY7zZKj7QglyG3qZO5vO0HKz
        0rPJrCwQUyyU+8SwXmvkJxuWLekdxUwxmxXLa99L1fFufQkh
X-Google-Smtp-Source: ABdhPJy0S+EUv86uoLU/w13YtrgANg3dRZq3JvPij7rcYlEaZzkLZJv9MpqQx+BneOmfW51Cu8E4aExj/kOt4a04N6xdJGH9R6Te
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d89:: with SMTP id l9mr2580890jaj.46.1633175368985;
 Sat, 02 Oct 2021 04:49:28 -0700 (PDT)
Date:   Sat, 02 Oct 2021 04:49:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b96daa05cd5d4538@google.com>
Subject: [syzbot] linux-next test error: WARNING in devlink_nl_region_notify
From:   syzbot <syzbot+e7ae6f62421c72822b9d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2d02a18f75fc Add linux-next specific files for 20210929
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1166777f300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b58fe22c337ee4a
dashboard link: https://syzkaller.appspot.com/bug?extid=e7ae6f62421c72822b9d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7ae6f62421c72822b9d@syzkaller.appspotmail.com

batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
device hsr_slave_0 entered promiscuous mode
device hsr_slave_1 entered promiscuous mode
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6562 at net/core/devlink.c:5158 devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
Modules linked in:
CPU: 1 PID: 6562 Comm: syz-executor.0 Not tainted 5.15.0-rc3-next-20210929-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
Code: 38 41 b8 c0 0c 00 00 31 d2 48 89 ee 4c 89 e7 e8 62 0b 26 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e e9 e1 03 45 fa e8 dc 03 45 fa <0f> 0b e9 f7 fe ff ff e8 d0 03 45 fa 0f 0b eb da 4c 89 e7 e8 b4 62
RSP: 0018:ffffc90002c3f660 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801d199d00 RSI: ffffffff87313be4 RDI: 0000000000000003
RBP: ffff88801d320b00 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87313ada R11: 0000000000000000 R12: ffff888019ed5000
R13: 0000000000000000 R14: 000000000000002c R15: ffff888019ed5070
FS:  00005555560ce400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6594537000 CR3: 00000000684dd000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 devlink_region_create+0x39f/0x4c0 net/core/devlink.c:10327
 nsim_dev_dummy_region_init drivers/net/netdevsim/dev.c:481 [inline]
 nsim_dev_probe+0x5f6/0x1150 drivers/net/netdevsim/dev.c:1479
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc17/0x1ee0 drivers/base/core.c:3395
 nsim_bus_dev_new drivers/net/netdevsim/bus.c:435 [inline]
 new_device_store+0x48b/0x770 drivers/net/netdevsim/bus.c:302
 bus_attr_store+0x72/0xa0 drivers/base/bus.c:122
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:507
 vfs_write+0x7cf/0xae0 fs/read_write.c:594
 ksys_write+0x12d/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3dbe12f3ef
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
RSP: 002b:00007ffcb02d3780 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f3dbe12f3ef
RDX: 0000000000000003 RSI: 00007ffcb02d37d0 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000000 R09: 00007ffcb02d3720
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f3dbe1d6971
R13: 00007ffcb02d37d0 R14: 0000000000000000 R15: 00007ffcb02d3ea0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
