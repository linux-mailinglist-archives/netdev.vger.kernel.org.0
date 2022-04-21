Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF01509952
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386025AbiDUHlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386033AbiDUHku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:40:50 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11541BEA0;
        Thu, 21 Apr 2022 00:37:08 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1BFF820012;
        Thu, 21 Apr 2022 07:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650526627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RGnL/qa/9bwpFzOONLpfFYP0rdX9DCvtXtmdg/3Ctco=;
        b=B0aK3onfXdqaP9TjuNhMnUT++Q+y62usbE8O3v3/R+VPEB91z0yeoarC0d5aM1iRY7kceG
        SPe+Orej5rEnmmJuMv7trHjSogkJ3cZ6Sm8c/3w/XbgiRPdTPYUFXXz8zM0e6DB1/kctOI
        76OvnV7CV5iLrtgxUMhLMc/XOb51LkevJxPezLpCNyWx29WhdmdWXhHF4uN3YNl1aJ8q9a
        bhFi8FCPyAIgiUOga5X46yg8kD5zv2S6a7R6kBimbGe48yEPgj4FnFFzj34SQiFn2QoE6t
        5/fppHM9PIiHlEkaHSFgYYF/uXVnXa6z3N0SyFDyon/8tmtebblAoivLMZaiNQ==
Date:   Thu, 21 Apr 2022 09:35:42 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Subject: Re: [PATCH net-next 03/12] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
Message-ID: <20220421093542.6fe50195@fixe.home>
In-Reply-To: <YmBo7sj+PXoJaqo8@robh.at.kernel.org>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-4-clement.leger@bootlin.com>
        <Yl68k22fUw7uBgV9@robh.at.kernel.org>
        <20220419170044.450050ca@fixe.home>
        <YmBo7sj+PXoJaqo8@robh.at.kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 20 Apr 2022 15:11:26 -0500,
Rob Herring <robh@kernel.org> a =C3=A9crit :

> On Tue, Apr 19, 2022 at 05:00:44PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Tue, 19 Apr 2022 08:43:47 -0500,
> > Rob Herring <robh@kernel.org> a =C3=A9crit :
> >  =20
> > > > +  clocks:
> > > > +    items:
> > > > +      - description: MII reference clock
> > > > +      - description: RGMII reference clock
> > > > +      - description: RMII reference clock
> > > > +      - description: AHB clock used for the MII converter register=
 interface
> > > > +
> > > > +  renesas,miic-cfg-mode:
> > > > +    description: MII mux configuration mode. This value should use=
 one of the
> > > > +                 value defined in dt-bindings/net/pcs-rzn1-miic.h.=
   =20
> > >=20
> > > Describe possible values here as constraints. At present, I don't see=
=20
> > > the point of this property if there is only 1 possible value and it i=
s=20
> > > required. =20
> >=20
> > The ethernet subsystem contains a number of internal muxes that allows
> > to configure ethernet routing. This configuration option allows to set
> > the register that configure these muxes.
> >=20
> > After talking with Andrew, I considered moving to something like this:
> >=20
> > eth-miic@44030000 {
> >   compatible =3D "renesas,rzn1-miic";
> >=20
> >   mii_conv1: mii-conv-1 {
> >     renesas,miic-input =3D <MIIC_GMAC1_PORT>;
> >     port =3D <1>; =20
>=20
> 'port' is already used, find another name. Maybe 'reg' here. Don't know.=
=20
> What do 1 and 2 represent?

'port' represent the port index in the MII converter IP. I went with reg
first, but according to Andrew feedback, it looked like it was a bad
idea since it was not really a "bus".  However, this pattern is already
used for dsa ports.

> > >=20
> > > Why do you need sub-nodes? They don't have any properties. A simple m=
ask=20
> > > property could tell you which ports are present/active/enabled if tha=
t's=20
> > > what you are tracking. Or the SoC specific compatibles you need to ad=
d=20
> > > can imply the ports if they are SoC specific. =20
> >=20
> > The MACs are using phandles to these sub-nodes to query a specific MII
> > converter port PCS:
> >=20
> > switch@44050000 {
> >     compatible =3D "renesas,rzn1-a5psw";
> >=20
> >     ports {
> >         port@0 { =20
>=20
> ethernet-ports and ethernet-port so we don't collide with the graph=20
> binding.

Acked.

>=20
>=20
> >             reg =3D <0>;
> >             label =3D "lan0";
> >             phy-handle =3D <&switch0phy3>;
> >             pcs-handle =3D <&mii_conv4>;
> >         };
> >     };
> > };
> >=20
> > According to Andrew, this is not a good idea to represent the PCS as a
> > bus since it is indeed not a bus. I could also switch to something like
> > pcs-handle =3D <&eth_mii 4> but i'm not sure what you'd prefer. We could
> > also remove this from the device-tree and consider each driver to
> > request the MII ouput to be configured using something like this for
> > instance: =20
>=20
> I'm pretty sure we already defined pcs-handle as only a phandle. If you=20
> want variable cells, then it's got to be extended like all the other=20
> properties using that pattern.

Yep, it seems to be used in some other driver as a single phandle too.
I'll kept that.

>=20
> >=20
> >  miic_request_pcs(pcs_np, miic_port_nr, MIIC_SWITCHD_PORT);
> >=20
> > But I'm not really fan of this because it requires the drivers to
> > assume some specificities of the MII converter (port number are not in
> > the same order of the switch for instance) and thus I would prefer this
> > to be in the device-tree.
> >=20
> > Let me know if you can think of something that would suit you
> > better but  keep in mind that I need to correctly match a switch/MAC
> > port with a PCS port and that I also need to configure MII internal
> > muxes.=20
> >=20
> > For more information, you can look at section 8 of the manual at [1]. =
=20
>=20
> I can't really. Other people want their bindings reviewed too.

No worries.

>=20
> Rob



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
