Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9746D38F4
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjDBQVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBQVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:21:43 -0400
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729A8A5D7
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:21:42 -0700 (PDT)
Received: by mail-il1-f208.google.com with SMTP id z19-20020a056e02089300b00326098d01d9so13241795ils.2
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 09:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680452501; x=1683044501;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x07zT0iCo8wKSCVHAjMWe9fzPd0xcWscECCQqfth9ec=;
        b=P5bcs5MNIG0h0KozN/z4TLr5/61IPiqWU5xGXaiwtdwcbggH8pvxjEpU8q4i44jg83
         hPZBF5frAwpy42UUmUfwL7w4BEwhnvC+OZSzmiSI9JLT+1RXjEpaz6HMyMVrMxtYuIiN
         ojI/cFOFceCPKLMgPhNBgzF7MC4ZfuTAsjPS6voX7P0C/Gu2PFgm+WXpau8QesXZpPb6
         Xj4D6s6+30GGFl9dyKmxHVfv05W8lFcKBRaM8nWYPLTPKu4MSMYSvo7dU1YmfI+WsyaH
         zowtvlDEPXgOhtUsHOxi6wbn9ERfZ19TDss2+5wEAkpEMpqWqf9RFDInH1oR4H4zWjpC
         t59g==
X-Gm-Message-State: AO0yUKW3GmQhTKeyuOnagkzLzLSy1XZ15cOgXtcB9GEWXze5Mgjg5n+5
        RMqEHA3JvnFuYf4qC8Mt4E3GueqwiCiNLXQX0JnalZU+Rwsa
X-Google-Smtp-Source: AK7set/bi4Wd8lT1rCMiTGzNOyybxOUDZmKUSa9kdAtlHK8uWQPRWN6MUSWo+nKl5CElpWkF1FRUS2BSDjTGx3V8qNzYyMWb71Em
MIME-Version: 1.0
X-Received: by 2002:a5e:db05:0:b0:745:6788:149f with SMTP id
 q5-20020a5edb05000000b007456788149fmr12143135iop.0.1680452501731; Sun, 02 Apr
 2023 09:21:41 -0700 (PDT)
Date:   Sun, 02 Apr 2023 09:21:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d817e05f85cd6a8@google.com>
Subject: [syzbot] [nfc?] UBSAN: shift-out-of-bounds in nci_activate_target
From:   syzbot <syzbot+0839b78e119aae1fec78@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    198925fae644 Add linux-next specific files for 20230329
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1174a6d1c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91e70627549fd509
dashboard link: https://syzkaller.appspot.com/bug?extid=0839b78e119aae1fec78
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/53c685bee82f/disk-198925fa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/45e82baa3bc5/vmlinux-198925fa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7c31fbc6acb9/bzImage-198925fa.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0839b78e119aae1fec78@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in net/nfc/nci/core.c:912:45
shift exponent 4294967071 is too large for 32-bit type 'int'
CPU: 1 PID: 30237 Comm: syz-executor.2 Not tainted 6.3.0-rc4-next-20230329-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_shift_out_of_bounds+0x221/0x5a0 lib/ubsan.c:387
 nci_activate_target.cold+0x1a/0x1f net/nfc/nci/core.c:912
 nfc_activate_target+0x1f8/0x4c0 net/nfc/core.c:420
 nfc_genl_activate_target+0x1f3/0x290 net/nfc/netlink.c:900
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2572
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc4abc8c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc4aca02168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc4abdabf80 RCX: 00007fc4abc8c0f9
RDX: 0000000000000000 RSI: 0000000020000780 RDI: 0000000000000005
RBP: 00007fc4abce7b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffcb707727f R14: 00007fc4aca02300 R15: 0000000000022000
 </TASK>
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
