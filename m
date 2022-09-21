Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6C5BF6AB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiIUGuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiIUGtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:49:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E4721803
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:49:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oatYC-0000tv-T7; Wed, 21 Sep 2022 08:49:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oatYC-0020N0-Qu; Wed, 21 Sep 2022 08:49:39 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oatYA-002Omy-Kh; Wed, 21 Sep 2022 08:49:38 +0200
Date:   Wed, 21 Sep 2022 08:49:35 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: fjes: Reorder symbols to get rid of a few forward
 declarations
Message-ID: <20220921064935.t24cjwgkesjr5ebn@pengutronix.de>
References: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
 <20220920164435.55c026d3@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s37v3qlracp5xe7m"
Content-Disposition: inline
In-Reply-To: <20220920164435.55c026d3@kernel.org>
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


--s37v3qlracp5xe7m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2022 at 04:44:35PM -0700, Jakub Kicinski wrote:
> On Sun, 18 Sep 2022 00:51:42 +0200 Uwe Kleine-K=F6nig wrote:
> > Quite a few of the functions and other symbols defined in this driver h=
ad
> > forward declarations. They can all be dropped after reordering them.
> >=20
> > This saves a few lines of code and reduces code duplication.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> Any reason why do this?

The motivation was a breakage I introduced in another driver when I
changed the prototype of a function and failed to adapt the declaration.
(See 2dec3a7a7beb ("macintosh/ams: Adapt declaration of ams_i2c_remove()
to earlier change") in today's next for the ugly details.)

Currently I work on changing the prototype for the remove callback of
platform drivers. So the patch here is prepatory work to make the latter
change easier to do and review.

> There's a ton of cobwebbed code with pointless forward declarations.

For sure I won't address all of them. But if I stumble over one and find
a few spare minutes I fix one at a time.

> Do you have the HW and plan to work on the driver?

I neither have the hardware nor do I plan to work on the driver. It's
just a platform driver I might touch at some point in the future to
adapt for a core driver change.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--s37v3qlracp5xe7m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmMqs/0ACgkQwfwUeK3K
7AnyUwgAhjo5SyezzziMGhkcCD0IKq2AQy5j/+cA0CPZuDh/MlDSdZPBTkcFnuw+
zSuL8Bl/hQFGu/wxKiBdChHGoc7qbH8LY3IwO+Soh32Qy58rRmbwnK92hJeoUv9/
ftGA6tPGFjhXhp8K71ut9kXrc6KAP2TfMYabV10cY8oqT41l4us1LQPToOjQlPEA
yy/pBotVuZVL42+Yf/wrKP9weG88MDG+aTFs02G+SUpTj/slPkYGFmj9sD3/gtmB
o/wrkkzYFiEy49hGxnav9ggeFPOunI6LfDgfnsxCgNfTu5Ufj47UQ2G7Y6gu+LGh
RWj1hpK///rLkgHtX7FAjbc0KbqLrA==
=VlP5
-----END PGP SIGNATURE-----

--s37v3qlracp5xe7m--
