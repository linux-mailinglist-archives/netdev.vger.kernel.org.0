Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D041A4885
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgDJQcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 12:32:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48121 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgDJQcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 12:32:16 -0400
Received: by mail-il1-f197.google.com with SMTP id a15so2972852ild.14
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 09:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Y0MqekMBiePxJvjoGJydSlkklIk8o/ZxoTDbFCFFc/8=;
        b=qLwJAHEXw47uqC37QtQV+zBi/bf6Sdxs9IJo1oCxXfgvsis6SKBrc0Wb//KFwrkYOP
         0y1Meeg0kRwabAb4CXu1khgRPa91crwhv6r/KrkK593La8djCmLX3lxBOzacqykGdn/b
         MkJLugcENtCjGmppEkU8UHoqoXc7CbX+Hf6jnnvtIe8qCpss5QYBTe8mjjoGhl6+PG56
         oH7Bi6qyogfqTJ+d1ll9fZdDJr0rnC37BFQ0/9Af7KcE2QTrFd+lr8B/0Eb0RZZNMXAx
         eSKtW8fUb3ThwwXjzvzPpjhfJMn2qLEg1ZWTOjOCY+5BMqRaFxrdAOEIQ+5fpMbHg+T4
         HI3Q==
X-Gm-Message-State: AGi0PuZWVnGRzFsMAFXcJD0gmml4DkPVNo33INQN2O5AXoab06icK4Tr
        1Ao48Zm0eR8riHrXFXrIBEX1FqoZigqL3fUG3fJVlutq9lw2
X-Google-Smtp-Source: APiQypJoFJORPYVAk6VZOkifbDZzcNgG0DvutrzmItImErAaHJ1BMnD1HhnCHZ3y8txFO9fEuAWT4N/3Vz76Wki8OvV4SXXrwplb
MIME-Version: 1.0
X-Received: by 2002:a92:3408:: with SMTP id b8mr5273262ila.68.1586536336014;
 Fri, 10 Apr 2020 09:32:16 -0700 (PDT)
Date:   Fri, 10 Apr 2020 09:32:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb471d05a2f246d7@google.com>
Subject: WARNING in hwsim_new_radio_nl
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

Hello,

syzbot found the following crash on:

HEAD commit:    5d30bcac Merge tag '9p-for-5.7-2' of git://github.com/mart..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119383b3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65d386b867ba5289
dashboard link: https://syzkaller.appspot.com/bug?extid=a4aee3f42d7584d76761
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com

------------[ cut here ]------------
precision 33020 too large
WARNING: CPU: 0 PID: 25816 at lib/vsprintf.c:2471 set_precision lib/vsprintf.c:2471 [inline]
WARNING: CPU: 0 PID: 25816 at lib/vsprintf.c:2471 vsnprintf+0x1467/0x1aa0 lib/vsprintf.c:2547
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 25816 Comm: syz-executor.0 Not tainted 5.6.0-syzkaller #0
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
Code: f5 6e f9 48 8d 5c 24 48 e9 8e fc ff ff e8 81 f5 6e f9 c6 05 a6 4e 63 01 01 48 c7 c7 c1 69 0a 89 44 89 fe 31 c0 e8 29 09 41 f9 <0f> 0b e9 b7 f6 ff ff e8 5d f5 6e f9 c6 05 81 4e 63 01 01 48 c7 c7
RSP: 0018:ffffc90016587780 EFLAGS: 00010246
RAX: 2f3b2aeaadea7400 RBX: ffffc900165877c8 RCX: 0000000000040000
RDX: ffffc90001f09000 RSI: 0000000000009177 RDI: 0000000000009178
RBP: 80fc0000ffffff02 R08: dffffc0000000000 R09: fffffbfff162889d
R10: fffffbfff162889d R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff88ea1fb0 R15: 00000000000080fc
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
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb9e5575c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fb9e55766d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f5 R14: 00000000004ccb09 R15: 000000000076bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
