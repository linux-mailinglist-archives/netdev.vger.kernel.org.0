Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A166E1B4
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 09:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfGSH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 03:28:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56929 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfGSH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 03:28:06 -0400
Received: by mail-io1-f69.google.com with SMTP id u25so33460270iol.23
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 00:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZOKptcEQOKWGsH6kGRMFGwq91Xnv2C9B1wmV09hcJ5c=;
        b=kSBXwKQ8fK4fEzD28DGh7bKcMW5h554PDzPPGpyaBe6NCgrprla/ozsBd7lDEt3X44
         7JH2FUAgv1QpAwjzP5ZJqrzLOQl6szWejWZXGJcUJdtzqWDoZniSJgXs8pqEzelm0AYB
         TRn1l3TBHe37BCTnq2yHUw2xlOICxytVINTZfADehesRvahxMCDXPAoxSBSjnq9uh6xq
         cUm6HapCtVr0ghRwNc4ApjsB43ip71BQ6rCGDwnEHR/Kv0nWBbPnAsbp/9JskUx+ShPD
         vJFQcQeQmIrRz1brhdkzqUNlQH5ZW4BWDEmohJmgP1KhkkIVVmXTC2G1XSRDhZLxEeiK
         V+tQ==
X-Gm-Message-State: APjAAAVTgnBochPQknn2QYnOzMXO5EQAlGvkPJe8vtZ7MKQsjEwG7b5t
        enSYB0GrrwVoCwlz5xdyoR86mBkWqB1Hxyb1B0lDiL9z7SWV
X-Google-Smtp-Source: APXvYqwq1aitWQEim6lQXQr33Kk51C3EOokbRynQEU6MrgfMrNRrXpweFrRMsyfcmQvBV6/b6gCQupDYuZMxFC/ee0R0bXMv0cj+
MIME-Version: 1.0
X-Received: by 2002:a5d:9e48:: with SMTP id i8mr46417366ioi.51.1563521285924;
 Fri, 19 Jul 2019 00:28:05 -0700 (PDT)
Date:   Fri, 19 Jul 2019 00:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8b010058e03aaf8@google.com>
Subject: BUG: unable to handle kernel paging request in corrupted (2)
From:   syzbot <syzbot+08b7a2c58acdfa12c82d@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    49d05fe2 ipv6: rt6_check should return NULL if 'from' is N..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=104b5f70600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
dashboard link: https://syzkaller.appspot.com/bug?extid=08b7a2c58acdfa12c82d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143a78f4600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+08b7a2c58acdfa12c82d@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
BUG: unable to handle page fault for address: 00000000ffffffff
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 9ad32067 P4D 9ad32067 PUD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9920 Comm: syz-executor.1 Not tainted 5.2.0+ #91
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
BUG: kernel NULL pointer dereference, address: 0000000000000002
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 9ad32067 P4D 9ad32067 PUD 9ad33067 PMD 0
Oops: 0010 [#2] PREEMPT SMP KASAN
CPU: 0 PID: 9920 Comm: syz-executor.1 Not tainted 5.2.0+ #91
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:0x2
Code: Bad RIP value.
RSP: 0000:ffff888092932a20 EFLAGS: 00010086
RAX: 000000000000002d RBX: ffff888092932a40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c1016 RDI: ffffed1012526536
RBP: ffffffff81724d28 R08: 000000000000002d R09: ffffed1015d044fa
R10: ffffed1015d044f9 R11: ffff8880ae8227cf R12: ffffffff81b3e334
R13: 0000000000000010 R14: 0000000000000000 R15: 1ffff1101252654b
FS:  000055555572a940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd8 CR3: 000000009c4d1000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
