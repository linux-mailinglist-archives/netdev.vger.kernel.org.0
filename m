Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3113458BC
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCWHcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhCWHby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:31:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5205C061756
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 00:31:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lObVz-0005mg-FY; Tue, 23 Mar 2021 08:31:47 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:c81e:25b5:b851:4b31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E8F295FDBF1;
        Tue, 23 Mar 2021 07:30:49 +0000 (UTC)
Date:   Tue, 23 Mar 2021 08:30:49 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Dan Murphy <dmurphy@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] net: can: Remove duplicate include of regmap.h
Message-ID: <20210323073049.xtsa4qfquezickon@pengutronix.de>
References: <20210323021026.140460-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2x7tt3dycidjeo77"
Content-Disposition: inline
In-Reply-To: <20210323021026.140460-1-wanjiabing@vivo.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2x7tt3dycidjeo77
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.03.2021 10:10:25, Wan Jiabing wrote:
> linux/regmap.h has been included at line 13, so remove the=20
> duplicate one at line 14.

applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2x7tt3dycidjeo77
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBZmSYACgkQqclaivrt
76k9hgf9E1gyqjyXoEpiqFqSf7ZDUNLduopZyW4BCvi6dF4SoZnaFmgPLbRuZTup
n4/0ylnbQ7Y4T/5Yyzv7nXaZlr9SLP86uAS+pqUzlQiKl0+Woz3c9SSvjaJDdrvu
BZEbBx2Bhc0olUgFvuJsHMbgC7VSpQHqLOTpszYJGu14fd2u4CNawknJtNAUP8Bs
emBNEA0Yq6nic70t16UhrPzjlUgZfhDDj0BBFyu1CBrBb5Vq3GG/3A74sVneVhvW
BsSfZTpl1i1+IyFi+FXDi2tJ4SML7d4tAKV2G8COP8sEnrlBp5mubw3NUH7JRz3l
mU9iAbLp5LCCKhdJubnUCP7e+FNQpQ==
=05VG
-----END PGP SIGNATURE-----

--2x7tt3dycidjeo77--
