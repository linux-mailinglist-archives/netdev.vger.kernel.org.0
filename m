Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097213C9B30
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhGOJPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 05:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhGOJPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 05:15:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A543DC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 02:12:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m3xPe-0002vP-4a; Thu, 15 Jul 2021 11:12:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:968e:ea40:4726:28f1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 14EBA64FD1A;
        Thu, 15 Jul 2021 09:12:08 +0000 (UTC)
Date:   Thu, 15 Jul 2021 11:12:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dong Aisheng <aisheng.dong@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-imx@nxp.com, kernel@pengutronix.de, dongas86@gmail.com,
        robh+dt@kernel.org, shawnguo@kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Message-ID: <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wmxjb5ivzs2k5a7d"
Content-Disposition: inline
In-Reply-To: <20210715082536.1882077-2-aisheng.dong@nxp.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wmxjb5ivzs2k5a7d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.07.2021 16:25:30, Dong Aisheng wrote:
> This patch fixes the following errors during make dtbs_check:
> arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml: can@308c0000: compatibl=
e: 'oneOf' conditional failed, one must be fixed:
> 	['fsl,imx8mp-flexcan', 'fsl,imx6q-flexcan'] is too long

IIRC the fsl,imx6q-flexcan binding doesn't work on the imx8mp. Maybe
better change the dtsi?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wmxjb5ivzs2k5a7d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDv++QACgkQqclaivrt
76lkpAf+NgsqEVY19xmRYoc424kQpm//J2pvhFCtpyRwHSzPGX6rrq2Betpq5yqb
EWpxnE0qP7Lr1nLJu+WUN4GJUA94UU+F83QpqQUMxSaWcqTZHyewqEqG5KJpJeCf
n+O+D3DIv4bnAC0A372LVSd2q+nfhMaL+zMphkmwlxlZPDxrHsauwWu3OTWWmU5E
dhApUvrBSGnp2eQZzqj6NAs4U54aDENzdusLLQdLuJDkI7ap2d2BgKaBMv6HF55g
uPodBPiIo2zRmvM4VlTP3gh2M7NkPMMyz2D90H6y6utYQQuc83F/sbjlj6v2a+1B
tW6uIdmxHoNw3EjpsPi5feFH/wDuOA==
=R46E
-----END PGP SIGNATURE-----

--wmxjb5ivzs2k5a7d--
