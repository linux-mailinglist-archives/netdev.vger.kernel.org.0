Return-Path: <netdev+bounces-5009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A581A70F6CB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C8CD1C20CCD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB876084D;
	Wed, 24 May 2023 12:44:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD82660843
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:44:56 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24F9A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:44:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q1nqr-0000ph-DY; Wed, 24 May 2023 14:44:25 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q1nqk-002USh-GG; Wed, 24 May 2023 14:44:18 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q1nqj-007Yje-A3; Wed, 24 May 2023 14:44:17 +0200
Date: Wed, 24 May 2023 14:44:14 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Jean Delvare <jdelvare@suse.de>
Cc: Corey Minyard <cminyard@mvista.com>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Adrien Grassein <adrien.grassein@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Kang Chen <void0red@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Machata <petrm@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Michael Walle <michael@walle.cc>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] nfc: Switch i2c drivers back to use .probe()
Message-ID: <20230524124414.foiodqo6zejby27y@pengutronix.de>
References: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
 <20230524131011.0d948017@endymion.delvare>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4dsiprop32wx4qxm"
Content-Disposition: inline
In-Reply-To: <20230524131011.0d948017@endymion.delvare>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--4dsiprop32wx4qxm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jean,

On Wed, May 24, 2023 at 01:10:11PM +0200, Jean Delvare wrote:
> On Sat, 20 May 2023 19:21:04 +0200, Uwe Kleine-K=F6nig wrote:
> > After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> > call-back type"), all drivers being converted to .probe_new() and then
> > 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> > convert back to (the new) .probe() to be able to eventually drop
> > .probe_new() from struct i2c_driver.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > this patch was generated using coccinelle, but I aligned the result to
> > the per-file indention.
> >=20
> > This is one patch for the whole iio subsystem. if you want it split per
>=20
> s/iio/nfc/

Yeah, copy&paste failure. I noticed after sending out the patch, but as
it's only in a part of the mail that doesn't make it into git I didn't
care to point it out.

> > driver for improved patch count numbers, please tell me.
> >=20
> > This currently fits on top of 6.4-rc1 and next/master. If you apply it
> > somewhere else and get conflicts, feel free to just drop the files with
> > conflicts from this patch and apply anyhow. I'll care about the fallout
> > later then.
> >=20
> > Best regards
> > Uwe
> >=20
> >  drivers/nfc/fdp/i2c.c       | 2 +-
> >  drivers/nfc/microread/i2c.c | 2 +-
> >  drivers/nfc/nfcmrvl/i2c.c   | 2 +-
> >  drivers/nfc/nxp-nci/i2c.c   | 2 +-
> >  drivers/nfc/pn533/i2c.c     | 2 +-
> >  drivers/nfc/pn544/i2c.c     | 2 +-
> >  drivers/nfc/s3fwrn5/i2c.c   | 2 +-
> >  drivers/nfc/st-nci/i2c.c    | 2 +-
> >  drivers/nfc/st21nfca/i2c.c  | 2 +-
> >  9 files changed, 9 insertions(+), 9 deletions(-)
> > (...)
>=20
> Reviewed-by: Jean Delvare <jdelvare@suse.de>

Thanks, but note that davem already applied the patch, so your tag
probably won't make it in.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--4dsiprop32wx4qxm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmRuBp0ACgkQj4D7WH0S
/k4+1Qf6AvpuEqbhup7szAc9UEn35Tu6D/fons+YB8mbGcd/q3YoNwPUFVe0zQXv
WFFNClIZ5YsYDajb7GigBpYtZ1SRHaQ2VvHiY52BaaSBFmrnkHFHcn1CX7OSix+o
C0cgONnsM8EC3FBtua9xCqGxa8e79Aiv48yJ5trUIsdg4CSRX1bkxpdVuHrck1lJ
HkgLOxRmwVTNRtVGEMyiuvBgCLUvqDnnGKYq5Q7P5zlLrYvjMG+SPOsTqvZZUCGS
FdoYLg+bKP1XVp7rI98cfdGRnxLuEEDYiO12aR8KPWC/ZPJ9iUiPFYcSHFLCQLfY
RVDrsJc+hg173JvQVPjuKc0O+ny1kA==
=wRp/
-----END PGP SIGNATURE-----

--4dsiprop32wx4qxm--

