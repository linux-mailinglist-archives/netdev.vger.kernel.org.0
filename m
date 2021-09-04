Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CFC4008A8
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350845AbhIDAIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbhIDAIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:08:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C41C061575;
        Fri,  3 Sep 2021 17:07:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id k17so499224pls.0;
        Fri, 03 Sep 2021 17:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ac0NqM/OB6g9iUrCA7LBliwNibjwqAkrbgHRRkfR0qc=;
        b=UbzjLAokr68iaS5qyEY7+2a3znQA05YmHnx+QznBEGguQHYlWQJL43jlNWyyqtKZHF
         a3BD+oeriMLrJMwr6ZfIdbaDpzob6rryPmxTArXXoNeTR5Vd8+jWG44brEMuaNMEKABH
         eDFjH3MFCm1tT3yq4e1leVcc5635czp/5uSqhGZlz6g4zjYLeDmwNgpyXXmRkAc7NS7k
         iJlLg1Aje0o8/UAbwAa5PJulYAk8XvVjwdBMrnzeNE3XJ4xXbZVI0WzJmyKb7cuqDDJw
         U7E9qLdAU/40KcAS1gBnx8//mHZC/28z1mBh8WVXUo5tawRlj2/sIoT9OVKgN3viO5CQ
         D38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ac0NqM/OB6g9iUrCA7LBliwNibjwqAkrbgHRRkfR0qc=;
        b=qR6mi2PK8w6GB4Pd55wY7I5B42O4cMpLN4uyklXCHF3qDUnrj4vdnxE2j9PVbAlhDZ
         L06aEn5g1nAID8i4Lt0PTcrE6b3ryNlicvjwavj74DtI5KU/Ffuy1OVPzqVimBsw1Mcr
         bZMWdseBAgT9MXbvZGbximpnNwdJITPQyCFd2JOPh/1eymyCIUOfy+djN6Iv/lUMuynt
         eGTAP4xwrXecH7dl/XyXWKSlfOvxZHND16nltDdgrZyL9kp6IswFuOhhiBuiUIAendZ/
         4lppDXMcrDvQXAdfbHlyN4OnA/TnFu3LEb6gtd3gAAGMmwRYEyt0U/d/0XgKW/8VsELv
         kLsA==
X-Gm-Message-State: AOAM530rBIzrbJ2TCUJjUCNKZe2zotbRogdvFZrQ7rASl3+VG5JW/f+A
        vb3fJEoUSnZonHIq6rmdaGw=
X-Google-Smtp-Source: ABdhPJztUluPpgOgdJ9YCbcBM4OW6xd2f41oS2ThJ2UZkjveWclXRERBhDWTF1CEHF7eZu4hfuOEeQ==
X-Received: by 2002:a17:902:e811:b0:138:a9a5:bc3a with SMTP id u17-20020a170902e81100b00138a9a5bc3amr1222282plg.18.1630714031311;
        Fri, 03 Sep 2021 17:07:11 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o18sm321027pjg.26.2021.09.03.17.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 17:07:11 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in bpf_check
To:     syzbot <syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000002c756105cb201ef1@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fa1d99d6-3f83-73bb-0aff-a70d3f1bc9dc@gmail.com>
Date:   Fri, 3 Sep 2021 17:07:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0000000000002c756105cb201ef1@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/21 5:01 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13fd5915300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c84ed2c3f57ace
> dashboard link: https://syzkaller.appspot.com/bug?extid=f3e749d4c662818ae439
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e4cdf5300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ef3b33300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8408 at mm/util.c:597 kvmalloc_node+0x108/0x110 mm/util.c:597
> Modules linked in:
> CPU: 0 PID: 8408 Comm: syz-executor221 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x108/0x110 mm/util.c:597
> Code: ff 48 89 df 44 89 fe 44 89 f2 e8 a3 6e 17 00 48 89 c5 eb 05 e8 19 28 ce ff 48 89 e8 5b 41 5c 41 5e 41 5f 5d c3 e8 08 28 ce ff <0f> 0b 31 ed eb e9 66 90 41 56 53 49 89 f6 48 89 fb e8 f2 27 ce ff
> RSP: 0018:ffffc900017ff210 EFLAGS: 00010293
> RAX: ffffffff81b2b708 RBX: 0000000200004d00 RCX: ffff888013ded580
> RDX: 0000000000000000 RSI: 0000000200004d00 RDI: 000000007fffffff
> RBP: 0000000000000000 R08: ffffffff81b2b6ac R09: 00000000ffffffff
> R10: fffff520002ffe15 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000002dc0
> FS:  0000000001386300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3e712d36c0 CR3: 00000000342e8000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  kvmalloc include/linux/mm.h:806 [inline]
>  kvmalloc_array include/linux/mm.h:824 [inline]
>  kvcalloc include/linux/mm.h:829 [inline]
>  check_btf_line kernel/bpf/verifier.c:9925 [inline]
>  check_btf_info kernel/bpf/verifier.c:10049 [inline]
>  bpf_check+0xd634/0x150d0 kernel/bpf/verifier.c:13759
>  bpf_prog_load kernel/bpf/syscall.c:2301 [inline]
>  __sys_bpf+0x11181/0x126e0 kernel/bpf/syscall.c:4587
>  __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
>  __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:4689
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f0a9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe831a89a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f0a9
> RDX: 0000000000000078 RSI: 0000000020000500 RDI: 0000000000000005
> RBP: 0000000000403090 R08: 0000000000000000 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403120
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> 
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
> 

As mentioned to Linus earlier, this bug comes after recent patch

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 09:45:49 2021 -0700

    mm: don't allow oversized kvmalloc() calls
    
    'kvmalloc()' is a convenience function for people who want to do a
    kmalloc() but fall back on vmalloc() if there aren't enough physically
    contiguous pages, or if the allocation is larger than what kmalloc()
    supports.
    
    However, let's make sure it doesn't get _too_ easy to do crazy things
    with it.  In particular, don't allow big allocations that could be due
    to integer overflow or underflow.  So make sure the allocation size fits
    in an 'int', to protect against trivial integer conversion issues.
    
    Acked-by: Willy Tarreau <w@1wt.eu>
    Cc: Kees Cook <keescook@chromium.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

