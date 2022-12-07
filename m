Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605D3645678
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiLGJ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiLGJ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:29:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD262FFE0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:29:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p2qjF-0003BG-VX; Wed, 07 Dec 2022 10:28:38 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:9850:a364:9342:887])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 42D5C13868A;
        Wed,  7 Dec 2022 09:28:31 +0000 (UTC)
Date:   Wed, 7 Dec 2022 10:28:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     yang.yang29@zte.com.cn
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net, dzm91@hust.edu.cn,
        julia.lawall@inria.fr, gustavoars@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH linux-next] can: ucan: use strscpy() to instead of
 strncpy()
Message-ID: <20221207092822.d7zgkgprun5iqj5v@pengutronix.de>
References: <202212070909095189693@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mvncjmsvupsgvwxc"
Content-Disposition: inline
In-Reply-To: <202212070909095189693@zte.com.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mvncjmsvupsgvwxc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.12.2022 09:09:09, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
>=20
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
>=20
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mvncjmsvupsgvwxc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOQXLMACgkQrX5LkNig
013UFAf/a9soVoeGWc2ul0Ld/JoH7fO1zRpPbW0Qbhj96LxdIUqTELFuKnp5d6IV
WJp0UgO4hjzotCPu3oVUhlTMidJqGV7GjiroxulZPQ7Awdp6QDbB9Y9jiR7pMSTn
H57LSZXIvay01w5anzskHtSJlqtlcCRO2biw3767Dnceo7Ke+7oVG1tbOow1CUyY
bqVVSBfzfoXR0J2nGNeJ3sZmRAgYt7wn4CQ6DDP9VM7rxBrU519UE1K8fgEbKJkq
FB1DyVoa2XbhyKYj770wJ9nbszG48hdJ/H/isxpTCAj5iTqwmkxjUrVUEbDnLXpg
rYtfZ7QWNr58H4Kv/3TyC+pXFS+Fuw==
=RqTJ
-----END PGP SIGNATURE-----

--mvncjmsvupsgvwxc--
