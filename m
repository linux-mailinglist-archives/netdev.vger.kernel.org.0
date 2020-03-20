Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768DA18CD0B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCTLch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:32:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43622 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCTLch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:32:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id n25so5770394eds.10
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 04:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RSnD9xSDOW7ijnveV2tieYH43cJUJrS080w49dqc/qI=;
        b=HUI9WoNkw8Sf30CQWRILVzC4tIN0jZeZhgo3KR4afVe06Zj4gJyy7EvMllxEwGJ7Y6
         NQTBCnJEWqyGgrlBLEKj3aFE1fKCGcc5IForp69tVCSS0TPIHGQhtzLUmMfNEzY5EDXj
         74M50kQjC9PgibIBE1ZKXyqpd1ysK5J9m+TpxuBj+5FHE1+1c3XVkLLLDI3YbB3y0AGo
         ocYcGTcvvseWwgVLgkJ0GPzriE28mut75kigJArbh5mX66JDMsFG/WVmLYpsbyvoHxi6
         jFdqpJrYGhpcL8hdIIjPiAubn2qIgsT+/4s4mDujXcjDnlGTC4wcfpQCos6y5UdK4xDe
         HEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RSnD9xSDOW7ijnveV2tieYH43cJUJrS080w49dqc/qI=;
        b=La73wIzLZcgt3L3hPOmjYJu3SgM9xR4iFLWjNsxeG02ENPZgLL7f7+uDk0CxizmzUz
         8H1H/Gcv6SqrCb4JtNBUUxJFF9PY6tDUj9b/vz3rumMYYRgTpMYlBmbEdnmUzF9Q/G1h
         Tozee0lXV8tx3+5+wjl8jjcpyQgO6l1pjkrDj9UGIlvFJq2duk/rLbu1YkxynkKYxweT
         zWUN9drOmRQHP+iPGalpY4WmNido7vwWWlbMelNTHW+VZgWQOAQmwSyMXTjup+PJgQnH
         KDWJH/6l0nVDbJSpv/Bh1xXQoqZhCC6SCCFFjpmEdaOr8aTfcYs4uKkQkvO8vxztnbnY
         LVZQ==
X-Gm-Message-State: ANhLgQ1yGoiw/pnXUL7yFia+kNRCywz6/OICR8uNn6bxIyRpmQ1ZCwKH
        Rge/Vddk0hNEgQ1nnopsTlxbRk/F0STdAgjAACU=
X-Google-Smtp-Source: ADFU+vtQ9iYQqg0skxiS08PIoKSG3htaXyoD3uFIgUT4t4aDAhPjP54u0UG95XT2rQHekgNOzbHWhMCOhcOoaDpzoOQ=
X-Received: by 2002:a17:906:9451:: with SMTP id z17mr7711218ejx.176.1584703955525;
 Fri, 20 Mar 2020 04:32:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200319211649.10136-1-olteanv@gmail.com> <20200319211649.10136-2-olteanv@gmail.com>
 <20200320100925.GB16662@lunn.ch> <CA+h21hrvsfwspGE6z37p-fwso3oD0pXijh+fZZfEEUEv6bySHQ@mail.gmail.com>
 <158470229183.43774.8932556125293087780@kwain>
In-Reply-To: <158470229183.43774.8932556125293087780@kwain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 20 Mar 2020 13:32:24 +0200
Message-ID: <CA+h21ho4aqgCSjgPTJ10cVeUow_RAUTNd9NSrVPJJVEqjAws9g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: phy: mscc: rename enum
 rgmii_rx_clock_delay to rgmii_clock_delay
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 at 13:05, Antoine Tenart <antoine.tenart@bootlin.com> w=
rote:
>
> Hello,
>
> Quoting Vladimir Oltean (2020-03-20 11:38:05)
> > On Fri, 20 Mar 2020 at 12:09, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Thu, Mar 19, 2020 at 11:16:46PM +0200, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > There is nothing RX-specific about these clock skew values. So remo=
ve
> > > > "RX" from the name in preparation for the next patch where TX delay=
s are
> > > > also going to be configured.
> > > >
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > ---
> > > >  drivers/net/phy/mscc/mscc.h      | 18 +++++++++---------
> > > >  drivers/net/phy/mscc/mscc_main.c |  2 +-
> > > >  2 files changed, 10 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/msc=
c.h
> > > > index 29ccb2c9c095..56feb14838f3 100644
> > > > --- a/drivers/net/phy/mscc/mscc.h
> > > > +++ b/drivers/net/phy/mscc/mscc.h
> > > > @@ -12,15 +12,15 @@
> > > >  #include "mscc_macsec.h"
> > > >  #endif
> > > >
> > > > -enum rgmii_rx_clock_delay {
> > > > -     RGMII_RX_CLK_DELAY_0_2_NS =3D 0,
> > > > -     RGMII_RX_CLK_DELAY_0_8_NS =3D 1,
> > > > -     RGMII_RX_CLK_DELAY_1_1_NS =3D 2,
> > > > -     RGMII_RX_CLK_DELAY_1_7_NS =3D 3,
> > > > -     RGMII_RX_CLK_DELAY_2_0_NS =3D 4,
> > > > -     RGMII_RX_CLK_DELAY_2_3_NS =3D 5,
> > > > -     RGMII_RX_CLK_DELAY_2_6_NS =3D 6,
> > > > -     RGMII_RX_CLK_DELAY_3_4_NS =3D 7
> > > > +enum rgmii_clock_delay {
> > > > +     RGMII_CLK_DELAY_0_2_NS =3D 0,
> > > > +     RGMII_CLK_DELAY_0_8_NS =3D 1,
> > > > +     RGMII_CLK_DELAY_1_1_NS =3D 2,
> > > > +     RGMII_CLK_DELAY_1_7_NS =3D 3,
> > > > +     RGMII_CLK_DELAY_2_0_NS =3D 4,
> > > > +     RGMII_CLK_DELAY_2_3_NS =3D 5,
> > > > +     RGMII_CLK_DELAY_2_6_NS =3D 6,
> > > > +     RGMII_CLK_DELAY_3_4_NS =3D 7
> > > >  };
> > >
> > > Can this be shared?
> > >
> > > https://www.spinics.net/lists/netdev/msg638747.html
> > >
> > > Looks to be the same values?
> > >
> > > Can some of the implementation be consolidated?
>
> > - That patch is writing to MSCC_PHY_RGMII_SETTINGS (defined to 18).
> > This one is writing to MSCC_PHY_RGMII_CNTL (defined to 20). And since
> > I have no documentation to understand why, I'm back to square 1.
>
> These are two different registers, using similar values. I guess the
> register was moved around as those PHYs are from the same family; but
> I'm not sure if it's correct to consolidate it as we do not know for
> sure. (Practically speaking the same values are used, so why not).
>
> Thanks,
> Antoine
>
> --
> Antoine T=C3=A9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

And to add to that: without documentation, I don't really know what
I'm consolidating.

 -Vladimir
