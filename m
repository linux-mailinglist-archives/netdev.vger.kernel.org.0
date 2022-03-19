Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D368E4DE920
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243542AbiCSPz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243538AbiCSPz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:55:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE45619C588
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:54:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nVbOY-0002zn-69; Sat, 19 Mar 2022 16:53:34 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-5e0d-31a6-08b1-9333.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5e0d:31a6:8b1:9333])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B3DDF4F317;
        Sat, 19 Mar 2022 15:53:30 +0000 (UTC)
Date:   Sat, 19 Mar 2022 16:53:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     trix@redhat.com
Cc:     mani@kernel.org, thomas.kopp@microchip.com, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] can: mcp251xfd: return errors from
 mcp251xfd_register_get_dev_id
Message-ID: <20220319155330.d62uvu47pujhjocy@pengutronix.de>
References: <20220319153128.2164120-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ynf2esusfukglzhk"
Content-Disposition: inline
In-Reply-To: <20220319153128.2164120-1-trix@redhat.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ynf2esusfukglzhk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.03.2022 08:31:28, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
>=20
> Clang static analysis reports this issue
> mcp251xfd-core.c:1813:7: warning: The left operand
>   of '&' is a garbage value
>   FIELD_GET(MCP251XFD_REG_DEVID_ID_MASK, dev_id),
>   ^                                      ~~~~~~
>=20
> dev_id is set in a successful call to
> mcp251xfd_register_get_dev_id().  Though the status
> of calls made by mcp251xfd_register_get_dev_id()
> are checked and handled, their status' are not
> returned.  So return err.
>=20
> Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD =
SPI CAN")
> Signed-off-by: Tom Rix <trix@redhat.com>

Thanks for your patch, applied to linux-can/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ynf2esusfukglzhk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmI1/HcACgkQrX5LkNig
012uEAgAhmQLM9+G2jVF/9a2t7pFA4UKyqfdbBR+4jLttIfKO6FZKMcPubSTDsw9
QxnM2nOYAufwvSmhgoNuo2/pFWV0JCrzb1DwvbeHUI4rm8JWGNIKT8IWPwznNmIi
4pHg5No4rSU4b/eUeyesiSpuqxRgUXCaZ/ReYMRUpOtc/f6vATqdTWZ1SPEq+9Cl
kBQ4BBSSLCLzFWkr01SZfUGWM3AazzUM23EPh8bx2KJ2jaki2sZxkXQAc13OSRBW
+DaRZu4Rk/DTaPXqmBGTD+5dX13d5CF/7p4l0ERJZSPJKZdZWDA3Imcn+ynGRuCJ
zbQplLUyon4OuqH+/U5tYREWRtEdMA==
=ySfD
-----END PGP SIGNATURE-----

--ynf2esusfukglzhk--
