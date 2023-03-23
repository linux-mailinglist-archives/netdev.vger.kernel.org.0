Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E3E6C679F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjCWMG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjCWMGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:06:07 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950D310E0;
        Thu, 23 Mar 2023 05:04:55 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4576E1C0E49; Thu, 23 Mar 2023 13:04:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679573094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a/KoMv72J5IIz0NM8GNmcSDXPLFS3Vkv0wZ+gg3A9vc=;
        b=D3RWeS7ZzdCwgmaip0tK7qF1pk+0eq9crqm8wlRLN0VwU4ch5LoLGN9GkYiUKbHStOHQG5
        ip72ixYlxxhVXDeZWurv7JvDnzYRhY38H53HaSB392q1stZiSOrW5vqP4OKqBXNebHqlHi
        jS7wZujiZ36L/6mjm/7tRHZFq4pMD+4=
Date:   Thu, 23 Mar 2023 13:04:53 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <ZBxAZRcEBg4to132@duo.ucw.cz>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-16-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PW0UYIpUfo2k2zdg"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-16-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PW0UYIpUfo2k2zdg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Andrew Lunn <andrew@lunn.ch>
>=20
> The WAN port of the 370-RD has a Marvell PHY, with one LED on
> the front panel. List this LED in the device tree.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

> @@ -135,6 +136,19 @@ &mdio {
>  	pinctrl-names =3D "default";
>  	phy0: ethernet-phy@0 {
>  		reg =3D <0>;
> +		leds {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +
> +			led@0 {
> +				reg =3D <0>;
> +				label =3D "WAN";
> +				color =3D <LED_COLOR_ID_WHITE>;
> +				function =3D LED_FUNCTION_LAN;
> +				function-enumerator =3D <1>;
> +				linux,default-trigger =3D "netdev";
> +			};
> +		};
>  	};
> =20

How will this end up looking in sysfs? Should documentation be added
to Documentation/leds/leds-blinkm.rst ?

BR,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--PW0UYIpUfo2k2zdg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBxAZQAKCRAw5/Bqldv6
8pImAJ980SFJLWibENGuBRgkO7NwT1wjugCguwbshHgsV+9S/7u61KaJxx8XEEA=
=1SzX
-----END PGP SIGNATURE-----

--PW0UYIpUfo2k2zdg--
