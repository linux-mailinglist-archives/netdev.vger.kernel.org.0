Return-Path: <netdev+bounces-7993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AF872262C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A692B1C20B9F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868D21549E;
	Mon,  5 Jun 2023 12:44:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4666D18
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:44:04 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E895F3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:43:55 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q69Ys-00060y-GZ; Mon, 05 Jun 2023 14:43:50 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id BE9AF1D2531;
	Mon,  5 Jun 2023 12:43:48 +0000 (UTC)
Date: Mon, 5 Jun 2023 14:43:48 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Richard Cochran <richardcochran@gmail.com>, kernel@pengutronix.de,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH resubmit] net: fec: Refactor: rename `adapter` to `fep`
Message-ID: <20230605-majorette-reverse-996f5b76cd77-mkl@pengutronix.de>
References: <20230605094402.85071-1-csokas.bence@prolan.hu>
 <20230605-surfboard-implosive-d1700e274b20-mkl@pengutronix.de>
 <e67321c3-2a81-170a-0394-bdb00beb7182@prolan.hu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jy6e6ifpre2hxodm"
Content-Disposition: inline
In-Reply-To: <e67321c3-2a81-170a-0394-bdb00beb7182@prolan.hu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--jy6e6ifpre2hxodm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.06.2023 14:35:33, Cs=C3=B3k=C3=A1s Bence wrote:
> On 2023. 06. 05. 11:51, Marc Kleine-Budde wrote:
> > On 05.06.2023 11:44:03, Cs=C3=B3k=C3=A1s Bence wrote:
> > > Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
> >=20
> > You probably want to add a patch description.
>=20
> Is it necessary for such a trivial refactor commit?

This is considered good practice.

> I thought the commit msg
> already said it all. What else do you think I should include still?
>=20
> Would something like this be sufficient?
> "Rename local `struct fec_enet_private *adapter` to `fep` in
> `fec_ptp_gettime()` to match the rest of the driver"

Looks good to me.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--jy6e6ifpre2hxodm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmR92IEACgkQvlAcSiqK
BOhRQwf/fjVRhgU6fuRp6IaQm03hmgiaXDhBWXG15ofmARVP5BEpDVq89B9emtfs
2wIbcQzcb/nnopSZ2505gPidrZcN9q70pR0nep0sEcWgu4JmjGFbhMrn+zQdmHEm
/90coxU3k7/1pdJjdYBzr/ECRYVONZ+LS6K5him+vKXfbTIbGB8mWODDC1W+mnVM
8FwdM14MZRUWLPa9oAhwSJITKUqJzHDlRUjJkvnXcSxLlWutT9dsVra5tePWbRXr
Drd5QQTAScr0ECPBDdHqwsfVDnMOfGW2lfiK0d4+xcxyDk078oyv6y8eazl+PrNt
QfhtTDQthIZYOFC7KJ26GaKM5xGf6Q==
=rv2h
-----END PGP SIGNATURE-----

--jy6e6ifpre2hxodm--

