Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADDE163709
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgBRXPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:15:33 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35249 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbgBRXPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:15:33 -0500
Received: by mail-ed1-f66.google.com with SMTP id y25so4633479edi.2;
        Tue, 18 Feb 2020 15:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JWWqmVpcRfqJEivRVNBcgidPXaZP+c61nTzWzkomjSY=;
        b=dfeL8JDieKb1EJAiJ+pv09xpLoSlv1ti7VYIdShY02oVYOiFQgtiG0Rx4uBBiyZjrS
         QmzwFCgojq0fb4j3gMCYkdaSedFjtCUI8U0OhjQ1PSBvBLikhHQdop8DMtfdHzMCVHQ9
         SJ7qn6r3vZDOmbYsFkbH7WScznKy9qri4Vx/N06RoPr86mPOo0trji7KKh6iGp1JrBTu
         aLbqbiEn2X9WFha7xFYRuEr9gJR/U5RselzA4MYDU0v0gvje+zyG80i2RvBCHa6WRJeS
         jiFf6KQ7J7sQJXEHeZp6CAb80qxp1HaJgG6pPce5/aX1s0Y/nTq8uYNJibsA/LnnVtc4
         s9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JWWqmVpcRfqJEivRVNBcgidPXaZP+c61nTzWzkomjSY=;
        b=lW0flRUwPnY5kjdvgPgPEqshxVymZhZ5AfKr5EhQy9/1MkxMYbjaHe0jTGkg8wA4y8
         Cv7zsMqBTEInzjRfAYvpGkDdqboWMNiq+CcUTd84mcWyGRZfiCAs27KPvzMv0ASu1h6i
         ya5xHmTlWUZcnuR/JV6qkJXqhwHdTNjOH7K73euhWwWarr9I+FpcSl3OnmKNzGUtzw5A
         A4j33A4METsLkdF48b/3/PBeAt1lHAGPcUD66T+eCt5c5TTaYJtbqiYJUaquZ91ESNH6
         ZThoeyaY7pBgQvyyQ1WBor2eaDDVGLUkkhAhMy/c0alsAzHMkigHwq541CyIPDvE32GL
         iT1A==
X-Gm-Message-State: APjAAAWqoA4IA3injHJXo8LmsCHbL6soZPuQXa/WmhdU2qcPweyRUF/P
        IFshMy4oMiBvwnbQ67n9QQ0whLJJ1HjbPqAUa40=
X-Google-Smtp-Source: APXvYqwpiOgIQO5h/xXb5VqSiH6WwB+YHjUU0Oq3uD55L/C5F0wkdPzJFx0H5q34fTJ4KuEdbA/iQm/ZlBnvvxRQZeU=
X-Received: by 2002:a50:a864:: with SMTP id j91mr21551777edc.318.1582067731479;
 Tue, 18 Feb 2020 15:15:31 -0800 (PST)
MIME-Version: 1.0
References: <20200217144414.409-1-olteanv@gmail.com> <20200217144414.409-4-olteanv@gmail.com>
 <20200217152912.GE31084@lunn.ch> <CA+h21ho29TRG8JYfSaaSsoxM-mg0-yOKBNCq9wbHDHCf2pkdUg@mail.gmail.com>
 <CA+h21hp-4WWtY=-WeMgC0M6Ls7Aq6AdVv3y=8WE9z=2Ybikt7Q@mail.gmail.com>
In-Reply-To: <CA+h21hp-4WWtY=-WeMgC0M6Ls7Aq6AdVv3y=8WE9z=2Ybikt7Q@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 19 Feb 2020 01:15:20 +0200
Message-ID: <CA+h21hqyiMQ6rxNz+hC-L7qX0heDAjoEXr1c5TBNV97hFRAopQ@mail.gmail.com>
Subject: Re: [PATCH devicetree 3/4] arm64: dts: fsl: ls1028a: add node for
 Felix switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 17 Feb 2020 at 19:24, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, 17 Feb 2020 at 17:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi Andrew,
> >
> > On Mon, 17 Feb 2020 at 17:29, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > Hi Vladimir
> > >
> > > > +                                     /* Internal port with DSA tagging */
> > > > +                                     mscc_felix_port4: port@4 {
> > > > +                                             reg = <4>;
> > > > +                                             phy-mode = "gmii";
> > >
> > > Is it really using gmii? Often in SoC connections use something else,
> > > and phy-mode = "internal" is more appropriate.
> > >
> >
> > What would be that "something else"? Given that the host port and the
> > switch are completely different hardware IP blocks, I would assume
> > that a parallel GMII is what's connecting them, no optimizations done.
> > Certainly no serializer. But I don't know for sure.
> > Does it matter, in the end?
> >
>
> To clarify, the reason I'm asking whether it matters is because I'd
> have to modify PHY_INTERFACE_MODE_GMII in
> drivers/net/dsa/ocelot/felix_vsc9959.c too, for the internal ports.
> Then I'm not sure anymore what tree this device tree patch should go
> in through.
>
> > > > +                                             ethernet = <&enetc_port2>;
> > > > +
> > > > +                                             fixed-link {
> > > > +                                                     speed = <2500>;
> > > > +                                                     full-duplex;
> > > > +                                             };
> > >
> > > gmii and 2500 also don't really go together.
> >
> > Not even if you raise the clock frequency?
> >
> > >
> > >      Andrew
> >
> > Thanks,
> > -Vladimir

Correct me if I'm wrong, but I think that PHY_INTERFACE_MODE_INTERNAL
is added by Florian in 2017 as a generalization of the BCM7445 DSA
switch bindings with internal PHY ports, and later became "popular"
with other DSA drivers (ar9331, lantiq gswip). Of those, ar9331 is
actually using phy-mode = "gmii" for the CPU port, and phy-mode =
"internal" for the embedded copper PHYs.
I hate to be making this sort of non-binary decision. Is it a GMII
interface _or_ an internal interface? Prior to 2017, this would have
probably been a non-question. The patch series which adds it does not
clarify "you should use this mode in situation A, and this mode in
situation B" either.

Regards,
-Vladimir
