Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0965C16F81
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 05:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfEHDgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 23:36:08 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:44382 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfEHDgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 23:36:07 -0400
Received: by mail-it1-f198.google.com with SMTP id v193so1046546itv.9
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 20:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5dZSJzVyB2gZ6t0seAHk5Qi3NpAEiExb1GD1A6ohrB8=;
        b=tc9hocm+mUwJ0TiT02J68wfw90W8xJHEqgmIsqoR396j0cYKDmAzKmaAKkALUzGUns
         rI9C0S5Z61bXctccps1cTKFU/cLWXHbUY2zdsubw2cB4ERuB8pu2PNF5J2s//ntgsOS4
         oqAlQlVlrBHATORR23SbSOPXszXr4ti91JvELsWr51whhXoJM+xqKeRdn0gbEe8TvEHd
         AwY51YR2L+tbAkqJn4DCvSza6JYG0KRgpgZSRYsdxf5zKeTgZtjnmgRj9Dlnoz1c8Smh
         ZbCbQnP2qEg/n29epRrGrFNl971ix547jEa+r2oy7V+wEJJSJ/PLTSg0QHGCPTU/g0TF
         3Smg==
X-Gm-Message-State: APjAAAUD+VRB+VBogl4P5IDoxs3pKyD0tFhuR+WplTYX3JyXybo2Gn4O
        ngknTTyYPrHaiWDjKRCur80T5IBSAxkSJjJ9/wf80linO1ZG
X-Google-Smtp-Source: APXvYqyvDopLdusXrW7Wfp1Y5mfs8uWUq8XNTfgSfTejHF8cNKXeZaZUCwr3DFE+0yNkV3zvh+Hm2tCGTH8I1ctUgFdD0idYHzH6
MIME-Version: 1.0
X-Received: by 2002:a24:b701:: with SMTP id h1mr1646271itf.178.1557286567110;
 Tue, 07 May 2019 20:36:07 -0700 (PDT)
Date:   Tue, 07 May 2019 20:36:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a573da058858083c@google.com>
Subject: WARNING in cgroup_exit
From:   syzbot <syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
        daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    00c3bc00 Add linux-next specific files for 20190507
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15220ec8a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63cd766601c6c9fc
dashboard link: https://syzkaller.appspot.com/bug?extid=f14868630901fc6151d3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fcf758a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1202ffa4a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 8653 at kernel/cgroup/cgroup.c:6008  
cgroup_exit+0x51a/0x5d0 kernel/cgroup/cgroup.c:6008
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8653 Comm: syz-executor076 Not tainted 5.1.0-next-20190507 #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x75a kernel/panic.c:218
  __warn.cold+0x20/0x47 kernel/panic.c:575
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
RIP: 0010:cgroup_exit+0x51a/0x5d0 kernel/cgroup/cgroup.c:6008
Code: 00 48 c7 c2 20 7f 6d 87 be d3 01 00 00 48 c7 c7 20 80 6d 87 c6 05 01  
93 f1 07 01 e8 fb 03 ed ff e9 b1 fb ff ff e8 96 f9 05 00 <0f> 0b e9 75 fc  
ff ff e8 8a f9 05 00 48 c7 c2 e0 82 6d 87 be 85 02
RSP: 0018:ffff888086c17a80 EFLAGS: 00010093
RAX: ffff88808e99a000 RBX: 0000000000000001 RCX: ffffffff816b0b5e
RDX: 0000000000000000 RSI: ffffffff816b0eea RDI: 0000000000000001
RBP: ffff888086c17b18 R08: ffff88808e99a000 R09: ffffed1010d82f3e
R10: ffffed1010d82f3d R11: 0000000000000003 R12: ffff88808e99a000
R13: ffff8880981c3200 R14: ffff888086c17af0 R15: 1ffff11010d82f52
  do_exit+0x97a/0x2fa0 kernel/exit.c:889
  do_group_exit+0x135/0x370 kernel/exit.c:980
  get_signal+0x425/0x2270 kernel/signal.c:2638
  do_signal+0x87/0x1900 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x244/0x2c0 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:198 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:276 [inline]
  do_syscall_64+0x57e/0x670 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4471e9
Code: e8 3c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 ab 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f479f748db8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dcc38 RCX: 00000000004471e9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dcc38
RBP: 00000000006dcc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc3c
R13: 00007ffd1ab0c31f R14: 00007f479f7499c0 R15: 0000000000000001
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
