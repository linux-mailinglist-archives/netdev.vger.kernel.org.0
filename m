Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C14647642
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHTgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLHTgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:36:38 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1B26C71B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:36:37 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g7-20020a056e021a2700b0030326ba44e4so2185373ile.13
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:36:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CizNqS/GZTonrF3LdGeiQ8J1oTN8lBn64H60Jh+Cr8o=;
        b=NT2IzmHCFqS6u9zqvMptsUAbv+lewkOl7ukctPFY95CYgTOlvV9lnive6evQAs8kzJ
         d01wNjf+pmk6QP3mUSHYgBS4cNjsySHT4JPRgTj34/QNrlUbos5KeGCMy2i3l7khWBe3
         8p+gXXeVyVh3rq58gVtPdSi8MX3hkTL5Q8ipX4tweFth0n1icl1gGsQ5DKYIRQ7gsI6K
         qEFskNBulPZh67DJghR6Poc44g6lrfqSZE5H0mQBtYnKx0KB2uVchuZdl0t0oQkugnhu
         zeZ8Fk9E1ou35VOevFJ5vx2h1ASdY70N4pdAJ1HH3+8b3Fpduj3nzE3uhouSkNPdZngo
         EN/A==
X-Gm-Message-State: ANoB5plVqW+Xyw/pzcbxApuZwmB28E0C9pbBNHm3rgICtz6AeeI/+sAu
        ItchP8c/ovGttppyzy3uRc3VzeZnoIFCx5uuJsn8/J74GOAr
X-Google-Smtp-Source: AA0mqf4jf5OoHwY6c9nj2dvqXqy/9f37I7axxzbBz8Q0+STPiSzKg1CSgbCb5dseyGD24HYH4VM1jCVHfqfucsDoXxddU4xQUSj3
MIME-Version: 1.0
X-Received: by 2002:a5d:9e4a:0:b0:6de:42ff:d96b with SMTP id
 i10-20020a5d9e4a000000b006de42ffd96bmr32906301ioi.58.1670528196432; Thu, 08
 Dec 2022 11:36:36 -0800 (PST)
Date:   Thu, 08 Dec 2022 11:36:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc5b5a05ef56276d@google.com>
Subject: [syzbot] WARNING in _copy_from_iter
From:   syzbot <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
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

HEAD commit:    591cd61541b9 Add linux-next specific files for 20221207
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15d12929880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b2d3e63e054c24f
dashboard link: https://syzkaller.appspot.com/bug?extid=d43608d061e8847ec9f3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172536fb880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d00a7d880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bc862c01ec56/disk-591cd615.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8f9b93f8ed2f/vmlinux-591cd615.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9d5cb636d548/bzImage-591cd615.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5086 at lib/iov_iter.c:629 _copy_from_iter+0x2ed/0xf70 lib/iov_iter.c:629
Modules linked in:
CPU: 0 PID: 5086 Comm: syz-executor371 Not tainted 6.1.0-rc8-next-20221207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:_copy_from_iter+0x2ed/0xf70 lib/iov_iter.c:629
Code: 77 fd 44 89 fb e9 33 ff ff ff e8 be 34 77 fd be 79 02 00 00 48 c7 c7 e0 59 a6 8a e8 fd 6f b0 fd e9 17 fe ff ff e8 a3 34 77 fd <0f> 0b 45 31 ff e9 7b ff ff ff e8 94 34 77 fd 31 ff 89 ee e8 fb 30
RSP: 0018:ffffc90003e1f828 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888026548000 RSI: ffffffff840a6e5d RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003e1fd00
R13: ffff888079c498f8 R14: ffffc90003e1fd00 R15: 0000000000000000
FS:  0000555557073300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045b630 CR3: 000000007d92a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 copy_from_iter include/linux/uio.h:187 [inline]
 copy_from_iter_full include/linux/uio.h:194 [inline]
 tipc_msg_build+0x2d4/0x10a0 net/tipc/msg.c:404
 __tipc_sendmsg+0xada/0x1870 net/tipc/socket.c:1505
 tipc_connect+0x57b/0x6b0 net/tipc/socket.c:2624
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fac68eeeb19
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe4214d778 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fac68eeeb19
RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00007fac68eb2cc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fac68eb2d50
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
