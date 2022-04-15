Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D66502C0E
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354598AbiDOOnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354712AbiDOOm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:42:58 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF213700F;
        Fri, 15 Apr 2022 07:40:24 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 974ECE000B;
        Fri, 15 Apr 2022 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650033622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zanZazVS+F6yO9Vb+0jek4QpQxEnTAcQmwRfYFhBd+k=;
        b=XvjgWF12omvcB0S9wdZocsVRAM1fWYoHiR3MF0fsHo3P2MRQFyfstVNy00SFVoUnaYfNn5
        DHTXUF6jawn9JnEU+1oqAbtBVncahboURiQbPA8my6MYgJfBtZa7dJYGANrQGdr2VlYBUO
        h6jCzl9nA6Oc98wTw2G+Nthu3s1C5LycIA7OUXethKZt4aeXqiQzdpThwIS3Giy5cuXfJW
        7fgNfwBtv3eQ3VWNQqBJe43/w+CMLSJuooTGyXCGiaStd+/42BLmNRw5wWflmuNrJUnDS7
        IXLGtSXkRqiUo9FnvBUtdVr8XG8qvaPy51ebNxVCCOqaHDI+dbpqhktihqA2oA==
Date:   Fri, 15 Apr 2022 16:38:53 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <20220415163853.683c0b6d@fixe.home>
In-Reply-To: <Yll+Tpnwo5410B9H@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-10-clement.leger@bootlin.com>
        <YlismVi8y3Vf6PZ0@lunn.ch>
        <20220415102453.1b5b3f77@fixe.home>
        <Yll+Tpnwo5410B9H@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
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

Le Fri, 15 Apr 2022 16:16:46 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> On Fri, Apr 15, 2022 at 10:24:53AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Fri, 15 Apr 2022 01:22:01 +0200,
> > Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :
> >  =20
> > > On Thu, Apr 14, 2022 at 02:22:47PM +0200, Cl=C3=A9ment L=C3=A9ger wro=
te: =20
> > > > Add the MII converter node which describes the MII converter that is
> > > > present on the RZ/N1 SoC.   =20
> > >=20
> > > Do you have a board which actually uses this? I just noticed that
> > > renesas,miic-cfg-mode is missing, it is a required property, but maybe
> > > the board .dts file provides it?
> > >=20
> > >     Andrew =20
> >=20
> > Hi Andrew, yes, I have a board that defines and use that. =20
>=20
> Great. Do you plan to mainline it? It is always nice to see a user.

Although we are working on a specific customer board, we will probably
try to mailine this support for the RZ/N1D-DB.

>=20
> > The
> > renesas,miic-cfg-mode actually configures the muxes that are present on
> > the SoC. They allows to mux the various ethernet components (Sercos
> > Controller, HSR Controller, Ethercat, GMAC1, RTOS-GMAC).
> > All these muxes are actually controller by a single register
> > CONVCTRL_MODE. You can actually see the muxes that are present in the
> > manual [1] at Section 8 and the CONVCTRL_MODE possible values are listed
> > on page 180.
> >=20
> > This seems to be something that is board dependent because the muxing
> > controls the MII converter outputs which depends on the board layout. =
=20
>=20
> Does it also mux the MDIO lines as well?

Nope, the MDIO lines are muxed using the pinctrl driver.

>=20
> We might want to consider the name 'mux'. Linux already has the
> concept of a mux, e.g. an MDIO mux, and i2c mux etc. These muxes have
> one master device, which with the aid of the mux you can connect to
> multiple busses. And at runtime you flip the mux as needed to access
> the devices on the multiple slave busses. For MDIO you typically see
> this when you have multiple Ethernet switch, each has its own slave
> MDIO bus, and you use the mux to connect the single SOC MDIO bus
> master to the various slave busses as needed to perform a bus
> transaction. I2C is similar, you can have multiple SFPs, either with
> there own IC2 bus, connected via a mux to a single I2C bus controller
> on the SoC.
>=20
> I've not looked at the data sheet yet, but it sounds like it operates
> in a different way, so we might want to avoid 'mux'.

Indeed, Let's not refer to it as mux in the code at all. If using your
proposal below, I guess we could avoid that.

>=20
> > I'm open to any modification for this setup which does not really fit
> > any abstraction that I may have seen.
> >=20
> > [1]
> > https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1=
l-group-users-manual-system-introduction-multiplexing-electrical-and =20
>=20
> O.K, looking at figure 8.1.
>=20
> What the user wants to express is something like:
>=20
> Connect MI_CONV5 to SECOS PORTA
> Connect MI_CONV4 to ETHCAT PORTB
> Connect MI_CONV3 to SWITCH PORTC
> Connect MI_CONV2 to SWITCH PORTD
>=20
> plus maybe
>=20
> Connect SWITCH PORTIN to RTOS

Yes, that is correct.

>=20
> So i guess i would express the DT bindings like this, 5 values, and
> let the driver then try to figure out the value you need to put in the
> register, or return -EINVAL. For DT bindings we try to avoid magic
> values which get written into registers. We prefer a higher level
> description, and then let the driver figure out how to actually
> implement that.

Ok, looks like a more flexible way to doing it. Let's go with something
like this:

renesas,miic-port-connection =3D <PORTIN_GMAC2>, <MAC2>, <SWITCH_PORTC>,
<SWITCH_PORTB>, <SWITCH_PORTA>;





--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
