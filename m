Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9525418FCB
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 09:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbhI0HVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 03:21:03 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53965 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbhI0HVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 03:21:02 -0400
Received: by mail-io1-f71.google.com with SMTP id g9-20020a056602150900b005d6376bdce7so18159483iow.20
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 00:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HJTwPJ+4jVvs82M6884XSo7mRxi3vygWxCFS8xlsnps=;
        b=VRWIlAsErP+F1uDz7R+hqusSn7pNHK6ab99QVeU3ORlgSsGVz1cmJHuR2cmJDi3Pz6
         KT420zZJgNB2nY+GjlhDxvaKsj9/439KOpfnzW0x1dKKPBleN5WdwJUWwY4AJ6AlILpX
         GzN3gz4Oi9huIzX7Fd4KXw+Ky63rVKBkfXMD9Sh4Cf/bta+EpYeHpoWgaOZ33pwt8wBY
         Z/rqZEYGv2QQGnxUbZ8O1DJlDzF3GNtXFP/Ey+2YS9i6kqsu10aXmsfwYKbFVnyGYMEr
         Nvf/D6Vpz6sFHTUS7PBdsYDtGC8sXx9t/xXi6Xmgnn7AAdxppOimbET32N+Pwkcegazg
         YiMg==
X-Gm-Message-State: AOAM530ZNMuT4cjNXYcMGgTHHo2NXk/rNwSRv2mcnwyUc+3/tJ/HqAhr
        VJhWooRt/gFDPmSqzww73EYQCkt0/SNcS4w1s1dLUNxO3EEz
X-Google-Smtp-Source: ABdhPJx1KpI5cC2MlZsTn36lab01Zs89i7Ym8v75LignfGo/a8nhKA0r+Yk3XpU68iUo6TF9EWHgj/nFGuLMI17hwUahXxv0Fp0m
MIME-Version: 1.0
X-Received: by 2002:a05:6602:345:: with SMTP id w5mr13802057iou.49.1632727164973;
 Mon, 27 Sep 2021 00:19:24 -0700 (PDT)
Date:   Mon, 27 Sep 2021 00:19:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aef88205ccf4ea41@google.com>
Subject: [syzbot] WARNING in cfg80211_bss_update (2)
From:   syzbot <syzbot+0b4e1901856f4895db24@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    428168f99517 Merge branch 'mlxsw-trap-adjacency'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=104c39d7300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
dashboard link: https://syzkaller.appspot.com/bug?extid=0b4e1901856f4895db24
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0b4e1901856f4895db24@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 26433 at net/wireless/scan.c:1574 cfg80211_combine_bsses net/wireless/scan.c:1574 [inline]
WARNING: CPU: 1 PID: 26433 at net/wireless/scan.c:1574 cfg80211_bss_update+0x19fe/0x2070 net/wireless/scan.c:1755
Modules linked in:
CPU: 1 PID: 26433 Comm: kworker/u4:10 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy15 ieee80211_iface_work
RIP: 0010:cfg80211_combine_bsses net/wireless/scan.c:1574 [inline]
RIP: 0010:cfg80211_bss_update+0x19fe/0x2070 net/wireless/scan.c:1755
Code: ff e9 e3 fd ff ff e8 71 37 0b f9 48 8d 7b 98 e8 c8 59 ff ff e9 46 fe ff ff e8 5e 37 0b f9 0f 0b e9 08 f2 ff ff e8 52 37 0b f9 <0f> 0b 4c 89 ff e8 88 99 72 fb 31 ff 89 c6 88 44 24 70 e8 7b 3d 0b
RSP: 0018:ffffc90004a7edc0 EFLAGS: 00010216
RAX: 0000000000001394 RBX: 0000000000000001 RCX: ffffc9000e290000
RDX: 0000000000040000 RSI: ffffffff886ad45e RDI: 0000000000000003
RBP: ffff888019e74400 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff886ac8f4 R11: 0000000000000000 R12: ffff888075a01468
R13: 0000000000000005 R14: ffff888075a01400 R15: ffff888019e74410
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000001f5bb000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cfg80211_inform_single_bss_frame_data+0x6e8/0xee0 net/wireless/scan.c:2411
 cfg80211_inform_bss_frame_data+0xa7/0xb10 net/wireless/scan.c:2444
 ieee80211_bss_info_update+0x376/0xb60 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon+0xcce/0x17c0 net/mac80211/ibss.c:1608
 ieee80211_ibss_rx_queued_mgmt+0xd37/0x1610 net/mac80211/ibss.c:1635
 ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
 ieee80211_iface_work+0xa65/0xd00 net/mac80211/iface.c:1493
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
