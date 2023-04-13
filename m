Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297C16E0A4C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDMJcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDMJco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:32:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DDD4C3C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:32:43 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pmtJq-0004ip-4c; Thu, 13 Apr 2023 11:32:42 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BAC4E1ACB50;
        Thu, 13 Apr 2023 09:31:25 +0000 (UTC)
Date:   Thu, 13 Apr 2023 11:31:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v1 1/1] add support for Ethernet PSE and PD
 devices
Message-ID: <20230413-valium-retreat-c5e7f29ebab6-mkl@pengutronix.de>
References: <20230317093024.1051999-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iapqsxlwlp3swzfr"
Content-Disposition: inline
In-Reply-To: <20230317093024.1051999-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
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


--iapqsxlwlp3swzfr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.03.2023 10:30:24, Oleksij Rempel wrote:
> This implementation aims to provide compatibility for Ethernet PSE
> (Power Sourcing Equipment) and PDs (Powered Devices).
>=20
> In its present state, this patch offers generic PSE support for PoDL
> (Power over Data Lines 802.3bu) specifications while also reserving
> namespace for PD devices.
>=20
> The infrastructure can be expanded to include 802.3af and 802.3at "Power
> via the Media Dependent Interface" (or PoE/Power over Ethernet).
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Soft Ping. Can anyone take a look at this?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--iapqsxlwlp3swzfr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ3y+kACgkQvlAcSiqK
BOjbHgf/VI5DlVcYA1p8Yw4U/yVtEFM8lgdiXYGwgw/w7xIROiEv0dnIc+wSy8LQ
k0cBsFwzAi59qaporTWAE4E3KvXjLyQI54JL8InaFS2n+v8otKU6Lk6UnTKAlXxs
z87n6Wlon8FA1FWGVm0UA2J2GYUbs98mWR4utW5Jm8powUipBwsdY6sA91S+F/S+
wB+Lolok2+N3U7PChN8n9ZZTWJY+WFzvTSN41R7PuKm9mYQtOcj3u2eQs/6kAD0z
ge9tAk8D5UZQZiKfj2dmiq40fSziAOI1dPO4CI07Uw1/HHFF9uzN12vedpdPrI0J
R8PWA5rzAO8hwT+D1Fx0x2iRk54snw==
=Jo3p
-----END PGP SIGNATURE-----

--iapqsxlwlp3swzfr--
