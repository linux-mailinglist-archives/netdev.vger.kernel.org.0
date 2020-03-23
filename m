Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447C618FD39
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgCWTEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:04:07 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:38725 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgCWTEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 15:04:07 -0400
Received: by mail-vs1-f65.google.com with SMTP id x206so9540451vsx.5
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 12:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NDYOXFTMDWIdsCkfyyirGcOsGcwZtinXqJlRoDSoqTo=;
        b=YNued+IkDlOLvZGJuYI1titjTXU2zN02Oe5Xt+lLRBOnsagazRi+5torcb9UcgRvP+
         Bhn8OKR5qSK0o3VYkPH3sKWwUKyp1dpOydpbkNbIxJaEw7ljU1wLBdHw+abLd0E6vTHc
         1PC9n4iFll/L0aR+NNIAqglYSHxdFwo7P9DTLi6O+KviZsHw+vn5+BljoUl4d/eu09Az
         z9MYR+m1ckdq38eyaUOdSMc3X72vI2fsZt8XJtqV0htBG3MJpIbiNt9NOyi6ap0MeBw5
         XHB1oEIM6kehU/ZSyUjAwjHoK1KmNgFT6bltH+O/fmSigAs18KPy9Z3h4NLh66g7nyBq
         mnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NDYOXFTMDWIdsCkfyyirGcOsGcwZtinXqJlRoDSoqTo=;
        b=WeRYejLQb1U4nLuL+A/gR7RHxzFgQYmOzqV7EpFhifWAJNGKV+/saPn/lLj2xMpgjf
         OxQeCV8OXSNhhdYDUUCpvtqiK3VVxJtdRnbg2ofPkKumw1GqWkwIPY/Qnv6m36K5MsOn
         37qbA/u1LFtkBsiapuhad0NqCWkFgZjPQHSjXkUhhaqEORrZ/upmw46a6OzFAJPPlZCE
         GmMjr/QQBODVzbSj1mfpBMEgmv8Ryw1LAIr3PgNSu0mCdkgeso8TC1TDVFe88gEFkTKl
         VAiTai0aSi9mEaM1CMxaECDfeZYRLoEW6w5bzlcNpDt+G4QoMTW2iQxoJA9yuyDqY3mj
         ZGyw==
X-Gm-Message-State: ANhLgQ0rxlPHrV6+UouHgjVaf9ek/Fr1Nh8aRf9CrNgVRbSfnYGblcG5
        eiZMfoBHfA9AzNJXBgq1RR4a1PayJ2HrBT8J38862Q==
X-Google-Smtp-Source: ADFU+vtzYXgtcShoih79dwSCyf4uy/B4YvUs9zTgh3btpuUpChoUKIr6zYLUYEP7ynwvFy4m9Hk38dc0rzQ8GoScTPc=
X-Received: by 2002:a67:cb07:: with SMTP id b7mr15906739vsl.104.1584990245584;
 Mon, 23 Mar 2020 12:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi>
 <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com>
 <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
 <CAK6E8=f=tB1Dw-ns5hOysvSbQ1VGJJ1-nLQXtxC6rfZbr5Tnww@mail.gmail.com> <alpine.DEB.2.20.2003231528460.32422@whs-18.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.20.2003231528460.32422@whs-18.cs.helsinki.fi>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 23 Mar 2020 12:03:29 -0700
Message-ID: <CAK6E8=cBiTo+3M4y6Jn8mEtfwjGBRLNF0-CqXZtqcSNwUE6FGw@mail.gmail.com>
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

On Mon, Mar 23, 2020 at 6:34 AM Ilpo J=C3=A4rvinen
<ilpo.jarvinen@cs.helsinki.fi> wrote:
>
> On Fri, 20 Mar 2020, Yuchung Cheng wrote:
>
> > On Fri, Mar 20, 2020 at 3:40 PM Ilpo J=C3=A4rvinen
> > <ilpo.jarvinen@cs.helsinki.fi> wrote:
> > >
> > > On Thu, 19 Mar 2020, Dave Taht wrote:
> > >
> > > > On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=C3=A4rvinen <ilpo.jarvinen@h=
elsinki.fi> wrote:
> > > > >
> > > > > From: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > > >
> > > > > Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > > > ---
> > > > >  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
> > > > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/networking/ip-sysctl.txt b/Documentati=
on/networking/ip-sysctl.txt
> > > > > index 5f53faff4e25..ecca6e1d6bea 100644
> > > > > --- a/Documentation/networking/ip-sysctl.txt
> > > > > +++ b/Documentation/networking/ip-sysctl.txt
> > > > > @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
> > > > >                 0 Disable ECN.  Neither initiate nor accept ECN.
> > > > >                 1 Enable ECN when requested by incoming connectio=
ns and
> > > > >                   also request ECN on outgoing connection attempt=
s.
> > > > > -               2 Enable ECN when requested by incoming connectio=
ns
> > > > > +               2 Enable ECN or AccECN when requested by incoming=
 connections
> > > > >                   but do not request ECN on outgoing connections.
> > > >
> > > > Changing existing user-behavior for this default seems to be overly
> > > > optimistic. Useful for testing, but...
> > >
> > > I disagree.
> > >
> > > The kernel default on ECN is/has been "do nothing" like forever. Yet,
> > > passively allowing ECN on servers is a low risk operation because not=
hing
> > > will change before client actively asks for it. However, it was obvio=
us
> > > that the servers didn't do that. The servers could have set tcp_ecn t=
o 1
> > > (before 2 was there) which is low risk for _servers_ (unlike for clie=
nts)
> > > but only very very few did. I don't believe servers would now
> > > intentionally pick 2 when they clearly didn't pick 1 earlier either.
> > >
> > > Adding 2 is/was an attempt to side-step the need for both ends to mak=
e
> > > conscious decision by setting the sysctl (which servers didn't want t=
o
> > > do). That is, 2 gives decision on what to do into the hands of the cl=
ient
> > > side which was the true intent of 2 (in case you don't know, I made t=
hat
> > > change).
> > What can a server configure to process only RFC3168 ECN if it prefers t=
o?
>
> That's why I suggested the flag-based approach?

That's assuming an admin that has control of sysctls can also change
individual applications (easily). In reality it often is not the case.
The default sysctl choices in this patch seem risky to me.



>
> > > If "full control" is the way to go, I think it should be made using f=
lags
> > > instead, along these lines:
> > >
> > > 1: Enable RFC 3168 ECN in+out
> > > 2: Enable RFC 3168 ECN in (default on)
> > > 4: Enable Accurate ECN in (default on)
> > > 8: Enable Accurate ECN in+out
> > >
> > > Note that I intentionally reversed the in and in/out order for 4&8
> > > (something that couldn't be done with 1&2 to preserve meaning of 1).
>
> It should address any except "out" but no "in" (the meaning of 1 cannot
> be changed I think). But out w/o in doesn't sound very useful.
>
> --
>  i.
