Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5459D3C9EB2
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhGOMhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237346AbhGOMg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:36:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A4C061762
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 05:34:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m40Yu-0003MR-V1; Thu, 15 Jul 2021 14:33:57 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:968e:ea40:4726:28f1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EC64864FF37;
        Thu, 15 Jul 2021 12:10:40 +0000 (UTC)
Date:   Thu, 15 Jul 2021 14:10:40 +0200
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
Message-ID: <20210715121040.2lqpz4tbdmb3bhbw@pengutronix.de>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
 <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
 <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
 <DB8PR04MB679513E50585817AF8E2C7E7E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <CAA+hA=R8XsZn3FDkywHpww7=4mvXrYzzXgsoKNF_-1M2McVTwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jfbxjgun2hqqa4lr"
Content-Disposition: inline
In-Reply-To: <CAA+hA=R8XsZn3FDkywHpww7=4mvXrYzzXgsoKNF_-1M2McVTwA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jfbxjgun2hqqa4lr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.07.2021 19:49:42, Dong Aisheng wrote:
> > > Then should it be "fsl,imx8mp-flexcan", "fsl,imx8qxp-flexcan" rather =
than only
> > > drop "fsl,imx6q-flexcan"?
> >
> > No, I will only use " fsl,imx8mp-flexcan" to avoid ECC impact.
> >
>=20
> Is ECC issue SW or HW compatibility issue?
> If SW, then we should keep the backward compatible string as DT is
> describing HW.

The commit messages describes the needed initialization for devices
supporting ECC:

https://lore.kernel.org/linux-can/20200929211557.14153-2-qiangqing.zhang@nx=
p.com/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jfbxjgun2hqqa4lr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDwJb0ACgkQqclaivrt
76nP7wgAi38ZLy/yVCMLfatImGdZXpYFOoS3goUIPlySktZJQbPzvufxhKDNR++O
6k5hf8jOVZmBpdpCVEyt4kMEEWq9oU6DB+xIdFscGs23bp8dTxZJyiGLtvurFzKy
5Nz5uQjwRb6KBOKr20EfhLO8swwApRIKIZ1UEkgvJgGfgo4gLSux9/wjKbeQkoe5
3CeUbiHoSnUjFzUg9XMXfTSBQM68ZSPMgCEW+WLLfC/kUW4DRNhbow0titPohfqB
ZK2bHPTpEe0mEuK4BP9ubhdiHZu0F4tAAWEnkBMwFBwcGjU27RNnquwFX8+lphQr
+VfcsbnRe6DjV2TsgB68VWzfR6nRqQ==
=GRc9
-----END PGP SIGNATURE-----

--jfbxjgun2hqqa4lr--
