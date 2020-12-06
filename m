Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C12A2D0603
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 17:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgLFQhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 11:37:51 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:43629 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgLFQhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 11:37:51 -0500
Received: by mail-il1-f200.google.com with SMTP id p6so7848775ils.10
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 08:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zsuPNydmjozr39AAHZE2NJ8iaBaXXZJv+6EgpqpR/Ss=;
        b=lPWXzaACvPFDpbnQB4MFl7xZZM5L6lYPEYE/mOFVj2Bcf2Qk/OxL1AYULixJ9D6Dd0
         JKlmFna5lCn+tqpn0xeidLkySP/iN1GtC0W2g2i/kUClFyYA68fJBCr51JtP+QnAwOBi
         liXChx4MhCvtko1bIzlQY/h3DhqyB8huLr+2W8/o2J65i1tdAgaZ3Mp3Xyetec+65MlJ
         yDikfqFkT5zFcLKfycADfqGe7I5SNamLQmfEglITFbujqIMSi/2uiyFR435B7s7bxCb0
         IuqVR7EkHqmZS6LsuF8QQPod3x6h5SpGi08MzSVlwyqTDMJ0P26svLRUkJ3iGGaVwX2X
         8D6A==
X-Gm-Message-State: AOAM5316uTXBpZiofsbwtWcBViPtSYwOauTcEergwOfQd8XRWcOgrgI1
        8Wql9fZ2xxPpSneVwx4f2CfEJ/tlJ6PjUh/7v9Hfa8sxCY8r
X-Google-Smtp-Source: ABdhPJw4x0qTJTBP9Ao5DDJQGmdUohkdbhUzfFIIX0Wd9yFEyjhWnvpimS6oha06lxJeO8KzWGTQoaAVjroY7Sz50Il1BY1X5mtV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:926:: with SMTP id o6mr15660312ilt.65.1607272629912;
 Sun, 06 Dec 2020 08:37:09 -0800 (PST)
Date:   Sun, 06 Dec 2020 08:37:09 -0800
In-Reply-To: <00000000000088b1f405b00bcbb8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029c89c05b5ce5237@google.com>
Subject: Re: WARNING in __cfg80211_ibss_joined (2)
From:   syzbot <syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7059c2c0 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a1199b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e49433cfed49b7d9
dashboard link: https://syzkaller.appspot.com/bug?extid=7f064ba1704c2466e36d
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146ff2ef500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105d68df500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9804 at net/wireless/ibss.c:36 __cfg80211_ibss_joined+0x487/0x520 net/wireless/ibss.c:36
Modules linked in:
CPU: 1 PID: 9804 Comm: kworker/u4:6 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cfg80211 cfg80211_event_work
RIP: 0010:__cfg80211_ibss_joined+0x487/0x520 net/wireless/ibss.c:36
Code: 0f 0b e9 0c fe ff ff e8 b7 55 7a f9 e9 41 fc ff ff e8 8d 55 7a f9 e9 7d fc ff ff e8 a3 55 7a f9 e9 0d ff ff ff e8 29 d7 38 f9 <0f> 0b e9 7e fc ff ff e8 1d d7 38 f9 0f 0b e8 96 55 7a f9 e9 e4 fb
RSP: 0018:ffffc9000a85fbd8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888014edcc10 RCX: ffffffff8155a937
RDX: ffff88802295b480 RSI: ffffffff88372d57 RDI: 0000000000000000
RBP: ffff888014edc000 R08: 0000000000000001 R09: ffffffff8ebaf6bf
R10: fffffbfff1d75ed7 R11: 0000000000000000 R12: 1ffff9200150bf7d
R13: ffff88803471e818 R14: 0000000000000000 R15: 0000000000000006
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020e0a000 CR3: 0000000025d73000 CR4: 0000000000350ee0
Call Trace:
 cfg80211_process_wdev_events+0x3de/0x5b0 net/wireless/util.c:942
 cfg80211_process_rdev_events+0x6e/0x100 net/wireless/util.c:968
 cfg80211_event_work+0x1a/0x20 net/wireless/core.c:322
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

