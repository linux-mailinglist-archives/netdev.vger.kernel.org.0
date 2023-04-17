Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615286E3F0C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjDQFgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDQFgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:36:37 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5CD40E3
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 22:35:54 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id t134-20020a6bc38c000000b00760f09eb49cso764888iof.1
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 22:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681709740; x=1684301740;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kwZCFvHqHpi36ZyUwte4FDMbaNXh4h+DCqvC+hQfIhk=;
        b=AHLw3CMvq8ybpvNU++3GP1OJdLtC6YbTIkhYKkcbrTTWn19m1vFmdu0MZlcDzbo2cu
         mIiURWR8Z99+cnsTIuR23i/hvD9rXOz312dpV/8cyiOCrn/m6pLV6nJue0Mev3jiRPGo
         lLDemtDFJv/FxL+V0pslYynk0bEq89B9ts9ocD8u4b4C1Y3BY8muTBiU1jcdQES/zVc4
         YAdwc95RIoJYo/6DnNFnn+umlRaA/uGfnaVDNJN9rhKG1/pqh1uwRRdmGKTv7Uivjwyq
         01af7t3BnDsZcdF+X/anSBlHoUwgboTxjGla17lpJg+CYG8EwcruNg1qOLCVbdgEragB
         2vEw==
X-Gm-Message-State: AAQBX9fk/km7y/mz/q+gaUJr31VEVbjawgve+45LP31x5jQQPLYEAgsk
        c+jdwQ82LeVL+tE4wP4nMaQd01Sc/CTYIvW82AV/Vet+3BKK
X-Google-Smtp-Source: AKy350YcRpw3cXCD1USzbe6yD2CiN0zufpsjUUa0IeA2ut5lmhIzIU4jNcpqFC1yOBQJp8ACcZVnvFKbhPTIeaWrJMSTCbTiEdJV
MIME-Version: 1.0
X-Received: by 2002:a02:9623:0:b0:40f:8b7d:90db with SMTP id
 c32-20020a029623000000b0040f8b7d90dbmr3604418jai.3.1681709740181; Sun, 16 Apr
 2023 22:35:40 -0700 (PDT)
Date:   Sun, 16 Apr 2023 22:35:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000adcd3c05f9818f7f@google.com>
Subject: [syzbot] [bluetooth?] WARNING: bad unlock balance in l2cap_bredr_sig_cmd
From:   syzbot <syzbot+5067576ebe3f37f2cca4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7a934f4bd7d6 Merge tag 'riscv-for-linus-6.3-rc7' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17444c3fc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=759d5e665e47a55
dashboard link: https://syzkaller.appspot.com/bug?extid=5067576ebe3f37f2cca4
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/df89fd1d6599/disk-7a934f4b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e76edf369cbd/vmlinux-7a934f4b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/23ad78b092d3/bzImage-7a934f4b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5067576ebe3f37f2cca4@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
6.3.0-rc6-syzkaller-00173-g7a934f4bd7d6 #0 Not tainted
-------------------------------------
kworker/u5:0/19118 is trying to release lock (&conn->chan_lock) at:
[<ffffffff89aea4c5>] l2cap_bredr_sig_cmd+0x875/0x9cb0 net/bluetooth/l2cap_core.c:5748
but there are no more locks to release!

other info that might help us debug this:
2 locks held by kworker/u5:0/19118:
 #0: ffff88804175e938 ((wq_completion)hci2#2){+.+.}-{0:0}, at: process_one_work+0x77e/0x10e0 kernel/workqueue.c:2363
 #1: ffffc90005077d20 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0}, at: process_one_work+0x7c8/0x10e0 kernel/workqueue.c:2365

stack backtrace:
CPU: 0 PID: 19118 Comm: kworker/u5:0 Not tainted 6.3.0-rc6-syzkaller-00173-g7a934f4bd7d6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
Workqueue: hci2 hci_rx_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 print_unlock_imbalance_bug+0x252/0x2c0 kernel/locking/lockdep.c:5109
 __lock_release kernel/locking/lockdep.c:5346 [inline]
 lock_release+0x59d/0x9d0 kernel/locking/lockdep.c:5689
 __mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:907
 l2cap_bredr_sig_cmd+0x875/0x9cb0 net/bluetooth/l2cap_core.c:5748
 l2cap_sig_channel net/bluetooth/l2cap_core.c:6507 [inline]
 l2cap_recv_frame+0xa5a/0x8990 net/bluetooth/l2cap_core.c:7786
 hci_acldata_packet net/bluetooth/hci_core.c:3828 [inline]
 hci_rx_work+0x58e/0xa90 net/bluetooth/hci_core.c:4063
 process_one_work+0x8a0/0x10e0 kernel/workqueue.c:2390
 worker_thread+0xa63/0x1210 kernel/workqueue.c:2537
 kthread+0x270/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Bluetooth: hci2: ACL packet for unknown connection handle 173
Bluetooth: hci2: ACL packet for unknown connection handle 173
Bluetooth: Unexpected start frame (len 16)
Bluetooth: Unexpected start frame (len 16)
Bluetooth: Unexpected start frame (len 16)
Bluetooth: hci4: Received unexpected HCI Event 0x00
Bluetooth: hci4: Received unexpected HCI Event 0x00
Bluetooth: hci4: Received unexpected HCI Event 0x00
Bluetooth: Unexpected start frame (len 20)
Bluetooth: Unexpected start frame (len 20)
Bluetooth: Unexpected start frame (len 28)
Bluetooth: hci1: Malformed Event: 0x02
Bluetooth: Unexpected start frame (len 28)
Bluetooth: Unexpected start frame (len 28)
Bluetooth: Unexpected start frame (len 28)
Bluetooth: Unexpected start frame (len 28)
Bluetooth: hci2: command 0x0419 tx timeout
Bluetooth: hci4: ACL packet for unknown connection handle 3017
Bluetooth: hci4: ACL packet for unknown connection handle 3017
Bluetooth: hci4: ACL packet for unknown connection handle 3017
Bluetooth: hci4: ACL packet for unknown connection handle 2303
Bluetooth: hci5: ACL packet for unknown connection handle 0
Bluetooth: Frame is too long (len 78, expected len 4)
Bluetooth: Frame is too long (len 78, expected len 4)
Bluetooth: Frame is too long (len 78, expected len 4)
Bluetooth: Frame is too long (len 78, expected len 4)
Bluetooth: hci5: ACL packet for unknown connection handle 233
Bluetooth: hci5: ACL packet for unknown connection handle 233
Bluetooth: hci5: ACL packet for unknown connection handle 233
Bluetooth: Unexpected continuation frame (len 28)
Bluetooth: Unexpected continuation frame (len 28)
Bluetooth: Unexpected start frame (len 16)
Bluetooth: Unexpected start frame (len 16)
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci1: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci2: ACL packet for unknown connection handle 2048
Bluetooth: hci0: command 0x0406 tx timeout


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
