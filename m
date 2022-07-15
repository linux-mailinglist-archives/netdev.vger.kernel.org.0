Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDE575B0E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiGOFj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGOFj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:39:26 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1269955086
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:39:25 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id p123-20020a6bbf81000000b00674f66cf13aso1838586iof.23
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=l2QAeekmVrp5Pj3poxHb1l2Iy+FrpOT/BOM8hDiG4Rk=;
        b=E6p+2kWD8RnRlv8QQdoA1AwZxdgIWRKzEJ6hR6avAmaSDFo15d2JMw51ZXLrFoO/uH
         TFMOv33pYI6jGHbwGG4zPIILWjhWGvFrp//pc8Ojl+EFFKwMtttefMSzGztVTvseGDhB
         8TRRVhnDG5zW9ofumUZ2Dx8/lGJKD2egoLmHkrAEPfDjzwKRZHkTrupruhkYOgQdJtaM
         D7C1OjQgMXlc7nXAGvLyEFNKKWP2VK+8eeYoWiI7K5uHmytN+HSt5aJ52g0Dl1IOwzhl
         9fy9Bu3OUxXg6b+c0PzuhZe4P7fx9MNTMcusD466Fat0Hg6oHNfUYnpmownnIp6vb3Z2
         UFlg==
X-Gm-Message-State: AJIora8GYv7Znc22tgTrNaIX7rmwXIQJ9w8Y+lXECLGP3iPmLnQDa8cu
        lIqe4CLwKijrPrXJLlX6bwXlfV38UjZC8Vwjj6rBm1pWf7sd
X-Google-Smtp-Source: AGRyM1vSSfzbRa9xmuhDZdZmSstgn1akAOKI0dDkXGpeqqr34jtiRzZTlUfK5wOkW4HY2cQSfWuPT/sXFk2cMmK9xs7N4VXo5U9/
MIME-Version: 1.0
X-Received: by 2002:a92:8748:0:b0:2d9:3f81:d0b7 with SMTP id
 d8-20020a928748000000b002d93f81d0b7mr6164423ilm.310.1657863564449; Thu, 14
 Jul 2022 22:39:24 -0700 (PDT)
Date:   Thu, 14 Jul 2022 22:39:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d85ed905e3d1707e@google.com>
Subject: [syzbot] upstream test error: INFO: trying to register non-static key
 in ieee80211_do_stop
From:   syzbot <syzbot+82d7f0e2f7a45da561c5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
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

HEAD commit:    e5d523f1ae8f ubsan: disable UBSAN_DIV_ZERO for clang
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11e0ab1c080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=970ac5ffe160d24
dashboard link: https://syzkaller.appspot.com/bug?extid=82d7f0e2f7a45da561c5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+82d7f0e2f7a45da561c5@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 2 PID: 3695 Comm: kworker/u16:3 Not tainted 5.19.0-rc6-syzkaller-00272-ge5d523f1ae8f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 assign_lock_key kernel/locking/lockdep.c:979 [inline]
 register_lock_class+0xf30/0x1130 kernel/locking/lockdep.c:1292
 __lock_acquire+0x10a/0x5660 kernel/locking/lockdep.c:4932
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 ieee80211_do_stop+0xc3/0x1ff0 net/mac80211/iface.c:380
 ieee80211_stop+0xc5/0x610 net/mac80211/iface.c:680
 __dev_close_many+0x1b6/0x2e0 net/core/dev.c:1516
 dev_close_many+0x22c/0x630 net/core/dev.c:1541
 dev_close net/core/dev.c:1567 [inline]
 dev_close+0x16d/0x210 net/core/dev.c:1561
 cfg80211_shutdown_all_interfaces+0x96/0x1f0 net/wireless/core.c:273
 ieee80211_remove_interfaces+0xed/0x820 net/mac80211/iface.c:2212
 ieee80211_unregister_hw+0x47/0x1f0 net/mac80211/main.c:1400
 mac80211_hwsim_del_radio drivers/net/wireless/mac80211_hwsim.c:3964 [inline]
 hwsim_exit_net+0x50e/0xca0 drivers/net/wireless/mac80211_hwsim.c:4731
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:162
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
device hsr_slave_0 left promiscuous mode
device hsr_slave_1 left promiscuous mode
batman_adv: batadv0: Interface deactivated: batadv_slave_0
batman_adv: batadv0: Removing interface: batadv_slave_0
batman_adv: batadv0: Interface deactivated: batadv_slave_1
batman_adv: batadv0: Removing interface: batadv_slave_1
device bridge_slave_1 left promiscuous mode
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
device veth1_macvtap left promiscuous mode
device veth0_macvtap left promiscuous mode
device veth1_vlan left promiscuous mode
device veth0_vlan left promiscuous mode
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
