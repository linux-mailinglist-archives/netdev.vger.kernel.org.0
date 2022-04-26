Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80050F00E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 07:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiDZFEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 01:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiDZFEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 01:04:31 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82A1CEE1E
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 22:01:24 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id u11-20020a056e021a4b00b002cc315db462so7217567ilv.4
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 22:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LxqcV03nxtRQab3OQQ/+BgCz/sCQjRuCxAx9hrcj9yU=;
        b=qSsNExuMHctGyuU/xexcOGEGVy/MQxWGO0Iy8J9Vu6hqFYTMSURDob2SLqH+UhNXQm
         u448doy4IKnZW9gkXVCG2Anc6Aezf53AC5Fd0Q8Qkfagf0cU/X6/MJGsrMJdy9/pwnpC
         y1KEDFpAzZPRyBKaE8OFA6Zr4H32ES5njXKXNg1mm9MKKSiTpi3nyQQhMurNIB57rQUE
         C29MpTjXVwOll6RXVaTd6njI9PBzOlwuuGnLcpKImw/X7wswyG2dKJK5XXSi/w1S0kHW
         XIzzldfVCwj4KdyUiZJNO4nDxeqPG4K85AFBr0QKNXCTCG71FamRabGWAVAWzmvzNAHY
         ogdg==
X-Gm-Message-State: AOAM530E7OX+6MxTxTY1/frbJuPKcVoAdfWa74O8ReY14YF57P8eDTPS
        NIFbZ9a778Xcexswu/iHT4FN+ngH8zUBMqsq54P9rxqlsN1z
X-Google-Smtp-Source: ABdhPJxiNiWCZ6FKc0zZ4jjLFrau05T3E01K6CXGI3CqXHVUQYlYBO1cIkSLES0EaeP3983LcBM3BgoAitWToutKSknEs4qa1Pfm
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cd2:b0:657:388f:b993 with SMTP id
 j18-20020a0566022cd200b00657388fb993mr8878699iow.54.1650949284109; Mon, 25
 Apr 2022 22:01:24 -0700 (PDT)
Date:   Mon, 25 Apr 2022 22:01:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f1fa405dd87954f@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in mac80211_hwsim_sta_rc_update
From:   syzbot <syzbot+efb5967310cacc5ac63e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
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

HEAD commit:    59f0c2447e25 Merge tag 'net-5.18-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165262fcf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71bf5c8488a4e33a
dashboard link: https://syzkaller.appspot.com/bug?extid=efb5967310cacc5ac63e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+efb5967310cacc5ac63e@syzkaller.appspotmail.com

wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
=============================
WARNING: suspicious RCU usage
5.18.0-rc3-syzkaller-00060-g59f0c2447e25 #0 Not tainted
-----------------------------
drivers/net/wireless/mac80211_hwsim.c:2206 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
4 locks held by kworker/u4:6/3738:
 #0: ffff8881488a1138 ((wq_completion)phy37){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881488a1138 ((wq_completion)phy37){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8881488a1138 ((wq_completion)phy37){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff8881488a1138 ((wq_completion)phy37){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff8881488a1138 ((wq_completion)phy37){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff8881488a1138 ((wq_completion)phy37){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90003fbfda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff888080bf0dc0 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1039 [inline]
 #2: ffff888080bf0dc0 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_rx_queued_mgmt+0x101/0x33b0 net/mac80211/ibss.c:1628
 #3: ffff8880430e9870 (&local->sta_mtx){+.+.}-{3:3}, at: sta_info_insert_rcu+0xc1/0x2b50 net/mac80211/sta_info.c:726

stack backtrace:
CPU: 0 PID: 3738 Comm: kworker/u4:6 Not tainted 5.18.0-rc3-syzkaller-00060-g59f0c2447e25 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy37 ieee80211_iface_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 mac80211_hwsim_sta_rc_update+0x2b8/0x430 drivers/net/wireless/mac80211_hwsim.c:2206
 mac80211_hwsim_sta_add+0xba/0x170 drivers/net/wireless/mac80211_hwsim.c:2224
 drv_sta_add net/mac80211/driver-ops.h:465 [inline]
 drv_sta_state+0x5cf/0x1520 net/mac80211/driver-ops.c:127
 sta_info_insert_drv_state net/mac80211/sta_info.c:575 [inline]
 sta_info_insert_finish net/mac80211/sta_info.c:679 [inline]
 sta_info_insert_rcu+0x14ab/0x2b50 net/mac80211/sta_info.c:736
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:585
 ieee80211_ibss_add_sta+0x405/0x740 net/mac80211/ibss.c:643
 ieee80211_update_sta_info net/mac80211/ibss.c:1027 [inline]
 ieee80211_rx_bss_info net/mac80211/ibss.c:1117 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x271d/0x33b0 net/mac80211/ibss.c:1639
 ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
 ieee80211_iface_work+0xa6f/0xd10 net/mac80211/iface.c:1581
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
