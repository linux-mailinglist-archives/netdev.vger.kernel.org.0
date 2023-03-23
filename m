Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861186C70CF
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCWTLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCWTLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:11:03 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D37171C;
        Thu, 23 Mar 2023 12:11:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6FE291C0E45; Thu, 23 Mar 2023 20:11:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679598660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aRHbTBB+ZgSTv8KzTFw1avZ2sf6wVSfYjmXj3OLadfU=;
        b=WUsbZMTdi1dQlK/4H3Xv9ArPjsuIMUxpSFwGMub4AZtfoYc0oMVOCdkbQ2YjKggzu6dMB1
        8/6ydNZJvXxECORDcGhsUhgc71YQX105BVUfg1favqDeOxxfizoj39rK55mpyM+ncRrurM
        7AuueYcYPNp8XcC2R2Lb0NBjGgM+2GI=
Date:   Thu, 23 Mar 2023 20:11:00 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Lee Jones <lee@kernel.org>, John Crispin <john@phrozen.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 15/15] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <ZBykRJmkxF7zf8g8@duo.ucw.cz>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-16-ansuelsmth@gmail.com>
 <ZBxAZRcEBg4to132@duo.ucw.cz>
 <318f65ef-fd63-446d-bd08-1ba51b1d1f72@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rI4G7utm2RBg+ik3"
Content-Disposition: inline
In-Reply-To: <318f65ef-fd63-446d-bd08-1ba51b1d1f72@lunn.ch>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rI4G7utm2RBg+ik3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The WAN port of the 370-RD has a Marvell PHY, with one LED on
> > > the front panel. List this LED in the device tree.
> > >=20
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> >=20
> > > @@ -135,6 +136,19 @@ &mdio {
> > >  	pinctrl-names =3D "default";
> > >  	phy0: ethernet-phy@0 {
> > >  		reg =3D <0>;
> > > +		leds {
> > > +			#address-cells =3D <1>;
> > > +			#size-cells =3D <0>;
> > > +
> > > +			led@0 {
> > > +				reg =3D <0>;
> > > +				label =3D "WAN";
> > > +				color =3D <LED_COLOR_ID_WHITE>;
> > > +				function =3D LED_FUNCTION_LAN;
> > > +				function-enumerator =3D <1>;
> > > +				linux,default-trigger =3D "netdev";
> > > +			};
> > > +		};
> > >  	};
> > > =20
> >=20
> > How will this end up looking in sysfs?
>=20
> Hi Pavel
>=20
> It is just a plain boring LED, so it will look like all other LEDs.
> There is nothing special here.

Well, AFAICT it will end up as /sys/class/leds/WAN, which is really
not what we want. (Plus the netdev trigger should be tested; we'll
need some kind of link to the ethernet device if we want this to work
on multi-ethernet systems).

> > Should documentation be added to Documentation/leds/leds-blinkm.rst
> >  ?
>=20
> This has nothing to do with blinkm, which appears to be an i2c LED
> driver.

Sorry, I meant

Should documentation be added to Documentation/leds/well-known-leds.txt ?

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--rI4G7utm2RBg+ik3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBykRAAKCRAw5/Bqldv6
8hYAAJ9Bvn10XxUIr7aK5MpezU9ojjLFBQCdGvLFTqwn12xC4aE58YdyoLAftHM=
=uXc6
-----END PGP SIGNATURE-----

--rI4G7utm2RBg+ik3--
