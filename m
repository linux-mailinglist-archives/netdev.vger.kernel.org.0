Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D97490B1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfFQUAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:00:11 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53554 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfFQUAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:00:10 -0400
Received: by mail-io1-f70.google.com with SMTP id h3so13313389iob.20
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 13:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=h9LXwK3TLjpjcKyAIIEYj8DsVbu7BBACxEGhOWUfoOo=;
        b=scdec2vcDb+fiUWMJ4urnV/CUjzXdP6BVFp6+YY1dK1bgdJRGEeUuy6eIjNZ0YD7PJ
         0VIYreovMzJfyATaawQU3PPIrMEQM4EQumFiY5EUu6OuuHFBk1Lso2rPqoWGD6FgsiOK
         aaaze0PaXi7E6NOJZ279u9X6VD+T2g2gQa7hU7JvdsdKUXWCRV5g59KXVWGb1cp3WEy5
         hPVtCIoerWlskm5BPfrxIq9Kc5xVFUQE2jgrWLDZgESW1SPfXPMUtUAudf7N2slGyqtJ
         vUnSmPfKOnjVEFsKXNYhgDMXpWFseVsMa+NNFIqr7hGUJwqp3MMMnSBEbFELp1GFn/oq
         B6qA==
X-Gm-Message-State: APjAAAXZDzXj2TjFeESC3o/Q7RRBcz9qlbhBoTQ+NXEfNmdBTcLEgJTH
        bOHoYg4QyUSwSwH74pCxu8xlRbCiEBA/xvtTwixShSpSdpdF
X-Google-Smtp-Source: APXvYqx+zVu6v6nYjgeGKo1Fsxp+YerqnS7qQXlJPnxzp8xQ1y80/WVuzDL+3jAgPK4+cjszEpNtpB/Ws1xxPPTk0X/r9uXvASGU
MIME-Version: 1.0
X-Received: by 2002:a6b:6209:: with SMTP id f9mr21476889iog.236.1560801608896;
 Mon, 17 Jun 2019 13:00:08 -0700 (PDT)
Date:   Mon, 17 Jun 2019 13:00:08 -0700
In-Reply-To: <000000000000a8fa360588580820@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000076a8a9058b8a71e1@google.com>
Subject: Re: WARNING in bpf_prog_kallsyms_find
From:   syzbot <syzbot+89d1ce6e80218a6192d8@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    a125097c Add linux-next specific files for 20190617
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=130e3881a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5fffe6c898291ba
dashboard link: https://syzkaller.appspot.com/bug?extid=89d1ce6e80218a6192d8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ee6121a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174911aea00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+89d1ce6e80218a6192d8@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 2952 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:219
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075f850 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075f890 R08: ffff8880a073c600 R09: ffffed1015d06c70
R10: ffffed1015d06c6f R11: ffff8880ae83637b R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffffff R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#2] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075f378 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075f3b8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffffff R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#3] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075ee98 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075eed8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#4] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075e9b8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075e9f8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#5] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075e4d8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075e518 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#6] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075dff8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075e038 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#7] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075db18 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075db58 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#8] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075d638 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075d678 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#9] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075d158 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075d198 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#10] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075cc78 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075ccb8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#11] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075c798 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075c7d8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#12] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075c2b8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075c2f8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#13] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075bdd8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075be18 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#14] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075b8f8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075b938 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#15] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075b418 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075b458 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#16] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075af38 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075af78 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#17] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075aa58 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075aa98 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#18] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075a578 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075a5b8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#19] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075a098 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075a0d8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#20] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a0759bb8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a0759bf8 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#21] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a07596d8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a0759718 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#22] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a07591f8 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a0759238 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Oops: 0000 [#23] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a0758d18 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a0758d58 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
BUG: unable to handle page fault for address: fffffbfff4004000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 9b511067 PTE 0
Thread overran stack, or stack corrupted
Oops: 0000 [#24] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a0758838 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a0758878 R08: ffff8880a073c600 R09: 0000000000000000
R10: ffffed1015d06c6f R11: ffff8880a073c600 R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffff01 R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
------------[ cut here ]------------
==================================================================
BUG: KASAN: use-after-free in vsnprintf+0xe9e/0x19a0 lib/vsprintf.c:2536
Read of size 8 at addr ffff8880a0757798 by task kworker/0:2/2952

CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
Call Trace:
------------[ cut here ]------------
kernel BUG at mm/slab.c:4169!
invalid opcode: 0000 [#25] PREEMPT SMP KASAN
CPU: 0 PID: 2952 Comm: kworker/0:2 Not tainted 5.2.0-rc5-next-20190617 #16
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:__check_heap_object+0xa5/0xb3 mm/slab.c:4169
Code: 2b 48 c7 c7 4d 46 83 88 e8 88 bd 07 00 5d c3 41 8b 91 3c 01 00 00 48  
29 c7 48 39 d7 77 bd 48 01 d0 48 29 c8 4c 39 c0 72 b2 c3 <0f> 0b 48 c7 c7  
4d 46 83 88 e8 9c c2 07 00 4c 8d 45 c4 89 d9 48 c7
RSP: 0018:ffff8880a0756f00 EFLAGS: 00010046
RAX: 000000000000000a RBX: 0000000000000001 RCX: 0000000000000008
RDX: ffff8880a0756000 RSI: 0000000000000000 RDI: ffff8880a0756ff8
RBP: ffff8880a0756f50 R08: 0000000000000001 R09: ffff8880aa58f1c0
R10: 0000000000000412 R11: 0000000000000000 R12: ffff8880a0756ff8
R13: ffffea000281d580 R14: ffff8880a0756ff9 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
Modules linked in:
---[ end trace 744eff192875d43e ]---
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:bpf_prog_kallsyms_find+0x1a0/0x2c0 kernel/bpf/core.c:667
Code: 75 07 e8 53 f2 f4 ff 0f 0b e8 4c f2 f4 ff 48 89 de 4c 89 f7 e8 61 f3  
f4 ff 49 39 de 72 71 e8 37 f2 f4 ff 48 89 d8 48 c1 e8 03 <42> 0f b6 04 28  
84 c0 74 08 3c 03 0f 8e e6 00 00 00 8b 33 4c 89 f7
RSP: 0018:ffff8880a075f850 EFLAGS: 00010806
RAX: 1ffffffff4004000 RBX: ffffffffa0020000 RCX: ffffffff817c0d0f
RDX: 0000000000000000 RSI: ffffffff817c0d19 RDI: 0000000000000006
RBP: ffff8880a075f890 R08: ffff8880a073c600 R09: ffffed1015d06c70
R10: ffffed1015d06c6f R11: ffff8880ae83637b R12: ffff88809a4f8578
R13: dffffc0000000000 R14: ffffffffffffffff R15: ffff88809a4f8578
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff4004000 CR3: 00000000994d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

