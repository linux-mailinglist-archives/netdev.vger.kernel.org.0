Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FBA565E0A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiGDTeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiGDTea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:34:30 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3A625EA
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:34:29 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id h73-20020a6bb74c000000b0067275998ba8so5832524iof.2
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 12:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5j8MhXW0pNg1Qth5r2dfWJalgtseUieCFeaSOlN4/2M=;
        b=S4lm9gBmaw6w/kD3usjWsdPYdN6ito0H7q9tt99EpEA46mkv1o0vJeOab6zZc3S0j6
         QeEwBgMvgma0zIjfNHE9l+Gb1Ym+nAH99ypnu0R5wGs0zQj2PSscIbAWv9ZTX/uLffSG
         ofeWYrqdFZjPD/i1agLRPuAEMxbX0Vzl1DBRNO6keGsQo8Uwa9om9XsYmMFLIPEuSH6Y
         yZPm/ZDrlB2O8HiTtPBhqCbzYk2cD7UyWq2nRqrXA3vzTa8L51xk15dzVCGocMzLTbV+
         C52+kaIx9Y57fLSgnsD8qv3oKH5rTY9R2birXiizdW3b1W+0oxqBxq4fNerY6Bs8Lt7m
         rAGQ==
X-Gm-Message-State: AJIora/DPrmJK93bAIl8Q3YEnbu3ksSzxXb4jkJq/qHObheh2/8jc7qX
        +FMd75E010vyVau1sM87uGtackX42un1nVn+2qsenPdVUsst
X-Google-Smtp-Source: AGRyM1tEiBIh/F6cinQ2Fxcr8U/1XIe8yW0Syg0e68vQXdSkt5e8/QIGuJbgeNm9HxgxERfPRvT0s9khSbWKFSvFTeMgailgjgAS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16cc:b0:2da:63c7:257e with SMTP id
 12-20020a056e0216cc00b002da63c7257emr17680833ilx.285.1656963268567; Mon, 04
 Jul 2022 12:34:28 -0700 (PDT)
Date:   Mon, 04 Jul 2022 12:34:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000768a805e2ffd3c3@google.com>
Subject: [syzbot] WARNING in sta_info_insert_rcu (2)
From:   syzbot <syzbot+f15276a56871c04c7c4e@syzkaller.appspotmail.com>
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

HEAD commit:    1a0e93df1e10 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17698be4080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=833001d0819ddbc9
dashboard link: https://syzkaller.appspot.com/bug?extid=f15276a56871c04c7c4e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f15276a56871c04c7c4e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 16069 at net/mac80211/sta_info.c:555 sta_info_insert_check net/mac80211/sta_info.c:555 [inline]
WARNING: CPU: 1 PID: 16069 at net/mac80211/sta_info.c:555 sta_info_insert_rcu+0x284/0x2b50 net/mac80211/sta_info.c:736
Modules linked in:
CPU: 0 PID: 16069 Comm: syz-executor.2 Not tainted 5.19.0-rc4-syzkaller-00044-g1a0e93df1e10 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/18/2022
RIP: 0010:sta_info_insert_check net/mac80211/sta_info.c:555 [inline]
RIP: 0010:sta_info_insert_rcu+0x284/0x2b50 net/mac80211/sta_info.c:736
Code: ba f8 44 89 e6 31 ff 83 e6 01 40 88 b5 38 ff ff ff e8 40 d2 ba f8 0f b6 85 38 ff ff ff 84 c0 0f 84 fa 00 00 00 e8 2c d6 ba f8 <0f> 0b 41 bc ea ff ff ff e8 1f d6 ba f8 48 8b bd 28 ff ff ff 4c 89
RSP: 0018:ffffc9000febeb30 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88801ca90c80 RCX: 0000000000000000
RDX: ffff8880795cbb00 RSI: ffffffff88bf9084 RDI: 0000000000000005
RBP: ffffc9000febec78 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000110208
R13: ffff888016fb8048 R14: ffff888044711798 R15: ffff888016fb8000
FS:  00007f2220d12700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200bd038 CR3: 000000001f5f5000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 sta_info_insert+0x13/0xb0 net/mac80211/sta_info.c:749
 ieee80211_prep_connection+0x31ca/0x44b0 net/mac80211/mlme.c:5701
 ieee80211_mgd_auth.cold+0x287/0x46d net/mac80211/mlme.c:5846
 rdev_auth net/wireless/rdev-ops.h:458 [inline]
 cfg80211_mlme_auth+0x3bd/0x760 net/wireless/mlme.c:273
 cfg80211_conn_do_work+0xc3f/0xf50 net/wireless/sme.c:170
 cfg80211_sme_connect net/wireless/sme.c:581 [inline]
 cfg80211_connect+0x10a5/0x2020 net/wireless/sme.c:1255
 nl80211_connect+0x1682/0x22e0 net/wireless/nl80211.c:11274
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f221fc89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2220d12168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f221fd9bf60 RCX: 00007f221fc89109
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00007f221fce305d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd01bab36f R14: 00007f2220d12300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
