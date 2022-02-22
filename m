Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D667E4C0261
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiBVTur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiBVTup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:50:45 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19CBB8B5E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 11:50:18 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id t72-20020a6bc34b000000b0063d7b2c24ecso12370264iof.12
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 11:50:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fdJDIrhq6AjxWdy9QWWruG80JTZiFgwR3NgptNzXp7c=;
        b=lNEDcyYntvnUDJ3Jo8+CTCUqz5s++YwPqLHPORoLNBQ9cSSI/Gnh51ThklGXoQl0r/
         p/5pecWk/1+d74MVycii2I+t7BOA9cuI8TP0gZYLqUfo+eR0HIMq50lSr/PUxFHeg/oI
         x8EGVeLCZGVCs5xhK6SVcOGQtm2DQ4QtDTSXd/F4myNbZgoinJU1pVRqEBCILhjF7aoO
         3gu3D7/NDBrrhfeBcuEh49iFpnWV7P0qMDJwBSZi3TaOKotzUVdi6wIXK/eqontXD+LB
         ArMHz5k/wq0d708lPshJPSabNv7Rlklv9JH2BwmL0Vl5UcBTWIEnznY8HW4nRRQKmZan
         yHtA==
X-Gm-Message-State: AOAM530Xjn91VoXrUEi4qr+tP+vPjt2Z4Wu6AoF//xZ7MDr6AkIGlf59
        qlbmxItbdk6bKcGCLqHKXk8SQO+XGToha9RvZA4ZAmdWUG3g
X-Google-Smtp-Source: ABdhPJxzXn0HAF1srxPYH/n0a3v62AYi50L/gJXjfHtDtnDNU49drLAVxvbnu6K3fs8YAGrf6XHppYvz3uOVanIHvG4rs484szF+
MIME-Version: 1.0
X-Received: by 2002:a5d:8714:0:b0:636:13bb:bc89 with SMTP id
 u20-20020a5d8714000000b0063613bbbc89mr20048910iom.126.1645559418262; Tue, 22
 Feb 2022 11:50:18 -0800 (PST)
Date:   Tue, 22 Feb 2022 11:50:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000951c2505d8a0a8e5@google.com>
Subject: [syzbot] WARNING in j1939_session_deactivate_activate_next
From:   syzbot <syzbot+3d2eaacbc2b94537c6c5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
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

HEAD commit:    7993e65fdd0f Merge tag 'mtd/fixes-for-5.17-rc5' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c9b264700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b41a243aa9878175
dashboard link: https://syzkaller.appspot.com/bug?extid=3d2eaacbc2b94537c6c5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133ec75a700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1039840a700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d2eaacbc2b94537c6c5@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_dat_one: 0xffff88801fdd2800: Data of RX-looped back packet (00 ff ff ff ff ff ff) doesn't match TX data (00 00 00 00 00 00 00)!
vcan0: j1939_xtp_rx_dat_one: 0xffff88801c86f000: last 15
vcan0: j1939_xtp_rx_abort_one: 0xffff88801fdd2800: 0x00000: (5) Maximal retransmit request limit reached
vcan0: j1939_xtp_rx_abort_one: 0xffff88801fdd2000: 0x00000: (5) Maximal retransmit request limit reached
------------[ cut here ]------------
WARNING: CPU: 0 PID: 13 at net/can/j1939/transport.c:1090 j1939_session_deactivate net/can/j1939/transport.c:1090 [inline]
WARNING: CPU: 0 PID: 13 at net/can/j1939/transport.c:1090 j1939_session_deactivate_activate_next+0x95/0xd3 net/can/j1939/transport.c:1100
Modules linked in:
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.17.0-rc4-syzkaller-00217-g7993e65fdd0f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:j1939_session_deactivate net/can/j1939/transport.c:1090 [inline]
RIP: 0010:j1939_session_deactivate_activate_next+0x95/0xd3 net/can/j1939/transport.c:1100
Code: 03 38 d0 7c 0c 84 d2 74 08 4c 89 ef e8 73 71 75 f8 8b 5d 28 bf 01 00 00 00 89 de e8 04 e3 2d f8 83 fb 01 77 07 e8 7a df 2d f8 <0f> 0b e8 73 df 2d f8 48 89 ef e8 8b 7a de fe 4c 89 e7 89 c3 e8 e1
RSP: 0018:ffffc90000d279b0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000100
RDX: ffff888011918000 RSI: ffffffff894afea6 RDI: 0000000000000003
RBP: ffff88801fdd2000 R08: 0000000000000001 R09: ffff88801fdd202b
R10: ffffffff894afe9c R11: 0000000000000000 R12: ffff88801dd41070
R13: ffff88801fdd2028 R14: ffff88801c9fd818 R15: ffffffff8ac38340
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000048 CR3: 000000007f5b2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 j1939_xtp_rx_abort_one.cold+0x20b/0x33c net/can/j1939/transport.c:1340
 j1939_xtp_rx_abort net/can/j1939/transport.c:1352 [inline]
 j1939_tp_cmd_recv net/can/j1939/transport.c:2100 [inline]
 j1939_tp_recv+0xb3d/0xcb0 net/can/j1939/transport.c:2133
 j1939_can_recv+0x6ff/0x9a0 net/can/j1939/main.c:108
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5351
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5465
 process_backlog+0x2a5/0x6c0 net/core/dev.c:5797
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6365
 napi_poll net/core/dev.c:6432 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:6519
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
