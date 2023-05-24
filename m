Return-Path: <netdev+bounces-4878-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A80370EF27
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C72961C20A54
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A5C79EB;
	Wed, 24 May 2023 07:15:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E36C1FA2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:15:52 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B08E6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:15:51 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q1iin-0008Vs-V2; Wed, 24 May 2023 09:15:46 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id CF1751CAECB;
	Wed, 24 May 2023 07:15:44 +0000 (UTC)
Date: Wed, 24 May 2023 09:15:44 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Frank Jungclaus <frank.jungclaus@esd.eu>
Cc: linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] can: esd_usb: More preparation before supporting esd
 CAN-USB/3 (addendum)
Message-ID: <20230524-brownnose-spinster-6f4a9d600b21-mkl@pengutronix.de>
References: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zezrvyawup3qxqy4"
Content-Disposition: inline
In-Reply-To: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--zezrvyawup3qxqy4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.05.2023 19:31:03, Frank Jungclaus wrote:
> While trying to again merge my code changes for CAN-USB/3, I came
> across some more places where it could make sense to change them
> analogous to the previous clean-up patch series [1].
>=20
> [1] [PATCH v2 0/6] can: esd_usb: More preparation before supporting esd C=
AN-USB/3
> Link: https://lore.kernel.org/all/20230519195600.420644-1-frank.jungclaus=
@esd.eu/

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--zezrvyawup3qxqy4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRtuZ0ACgkQvlAcSiqK
BOiaDAgAk8zZ0dPy7U85VzvgRKUxB9JKLi/zjcsbhjpgfZTB84AmOPgiOLNU1z2r
G1C5FoTH4SKl6v1gICkNMp+6X67g3V+hnP6inrpRMs1Z5Ki2p/MWy3g8GTWMkMOZ
0qU0dc0TwGqQ++/AAl+zKSa9MkBieo7dsGWdqYW4CDPgeaElDNliLE12/D3G3YZR
sSpRdHgpLmowBPSI7x/FtowfRkGp0CctwrYywVERR+jmfacSH/sKwK+nX525zk+Z
i6GnvF+yabuXJtpR3ztzmPe1K5CVjH7mXTqLEWam1WOMN7aJm588b8+7AMD8c4Yh
I1WFL110Kjp1DXEAt/7/i2jX2LzidQ==
=wh88
-----END PGP SIGNATURE-----

--zezrvyawup3qxqy4--

