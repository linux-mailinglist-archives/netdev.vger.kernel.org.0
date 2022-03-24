Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFFF4E6228
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349684AbiCXLMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349686AbiCXLMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:12:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E80A5EB4
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:11:22 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nXLMx-00053I-B5; Thu, 24 Mar 2022 12:11:07 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nXLMs-002gI2-DH; Thu, 24 Mar 2022 12:11:05 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nXLMu-00BKEP-DC; Thu, 24 Mar 2022 12:11:04 +0100
Date:   Thu, 24 Mar 2022 12:11:04 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     ulf.hansson@linaro.org, robh+dt@kernel.org, krzk+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, qiangqing.zhang@nxp.com,
        devicetree@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        netdev@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] dt-bindings: imx: add nvmem property
Message-ID: <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wgkvs6aazjig7tcg"
Content-Disposition: inline
In-Reply-To: <20220324042024.26813-1-peng.fan@oss.nxp.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
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


--wgkvs6aazjig7tcg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, Mar 24, 2022 at 12:20:20PM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
>=20
> To i.MX SoC, there are many variants, such as i.MX8M Plus which
> feature 4 A53, GPU, VPU, SDHC, FLEXCAN, FEC, eQOS and etc.
> But i.MX8M Plus has many parts, one part may not have FLEXCAN,
> the other part may not have eQOS or GPU.
> But we use one device tree to support i.MX8MP including its parts,
> then we need update device tree to mark the disabled IP status "disabled".
>=20
> In NXP U-Boot, we hardcoded node path and runtime update device tree
> status in U-Boot according to fuse value. But this method is not
> scalable and need encoding all the node paths that needs check.
>=20
> By introducing nvmem property for each node that needs runtime update
> status property accoridng fuse value, we could use one Bootloader
> code piece to support all i.MX SoCs.
>=20
> The drawback is we need nvmem property for all the nodes which maybe
> fused out.

I'd rather not have that in an official binding as the syntax is
orthogonal to status =3D "..." but the semantic isn't. Also if we want
something like that, I'd rather not want to adapt all bindings, but
would like to see this being generic enough to be described in a single
catch-all binding.

I also wonder if it would be nicer to abstract that as something like:

	/ {
		fuse-info {
			compatible =3D "otp-fuse-info";

			flexcan {
				devices =3D <&flexcan1>, <&flexcan2>;
				nvmem-cells =3D <&flexcan_disabled>;
				nvmem-cell-names =3D "disabled";
			};

			m7 {
				....
			};
		};
	};

as then the driver evaluating this wouldn't need to iterate over the
whole dtb but just over this node. But I'd still keep this private to
the bootloader and not describe it in the generic binding.

Just my 0.02=E2=82=AC
Uwe

--wgkvs6aazjig7tcg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmI8UcQACgkQwfwUeK3K
7Am9+Af/TL19J0ba7ItLW+bNEISHsBaSaOLd2ifYXQclP0TkgvgsPpvr+ZFan0HB
W2lomfRdTS4NSas5aNAopvU1h+NkDot8iQAK65FIFAaSPqVZ5NTACag7zjN2wxKh
Op2qcQycHc8n6kOZsVI7hBLTPpPST3L53MHRzwiZ2CTuRdfp/f/ISmhEJ0nyijyv
+qE21d99fSrCBh6tXBCqbQCwbIBq6ujU07fkO3EXapDrYsskghCRmtcPcnV0bD93
UiKvwg5+UAFezAiGM9WFXQD61b2PJ/t+PkjR1sra0jOFdA58YKKh98uZN7yIuZ2q
nANoUKO0g3cpTR0HxCu8yvaa6luAhw==
=VM/f
-----END PGP SIGNATURE-----

--wgkvs6aazjig7tcg--
