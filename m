Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54754E5803
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343905AbiCWSDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiCWSDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:03:52 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FE8396B7
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:21 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id u10-20020a5ec00a000000b00648e5804d5bso1552000iol.12
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HZKcxTd8yBjcuCzsi5LaWFbMjBot/jNyVQw48+3QEKE=;
        b=oIoblytbfpgFtDoSeAkNesr/HTLm+ssLls3k/a4t2qFLjAzzqh477M0+SyqnauS9q9
         xNuR8s16CXuLXXRWBvvXlpx2rweQH+Z4jAIqbTW913Z0YCguDOPQ8A5zuFqSL/MtbRVA
         v9s8+h3DU5Q/orREeVKsU/f3hiz9cLp1R3HMTh9/PWjwcabmX4Xgds+Xln22+32ny4GE
         emgHYpVZ3fA5HqBEq3ofXIJhRVDr5vxhFytRFKBr1Y5AtEEMH1kpor4Cjh8TG7t/dLf0
         /lz3sGQAlsoY1iGTNEdbIVOAOiq+OtyvDBVmagsh5/eJNYvtW/pkxQr3JLZKSb5wrsFC
         PNgg==
X-Gm-Message-State: AOAM531RPP2WSuS7AvXxIvYZNwrcWtpcmQWjNcJUfqDed8DVI1ruDPZL
        0X4nadfVkIuQKhDCl3YA8MT2IH1mO59/2LOe1gr0dw2MhOR9
X-Google-Smtp-Source: ABdhPJy4ryZML6boSyKCoxyWPJyLTqtm/xisM+H+IOjG+Nwayo7G7wbl+ObA0qqhNpIbTCLIwVvKnXbYS3KF2VjRdNsbTadybvkv
MIME-Version: 1.0
X-Received: by 2002:a05:6638:264b:b0:31a:84d7:7281 with SMTP id
 n11-20020a056638264b00b0031a84d77281mr636739jat.288.1648058540624; Wed, 23
 Mar 2022 11:02:20 -0700 (PDT)
Date:   Wed, 23 Mar 2022 11:02:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e20ce905dae687ee@google.com>
Subject: [syzbot] WARNING in ieee80211_mgd_probe_ap_send
From:   syzbot <syzbot+07aa0ff28ef3cc7c3793@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    14702b3b2438 Merge tag 'soc-fixes-5.17-4' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d33aeb700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d35f9bc6884af6c9
dashboard link: https://syzkaller.appspot.com/bug?extid=07aa0ff28ef3cc7c3793
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+07aa0ff28ef3cc7c3793@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1087 at net/mac80211/mlme.c:2563 ieee80211_mgd_probe_ap_send+0x506/0x5d0 net/mac80211/mlme.c:2563
Modules linked in:
CPU: 0 PID: 1087 Comm: kworker/u4:5 Not tainted 5.17.0-rc8-syzkaller-00077-g14702b3b2438 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy23 ieee80211_beacon_connection_loss_work
RIP: 0010:ieee80211_mgd_probe_ap_send+0x506/0x5d0 net/mac80211/mlme.c:2563
Code: f8 48 c7 c2 60 05 d0 8a be d3 02 00 00 48 c7 c7 c0 05 d0 8a c6 05 60 18 d0 04 01 e8 2d 05 59 00 e9 34 fe ff ff e8 6a 4e c9 f8 <0f> 0b e9 c5 fe ff ff e8 de c7 10 f9 e9 3a fb ff ff 4c 89 e7 e8 e1
RSP: 0018:ffffc90004e07c80 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff88801c1fd700 RSI: ffffffff88af71c6 RDI: 0000000000000000
RBP: ffff88801dff0cc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88801dff12d0
R13: ffff88805dc3d0b8 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f43a4a93a0 CR3: 0000000061885000 CR4: 00000000003506e0
Call Trace:
 <TASK>
 ieee80211_mgd_probe_ap.part.0+0x30a/0x480 net/mac80211/mlme.c:2653
 ieee80211_mgd_probe_ap net/mac80211/mlme.c:2597 [inline]
 ieee80211_beacon_connection_loss_work+0x147/0x180 net/mac80211/mlme.c:2787
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
