Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835BD2654B8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgIJWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgIJWBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:01:06 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0955C061573;
        Thu, 10 Sep 2020 15:01:05 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p6so5047626ybk.10;
        Thu, 10 Sep 2020 15:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqyY0998nnTOOx9j6km0P/zJSInnI5dSi92OehQyjG8=;
        b=UiUbvVLCF7pkYoifxWjoGeHF94Pvk61F3V2rzi2kA+rcKJlCbkUfKw3lx+VE4VN0uW
         t3yIY/H64pDtRYoqYeLAto/MznOtX0B6pl1ONIYEt61St+d50gHAOc3MWX1+sr4n2Q03
         pjDtltvSwqJ8Fspx0tHxF2eD6SNxevNOCvojCm2706UOdrTwJYhMjlanY0FMs8XzyemZ
         xrp3PVLvqoQJeluueuuyBZQRync+rzo5RMR6iyoDvJ/l+y8UDE4rz8IqK8XMEc7pY88J
         rZP8KM6KFBprO5H0fLOkJmT50uKNNQYAuCmNrStgpTeS+OiukQOST7/117mvnYVUXbvk
         Q91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqyY0998nnTOOx9j6km0P/zJSInnI5dSi92OehQyjG8=;
        b=Fn58vwfi5mcPOzJuU5m8nzBa3clykJduemeGV6cjcmMf63820QLEMcLZOFqFJmzkD/
         PBfVVWLO0fPR2vo7450P+E0NV/lrBs2U4goWFMcTR4Z7gCj5cl5DYRLKBWJKRcxj4SBH
         yPRvuvhvEqbnVHWZfd2QIDYrOu1vaZRMMi4l4HQEW9pGjEP9hFtsSO5CgPYHtEVuzSDJ
         CtvHd8xHrhTPSe/6N5oj5uRk+bfVeGyfXJmLiysuSOrfZbeCX93uOdX1vI+4OJQwz6fF
         63WJubUyEPEXSH7GrrofxmTZ1lz7rJh3pTUaoyKBjzhfTv3C9kGF3uMUfYfdT5wOpUpM
         5uVQ==
X-Gm-Message-State: AOAM531PhImTpUGnKCdwBwyWRp12HtXEkLmnHD+NvHDimYYN8RTi9wQi
        gxvpID+gW/dPcNkT83qRkqx6Q+/8srXbf7L/wbA=
X-Google-Smtp-Source: ABdhPJwwJaJVkvBKNQpfSNCAzEM3ujd4iniWp5aQeouKQJp3UeGDkrhhhdijSfKOsiJ3r0E5PNKHrJJ9eDRzFsLpEbs=
X-Received: by 2002:a25:aa8f:: with SMTP id t15mr15916005ybi.459.1599775264934;
 Thu, 10 Sep 2020 15:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c82fe505aef233c6@google.com>
In-Reply-To: <000000000000c82fe505aef233c6@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 15:00:54 -0700
Message-ID: <CAEf4BzbuUDEktVCYZAonUTM6iYBcAOPjKho2gMRD+9Q=N5cYxQ@mail.gmail.com>
Subject: Re: WARNING in bpf_raw_tp_link_fill_link_info
To:     syzbot <syzbot+976d5ecfab0c7eb43ac3@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 2:31 AM syzbot
<syzbot+976d5ecfab0c7eb43ac3@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    7fb5eefd selftests/bpf: Fix test_sysctl_loop{1, 2} failure..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1424fdb3900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b6856d16f78d8fa9
> dashboard link: https://syzkaller.appspot.com/bug?extid=976d5ecfab0c7eb43ac3
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a1f411900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10929c11900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+976d5ecfab0c7eb43ac3@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6854 at include/linux/thread_info.h:150 check_copy_size include/linux/thread_info.h:150 [inline]
> WARNING: CPU: 0 PID: 6854 at include/linux/thread_info.h:150 copy_to_user include/linux/uaccess.h:167 [inline]
> WARNING: CPU: 0 PID: 6854 at include/linux/thread_info.h:150 bpf_raw_tp_link_fill_link_info+0x306/0x350 kernel/bpf/syscall.c:2661
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 6854 Comm: syz-executor574 Not tainted 5.9.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:231
>  __warn.cold+0x20/0x4a kernel/panic.c:600
>  report_bug+0x1bd/0x210 lib/bug.c:198
>  handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
>  exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
> RIP: 0010:check_copy_size include/linux/thread_info.h:150 [inline]
> RIP: 0010:copy_to_user include/linux/uaccess.h:167 [inline]
> RIP: 0010:bpf_raw_tp_link_fill_link_info+0x306/0x350 kernel/bpf/syscall.c:2661
> Code: 41 bc ea ff ff ff e9 35 ff ff ff 4c 89 ff e8 41 66 33 00 e9 d0 fd ff ff 4c 89 ff e8 a4 66 33 00 e9 06 ff ff ff e8 ca ed f2 ff <0f> 0b eb 94 48 89 ef e8 2e 66 33 00 e9 65 fd ff ff e8 24 66 33 00
> RSP: 0018:ffffc900051c7bd0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc900051c7c60 RCX: ffffffff818179d6
> RDX: ffff88808b490000 RSI: ffffffff81817a96 RDI: 0000000000000006
> RBP: 0000000000000019 R08: 0000000000000000 R09: ffffc900051c7c7f
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000019
> R13: 0000000000001265 R14: ffffffff8986ecc0 R15: ffffc900051c7c78
>  bpf_link_get_info_by_fd kernel/bpf/syscall.c:3626 [inline]
>  bpf_obj_get_info_by_fd+0x43a/0xc40 kernel/bpf/syscall.c:3664
>  __do_sys_bpf+0x1906/0x4b30 kernel/bpf/syscall.c:4237
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x4405f9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fff47155808 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004405f9
> RDX: 0000000000000010 RSI: 00000000200000c0 RDI: 000000000000000f
> RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401e00
> R13: 0000000000401e90 R14: 0000000000000000 R15: 0000000000000000
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>

#syz fix: b474959d5afd ("bpf: Fix a buffer out-of-bound access when
filling raw_tp link_info")

>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
