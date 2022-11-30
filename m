Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404A763D3E5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiK3LCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiK3LCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:02:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B314A7460E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:01:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0Kqc-0006WK-76; Wed, 30 Nov 2022 12:01:50 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:38ad:958d:3def:4382])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7752412DD7C;
        Wed, 30 Nov 2022 11:01:47 +0000 (UTC)
Date:   Wed, 30 Nov 2022 12:01:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     ye.xingchen@zte.com.cn
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn
Subject: Re: [PATCH] can: c_can: use devm_platform_get_and_ioremap_resource()
Message-ID: <20221130110146.seyu6e37ynpqjzyr@pengutronix.de>
References: <202211111443005202576@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qgpjgmca727svylu"
Content-Disposition: inline
In-Reply-To: <202211111443005202576@zte.com.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qgpjgmca727svylu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.11.2022 14:43:00, ye.xingchen@zte.com.cn wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to devm_platform_get_and_ioremap_resource(), as this is exactly
> what this function does.
>=20
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Added to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qgpjgmca727svylu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHOBcACgkQrX5LkNig
013gXQf9H84qEBUKbv92KTcKZspx2AHMMxw21HBVtC7ahAp3FXEtkgsHgSchUYAy
QBXYjHa/qMKPBxg73YvK1laDF80w10hAQaXxqhS1OiuLo4AMMYUqqMP9Uk/zsAoq
6q4inCgLnaH6BfTAfCHezfjbN3K7c+Ze++TEssW9do5d+UHXOVByZv6XtkvW9Hvh
cEOizyF6BJWCQ0j8rq1XWmV2rMZiQ/bus5ik6hj/wrVYdKwGTgozk4gM2FA/MCAH
Reb2vJkZnY3j86Q9nsAaDhOIgdurnYWg9vWxoYdenSU+ng0ffEsCXeXLywCuQOnr
duzZpXD8SIL2MTroTSk4Yk9ShQ6pLw==
=HSD9
-----END PGP SIGNATURE-----

--qgpjgmca727svylu--
