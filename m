Return-Path: <netdev+bounces-915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 029EC6FB5D6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC4581C20A33
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983B05684;
	Mon,  8 May 2023 17:20:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD6D20F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:20:10 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD731A2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:20:08 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw4W8-0003gl-9t; Mon, 08 May 2023 19:19:20 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw4Vw-00231L-LY; Mon, 08 May 2023 19:19:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw4Vv-002VQ3-NG; Mon, 08 May 2023 19:19:07 +0200
Date: Mon, 8 May 2023 19:19:07 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Peppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Alexandre TORGUE - foss <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>, Vinod Koul <vkoul@kernel.org>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Samin Guo <samin.guo@starfivetech.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"linux-oxnas@groups.io" <linux-oxnas@groups.io>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	NXP Linux Team <linux-imx@nxp.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Simon Horman <simon.horman@corigine.com>,
	"linux-amlogic@lists.infradead.org" <linux-amlogic@lists.infradead.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next v2 01/11] net: stmmac: Make
 stmmac_pltfr_remove() return void
Message-ID: <20230508171907.4pi6xztf6qfa4zwm@pengutronix.de>
References: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
 <20230508142637.1449363-2-u.kleine-koenig@pengutronix.de>
 <PAXPR10MB5056E934F4E1D730C03D3C6985719@PAXPR10MB5056.EURPRD10.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rsjjsoecsye26qx7"
Content-Disposition: inline
In-Reply-To: <PAXPR10MB5056E934F4E1D730C03D3C6985719@PAXPR10MB5056.EURPRD10.PROD.OUTLOOK.COM>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--rsjjsoecsye26qx7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, May 08, 2023 at 02:47:36PM +0000, Peppe CAVALLARO wrote:
> Thx for this patch train, maybe I missed the cover letter. In my
> opinion the proposed change is intrusive but I can accept. It could be
> great to enhance the platform remove functions to fail in case of an
> expected case occurs.

Not sure I understand what you want. platform_remove() (i.e. the caller
of the remove callback) emits a warning if .remove() returns an value !=3D
0.

In the Linux driver model remove functions are not supposed to fail. The
most usual case for a driver unbind (aka remove) is that the device in
question disappeared (think hotplug). There is no value in failing, what
should happen if the driver fails? There is no chance to reenter
=2Eremove() as some resources might already be freed.

> +	.remove_new =3D stmmac_pltfr_remove,
>=20
> To be honest, I do not like to see: ".remove_new" as hook

=2Eremove_new() is not here to say. Once all drivers are converted,
=2Eremove() is changed to get the same semantics as .remove_new() has now
and then after all drivers are converted back to .remove() .remove_new()
will be dropped. See 5c5a7680e67ba6fbbb5f4d79fa41485450c1985c for some
more details.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--rsjjsoecsye26qx7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmRZLwoACgkQj4D7WH0S
/k5oqAgAtZbDz/JeywtQRweJp39ep72ljsut8JZVkM24C3EP+ndMdqeXr30Dv4uo
vo9g8mcVmtlq7WYyBRaOL6ldTe+RFapVrMZmG6bkkaVk/ahEPiL1SZXFfDWcIglC
A93oYYeoykVQYWi9CGMED6w7bOBy0NDQmSpd5VSI9YKEQKbcqs9I4agXs9quOSKi
IZgd0msErY4ovsypqIZqOlHlfyc8rHFcZbD2avv39x6Pffsx0tgPDNMGcjL6u0aH
ICgqBivvxKkrFvu738mc55TnrEmLb4295TpcCYUnqWOGJg9V/HchwkMPSn6gGxjs
7Lc0UrM3XiGMumkkfRWnv/QWi0wAHw==
=ZQ11
-----END PGP SIGNATURE-----

--rsjjsoecsye26qx7--

