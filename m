Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16C29F51
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391503AbfEXTqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:46:32 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41325 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391181AbfEXTqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:46:31 -0400
Received: by mail-ed1-f65.google.com with SMTP id m4so15805018edd.8
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 12:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/Ck6wvTUAwb1WUjEOSpML6C5pQ+OBRshdJa8zkDwgYM=;
        b=DmQzHbhqOGqC/fNodKmALNzkAZgMtgLIYqf1qcB1WUpsNyH2z1GbkrsCphUHJml/8j
         i9UB7JuEIy9LsYLmvb1eh6bpipm3jfPArj2vShDx0/goalDJ1Q1/iwRVih4WOigHyHbm
         RGnyDE/aeiAz8r8+DE0xJXbb+DPRV82YyKLCFMD+7GdmeDRPEdqOrOoGXf19X3W6Zbfq
         jZxImIgWbW++Tw311OsEgswqD+D/nDzWCIe6QlHbj/JptVgYF7qZuPnzsrVH2Z8sjRJq
         wXLFtBPjvdLcuLn2Se6WGT/lT8KOP/0AqHp6aqPnJuP9egHDqC7jJlX1jOUrUT+rkQKD
         l5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/Ck6wvTUAwb1WUjEOSpML6C5pQ+OBRshdJa8zkDwgYM=;
        b=nHKizJh+eu6hCwXJkTPKUiUaeOeiPttzllxiIrohV0opcZ6s0JquNj1zxeJGvqZcYL
         a1DPlTPbmmjpQJe/TEGpvBxj3DQ+C6tTYFrqXi+alnGpP/ZQ8lJAPLEal/ZFqmRMZbzw
         NLhQcVoPwKFZzCFT1Oh1L77yXmfo9U808ozHhMMOhjX1tpPbpVEeFIo762RbD8fLKF3B
         owynDP3r/pmOCZI08GMTUX95hyLczNvuTSzC3oBYQ3FMblBphot82DlAh8IbZRdSzoiH
         gvepN6xh0SaH5D1Ruf5cU12IqAlj1dumtMBjW9H1FRyHauDFuwqjctx9njWklbd8CPX4
         5+ig==
X-Gm-Message-State: APjAAAWF85M5koujlkP/2vbFK4gIqXYJVDY3m9yFRzhnCXz8aS3EE/Rx
        C/p4VnXRyllssY89nW5HicBsaYwpgrNNWO/BCKn/105dSeQ=
X-Google-Smtp-Source: APXvYqyNwsgq3+oV1LYwtrttXeKsMY6z7f/gHc1TbwITgUcoBlCSxmQZV0/K+tUOhnbGddRo0j2sD+LazbR+aIkVmjw=
X-Received: by 2002:a17:906:14db:: with SMTP id y27mr12610584ejc.132.1558727190117;
 Fri, 24 May 2019 12:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190524103523.8459-1-muvarov@gmail.com> <748ce02b-985d-54ad-8cfe-736f38622e25@gmail.com>
In-Reply-To: <748ce02b-985d-54ad-8cfe-736f38622e25@gmail.com>
From:   Maxim Uvarov <muvarov@gmail.com>
Date:   Fri, 24 May 2019 22:46:18 +0300
Message-ID: <CAJGZr0Lo0gEiqgdvb0Z7UiapgLMX9m6LbtomsF-97JzT7Whsnw@mail.gmail.com>
Subject: Re: [PATCH] net:phy:dp83867: set up rgmii tx delay
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D0=BF=D1=82, 24 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 17:37, Florian Fain=
elli <f.fainelli@gmail.com>:
>
>
>
> On 5/24/2019 3:35 AM, Max Uvarov wrote:
> > PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
> > so code to set tx delay is never called.
> >
> > Signed-off-by: Max Uvarov <muvarov@gmail.com>
>
> Could you provide an appropriate Fixes: tag for this as well as fix the
> subject to be:
>
> net: phy: dp83867: Set up RGMII TX delay
>
> (sorry for being uber nitpicking on this)
>
> > ---
> >  drivers/net/phy/dp83867.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> > index 2984fd5ae495..5fed837665ea 100644
> > --- a/drivers/net/phy/dp83867.c
> > +++ b/drivers/net/phy/dp83867.c
> > @@ -251,10 +251,8 @@ static int dp83867_config_init(struct phy_device *=
phydev)
> >               ret =3D phy_write(phydev, MII_DP83867_PHYCTRL, val);
> >               if (ret)
> >                       return ret;
> > -     }
> >
>
> Is this hunk ^ intentional?
>

yes. Might be hard to see idea in patch without looking to the code.
But it just removes if bellow and puts the code to upper if stametent.
Which is if rgmii().
That is needed for connection type rgmi-txid which has actual setting bello=
w.

Max.

> > -     if ((phydev->interface >=3D PHY_INTERFACE_MODE_RGMII_ID) &&
> > -         (phydev->interface <=3D PHY_INTERFACE_MODE_RGMII_RXID)) {
> > +             /* Set up RGMII delays */
> >               val =3D phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGM=
IICTL);
> >
> >               if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
> >
>
> --
> Florian
