Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4664FC36
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 21:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiLQUXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 15:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLQUXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 15:23:42 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2ABE0DB
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 12:23:38 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id x10-20020a056e021bca00b00302b6c0a683so4025767ilv.23
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 12:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zhak8b5pECv3WdAuTBYFEI8u4BH4xzgqJb+pR1es1dw=;
        b=EiAH+AFYSKuH7vUYvyM9HpNWhqwcZd0dnvw63KpStNTstEoZarhzkZBNDV1Aw4WbO4
         9qyMc0nRBcPOR960AQxGcxvjp3RSd5mrQtsDB93eDvjBzvgUU1B54jw+aBiqFW672dOM
         BMujDMVqe1WFpFFjN4PsDF0piRYCyRQwo3mXhRyd98EbRZUIt7uZihhmrv2JNQxPSSQv
         Qg/40oiGKYHaKPufjwd27NNfWHBc1HgX7wiELcSZLzblZH4AufY6BZqSgUUWwn7dTMtk
         ikPeVsd4ag+kEpDyFwZyp1CBqHau/u8qK8CYkvvX2U1A02sj3jD4NMKVJ0c18zaUD5fm
         73eg==
X-Gm-Message-State: ANoB5pmoVsPdCAiwSAlRcmFa+Y6TRQsiXAy5fjgWuzxNujVctqi5TQ4D
        nepfYFUCqM8kCjDsb3riiMootjBqY3USjrpPyOHOx/+7YI/k
X-Google-Smtp-Source: AA0mqf4SE3WhaLo0Wqu5rl3EqqzkTQBtaB/iRqHJV5j60PglmweOvVXaL+HWPFGUhuyO9VrWZ1Wx5GLdjlbY/HrWbkGBm2XCzhdO
MIME-Version: 1.0
X-Received: by 2002:a92:bf08:0:b0:302:43b8:d42f with SMTP id
 z8-20020a92bf08000000b0030243b8d42fmr39574908ilh.64.1671308617477; Sat, 17
 Dec 2022 12:23:37 -0800 (PST)
Date:   Sat, 17 Dec 2022 12:23:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074764e05f00bdc01@google.com>
Subject: [syzbot] WARNING in drv_link_info_changed
From:   syzbot <syzbot+224ad65c927c83902f06@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
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

HEAD commit:    e2ca6ba6ba01 Merge tag 'mm-stable-2022-12-13' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d4f027880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6133b41a9a0f500
dashboard link: https://syzkaller.appspot.com/bug?extid=224ad65c927c83902f06
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/be256841c209/disk-e2ca6ba6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/76c90a4cdade/vmlinux-e2ca6ba6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a44766da5515/bzImage-e2ca6ba6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+224ad65c927c83902f06@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5553 at net/mac80211/driver-ops.c:416 drv_link_info_changed+0xd2/0x780 net/mac80211/driver-ops.c:416
Modules linked in:
CPU: 1 PID: 5553 Comm: kworker/u4:23 Not tainted 6.1.0-syzkaller-09941-ge2ca6ba6ba01 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: phy12 ieee80211_roc_work
RIP: 0010:drv_link_info_changed+0xd2/0x780 net/mac80211/driver-ops.c:416
Code: 83 f8 01 0f 84 f6 00 00 00 e8 ea a6 4f f8 83 eb 07 31 ff 83 e3 fb 89 de e8 8b a3 4f f8 85 db 0f 84 da 00 00 00 e8 ce a6 4f f8 <0f> 0b e9 c5 02 00 00 e8 c2 a6 4f f8 4d 8d bc 24 50 1a 00 00 48 b8
RSP: 0018:ffffc90004befb90 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000fffffffb RCX: 0000000000000000
RDX: ffff888027601d40 RSI: ffffffff893103a2 RDI: 0000000000000005
RBP: ffff88807e7e8de0 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffffb R11: 0000000000000000 R12: ffff88803f4c0c80
R13: 0000000000000200 R14: 0000000000000000 R15: ffff88803f4c26d0
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f696ff85058 CR3: 000000002991d000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 ieee80211_link_info_change_notify+0x17a/0x270 net/mac80211/main.c:290
 ieee80211_offchannel_stop_vifs+0x308/0x4e0 net/mac80211/offchannel.c:121
 _ieee80211_start_next_roc+0x6f7/0x9a0 net/mac80211/offchannel.c:365
 __ieee80211_roc_work+0x190/0x3d0 net/mac80211/offchannel.c:432
 ieee80211_roc_work+0x2f/0x40 net/mac80211/offchannel.c:460
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
