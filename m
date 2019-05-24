Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2263D29493
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389965AbfEXJY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:24:26 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:38024 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389732AbfEXJY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:24:26 -0400
Received: by mail-it1-f194.google.com with SMTP id i63so12794188ita.3
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 02:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HYgiw9gdlhueg6+WRAGyhJKX3AtGrR1zYnjTbOTRfuY=;
        b=wFonep2dku0EgPsJQkwjn4qapIzbxEItS07MsYZtekZBxqqCxFWH+MeuyJ6bjDF28a
         KpuMxHLx4Dey+j1/UoQ0wEodShezvwCAaVP8ACNkyacJvevRpu9drmOiaT4m7EKklQqk
         jQU3VG3IbBvFEEQ+u2u2r/Z4MWdh9ywg9cey7DPiNvK/PTrUhJdOQ4lcCn+invrdaAB9
         x/MFN1bt83Gy7Rpatti38cgt1xZ5RA1W4y+lRbbLgzBM7IYWHHeSbgceaYm3DhNY1M1Z
         uftoxhYDz76QZHEF+QurEEU+8+XHbJ3lQGO1ZP47YB5JC53IIMAZtqQX7S8S95j5YX1g
         xlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HYgiw9gdlhueg6+WRAGyhJKX3AtGrR1zYnjTbOTRfuY=;
        b=QuAhQ1zXqa5yfAvi9sYl8tiFCZOgzOsDHY5m5zM1AaNTq1OqmwWKtVTHqviM3KqsX7
         hc3WOhLViWDAomjrsE+FNTz/Ft4uCugSFAZl7k32LSWJnRwL0VKwYwU5nkIZeABZf8B5
         FAmrGJkYeh7qiv5osqvASN5cXLO9OqByC8UxoJKkVLDt5Onmoy7QZz/pYWbIvINM/bo0
         3BQgE0qVQbeV/7zmPCHnAqLSf6lnWFm1Pd2oTi6lIff8REA0bT3f+KqdgDNxfIyt4/X9
         Oshw9VUOrF3CKQs6ssxeRcrNPLCAdZDdE81N955/XTClePZCl7sqludm4cU7nchjUaTM
         +i8A==
X-Gm-Message-State: APjAAAVgUyiQ//W/6NnR2p0uhdRLUIGGEOApgHo/hSjDxZ2YfgHmIdNp
        GQjS2g12tlDD0V5iEmjJBgh8ON1aRsPOP9A0SSE/ekMP
X-Google-Smtp-Source: APXvYqzSFjcTrQ2rHAw6gfH24REoDGsW3b8LRVtsKU42COArxlGqgL+aTZ/NtgQ7xnvLKEwhjywv57YGeuFjAvP552U=
X-Received: by 2002:a02:1384:: with SMTP id 126mr60762476jaz.72.1558689865209;
 Fri, 24 May 2019 02:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008666df05899b7663@google.com> <649cac1e-c77c-daf8-6ae7-b02c8571b988@iogearbox.net>
In-Reply-To: <649cac1e-c77c-daf8-6ae7-b02c8571b988@iogearbox.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 24 May 2019 11:24:14 +0200
Message-ID: <CACT4Y+Y_iA=5Bdtcg+X-ky7Q3m5hxGOexo+246b6b2ow_GLUGg@mail.gmail.com>
Subject: Re: bpf build error
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot <syzbot+cbe357153903f8d9409a@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 10:08 AM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> On 05/24/2019 07:28 AM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    e6f6cd0d bpf: sockmap, fix use after free from sleep in=
 ps..
> > git tree:       bpf
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16f116e4a00=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dfc045131472=
947d7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dcbe357153903f=
8d9409a
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+cbe357153903f8d9409a@syzkaller.appspotmail.com
> >
> > net/core/skbuff.c:2340:6: error: =E2=80=98struct msghdr=E2=80=99 has no=
 member named =E2=80=98flags=E2=80=99
>
> Disregard, tossed from bpf tree.

Let's close it then

#syz invalid

or it will hang open on the dashboard distracting people looking for
open bugs and new bpf build breakages won't be reported.
