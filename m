Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4462F378
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiKRLRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiKRLRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:17:49 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AD099EAD
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:17:48 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id q6-20020a056e020c2600b00302664fc72cso3107880ilg.14
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:17:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=icbM6LR89x3ZTtuCKeMsNpGB89t4A+E9BcUPjncu7JM=;
        b=stRcoGUxsprQmzZMioGfPsrEbef7mOaD8apYImhvOD4JSPHA4BTKGUEMTz7yLtWQ5M
         dJ4X6Xv2Tx0TRD75sU7wmE8tsraukXQWZZ3c4XS9Lm7YbBY1NA1D6A+PGP7/sD0CBghQ
         l9QWxYz1sv4EF9s9rv5RGzlu/a+5ZAZ48N13kY9z/Thwfw9LO0/F27Sr76+03YeVaUzk
         4TcsT9tywuIN9o5RbxgNITLpYPNoqxYAdbqlae0mjE5p4TJZCzaqybP3xcRCz769ZmzZ
         ly4gmC8EMOW0SuffwyzIyAEIp1f5dlzEcrHAg3H3CEmioAOpIMcHqKkisWlpng0K6sDC
         Buzw==
X-Gm-Message-State: ANoB5plXTOzsARIhlrrY1h+nvwTLqgOdrl5TW1GUDVT8z8swdX7GJVIy
        BeAi6e6qFDy81p+Ly6J9/g+0z1JPmEFdclopBaXOEgDLKFxG
X-Google-Smtp-Source: AA0mqf7drEU1YpQnGbg3G2U6EVfhnI+s3wlnztWMe7R1Nu0U4D8BzBehZa99Li6Sogfkxj244qnObNrnPcG6tnR4uCvuQTuxxqQp
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3f06:b0:363:aa8f:e316 with SMTP id
 ck6-20020a0566383f0600b00363aa8fe316mr2908709jab.238.1668770267260; Fri, 18
 Nov 2022 03:17:47 -0800 (PST)
Date:   Fri, 18 Nov 2022 03:17:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fdedc805edbcda46@google.com>
Subject: [syzbot] WARNING in rtnl_dellink (2)
From:   syzbot <syzbot+d8c77f7232bfdb254e37@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        idosch@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, petrm@nvidia.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    a70385240892 Merge tag 'perf_urgent_for_v6.1_rc2' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147717d2880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea03ca45176080bc
dashboard link: https://syzkaller.appspot.com/bug?extid=d8c77f7232bfdb254e37
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5e17f1e83cf3/disk-a7038524.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8ef729877f7/vmlinux-a7038524.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8c77f7232bfdb254e37@syzkaller.appspotmail.com

bond0 (unregistering): (slave bond3): Releasing backup interface
bond0 (unregistering): Released all slaves
------------[ cut here ]------------
WARNING: CPU: 1 PID: 20974 at net/core/dev.c:10871 unregister_netdevice_many+0x13ba/0x1930 net/core/dev.c:10871
Modules linked in:
CPU: 0 PID: 20974 Comm: syz-executor.1 Not tainted 6.1.0-rc1-syzkaller-00454-ga70385240892 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:unregister_netdevice_many+0x13ba/0x1930 net/core/dev.c:10871
Code: 0b e9 27 f1 ff ff e8 75 08 24 fa be 04 00 00 00 4c 89 f7 e8 28 96 ab fc e9 42 fb ff ff 48 89 dd e9 1c f9 ff ff e8 56 08 24 fa <0f> 0b e9 f0 f9 ff ff e8 4a 08 24 fa 0f b6 1d dc e5 73 06 31 ff 89
RSP: 0018:ffffc9000b4ff268 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff88807627c0b0 RCX: ffffc90004743000
RDX: 0000000000040000 RSI: ffffffff8758834a RDI: 0000000000000005
RBP: ffff88801ecf8080 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 000000000008c07e R12: 0000000000000000
R13: ffff88801ecf8080 R14: ffff88807627c000 R15: dffffc0000000000
FS:  00007f42ed863700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f220e57f1b8 CR3: 0000000036be9000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000b002800
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rtnl_delete_link net/core/rtnetlink.c:3123 [inline]
 rtnl_dellink+0x354/0xa90 net/core/rtnetlink.c:3174
 rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6091
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2540
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f42ec68b5f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f42ed863168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f42ec7abf80 RCX: 00007f42ec68b5f9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007f42ec6e67b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f42eccdfb1f R14: 00007f42ed863300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
