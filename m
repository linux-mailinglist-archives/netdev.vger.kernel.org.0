Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00BE694C92
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBMQYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjBMQYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:24:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF5C2131
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:23:45 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRbc9-00042X-KD; Mon, 13 Feb 2023 17:23:37 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRbc4-004hBN-Mp; Mon, 13 Feb 2023 17:23:33 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRbc5-003F5a-8J; Mon, 13 Feb 2023 17:23:33 +0100
Date:   Mon, 13 Feb 2023 17:23:33 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, kernel@pengutronix.de,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] net: stmmac: Make stmmac_dvr_remove() return void
Message-ID: <20230213162333.iqjlwa2ladkxfooy@pengutronix.de>
References: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
 <Y+pHZ75Ynp5xkgQy@lincoln>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jkm32kqnyjmt5dd5"
Content-Disposition: inline
In-Reply-To: <Y+pHZ75Ynp5xkgQy@lincoln>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jkm32kqnyjmt5dd5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 03:21:27PM +0100, Larysa Zaremba wrote:
> On Sat, Feb 11, 2023 at 12:24:30PM +0100, Uwe Kleine-K=F6nig wrote:
> > The function returns zero unconditionally. Change it to return void ins=
tead
> > which simplifies some callers as error handing becomes unnecessary.
> >=20
> > This also makes it more obvious that most platform remove callbacks alw=
ays
> > return zero.
>=20
> Code in both patches looks OK.

Is this an Ack?

> Please, specify, which tree this patch should be in (net or net-next).
> This is rather a code improvement than a fix, so net-next would be approp=
riate.

net-next sounds fine. Sorry, I forgot about this requirement for net
patches.

> Also, multiple patches usually require a cover letter. The code changes a=
re=20
> trivial, so maybe the best solution would be to just to squash those patc=
hes=20
> together.

My conclusion was a bit different: The code changes are trivial, so they
don't require a cover letter :-)

I don't care much about squashing the two patches together. I slightly
prefer to keep the changes as two changes as the changes are orthogonal
and one patch per thing is the usual action.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--jkm32kqnyjmt5dd5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmPqZAEACgkQwfwUeK3K
7AmFzwf/YlaZdZn4/6cDeX6U7Qr7zgpjsDbXh2gtnbfrS4loVTUNqwIEluGj+LtN
K8ZSLakcWnrrs7Lj0B0+CPzAufUZe8YPOjnpgJ2xT0m3aOm0eI7e4TZmXbHitR9W
pV+rnQxa6AJ9FefZPIbcrL3fwwgEJCp5Er/TNw2dCSqDOAGNeYVcJ5AMmc9YgGmX
Ujyaf2Lm66Cp4dasj8IpX6cONEjxZ8T5iCdMxrtjiH7kuvzUsjDiZyVxtvlW8+B4
wJam0jluHUaIyv42uUwtGL1GgYFro0Q9U6Et3Yfqi7DSmgAExql/Apj1hRz1O5yD
11H9racybAuYwBkLZph8ogoqhYkCHA==
=pxTs
-----END PGP SIGNATURE-----

--jkm32kqnyjmt5dd5--
