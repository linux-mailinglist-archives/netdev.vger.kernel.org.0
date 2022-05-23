Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87B0531659
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240933AbiEWRfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240858AbiEWRdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 13:33:17 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184A57890C;
        Mon, 23 May 2022 10:27:51 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id x11so6922601vkn.11;
        Mon, 23 May 2022 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fC+d3E3kApd+GGgczOrWdAYwew0zJ7TGt0XFA7/szWI=;
        b=a35W3v4Lh6GZ7DEO5tagc+mpT9qfvgsAxMLW4sMzqYIIMGTkAU8/Fq2APwY4QMRYCU
         K1xKWl6BFpjAqn0GQuZOEJUcPI7XNOcBdRilPrQ5Dw625/DdqHr1YhuXZDe4pHka9Ln7
         C8nWgNrHNpE5mN3wI393po0Wgusuybjci+skMLX6IZ9qFeKR9fi2Qn+l0TLs7atq4Uxg
         64FZmdqq5p9YRAr8hZ+Jh+NrKiu66md50LS6qnTzewDzRkLbXQbBFWbCTawe9q7BsNoO
         ri9h9kiIHgAFEXRZ8zgdYypSVjh1erdxjY2yBD8hmGkyHXjt8JF1LhgHG5tqiPTCKNmw
         nHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fC+d3E3kApd+GGgczOrWdAYwew0zJ7TGt0XFA7/szWI=;
        b=OI+WkfAlnV+Yms3mdDv9CjRGnLxhu8GVXDRYzFyU5QPfvj4yPHAEVhrBroXPnASoWN
         RKHp92uLKmk7ugZ0oD+sCTKy7sccQ3pWXMYGHza2+FdgdNVwK3tGEip0seRC0wQLqPG3
         oTxnVjK6gmzlX9DN4r9qMUmGMSBHNYaTUjCZYw5ApJJ/1wxuWSuVJbIjYnS3ml/m9ZSn
         syl5het5fPdMDCQNR34WUYil8xzgryzpG7W1Tg2fts3VcVVTFSgEuTNTKyaraxBgGzPZ
         P4J1MsoqaTzNmNlZQL3a2BQn5ucCVyaUDphdwamEoB9frFxgCQQP1alv8/C1a3/PGKcj
         10mA==
X-Gm-Message-State: AOAM533Q8uWVCfsJfXN19jmybV03nSbXmsoM2tn9KO/+dJBMg19bxcdo
        f05Cf0z1QkmsDZ7U/CLd1tsBkSsrD1HsnOWqvV0=
X-Google-Smtp-Source: ABdhPJycBmA1+0lgYrMGtnUUWsVTZlXhmGrwSBjTjymxE6tX6I8UalbuelVb9lbZsXjjtvcjCtr3wH7hIwvsqD+SA30=
X-Received: by 2002:a1f:a293:0:b0:357:edb7:9520 with SMTP id
 l141-20020a1fa293000000b00357edb79520mr390435vke.12.1653326870180; Mon, 23
 May 2022 10:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000003f33bc05dfaf44fe@google.com>
In-Reply-To: <0000000000003f33bc05dfaf44fe@google.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 23 May 2022 10:27:39 -0700
Message-ID: <CAJnrk1ZZcX=i3ZxmRokk=FZ4QETiHGB0HNocMUPbj_hqdgx4zw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in inet_csk_get_port
To:     syzbot <syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, dsahern@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 8:12 AM syzbot
<syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    aa5334b1f968 Merge branch 'add-a-bhash2-table-hashed-by-po..
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=151fe7fdf00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=468b6c3a1b5b53f0
> dashboard link: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1336e875f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1673a38df00000
>
> The issue was bisected to:
>
> commit d5a42de8bdbe25081f07b801d8b35f4d75a791f4
> Author: Joanne Koong <joannelkoong@gmail.com>
> Date:   Fri May 20 00:18:33 2022 +0000
>
>     net: Add a second bind table hashed by port and address
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14193ea9f00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16193ea9f00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12193ea9f00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
>
> nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 3598 at net/ipv4/inet_connection_sock.c:525 inet_csk_get_port+0x1148/0x1ad0 net/ipv4/inet_connection_sock.c:525
> Modules linked in:
> CPU: 1 PID: 3598 Comm: syz-executor285 Not tainted 5.18.0-rc7-syzkaller-01833-gaa5334b1f968 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:inet_csk_get_port+0x1148/0x1ad0 net/ipv4/inet_connection_sock.c:525
> Code: 07 00 00 48 8b 44 24 28 4c 89 ee 48 8b 78 18 e8 2e d1 fe ff e9 0f ff ff ff e8 f4 59 a6 f9 0f 0b e9 ae fa ff ff e8 e8 59 a6 f9 <0f> 0b e9 de fa ff ff e8 dc 59 a6 f9 e8 a7 ed 9d 01 31 ff 89 c3 89
> RSP: 0018:ffffc90002f4fbf8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888022f6a100 RCX: 0000000000000000
> RDX: ffff88801e6fbb00 RSI: ffffffff87d2dff8 RDI: ffff88801e2e06a8
> RBP: ffff88801e2e06a0 R08: 0000000000000001 R09: 0000000000000000
> R10: ffffffff87d2c485 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff888022f6a100 R14: 0000000000000000 R15: ffff88801e2e0000
> FS:  000055555578e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000005defd8 CR3: 000000001ce0b000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  inet_csk_listen_start+0x13e/0x3c0 net/ipv4/inet_connection_sock.c:1178
>  inet_listen+0x231/0x640 net/ipv4/af_inet.c:228
>  __sys_listen+0x17d/0x250 net/socket.c:1778
>  __do_sys_listen net/socket.c:1787 [inline]
>  __se_sys_listen net/socket.c:1785 [inline]
>  __x64_sys_listen+0x50/0x70 net/socket.c:1785
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f9112cccd09
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffca7006048 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9112cccd09
> RDX: ffffffffffffffc0 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f9112c90eb0 R08: 000000000000001c R09: 000000000000001c
> R10: 0000000020001540 R11: 0000000000000246 R12: 00007f9112c90f40
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
>
I will submit a follow-up fix for this.
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
