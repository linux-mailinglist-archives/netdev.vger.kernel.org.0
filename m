Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8C01A62F7
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgDMGPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgDMGPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:15:16 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FE8C008654
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 23:15:14 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id a12so9584783ioe.17
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 23:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hZnovlyZtwDPt3BKlPSdR2ANOMYrJFMgs7FxVxmw4ZY=;
        b=Uau/AVk+jGW/S3QOdazFmtkwph66OlLtcddKINbuPDPTVq06jZJ/MFs0kf1wUjNk8d
         WNxSy/+wcZsRbpXeiSHAd/ebA9ksSURcuKa82vU/EBoB8p6iz6efyynV80w+14yIgUyF
         WrFRFnrRHxdp3Yc4bH/qkLjB8/P/V7YxeiZ9h+Gxvqi3K5wJa0klLQO9YFzAdVNfRfKA
         VENNH7LucB5uTnX0TL6ukE6Ap5QBScklYEaTxxEfM9euzMLBdz8FJl9UuJjyjhdZs5o8
         z0+K2qbp2ViQQ/H2B8rSIKspN3ITVkUYw4szcbSpxe7AGfGRt/yD0YgkZZottp+i/uJt
         h+Iw==
X-Gm-Message-State: AGi0PuYx7JHDH6XhRoiV+c2EQZerus3AZk8uUi4VYOKtvkO27RCQsCNP
        nz8C3c7vAsFueQ9dpVbx1pEgJC1s5VCx4IMRCPQoi3YKMQhs
X-Google-Smtp-Source: APiQypI1DX3eCch75C6Hn90dygVJhYx78BvFMSqdyOf8gzAZY8AhtRlaie/49UnEKT9YDIvxRgsPd91QzsedFygLntitGz8xkyOo
MIME-Version: 1.0
X-Received: by 2002:a02:93cf:: with SMTP id z73mr14821825jah.136.1586758513747;
 Sun, 12 Apr 2020 23:15:13 -0700 (PDT)
Date:   Sun, 12 Apr 2020 23:15:13 -0700
In-Reply-To: <000000000000bb471d05a2f246d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008e73c805a326018b@google.com>
Subject: Re: WARNING in hwsim_new_radio_nl
From:   syzbot <syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=110243b3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
dashboard link: https://syzkaller.appspot.com/bug?extid=a4aee3f42d7584d76761
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=100825afe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10df613fe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com

netlink: 98586 bytes leftover after parsing attributes in process `syz-executor425'.
------------[ cut here ]------------
precision 33020 too large
WARNING: CPU: 1 PID: 6998 at lib/vsprintf.c:2471 set_precision lib/vsprintf.c:2471 [inline]
WARNING: CPU: 1 PID: 6998 at lib/vsprintf.c:2471 vsnprintf+0x1467/0x1aa0 lib/vsprintf.c:2547
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6998 Comm: syz-executor425 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:set_precision lib/vsprintf.c:2471 [inline]
RIP: 0010:vsnprintf+0x1467/0x1aa0 lib/vsprintf.c:2547
Code: a6 bb fd 48 8d 5c 24 48 e9 8e fc ff ff e8 01 a6 bb fd c6 05 bf 06 b0 05 01 48 c7 c7 c1 d3 f2 88 44 89 fe 31 c0 e8 29 ba 8d fd <0f> 0b e9 b7 f6 ff ff e8 dd a5 bb fd c6 05 9a 06 b0 05 01 48 c7 c7
RSP: 0018:ffffc90001647780 EFLAGS: 00010246
RAX: 2f9f2ace1f35b900 RBX: ffffc900016477c8 RCX: ffff88809d86c2c0
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000286
RBP: 80fc0000ffffff02 R08: dffffc0000000000 R09: fffffbfff1628ea5
R10: fffffbfff1628ea5 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff88ea3058 R15: 00000000000080fc
 kvasprintf+0x59/0xf0 lib/kasprintf.c:22
 kasprintf+0x6a/0x90 lib/kasprintf.c:59
 hwsim_new_radio_nl+0x95c/0xf30 drivers/net/wireless/mac80211_hwsim.c:3672
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x1054/0x1530 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f9/0x7c0 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x2a6/0x360 net/socket.c:2449
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffecc373af8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

