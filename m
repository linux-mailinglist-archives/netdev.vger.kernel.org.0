Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C636BA23D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjCNWRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjCNWRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:17:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534F63D900
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:16:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcCvN-0007Qo-3e; Tue, 14 Mar 2023 23:15:17 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcCvG-004Afk-5X; Tue, 14 Mar 2023 23:15:10 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcCvF-004vG9-JQ; Tue, 14 Mar 2023 23:15:09 +0100
Date:   Tue, 14 Mar 2023 23:15:08 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de
Subject: Re: [PATCH net-next 4/9] net: fec: Convert to platform remove
 callback returning void
Message-ID: <20230314221508.lhumfl3y3qrybqj2@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-5-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2k66syviotczz2nl"
Content-Disposition: inline
In-Reply-To: <20230313103653.2753139-5-u.kleine-koenig@pengutronix.de>
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


--2k66syviotczz2nl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Mar 13, 2023 at 11:36:48AM +0100, Uwe Kleine-K=F6nig wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

FTR: This patch depends on patch 2 of this series which has issues. So
please drop this patch, too. Taking the other 7 patches should be fine
(unless some more issues are discovered of course).

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2k66syviotczz2nl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQQ8ekACgkQwfwUeK3K
7AmJzwf6AqdmPgWtFz2BvFhLiYVByFd/VUF0ElPQ+jfG2/pNZFpEROtlIgAvC4U+
TOZLYZ9fPSd7GZhPDPMdmjV2Hsf0W+BkAbhoq763hxFPuAMzKc+I5VgsIuhFw0Js
HTTC0IOSWqBZsMq645pT3DBY2yADDbHq3OTBpDHvdVttW/L/X3RgGu7zQf9KsVWx
LEzMzGlyrjm59/gyGRAkkg186MzIP4XV7S2rNTQ0l7T0+0H+uC/EIkmwjzzrK6Hc
ZBow9PmoZ2O1NQTt/k/wx9fsjpkZirOrPay89NR1D2UNcytEwCTBqSdVMfrbxfmG
eGYXF2oLa+LfXBioNmVR+un3DRRWXA==
=BzD+
-----END PGP SIGNATURE-----

--2k66syviotczz2nl--
