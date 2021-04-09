Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F81359F91
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhDINKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbhDINKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:10:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672F6C061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 06:10:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lUqtf-0007oz-Oa; Fri, 09 Apr 2021 15:10:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e35b:267f:b46f:b43f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 94C7F60B442;
        Fri,  9 Apr 2021 13:10:02 +0000 (UTC)
Date:   Fri, 9 Apr 2021 15:10:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Koen Vandeputte <koen.vandeputte@citymesh.com>
Cc:     linux-can@vger.kernel.org, wg@grandegger.com,
        netdev@vger.kernel.org, qiangqing.zhang@nxp.com,
        gregkh@linuxfoundation.org
Subject: Re: flexcan introduced a DIV/0 in kernel
Message-ID: <20210409131001.7r36v2vd3zmceloj@pengutronix.de>
References: <5bdfcccb-0b02-e46b-eefe-7df215cc9d02@citymesh.com>
 <27f66de1-42bc-38d9-8a1c-7062eb359958@pengutronix.de>
 <f7ba143a-58c8-811a-876e-d494c4681537@citymesh.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pir2bzxakkou25dt"
Content-Disposition: inline
In-Reply-To: <f7ba143a-58c8-811a-876e-d494c4681537@citymesh.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pir2bzxakkou25dt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.04.2021 14:55:59, Koen Vandeputte wrote:
>=20
> On 09.04.21 13:21, Marc Kleine-Budde wrote:
> > On 4/9/21 12:18 PM, Koen Vandeputte wrote:
> > > Hi All,
> > >=20
> > > I just updated kernel 4.14 within OpenWRT from 4.14.224 to 4.14.229
> > > Booting it shows the splat below on each run. [1]
> > >=20
> > >=20
> > > It seems there are 2 patches regarding flexcan which were introduced =
in
> > > 4.14.226
> > >=20
> > > --> ce59ffca5c49 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
> > > --> bb7c9039a396 ("can: flexcan: assert FRZ bit in flexcan_chip_freez=
e()")
> > >=20
> > > Reverting these fixes the splat.
> > This patch should fix the problem:
> >=20
> > 47c5e474bc1e can: flexcan: flexcan_chip_freeze(): fix chip freeze for m=
issing
> > bitrate
> >=20
> > Greg, can you pick this up for v4.14?
> >=20
> > regards,
> > Marc
> >=20
> Checking kernels 4.4 & 4.9 shows that this fix is also missing over there.
>=20
> Marc,
> Can you confirm that it's also required for these?

ACK, the fix is needed for v4.4.265 and v4.9.265.

Thanks for checking this,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pir2bzxakkou25dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBwUicACgkQqclaivrt
76ntwgf/ZszwewI5LFOBytekzBJRkx1XzpPw7/eqSfQjC/Hg2qjHyVlZYgVwx53n
cVAUQh6x1pWBfut0/wsMO9K2ce3YB0cy64M9+uB2EBhe80lzYiwDFyCKisYoJWso
gStj3vor1qgLJo7z0YtX3c4bs4jgSwxxC5slfYlat3S/DYiArBKF9rc1Aw/3jb9q
F5dckmL8LYhkldEmoSpMgq2LxBPw7aONKRWYKUUw15MArHQcDtGjqMan7F0UImbq
Z+t3UA2O8cA3xoLK6Ln1qc6nstlkByo1uwA6RNH9+NDO2uOLf64iXZTgexAFoZ/+
K5Fg4Ok1PcEyZP6G+kfJHpNRzPURog==
=kRSP
-----END PGP SIGNATURE-----

--pir2bzxakkou25dt--
