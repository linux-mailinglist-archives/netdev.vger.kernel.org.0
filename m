Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC44E834C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfJ2IgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:36:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47985 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbfJ2IgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:36:06 -0400
Received: by mail-io1-f71.google.com with SMTP id r84so10555233ior.14
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cw6cok1K17kDzbl+jeM+X/kALvXMwvoSlXYp5f7esrs=;
        b=log4+nbQ+bWfbyRzrS8MY9vF3rJXy7d2MVosyL9KbqMX5LP7hZFcK+TRRcCmKp5U+T
         DfwqwfKpP9BBMPdblepAvLJCHCf6Ntn5q+91UQdpbn/zZ/f/kXOZgYrMORXY1qu1tWyM
         JIIrhMchEjSixJED7w0iItejiCkRqWAhxYxrge47PEmRIgvBbm13KQ7mVSFhEK8/6QpM
         aeg5VziFXbBUnWs6MqhKSvglMXrXJ8iOtqMrxmdzjsmKvjTERJlG3CvtFuio6x2cQgoS
         Bh5N7J6LUco6lXNVY4CRQ7SB36XA620JUSpo8AcYy3Pzyz3RZILzmCWLZaobSq1PVcB5
         CDMA==
X-Gm-Message-State: APjAAAUQvF2c3COEEqbtIcPun1g07poVYFqWzFhnTZOr2sAvo3bYQwAP
        3btXp2VnwtRrLpC1E9XalW6/dy26FDJOdbeOPC8il1irjBmp
X-Google-Smtp-Source: APXvYqx8tJ7rkDhUNSoMTNMjB0yHs96gPAyCaHWhA8L952o958ZmrxoUQNx+nf8qU8tnTuT4NH3iN+86HFUmmgLqrC9MNMq0vidS
MIME-Version: 1.0
X-Received: by 2002:a92:1696:: with SMTP id 22mr24696502ilw.243.1572338165821;
 Tue, 29 Oct 2019 01:36:05 -0700 (PDT)
Date:   Tue, 29 Oct 2019 01:36:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d73b12059608812b@google.com>
Subject: WARNING in print_bfs_bug
From:   syzbot <syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com, f.fainelli@gmail.com,
        hawk@kernel.org, idosch@mellanox.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, petrm@mellanox.com,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    65921376 Merge branch 'net-fix-nested-device-bugs'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13ee0a97600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0ac4d9b35046343
dashboard link: https://syzkaller.appspot.com/bug?extid=62ebe501c1ce9a91f68c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com

------------[ cut here ]------------
lockdep bfs error:-1
WARNING: CPU: 0 PID: 27915 at kernel/locking/lockdep.c:1696  
print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 27915 Comm: syz-executor.1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
Code: 07 00 74 2d 48 c7 c7 00 5f aa 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b  
41 5c 5d c3 44 89 e6 48 c7 c7 e0 17 ac 87 e8 cc e0 eb ff <0f> 0b 5b 41 5c  
5d c3 0f 0b 48 c7 c7 d8 1f f3 88 e8 bf fc 55 00 eb
RSP: 0018:ffff88801a307688 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 00000000000135ee RSI: ffffffff815cb646 RDI: ffffed1003460ec3
RBP: ffff88801a307698 R08: ffff88809b026340 R09: ffffed1015d04101
R10: ffffed1015d04100 R11: ffff8880ae820807 R12: 00000000ffffffff
R13: ffff88809b026bd8 R14: ffff88801a307710 R15: 00000000000003b0
  check_path+0x36/0x40 kernel/locking/lockdep.c:1772
  check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
  check_prev_add kernel/locking/lockdep.c:2476 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __mutex_lock_common kernel/locking/mutex.c:956 [inline]
  __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  rtnl_lock+0x17/0x20 net/core/rtnetlink.c:72
  vlan_ioctl_handler+0xd2/0xf93 net/8021q/vlan.c:554
  sock_ioctl+0x518/0x790 net/socket.c:1147
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459f39
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f81d8fbec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459f39
RDX: 0000000020000000 RSI: 0800000000008982 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f81d8fbf6d4
R13: 00000000004c1521 R14: 00000000004d4dc0 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
