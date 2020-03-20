Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92F518DBD0
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgCTXXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:23:00 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34162 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTXXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 19:23:00 -0400
Received: by mail-vs1-f66.google.com with SMTP id t10so5126546vsp.1
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 16:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OXBHwBnIhfZbgmJ5fMzfXXPx9bbYrAMnt/qGmt3CjnU=;
        b=VHAEapM0zjuNKIO3AA6W6/IEpI6sTQpcey+ZyjsvHak2NhreZVlohxBwpyTkzvs9kC
         NV6BNFGvZg5/CzaV0JaOwKN9fxFnEGrGulWRLlMEpYhi9OVSchYFwKXaRRR0FsaDlhaR
         k00IuVqsfnpfK7raDmlQO0PcGsRper64w/DAm6qxYfIbGZiI1OWVOxzs5dsuTNda6qRL
         OJ2SjUFXqnGG0lN7pRCEoWvNsemQRBAYOVV8hG9vz7WCoAltdl4zFx7UCGKTdYgDx6AA
         6S5S9iB7C77EFXUjxW/IxJKlKHPXbeCfdj2jYoIK/hnfFt19a3/LdZeOF21RRsVft0WO
         3SQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OXBHwBnIhfZbgmJ5fMzfXXPx9bbYrAMnt/qGmt3CjnU=;
        b=V7VNFiBVSAbaqKFlL+BXfh7QXOsADinXhwxaI9b6GJRr69XU2iCQScq65YjxEJok/U
         TBxbCUEixlzF50CpBVtq6wSWqddqtUgY8I30xdt+uMSVNe0jtPxguMkEnbypazc0e2ds
         TxijY39MzhMQDSjb8u1Jx/GVs4BO0zWubszMx1WDmYwt/fr1WxrbaxwO3jZ2pDL3ktXw
         d+wbkrQjdftVAJ72Simq0hzfySrJcAW0RdlcxUVdlWuHzuAl2TOZ/omCU30T3DGVaRPj
         bqtBAiQydqj6AS9v02RtQOE8EEWS2f4Hm1GcJgM3mLlr9OBudSoizeS+pGnTMf3057Lh
         tuqw==
X-Gm-Message-State: ANhLgQ3+6bLTxFFXmN2buTCuUsV/43xtFd0oJ9hc7oJr4nEZtQNu9qCz
        OvJvhAG7zgAjI0BwVhOy//8Qy6F140iFsLjrkT52+g==
X-Google-Smtp-Source: ADFU+vsQgHeEbJdvG0B/4PaEfS8+dSu+iFsd8bWqw5SYdJYX6rghkk7BHzbIdd7mLmjB3cRh8kbSRxbkjRaENeb9Yjk=
X-Received: by 2002:a67:70c2:: with SMTP id l185mr7457947vsc.123.1584746579104;
 Fri, 20 Mar 2020 16:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi>
 <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com> <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 20 Mar 2020 16:22:22 -0700
Message-ID: <CAK6E8=f=tB1Dw-ns5hOysvSbQ1VGJJ1-nLQXtxC6rfZbr5Tnww@mail.gmail.com>
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

On Fri, Mar 20, 2020 at 3:40 PM Ilpo J=C3=A4rvinen
<ilpo.jarvinen@cs.helsinki.fi> wrote:
>
> On Thu, 19 Mar 2020, Dave Taht wrote:
>
> > On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=C3=A4rvinen <ilpo.jarvinen@helsi=
nki.fi> wrote:
> > >
> > > From: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > >
> > > Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > ---
> > >  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/n=
etworking/ip-sysctl.txt
> > > index 5f53faff4e25..ecca6e1d6bea 100644
> > > --- a/Documentation/networking/ip-sysctl.txt
> > > +++ b/Documentation/networking/ip-sysctl.txt
> > > @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
> > >                 0 Disable ECN.  Neither initiate nor accept ECN.
> > >                 1 Enable ECN when requested by incoming connections a=
nd
> > >                   also request ECN on outgoing connection attempts.
> > > -               2 Enable ECN when requested by incoming connections
> > > +               2 Enable ECN or AccECN when requested by incoming con=
nections
> > >                   but do not request ECN on outgoing connections.
> >
> > Changing existing user-behavior for this default seems to be overly
> > optimistic. Useful for testing, but...
>
> I disagree.
>
> The kernel default on ECN is/has been "do nothing" like forever. Yet,
> passively allowing ECN on servers is a low risk operation because nothing
> will change before client actively asks for it. However, it was obvious
> that the servers didn't do that. The servers could have set tcp_ecn to 1
> (before 2 was there) which is low risk for _servers_ (unlike for clients)
> but only very very few did. I don't believe servers would now
> intentionally pick 2 when they clearly didn't pick 1 earlier either.
>
> Adding 2 is/was an attempt to side-step the need for both ends to make
> conscious decision by setting the sysctl (which servers didn't want to
> do). That is, 2 gives decision on what to do into the hands of the client
> side which was the true intent of 2 (in case you don't know, I made that
> change).
What can a server configure to process only RFC3168 ECN if it prefers to?

>
> Allowing the client side to make the decision alone has proven successful
> approach. We now have significant passive RFC3168 ECN server deployment.
> It is wide-spread enough that Apple found it useful enough for their
> client side, experimented with it and worked to fix the issues where they
> discovered something in the network was incompatible with ECN. I don't
> believe it would have happened without leaving the decision into the hand=
s
> of the clients.
>
> Similarly, passively allowing the client to decide to use AccECN is
> low risk thing. ...As with RFC 3168 ECN, "do nothing" applies also for
> Accurate ECN here unless the client asks for it.
>
> > > +               3 Enable AccECN when requested by incoming connection=
s and
> > > +                 also request AccECN on outgoing connection attempts=
.
> > > +           0x102 Enable AccECN in optionless mode for incoming conne=
ctions.
> > > +           0x103 Enable AccECN in optionless mode for incoming and o=
utgoing
> > > +                 connections.
> >
> > In terms of the logic bits here, it might make more sense
> >
> > 0: disable ecn
> > 1: enable std ecn on in or out
> > 2: enable std ecn when requested on in (the default)
> > 3: essentially unused
> > 4: enable accecn when requested on in
> > 5: enable std ecn and accecn on in or out
> > 6: enable accecn and ecn on in but not out
>
> If "full control" is the way to go, I think it should be made using flags
> instead, along these lines:
>
> 1: Enable RFC 3168 ECN in+out
> 2: Enable RFC 3168 ECN in (default on)
> 4: Enable Accurate ECN in (default on)
> 8: Enable Accurate ECN in+out
>
> Note that I intentionally reversed the in and in/out order for 4&8
> (something that couldn't be done with 1&2 to preserve meaning of 1).
>
> I think it's a bit complicated though but if this is what most people
> want, I can of course change it to flags.
>
> > Do we have any data on how often the tcp ns bit is a source of
> > firewalling problems yet?
> >
> > 0x102 strikes me as a bit more magical than required
>
> To me it compares to some fast open cookie things that are similarly usin=
g
> higher order bits in flag like manner.
>
> > and I don't know
> > what optionless means in this context.
>
> Do you mean that "optionless" is not a good word to use here? (I'm not
> a native speaker but I can imagine it might sound like "futureless"?)
> I meant that AccECN operates then w/o sending any AccECN option (rx side
> still processes the options if the peer chooses to send them despite not
> getting any back).
>
> Thanks.
>
> --
>  i.
