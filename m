Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6126EAA24
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjDUMRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjDUMRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:17:51 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF321902E
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 05:17:49 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-763646b324aso329413339f.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 05:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682079469; x=1684671469;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=czyz4jPXZl6oM7+PF3+JFt1DVnlTxkTrAGRzEaB5Bgk=;
        b=OJy6Abb0ac0XyVG19BJgI7GZvgghVSXauuWbwKxaWRool3RqNWzMe66nI6ADFmMOnq
         LP5D1KHe8pWJ9tkzJi6qHxtj6S0it3/IoJu7DE7yZb2zdZ5xzNEywWXeJ7AHSJ1XXa4I
         9FJaFFWLcEQcN4BW7CN8J7ve3mm0VL6WEXOWSvAPydtZ8potHoB3e85Lnk/VqUaURTUN
         2WFoDeM4ksnyrUOKgAh7y991Cd1UaOnn1B6zQBVIonWJdCHwm3vRq7ErylHAkOvW3jSK
         lNDl2GbUjnc2YSeyPaQiKV7pyEe0k0Kv998Ypel21YUuLGY+0XUazoEqNal+WXIojH/u
         3zHQ==
X-Gm-Message-State: AAQBX9d302mo7BfjQxkZzD/pPiBnTZesBACMQNZbUAG/nJe68BbiSZxq
        wnlcIrldGRQCOq0LT5+RIYunDK032t3gLmQK1DYfI7xRW2vr
X-Google-Smtp-Source: AKy350Z5L9F4MKiEFyqwzMO/3b69TKAPFK23KWq1pLXa3RrBpmt6Op3F0GyqDOTiThXXlsToK2BvgsLZYKFPH37pwP6WSpwcsuqJ
MIME-Version: 1.0
X-Received: by 2002:a5e:a90b:0:b0:760:efd4:9582 with SMTP id
 c11-20020a5ea90b000000b00760efd49582mr2460102iod.2.1682079469260; Fri, 21 Apr
 2023 05:17:49 -0700 (PDT)
Date:   Fri, 21 Apr 2023 05:17:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fd60705f9d7a53b@google.com>
Subject: [syzbot] [wireless?] WARNING in cfg80211_bss_update (3)
From:   syzbot <syzbot+9d593239580fe3639301@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6a8f57ae2eb0 Linux 6.3-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1716e35bc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11869c60f54496a7
dashboard link: https://syzkaller.appspot.com/bug?extid=9d593239580fe3639301
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/beced60615bb/disk-6a8f57ae.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9ba2bd636062/vmlinux-6a8f57ae.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1f235faaf4bc/bzImage-6a8f57ae.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d593239580fe3639301@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 15587 at net/wireless/scan.c:1584 cfg80211_combine_bsses net/wireless/scan.c:1584 [inline]
WARNING: CPU: 1 PID: 15587 at net/wireless/scan.c:1584 cfg80211_bss_update+0x197d/0x21f0 net/wireless/scan.c:1778
Modules linked in:
CPU: 1 PID: 15587 Comm: kworker/u4:21 Not tainted 6.3.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
Workqueue: phy15 ieee80211_iface_work
RIP: 0010:cfg80211_combine_bsses net/wireless/scan.c:1584 [inline]
RIP: 0010:cfg80211_bss_update+0x197d/0x21f0 net/wireless/scan.c:1778
Code: df 48 c1 ea 03 80 3c 02 00 0f 85 15 06 00 00 49 c7 47 48 00 00 00 00 31 f6 31 ff e8 dd 1e 24 f8 e9 5c f1 ff ff e8 63 22 24 f8 <0f> 0b e9 8a f3 ff ff e8 57 22 24 f8 0f 0b 4c 89 f7 e8 6d 4d b5 fa
RSP: 0018:ffffc9000637f598 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88803b8cd7c0 RSI: ffffffff895ec8fd RDI: 0000000000000000
RBP: ffff88807d2a8000 R08: 0000000000000000 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000094001 R12: ffff8880762a0068
R13: 0000000000000005 R14: 0000000000000006 R15: ffff8880762a0000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f57b2eff8 CR3: 000000007df78000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 cfg80211_inform_single_bss_frame_data+0x72c/0x1020 net/wireless/scan.c:2492
 cfg80211_inform_bss_frame_data+0xc3/0xca0 net/wireless/scan.c:2525
 ieee80211_bss_info_update+0x35c/0xb50 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1120 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1609 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x19c9/0x3030 net/mac80211/ibss.c:1638
 ieee80211_iface_process_skb net/mac80211/iface.c:1583 [inline]
 ieee80211_iface_work+0xa4d/0xd70 net/mac80211/iface.c:1637
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
