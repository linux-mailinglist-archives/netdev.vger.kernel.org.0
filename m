Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5014708B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAWSOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:14:53 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42500 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWSOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:14:53 -0500
Received: by mail-ot1-f65.google.com with SMTP id 66so3624011otd.9;
        Thu, 23 Jan 2020 10:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QiY1d7i7CA5Tav17hx32IsMyqd7CfjaBpQNb7C5kBuw=;
        b=fsfzk5mArV7ZcorT1o9PQKB9wdAMbgqF6PRn/aUZfOx0XfSoa3hebW2GJvaUPHnJP2
         63jLNVbDZ+5I8xqjdLwD084Egu3c6rzhpxHGBgodeNT2HDUefNDKE5J0zSTBSpSSu3ix
         YS6Sj5oLLAqy+7WRO16x7Iwptqrqzp2B19IveaCXaXHhd7e5kicoyfmr3EN6MbvvGeYx
         oRHLceJV6ZtGa61JTf1hV+UzCzkqwUXLY7Fei/8aUeRerbdPPaVa4vnLwH3TmufPwrU6
         gvd8quYw2cqDyLkOJ2NAZumi+0J6hBSEorjkDLovPFv6QFsQxV2FkJCWjxzh0nunCZ9g
         5WNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QiY1d7i7CA5Tav17hx32IsMyqd7CfjaBpQNb7C5kBuw=;
        b=iuU+AnRVMd3Rs+kBfnOIG25PiWKikK6LeDM0cuOIgT2fdVTVMpd4+I4QfBfPAqFyto
         ++J4Fi69yyyq+h6+wYshT3rs7chA0WVXDjrX4onRtfIrekqt619jGfn38TFm79OhKnAV
         CDANbr8HxtcCsblvYC5ItLZ6234/b8YZshoNNSDLAPcgz0tVf/P1cCtmdpNmGgB3KONA
         MjDGxHwpUlOGqtZdaaPpEWw5ykxgxpP61+90ThUObz61uAW6zY92JDysALkyn9XUdymt
         Hw7rkrPmSZc4oRxIBueKRrxPAK4wPhYTdjqe+abvH9+TPP1Ik1EaW8Oes375GC4hXD4h
         z+ag==
X-Gm-Message-State: APjAAAWCWcMdN4Xh9un7DQM/R57ceVBagWlqMl90Ip+BQxiiDgIT8hgx
        eSyqP/lqlz8OoRz4DJKKlS03A58Y5P76fs8QrNk=
X-Google-Smtp-Source: APXvYqwJjFmJNIjrARE0noxL4rB+Lw5AseD4BssMsVsC+uhiQLAVzM103SDmmU7/8SdHCFKnOl0AwIGP0+ZPEj6keBo=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr11837551ots.319.1579803291997;
 Thu, 23 Jan 2020 10:14:51 -0800 (PST)
MIME-Version: 1.0
References: <0000000000007c3ba2059cb50843@google.com>
In-Reply-To: <0000000000007c3ba2059cb50843@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 23 Jan 2020 10:14:41 -0800
Message-ID: <CAM_iQpUHHmJGQfVFf2C=b_-QNwLG7WMK=z=PpiEtVHvX7HkzGA@mail.gmail.com>
Subject: Re: WARNING in cbq_destroy
To:     syzbot <syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:57 PM syzbot
<syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=144f7601e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
> dashboard link: https://syzkaller.appspot.com/bug?extid=63bdb6006961d8c917c6
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a1a721e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a91a95e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com
>
> netlink: 96 bytes leftover after parsing attributes in process `syz-executor899'.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8828 at net/sched/sch_cbq.c:1437 cbq_destroy_class net/sched/sch_cbq.c:1437 [inline]
> WARNING: CPU: 1 PID: 8828 at net/sched/sch_cbq.c:1437 cbq_destroy+0x324/0x400 net/sched/sch_cbq.c:1471


Just FYI: I am still working on a fix, which is more complicated than I thought.

Thanks.
