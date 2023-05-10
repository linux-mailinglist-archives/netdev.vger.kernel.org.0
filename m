Return-Path: <netdev+bounces-1336-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1103A6FD702
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 374891C20CBB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497B43D60;
	Wed, 10 May 2023 06:30:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3531A612E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:30:08 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99674213B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:30:07 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwdKu-0007AP-Us; Wed, 10 May 2023 08:30:04 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwdKq-002PS9-K9; Wed, 10 May 2023 08:30:00 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwdKp-002ztf-QJ; Wed, 10 May 2023 08:29:59 +0200
Date: Wed, 10 May 2023 08:29:59 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc: kernel@pengutronix.de, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	Vinod Koul <vkoul@kernel.org>, Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 06/11] net: stmmac: dwmac-qcom-ethqos:
 Convert to platform remove callback returning void
Message-ID: <20230510062959.ll5cr5s3uhjrdufj@pengutronix.de>
References: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
 <20230508142637.1449363-7-u.kleine-koenig@pengutronix.de>
 <CAH=2Ntyc-Oi-FCNQJbLwgyWT8Tt7tVpHO7HOc=hM2RdNweOzjg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ujbmobocnpqqxvme"
Content-Disposition: inline
In-Reply-To: <CAH=2Ntyc-Oi-FCNQJbLwgyWT8Tt7tVpHO7HOc=hM2RdNweOzjg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--ujbmobocnpqqxvme
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Bhupesh,

On Tue, May 09, 2023 at 01:21:56PM +0530, Bhupesh Sharma wrote:
> On Mon, 8 May 2023 at 19:56, Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> >
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code. However the value returned is (mostly) ignored
>=20
> ^^^ mostly, here seems confusing. Only if the return value is ignored
> marking the function
> as 'void' makes sense IMO.

FTR: It's only mostly ignored because a message is emitted:

	dev_warn(_dev, "remove callback returned a non-zero value. This will be ig=
nored.\n");

(see platform_remove() in drivers/base/platform.c).

> Also a small note (maybe a TBD) indicating that 'remove_new' will be
> eventually replaced with 'remove' would make reading this easier.

I adapted the commit message for future similar submissions. Thanks for
the feedback.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ujbmobocnpqqxvme
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmRbOeYACgkQj4D7WH0S
/k5/GwgApW0aJFnjWf98AQ2GZft5CQeuQgfG9/DAnorz18X3IVbz5SUAyHBulSuP
CUx7GTREdCDoTXzgHUYz7vSqYzL2Ms0wfNBU+e7yTPmwlXOg+LTKURGb1hQghH7z
4GykefqgvVoF71QJvh2mCzmJZShPRGbQhV5x/K3N1vabiMKtOGT16uL+urxHAjOi
JcoO4QmLbgqscnWSy9ArmedFM7qtF0zNfhgA4EShG9UwgFSBxyqdfmKmYVJkQza+
fKjeD1pjYRSZVRfX6bC4LhlC7aMF3sjjOBhOP4QjoHf7BVH7Z6uJdXKqIEYX7ha7
bGJDn1V7wRLu3JchRl0ZgZOki4QouQ==
=PMrW
-----END PGP SIGNATURE-----

--ujbmobocnpqqxvme--

