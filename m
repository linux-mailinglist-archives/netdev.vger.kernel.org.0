Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50593C9D7B
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbhGOLKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241765AbhGOLKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:10:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D06FC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 04:07:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m3zCu-0001Du-Op; Thu, 15 Jul 2021 13:07:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:968e:ea40:4726:28f1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 167AC64FE88;
        Thu, 15 Jul 2021 11:07:07 +0000 (UTC)
Date:   Thu, 15 Jul 2021 13:07:06 +0200
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
Message-ID: <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
 <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vmvpctoj2hry3h5w"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vmvpctoj2hry3h5w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.07.2021 11:00:07, Joakim Zhang wrote:
> > I checked with Joakim that the flexcan on MX8MP is derived from MX6Q wi=
th
> > extra ECC added. Maybe we should still keep it from HW point of view?
>=20
> Sorry, Aisheng, I double check the history, and get the below results:
>=20
> 8MP reuses 8QXP(8QM), except ECC_EN
> (ipv_flexcan3_syn_006/D_IP_FlexCAN3_SYN_057 which corresponds to
> version d_ip_flexcan3_syn.03.00.17.01)

Also see commit message of:

https://lore.kernel.org/linux-can/20200929211557.14153-2-qiangqing.zhang@nx=
p.com/

> I prefer to change the dtsi as Mac suggested if possible, shall I send
> a fix patch?

Make it so!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vmvpctoj2hry3h5w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDwFtcACgkQqclaivrt
76lQKggAj2Bmlhy4dp286A84lAbdUdEc6Orxejlc/BNFaJlqDmgTbKwrhcq4zoaw
k1dGc3kP0fjKzFcRM7lLz6QwxhsToo2f70/NBGN5/O+7RZr7EokSlcWBLA6D+zzP
qEfvMcRqmMoTupOnuBpYMyTfZVRqyE+U3tGPTgYWdAiNcteSKwPc18/hJQORtU2q
S8VNbCfjBTwvyRpiVbpLhyYyUGFh/uOKMZjpJXiSVCsFYdTsAakK9REgRdO4f331
OlAJQJrvxZQJ/IAUSIqrNfHbpNVGqYD4eWRitRurr6GqK7ZRyR5NZbhOka7NsbS/
QaOulnJx58Ay5Ybhh6W0KqasmMkvIA==
=bhZi
-----END PGP SIGNATURE-----

--vmvpctoj2hry3h5w--
