Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B95618F5CA
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgCWNev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:34:51 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:60594 "EHLO
        script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgCWNev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:34:51 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2017-10-25 mail.cs.helsinki.fi Mon, 23 Mar 2020 15:34:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.helsinki.fi;
         h=date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=dkim20130528; bh=WtvmLsM9AN1IIyOYJ
        uWzjEvieT5KXChUvNYf99oxXYI=; b=MdBd7SsiUlwyGSZxydhysNtVO/Ov/++6p
        iUxqvQjs9JkmY/sDkXu8NYQwu+zjuG4tty3vXV7tFS9WVJWLjhrflshtBJuCluxr
        WwllvwJhTIW4dRJqriRC4giTYinmM0/M31FKyOILKdO5yNt8Aqnb8e4aa1gIRD4o
        wYUrm+rxeU=
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
  (TLS: TLSv1/SSLv3,256bits,AES256-GCM-SHA384)
  by mail.cs.helsinki.fi with ESMTPS; Mon, 23 Mar 2020 15:34:40 +0200
  id 00000000005A01CB.000000005E78BAF0.00005EC5
Date:   Mon, 23 Mar 2020 15:34:40 +0200 (EET)
From:   "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@cs.helsinki.fi>
X-X-Sender: ijjarvin@whs-18.cs.helsinki.fi
To:     Yuchung Cheng <ycheng@google.com>
cc:     Dave Taht <dave.taht@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: Re: [RFC PATCH 28/28] tcp: AccECN sysctl documentation
In-Reply-To: <CAK6E8=f=tB1Dw-ns5hOysvSbQ1VGJJ1-nLQXtxC6rfZbr5Tnww@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.2003231528460.32422@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi> <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com> <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
 <CAK6E8=f=tB1Dw-ns5hOysvSbQ1VGJJ1-nLQXtxC6rfZbr5Tnww@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_script-24287-1584970480-0001-2"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_script-24287-1584970480-0001-2
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Mar 2020, Yuchung Cheng wrote:

> On Fri, Mar 20, 2020 at 3:40 PM Ilpo J=E4rvinen
> <ilpo.jarvinen@cs.helsinki.fi> wrote:
> >
> > On Thu, 19 Mar 2020, Dave Taht wrote:
> >
> > > On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=E4rvinen <ilpo.jarvinen@hels=
inki.fi> wrote:
> > > >
> > > > From: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > >
> > > > Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > > ---
> > > >  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
> > > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/Documentation/networking/ip-sysctl.txt b/Documentati=
on/networking/ip-sysctl.txt
> > > > index 5f53faff4e25..ecca6e1d6bea 100644
> > > > --- a/Documentation/networking/ip-sysctl.txt
> > > > +++ b/Documentation/networking/ip-sysctl.txt
> > > > @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
> > > >                 0 Disable ECN.  Neither initiate nor accept ECN.
> > > >                 1 Enable ECN when requested by incoming connectio=
ns and
> > > >                   also request ECN on outgoing connection attempt=
s.
> > > > -               2 Enable ECN when requested by incoming connectio=
ns
> > > > +               2 Enable ECN or AccECN when requested by incoming =
connections
> > > >                   but do not request ECN on outgoing connections.
> > >
> > > Changing existing user-behavior for this default seems to be overly
> > > optimistic. Useful for testing, but...
> >
> > I disagree.
> >
> > The kernel default on ECN is/has been "do nothing" like forever. Yet,
> > passively allowing ECN on servers is a low risk operation because not=
hing
> > will change before client actively asks for it. However, it was obvio=
us
> > that the servers didn't do that. The servers could have set tcp_ecn t=
o 1
> > (before 2 was there) which is low risk for _servers_ (unlike for clie=
nts)
> > but only very very few did. I don't believe servers would now
> > intentionally pick 2 when they clearly didn't pick 1 earlier either.
> >
> > Adding 2 is/was an attempt to side-step the need for both ends to mak=
e
> > conscious decision by setting the sysctl (which servers didn't want t=
o
> > do). That is, 2 gives decision on what to do into the hands of the cl=
ient
> > side which was the true intent of 2 (in case you don't know, I made t=
hat
> > change).
> What can a server configure to process only RFC3168 ECN if it prefers t=
o?

That's why I suggested the flag-based approach?

> > If "full control" is the way to go, I think it should be made using f=
lags
> > instead, along these lines:
> >
> > 1: Enable RFC 3168 ECN in+out
> > 2: Enable RFC 3168 ECN in (default on)
> > 4: Enable Accurate ECN in (default on)
> > 8: Enable Accurate ECN in+out
> >
> > Note that I intentionally reversed the in and in/out order for 4&8
> > (something that couldn't be done with 1&2 to preserve meaning of 1).

It should address any except "out" but no "in" (the meaning of 1 cannot=20
be changed I think). But out w/o in doesn't sound very useful.

--
 i.

--=_script-24287-1584970480-0001-2--
