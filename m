Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51013DFBFD
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhHDHVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbhHDHVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 03:21:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832F6C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 00:21:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBBD5-00075N-7L; Wed, 04 Aug 2021 09:21:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E25D96605B5;
        Wed,  4 Aug 2021 07:20:59 +0000 (UTC)
Date:   Wed, 4 Aug 2021 09:20:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Angelo Dureghello <angelo@kernel-space.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: can: flexcan: add mcf5441x support
Message-ID: <20210804072058.vechdbtfcdz66rmz@pengutronix.de>
References: <7c80c17f-e38a-8fb1-f3c7-987187a2c4d8@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ujbc5qq3llttedpi"
Content-Disposition: inline
In-Reply-To: <7c80c17f-e38a-8fb1-f3c7-987187a2c4d8@canonical.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ujbc5qq3llttedpi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.08.2021 16:23:26, Colin Ian King wrote:
> I'm not sure if it's possible for priv->clk_ipg and priv_clk_per to both
> be null, so I'm not sure if err can end up being not set. However, it
> does seem that either err should be zero or some err value, but I was
> unsure how err should be initialized in this corner case. As it stands,
> err probably needs to be set just to be safe.

ACK - There was already a patch that fixes the problem, but I've not
included it in a pull request:

https://lore.kernel.org/linux-can/20210728075428.1493568-1-mkl@pengutronix.=
de/

Will send now one.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ujbc5qq3llttedpi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKP9cACgkQqclaivrt
76nhcQf+JviYcYhXs2AfGXxhXa1mOiIyxbhtAdJofmRGNZosFUBcRk7VUI8t4e8B
f9bZ1kVN3VwybiLQoYdxeAHcoSCEC0DYFoAuJlQFuOC5wsk3b0/lph/aK8D37Z4d
+cqxEdhu95JgZDDROYwYabWIN0vuym5jPAqyGKwvbvbBVxShHhpQrEbimZq4eENR
9OImRAkrjyP3v90E8scC4aupHcrsGmiDPZTSvqw1KOqK4hKYwl/wzgiIoB7QWftL
5+vHqrLqejpmhCYaHsF6UvLAd5rg2+3nyu83r9o5stuMKn7c0o4lDezpA/S0hi8x
0cVLp12P4s5rJCJkJ04lZmZLYQ11kQ==
=V9nl
-----END PGP SIGNATURE-----

--ujbc5qq3llttedpi--
