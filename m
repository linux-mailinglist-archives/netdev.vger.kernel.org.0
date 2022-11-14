Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D566274D4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiKNDLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 22:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiKNDLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 22:11:52 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4CF13D0B
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 19:11:51 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id h10-20020a056e021b8a00b00302671bb5fdso186539ili.21
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 19:11:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rqIsuBwvSB+Mn8dR1olneK+HQNtKtA0h9FCa4B9a55M=;
        b=F9H9nanCEZjdgWdfncLp6BZv8OIsa5XDlk2a/EsW5IKiqBgYnpezIB6mxBgQfVzese
         cOv0cdkGXnCvIufG2hK9HTj5uRyFgtlVGaa2mkYnervRCQCmTRbmrlNR2051aGKkMqlZ
         cOtHF/eF+/Bx71LKDWKcV+fls08wtcUb7awPpu4ya1l4EWFr/chjvfWFkP34f/bAnGPm
         4+6qAOXJzNdk5YMffSSAdnFbx6du5PdOwndHpZvqI78FuCUroUDIUQaw10lRwznOKrpr
         0sIFbiTy1o0wnjDt5fkaUc31pcCYEPzVB7o3j5USnMUd2NtQ5DllHriQFFA2UKRtlvvK
         MPFA==
X-Gm-Message-State: ANoB5pnxUeYIZfNGGnNwuqYZ3ejeGjvQEAO67CUNV0SzlJpCgcQ8poUU
        BZAjxguVi5r5fzeL0MYU8RhoL/QGjZsrRI39jg0Wk6MrTWXg
X-Google-Smtp-Source: AA0mqf7kIOn1CXMutPbVoAU9EClWbYwm3Ywu/N2Q1kpHBNtAy03tkMraPb8e9Pz2pTCPxcobJS4Ps4RzHwpT7vPVz4M8Y8rSAmh6
MIME-Version: 1.0
X-Received: by 2002:a92:130a:0:b0:300:b0c9:c2c7 with SMTP id
 10-20020a92130a000000b00300b0c9c2c7mr5509814ilt.116.1668395511093; Sun, 13
 Nov 2022 19:11:51 -0800 (PST)
Date:   Sun, 13 Nov 2022 19:11:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8a20c05ed659923@google.com>
Subject: [syzbot] WARNING in nci_unregister_device
From:   syzbot <syzbot+793f4af30562b0fe1614@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
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

HEAD commit:    af7a05689189 Merge tag 'mips-fixes_6.1_1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d2b449880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7abe2506fc0b8c90
dashboard link: https://syzkaller.appspot.com/bug?extid=793f4af30562b0fe1614
compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+793f4af30562b0fe1614@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 2206 at kernel/workqueue.c:4442 destroy_workqueue+0x100/0x240 kernel/workqueue.c:4442
Modules linked in:
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 2206 Comm: syz-executor.0 Not tainted 6.1.0-rc4-syzkaller #0
Hardware name: ARM-Versatile Express
Backtrace: 
[<8173b47c>] (dump_backtrace) from [<8173b570>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:253)
 r7:81cfb8d0 r6:822228ec r5:60000093 r4:81d09cb8
[<8173b558>] (show_stack) from [<81757650>] (__dump_stack lib/dump_stack.c:88 [inline])
[<8173b558>] (show_stack) from [<81757650>] (dump_stack_lvl+0x48/0x54 lib/dump_stack.c:106)
[<81757608>] (dump_stack_lvl) from [<81757674>] (dump_stack+0x18/0x1c lib/dump_stack.c:113)
 r5:00000000 r4:82448d14
[<8175765c>] (dump_stack) from [<8173c118>] (panic+0x11c/0x360 kernel/panic.c:274)
[<8173bffc>] (panic) from [<80241604>] (__warn+0x98/0x1a4 kernel/panic.c:621)
 r3:00000001 r2:00000000 r1:00000000 r0:81cfb8d0
 r7:80263588
[<8024156c>] (__warn) from [<8173c3c4>] (warn_slowpath_fmt+0x68/0xd4 kernel/panic.c:644)
 r8:00000009 r7:80263588 r6:0000115a r5:81cfcce8 r4:00000000
[<8173c360>] (warn_slowpath_fmt) from [<80263588>] (destroy_workqueue+0x100/0x240 kernel/workqueue.c:4442)
 r8:842200d0 r7:851f6210 r6:851f6200 r5:83a07400 r4:83a0741c
[<80263488>] (destroy_workqueue) from [<816caafc>] (nci_unregister_device+0x30/0x98 net/nfc/nci/core.c:1293)
 r7:840da800 r6:840da800 r5:000e001b r4:824fd054
[<816caacc>] (nci_unregister_device) from [<809f196c>] (virtual_ncidev_close+0x64/0x7c drivers/nfc/virtual_ncidev.c:166)
 r9:7efffd08 r8:842200d0 r7:839f4650 r6:834e4660 r5:000e001b r4:824fd054
[<809f1908>] (virtual_ncidev_close) from [<804a9600>] (__fput+0x84/0x264 fs/file_table.c:320)
 r5:000e001b r4:85c92540
[<804a957c>] (__fput) from [<804a985c>] (____fput+0x10/0x14 fs/file_table.c:348)
 r9:7efffd08 r8:8525cd44 r7:824495dc r6:8525c500 r5:8525cd14 r4:00000000
[<804a984c>] (____fput) from [<8026618c>] (task_work_run+0x8c/0xb4 kernel/task_work.c:179)
[<80266100>] (task_work_run) from [<8020c070>] (resume_user_mode_work include/linux/resume_user_mode.h:49 [inline])
[<80266100>] (task_work_run) from [<8020c070>] (do_work_pending+0x420/0x524 arch/arm/kernel/signal.c:630)
 r9:7efffd08 r8:80200288 r7:fffffe30 r6:80200288 r5:ed19dfb0 r4:8525c500
[<8020bc50>] (do_work_pending) from [<80200088>] (slow_work_pending+0xc/0x20)
Exception stack(0xed19dfb0 to 0xed19dff8)
dfa0:                                     00000000 00000002 00000000 00000003
dfc0: 00000004 0126b4c0 00000000 00000006 00140000 000003e8 0014c1f8 0014c1f8
dfe0: 2f360000 7e8cb408 0002993c 00029df8 80000010 00000003
 r10:00000006 r9:8525c500 r8:80200288 r7:00000006 r6:00000000 r5:0126b4c0
 r4:00000004
SMP: failed to stop secondary CPUs
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
