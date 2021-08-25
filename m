Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0D53F6F79
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbhHYG11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbhHYG1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:27:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBD1C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 23:26:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mImMn-0007hy-5R; Wed, 25 Aug 2021 08:26:29 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-b509-65fb-e781-8611.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:b509:65fb:e781:8611])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EC21666E870;
        Wed, 25 Aug 2021 06:26:25 +0000 (UTC)
Date:   Wed, 25 Aug 2021 08:26:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        geert+renesas@glider.be, prabhakar.mahadev-lad.rj@bp.renesas.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: rcar: Kconfig: Add helper dependency on COMPILE_TEST
Message-ID: <20210825062625.afnxhdbwdjacbca5@pengutronix.de>
References: <20210825062341.2332-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ql72rxdwswt3fxcc"
Content-Disposition: inline
In-Reply-To: <20210825062341.2332-1-caihuoqing@baidu.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ql72rxdwswt3fxcc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.08.2021 14:23:41, Cai Huoqing wrote:
> it's helpful for complie test in other platform(e.g.X86)
>=20
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Applied to linux-can-next/testing

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ql72rxdwswt3fxcc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEl4o4ACgkQqclaivrt
76mZIAf8COFPwyk1hHgc3XeEeWOGGVFq/DYoiKR9RpjXdpVFI8LXajTgAmdCXvFv
ZZCeKTYVVYzFhmxMsGXmB9dsFkezNEpEmjUEuJ3st0TSBQNADBi/dBR+Mry0EMIM
wyVGp7PVHTQG342IvgTn9HgCyRwJfr28lEs/TCrhk6crZUm7o2FfCC4Ge3BmpUln
AIX2nePUs4Q3MUGj8D8HEPId2hNuUbJMvPWsKczqhcRAGeL/5+sZqyGOwyf6Krn1
t+SIV11umeGOkfz+25Q4pt76DB87tbGLvka0TIQlwSNdIp0uZFDrVjF03atV5gKs
iMNnVB+hotJ87SdLO9yoH/1H1x8U9A==
=8tJw
-----END PGP SIGNATURE-----

--ql72rxdwswt3fxcc--
