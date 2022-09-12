Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE61B5B5A1D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiILM3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiILM3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:29:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575FB31362
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:29:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXiYo-0003Sh-5Z; Mon, 12 Sep 2022 14:29:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2D3CCE1320;
        Mon, 12 Sep 2022 12:29:06 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:28:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 0/2] Revert fec PTP changes
Message-ID: <20220912122857.b6g7r23esks43b3t@pengutronix.de>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cumpk6zhond2hzwb"
Content-Disposition: inline
In-Reply-To: <20220912070143.98153-1-francesco.dolcini@toradex.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cumpk6zhond2hzwb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.09.2022 09:01:41, Francesco Dolcini wrote:
> Revert the last 2 FEC PTP changes from Cs=C3=B3k=C3=A1s Bence, they are c=
ausing multiple
> issues and we are at 6.0-rc5.
>=20
> Francesco Dolcini (2):
>   Revert "fec: Restart PPS after link state change"
>   Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"

Nitpick: I would revert "net: fec: Use a spinlock to guard
`fep->ptp_clk_on`" first, as it's the newer patch.
>=20
>  drivers/net/ethernet/freescale/fec.h      | 11 +----
>  drivers/net/ethernet/freescale/fec_main.c | 59 +++++------------------
>  drivers/net/ethernet/freescale/fec_ptp.c  | 57 +++++++---------------
>  3 files changed, 31 insertions(+), 96 deletions(-)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cumpk6zhond2hzwb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfJgYACgkQrX5LkNig
0120hgf/bnH8SVIiFPdI9K2/SCjyTd7Ie7AaLhi8FDLAlwLOEdx16r1U5CeyH4PT
DSEpqh56UPakv2RJTXSzG+G84lrWIHQgsh1OlCvQ/xz40paVLgtY4mOJVzEObTFq
icLkkaERzHOfrI2FuNoGZB1x+eCtIvvCK5nW3aY65gGqHpxU+GZAlBmgpJqmQH4I
/sY4uS6C93RvZ1IL5QqFKJqBFYahBPNAfgba9KkgUkhwQ7M4XICAdMbKhdJXcTyz
rh8awsq3jvBqPiLZWHjga4yQ9fr+g3I1Yq6ccom1ZkFqcN9WPf7SxCZZG67d9PqQ
pkp6giiV1UgNaKC/OZALyU1ydS8cVg==
=56MK
-----END PGP SIGNATURE-----

--cumpk6zhond2hzwb--
