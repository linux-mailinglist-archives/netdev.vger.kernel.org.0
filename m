Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEE755AA75
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 15:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiFYNWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 09:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiFYNWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 09:22:23 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0E621247
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 06:22:21 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id f18-20020a5d8592000000b0067289239d1dso2993124ioj.22
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 06:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BjZQvvA6i1wTN10u+QILwySJyfFf9Ak+YFbYOo2VvfA=;
        b=7/SJtbCz+AMaWdacdV/Qp+jyD1VQUKNbwStCN/gDEWjukJL+UpUo5i1r7fxNKQwR8d
         sYQvtK6FPH2w0k6/Nsc0GtNqEnD6eR/1Nh4LQflOfrAB0t0SJxqR67Lw3lCNFJLa746G
         j7SvYhpMmrrnDtSlCea9BRIpY+Viui5KhnZ1h1ftAPWppvH55EPD9dScHo37K8UMm9+s
         u78Le0hHygMuhSeqjZNWPuDnitSPhcn/Nwfd1cPxQMe6F7oinLCmeXncLgWzsNIjhOIS
         YgIPvZShHi7NfiiBcPJgNH74ANLcO/sN9osvaIzfLO43ERW1Dusw1O551bCSmHi8nK/F
         qWEg==
X-Gm-Message-State: AJIora+ChKRSKcDp2z/fl/hS9UaR92yDUatG99JOIeDL1oTrHM+1AZI/
        DrZ1K8z3pmQsvA6ZWWeU/Oua8TBtq+fb82AG348gVhZSBtPd
X-Google-Smtp-Source: AGRyM1vPCvxsW13MJIXmV3zpoPlQErTa0y92lXPI5yANXTUncWMJ9kKYo8OM+6Tt72LN9h7CB8anzywiKTd16jlw0rCTPnDfsO7Q
MIME-Version: 1.0
X-Received: by 2002:a05:6638:371e:b0:331:bc34:c3b1 with SMTP id
 k30-20020a056638371e00b00331bc34c3b1mr2534999jav.68.1656163340337; Sat, 25
 Jun 2022 06:22:20 -0700 (PDT)
Date:   Sat, 25 Jun 2022 06:22:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097473905e2459315@google.com>
Subject: [syzbot] WARNING in wdev_chandef
From:   syzbot <syzbot+b4e9aa0f32ffd9902442@syzkaller.appspotmail.com>
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

HEAD commit:    34d1d36073ea Add linux-next specific files for 20220621
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15062b7ff00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b24b62d1c051cfc8
dashboard link: https://syzkaller.appspot.com/bug?extid=b4e9aa0f32ffd9902442
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b4e9aa0f32ffd9902442@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9272 at net/wireless/chan.c:1436 wdev_chandef+0x164/0x1a0 net/wireless/chan.c:1436
Modules linked in:
CPU: 1 PID: 9272 Comm: syz-executor.1 Not tainted 5.19.0-rc3-next-20220621-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:wdev_chandef+0x164/0x1a0 net/wireless/chan.c:1436
Code: f8 48 8d bb b0 00 00 00 be ff ff ff ff e8 c4 66 c5 00 31 ff 89 c5 89 c6 e8 c9 1b c5 f8 85 ed 0f 85 f7 fe ff ff e8 6c 1f c5 f8 <0f> 0b e9 eb fe ff ff 48 c7 c7 4c 70 bd 8d e8 69 39 11 f9 e9 c3 fe
RSP: 0018:ffffc9000302f2f0 EFLAGS: 00010216
RAX: 0000000000000515 RBX: ffff888074ac0c90 RCX: ffffc9000c92a000
RDX: 0000000000040000 RSI: ffffffff88b59de4 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000004 R15: 0000000000000004
FS:  00007f71b11d9700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002022a000 CR3: 000000002a96d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 he_get_txmcsmap net/wireless/nl80211.c:4894 [inline]
 nl80211_parse_tx_bitrate_mask.isra.0+0x3e8/0x2460 net/wireless/nl80211.c:4994
 parse_tid_conf net/wireless/nl80211.c:15379 [inline]
 nl80211_set_tid_config+0x147e/0x18f0 net/wireless/nl80211.c:15444
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
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2489
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2543
 __sys_sendmsg net/socket.c:2572 [inline]
 __do_sys_sendmsg net/socket.c:2581 [inline]
 __se_sys_sendmsg net/socket.c:2579 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f71b0089109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f71b11d9168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f71b019bf60 RCX: 00007f71b0089109
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007f71b00e305d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe9a7e5d8f R14: 00007f71b11d9300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
