Return-Path: <netdev+bounces-2922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA02370484B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA1851C20E2F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E704156E4;
	Tue, 16 May 2023 08:57:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F230633D7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:57:07 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5772707
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:57:06 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyqTl-0003Fb-MX; Tue, 16 May 2023 10:56:21 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 823541C6306;
	Tue, 16 May 2023 08:56:17 +0000 (UTC)
Date: Tue, 16 May 2023 10:56:17 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Simon Horman <simon.horman@corigine.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Eric Dumazet <edumazet@google.com>, Haibo Chen <haibo.chen@nxp.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Rob Herring <robh@kernel.org>, Samuel Holland <samuel@sholland.org>,
	Minghao Chi <chi.minghao@zte.com.cn>, Chen-Yu Tsai <wens@csie.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	linux-arm-kernel@lists.infradead.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-sunxi@lists.linux.dev,
	Wolfgang Grandegger <wg@grandegger.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-can@vger.kernel.org,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Wei Fang <wei.fang@nxp.com>,
	Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Michal Simek <michal.simek@amd.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wolfram Sang <wsa@kernel.org>, Ondrej Ille <ondrej.ille@gmail.com>,
	Mark Brown <broonie@kernel.org>, kernel@pengutronix.de,
	netdev@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH net-next 00/19] can: Convert to platform remove callback
 returning void
Message-ID: <20230516-cresting-anaconda-07c5ff1412ed-mkl@pengutronix.de>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
 <ZGMxOB6iVj39vM6U@corigine.com>
 <ZGNCoz+Dos/niRlx@corigine.com>
 <20230516-sharply-sulphuric-2c99e8c1cbda-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="buls3nqvfcme3fto"
Content-Disposition: inline
In-Reply-To: <20230516-sharply-sulphuric-2c99e8c1cbda-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--buls3nqvfcme3fto
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.05.2023 10:54:06, Marc Kleine-Budde wrote:
> On 16.05.2023 10:45:23, Simon Horman wrote:
> > On Tue, May 16, 2023 at 09:31:04AM +0200, Simon Horman wrote:
> > > On Fri, May 12, 2023 at 11:27:06PM +0200, Uwe Kleine-K=C3=B6nig wrote:
> > > > Hello,
> > > >=20
> > > > this series convers the drivers below drivers/net/can to the
> > > > .remove_new() callback of struct platform_driver(). The motivation =
is to
> > > > make the remove callback less prone for errors and wrong assumption=
s.
> > > > See commit 5c5a7680e67b ("platform: Provide a remove callback that
> > > > returns no value") for a more detailed rationale.
> > > >=20
> > > > All drivers already returned zero unconditionally in their
> > > > .remove() callback, so converting them to .remove_new() is trivial.
> > >=20
> > > Hi Uwe,
> > >=20
> > > I like these changes and they all look good to me.
> > > However, I have a question, perhaps more directed at the netdev
> > > maintainers than yourself.
> > >=20
> > > In principle patch-sets for netdev should not include more than 15 pa=
tches.
> > > It's unclear to me if, on the basis of that, this patchset should
> > > be split up. Or if, f.e. given the simple nature of the patches,
> > > an exception applies in this case. Or something else.
> > >=20
> > > I have no fixed opinion on this.
> > > But I feel that the question should be asked.
> > >=20
> > > Link: https://kernel.org/doc/html/v6.1/process/maintainer-netdev.html
> > >=20
> > > ...
> >=20
> > I now realise this series is for can.
> > Which I assume means the guidance above doesn't apply.
> >=20
> > Sorry for the noise.
>=20
> That's still a good point, because sooner or later Uwe will probably
> also convert the platform drivers to Driver/Network/Ethernet.

=2E..in driver/net/ethernet.

(damnyouautocorrect)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--buls3nqvfcme3fto
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRjRSwACgkQvlAcSiqK
BOgpFgf/clqhhNylGlVnHL52KfOeawTcsln5X1etmr1JkJUTACGJNgqBtVd/2MwZ
5F53qnKrEiB329WeGNLy7/ebiGKMEes8gHzmxVagn+nKgeYHfpMqjjWI/S5Ed76k
dHtngo9juS8SYIKK3d8H651SMg1S/J6+UkNlXtWs0jNznBQQsIje927pCQs5Zsn4
dtf5cg3WZDaQc+KXjbFkSo3N390ViYCzwDq6Xs/gPfjdJEWhXVlcwAjTuDw0e1Ot
TfLffOGUHZNLUaC2s7UYy43lEdfEHChQ8U9Db/HPZ4MGHkflZ4ywiZ75FZl80Iwn
KMsaxUzR+12+ASzieFSRPKwr0G2jEQ==
=t1JR
-----END PGP SIGNATURE-----

--buls3nqvfcme3fto--

