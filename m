Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94F33CB507
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 11:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhGPJJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 05:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhGPJJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 05:09:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7614C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 02:06:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m4Jnx-0002gl-3K; Fri, 16 Jul 2021 11:06:45 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:df95:c0e5:d620:3bac])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 846B86508B9;
        Fri, 16 Jul 2021 09:06:43 +0000 (UTC)
Date:   Fri, 16 Jul 2021 11:06:42 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Dong Aisheng <dongas86@gmail.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Message-ID: <20210716090642.pyk6o6uvqrhuiwzc@pengutronix.de>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
 <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
 <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
 <20210715120729.6ify4gh7vcenkxxm@pengutronix.de>
 <DB8PR04MB67956BA87EE91F3298329175E6119@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vplpo67ze6o2o3mq"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB67956BA87EE91F3298329175E6119@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vplpo67ze6o2o3mq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.07.2021 02:04:56, Joakim Zhang wrote:
> > On 15.07.2021 19:36:06, Dong Aisheng wrote:
> > > Then should it be "fsl,imx8mp-flexcan", "fsl,imx8qxp-flexcan" rather
> > > than only drop "fsl,imx6q-flexcan"?
> >=20
> > The driver has compatibles for the 8qm, not for the 8qxp:
> >=20
> > |	{ .compatible =3D "fsl,imx8qm-flexcan", .data =3D
> > &fsl_imx8qm_devtype_data, },
> > |	{ .compatible =3D "fsl,imx8mp-flexcan", .data =3D
> > |&fsl_imx8mp_devtype_data, },
>=20
> AFAIK, we first design the i.MX8QM FlexCAN and later i.MX8QXP reuses
> IP from i.MX8QM, so there is no difference for them.
>=20
> IMHO, IP design is always backwards compatible,

Hopefully the IP blocks of the i.MX8Q* are compatible, but the other
flexcan IP core are not.

> then we need list each as fallback compatible string? I think it's
> unnecessary.

In the DTs we usually use the name of the SoC we're just describing as
the first compatible, and add a second compatible with the oldest SoC
having this IP core or an IP core that is compatible (so that the driver
works).

As the imx8mp needs the DISABLE_MECR quirk it's not compatible with the
imx6.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vplpo67ze6o2o3mq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDxTCAACgkQqclaivrt
76lj+AgAiLyjZGBYnmjmMZZL/M7hjLlwNRc1L5g38yaFWxypcrvzJzdUHQ+r3tIJ
nX2f2/rkPggetuGRapYuQ8r02RZ83k97L4vE7p4CuM7P823mgdL5s462CXFP5f5b
b2J51CbD4torpw2YR+7H+geGZ8pt6NSH2KoPzAqZza+XNzVWJJIg7dt+N4CMBiM6
ZhVkCS/6A6hopioI7vrDmZxWkM/1Fj4TqbRHhlOlb2LMek7abKEkFlkTGg9OjE6g
GXWcQHL0H7dFRVAP3K/VZ87846dZ3ENg+rTAWBIWMBNTEEZwujno/6o78YTdiDQe
jOeW1Bu7+g9gIV44IBAjt5Wt5JbBtw==
=2Tan
-----END PGP SIGNATURE-----

--vplpo67ze6o2o3mq--
