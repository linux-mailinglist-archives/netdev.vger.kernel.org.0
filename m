Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51F25B1708
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiIHIb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIHIb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:31:27 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A2528708
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 01:31:26 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id g12-20020a5d8c8c000000b006894fb842e3so10970527ion.21
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 01:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=tmob1Pwx3g7IXf8kuVys20j3kfq72jNaVH4vG9pNamI=;
        b=Blk8L0OKIzybyEkRb0+xEbA6vCvFBHCNp49VL/aTTLGVAEtvzJk9Fc3nsO3zA6cVvW
         9HOBoN+L8nMlxCloVSBSCecFtT/yGLwG0NEgUQcsoRMzjmC4RUq6FwDfFIzYKJ34ft5d
         ZJ/X98uQyGuPiMDTWt/HkVx7YXBNhIQFFLta9B8FivUuM6nf5ov9HcpL1YROFWZh5bO9
         J/dtouko3yMgmf6ZnSBsJ42EsG9e0x0n/7arbezuozeLIhrOi3uCZcv672oXNVpCByzQ
         mMrvuDNesqN59mWoSdM7am9AoK+wADeMALAwqNtyVYM+5/uFYEsbp+OZc4RSqqrx/HhR
         weMQ==
X-Gm-Message-State: ACgBeo2L/aiMjtA+m9n5mij7bmJ8Vd7KDDZCt7/7wWEvgaidhlnsPJ/S
        wbviUCvdkIQBNLwL/gx14DkPwvlE7LVfAdy6/YWWhAQq6HJj
X-Google-Smtp-Source: AA6agR4RyaQZMb0LT52K4J1w2Rh2S6e8XRPB1RjIvWa0mWOqyYR4CkJey2RmksPuRtZZgU0/givQVnJIleHFCKC7PaJf7Q2dp00O
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4303:b0:34c:143b:d394 with SMTP id
 bt3-20020a056638430300b0034c143bd394mr4082777jab.21.1662625885923; Thu, 08
 Sep 2022 01:31:25 -0700 (PDT)
Date:   Thu, 08 Sep 2022 01:31:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000532e0e05e826413c@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in mgmt_index_removed
From:   syzbot <syzbot+844c7bf1b1aa4119c5de@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    e47eb90a0a9a Add linux-next specific files for 20220901
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fad8f5080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7933882276523081
dashboard link: https://syzkaller.appspot.com/bug?extid=844c7bf1b1aa4119c5de
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+844c7bf1b1aa4119c5de@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 4347 at lib/debugobjects.c:509 debug_print_object+0x16e/0x250 lib/debugobjects.c:509
Modules linked in:
CPU: 1 PID: 4347 Comm: syz-executor.1 Not tainted 6.0.0-rc3-next-20220901-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:509
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 00 46 49 8a 4c 89 ee 48 c7 c7 a0 39 49 8a e8 36 a5 3a 05 <0f> 0b 83 05 b5 56 dc 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc900148279c0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff81620448 RDI: fffff52002904f2a
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 203a47554245444f R12: ffffffff89ef0860
R13: ffffffff8a494060 R14: ffffffff816b41b0 R15: 1ffff92002904f43
FS:  00007f431bb46700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000300 CR3: 0000000027d81000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:899 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:870
 debug_timer_assert_init kernel/time/timer.c:792 [inline]
 debug_assert_init kernel/time/timer.c:837 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1257
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1275
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3119
 mgmt_index_removed+0x218/0x340 net/bluetooth/mgmt.c:8964
 hci_sock_bind+0x472/0x1760 net/bluetooth/hci_sock.c:1218
 __sys_bind+0x1e9/0x250 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f431aa89279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f431bb46168 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007f431ab9bf80 RCX: 00007f431aa89279
RDX: 0000000000000006 RSI: 0000000020000300 RDI: 0000000000000004
RBP: 00007f431aae32e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffce33d94af R14: 00007f431bb46300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
