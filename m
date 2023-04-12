Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7E6DFC52
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjDLRLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDLRLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:11:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB5C658C
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:11:19 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pmdzp-0001ho-BG; Wed, 12 Apr 2023 19:11:01 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pmdzm-00AmwQ-36; Wed, 12 Apr 2023 19:10:58 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pmdzk-00CfNB-OC; Wed, 12 Apr 2023 19:10:56 +0200
Date:   Wed, 12 Apr 2023 19:10:56 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Roy Pledge <Roy.Pledge@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de, dmaengine@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Message-ID: <20230412171056.xcluewbuyytm77yp@pengutronix.de>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2x2mx27jq2zwvoxs"
Content-Disposition: inline
In-Reply-To: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2x2mx27jq2zwvoxs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, Mar 10, 2023 at 11:41:22PM +0100, Uwe Kleine-K=F6nig wrote:
> Hello,
>=20
> many bus remove functions return an integer which is a historic
> misdesign that makes driver authors assume that there is some kind of
> error handling in the upper layers. This is wrong however and returning
> and error code only yields an error message.
>=20
> This series improves the fsl-mc bus by changing the remove callback to
> return no value instead. As a preparation all drivers are changed to
> return zero before so that they don't trigger the error message.

Who is supposed to pick up this patch series (or point out a good reason
for not taking it)?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2x2mx27jq2zwvoxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmQ25h8ACgkQj4D7WH0S
/k7l+Af+N5+aCs46B4ridehobQBafv9tZPTtFGoBY5sC3oXI6o1esrrE+v65jjyp
+6c8u6nhgNeTebXzIxFZRF5wUcD+7uIAD+ZomoHHX7CJ83BoYu0ifciGJOIC15r5
j5AnkV0+1vzfztf5wozUdHsk/m+PKeRgKLzvJ2z7HmFShucihqWRGFUkdu9+DIw4
0hxxi+Y0L+5iuoKcXmrFi28Rid2oVDjeSYvkQTsWtp3l/4Gtu2Dqc0hW2hU66NmG
6rOxQ24mymBgwEc0XyR0uBq+/1YBdKzJOFjjH3ilQNzWb66Spxl1q74K0karyFcS
rEZESsixkY8yP2PuyQt8FJxICwYcXQ==
=BATw
-----END PGP SIGNATURE-----

--2x2mx27jq2zwvoxs--
