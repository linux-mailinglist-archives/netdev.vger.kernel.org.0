Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE86E5645BB
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 10:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiGCIOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 04:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiGCIOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 04:14:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0368565DB
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 01:14:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o7ukG-0000kC-99; Sun, 03 Jul 2022 10:14:20 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o7uk9-0048UC-IY; Sun, 03 Jul 2022 10:14:17 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o7ukC-002h2n-7I; Sun, 03 Jul 2022 10:14:16 +0200
Date:   Sun, 3 Jul 2022 10:14:12 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Message-ID: <20220703081412.75t6w5lgt4n3tup2@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
 <20220702164018.ztizq3ftto4lsabr@pengutronix.de>
 <OS0PR01MB592277E660F0DAC3A614A7C286BF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fx47dwq5sofzh2mk"
Content-Disposition: inline
In-Reply-To: <OS0PR01MB592277E660F0DAC3A614A7C286BF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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


--fx47dwq5sofzh2mk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 03, 2022 at 07:15:16AM +0000, Biju Das wrote:
> Hi Marc and Uwe,
>=20
> > Subject: Re: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
> > Controller
> >=20
> > On 02.07.2022 15:01:30, Biju Das wrote:
> > > The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> > > to others like it has no clock divider register (CDR) support and it
> > > has no HW loopback(HW doesn't see tx messages on rx).
> > >
> > > This patch adds support for RZ/N1 SJA1000 CAN Controller.
> > >
> > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > >  drivers/net/can/sja1000/sja1000_platform.c | 34
> > > ++++++++++++++++++----
> > >  1 file changed, 29 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/can/sja1000/sja1000_platform.c
> > > b/drivers/net/can/sja1000/sja1000_platform.c
> > > index 5f3d362e0da5..8e63af76a013 100644
> > > --- a/drivers/net/can/sja1000/sja1000_platform.c
> > > +++ b/drivers/net/can/sja1000/sja1000_platform.c
> > [...]
> > > @@ -262,6 +276,16 @@ static int sp_probe(struct platform_device *pdev)
> > >  	priv->reg_base =3D addr;
> > >
> > >  	if (of) {
> > > +		clk =3D devm_clk_get_optional(&pdev->dev, "can_clk");
> > > +		if (IS_ERR(clk))
> > > +			return dev_err_probe(&pdev->dev, PTR_ERR(clk), "no CAN
> > clk");
> > > +
> > > +		if (clk) {
> > > +			priv->can.clock.freq  =3D clk_get_rate(clk) / 2;
> > > +			if (!priv->can.clock.freq)
> > > +				return dev_err_probe(&pdev->dev, -EINVAL, "Zero
> > CAN clk rate");
> > > +		}
> >=20
> > There's no clk_prepare_enable in the driver. You might go the quick and
> > dirty way an enable the clock right here. IIRC there's a new convenience
> > function to get and enable a clock, managed bei devm. Uwe (Cc'ed) can
> > point you in the right direction.
>=20
>  + clk
>=20
> As per the patch history devm version for clk_prepare_enable is rejected[=
1], so the individual drivers implemented the same using devm_add_action_or=
_reset [2].
> So shall I implement devm version here as well?

You want to make use of 7ef9651e9792b08eb310c6beb202cbc947f43cab (which
is currently in next). If you cherry-pick this to an older kernel
version, make sure to also pick
8b3d743fc9e2542822826890b482afabf0e7522a.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--fx47dwq5sofzh2mk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmLBT9IACgkQwfwUeK3K
7Alptgf/SWE8eashOILFfLmPuRKFKypJmOjW7PCEqdYeTQ/d2XK0WtqvmzgYDTjm
Vjvna6c/6jmEE0bVCVQ90n+0KIHQ4n8D3IGXBvrEjF809xp5BPeO82qChKwjZ7lk
vm9fDLj3Wy2PS7sNn7D0nIjQKt/HafqAAclKSIQU3xWWeZjuiL+zBCbn2ttYOoJ2
jPUSwFQ9NYR9uoRnvWdTrlPXLuD0o/h7Czf9bNeuEclZ+KoDulqh4Pll11ipYZ1q
C/yvoJa8B9UDVyzflKPkdwZBqaF89DXMh2NtUnCy+XgGQDSwdvBDLg4S94iCzIe6
zVS779Af/9w5w/PB0SO17B0dcjqs9A==
=UInt
-----END PGP SIGNATURE-----

--fx47dwq5sofzh2mk--
