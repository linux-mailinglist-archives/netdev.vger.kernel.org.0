Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9151A29F23
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732115AbfEXTeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:34:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36858 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfEXTeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:34:03 -0400
Received: by mail-ed1-f68.google.com with SMTP id a8so15795578edx.3
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 12:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2z8CmZt5cPEjU4CsCj8pAJHrVsw5XrHwU4Nj6fdZRB0=;
        b=FLfZ4LBFUUlMzV3vr9fuZLG7VAeMsRH8HnM9refm5NJm6MpCgOyggnFtUmgSGjBQUB
         xoxUlXbiG/kPL7bquDztkf8nFuuP1YyF30kVTgBCm1VE/nbhxO3C0n83gg3WvywXqLlu
         Dj7zrolAJQjjpm5VeF8JrzyBPrxEj0oC2aAVImr+jrBwrAmWzc5WvwsbcWBbTHZVUDya
         mgsCRJVbjpxt6XKhDOIekeiutZTZJlUeN+6RJbrK3pMYqiEAFlPM05jg8dzwTQiXZ6g1
         tKRzWi2jpPqbZFUMuBPg8pUe1LyR7ulIi8jjixhZp0I30EpZIsodoD2AdSGp2QNgqJo6
         MfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2z8CmZt5cPEjU4CsCj8pAJHrVsw5XrHwU4Nj6fdZRB0=;
        b=g5nS+esH3IKhElcgXHRpS6Bbnvgw6IJ0Xeuar74hyIc94lJmnNEgGDL4NtAPtZZ71F
         0xAdiABxdnAb0DuCh9LpIwkMS4UTqSuZmzjeBQ7YzPfIe0O5yTahzH9to+T5rUd7NlMS
         3zafqxU1KoirzOacofExEVZJohFV2tE+FwzeOVD+iDCGTnAAQmiV8NIB7DKKKel9FbQg
         sUBA1X0E7F9aVMPMInosB1qaxXxscW/jd0I6CLKgYfT8Z1mUEloPJpfME8aEtuFphdcg
         YKDosFXEhFGTmxSA4ziQbxaEPRfncjjgzygu4XSg5Ga5tYWpp7nI+SmbbMEMLBefAUmh
         OK4A==
X-Gm-Message-State: APjAAAXmtv+d+nW3a1bqQdz6mbrKLEwocuOiLg8Cp/q+Zv2XlL0dNtOe
        ksO1kDVZPR3UMlpHyFbDxGXkG4hus2PYeRmy6cg=
X-Google-Smtp-Source: APXvYqwQFRJBfw7acmUwhlbBEQRlfHVl79/EE81g82XHywPD+3cJRHNLTekimbJmJTtjpOjvWuD22E8Nw1r098r/vFA=
X-Received: by 2002:a17:906:60c9:: with SMTP id f9mr48659296ejk.83.1558726441481;
 Fri, 24 May 2019 12:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190524102541.4478-1-muvarov@gmail.com> <20190524102541.4478-2-muvarov@gmail.com>
 <a812ab2b-23ce-80b8-0623-de847b941fe7@gmail.com>
In-Reply-To: <a812ab2b-23ce-80b8-0623-de847b941fe7@gmail.com>
From:   Maxim Uvarov <muvarov@gmail.com>
Date:   Fri, 24 May 2019 22:33:50 +0300
Message-ID: <CAJGZr0LfM5oqXCOcfChwAqrjDnaTaK3Ja2Pko4T73THrU1y=AQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] net:phy:dp83867: fix speed 10 in sgmii mode
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D0=BF=D1=82, 24 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 20:24, Heiner Kallw=
eit <hkallweit1@gmail.com>:
>
> On 24.05.2019 12:25, Max Uvarov wrote:
> > For support 10Mps sped in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
> > of DP83867_10M_SGMII_CFG register has to be cleared by software.
> > That does not affect speeds 100 and 1000 so can be done on init.
> >
> > Signed-off-by: Max Uvarov <muvarov@gmail.com>
> > ---
> >  drivers/net/phy/dp83867.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> > index fd35131a0c39..afd31c516cc7 100644
> > --- a/drivers/net/phy/dp83867.c
> > +++ b/drivers/net/phy/dp83867.c
> > @@ -30,6 +30,7 @@
> >  #define DP83867_STRAP_STS1   0x006E
> >  #define DP83867_RGMIIDCTL    0x0086
> >  #define DP83867_IO_MUX_CFG   0x0170
> > +#define DP83867_10M_SGMII_CFG  0x016F
> >
> >  #define DP83867_SW_RESET     BIT(15)
> >  #define DP83867_SW_RESTART   BIT(14)
> > @@ -74,6 +75,9 @@
> >  /* CFG4 bits */
> >  #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
> >
> > +/* 10M_SGMII_CFG bits */
> > +#define DP83867_10M_SGMII_RATE_ADAPT          BIT(7)
> > +
> >  enum {
> >       DP83867_PORT_MIRROING_KEEP,
> >       DP83867_PORT_MIRROING_EN,
> > @@ -277,6 +281,24 @@ static int dp83867_config_init(struct phy_device *=
phydev)
> >                                      DP83867_IO_MUX_CFG_IO_IMPEDANCE_CT=
RL);
> >       }
> >
> > +     if (phydev->interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
> > +             /* For support SPEED_10 in SGMII mode
> > +              * DP83867_10M_SGMII_RATE_ADAPT bit
> > +              * has to be cleared by software. That
> > +              * does not affect SPEED_100 and
> > +              * SPEED_1000.
> > +              */
> > +             val =3D phy_read_mmd(phydev, DP83867_DEVADDR,
> > +                                DP83867_10M_SGMII_CFG);
> > +             val &=3D ~DP83867_10M_SGMII_RATE_ADAPT;
> > +             ret =3D phy_write_mmd(phydev, DP83867_DEVADDR,
> > +                                 DP83867_10M_SGMII_CFG, val);
>
> This could be simplified by using phy_modify_mmd().
>
> > +             if (ret) {
> > +                     WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\=
n");
>
> This error message says more or less nothing. The context is visible in t=
he
> stack trace, so you can remove the message w/o losing anything.
> As we're in the config_init callback, I don't think the "ONCE" version is
> needed. So you could simply use WARN_ON(1). Typically just the errno is
> returned w/o additional message, so you could also simply do:
> return phy_modify_mmd(phydev, ...)

The error shoud indicate that something is wrong with mdio bus. I.e.
write returned error. And it's more likely hardware bug which needs to
be fixed. Once I used to not print this error on each ifconfig
up/down.

Max.

>
> > +                     return ret;
> > +             }
> > +     }
> > +
> >       /* Enable Interrupt output INT_OE in CFG3 register */
> >       if (phy_interrupt_is_valid(phydev)) {
> >               val =3D phy_read(phydev, DP83867_CFG3);
> >
>


--=20
Best regards,
Maxim Uvarov
