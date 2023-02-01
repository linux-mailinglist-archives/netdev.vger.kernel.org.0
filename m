Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249B768704B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjBAVGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjBAVGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:06:02 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A986D5C4
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 13:05:59 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id z25-20020a6be019000000b00716eaf80c1dso7325910iog.3
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 13:05:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3PmGRfbG2FyM6dtBICa8SqYwc52m52X+oEjjhvzQDI=;
        b=zQl+YuQjBQvaTNzYlTdVpYKhhS85Va6DfiiK30l1HjRwix7frPtXXbGHFRYJk+t7KD
         IC8UQHe7JZpsefZjcbSL/ZXvi+zr/1YGh9y4+cPutkL6fX7jXmnuIYYqVcKcbPLViHVO
         PLsVMcRZm/4xQSuUr4mhYx0iSNCFWwObWXt0/Rp3h/p3TeyfPS6xI4USTJcz3j9UaszA
         8F0LXhv0VDBRcif7iqwFOMD/jsapKsTDX3oIRRcXGJPbhueh0z8BVVgy4ybQtyYR0oKs
         AGLa5HLY3JAL/rAO+2Hlhn3fDfpWyEafBWwiMUssXHfRK6tKbK3lyx9AWU3TA5wUEhY0
         R/pA==
X-Gm-Message-State: AO0yUKXEuRZOmCCgBdUmGgL7OBs2/dHND9uo8zZdiQv1wGHeCvEMQXXY
        8W15lhh4Xuny7QRnjZ1GKGCPoYSJmjRy5es4w332EYee76sn
X-Google-Smtp-Source: AK7set9Unrpvidh/P+Fd6hfW7ohyyBl8pIEZS47yyVPvX8oN7jakBQ4PiGehip5A5Md4fGKzCVrxAMRLA1Ib6zGGAfIcHwCBjFpt
MIME-Version: 1.0
X-Received: by 2002:a02:2a89:0:b0:3ae:d313:3af with SMTP id
 w131-20020a022a89000000b003aed31303afmr918794jaw.79.1675285558290; Wed, 01
 Feb 2023 13:05:58 -0800 (PST)
Date:   Wed, 01 Feb 2023 13:05:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099748b05f3a9d0ad@google.com>
Subject: [syzbot] WARNING in ath6kl_bmi_get_target_info
From:   syzbot <syzbot+624665ad2304abbedf2a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c52c9acc415e xhci: host: Add Renesas RZ/V2M SoC support
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=12cf70c9480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcf19b1033eb57df
dashboard link: https://syzkaller.appspot.com/bug?extid=624665ad2304abbedf2a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/729855741e3d/disk-c52c9acc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a4fc630e298b/vmlinux-c52c9acc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6fd5e7bf2703/bzImage-c52c9acc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+624665ad2304abbedf2a@syzkaller.appspotmail.com

usb 1-1: New USB device found, idVendor=0cf3, idProduct=9374, bcdDevice=bc.3b
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5559 at drivers/net/wireless/ath/ath6kl/bmi.c:90 ath6kl_bmi_get_target_info+0x4db/0x580 drivers/net/wireless/ath/ath6kl/bmi.c:90
Modules linked in:
CPU: 0 PID: 5559 Comm: kworker/0:7 Not tainted 6.2.0-rc5-syzkaller-00917-gc52c9acc415e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Workqueue: usb_hub_wq hub_event
RIP: 0010:ath6kl_bmi_get_target_info+0x4db/0x580 drivers/net/wireless/ath/ath6kl/bmi.c:90
Code: 8f fc ff ff e8 16 30 12 fe be 08 00 00 00 48 c7 c7 e0 58 97 86 41 bc f3 ff ff ff e8 ad 59 ab 02 e9 71 fd ff ff e8 f5 2f 12 fe <0f> 0b 41 bc ea ff ff ff e9 5f fd ff ff e8 a3 ed 45 fe e9 01 fc ff
RSP: 0018:ffffc90006ce6f48 EFLAGS: 00010212
RAX: 0000000000025d59 RBX: ffffc90006ce7058 RCX: ffffc9000cc1f000
RDX: 0000000000040000 RSI: ffffffff83352c9b RDI: 0000000000000005
RBP: ffff88813f480de0 R08: 0000000000000005 R09: 000000000000000c
R10: 000000006d6d67b4 R11: 0000000000000000 R12: 000000006d6d67b4
R13: 1ffff92000d9cdea R14: ffff88813f480e10 R15: ffffc90006ce705c
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f38cab4d718 CR3: 000000010dc0c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ath6kl_core_init drivers/net/wireless/ath/ath6kl/core.c:101 [inline]
 ath6kl_core_init+0x1d1/0x11c0 drivers/net/wireless/ath/ath6kl/core.c:66
 ath6kl_usb_probe+0xc58/0x1270 drivers/net/wireless/ath/ath6kl/usb.c:1168
 usb_probe_interface+0x30b/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __device_attach_driver+0x1d0/0x2e0 drivers/base/dd.c:936
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1e4/0x530 drivers/base/dd.c:1008
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xbd5/0x1e90 drivers/base/core.c:3479
 usb_set_configuration+0x1019/0x1900 drivers/usb/core/message.c:2171
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd4/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __device_attach_driver+0x1d0/0x2e0 drivers/base/dd.c:936
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1e4/0x530 drivers/base/dd.c:1008
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xbd5/0x1e90 drivers/base/core.c:3479
 usb_new_device.cold+0x685/0x10ad drivers/usb/core/hub.c:2576
 hub_port_connect drivers/usb/core/hub.c:5408 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5552 [inline]
 port_event drivers/usb/core/hub.c:5712 [inline]
 hub_event+0x2d58/0x4810 drivers/usb/core/hub.c:5794
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 process_scheduled_works kernel/workqueue.c:2352 [inline]
 worker_thread+0x854/0x1080 kernel/workqueue.c:2438
 kthread+0x2ea/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
