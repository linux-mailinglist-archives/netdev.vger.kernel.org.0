Return-Path: <netdev+bounces-7048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 120387196FA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE0E1C2102A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C6C1641E;
	Thu,  1 Jun 2023 09:31:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0772A14274
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:31:00 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50956F2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:30:59 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ee1-0005e4-Ky; Thu, 01 Jun 2023 11:30:57 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ee0-004Jx2-0m; Thu, 01 Jun 2023 11:30:56 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4edz-00A78v-6b; Thu, 01 Jun 2023 11:30:55 +0200
Date: Thu, 1 Jun 2023 11:30:55 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Kalle Valo <kvalo@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, Eric Dumazet <edumazet@google.com>,
	kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/4] Convert to platform remove callback
 returning void
Message-ID: <20230601093055.ovmhypa5jw2bq32q@pengutronix.de>
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
 <87h6rrk0cn.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g4pasupk4odv3umz"
Content-Disposition: inline
In-Reply-To: <87h6rrk0cn.fsf@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--g4pasupk4odv3umz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Kalle,

On Thu, Jun 01, 2023 at 12:17:44PM +0300, Kalle Valo wrote:
> Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de> writes:
>=20
> > the motivation for this series is patch #3, patch #2 is a preparation f=
or it
> > and patches #1 and #4 are just cleanups that I noticed en passant.
> >
> > Best regards
> > Uwe
> >
> > Uwe Kleine-K=F6nig (4):
> >   ath10k: Drop cleaning of driver data from probe error path and remove
> >   ath10k: Drop checks that are always false
> >   ath10k: Convert to platform remove callback returning void
> >   atk10k: Don't opencode ath10k_pci_priv() in ath10k_ahb_priv()
> >
> >  drivers/net/wireless/ath/ath10k/ahb.c  | 20 +++-----------------
> >  drivers/net/wireless/ath/ath10k/snoc.c |  8 +++-----
> >  2 files changed, 6 insertions(+), 22 deletions(-)
>=20
> ath10k patches go to my ath.git tree, not net-next.

This isn't obvious for outsiders. Not sure what can be improved to
make this easier to spot.

> Also "wifi:" is missing from the title but I can add that.

oops, I wondered about that, too, but was sure that I used the prefix
=66rom previous commits. Now that you said it, suddenly all previous
commits have this wifi prefix. Hmm, somebody must have tinkered with my
source tree :-)

Thanks for fixing my misdemeanors,
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--g4pasupk4odv3umz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmR4ZU4ACgkQj4D7WH0S
/k4Utwf/dhPpcpseS9x4rk209oXT1aUQ8EwAXqrNMqTSAUjG325bqhzAYUBeNqK2
nrHzvynSDmP9BEW8zD+dcOKLZesUPgBkIuxoAz9fR4ac+KktWdUBlIRQ40cYMcyq
hm6z9GthpphkyrEzDUv7LympX8CPnQlYBA/pTEXdtXSYMAQX4w5K3q4/rt2theCV
4U/FIiTNrC7GBNgncXsq8YuGfaLwoNpoAg8SLipvPhdhsFLyjm+flS3NeJrhf6Yf
h0HzJObYBEKMTmFLKhqf/LWa8DRXYiuEIk3eeTTh5NGsv9DUKx2Cd4XYq5vIB6Ro
DeHLYMNpWlkU2sEax8AAx8wLv01Qgw==
=gVBP
-----END PGP SIGNATURE-----

--g4pasupk4odv3umz--

