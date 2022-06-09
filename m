Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A05445F9
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbiFIIef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiFIIeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:34:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DAE19F040
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:34:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzDcA-00016O-Vd; Thu, 09 Jun 2022 10:34:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6F7938FDDD;
        Thu,  9 Jun 2022 08:34:01 +0000 (UTC)
Date:   Thu, 9 Jun 2022 10:34:00 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        srinivas.neeli@amd.com, neelisrinivas18@gmail.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Subject: Re: [PATCH V3 0/2] xilinx_can: Update on xilinx can
Message-ID: <20220609083400.pb5q2fxhexhdqrec@pengutronix.de>
References: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h4ux6p3yn7okbj3o"
Content-Disposition: inline
In-Reply-To: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h4ux6p3yn7okbj3o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.06.2022 13:54:31, Srinivas Neeli wrote:
> This patch series addresses
> 1) Reverts the limiting CANFD brp_min to 2.
> 2) Adds TDC support for Xilinx can driver.

Thanks for your patches!

> Hi Marc,
> Please apply PATCH V3 1/2 on stable branch.
> Due to some mailing issue i didn't receive your mail.

Applied to can/testing, please don't mix patches for can and can-next in
on series in the future.

> Changes in V3:
> -Implemented GENMASK,FIELD_PERP & FIELD_GET Calls.
> -Implemented TDC feature for all Xilinx CANFD controllers.
> -corrected prescalar to prescaler(typo).

Pleas make this a separate patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--h4ux6p3yn7okbj3o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhsHYACgkQrX5LkNig
010CkwgAr0Yn7uNWp2Rx87P8xbIi6hVYVLuyQarsLg75Xp2IjC1KG4KpIEBgY2uH
im/FjZiJvUi1TCuFCjck+qNSdA22Jfn5rk0uyEmn7g0l1BZq7UlkK1tdAHqoQ/Cn
Dcw9BMQqQfdm4btLikc4h1stqAH0CeZOwNXUkzjBga65ZmUaJIVowN55st01M1T3
qO5elkWFftg1JOsbd594rh2mSDHXB/c3+a929hrAtk1KfC96F7tL+0lSdccFFL4f
cN2+jGrt2mPCdawxZC/EGU6nr4zqCxDLsrbgMdQBkuH5l+O9ssfP3DI8MSIRuqtN
8MaCL4sqduJssOhRn9qxccN72AwhaQ==
=Q3e1
-----END PGP SIGNATURE-----

--h4ux6p3yn7okbj3o--
