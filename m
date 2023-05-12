Return-Path: <netdev+bounces-2310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BCF70116B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27EF2281CC9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB81261ED;
	Fri, 12 May 2023 21:38:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EFE138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:38:12 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B60835A0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:38:11 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaSY-0007zh-G2; Fri, 12 May 2023 23:37:54 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaSV-0033aR-4j; Fri, 12 May 2023 23:37:51 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaSU-003qld-8s; Fri, 12 May 2023 23:37:50 +0200
Date: Fri, 12 May 2023 23:37:46 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>, Mark Brown <broonie@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>
Cc: netdev@vger.kernel.org, kernel@pengutronix.de,
	linux-can@vger.kernel.org
Subject: Re: [PATCH 12/19] can: mscan/mpc5xxx_can.c -- Convert to platform
 remove callback returning void
Message-ID: <20230512213746.u5ip4n2dy6crpghi@pengutronix.de>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
 <20230512212725.143824-13-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vhk4jyixv5dls47a"
Content-Disposition: inline
In-Reply-To: <20230512212725.143824-13-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--vhk4jyixv5dls47a
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I fatfingered the subject. I didn't adapt completely in the first rebase
round as I was unsure what to pick and then forgot to fix that before
sending out. Looking at the history the suitable prefix would be

	can: mscan: mpc5xxx_can:

=2E Feel free to adapt whan applying, otherwise I can resend this patch
individually or the complete series. Just tell me how you prefer it.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--vhk4jyixv5dls47a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmResagACgkQj4D7WH0S
/k45fQf+K0RxBCTaHwASNUK8deKJH4D53RkNdw/oDyfNTjfdpD5i3fV4vL7O76wN
XIHe/sRfpsFX/OHIycxAd0r6D07XUIr/wdZxLkQaMqttp15CJa9oP6BhXa5UC/H7
LBlwLUVU7RJW5CPQdbnsJZM1fHdCVmjR+9qZ8lGYoKYccWw0Xjjex4AOaI45ri02
lB1+ooVlImOG5ONHYktVpA4gL+CrXr/QlJ1O/kTZKcwtU05EI15GaxTPuZ65OuSs
W/zwlnw+xej1eIZV6bq1PwZoVrvW7bXSN8/qSfN3115ACyuWLM9UhptBR6Q+1p0Q
snUkmBr0U9w7VquMgceHmIHXHcZ0Jg==
=7Msi
-----END PGP SIGNATURE-----

--vhk4jyixv5dls47a--

