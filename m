Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EA82642A1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgIJJoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:44:25 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55834 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729971AbgIJJoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:44:17 -0400
Received: by mail-io1-f72.google.com with SMTP id t187so3870115iof.22
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 02:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=S6MCEGhGKPoO8g278zFxt30iZMpHoqILt9t9oWymNB8=;
        b=dQ2uQ026zUXdJhwIkqEhj0zcRdfAcCT9r1Jfvuak2/GRbJT9yvw/ImgZ1HzVWVVlSj
         281DXaATV1lIaHPPHZpHCAfR+Ih+ocsSAOXnFQuPEpdkmy1obFlj22fBZb9k9h6m4XwJ
         2Fq51lbOqbG7lxAzNJ1jmuoaXqbRhMu5vYUm6DvhjslNYPS0vCfb6ECVEiGGvIWahWEP
         hlt8RXwkTWWFWoNGdAGd+pskCVzJxu0eg5LgjAP7IfHLDjYlmLQ+71UfI2ciyVNfNuk+
         zyLOZ0LdKFGiVdZav3BOxYRhzN1hUFiYg6/J81bKZECXr+zpOlPNiHtUH10MmnRZC8E+
         wBCg==
X-Gm-Message-State: AOAM530yhfpjpeFfQzcrYlCgZnHfFyrU5xqDC+UOugs7+/0cc98IVVLT
        Q4MwdjS0aS8w5MyrZpos/+d/03Cz+6lOMbxeX+duUa5S9QT6
X-Google-Smtp-Source: ABdhPJwZhRDqLvTPBxLrstBoJIBUQdIYLfQ9me2gZUWmqtUe3W13TBOlf4Twyuuuk2mllfgnHj+mRqPVMKxwjb+ZP/DKHBqvQPWg
MIME-Version: 1.0
X-Received: by 2002:a92:6906:: with SMTP id e6mr7203229ilc.249.1599731056642;
 Thu, 10 Sep 2020 02:44:16 -0700 (PDT)
Date:   Thu, 10 Sep 2020 02:44:16 -0700
In-Reply-To: <000000000000a6348d05a9234041@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e13b505aef2693f@google.com>
Subject: Re: WARNING in tracepoint_add_func
From:   syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
To:     frederic@kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        netdev@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    746f534a tools/libbpf: Avoid counting local symbols in ABI..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1317f559900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=721aa903751db87aa244
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128ff37d900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+721aa903751db87aa244@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 7451 at kernel/tracepoint.c:243 tracepoint_add_func+0x254/0x880 kernel/tracepoint.c:243
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7451 Comm: syz-executor.0 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:tracepoint_add_func+0x254/0x880 kernel/tracepoint.c:243
Code: 44 24 20 48 8b 5b 08 80 38 00 0f 85 6b 05 00 00 48 8b 44 24 08 48 3b 58 08 0f 85 2d ff ff ff 41 bc ef ff ff ff e8 7c 68 fe ff <0f> 0b e8 75 68 fe ff 44 89 e0 48 83 c4 38 5b 5d 41 5c 41 5d 41 5e
RSP: 0018:ffffc900056e7ac0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90000e76000 RCX: ffffffff8175d632
RDX: ffff8880a85ae5c0 RSI: ffffffff8175d694 RDI: ffff8880942a1798
RBP: ffffffff82101830 R08: 0000000000000000 R09: ffffffff89c13687
R10: 000000000000000a R11: 0000000000000000 R12: 00000000ffffffef
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8880942a1790
 tracepoint_probe_register_prio kernel/tracepoint.c:315 [inline]
 tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:335
 __bpf_probe_register kernel/trace/bpf_trace.c:1950 [inline]
 bpf_probe_register+0x16c/0x1d0 kernel/trace/bpf_trace.c:1955
 bpf_raw_tracepoint_open+0x34e/0xb20 kernel/bpf/syscall.c:2741
 __do_sys_bpf+0x1336/0x4c20 kernel/bpf/syscall.c:4220
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f23d5b85c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000001800 RCX: 000000000045d5b9
RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000011
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007fffab077bbf R14: 00007f23d5b869c0 R15: 000000000118cf4c
Kernel Offset: disabled
Rebooting in 86400 seconds..

