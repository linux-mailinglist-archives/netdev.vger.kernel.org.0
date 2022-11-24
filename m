Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25F5637B9C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiKXOn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiKXOn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:43:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5253EC09E
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:43:56 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDS3-0002Xe-I9; Thu, 24 Nov 2022 15:43:43 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5A9EC12865E;
        Thu, 24 Nov 2022 14:43:42 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:43:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     haibo.chen@nxp.com
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] arm64: dts: imx93: add flexcan nodes
Message-ID: <20221124144340.pxlnpvu3igl4fijo@pengutronix.de>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
 <1669116752-4260-3-git-send-email-haibo.chen@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bun327v46tx4wk6q"
Content-Disposition: inline
In-Reply-To: <1669116752-4260-3-git-send-email-haibo.chen@nxp.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bun327v46tx4wk6q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Shawn,

do you take this patch?

Marc

On 22.11.2022 19:32:32, haibo.chen@nxp.com wrote:
> From: Haibo Chen <haibo.chen@nxp.com>
>=20
> Add flexcan1 and flexcan2 nodes.
>=20
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
> ---
>  arch/arm64/boot/dts/freescale/imx93.dtsi | 28 ++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/d=
ts/freescale/imx93.dtsi
> index 5d79663b3b84..6808321ed809 100644
> --- a/arch/arm64/boot/dts/freescale/imx93.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
> @@ -223,6 +223,20 @@ lpuart2: serial@44390000 {
>  				status =3D "disabled";
>  			};
> =20
> +			flexcan1: can@443a0000 {
> +				compatible =3D "fsl,imx93-flexcan";
> +				reg =3D <0x443a0000 0x10000>;
> +				interrupts =3D <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks =3D <&clk IMX93_CLK_BUS_AON>,
> +					 <&clk IMX93_CLK_CAN1_GATE>;
> +				clock-names =3D "ipg", "per";
> +				assigned-clocks =3D <&clk IMX93_CLK_CAN1>;
> +				assigned-clock-parents =3D <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
> +				assigned-clock-rates =3D <40000000>;
> +				fsl,clk-source =3D /bits/ 8 <0>;
> +				status =3D "disabled";
> +			};
> +
>  			iomuxc: pinctrl@443c0000 {
>  				compatible =3D "fsl,imx93-iomuxc";
>  				reg =3D <0x443c0000 0x10000>;
> @@ -393,6 +407,20 @@ lpuart6: serial@425a0000 {
>  				status =3D "disabled";
>  			};
> =20
> +			flexcan2: can@425b0000 {
> +				compatible =3D "fsl,imx93-flexcan";
> +				reg =3D <0x425b0000 0x10000>;
> +				interrupts =3D <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks =3D <&clk IMX93_CLK_BUS_WAKEUP>,
> +					 <&clk IMX93_CLK_CAN2_GATE>;
> +				clock-names =3D "ipg", "per";
> +				assigned-clocks =3D <&clk IMX93_CLK_CAN2>;
> +				assigned-clock-parents =3D <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
> +				assigned-clock-rates =3D <40000000>;
> +				fsl,clk-source =3D /bits/ 8 <0>;
> +				status =3D "disabled";
> +			};
> +
>  			lpuart7: serial@42690000 {
>  				compatible =3D "fsl,imx93-lpuart", "fsl,imx7ulp-lpuart";
>  				reg =3D <0x42690000 0x1000>;
> --=20
> 2.34.1
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bun327v46tx4wk6q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/gxkACgkQrX5LkNig
012jpAf/Tl9GlAuWcLGh7nB/ddi7WxuR6tBSKZbkKApe5rmKuGQODe4jB8aDevD6
3cUSNHjhdAJLrTm+z99xGGr3/bxb4XqZQAUTRj1PYz/Pc82TC/aFglh99o+ixG/X
IkcsjSRQRvT6EmISzMCP5S3L031W6OgkpPNy6SeZSACqyc72x7ZjPdEGTZNutXcI
IG5yqJDljrm7ZyMBehv4miKVFbgdFlwOgRVsE1iQcw2UyNi7HGHcezWf0UQS/7Ht
+5NiruhiGx/gBY13fNKE1AzPwEN7BhPcgE+C2b7MIRxOxucKE+xKnYImk3Pu7hYJ
csl8iwEdREP5mtZv5A7fAu3fT4mdKg==
=g+gE
-----END PGP SIGNATURE-----

--bun327v46tx4wk6q--
