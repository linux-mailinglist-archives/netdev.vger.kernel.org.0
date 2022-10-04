Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075A65F3E4D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 10:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJDI1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 04:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJDI1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 04:27:40 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5645A22B25
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 01:27:39 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id d24-20020a05660225d800b006a466ec7746so8522191iop.3
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 01:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=qwFvGbQiWknd7LwkA95D2PQSvo2HDMcPtZb17hQuM8w=;
        b=BGrXWjN7vRNrENUwNUwlc//RIE7BRFgYghokkiINM2iDeMUaMmUervKOZcLhaZym7I
         S0CWqa0XOP+sufVZlQ6pUkymidPA/2jodhhQYJH5M4fAdSIeGxBYTLyPdYSrA/Ix7PZK
         cN4GXPflbKJtgVlI4QvQLooND5VJurq979MgZI2feqbbPC5kEtBaDfvOVsNJpH6FwIyl
         XZlWhURquGU6JitaYH/wHzPlM/DRZLwd0DUsvLDwQ8xE6TDQbcBYXsTliE2Y6KFuc0RC
         KMPjvtcKTOpoLQhU7xlog2DTQko6IymTP0b7PKud1/5/8DE5QszwrzwRZfhCHvUd8mSQ
         LXaw==
X-Gm-Message-State: ACrzQf1geW+8ahEwalObXpptGZGWjeYGTfS+de4y/p6svtfXgmfPybta
        a0tngwvHwweaDeCayY+U3/nWrvgIo8xlU9FO05X9lXHJHoHj
X-Google-Smtp-Source: AMsMyM4SUY8R2gie9r7SVAxXW/957PVuXJtTxAIAe/jdvROQ31EkuzclZr5WncAFPxxQVhBSy+4uHtTuVkM3D/yvxTPPmVmWvNz8
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1644:b0:35a:5304:f19f with SMTP id
 a4-20020a056638164400b0035a5304f19fmr12756572jat.270.1664872058686; Tue, 04
 Oct 2022 01:27:38 -0700 (PDT)
Date:   Tue, 04 Oct 2022 01:27:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a793cc05ea313b87@google.com>
Subject: [syzbot] upstream boot error: WARNING in netlink_ack
From:   syzbot <syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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

HEAD commit:    725737e7c21d Merge tag 'statx-dioalign-for-linus' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10257034880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=486af5e221f55835
dashboard link: https://syzkaller.appspot.com/bug?extid=3a080099974c271cd7e9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com

------------[ cut here ]------------
memcpy: detected field-spanning write (size 28) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)
WARNING: CPU: 3 PID: 3351 at net/netlink/af_netlink.c:2447 netlink_ack+0x8ac/0xb10 net/netlink/af_netlink.c:2447
Modules linked in:
CPU: 3 PID: 3351 Comm: dhcpcd Not tainted 6.0.0-syzkaller-00593-g725737e7c21d #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:netlink_ack+0x8ac/0xb10 net/netlink/af_netlink.c:2447
Code: fa ff ff e8 36 c3 e5 f9 b9 10 00 00 00 4c 89 ee 48 c7 c2 20 3f fb 8a 48 c7 c7 80 3f fb 8a c6 05 e8 98 34 06 01 e8 26 77 a6 01 <0f> 0b e9 3a fa ff ff 41 be 00 01 00 00 41 bd 14 00 00 00 e9 ea fd
RSP: 0018:ffffc900220e7758 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88801a798a80 RCX: 0000000000000000
RDX: ffff8880151c0180 RSI: ffffffff81611cb8 RDI: fffff5200441cedd
RBP: ffff88801ed850c0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000001c R14: ffff88801ec8e400 R15: ffff88801ec8e414
FS:  00007faef0af8740(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff6adbe000 CR3: 0000000027683000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2507
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
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
RIP: 0033:0x7faef0bf0163
Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
RSP: 002b:00007fff6adbdc48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007faef0bf0163
RDX: 0000000000000000 RSI: 00007fff6adbdc90 RDI: 0000000000000010
RBP: 00007fff6adc1ed8 R08: 0000000000000000 R09: 0000000000000000
R10: 00007faef0c6ffc0 R11: 0000000000000246 R12: 0000000000000010
R13: 00007fff6adc1cf0 R14: 0000000000000000 R15: 000055e5ebce0290
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
