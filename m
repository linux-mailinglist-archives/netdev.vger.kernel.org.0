Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517123C9EB6
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbhGOMhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbhGOMhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:37:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0D3C061760
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 05:34:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m40Yu-0003MQ-V2; Thu, 15 Jul 2021 14:33:57 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:968e:ea40:4726:28f1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C042564FF2E;
        Thu, 15 Jul 2021 12:07:29 +0000 (UTC)
Date:   Thu, 15 Jul 2021 14:07:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dong Aisheng <dongas86@gmail.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
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
Message-ID: <20210715120729.6ify4gh7vcenkxxm@pengutronix.de>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
 <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
 <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lrbkdnzszrwfxx6h"
Content-Disposition: inline
In-Reply-To: <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lrbkdnzszrwfxx6h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.07.2021 19:36:06, Dong Aisheng wrote:
> Then should it be "fsl,imx8mp-flexcan", "fsl,imx8qxp-flexcan" rather than=
 only
> drop "fsl,imx6q-flexcan"?

The driver has compatibles for the 8qm, not for the 8qxp:

|	{ .compatible =3D "fsl,imx8qm-flexcan", .data =3D &fsl_imx8qm_devtype_dat=
a, },
|	{ .compatible =3D "fsl,imx8mp-flexcan", .data =3D &fsl_imx8mp_devtype_dat=
a, },

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lrbkdnzszrwfxx6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDwJP4ACgkQqclaivrt
76kEKAf/ei6IOOUTeOXkmfYBk+9XSDomucSWz/JK+JcGmkHtKWaDvZ85xJKLyyzi
X0SkHJeieX81WvCRGweRObl/e40BSm7/1US0TZQU4eceizOaPAPZUufyOeJ1k9dr
gwSTJRDfNGo13E9rEpFfg04y/ScQLFXG6Ge5xYUA625yfu/JbeT8qTCSRks2qmkZ
upSYr5YqdPFro+8frBb3TJ3uEr1IxBZ7jSyjqTlm8vo7ERV7gQf7pl6X7F/EMkAV
nuUZ6HuxShjI6qFXDvmr3kjk9IECyGM+zUN8qk+Rm9vBQ+7LAtHuW4Z31sPQ7GgC
TyVWhS6BRHl2x/ynenn0u895BSug0g==
=mDQp
-----END PGP SIGNATURE-----

--lrbkdnzszrwfxx6h--
