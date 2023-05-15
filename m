Return-Path: <netdev+bounces-2625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 183E0702C22
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C88782811CF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D9CC2F9;
	Mon, 15 May 2023 11:59:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA14C2CB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:59:55 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A16A19BA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:59:31 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyWqT-0002RK-8l; Mon, 15 May 2023 13:58:29 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id D92941C577F;
	Mon, 15 May 2023 11:58:27 +0000 (UTC)
Date: Mon, 15 May 2023 13:58:27 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Richard Cochran <richardcochran@gmail.com>, qiangqing.zhang@nxp.com,
	kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: fec: Refactor: rename `adapter` to `fep`
Message-ID: <20230515-fringe-unengaged-eeafd00f0731-mkl@pengutronix.de>
References: <20230515114721.6420-1-csokas.bence@prolan.hu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6arcdoirwv7nifuq"
Content-Disposition: inline
In-Reply-To: <20230515114721.6420-1-csokas.bence@prolan.hu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--6arcdoirwv7nifuq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.05.2023 13:47:21, Cs=C3=B3k=C3=A1s Bence wrote:
> Commit 01b825f reverted a style fix, which renamed
> `struct fec_enet_private *adapter` to `fep` to match
> the rest of the driver.

That description is a bit misleading. In fact commit 01b825f997ac
("Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"")
reverted a patch that introduced a regression.

As a side effect the problematic patch b353b241f1eb ("net: fec: Use a
spinlock to guard `fep->ptp_clk_on`") renamed struct fec_enet_private
*adapter to fep to match the rest of the driver.

> This commit factors out
> that style fix.
>=20
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--6arcdoirwv7nifuq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRiHmAACgkQvlAcSiqK
BOiMoAf7BwToe1lWb7sXwxtvQBaIWvhLUtypz3/sRnzjykFifn8q7lsD5cerm4jJ
0KByRLjpGLEm+hHhXpvDzb2MHKBuympC5gc4F0Ntg7KNWHeufPxCFAQ7Hzg1uM31
PKTVFF0QMISvLaNuvWkYxlzKxD/BYBtIW+OyvKOpMcogbLRQ9C/xenzqPDGblGMz
aQBEv5nX752la8gJGcfuxhvV/9kt0EC7P8h30d8NFD/WPLmupVnccREXm4qbJgSp
S2o2FktmzjuVcQz0qWkn27eaheTtZhO65OQ7vPu/ckOnr3cRT+9R/a8cMEGO6IF3
AYSyECDk7J+P37zP5mxFqwhrtZ8okQ==
=rfsk
-----END PGP SIGNATURE-----

--6arcdoirwv7nifuq--

