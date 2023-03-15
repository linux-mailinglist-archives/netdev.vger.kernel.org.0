Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2AA6BA7D0
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCOGar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCOGaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:30:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7186188E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 23:30:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcKe1-0005Ef-EG; Wed, 15 Mar 2023 07:29:53 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcKds-004FBQ-1I; Wed, 15 Mar 2023 07:29:44 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcKdr-0050hi-Ac; Wed, 15 Mar 2023 07:29:43 +0100
Date:   Wed, 15 Mar 2023 07:29:39 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wolfram Sang <wsa@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wei Fang <wei.fang@nxp.com>, Mark Brown <broonie@kernel.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net-next 4/9] net: fec: Convert to platform remove
 callback returning void
Message-ID: <20230315062939.a6co333ssuz564p2@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-5-u.kleine-koenig@pengutronix.de>
 <20230314221508.lhumfl3y3qrybqj2@pengutronix.de>
 <20230314222821.0988983c@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5li5uzprglwpgp5b"
Content-Disposition: inline
In-Reply-To: <20230314222821.0988983c@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5li5uzprglwpgp5b
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jakub,

On Tue, Mar 14, 2023 at 10:28:21PM -0700, Jakub Kicinski wrote:
> On Tue, 14 Mar 2023 23:15:08 +0100 Uwe Kleine-K=F6nig wrote:
> > FTR: This patch depends on patch 2 of this series which has issues. So
> > please drop this patch, too. Taking the other 7 patches should be fine
> > (unless some more issues are discovered of course).
>=20
> Could you post a v2 with just the right patches in it?
> Would be quicker for us to handle and we're drowning in patches ATM :(

That approximately matches my plan. I didn't intend to resend the
patches that were not criticised if you pick them up. I have still 2000+
patches of this type in my queue and intend to care for the rejects when
I'm through sending them all once. When I rebase then I can easily see
which drivers need some more care. I expect that won't happen in the
current development cycle.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5li5uzprglwpgp5b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQRZc8ACgkQwfwUeK3K
7Akibwf9Ep0w2iLTcvMlBzL9TFd3EPgd9oRYkNo31TD6v3d5jxePS0/cBxbI+tpM
e8tHhhPV9LzYjw7T/2RRUy9RrzC1FZYUV67gQ+hGfnILwIv6AQHULUtVg8vmjbc2
4iL/jP9di2xP1VVHT8iYStWpIbbpsNMEjXSPAWpGeORiFB7V/giAdf/6tTi3f38D
aagrvw5Bay/LXlBcWpr6IgjWNv8ZyRonmfkaM8BrcXVmOlmPOu8WLlmhby2acWfK
GKxLervHmc4Kh9RlAxOerL/2eZi8vdeE0wDQsRfAbLqWPSriPklFEG2G4grWB2e0
ja0e8S2iocRY9V8agDhtCvCZno0YHg==
=yfsy
-----END PGP SIGNATURE-----

--5li5uzprglwpgp5b--
