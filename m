Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B77492753
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfHSOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:44:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45727 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSOog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:44:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so8989238wrj.12;
        Mon, 19 Aug 2019 07:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fbfLwnIbN3ORragmV2yEJsShFmVzLuxHgB1PtnaULo=;
        b=Z5cw87NB59ZPge3YYzkXaZGswoEbw0YZKAjTPNpseh0OwQ5+WMmJBhtfUhJXjQxN4U
         w/kuvMAeZmJLHe+w8hsIUKpqnI8/fva3ZEfKYJLMk0k8f5ofBgfDUg1G5te6+fVs27tU
         JUMjxvpaVojlNE+nEMFU0nUNuVnNqW6/uUBp6x02t4OgUkm46esvBROOh8dkbFiCa0P4
         R7agJMK+i6ZV+0AQhWtKitk+craxda2NNvKNpfus8cvPqe2hrZzPay8bepins843IE4q
         heLm+FURWfBASB4nqhU1Z+RxeepqzmDC7l7Mo3/oADdWE3sUS1c6ik5DJiGhDju63Oyc
         FJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fbfLwnIbN3ORragmV2yEJsShFmVzLuxHgB1PtnaULo=;
        b=mrOxk7op4WL2UcqYSs71r5t0orQnpCtdH/308cZIXGo6mtNveVIrqwd3W/pvBYaT7q
         HL/EE/jCV5wpj9NfS0xaYLli/lt/56s/7neowSepmOTp+PohMVJywJKpUxjlk1tThNRl
         j5IIbgr7WnyevNIuHc+tutMVhD5IJ5OOtkj0OTA9TlslCOA6n5EdTFa1gu5SidIYqe0l
         S0Fji3JhoUEZbDFs13peaWJWH3Crc/p38vM5pFquFNG5b6lUeIR7i5IlbmRt9FMs1rTd
         PfJhwGsHPsUaIRURV8F3GlTfWw6Ak3G+bB92UffjdRiSgRf9ZnxchqafaLljpUdO7GPh
         JtcQ==
X-Gm-Message-State: APjAAAU9qWq5k5y4yEHpePhGYfkBIr4gzdPIvtiMeduOeT2y1N6jTmqt
        H0O9QlCB8NeRRQgEvFhxG2ZhbT3AAiRNdYB5Oco=
X-Google-Smtp-Source: APXvYqyWQCgxiY7d0/Dh17AmRHCWWe7UeJIUusW723kEYdIuT3nERF1HSbfScnywQSlgy6jwU6bcGEMBEoJDqS8TkII=
X-Received: by 2002:adf:f90e:: with SMTP id b14mr26417077wrr.124.1566225873866;
 Mon, 19 Aug 2019 07:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008182a50590404a02@google.com> <CADvbK_e+em+LiQOttfA9nckA4EPFuW_Q-cBmXx3S5pw5X+tQfw@mail.gmail.com>
 <CACT4Y+aNTHtbw1upruHtfrLZnUyKkZHU5_3fndmVV6D_zzJJbQ@mail.gmail.com>
In-Reply-To: <CACT4Y+aNTHtbw1upruHtfrLZnUyKkZHU5_3fndmVV6D_zzJJbQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 19 Aug 2019 22:44:22 +0800
Message-ID: <CADvbK_c7BXurbHyAqjX+0h2ZYtmJ0802zxmQB3qv8=GLv2ig9g@mail.gmail.com>
Subject: Re: kernel BUG at include/linux/skbuff.h:LINE! (2)
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 18, 2019 at 10:13 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sun, Aug 18, 2019 at 7:07 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Sat, Aug 17, 2019 at 2:38 AM syzbot
> > <syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    459c5fb4 Merge branch 'mscc-PTP-support'
> > > git tree:       net-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=13f2d33c600000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=eb349eeee854e389c36d
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111849e2600000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1442c25a600000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > kernel BUG at include/linux/skbuff.h:2225!
> > > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> > > CPU: 0 PID: 9030 Comm: syz-executor649 Not tainted 5.3.0-rc3+ #134
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
> > > RIP: 0010:__skb_pull include/linux/skbuff.h:2222 [inline]
> > > RIP: 0010:skb_pull_inline include/linux/skbuff.h:2231 [inline]
> > > RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
> > > Code: 9d c8 00 00 00 49 89 dc 49 89 9d c8 00 00 00 e8 9c e5 dd fb 4c 89 e0
> > > 5b 41 5c 41 5d 41 5e 5d c3 45 31 e4 eb ea e8 86 e5 dd fb <0f> 0b e8 df 13
> > > 18 fc e9 44 ff ff ff e8 d5 13 18 fc eb 8a e8 ee 13
> > > RSP: 0018:ffff88808ac96e10 EFLAGS: 00010293
> > > RAX: ffff88809c546000 RBX: 0000000000000004 RCX: ffffffff8594a3a6
> > > RDX: 0000000000000000 RSI: ffffffff8594a3fa RDI: 0000000000000004
> > > RBP: ffff88808ac96e30 R08: ffff88809c546000 R09: fffffbfff14a8f4f
> > > R10: fffffbfff14a8f4e R11: ffffffff8a547a77 R12: 0000000095e28bcc
> > > R13: ffff88808ac97478 R14: 00000000ffff8880 R15: ffff88808ac97478
> > > FS:  0000555556549880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000020000100 CR3: 0000000089c3c000 CR4: 00000000001406f0
> > > Call Trace:
> > >   sctp_inq_pop+0x2f1/0xd80 net/sctp/inqueue.c:202
> > >   sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
> > >   sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
> > >   sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
> > >   sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
> > >   ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
> > >   ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
> > >   NF_HOOK include/linux/netfilter.h:305 [inline]
> > >   NF_HOOK include/linux/netfilter.h:299 [inline]
> > >   ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
> > >   dst_input include/net/dst.h:442 [inline]
> > >   ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
> > Looks skb_list_del_init() should be called in ip6_sublist_rcv_finish,
> > as does in ip_sublist_rcv_finish().
>
> This was recently introduced, right? Only in net-next and linux-next.
> Otherwise, is it a remote DoS? If so and if it's present in any
> releases, may need a CVE.
I need to reproduce and confirm it, will let you know.
