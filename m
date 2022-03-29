Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD554EA780
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiC2FtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiC2FtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:49:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2259329A7
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 22:47:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nZ4hH-0007yN-PW; Tue, 29 Mar 2022 07:47:15 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nZ4hD-003jKy-B6; Tue, 29 Mar 2022 07:47:14 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nZ4hF-00CVon-BF; Tue, 29 Mar 2022 07:47:13 +0200
Date:   Tue, 29 Mar 2022 07:47:10 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: fec: Do proper error checking for enet_out
 clk
Message-ID: <20220329054710.rw75gc74wunsf7ms@pengutronix.de>
References: <20220325165543.33963-1-u.kleine-koenig@pengutronix.de>
 <20220328160910.3eb8fb87@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hcqgpzllmsexx23b"
Content-Disposition: inline
In-Reply-To: <20220328160910.3eb8fb87@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hcqgpzllmsexx23b
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 28, 2022 at 04:09:10PM -0700, Jakub Kicinski wrote:
> On Fri, 25 Mar 2022 17:55:43 +0100 Uwe Kleine-K=F6nig wrote:
> > An error code returned by devm_clk_get() might have other meanings than
> > "This clock doesn't exist". So use devm_clk_get_optional() and handle
> > all remaining errors as fatal.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > this isn't urgent and doesn't fix a problem I encountered, just noticed
> > this patch opportunity while looking up something different in the
> > driver.
>=20
> Would you mind reposting after the merge window?=20
> We keep net-next closed until -rc1 is cut.

I somehow expected there is an implicit queue of patches that is
processed once net-next opens again. But sure, will resend after -rc1.

Best regards
Uwe

--hcqgpzllmsexx23b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmJCnVoACgkQwfwUeK3K
7Ak3YQf6AkxfmRR5IN+h75es0GvSoXTPgX9o1kJGtpLDx0J9MDMYCrUY1lSrY9zQ
TlISlu0mI2cAt5oyYIvbWg4Aj/BbJJ+Q8YEuA4AmsmKx7YBWKGDDKUYFwgpKQBWm
yFFVFG9/JPbKXmA9kVIIpTe7uarFWxIE+lwkwrCsyUXEk7DX/PB9fjCZworrKFr6
/lt+JJH8ZfYNHcpTV9bpJsDORwmDuc+EoBC88sRT9mjlx+h1DITmnmtmm7+w3S8M
HeAREzmao8DHR6TwqQQ33Het4OqoXu5+zFUwG1GguhaZcvAZoIsxwjHX/xFmc18T
+GwqeklgEtrbZsfSVWLBiDALp2UdSQ==
=xiXf
-----END PGP SIGNATURE-----

--hcqgpzllmsexx23b--
