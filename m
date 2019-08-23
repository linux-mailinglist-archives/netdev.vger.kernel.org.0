Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF499B20C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395343AbfHWOdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:33:09 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:45919 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395335AbfHWOdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 10:33:07 -0400
Received: by mail-io1-f72.google.com with SMTP id e20so11225734ioe.12
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 07:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tq7Jw6SrnSfUoJ4hJwFy3Z1HYUI0Qv2w/PUYUtFSAsM=;
        b=WxO01gYGKdGIBWq5DIENvrvOeUSVDz4S2auwK4kT/CBvBcOvYbJ7PWCJ/LkaqcRS/u
         sCJHv7z0JoBJTSdte2C0hYX41tSJvUBmlu5MxVcLCvLyQE80fQBSCT7XmOcHgWiDpybc
         frf4KGQ2u8ixZNXRdrCcFjSRTtuqOgczBivJMhHo4WjhStNlguXR47ictBqHA4Ba/qTi
         Xiq42cfYuNPXl3DM0APWCrgwBoG/tCUb3yunN7vniOtWLB0fmD0Te8qSTdApE8G5nfwn
         0vM1K2pnEgehG60ncO9R9ZtYm/wh9lpd7DSMq+qeQiBKuuhSYx75U1eEZPiKAuqVuEME
         4/mQ==
X-Gm-Message-State: APjAAAUlT3mdjpxlQ5n8XbJr7nG0ukYSH+i+P6g5ajCYOdgT8L/s0xL/
        Dz/5JvDZnFTZHSiZYS9DDMe4Q/vVyJ3UpTPW8QQPnbYXdSIj
X-Google-Smtp-Source: APXvYqzS/77kZr9waqajqpiOTNdu3Q5rrmDv7WcWt+0cT0dt5T+e06aDEiHc0nrDV+PZ9oeBuIkbnstfUzz7eSdx9Fhh/qEI1JfM
MIME-Version: 1.0
X-Received: by 2002:a5e:a811:: with SMTP id c17mr6793074ioa.122.1566570786561;
 Fri, 23 Aug 2019 07:33:06 -0700 (PDT)
Date:   Fri, 23 Aug 2019 07:33:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fac1d0590c9afef@google.com>
Subject: WARNING in sk_msg_check_to_free
From:   syzbot <syzbot+ea3c54a7b2364123d818@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fed07ef3 Merge tag 'mlx5-updates-2019-08-21' of git://git...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150102bc600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e34a4fe936eac597
dashboard link: https://syzkaller.appspot.com/bug?extid=ea3c54a7b2364123d818
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ea3c54a7b2364123d818@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 14478 at include/linux/skmsg.h:129  
sk_msg_check_to_free.isra.0.part.0+0x15/0x19 include/linux/skmsg.h:129
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 14478 Comm: syz-executor.0 Not tainted 5.3.0-rc5+ #143
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:219
  __warn.cold+0x20/0x4c kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:sk_msg_check_to_free.isra.0.part.0+0x15/0x19  
include/linux/skmsg.h:129
Code: 77 ff ff ff e8 4e de 03 fc eb 96 4c 89 f7 e8 e4 dd 03 fc eb c3 55 48  
89 e5 e8 f9 b4 c9 fb 48 c7 c7 80 3a 48 88 e8 c1 55 b3 fb <0f> 0b 5d c3 e8  
e4 b4 c9 fb e8 dd ff ff ff 48 8b 45 d0 0f b6 00 41
RSP: 0018:ffff88806381fb98 EFLAGS: 00010286
RAX: 0000000000000024 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c2456 RDI: ffffed100c703f65
RBP: ffff88806381fb98 R08: 0000000000000024 R09: ffffed1015d060d1
R10: ffffed1015d060d0 R11: ffff8880ae830687 R12: 000000000000000d
R13: ffff8880986c1550 R14: 0000000000000001 R15: 0000000000000007
  sk_msg_check_to_free include/linux/skmsg.h:129 [inline]
  __sk_msg_free.cold+0xa/0x2e net/core/skmsg.c:190
  sk_msg_free+0x44/0x60 net/core/skmsg.c:207
  tls_sw_release_resources_tx+0x268/0x6b0 net/tls/tls_sw.c:2092
  tls_sk_proto_cleanup net/tls/tls_main.c:275 [inline]
  tls_sk_proto_close+0x6a7/0x990 net/tls/tls_main.c:305
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413511
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffdca8135c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000413511
RDX: 0000001b31920000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000025038832 R09: 0000000025038836
R10: 00007ffdca8136a0 R11: 0000000000000293 R12: 000000000075bf20
R13: 000000000009f412 R14: 0000000000760b20 R15: ffffffffffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
