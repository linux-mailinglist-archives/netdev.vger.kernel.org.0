Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017AD63165C
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 21:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKTUhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 15:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKTUhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 15:37:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0BEDF9D
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 12:37:38 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1owr4H-0008BO-D6; Sun, 20 Nov 2022 21:37:33 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owr4D-005WVs-Jw; Sun, 20 Nov 2022 21:37:30 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1owr4D-000Pot-Ox; Sun, 20 Nov 2022 21:37:29 +0100
Date:   Sun, 20 Nov 2022 21:37:25 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Angel Iglesias <ang.iglesiasg@gmail.com>,
        linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        Grant Likely <grant.likely@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 500/606] net/mlx5: Convert to i2c's .probe_new()
Message-ID: <20221120203725.je2nozmdq3bp2spi@pengutronix.de>
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
 <20221118224540.619276-501-uwe@kleine-koenig.org>
 <Y3nSPYlgl89cserh@shredder>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2hrmtg7srutfafrx"
Content-Disposition: inline
In-Reply-To: <Y3nSPYlgl89cserh@shredder>
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


--2hrmtg7srutfafrx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 20, 2022 at 09:07:41AM +0200, Ido Schimmel wrote:
> In subject: s/mlx5/mlxsw/

Hmm, I wonder how I did that, given I didn't determine the prefix by
hand. *shrug*

Thanks, I fixed that in my tree and added your Reviewed-by tag.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2hrmtg7srutfafrx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmN6kAMACgkQwfwUeK3K
7AnLDQf/QDgRkygwFrlHH43sRHoAfatIKwkP6WXVxL8ubCCgyO+REzW/pj9yIYQl
rqjmUANVRXJFbQbi/g1mf8LknpeXGbRtnpnxFGMP+jJVEU/KcpTMSIO/cPncEuDJ
Higf0lSvUEK5q8ufL+j1cJXUdw9Thil2QLrZJWyt2n3yHCpr1ZFOWT+aqEKhW3qj
ejsIPiXeeXB3SYaIO63cPS0eZbGK4f/pNX3NTqYosicGDtei/PgTl9g4JakaQpIk
nLW8VgpBjml8d2mRmfmAKuiAwDsx9Y06xVaXF6egeHaKrC1toB7Xwi/mrzRrwpyS
ZWhgoOMOwDMp3XoGjFju/T1MPqYtjQ==
=ppU8
-----END PGP SIGNATURE-----

--2hrmtg7srutfafrx--
