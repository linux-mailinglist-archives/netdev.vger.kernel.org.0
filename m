Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762EA2FE563
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbhAUIwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbhAUIwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:52:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE25C0613C1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:51:19 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2VgK-0000y7-3Z; Thu, 21 Jan 2021 09:51:08 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:37fb:eadb:47a3:78d5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3AA0D5C9852;
        Thu, 21 Jan 2021 08:51:05 +0000 (UTC)
Date:   Thu, 21 Jan 2021 09:51:04 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Su Yanjun <suyanjun218@gmail.com>
Cc:     manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
Message-ID: <20210121085104.kp5qkllzyfu6ybtj@hardanger.blackshift.org>
References: <20210121083313.71296-1-suyanjun218@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uvdzd62yprqygzpz"
Content-Disposition: inline
In-Reply-To: <20210121083313.71296-1-suyanjun218@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uvdzd62yprqygzpz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 04:33:13PM +0800, Su Yanjun wrote:
> No functional effect.
>=20
> Signed-off-by: Su Yanjun <suyanjun218@gmail.com>

Fails to build from source:

  CC [M]  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.o
drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c: In function =E2=80=98mcp251=
xfd_get_val_bytes=E2=80=99:
drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c:187:22: error: invalid use o=
f undefined type =E2=80=98struct regmap=E2=80=99
  187 |  return priv->map_reg->format.val_bytes;
      |                      ^~
rivers/net/can/spi/mcp251xfd/mcp251xfd-core.c:188:1: error: control reaches=
 end of non-void function [-Werror=3Dreturn-type]
  188 | }
      | ^
cc1: some warnings being treated as errors

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uvdzd62yprqygzpz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAJQHUACgkQqclaivrt
76kgAwgAoJfEY57+qt577cXwMuAWcpN2BrXymJSzb3emTslNlwY0SQNVl/Y0aEmy
5ffMoyK3TyA28ztLxOCdvvSssNS2DqnjvLgOIL1xmVBAatwBnzdAPFICvKpumvsZ
OdyDrh4ZZUT55W6X7I+370f8KFSBN7XPReOHkUykZvZj1qg4S1g1DPjFVEDDTgyW
hGcTFTg2Is5V4Lwt2LXmlfCnF/l+khF6ZakDZ1A99w0KSMTD9Vua5Gx4sqEEGYRp
ap917/egq2nQkEMNqRVN0uDkS398m1mobCYvP7wf20M4fI8NyLPAM0hPgS357TBz
GPiDvWHoTR4Y2iWZUcnOnjE2slMq5g==
=VcRg
-----END PGP SIGNATURE-----

--uvdzd62yprqygzpz--
