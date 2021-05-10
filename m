Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B7E378FB6
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhEJNw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243354AbhEJNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:46:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C1C061346
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:29:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lg5yX-0001Bg-K8; Mon, 10 May 2021 15:29:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:80ab:77d5:ac71:3f91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 638ED6215A8;
        Mon, 10 May 2021 13:29:32 +0000 (UTC)
Date:   Mon, 10 May 2021 15:29:31 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] can: c_can: remove the rxmasked unused variable
Message-ID: <20210510132931.aic2kbk5ehu5un2m@pengutronix.de>
References: <20210509124309.30024-1-dariobin@libero.it>
 <20210509124309.30024-2-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xz453uakwv65dvln"
Content-Disposition: inline
In-Reply-To: <20210509124309.30024-2-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xz453uakwv65dvln
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.05.2021 14:43:07, Dario Binacchi wrote:
> Initialized by c_can_chip_config() it's never used.
>=20
> Signed-off-by: Dario Binacchi <dariobin@libero.it>

applied to linux-can-next/testing

thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xz453uakwv65dvln
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCZNTkACgkQqclaivrt
76nx4Af/VJfRs/tZ2XnRazx5qKveRojEk7IALkZJt29jlu0wXxedhtoEKXCcgTBT
1KZtQdS6VO4q15tjhk7A/WJmTh1MGKDFw5dQoHpQF1fhJqZhqNS2XOZ9iABiGoU7
fX2Z3+sRVgM4bQu9x9QzjU5h6oSwarupH3UvxPj9x1RdxOd2tvOc54ih2okmjsbN
9pa3IUrFf4MPmpDt8OU3IAdzxFR2Y4O0kJQszRqTYoKGptog7L5vUFD5uVx+IknE
WVbF518otNqv9+6yT1oEvxq7aSEv+Zux5Ohx66APM70HiBZiEpIEEDwX5KOoBjtD
vTTpzJYYMp2ZKdzhSy4Il8pacrRWCw==
=Z/lu
-----END PGP SIGNATURE-----

--xz453uakwv65dvln--
