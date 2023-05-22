Return-Path: <netdev+bounces-4175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7107070B77B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACF1F280E8E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B7F8F7F;
	Mon, 22 May 2023 08:20:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CBA8F5B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:20:00 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612F7D2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 01:19:59 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q10lk-0000SJ-Ab; Mon, 22 May 2023 10:19:52 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id CD25A1C96BD;
	Mon, 22 May 2023 08:19:30 +0000 (UTC)
Date: Mon, 22 May 2023 10:19:30 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc: Frank Jungclaus <frank.jungclaus@esd.eu>, linux-can@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>,
	Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] can: esd_usb: Replace initializer macros used for
 struct can_bittiming_const
Message-ID: <20230522-tattling-drum-b02b6c6bf76a-mkl@pengutronix.de>
References: <20230519195600.420644-1-frank.jungclaus@esd.eu>
 <20230519195600.420644-3-frank.jungclaus@esd.eu>
 <CAMZ6RqL-2qB=kLPd84rWHd3=xPcspSNXvNYpR9Fyx+4-Ft16gQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iqguu65hudcmyit7"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqL-2qB=kLPd84rWHd3=xPcspSNXvNYpR9Fyx+4-Ft16gQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--iqguu65hudcmyit7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.05.2023 18:16:17, Vincent MAILHOL wrote:
> Thanks for the patch.
>=20
> On Sat. 20 May 2023 at 04:57, Frank Jungclaus <frank.jungclaus@esd.eu> wr=
ote:
> > Replace the macros used to initialize the members of struct
> > can_bittiming_const with direct values. Then also use those struct
> > members to do the calculations in esd_usb2_set_bittiming().
> >
> > Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVS=
DFmqpd++aBzZQg@mail.gmail.com/
> > Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 33 +++++++++++++--------------------
> >  1 file changed, 13 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index 32354cfdf151..2eecf352ec47 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -60,18 +60,10 @@ MODULE_LICENSE("GPL v2");
> >  #define ESD_USB_NO_BAUDRATE    GENMASK(30, 0) /* bit rate unconfigured=
 */
> >
> >  /* bit timing CAN-USB/2 */
> > -#define ESD_USB2_TSEG1_MIN     1
> > -#define ESD_USB2_TSEG1_MAX     16
> >  #define ESD_USB2_TSEG1_SHIFT   16
> > -#define ESD_USB2_TSEG2_MIN     1
> > -#define ESD_USB2_TSEG2_MAX     8
> >  #define ESD_USB2_TSEG2_SHIFT   20
> > -#define ESD_USB2_SJW_MAX       4
> >  #define ESD_USB2_SJW_SHIFT     14
> >  #define ESD_USBM_SJW_SHIFT     24
> > -#define ESD_USB2_BRP_MIN       1
> > -#define ESD_USB2_BRP_MAX       1024
> > -#define ESD_USB2_BRP_INC       1
> >  #define ESD_USB2_3_SAMPLES     BIT(23)
> >
> >  /* esd IDADD message */
> > @@ -909,19 +901,20 @@ static const struct ethtool_ops esd_usb_ethtool_o=
ps =3D {
> >
> >  static const struct can_bittiming_const esd_usb2_bittiming_const =3D {
> >         .name =3D "esd_usb2",
> > -       .tseg1_min =3D ESD_USB2_TSEG1_MIN,
> > -       .tseg1_max =3D ESD_USB2_TSEG1_MAX,
> > -       .tseg2_min =3D ESD_USB2_TSEG2_MIN,
> > -       .tseg2_max =3D ESD_USB2_TSEG2_MAX,
> > -       .sjw_max =3D ESD_USB2_SJW_MAX,
> > -       .brp_min =3D ESD_USB2_BRP_MIN,
> > -       .brp_max =3D ESD_USB2_BRP_MAX,
> > -       .brp_inc =3D ESD_USB2_BRP_INC,
> > +       .tseg1_min =3D 1,
> > +       .tseg1_max =3D 16,
> > +       .tseg2_min =3D 1,
> > +       .tseg2_max =3D 8,
> > +       .sjw_max =3D 4,
> > +       .brp_min =3D 1,
> > +       .brp_max =3D 1024,
> > +       .brp_inc =3D 1,
> >  };
> >
> >  static int esd_usb2_set_bittiming(struct net_device *netdev)
> >  {
> >         struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
> > +       const struct can_bittiming_const *btc =3D priv->can.bittiming_c=
onst;
>=20
> I initially suggested doing:
>=20
>           const struct can_bittiming_const *btc =3D priv->can.bittiming_c=
onst;
>=20
> But now that I think again about it, doing:
>=20
>           const struct can_bittiming_const *btc =3D &esd_usb2_bittiming_c=
onst;
>=20
> is slightly better as it will allow the compiler to fold the integer
> constant expressions such as btc->brp_max - 1. The compiler is not
> smart enough to figure out what values are held in
> priv->can.bittiming_const at compile time.
>=20
> Sorry for not figuring this the first time.

Good suggestion! Fixed up while applying.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--iqguu65hudcmyit7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRrJY8ACgkQvlAcSiqK
BOhHzQgArh8iOdOn4ECwgOQWxo5eUoe+7PZz9/bi4lsZwzKr3ynbouweNyHdCMdi
e5FbdEIxkNsQHdQCE4momJ0lfW4PBvl8T75SWxWixN2KJqdtcg4YmCCFRPSsL/jN
JXzWqxnW169wnJkQ7FxStSLX5DQJLxMevJiraGOz9dBAhboFDOMWmBJag+DBfmrL
jBa91bLKvIb4ezOFbwxlt1qqkE7bHuDLTh2jHPkZ/xCD8mt3CYhVzCC7DS3N/+s1
kYeFTyxDC0rW9Z/N+VRXPby5476KGo75uhNAhhGV5IzrDr0EKoMAueNxUSv0Er12
UyYWHBeEOMPqjpycKeM3wn44fbqp/w==
=LL8L
-----END PGP SIGNATURE-----

--iqguu65hudcmyit7--

