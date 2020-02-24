Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE44D16B42F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBXWiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:38:46 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44098 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgBXWiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 17:38:46 -0500
Received: by mail-ed1-f68.google.com with SMTP id g19so13843643eds.11
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 14:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Am1tgX996z1ppxv6KMXbcSkx7Xx4s/5SxOG8NwtW1po=;
        b=128yUKO7rcI157pfejcd9t2zQycldfxQIqIc8cRktUGVtjEdYJS7Xa2EEt4NCp6cMj
         ccOG/dx9wXq7fMbzKK9/c7gB/ST6TIrQg1OjwnQQg+hSWoeKvgzRSMREJxlV9nv3iZ/r
         8R3sj1oXQ/MGMYqXhA9xggevnRUy18QlEfCXwLdv2LD9aNUakDNtJQAeNmi7jl/F/7/j
         8h4jxBu2dbtGtfbkW010yvY9lkLUukFR4hU0J+O64RWRMGeWffLAgOFtZ4X0bzq7CxP3
         PqoEz7RcxB0OAwtf3M7T07PnxyBA2lRFoYnVrcskyMkOASjt0wJOA70Fs7rjWV8wW65t
         1Xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Am1tgX996z1ppxv6KMXbcSkx7Xx4s/5SxOG8NwtW1po=;
        b=aQmrdEIw+Q4Z9UKM8EhXJ83d+guDm8Skn1fQrJLndh16QMKRr+SdSpouEDNoKEyO1z
         H+csPUf8uLAWkJOcxQcDF9a3T0aXbHGAHodF3T387Rsz44FWTptmt10b478cSOCh2zK3
         70uJDYhtaSFhYoz6La9zajk6UEnQzCL6egj6GOSFQlpVe5BSWmdloEotKdgCS8QdqUzB
         xq1S8Il8erboC+YvSMz9iqyjZlXNhCEKDCodSscHdPjz2EOnQTYpxUTSMWh/Zez2TVPu
         ixBWy2gHy82+tup5FZ3PLG3LqrQnMjrcu1eXfJv+9tKjOzvv2sfEXctInvrLU7MMChXl
         kLrQ==
X-Gm-Message-State: APjAAAU4dG5x+FgN8e46Sa4fva6DJg/MeN1I0Twfsr36KnGb/XqYYjHy
        rFqmZ1cs4ghx9iLlj63XWjP62no367WGZEppkNHB
X-Google-Smtp-Source: APXvYqxEBymbJcwpeAcsqEent6pUKYyaxYqCtvnCFKaEevNm78Aalz+Q0v7wR9q33U6yWP+EFiJQt51zFjYAEi6KtSM=
X-Received: by 2002:a50:fd15:: with SMTP id i21mr48320647eds.12.1582583922225;
 Mon, 24 Feb 2020 14:38:42 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003cbb40059f4e0346@google.com>
In-Reply-To: <0000000000003cbb40059f4e0346@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 24 Feb 2020 17:38:31 -0500
Message-ID: <CAHC9VhQVXk5ucd3=7OC=BxEkZGGLfXv9bESX67Mr-TRmTwxjEg@mail.gmail.com>
Subject: Re: kernel panic: audit: backlog limit exceeded
To:     syzbot <syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        dan.carpenter@oracle.com, davem@davemloft.net,
        Eric Paris <eparis@redhat.com>, fzago@cray.com,
        gregkh@linuxfoundation.org, john.hammond@intel.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 3:18 AM syzbot
<syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    36a44bcd Merge branch 'bnxt_en-shutdown-and-kexec-kdump-re..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=148bfdd9e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
> dashboard link: https://syzkaller.appspot.com/bug?extid=9a5e789e4725b9ef1316
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=151b1109e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128bfdd9e00000
>
> The bug was bisected to:
>
> commit 0c1b9970ddd4cc41002321c3877e7f91aacb896d
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Fri Jul 28 14:42:27 2017 +0000
>
>     staging: lustre: lustre: Off by two in lmv_fid2path()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6c3e9e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1416c3e9e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1016c3e9e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com
> Fixes: 0c1b9970ddd4 ("staging: lustre: lustre: Off by two in lmv_fid2path()")
>
> audit: audit_backlog=13 > audit_backlog_limit=7
> audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=7
> Kernel panic - not syncing: audit: backlog limit exceeded
> CPU: 1 PID: 9913 Comm: syz-executor024 Not tainted 5.6.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:221
>  audit_panic.cold+0x32/0x32 kernel/audit.c:307
>  audit_log_lost kernel/audit.c:377 [inline]
>  audit_log_lost+0x8b/0x180 kernel/audit.c:349
>  audit_log_start kernel/audit.c:1788 [inline]
>  audit_log_start+0x70e/0x7c0 kernel/audit.c:1745
>  audit_log+0x95/0x120 kernel/audit.c:2345
>  xt_replace_table+0x61d/0x830 net/netfilter/x_tables.c:1413
>  __do_replace+0x1da/0x950 net/ipv6/netfilter/ip6_tables.c:1084
>  do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
>  do_ip6t_set_ctl+0x33a/0x4c8 net/ipv6/netfilter/ip6_tables.c:1681
>  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
>  ipv6_setsockopt net/ipv6/ipv6_sockglue.c:949 [inline]
>  ipv6_setsockopt+0x147/0x180 net/ipv6/ipv6_sockglue.c:933
>  tcp_setsockopt net/ipv4/tcp.c:3165 [inline]
>  tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3159
>  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
>  __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
>  __do_sys_setsockopt net/socket.c:2146 [inline]
>  __se_sys_setsockopt net/socket.c:2143 [inline]
>  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x44720a
> Code: 49 89 ca b8 37 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 1a e0 fb ff c3 66 0f 1f 84 00 00 00 00 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 fa df fb ff c3 66 0f 1f 84 00 00 00 00 00
> RSP: 002b:00007ffd032dec78 EFLAGS: 00000286 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044720a
> RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
> RBP: 00007ffd032deda0 R08: 00000000000003b8 R09: 0000000000004000
> R10: 00000000006d7b40 R11: 0000000000000286 R12: 00007ffd032deca0
> R13: 00000000006d9d60 R14: 0000000000000029 R15: 00000000006d7ba0
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Similar to syzbot report 72461ac44b36c98f58e5, see my comments there.

-- 
paul moore
www.paul-moore.com
