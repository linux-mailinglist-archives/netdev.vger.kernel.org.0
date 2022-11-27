Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4465639D96
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiK0W0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiK0W0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:26:33 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65620A194
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 14:26:31 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id l21-20020a5d9315000000b006df7697880aso1379183ion.23
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 14:26:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D4BAMvOh+lRBFmBVJIyi+KYicBvfJ9pF6A4C+kPxHtM=;
        b=QBPnyI3Yk9TnWzGsQ954zVbxjP7S/Z5GIEU9zuBb53UyJwDeQKA5P9hAfeq9HRo8eh
         jhhgXC8iTKBUCVjj6HyRtbGfjX15/ORA0rk4m/zjwcaLg0NrSJo/c4q+UTggTr5AEYsP
         XrOhXwfdlrd011H7E6iUc8Cl+1ySclKbLi2LhBIPMRZa7NoZEq7WuYzEt3VrKWQy1X6P
         hVC3aweOdYJLh6QNj1HTkOVhpB0qVgJZzqjwaIDS5qfDDeed0qlFEafLYzJF9ja1QEBo
         F5kecNCG3x9oltYNt0bJXOB6d9HdIwyghm0hYFlWrWBQby+DReaMxpES1pvRgtjUT1gl
         ztcw==
X-Gm-Message-State: ANoB5pnSgR2ii3paFoKZrPWei84ZlOQJ7qJy02BN0lrUyZ1brDjrxt/h
        cBLD/DMpeXiuOxQubiYVtsvF1iOKMpcp18G8MmY1XQ3cafUh
X-Google-Smtp-Source: AA0mqf641B3UAoXUEN9NYmdriC/PxzTyI2l/4icimkHqjNiJ8PbhMaWOljCeZm6je7h/1KsCkkbeVm4XU2gv00RC4cQO55nAZW71
MIME-Version: 1.0
X-Received: by 2002:a02:c505:0:b0:372:e2a5:3a54 with SMTP id
 s5-20020a02c505000000b00372e2a53a54mr14999197jam.106.1669587990751; Sun, 27
 Nov 2022 14:26:30 -0800 (PST)
Date:   Sun, 27 Nov 2022 14:26:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c590f05ee7b3ff4@google.com>
Subject: [syzbot] WARNING in nci_add_new_protocol
From:   syzbot <syzbot+210e196cef4711b65139@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    4312098baf37 Merge tag 'spi-fix-v6.1-rc6' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e25bb5880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1129081024ee340
dashboard link: https://syzkaller.appspot.com/bug?extid=210e196cef4711b65139
compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+210e196cef4711b65139@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7843 at net/nfc/nci/ntf.c:260 nci_add_new_protocol+0x268/0x30c net/nfc/nci/ntf.c:260
memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)
Modules linked in:
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7843 Comm: kworker/u4:3 Not tainted 6.1.0-rc6-syzkaller #0
Hardware name: ARM-Versatile Express
Workqueue: nfc2_nci_rx_wq nci_rx_work
Backtrace: 
[<81751624>] (dump_backtrace) from [<81751718>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:253)
 r7:81cf8970 r6:822228ec r5:60000193 r4:81d06d58
[<81751700>] (show_stack) from [<8176d3e0>] (__dump_stack lib/dump_stack.c:88 [inline])
[<81751700>] (show_stack) from [<8176d3e0>] (dump_stack_lvl+0x48/0x54 lib/dump_stack.c:106)
[<8176d398>] (dump_stack_lvl) from [<8176d404>] (dump_stack+0x18/0x1c lib/dump_stack.c:113)
 r5:00000000 r4:82445d14
[<8176d3ec>] (dump_stack) from [<817522c0>] (panic+0x11c/0x360 kernel/panic.c:274)
[<817521a4>] (panic) from [<80241604>] (__warn+0x98/0x1a4 kernel/panic.c:621)
 r3:00000001 r2:00000000 r1:00000000 r0:81cf8970
 r7:816e192c
[<8024156c>] (__warn) from [<817525a0>] (warn_slowpath_fmt+0x9c/0xd4 kernel/panic.c:651)
 r8:00000009 r7:816e192c r6:00000104 r5:81ec7084 r4:81d20104
[<81752508>] (warn_slowpath_fmt) from [<816e192c>] (nci_add_new_protocol+0x268/0x30c net/nfc/nci/ntf.c:260)
 r8:84f0b129 r7:dfb25e4c r6:00000002 r5:00000081 r4:84f0b0fc
[<816e16c4>] (nci_add_new_protocol) from [<816e2738>] (nci_add_new_target net/nfc/nci/ntf.c:306 [inline])
[<816e16c4>] (nci_add_new_protocol) from [<816e2738>] (nci_rf_discover_ntf_packet net/nfc/nci/ntf.c:378 [inline])
[<816e16c4>] (nci_add_new_protocol) from [<816e2738>] (nci_ntf_packet+0xaf8/0xe18 net/nfc/nci/ntf.c:792)
 r8:00000001 r7:00000000 r6:84f0b000 r5:85202c00 r4:00000103
[<816e1c40>] (nci_ntf_packet) from [<816df268>] (nci_rx_work+0x70/0xe8 net/nfc/nci/core.c:1513)
 r10:84851205 r9:81a4b84c r8:81ec67b8 r7:84f0b0a4 r6:84f0b070 r5:84f0b000
 r4:85202c00
[<816df1f8>] (nci_rx_work) from [<802611c0>] (process_one_work+0x20c/0x5ac kernel/workqueue.c:2289)
 r9:828e5c00 r8:00000100 r7:84851200 r6:8280e800 r5:85867500 r4:84f0b070
[<80260fb4>] (process_one_work) from [<802615cc>] (worker_thread+0x6c/0x4e0 kernel/workqueue.c:2436)
 r10:8280e800 r9:00000088 r8:82204d40 r7:8280e81c r6:85867518 r5:8280e800
 r4:85867500
[<80261560>] (worker_thread) from [<80269b24>] (kthread+0xec/0x11c kernel/kthread.c:376)
 r10:00000000 r9:ed855e8c r8:852e8700 r7:85867500 r6:80261560 r5:828e5c00
 r4:84991a40
[<80269a38>] (kthread) from [<80200100>] (ret_from_fork+0x14/0x34 arch/arm/kernel/entry-common.S:148)
Exception stack(0xdfb25fb0 to 0xdfb25ff8)
5fa0:                                     00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80269a38 r4:84991a40
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
