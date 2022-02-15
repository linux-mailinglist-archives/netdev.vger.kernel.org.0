Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7546A4B6591
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiBOINW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:13:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiBOINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:13:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C1EE0E0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:13:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nJsx3-0003M9-1W; Tue, 15 Feb 2022 09:12:45 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 908F233846;
        Tue, 15 Feb 2022 08:12:43 +0000 (UTC)
Date:   Tue, 15 Feb 2022 09:12:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 5/8] ARM: dts: exynos: fix ethernet node name for
 different odroid boards
Message-ID: <20220215081240.hhie4niqnc5tuka2@pengutronix.de>
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
 <20220215080937.2263111-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ruaa4qutvikg7brg"
Content-Disposition: inline
In-Reply-To: <20220215080937.2263111-5-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ruaa4qutvikg7brg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.02.2022 09:09:34, Oleksij Rempel wrote:
> The node name of Ethernet controller should be "ethernet" instead of
> "usbether"
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  arch/arm/boot/dts/exynos4412-odroidu3.dts       | 4 ++--
>  arch/arm/boot/dts/exynos4412-odroidx.dts        | 8 ++++----
>  arch/arm/boot/dts/exynos5410-odroidxu.dts       | 4 ++--
>  arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts | 6 +++---
>  arch/arm/boot/dts/exynos5422-odroidxu3.dts      | 6 +++---
>  5 files changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dt=
s/exynos4412-odroidu3.dts
> index efaf7533e84f..36c369c42b77 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> @@ -119,8 +119,8 @@ &ehci {
>  	phys =3D <&exynos_usbphy 2>, <&exynos_usbphy 3>;
>  	phy-names =3D "hsic0", "hsic1";
> =20
> -	ethernet: usbether@2 {
> -		compatible =3D "usb0424,9730";
> +	ethernet: ethernet@2 {
> +		compatible =3D "usb424,9730";

The change of the compatible is not mentioned in the patch description.
Is this intentional?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ruaa4qutvikg7brg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmILYHUACgkQrX5LkNig
011yBQf/fenmunl2JTABeDMwlX/3g+MNPH3XDVUcmYfSGIjN/yUYavmljQFDoLrw
JFsE8C8xbz8NmuVZ1/6ROJS2FDV48/AsVgVw8hAYLDIny6nSpbjGDBRKO9GD05Jb
QysbLbwcuwnh8TSZqtLLh0kplaC7SRCVSvvA6vxdSNzc+cyNDgTrYOQ0tvxEXSmv
Fh6kfuM8hKXWD0CgZrYGp4I/1UW2ojeSihGhf6F9lOgJ9cR5v+cR7/TfRviRGhqU
TXVG2xqgdBtYN4FCR8dU+ZNLmEzz6Q77mGmYXr7JZicaXr6cgqYMxMIG7p0UoiF+
M++Hxo4s8U/JkrvGcFGRuIZBnnjkGw==
=hKqu
-----END PGP SIGNATURE-----

--ruaa4qutvikg7brg--
