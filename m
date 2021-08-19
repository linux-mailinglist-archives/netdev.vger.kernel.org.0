Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EFD3F1719
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhHSKJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbhHSKJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:09:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F45DC061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 03:08:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGeyL-00046Q-5R; Thu, 19 Aug 2021 12:08:29 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:5b60:c5f4:67f4:2e1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D119A66A59E;
        Thu, 19 Aug 2021 10:08:27 +0000 (UTC)
Date:   Thu, 19 Aug 2021 12:08:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 7/7] can: etas_es58x: clean-up documentation of struct
 es58x_fd_tx_conf_msg
Message-ID: <20210819100826.hplvfua3il34co5r@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-8-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hvqy3gn7ubyds7r6"
Content-Disposition: inline
In-Reply-To: <20210815033248.98111-8-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hvqy3gn7ubyds7r6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.08.2021 12:32:48, Vincent Mailhol wrote:
> The documentation of struct es58x_fd_tx_conf_msg explains in details
> the different TDC parameters. However, those description are redundant
> with the documentation of struct can_tdc.
>=20
> Remove most of the description.
>=20
> Also, fixes a typo in the reference to the datasheet (E701 -> E70).

As suggested, applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hvqy3gn7ubyds7r6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEeLZgACgkQqclaivrt
76mvRAgAiB/sXimDfkDeoDlS3EJsgnT7BBWlC7ax98NJuH4M1tiSbhDjrVnuGqd/
Ex2wPz5VCKa8yLq/eueLnkMTLF82RpO1xnfBnh5K+VKv6a9lUJLXnJWJ0ZsefkE1
8vTSD/8O1HdS0okrL54JEOWRXCrlB/c5mEjWPxhUoXMnW6Atrol0d79xgbNrkN5C
9EHX/0YDyKJqT+eLaPBMAmBTiY3lR77f5x5d7ldcjAVUUZQrJJK69wRYdlpeuLBk
pXI/O0ERbXECsnXsKfTHcgnXrHIBj0wKkrhtgd/qR3wYw1e4EVh7AR+TK8S0NF50
2zHid4xfSvfVa4TNAU9ovoaMqIpTRA==
=GAgJ
-----END PGP SIGNATURE-----

--hvqy3gn7ubyds7r6--
