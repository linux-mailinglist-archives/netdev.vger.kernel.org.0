Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4B04D77E2
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 20:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiCMTIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 15:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiCMTIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 15:08:45 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B24555231
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 12:07:20 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso10810644ioo.13
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 12:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hrG6Ki3aA8GUhdvCzu83x+7g5sqskeEOsHfTy29t4bQ=;
        b=tkH7+geRr/gaWv5afV0kmcOo/dFcm40e3F4aqSlu8MjNo94x7klXlnzFDte5w0wZkO
         aYHt8NxKkxo2stmLWea19jWBuEoPUuKR+4LDQxXidFeHcnEeXW4aX0o1m5C2Pg3/U6xK
         JwWmsPjb7rE/SrVIi8s2t+lSB60mHdaOHh686qhUwj7eRwXl2C/W6ZPlRj892ediiMws
         Fnn9nGntmak5ipV4BLPsakvbgDQUGFi5r/HISkSq6jmuzgwCnUDgIYlZZpDfuIIekqfQ
         KPt35/8pPBzO3FsOdut9TLT7bnp7NaHXHeE1lPr7ZtlLUMyJqBOskspYpcxme/1V146X
         VZGg==
X-Gm-Message-State: AOAM532jJ3fMaTrNL8hTWligQ/hhI8GO8n68UzsFfacpilZPYqkal25A
        G4wgQ1Ki1R00ywMqYwMQnwAf7sL6RBW0N3C2E2m9sdD1UWWH
X-Google-Smtp-Source: ABdhPJy52cW2X75vVZN/Qp8fQW0mjgpEorMgwvmJGJ9IXYb2e9asY0cQIyZbCDcnDxdOubkkNtceCMO4uFw8Z/qci8JwOkZPxMF/
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3816:b0:31a:60:22c9 with SMTP id
 i22-20020a056638381600b0031a006022c9mr2318973jav.146.1647198380638; Sun, 13
 Mar 2022 12:06:20 -0700 (PDT)
Date:   Sun, 13 Mar 2022 12:06:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a48c405da1e42a7@google.com>
Subject: [syzbot] WARNING in dev_shutdown (2)
From:   syzbot <syzbot+b7f7bc8316a81a317025@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    98d107b84614 usb: host: xhci: Remove some unnecessary retu..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=14e2cd45700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c586df4d4c0a65
dashboard link: https://syzkaller.appspot.com/bug?extid=b7f7bc8316a81a317025
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b7f7bc8316a81a317025@syzkaller.appspotmail.com

ax88179_178a 1-1:8.224 eth1: Failed to write reg index 0x0001: -19
ax88179_178a 1-1:8.224 eth1: Failed to write reg index 0x0002: -19
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5 at net/sched/sch_generic.c:1484 dev_shutdown+0x44f/0x520 net/sched/sch_generic.c:1484
Modules linked in:
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.17.0-rc6-syzkaller-00100-g98d107b84614 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:dev_shutdown+0x44f/0x520 net/sched/sch_generic.c:1484
Code: fc 48 c7 c2 20 40 d6 86 be 55 00 00 00 48 c7 c7 00 44 d6 86 c6 05 d6 6d ca 03 01 e8 98 96 c4 00 e9 76 fd ff ff e8 41 62 61 fc <0f> 0b e9 b8 fe ff ff 48 8b 7c 24 10 e8 30 83 90 fc e9 de fb ff ff
RSP: 0018:ffffc9000005f598 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000001 RCX: ffffc90007c12000
RDX: 0000000000040000 RSI: ffffffff84e29def RDI: ffff888116c4c510
RBP: ffff888116c4c000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff84e23f1a R11: 0000000000000000 R12: ffff888116c4c410
R13: ffff888110ce4c18 R14: ffffed1022d89880 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2bf24000 CR3: 000000010e37a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unregister_netdevice_many+0x816/0x1870 net/core/dev.c:10408
 unregister_netdevice_queue net/core/dev.c:10349 [inline]
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10339
 unregister_netdevice include/linux/netdevice.h:2902 [inline]
 unregister_netdev+0x18/0x20 net/core/dev.c:10474
 usbnet_disconnect+0x139/0x270 drivers/net/usb/usbnet.c:1623
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x627/0x760 drivers/base/dd.c:1209
 device_release_driver_internal drivers/base/dd.c:1242 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1265
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5207 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5507 [inline]
 port_event drivers/usb/core/hub.c:5665 [inline]
 hub_event+0x1e39/0x44d0 drivers/usb/core/hub.c:5747
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 process_scheduled_works kernel/workqueue.c:2370 [inline]
 worker_thread+0x833/0x1110 kernel/workqueue.c:2456
 kthread+0x2ef/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
