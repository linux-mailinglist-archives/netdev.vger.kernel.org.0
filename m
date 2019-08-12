Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114A089E5F
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfHLMaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:30:11 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:54096 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbfHLMaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:30:08 -0400
Received: by mail-ot1-f72.google.com with SMTP id q16so8406373ota.20
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zNDPGmT8G+26asZc3oWG0z1sMep9s7XdIuJHVrTs56k=;
        b=rOwEJthEnFyrxBcc6VX/42Hok6uk64/8Y4LihvuZWHfz4m28MuZLJ7gypUqWM9dy25
         +gew9GiKo3gOyNUuaKcBKFURVU28fjjG4Eozubb6uWS1MuSxuWEMI/bYWgpa9uat8zVi
         MHvObkGg+/TKp5e+nOdL1m7SDXmHIZmZbxp+hxc/oFaJuIadSLYiDpJcP+XkbrgU4kC7
         yEi0DxiAY/JbSfCkg4R/9if1xlcIdexdd9GgCRYqMViOr+D4QcwL6kBRn/h0ti1dH0IU
         7WhY0u59V562EjBHU8dWXl6gZvSn6usz3e8tNAqeHTUERAweuc0O7RkGfjBq/EqLFnX2
         uePA==
X-Gm-Message-State: APjAAAU/zRF+/pcr8pjCVBoffJEytUr6mhuueisg2+YLTMxfsEQ4ba1f
        sMQEpa/106wPYjm4UUErfkwv9v+shmJgDjoAxBQ99zuz5q31
X-Google-Smtp-Source: APXvYqyZzGcFvQpsI+4sC7CHQPAzaqE/uti+1pxPQbJQGViLZPooh4iy4aPBUxAlRx2mjqyXyqM2GIbe6ThZjkFP4XjMUsVrsEhd
MIME-Version: 1.0
X-Received: by 2002:a5d:968b:: with SMTP id m11mr28741858ion.16.1565613007314;
 Mon, 12 Aug 2019 05:30:07 -0700 (PDT)
Date:   Mon, 12 Aug 2019 05:30:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002825fc058feaafc1@google.com>
Subject: WARNING in xfrm_policy_inexact_insert
From:   syzbot <syzbot+0ffe44015de138d98e79@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    296d05cb Merge tag 'riscv/for-v5.3-rc4' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163917c2600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2031e7d221391b8a
dashboard link: https://syzkaller.appspot.com/bug?extid=0ffe44015de138d98e79
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0ffe44015de138d98e79@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 907 at net/xfrm/xfrm_policy.c:1506  
xfrm_policy_insert_inexact_list net/xfrm/xfrm_policy.c:1506 [inline]
WARNING: CPU: 1 PID: 907 at net/xfrm/xfrm_policy.c:1506  
xfrm_policy_inexact_insert+0x102a/0x1540 net/xfrm/xfrm_policy.c:1195
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 907 Comm: syz-executor.2 Not tainted 5.3.0-rc3+ #72
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x25c/0x799 kernel/panic.c:219
  __warn+0x22f/0x230 kernel/panic.c:576
  report_bug+0x190/0x290 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:xfrm_policy_insert_inexact_list net/xfrm/xfrm_policy.c:1506  
[inline]
RIP: 0010:xfrm_policy_inexact_insert+0x102a/0x1540  
net/xfrm/xfrm_policy.c:1195
Code: c1 03 38 c1 0f 8c 0a f7 ff ff 48 89 df e8 6e 3a 38 fb e9 fd f6 ff ff  
e8 44 41 ff fa 48 c7 c7 82 bf 3a 88 31 c0 e8 e9 8a e8 fa <0f> 0b e9 b4 fc  
ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 04 f7 ff
RSP: 0018:ffff888088ca78b0 EFLAGS: 00010246
RAX: 0000000000000024 RBX: ffff8880a752d8a0 RCX: 2f5cd5be3d6cb100
RDX: ffffc9000a35f000 RSI: 0000000000005caf RDI: 0000000000005cb0
RBP: ffff888088ca79b8 R08: ffffffff815cf524 R09: ffffed1015d66088
R10: ffffed1015d66088 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
  xfrm_policy_insert+0xdf/0xce0 net/xfrm/xfrm_policy.c:1574
  pfkey_spdadd+0xe47/0x1980 net/key/af_key.c:2325
  pfkey_process net/key/af_key.c:2834 [inline]
  pfkey_sendmsg+0xacd/0xeb0 net/key/af_key.c:3673
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x60d/0x910 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x17c/0x200 net/socket.c:2363
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa22f5f1c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459829
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa22f5f26d4
R13: 00000000004c76ea R14: 00000000004dceb0 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
