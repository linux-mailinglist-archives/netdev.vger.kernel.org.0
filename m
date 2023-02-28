Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6424B6A5D57
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjB1Qm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjB1Qmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:42:54 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05A82C679
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:41:52 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id v3-20020a92c6c3000000b003159a0109ceso6365033ilm.12
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:41:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3F7vJLWGFsiTKVPdaUHctwhOd/Q+EKNvjOPIBluuyZQ=;
        b=LMkIa0eEHPQ2gdgbuNvCmBWWX9pwjo7GGyEDgBsoz5c/Oy6QKm4T15F9sVrldQtSmo
         TIKkOD4wdBcMRz/rNG/OtrRvyqxyHVSgL21ZSNuzYWOn18JHJIC3r+QDu0XW9pV3tqJn
         pbLUCMIRTK1n2Mf9aU8EJV4LdNE8gRk9a+XxwcmdWhCsJqu0aMU9SapKfxXDR1+ULhli
         nQQ4F9aQ6fTh9yvjiBy5V75O7N38ITOop292ECY7XgXMbRUKoayHKRS4u7N2Md5+V4DD
         LtAKMP5hGjQgxGuRx92y623TPmgEVOancb5Go1Yaze6/fv2vc9Ds5KE3G6MEBvue0RFL
         M5lQ==
X-Gm-Message-State: AO0yUKWGpT4DBp5qjdo6QSNli/9Bemj9dTRmR0HvZyHUvU134kDMvDod
        uwtgrg36XOgdjWAo8UqaoQ3L/bjGVXmtUX6y9gxgWHv0bFg6
X-Google-Smtp-Source: AK7set9Ewc0ZA9WAz1DvmsWDUQnOSzPLuTXIwGfU292cwOE7tExPcShZO3WR9hBhZPtiDdBRNptUiUTV/aAHfCM4dWKVnR9R4Y/W
MIME-Version: 1.0
X-Received: by 2002:a92:300f:0:b0:315:4c21:a377 with SMTP id
 x15-20020a92300f000000b003154c21a377mr1531876ile.6.1677602512210; Tue, 28 Feb
 2023 08:41:52 -0800 (PST)
Date:   Tue, 28 Feb 2023 08:41:52 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d092ed05f5c545a4@google.com>
Subject: [syzbot] [wireless?] WARNING in ieee80211_ibss_csa_beacon (2)
From:   syzbot <syzbot+b10a54cb0355d83fd75c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ae3419fbac84 vc_screen: don't clobber return value in vcs_..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1416fe18c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f763d89e26d3d4c4
dashboard link: https://syzkaller.appspot.com/bug?extid=b10a54cb0355d83fd75c
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/35978c167752/disk-ae3419fb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf285a5d176b/vmlinux-ae3419fb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6e8d414e67aa/bzImage-ae3419fb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b10a54cb0355d83fd75c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5872 at net/mac80211/ibss.c:500 ieee80211_ibss_csa_beacon+0x572/0x620
Modules linked in:
CPU: 1 PID: 5872 Comm: kworker/u4:16 Not tainted 6.2.0-syzkaller-12913-gae3419fbac84 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Workqueue: phy4 ieee80211_csa_finalize_work
RIP: 0010:ieee80211_ibss_csa_beacon+0x572/0x620 net/mac80211/ibss.c:500
Code: f7 c6 05 d1 4a 2d 04 01 48 c7 c7 e0 af 0d 8c be fd 01 00 00 48 c7 c2 80 b0 0d 8c e8 98 4f 39 f7 e9 6e fe ff ff e8 de ea 59 f7 <0f> 0b b8 ea ff ff ff e9 7a ff ff ff e8 cd ea 59 f7 0f 0b e9 f9 fa
RSP: 0018:ffffc9000bad7b48 EFLAGS: 00010293
RAX: ffffffff8a32fba2 RBX: ffff88803c8b3838 RCX: ffff88802594d7c0
RDX: 0000000000000000 RSI: ffffffff8b0a8b80 RDI: ffffffff8b587580
RBP: ffff888028d65aaa R08: dffffc0000000000 R09: fffffbfff209e051
R10: 0000000000000000 R11: dffffc0000000001 R12: ffff888028d65ab0
R13: ffff88803c8b06c0 R14: ffff888028d64c80 R15: ffff888028d65ad0
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32337000 CR3: 000000007baf6000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 000000000000003b DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ieee80211_set_after_csa_beacon net/mac80211/cfg.c:3523 [inline]
 __ieee80211_csa_finalize net/mac80211/cfg.c:3585 [inline]
 ieee80211_csa_finalize+0x54c/0xe50 net/mac80211/cfg.c:3609
 ieee80211_csa_finalize_work+0xfc/0x140 net/mac80211/cfg.c:3634
 process_one_work+0x915/0x13a0 kernel/workqueue.c:2390
 worker_thread+0xa63/0x1210 kernel/workqueue.c:2537
 kthread+0x270/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
