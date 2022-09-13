Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08255B7B95
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIMTvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIMTvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:51:47 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181BE6BCD9
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:51:43 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id o5-20020a056e02102500b002ddcc65029cso9017052ilj.8
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=4Ja416e6EJtl4Wt4k3rSUiNYJTMdEKf5Mdz7+oJMoaM=;
        b=oq/ThVEz8ANJ5duV5S6S/riMvT/dLd9yz0yfNz1m4LXfv8zWrFfVLtubIqJzuIKgHk
         P8dV8vaDg1WYo31Wyr96CJQNUDGaYi0kgDFDh180lfKyabEizWVGvMI28kBvoat5AIBU
         AABuh5LEBOQR9+jFYyCbZMxbv9RaU1TQSGx2UWgOubcKlB5MFAS8FIgKK2msIp252sGg
         w6DYtIS+yOIuFh46mDO0n6iTCNMYrR7+TnxbU8CWTKED2AzJmd/FZBT8xkW/dHfo4/Lk
         VrlheLpgNdETwDDrQElku6N6401xecmfdEg/U/jwvw9Fw9WcKViI1HYler6GwaeqHqvK
         zCpQ==
X-Gm-Message-State: ACgBeo0oyxj8jFR7HSeTmF9MQDtDbL2+3vwnXP2Eu21vOG+bUxtrijid
        tBAeo+j6J+KJQXmW5dxl8hnq4VQN6rXydy1r2qj8RwKCGMR4
X-Google-Smtp-Source: AA6agR7PzI68sFAEeTK6kqc/EWQIZjiO+xUlEtke6HmJMklycsbSZgPtF3Lv8oRweEc5SEqc1AMHgWLOP1OApBKLU6KC8qd3kkhg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1688:b0:2f2:179b:a648 with SMTP id
 f8-20020a056e02168800b002f2179ba648mr13182154ila.201.1663098702306; Tue, 13
 Sep 2022 12:51:42 -0700 (PDT)
Date:   Tue, 13 Sep 2022 12:51:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000060a74405e8945759@google.com>
Subject: [syzbot] linux-next test error: WARNING in set_peer
From:   syzbot <syzbot+a448cda4dba2dac50de5@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
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

HEAD commit:    0caac1da9949 Add linux-next specific files for 20220913
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=172d78d8880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd6142ea1cf631c
dashboard link: https://syzkaller.appspot.com/bug?extid=a448cda4dba2dac50de5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4916ab25f774/disk-0caac1da.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/16dace3b273b/vmlinux-0caac1da.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a448cda4dba2dac50de5@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: renamed from eth1
netdevsim netdevsim0 netdevsim2: renamed from eth2
netdevsim netdevsim0 netdevsim3: renamed from eth3
------------[ cut here ]------------
memcpy: detected field-spanning write (size 28) of single field "&endpoint.addr" at drivers/net/wireguard/netlink.c:446 (size 16)
WARNING: CPU: 0 PID: 3616 at drivers/net/wireguard/netlink.c:446 set_peer+0x991/0x10c0 drivers/net/wireguard/netlink.c:446
Modules linked in:
CPU: 0 PID: 3616 Comm: syz-executor.0 Not tainted 6.0.0-rc5-next-20220913-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:set_peer+0x991/0x10c0 drivers/net/wireguard/netlink.c:446
Code: 00 e8 63 30 b3 fc b9 10 00 00 00 48 c7 c2 00 4c 72 8a be 1c 00 00 00 48 c7 c7 60 4c 72 8a c6 05 d0 e7 02 09 01 e8 f1 d7 74 04 <0f> 0b e9 03 04 00 00 e8 33 30 b3 fc 89 ee 44 89 ef e8 79 2c b3 fc
RSP: 0018:ffffc90003d4f540 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffc90003d4f6d8 RCX: 0000000000000000
RDX: ffff888072ed57c0 RSI: ffffffff81611eb8 RDI: fffff520007a9e9a
RBP: ffffc90003d4f5e8 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 7720676e696e6e6d R12: 000000000000001c
R13: 0000000000000000 R14: ffff888072f1d104 R15: ffff888024cb0960
FS:  000055555616b400(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa5644d32c0 CR3: 000000006e43c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 wg_set_device+0x8d7/0x11b0 drivers/net/wireguard/netlink.c:589
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:778 [inline]
 genl_rcv_msg+0x3b7/0x630 net/netlink/genetlink.c:795
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2540
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:806
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 __sys_sendto+0x236/0x340 net/socket.c:2117
 __do_sys_sendto net/socket.c:2129 [inline]
 __se_sys_sendto net/socket.c:2125 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2125
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa56343c18c
Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
RSP: 002b:00007ffe4bc97580 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fa5644d4320 RCX: 00007fa56343c18c
RDX: 0000000000000170 RSI: 00007fa5644d4370 RDI: 0000000000000005
RBP: 0000000000000000 R08: 00007ffe4bc975d4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007fa5644d4370 R14: 0000000000000005 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
