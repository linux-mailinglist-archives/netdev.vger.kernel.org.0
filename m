Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1952F4D9E9D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349565AbiCOP1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242561AbiCOP1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:27:36 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAD0506D7
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:26:24 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so11531205ilc.17
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vdTQDBC3Jklh96eo2Y2NGd8ppWKF8RaZ4ErDmGq8gGk=;
        b=qBv/x5PzawGgF0JG6KjzQJjYFy/0EV/Yo/jNObD8zTLRb0MWM7stEE1yKCl8ugUxFX
         HKs2VDQ+cxWQArbQn07KRITqi/fpz41uTy56B2oaw7GS3+eTuLeWozANxZkJE/nJ3eBg
         IzzhtMJOkoUT3EmMSxdDSc7hyUGyQyTWYsHthHp9YPzkbGKj9fCjDKvtaxmcNmJCu6qr
         VIfryPm+IVR2sP7Mj4kVZU1HaMgMAIzJ8MXGdHDG8bc0TCODhf9Lh8e4xzZeivzvBT6Q
         dlLykNaykQ+9iKFeIxbCwQE0nf8rKUvJWAPGUc9pc4QRBXi+uheEQjsq5HCErEUPgcow
         TLOQ==
X-Gm-Message-State: AOAM530ihNuI2vKU5/Va1yGjIl2GHSowMjSxGSHtQxfCeV4T826gQCH+
        dyqs/4hoBrhRzX3Vx+JcxVLoJcr1aRJj0BnC9QGpyo8uB6Kw
X-Google-Smtp-Source: ABdhPJxRlEiUerv7gDBygAznUFLNS8dEjNh8w4wUD1854dHWrJtxtiWpX1Ofn8b9ntKMGI5XtebtNVYiHhzz9+6TcpL8z7tKBfdj
MIME-Version: 1.0
X-Received: by 2002:a92:6c09:0:b0:2c7:a105:d426 with SMTP id
 h9-20020a926c09000000b002c7a105d426mr7213685ilc.111.1647357983549; Tue, 15
 Mar 2022 08:26:23 -0700 (PDT)
Date:   Tue, 15 Mar 2022 08:26:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d718005da436bcc@google.com>
Subject: [syzbot] KMSAN: uninit-value in asix_mdio_write_nopm
From:   syzbot <syzbot+737f7d251877e50f3dce@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=151d8ea9700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28718f555f258365
dashboard link: https://syzkaller.appspot.com/bug?extid=737f7d251877e50f3dce
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+737f7d251877e50f3dce@syzkaller.appspotmail.com

usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 6-1: Product: syz
usb 6-1: Manufacturer: syz
usb 6-1: SerialNumber: syz
usb 6-1: config 0 descriptor??
asix 6-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
=====================================================
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:84 [inline]
BUG: KMSAN: uninit-value in asix_mdio_write_nopm+0x556/0x9d0 drivers/net/usb/asix_common.c:605
 asix_check_host_enable drivers/net/usb/asix_common.c:84 [inline]
 asix_mdio_write_nopm+0x556/0x9d0 drivers/net/usb/asix_common.c:605
 ax88772a_hw_reset+0xa67/0x12e0 drivers/net/usb/asix_devices.c:524
 ax88772_bind+0x750/0x1770 drivers/net/usb/asix_devices.c:762
 usbnet_probe+0x1251/0x4160 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:752
 driver_probe_device drivers/base/dd.c:782 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:899
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:970
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1017
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:752
 driver_probe_device drivers/base/dd.c:782 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:899
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:970
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1017
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_new_device+0x1b8e/0x2950 drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5358 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x58e3/0x89e0 drivers/usb/core/hub.c:5742
 process_one_work+0xdb6/0x1820 kernel/workqueue.c:2307
 worker_thread+0x10b3/0x21e0 kernel/workqueue.c:2454
 kthread+0x3c7/0x500 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

Local variable smsr.i created at:
 asix_mdio_write_nopm+0xe7/0x9d0 drivers/net/usb/asix_common.c:605
 ax88772a_hw_reset+0xa67/0x12e0 drivers/net/usb/asix_devices.c:524

CPU: 1 PID: 3515 Comm: kworker/1:3 Not tainted 5.17.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
