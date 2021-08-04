Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796843DFC62
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhHDH7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbhHDH72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 03:59:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D11C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 00:59:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBBnq-0002Ia-J2; Wed, 04 Aug 2021 09:59:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 347056605ED;
        Wed,  4 Aug 2021 07:58:57 +0000 (UTC)
Date:   Wed, 4 Aug 2021 09:58:55 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v4 3/3] arm64: dts: renesas: r9a07g044: Add CANFD node
Message-ID: <20210804075855.2vjvfb67kufiibqx@pengutronix.de>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ze4ynsr3mhucbku3"
Content-Disposition: inline
In-Reply-To: <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ze4ynsr3mhucbku3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.07.2021 14:30:22, Lad Prabhakar wrote:
> Add CANFD node to R9A07G044 (RZ/G2L) SoC DTSI.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot=
/dts/renesas/r9a07g044.dtsi
> index 9a7489dc70d1..51655c09f1f8 100644
> --- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> @@ -13,6 +13,13 @@
>  	#address-cells =3D <2>;
>  	#size-cells =3D <2>;
> =20
> +	/* External CAN clock - to be overridden by boards that provide it */
> +	can_clk: can {
> +		compatible =3D "fixed-clock";
> +		#clock-cells =3D <0>;
> +		clock-frequency =3D <0>;
> +	};
> +
>  	/* clock can be either from exclk or crystal oscillator (XIN/XOUT) */
>  	extal_clk: extal {
>  		compatible =3D "fixed-clock";
> @@ -89,6 +96,40 @@
>  			status =3D "disabled";
>  		};
> =20
> +		canfd: can@10050000 {
> +			compatible =3D "renesas,r9a07g044-canfd", "renesas,rzg2l-canfd";
> +			reg =3D <0 0x10050000 0 0x8000>;
> +			interrupts =3D <GIC_SPI 426 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 427 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 428 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 429 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-names =3D "g_err", "g_recc",
> +					  "ch0_err", "ch0_rec", "ch0_trx",
> +					  "ch1_err", "ch1_rec", "ch1_trx";
> +			clocks =3D <&cpg CPG_MOD R9A07G044_CANFD_PCLK>,
> +				 <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>,
> +				 <&can_clk>;
> +			clock-names =3D "fck", "canfd", "can_clk";
> +			assigned-clocks =3D <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>;
> +			assigned-clock-rates =3D <50000000>;
> +			resets =3D <&cpg R9A07G044_CANFD_RSTP_N>,
> +				 <&cpg R9A07G044_CANFD_RSTC_N>;
> +			reset-names =3D "rstp_n", "rstc_n";
> +			power-domains =3D <&cpg>;
> +			status =3D "disabled";
> +
> +			channel0 {
> +				status =3D "disabled";
> +			};
> +			channel1 {
> +				status =3D "disabled";
> +			};
> +		};
> +
>  		i2c0: i2c@10058000 {
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;

This doesn't apply to net-next/master, the r9a07g044.dtsi doesn't have a
i2c0 node at all. There isn't a i2c0 node in Linus' master branch, yet.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ze4ynsr3mhucbku3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKSLwACgkQqclaivrt
76kwigf/Q3643nBF+tEaWkQKOY+e+2zNCqq8EEB0xZM/x6lVE3TVQnt/TGWl+5sK
QI3WuAC41jnIVEKYDVv6ZdcqIMOFR6c7baygWW/VpL2hIhhJ9pWwJZPgsZnL38o9
c32rg8mkSrhZCmuVRDLJi/PQiV/t8CV+h2LMwYoNE+dOSqq5rBk6MUWZbxanTyCU
+x0T5k0NmcN6ewN+/azYNX9Wg1+J3f4sVcjEw5fuejPyhs1nsz59S97smT5Pp0KO
cD26J88VlNzIeLAuXnqZXZRdprKeDpIrpK0gp+r8Kcjh6/Tu2Oxnr7W0+WxWmFIa
yjVUQ1jg06lS7QpCBmR5QiRtKveqnQ==
=uMmw
-----END PGP SIGNATURE-----

--ze4ynsr3mhucbku3--
