Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6329C18AD2B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 08:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCSHKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 03:10:13 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:32942 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgCSHKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 03:10:13 -0400
Received: by mail-io1-f71.google.com with SMTP id b4so1016454iok.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 00:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q9Kt0NzDUxr8k7sbst9p1vaECfFTjpb4vCfXXGgMRts=;
        b=jeMWyTp51d+ceNOxm20yT1zNmOosKbl0/q1sl3gmwnyMaS2suExB0FQgAGotHSzwGI
         tR2REZCiD+yTKQNM8QWv3gVdwZXcU0WbEVQd9NYkl2GTy/2/dTIIpLQ0jno4ATE5sFMR
         VhRACkURGrate9rP/8tZhFY95eITYSnlwVFGycbKtUiL5QrzNE/qPUxpe5Z9kQJM4WOO
         cQy5IZXzCVYXDF/lolpr4cMyEqSE+S/fOECXFQcAVSxLrqHTvNO5o8stxmiH1w8oD4B9
         c0feQtN8B2bzFQ6v19briTH9L/QdruhJ3Qqiy/SawcXUfFmYZ1i6wbOSKzYI0a7BCqko
         Scig==
X-Gm-Message-State: ANhLgQ1kQX6xOnBCM3f9jmU+e7eUvauwWZJurcdIjxI6RCPypetStujw
        iu/LclRWyBVw5MY/A9/vr7T5OjPhfwQrwekOUmPTqOAsFp0D
X-Google-Smtp-Source: ADFU+vvPcqiRK9kQ/cj0PZoJ4odujOCfciq8aorM980M9A3zHGyVu+zSiBB9I01PKJSAOF2wGtge2nenQkiVJ7aiSpvHyCnAVrQx
MIME-Version: 1.0
X-Received: by 2002:a6b:7c03:: with SMTP id m3mr1506614iok.36.1584601812603;
 Thu, 19 Mar 2020 00:10:12 -0700 (PDT)
Date:   Thu, 19 Mar 2020 00:10:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000269a1405a12fdc77@google.com>
Subject: WARNING in kcm_write_msgs
From:   syzbot <syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        info@metux.net, jonathan.lemon@gmail.com, jslaby@suse.cz,
        kafai@fb.com, kstewart@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        samitolvanen@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        willy@infradead.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    94b18a87 Merge tag 'wireless-drivers-2020-03-13' of git://..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=172427fde00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=52624bdfbf2746d37d70
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 20807 at net/kcm/kcmsock.c:630 kcm_write_msgs+0xfb6/0x1760 net/kcm/kcmsock.c:630
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 20807 Comm: syz-executor.4 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:kcm_write_msgs+0xfb6/0x1760 net/kcm/kcmsock.c:630
Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 5e 05 00 00 48 8b 44 24 50 45 31 e4 48 8b 74 24 08 48 89 70 10 e9 95 f4 ff ff e8 ea 30 58 fa <0f> 0b 41 bc ea ff ff ff e9 83 f4 ff ff e8 d8 30 58 fa 0f 0b e9 1c
RSP: 0018:ffffc900019f7978 EFLAGS: 00010216
RAX: 0000000000040000 RBX: ffff88809bfb6800 RCX: ffffc90012459000
RDX: 00000000000041ee RSI: ffffffff8719e4d6 RDI: 0000000000000001
RBP: 0000000000000000 R08: ffff888051780040 R09: fffffbfff180e59b
R10: fffffbfff180e59a R11: ffffffff8c072cd7 R12: 0000000000008000
R13: ffff888095ee8e00 R14: 00000000000000c0 R15: ffff8880594c7980
 kcm_sendmsg+0x1b67/0x2129 net/kcm/kcmsock.c:1036
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x283/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x49c/0x700 fs/read_write.c:483
 __vfs_write+0xc9/0x100 fs/read_write.c:496
 vfs_write+0x262/0x5c0 fs/read_write.c:558
 ksys_write+0x1e8/0x250 fs/read_write.c:611
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1d680c7c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f1d680c86d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000c4d R14: 00000000004ca084 R15: 000000000076bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
