Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3684FE733
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358319AbiDLRgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358344AbiDLRgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:36:48 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEA31C133
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:34:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id d19-20020a0566022bf300b00645eba5c992so12036736ioy.4
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=76SE2NB56vXH5NM9G3THUUmZ2Fv37V7kWmVL28ZuXes=;
        b=tOznrC0jMB8O+lLIUJDSHu6+BQIpojgtpqU+uiUn3Gz1Q8Su0My4pQqQuZGX2m/Mmr
         9FLDQsu5T/DZCweCTSdEgN1n2YgPCSCPkk8DyarlflWgXQHybHheixwR+2NNUur4Adta
         JrZvRkGrQE5sLXNJGiuHdadL0VQin/wEHbT5Dvj8RwMrRxFUJQOBhd9EdVjEMABO7YY1
         ptf2b/rwsvsRvwhRhGBsERrFFjLKmM6WIrgGDRIhVCtHzuS8EsstTqmwE41Azhapxf/R
         DU+Urai/ntqq9GxywL5M57pazLzq9LGzQCKJjat3mqgj2AXGNH3lSL0By9kboCsEkszC
         18aw==
X-Gm-Message-State: AOAM533Xlcb4CNzNmWPGzTarcFDdLFPkMoqPLXzwLkHyxhUVJdS0/pN9
        o10gs3X6iN7IlDF2QwWnbMOqn6RRuPTz9JdhOWPJ+FvKSzrf
X-Google-Smtp-Source: ABdhPJw7Ru72pObzE9Ta+Gy9/XRzJSF88PI1vo7s+/HcQl1xcbdg6NKzC7f73j9FYrS1PSgL31qv+xV4Q93w8cztjSqRNAGRc0CS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c48:b0:2cb:cba0:f301 with SMTP id
 d8-20020a056e021c4800b002cbcba0f301mr772266ilg.156.1649784861528; Tue, 12 Apr
 2022 10:34:21 -0700 (PDT)
Date:   Tue, 12 Apr 2022 10:34:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a095a405dc7878c5@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in ieee80211_tx_h_select_key
From:   syzbot <syzbot+e550ebeb0bc610768394@syzkaller.appspotmail.com>
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

HEAD commit:    ce522ba9ef7e Linux 5.18-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b1ddc4f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ac56d6828346c4e
dashboard link: https://syzkaller.appspot.com/bug?extid=e550ebeb0bc610768394
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e550ebeb0bc610768394@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.18.0-rc2-syzkaller #0 Not tainted
-----------------------------
net/mac80211/tx.c:604 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/u4:7/5407:
 #0: ffff888023e70938 ((wq_completion)phy24){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc90002fffd00 ((work_completion)(&(&data->hw_scan)->work)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff88801c127128 (&data->mutex){+.+.}-{3:3}, at: hw_scan_work+0xbd/0xcf0 drivers/net/wireless/mac80211_hwsim.c:2431

stack backtrace:
CPU: 0 PID: 5407 Comm: kworker/u4:7 Not tainted 5.18.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy24 hw_scan_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 ieee80211_tx_h_select_key+0x6ba/0x14a0 net/mac80211/tx.c:604
 invoke_tx_handlers_early+0x9db/0x1cd0 net/mac80211/tx.c:1798
 invoke_tx_handlers net/mac80211/tx.c:1862 [inline]
 ieee80211_tx_prepare_skb+0x1c0/0x4d0 net/mac80211/tx.c:1885
 hw_scan_work+0x7e8/0xcf0 drivers/net/wireless/mac80211_hwsim.c:2478
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
