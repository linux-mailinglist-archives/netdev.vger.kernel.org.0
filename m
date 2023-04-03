Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347E36D51A0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjDCTyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjDCTyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:54:13 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A161FDA;
        Mon,  3 Apr 2023 12:54:12 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DD0D41C0DFD; Mon,  3 Apr 2023 21:54:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1680551650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fykVoMCfV1nx33PPt8DE784tGv/X2NEpQvm7pJbRM6M=;
        b=juEewWzjR/oFjcMcyhikVgpbth86/4CzY4LjhmZYOiqcJ+5Be4T+2WDJeJBSHO4bPavBvk
        y+/DQog1H9zekTEiK2kzTiGyfrFiYFlzRITJwZC49aSofJp8dLsv0R37DWITFhzFJJaEu5
        npoFwNyjVcf2waVYeKGbQdTBYGtyeoY=
Date:   Mon, 3 Apr 2023 21:54:10 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <ZCsu4qD8k947kN7v@duo.ucw.cz>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
 <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
 <2e5c6dfb-5f55-416f-a934-6fa3997783b7@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lPaKBUJ34nC7zHk1"
Content-Disposition: inline
In-Reply-To: <2e5c6dfb-5f55-416f-a934-6fa3997783b7@lunn.ch>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lPaKBUJ34nC7zHk1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The WAN port of the 370-RD has a Marvell PHY, with one LED on
> > > the front panel. List this LED in the device tree.
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
> >=20
> > /sys/class/leds/WAN is not acceptable.
>=20
> As i said here, that is not what it gets called:
>=20
> https://lore.kernel.org/netdev/aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.=
ch/T/#m6c72bd355df3fcf8babc0d01dd6bf2697d069407
>=20
> > It can be found in /sys/class/leds/f1072004.mdio-mii:00:WAN. But when
> > we come to using it for ledtrig-netdev, the user is more likely to foll=
ow
> > /sys/class/net/eth0/phydev/leds/f1072004.mdio-mii\:00\:WAN/
>=20
> Is that acceptable?
>=20
> What are the acceptance criteria?

Acceptance criteria would be "consistent with documentation and with
other similar users". If the LED is really white, it should be
f1072004.mdio-mii\:white\:WAN, but you probably want
f1072004.mdio-mii\:white\:LAN (or :activity), as discussed elsewhere in the=
 thread.

Documentation is in Documentation/leds/well-known-leds.txt , so you
should probably add a new section about networking, and explain naming
scheme for network activity LEDs. When next users appear, I'll point
them to the documentation.

Does that sound ok?

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--lPaKBUJ34nC7zHk1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCsu4gAKCRAw5/Bqldv6
8h78AJ9AUnGfeFk8XU7IuIMt4pYID4EtCACgncPOn1FIVY/7WnPw/CXAoZkbNu0=
=zXBp
-----END PGP SIGNATURE-----

--lPaKBUJ34nC7zHk1--
