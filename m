Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401A3191731
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCXRFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:05:55 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34302 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgCXRFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:05:55 -0400
Received: by mail-vs1-f65.google.com with SMTP id b5so1194726vsb.1
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 10:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=++YignfeluUqAX6pApRaB75AO87QYP7h18KmSFM05EQ=;
        b=IntQvyZT/D4wnOdtnjvZ9EDnZREA1vm6rsI9c4pZj6e+ZQZIfeVS+wOlrlLJMI96WI
         1nckS4q1/xfOMNDp3N/jDXdksrEUbU1AFn7564IbV5EgrJABxcSm8/770t2mt83RTj7e
         wOFDI77AH0urGLOusd2YhPhyMwJ69WSIdOPl0bvjHYlyCBTSdD8UY/j3h1TKQqwkSfhN
         fkBCq0HqBCxcN4Kpy8fDm0CbrP3KkmgzxnMhJebEP7ejH6198e4OmqKRxpilluiUCgAE
         KH+6I0Rf9BfCk8COmVsW2xXZPw8ddDRjPIH6VaXZjRb9GPKF5cV2AYhqlcAaDoj/DmnU
         WxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=++YignfeluUqAX6pApRaB75AO87QYP7h18KmSFM05EQ=;
        b=bRmisbFZy2RRwRSWPkIctpuqw+DL665QomtMrg972/V9qeB4rEfqyjwgD2lciJ4bsQ
         F24YdhuEjW71tton97kXKddQTRH4WjQitVaakyGEZhkwxFFtADi4MqIf/iL5H4zfv+oN
         9cK9h8JJKjR6lIuGyfJHXPQaFhxEjSUbjqKnWIne3u+dogvbl+i5dyUzYlLmedsrmcK9
         FvPngzuBao2GqNaSfgK8Y0J3HQt6TM0yPvutowx+ho4RD/eEZ0iNG3rfXg4rZn+Ysy/H
         EHnFoYTTX53cDIVCxJkHl6AZ9dQeZmiS3tROB8yLsHJ//zc20XVqaDRwUlkElBhdH0Wh
         w+6A==
X-Gm-Message-State: ANhLgQ0MHPwf8W9iGBW1ggGGvmLun7cgiXGiJ2XKRmKTK9d3O7Bt8zZc
        XTHo4ss8AHKHMM6W8rlgHK3ERcTRNz/07wXEhUWOxQ==
X-Google-Smtp-Source: ADFU+vtogMt3VOC8v44d05QIPL2BfL2sDBZT5HXowVsKyIdVvGdfGeFVKo0KEFQdnROXY/uE6ryM5bjqink90i8WV8k=
X-Received: by 2002:a67:70c2:: with SMTP id l185mr18912552vsc.123.1585069552882;
 Tue, 24 Mar 2020 10:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi>
 <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com>
 <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
 <CAK6E8=f=tB1Dw-ns5hOysvSbQ1VGJJ1-nLQXtxC6rfZbr5Tnww@mail.gmail.com>
 <alpine.DEB.2.20.2003231528460.32422@whs-18.cs.helsinki.fi>
 <CAK6E8=cBiTo+3M4y6Jn8mEtfwjGBRLNF0-CqXZtqcSNwUE6FGw@mail.gmail.com> <alpine.DEB.2.20.2003241449310.14439@whs-18.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.20.2003241449310.14439@whs-18.cs.helsinki.fi>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 24 Mar 2020 10:05:16 -0700
Message-ID: <CAK6E8=dTKvUbNQeA5wnSNCmW3ARAawxcM7Q4oLBbWMbNnOm-8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 28/28] tcp: AccECN sysctl documentation
To:     =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>
Cc:     Dave Taht <dave.taht@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 5:50 AM Ilpo J=C3=A4rvinen
<ilpo.jarvinen@cs.helsinki.fi> wrote:
>
> On Mon, 23 Mar 2020, Yuchung Cheng wrote:
>
> > On Mon, Mar 23, 2020 at 6:34 AM Ilpo J=C3=A4rvinen
> > <ilpo.jarvinen@cs.helsinki.fi> wrote:
> > >
> > > On Fri, 20 Mar 2020, Yuchung Cheng wrote:
> > >
> > > > On Fri, Mar 20, 2020 at 3:40 PM Ilpo J=C3=A4rvinen
> > > > <ilpo.jarvinen@cs.helsinki.fi> wrote:
> > > > >
> > > > > On Thu, 19 Mar 2020, Dave Taht wrote:
> > > > >
> > > > > > On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=C3=A4rvinen <ilpo.jarvin=
en@helsinki.fi> wrote:
> > > > > > >
> > > > > > > From: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > > > > >
> > > > > > > Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.=
fi>
> > > > > > > ---
> > > > > > >  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
> > > > > > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/Documentation/networking/ip-sysctl.txt b/Documen=
tation/networking/ip-sysctl.txt
> > > > > > > index 5f53faff4e25..ecca6e1d6bea 100644
> > > > > > > --- a/Documentation/networking/ip-sysctl.txt
> > > > > > > +++ b/Documentation/networking/ip-sysctl.txt
> > > > > > > @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
> > > > > > >                 0 Disable ECN.  Neither initiate nor accept E=
CN.
> > > > > > >                 1 Enable ECN when requested by incoming conne=
ctions and
> > > > > > >                   also request ECN on outgoing connection att=
empts.
> > > > > > > -               2 Enable ECN when requested by incoming conne=
ctions
> > > > > > > +               2 Enable ECN or AccECN when requested by inco=
ming connections
> > > > > > >                   but do not request ECN on outgoing connecti=
ons.
> > > > > >
> > > > > > Changing existing user-behavior for this default seems to be ov=
erly
> > > > > > optimistic. Useful for testing, but...
> > > > >
> > > > > I disagree.
> > > > >
> > > > > The kernel default on ECN is/has been "do nothing" like forever. =
Yet,
> > > > > passively allowing ECN on servers is a low risk operation because=
 nothing
> > > > > will change before client actively asks for it. However, it was o=
bvious
> > > > > that the servers didn't do that. The servers could have set tcp_e=
cn to 1
> > > > > (before 2 was there) which is low risk for _servers_ (unlike for =
clients)
> > > > > but only very very few did. I don't believe servers would now
> > > > > intentionally pick 2 when they clearly didn't pick 1 earlier eith=
er.
> > > > >
> > > > > Adding 2 is/was an attempt to side-step the need for both ends to=
 make
> > > > > conscious decision by setting the sysctl (which servers didn't wa=
nt to
> > > > > do). That is, 2 gives decision on what to do into the hands of th=
e client
> > > > > side which was the true intent of 2 (in case you don't know, I ma=
de that
> > > > > change).
> > > > What can a server configure to process only RFC3168 ECN if it prefe=
rs to?
> > >
> > > That's why I suggested the flag-based approach?
> >
> > That's assuming an admin that has control of sysctls can also change
> > individual applications (easily). In reality it often is not the case.
> > The default sysctl choices in this patch seem risky to me.
> >
> > > > > If "full control" is the way to go, I think it should be made usi=
ng flags
> > > > > instead, along these lines:
> > > > >
> > > > > 1: Enable RFC 3168 ECN in+out
> > > > > 2: Enable RFC 3168 ECN in (default on)
> > > > > 4: Enable Accurate ECN in (default on)
> > > > > 8: Enable Accurate ECN in+out
> > > > >
> > > > > Note that I intentionally reversed the in and in/out order for 4&=
8
> > > > > (something that couldn't be done with 1&2 to preserve meaning of =
1).
> > >
> > > It should address any except "out" but no "in" (the meaning of 1 cann=
ot
> > > be changed I think). But out w/o in doesn't sound very useful.
>
> So you mean you'd want to have control that is finer-grained than what th=
e
> sysctls offer?
I recommend having separate sysctl values for AccECN so that servers
configured to use existing values do not behave differently (on ECN)
after kernel upgrade, similar to what Dave Taht suggested.

>
>
> --
>  i.
