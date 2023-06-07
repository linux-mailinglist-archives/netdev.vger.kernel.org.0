Return-Path: <netdev+bounces-8707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D739D72548B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86DC82810E1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06821C01;
	Wed,  7 Jun 2023 06:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B257FC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:42:45 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910CA172B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:42:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6msR-0004I5-7z; Wed, 07 Jun 2023 08:42:39 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6msO-005gKv-8Y; Wed, 07 Jun 2023 08:42:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6msN-00Bvl5-CQ; Wed, 07 Jun 2023 08:42:35 +0200
Date: Wed, 7 Jun 2023 08:42:35 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Madalin Bucur <madalin.bucur@nxp.com>,
	Madalin Bucur <madalin.bucur@oss.nxp.com>, netdev@vger.kernel.org,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Michal Kubiak <michal.kubiak@intel.com>, kernel@pengutronix.de,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/8] net: dpaa: Improve error reporting
Message-ID: <20230607064235.5uylgrxef574eitw@pengutronix.de>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-2-u.kleine-koenig@pengutronix.de>
 <ZH9m4wFPTWsXXBAD@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dvizdpvsfxqzotgd"
Content-Disposition: inline
In-Reply-To: <ZH9m4wFPTWsXXBAD@boxer>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--dvizdpvsfxqzotgd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 06, 2023 at 07:03:31PM +0200, Maciej Fijalkowski wrote:
> On Tue, Jun 06, 2023 at 06:28:22PM +0200, Uwe Kleine-K=F6nig wrote:
> > Instead of the generic error message emitted by the driver core when a
> > remove callback returns an error code ("remove callback returned a
> > non-zero value. This will be ignored."), emit a message describing the
> > actual problem and return zero to suppress the generic message.
> >=20
> > Note that apart from suppressing the generic error message there are no
> > side effects by changing the return value to zero. This prepares
> > changing the remove callback to return void.
> >=20
> > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/n=
et/ethernet/freescale/dpaa/dpaa_eth.c
> > index 431f8917dc39..6226c03cfca0 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -3516,6 +3516,8 @@ static int dpaa_remove(struct platform_device *pd=
ev)
> >  	phylink_destroy(priv->mac_dev->phylink);
> > =20
> >  	err =3D dpaa_fq_free(dev, &priv->dpaa_fq_list);
> > +	if (err)
> > +		dev_err(dev, "Failed to free FQs on remove\n");
>=20
> so 'err' is now redundant - if you don't have any value in printing this
> out then you could remove this variable altogether.

Good hint, err can have different values here (at least -EINVAL and
-EBUSY), so printing it has some values. I'll wait a bit for more
feedback to this series and then prepare a v3 with

	dev_err(dev, "Failed to free FQs on remove (%pE)\n", err);

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--dvizdpvsfxqzotgd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmSAJtoACgkQj4D7WH0S
/k5/8AgAmvmpwyr7uEA2SI65fWA/Za97B4qNVPmOqshZD7IoTYkhmX0NT9JogHhB
83/+SH58MbFP17d28wuRBMs0znd80lYxqe76Zix8VaqufYgZEa8tX094wGNo6SX2
hvEmRImg9+lcPk7NhX1IZqrPsT3H2iM6+jLQ+Qz4DfC9V8IZ6ta6R4CeXVt9YfWj
Eyg0RvrU4R+k2Za4hobqfgloh6l2hyyUAoRKOLudYmoGhAhBXUZ+OFCuVRUIgQih
dS3s5cuHguBxaxv1goZTn2CgDRkftbaiPN6JmzMgMIrwKeKCzkC93iD1yEg8lKwg
xQV8mzN8Ue9WXiwrVzUygDOvONpSeA==
=MOiB
-----END PGP SIGNATURE-----

--dvizdpvsfxqzotgd--

