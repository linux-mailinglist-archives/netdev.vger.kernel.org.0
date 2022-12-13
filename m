Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE564B0D8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiLMIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbiLMIL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:11:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAA8167E3
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 00:11:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p50OE-0003HQ-OY; Tue, 13 Dec 2022 09:11:50 +0100
Received: from pengutronix.de (hardanger.fritz.box [IPv6:2a03:f580:87bc:d400:7718:f6d6:39bc:6089])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8B6EB13D82D;
        Tue, 13 Dec 2022 08:11:49 +0000 (UTC)
Date:   Tue, 13 Dec 2022 09:11:49 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Bough Chen <haibo.chen@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: RE: [PATCH net-next 11/39] can: flexcan: add auto stop mode for
 IMX93 to support wakeup
Message-ID: <20221213081149.lo6pupzfuhrydnrj@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
 <20221212113045.222493-12-mkl@pengutronix.de>
 <DB7PR04MB4010740EC36BE814CE5C416B90E39@DB7PR04MB4010.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5r3s5utz4ssaoyie"
Content-Disposition: inline
In-Reply-To: <DB7PR04MB4010740EC36BE814CE5C416B90E39@DB7PR04MB4010.eurprd04.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5r3s5utz4ssaoyie
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.12.2022 02:22:02, Bough Chen wrote:
> > -----Original Message-----
> > From: Marc Kleine-Budde <mkl@pengutronix.de>
> > Sent: 2022=E5=B9=B412=E6=9C=8812=E6=97=A5 19:30
> > To: netdev@vger.kernel.org
> > Cc: davem@davemloft.net; kuba@kernel.org; linux-can@vger.kernel.org;
> > kernel@pengutronix.de; Bough Chen <haibo.chen@nxp.com>; Marc
> > Kleine-Budde <mkl@pengutronix.de>
> > Subject: [PATCH net-next 11/39] can: flexcan: add auto stop mode for IM=
X93 to
> > support wakeup
> >=20
> > From: Haibo Chen <haibo.chen@nxp.com>
> >=20
> > IMX93 do not contain a GPR to config the stop mode, it will set the fle=
xcan into
> > stop mode automatically once the ARM core go into low power mode (WFI
> > instruct) and gate off the flexcan related clock automatically. But to =
let these
> > logic work as expect, before ARM core go into low power mode, need to m=
ake
> > sure the flexcan related clock keep on.
> >=20
> > To support stop mode and wakeup feature on imx93, this patch add a new
> > fsl_imx93_devtype_data to separate from imx8mp.
> >=20
> > Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
> > Link:
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flor=
e.kern
> > el.org%2Fall%2F1669116752-4260-1-git-send-email-haibo.chen%40nxp.com&a
> > mp;data=3D05%7C01%7Chaibo.chen%40nxp.com%7C57db640faf1a4fe6ac9e08da
> > dc34556c%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638064414
> > 581423735%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV
> > 2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D
> > yc1AspfoVq%2BHKokRFxf06vcaqqP%2FtZUnpMnTaXL97y8%3D&amp;reserved=3D
> > 0
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> Hi Marc,
>=20
> Thanks for sending this patch.
> But this patch has one runtime PM unbalance issue, I will fix this issue =
and send again these days.

It's in net-next now, please send an incremental patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5r3s5utz4ssaoyie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOYM8IACgkQrX5LkNig
011iDAf6AlqjF3CCizNtzf/pNHF+B1mr9+IArDxNbt4QbScr4epTz9KVAno3UoLZ
kEzawBwDrcqxuxph1qxif0AKhxwWJuzs+JP/VgeFuTLaaumevLofqj3lth7/dWK1
//gzKBiOeyurwRpo6JanaRASCaIM76+Sd3c5hYV/Gb+h6Fil+yY8TOX6YFLcVy+E
cinQ22/GgxIcE/MIK0M1GKlYHNp05UBlb1WuSguUREK1eidxaH8K7QGHHVtce2lh
eVhmwj1E2yOexVCP0QWxdM016V5PbIKbT5yOFLcOBZLvXp4T1tyY2gBUcztanYWo
xwH8onDwtYoBxXyBJ+m4tglsCNp6hw==
=pFwR
-----END PGP SIGNATURE-----

--5r3s5utz4ssaoyie--
