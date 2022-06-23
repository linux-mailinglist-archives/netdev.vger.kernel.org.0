Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76EF5574C5
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiFWIDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiFWIDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:03:18 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF932C660;
        Thu, 23 Jun 2022 01:03:15 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4900FE0013;
        Thu, 23 Jun 2022 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655971394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3E94NbzYv5YlL11+dddbLmI84sUMgfXDsFCWy0L1tXs=;
        b=AHi+aMoCsCBw8opB/qYlKeOcOycTfdl7uPeeRAvZoClHs9kCpks4D2UOMlODssCVuIpH4p
        EouZl5a63YJz83m2vIR6vxcjhjRszM0ASx3w2FGRnkgNWSCwVebGe9d4X3G4YiJ+/aCxNc
        icIzo5fD2XXqnsk0rELF62cQjASXK9WFOO6fcVQMtBYocQiGIjeFW8JlntuqTTVyOdVvkh
        6q8mI9A5Dfj0F2XsUdbd+AMYHAha9QhwpnCMSqyKzZivYyn8o7mvZorc4pjK/0GzjE9OR5
        05MZb6C6E/Aep5tiwHVOiwCiGMVJuzr3sznCzXdFtJzO2UCTiK0hLpgqhO6vew==
Date:   Thu, 23 Jun 2022 10:02:21 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 15/16] ARM: dts: r9a06g032-rzn1d400-db: add
 switch description
Message-ID: <20220623100221.740de5c3@fixe.home>
In-Reply-To: <20220621115603.yzcxcu7gzwng6bcg@skbuf>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
        <20220620110846.374787-16-clement.leger@bootlin.com>
        <20220621115603.yzcxcu7gzwng6bcg@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 21 Jun 2022 14:56:03 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Mon, Jun 20, 2022 at 01:08:45PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add description for the switch, GMAC2 and MII converter. With these
> > definitions, the switch port 0 and 1 (MII port 5 and 4) are working on
> > RZ/N1D-DB board.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > --- =20
>=20
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>=20
> Just minor comments below:
>=20
> >  arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts | 117 ++++++++++++++++++++
> >  1 file changed, 117 insertions(+)
> >=20
> > diff --git a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts b/arch/arm/boo=
t/dts/r9a06g032-rzn1d400-db.dts
> > index 3f8f3ce87e12..36b898d9f115 100644
> > --- a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> > +++ b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> > @@ -8,6 +8,8 @@
> > =20
> >  /dts-v1/;
> > =20
> > +#include <dt-bindings/pinctrl/rzn1-pinctrl.h>
> > +#include <dt-bindings/net/pcs-rzn1-miic.h>
> >  #include "r9a06g032.dtsi"
> > =20
> >  / {
> > @@ -31,3 +33,118 @@ &wdt0 {
> >  	timeout-sec =3D <60>;
> >  	status =3D "okay";
> >  };
> > +
> > +&gmac2 {
> > +	status =3D "okay";
> > +	phy-mode =3D "gmii";
> > +	fixed-link {
> > +		speed =3D <1000>;
> > +		full-duplex;
> > +	};
> > +};
> > +
> > +&switch {
> > +	status =3D "okay";
> > +	#address-cells =3D <1>;
> > +	#size-cells =3D <0>;
> > +
> > +	pinctrl-names =3D "default";
> > +	pinctrl-0 =3D <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;
> > +
> > +	dsa,member =3D <0 0>; =20
>=20
> This doesn't really have any value for single-switch DSA trees, since
> that is the implicit tree id/switch id, but it doesn't hurt, either.

Ok, let's remove it then if it's useless.

>=20
> > +
> > +	mdio {
> > +		clock-frequency =3D <2500000>;
> > +
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <0>;
> > +
> > +		switch0phy4: ethernet-phy@4{ =20
>=20
> Space between ethernet-phy@4 and {.
>=20
> > +			reg =3D <4>;
> > +			micrel,led-mode =3D <1>;
> > +		};
> > +
> > +		switch0phy5: ethernet-phy@5{ =20
>=20
> Same thing here.

Acked

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
