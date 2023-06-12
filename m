Return-Path: <netdev+bounces-10069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D1772BD10
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E458928116F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C31C18AFF;
	Mon, 12 Jun 2023 09:50:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B1F18C14
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:50:19 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313BE6EAB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:50:15 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8eBe-00026t-7Y; Mon, 12 Jun 2023 11:50:10 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8eBc-006r5q-Pt; Mon, 12 Jun 2023 11:50:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8eBb-00DTlM-VP; Mon, 12 Jun 2023 11:50:07 +0200
Date: Mon, 12 Jun 2023 11:50:07 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Ido Schimmel <idosch@nvidia.com>
Cc: Petr Machata <petrm@nvidia.com>, vadimp@nvidia.com,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: mlxsw: i2c: Switch back to use struct i2c_driver's
 .probe()
Message-ID: <20230612095007.bkwi5m3cweaonl72@pengutronix.de>
References: <20230612072222.839292-1-u.kleine-koenig@pengutronix.de>
 <ZIbVT+1PgXtElVs3@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2ntzn64cbcyr5uyp"
Content-Disposition: inline
In-Reply-To: <ZIbVT+1PgXtElVs3@shredder>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--2ntzn64cbcyr5uyp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 12, 2023 at 11:20:31AM +0300, Ido Schimmel wrote:
> On Mon, Jun 12, 2023 at 09:22:22AM +0200, Uwe Kleine-K=F6nig wrote:
> > After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> > call-back type"), all drivers being converted to .probe_new() and then
> > commit 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> > convert back to (the new) .probe() to be able to eventually drop
> > .probe_new() from struct i2c_driver.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
>=20
> I assume it's intended for net-next.

Indeed, forget the subject-prefix, sorry.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2ntzn64cbcyr5uyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmSG6k8ACgkQj4D7WH0S
/k6tCggAm42B8iWZw5vqhQRy0r0hDhd/NgwBcRbc/wrN7GHJXpv1iQggmPZJi4zS
nZsoWoCQEXax66sia7a6AUHYYBjNTe5xRtnng3LCoBovdg7oS8Dn4xFplxeKsvkb
qdK/IWRMLiJNrf6zytgUKt7M3XFhOpGi/rGLHK4tfNBu8isoM/WDqVuevpuCifH6
qCSxK64PVnNfyITqS3Us48F+ZLcBKnhLQQmA1XsuhJRt19gkPHZzFk0Ehk6f24EO
5bcG7VIabMLr+KYmda49oc10wvXLoUt+NSKGHz2n4QRRPhkwpVA9GRyyQW6qqiCk
hOpvs2onWOG+ChYCjSLvhRm4FSJZ+A==
=UqVw
-----END PGP SIGNATURE-----

--2ntzn64cbcyr5uyp--

