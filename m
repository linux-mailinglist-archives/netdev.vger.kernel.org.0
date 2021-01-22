Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5382B2FFE4C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbhAVIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbhAVIcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:32:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7134CC061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:31:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2rqa-0004fJ-MY; Fri, 22 Jan 2021 09:31:12 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:aed1:e241:8b32:9cc0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 043E05CA589;
        Fri, 22 Jan 2021 08:31:09 +0000 (UTC)
Date:   Fri, 22 Jan 2021 09:31:09 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Su Yanjun <suyanjun218@gmail.com>
Cc:     manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
Message-ID: <20210122083109.7gyxdwi2dlo3ptjj@hardanger.blackshift.org>
References: <20210122081334.213957-1-suyanjun218@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5h6qemvvzzz5qhue"
Content-Disposition: inline
In-Reply-To: <20210122081334.213957-1-suyanjun218@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5h6qemvvzzz5qhue
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 22, 2021 at 04:13:34PM +0800, Su Yanjun wrote:
> The sizeof(u32) is hardcoded. It's better to use the config value in
> regmap.
>=20
> It increases the size of target object, but it's flexible when new mcp ch=
ip
> need other val_bytes.
>=20
> Signed-off-by: Su Yanjun <suyanjun218@gmail.com>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5h6qemvvzzz5qhue
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAKjUoACgkQqclaivrt
76m+Cwf/QmCkqwzxOCPGlj7JWUKqIeOMCNJWBFJzqnV6mMaihyIwiPHsollFQpyE
tmmZl2bcJ+N1zq2BfDQiK/3WksXbIgqhFg5gGhhgfA/Co4i9wq/EsgJcocKb0+Zq
fl5R2JZKDQf8h2GN/qOP96+vUnXie8vr6cKpExlPH2Nm4cmC0ekjW0kYb33XNkvo
E5XzfdewZBOoyxb50nFn/yvkM3GxirMlR3NhvVp4sQxugzpWCkekBcOseMiWY2Sp
xt3sLwZfLoOblu791qIB+2uAWwJgG5V2UJWwTZMRI2eT/mDeKuIePFn9LH+w2Wgv
6jrwq/1o8+CjBNw5CEbSdLttBQ/d+w==
=YbTG
-----END PGP SIGNATURE-----

--5h6qemvvzzz5qhue--
