Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE05517CC4B
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 06:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCGFkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 00:40:13 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:44310 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgCGFkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 00:40:12 -0500
Received: by mail-io1-f69.google.com with SMTP id q13so2951078iob.11
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 21:40:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qgfToczf7DEQuzSkGPQXLwPPopcDsBOkFi/RISrdjEg=;
        b=QBFkzm8an0bT2lfuuBW0sfKpA9bvKOsTiQEl4mXS9/61rvCBY1EIgIpWGC38I8Tbsq
         MYByHweHIpfJChnMXQBiVLY1hJaZfV77eWW835VmoOZO0pqeFnRAd3LVL98U0au14MS8
         PYy6KBvjT+Bf7FA/D5kkokldDRm3GKU19EDzBqAkMnmg2nv1lSNdxpcTXqKqS3WhbPao
         p888vgsIMpvciu+2Z/cehxXYsqzvvkoduhpUAO+0QFXosz01FHecWTaS3wkvBfF/tIaK
         69SidBoNVDonTv5re/2DruZ6KaiirbTx7iUp1Slkrylklh3XupY4O5e6HfsQZGQyKWrY
         50+w==
X-Gm-Message-State: ANhLgQ3H7847ftjpHf7qRdRoCOPUPXigjsYFsqS1WyaX3eQwWrAXikTI
        8fXxulJ6Mxs/XTpXZKDxaR+PeE510jnDcqsC+wlQiXmOZLBA
X-Google-Smtp-Source: ADFU+vtm0KKw8dNW9tqKxlP/M6gMnwlkK7/bAKoxLPVsGLBR3MWu0u/FfLh16MY8r1ycH0aJdAbWPF2qmQDCK3Aq4zKV/2mFcVCE
MIME-Version: 1.0
X-Received: by 2002:a6b:f60f:: with SMTP id n15mr5740254ioh.32.1583559612127;
 Fri, 06 Mar 2020 21:40:12 -0800 (PST)
Date:   Fri, 06 Mar 2020 21:40:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000295deb05a03d3415@google.com>
Subject: WARNING: ODEBUG bug in rfcomm_dev_ioctl
From:   syzbot <syzbot+4496e82090657320efc6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fb279f4e Merge branch 'i2c/for-current-fixed' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168c481de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b13b05f0e61d957
dashboard link: https://syzkaller.appspot.com/bug?extid=4496e82090657320efc6
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: timer_list hint: rfcomm_dlc_timeout+0x0/0xc0 net/bluetooth/rfcomm/core.c:300
WARNING: CPU: 0 PID: 9181 at lib/debugobjects.c:488 debug_print_object lib/debugobjects.c:485 [inline]
WARNING: CPU: 0 PID: 9181 at lib/debugobjects.c:488 __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
WARNING: CPU: 0 PID: 9181 at lib/debugobjects.c:488 debug_check_no_obj_freed+0x45c/0x640 lib/debugobjects.c:998
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9181 Comm: syz-executor.3 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object lib/debugobjects.c:485 [inline]
RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
RIP: 0010:debug_check_no_obj_freed+0x45c/0x640 lib/debugobjects.c:998
Code: 74 08 4c 89 f7 e8 64 2d 18 fe 4d 8b 06 48 c7 c7 53 10 d1 88 48 c7 c6 0f 01 cf 88 48 89 da 89 e9 4d 89 f9 31 c0 e8 c4 cd ae fd <0f> 0b 48 ba 00 00 00 00 00 fc ff df ff 05 c6 39 b1 05 48 8b 5c 24
RSP: 0018:ffffc90001907c88 EFLAGS: 00010046
RAX: 72f8f847df918a00 RBX: ffffffff88d4edca RCX: 0000000000040000
RDX: ffffc90011373000 RSI: 0000000000013ee9 RDI: 0000000000013eea
RBP: 0000000000000000 R08: ffffffff815e1276 R09: ffffed1015d04592
R10: ffffed1015d04592 R11: 0000000000000000 R12: ffff88808ea6fbac
R13: ffffffff8b592e40 R14: ffffffff890ddc78 R15: ffffffff873dcc50
 kfree+0xfc/0x220 mm/slab.c:3756
 rfcomm_dlc_put include/net/bluetooth/rfcomm.h:258 [inline]
 __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:417 [inline]
 rfcomm_create_dev net/bluetooth/rfcomm/tty.c:486 [inline]
 rfcomm_dev_ioctl+0xe37/0x2340 net/bluetooth/rfcomm/tty.c:588
 rfcomm_sock_ioctl+0x79/0xa0 net/bluetooth/rfcomm/sock.c:902
 sock_do_ioctl+0x7b/0x260 net/socket.c:1053
 sock_ioctl+0x4aa/0x690 net/socket.c:1204
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl fs/ioctl.c:763 [inline]
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl+0xf9/0x160 fs/ioctl.c:770
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c4a9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd490578c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd4905796d4 RCX: 000000000045c4a9
RDX: 0000000020000100 RSI: 00000000400452c8 RDI: 0000000000000004
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000317 R14: 00000000004c5443 R15: 000000000076bf2c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
