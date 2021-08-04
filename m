Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC18E3DFE6D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbhHDJxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhHDJxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 05:53:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0ECC061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 02:53:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDaI-0000a8-JG; Wed, 04 Aug 2021 11:53:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 92942660752;
        Wed,  4 Aug 2021 09:53:07 +0000 (UTC)
Date:   Wed, 4 Aug 2021 11:53:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     dev.kurt@vandijck-laurijssen.be, wg@grandegger.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, David Jander <david@protonic.nl>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH v2 0/2] net: j1939: extend UAPI for RX notifications
Message-ID: <20210804095306.clain5rwtwae3gwa@pengutronix.de>
References: <20210707094854.30781-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jsatu2nnuv3rvstw"
Content-Disposition: inline
In-Reply-To: <20210707094854.30781-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jsatu2nnuv3rvstw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.07.2021 11:48:52, Oleksij Rempel wrote:
> changes v2:
> - fix size calculation for the addresses
> - make sure all J1939_NLA* have same order

Applied to linux-can-next/testing.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jsatu2nnuv3rvstw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKY38ACgkQqclaivrt
76lJHwf+JRnAS/+Bk0W1mWwgFreEDcuNZ670PjVUtGSeHGZz0stUIqL6Q1PoF+ia
RND4Vy39W14bCz9O7gD+m1NhvmQiksOiLHdOYsDF56Dnb+kNZAODYDxbijlT1/VH
fSjtdDTQpJjv33+fFvKK878UkgN6GXq244d8w+1LUlf3gPov5sgdofT0Sf7buGlZ
Gm/8ogVlMm6sP/GTSxdKas74xyFpcigDyznKsapRW2GvmpwEgmxLxLGNSkdjO7o2
SKvvo5Qi/5QSkAD2vN9hHK4E2mdrBdXf4nK/zxfRwxBC5+LeNmexe0qUzdMdSeuQ
AQ9kCYTdaLmO6AzvVRfPHS5CdcbjdQ==
=Np+y
-----END PGP SIGNATURE-----

--jsatu2nnuv3rvstw--
