Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C7F667130
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbjALLrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjALLqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:46:35 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24774101CB
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:37:37 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id o16-20020a056602225000b006e032e361ccso11046922ioo.13
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNqj14hq1ZmMXk1ki/tpD2RyflNBufk7g6Rn75mefPk=;
        b=7m/WwQ9TyJRjdyFSE5tmOW+y5yVUK2PIstjC2BubprEoBKojVU/j6pKGkjQNb9w8iL
         0/Je00SzW+VB2QfaAKzkU4gtw+MBAcIDw2eYJq8gOszQsvEAO1qLXagUg236SLLIfFRi
         bvo10+AcAV9XNHAzHL25xCLYFqqy7zYkB6iaqZXLBIuAcCUp03NYRWuazpu43fsKuwf0
         GByefMeZUNYvQ39cl6gXVC35Io1Mze6ILM5GjE4+m4Nj6HswKJp04yHcPougHhNocT+8
         5/xhP/V6ZUpZbEA5FsUfm0vdOrJ4eNHVd1vHFwVVmKW2bGsKG1mxXEEr2xjDPB3chRDP
         yvdw==
X-Gm-Message-State: AFqh2koyfZ4WGdW0EWefXw35I6CRm2qPMxiCvUW50LH5CTm62pjZjVBn
        d7spWE+ZuBrdl6qPWJYTP+u8TDH+/4FuuNG/h1UW7enWcTcz
X-Google-Smtp-Source: AMrXdXunL+1Lgm4hPngP0/gYdfSj1aFp5ubVrdX479epzsfjt3JEbaGt1aHfc2kM2TclTwPSXvYXIod4yPltKwm3prJ4fdyZ7rf7
MIME-Version: 1.0
X-Received: by 2002:a6b:d111:0:b0:6bc:2a47:a874 with SMTP id
 l17-20020a6bd111000000b006bc2a47a874mr6363310iob.126.1673523456454; Thu, 12
 Jan 2023 03:37:36 -0800 (PST)
Date:   Thu, 12 Jan 2023 03:37:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000253b7305f20f8be8@google.com>
Subject: [syzbot] WARNING in rate_control_rate_init
From:   syzbot <syzbot+352621ea3116a4a2c99b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, trix@redhat.com
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

HEAD commit:    f23395b4049c Merge branch 'net-wangxun-adjust-code-structu..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12f87d76480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46221e8203c7aca6
dashboard link: https://syzkaller.appspot.com/bug?extid=352621ea3116a4a2c99b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5aa1ecd77028/disk-f23395b4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7d8e9efbea4d/vmlinux-f23395b4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/001988a09954/bzImage-f23395b4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+352621ea3116a4a2c99b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 10778 at net/mac80211/rate.c:48 rate_control_rate_init+0x4ed/0x6b0 net/mac80211/rate.c:48
Modules linked in:
CPU: 0 PID: 10778 Comm: syz-executor.5 Not tainted 6.2.0-rc2-syzkaller-00314-gf23395b4049c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:rate_control_rate_init+0x4ed/0x6b0 net/mac80211/rate.c:48
Code: f8 48 c7 c2 c0 31 7c 8b be 19 03 00 00 48 c7 c7 80 31 7c 8b c6 05 f0 d3 16 05 01 e8 ba f5 78 00 e9 33 fe ff ff e8 13 74 3a f8 <0f> 0b e8 0c 32 24 f8 31 ff 89 c3 89 c6 e8 71 70 3a f8 84 db 74 27
RSP: 0018:ffffc900145b7280 EFLAGS: 00010216
RAX: 0000000000002825 RBX: ffff88801cad46e0 RCX: ffffc9000b3ca000
RDX: 0000000000040000 RSI: ffffffff8946de7d RDI: 0000000000000005
RBP: ffff888042a78000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: ffff88801c738de0 R15: ffff88807b9bc000
FS:  00007f6d736d4700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f752b9ad988 CR3: 0000000029022000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 sta_apply_auth_flags.constprop.0+0x424/0x4a0 net/mac80211/cfg.c:1569
 sta_apply_parameters+0xaf8/0x16f0 net/mac80211/cfg.c:1896
 ieee80211_add_station+0x3d0/0x620 net/mac80211/cfg.c:1961
 rdev_add_station net/wireless/rdev-ops.h:201 [inline]
 nl80211_new_station+0x1288/0x1c60 net/wireless/nl80211.c:7398
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6d7288c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6d736d4168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6d729abf80 RCX: 00007f6d7288c0c9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007f6d728e7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffff260419f R14: 00007f6d736d4300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
