Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F47E52E7A8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbiETIeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347463AbiETIdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:33:45 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A83A158948;
        Fri, 20 May 2022 01:33:08 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A58A124001C;
        Fri, 20 May 2022 08:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653035587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8uycxO5fJimk0zTNVtpGUm4BdARppNdHxB7/Xtb6ANM=;
        b=gPStD7GoQ1fffRcB8mNyIeGO4ElBHqlR+svkzdvU8QApZyJqS1PVnyFh7PeqBwiNpTMn7d
        ouuZxIXXLukQpNS3trpXZDxz6MQ501jIhKFYwZo0rTAn5UOvzx4Q5v3EVmZEJ4uNF0s8ny
        y2Cqj5hCfUaR8PeKkFvkLiXfXw2WYRb3OZW2Ce0gsEfHAQljuQC+1tdNhrWYhkWq/EvkGf
        3BAFdvPdRW+rvd0Koff9tM6D9NW16Xt59P4VFnjBltmgINsAdWDqq9fyjB1sCD6RLOX6tp
        v5jAShkIh6yeXsnvBHrQ5aphV3gIMPONSezL3gjvsSw3mf+mLTXJFpzN13yPDQ==
Date:   Fri, 20 May 2022 10:31:52 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5 11/13] ARM: dts: r9a06g032: describe GMAC2
Message-ID: <20220520103152.48f7b178@fixe.home>
In-Reply-To: <CAMuHMdXTrZnGVt44hg5QUvuS5cZABmRncgNYtatkmk8VcH7gew@mail.gmail.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-12-clement.leger@bootlin.com>
        <CAMuHMdUJpNSyX0qK64+W1G6P1S-78mb_+D0-w3kHOFY3VVkANQ@mail.gmail.com>
        <20220520101332.0905739f@fixe.home>
        <CAMuHMdXTrZnGVt44hg5QUvuS5cZABmRncgNYtatkmk8VcH7gew@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 20 May 2022 10:25:37 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Fri, May 20, 2022 at 10:14 AM Cl=C3=A9ment L=C3=A9ger
> <clement.leger@bootlin.com> wrote:
> > Le Fri, 20 May 2022 09:18:58 +0200,
> > Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit : =20
> > > On Thu, May 19, 2022 at 5:32 PM Cl=C3=A9ment L=C3=A9ger <clement.lege=
r@bootlin.com> wrote: =20
> > > > RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> > > > "snps,dwmac" driver. GMAC1 is connected directly to the MII convert=
er
> > > > port 1. GMAC2 however can be used as the MAC for the switch CPU
> > > > management port or can be muxed to be connected directly to the MII
> > > > converter port 2. This commit add description for the GMAC2 which w=
ill
> > > > be used by the switch description.
> > > >
> > > > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> =
=20
>=20
> > > > --- a/arch/arm/boot/dts/r9a06g032.dtsi
> > > > +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> > > > @@ -200,6 +200,23 @@ nand_controller: nand-controller@40102000 {
> > > >                         status =3D "disabled";
> > > >                 };
> > > >
> > > > +               gmac2: ethernet@44002000 {
> > > > +                       compatible =3D "snps,dwmac"; =20
> > >
> > > Does this need an SoC-specific compatible value? =20
> >
> > Indeed, it might be useful to introduce a specific SoC compatible since
> > in a near future, there might be some specific support for that gmac.
> > Here is an overview of the gmac connection on the SoC:
> >
> >                                           =E2=94=8C=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90   =
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=90
> >                                           =E2=94=82         =E2=94=82  =
 =E2=94=82          =E2=94=82
> >                                           =E2=94=82  GMAC2  =E2=94=82  =
 =E2=94=82  GMAC1   =E2=94=82
> >                                           =E2=94=82         =E2=94=82  =
 =E2=94=82          =E2=94=82
> >                                           =E2=94=94=E2=94=80=E2=94=80=
=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98   =
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=98
> >                                               =E2=94=82               =
=E2=94=82
> >                                               =E2=94=82               =
=E2=94=82
> >                                               =E2=94=82               =
=E2=94=82
> >                                          =E2=94=8C=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=90        =E2=94=82
> >                                          =E2=94=82           =E2=94=82 =
       =E2=94=82
> >             =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4  SWITCH   =
=E2=94=82        =E2=94=82
> >             =E2=94=82                            =E2=94=82           =
=E2=94=82        =E2=94=82
> >             =E2=94=82          =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=AC=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98        =E2=94=82
> >             =E2=94=82          =E2=94=82            =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98    =E2=94=82        =
     =E2=94=82
> >             =E2=94=82          =E2=94=82            =E2=94=82          =
 =E2=94=82             =E2=94=82
> >        =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >        =E2=94=82                      MII Converter                    =
    =E2=94=82
> >        =E2=94=82                                                       =
    =E2=94=82
> >        =E2=94=82                                                       =
    =E2=94=82
> >        =E2=94=82 port 1      port 2       port 3      port 4       port=
 5  =E2=94=82
> >        =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >
> > As you can see, the GMAC1 is directly connected to MIIC converter and
> > thus will need a "pcs-handle" property to point on the MII converter
> > port whereas the GMAC2 is directly connected to the switch in GMII.
> >
> > Is "renesas,r9a06g032-gmac2", "renesas,rzn1-switch-gmac2" looks ok
> > for you for this one ? =20
>=20
> Why "switch" in the family-specific value, but not in the SoC-specific
> value?

That's a typo, switch should be removed.

>=20
> Are GMAC1 and GMAC2 really different, or are they identical, and is
> the only difference in the wiring, which can be detected at run-time
> using this "pcs-handle" property? If they're identical, they should
> use the same compatible value.

They are actually identical except the requirement for a "pcs-handle"
for gmac1. I thought about using different compatible to enforce this by
making it "required" with the "renesas,r9a06g032-gmac1" compatible but
not the "renesas,r9a06g032-gmac2" one. If it's ok for you to let it
optional and use a single compatible, I'm ok with that !


Thanks !

>=20
> Thanks!
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
