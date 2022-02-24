Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B384C2658
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiBXIdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiBXIdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:33:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957042649B4
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:33:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9Yq-0006xs-EP; Thu, 24 Feb 2022 09:33:16 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-ef25-a96a-420c-82a6.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:ef25:a96a:420c:82a6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CA3B83C50D;
        Thu, 24 Feb 2022 08:33:15 +0000 (UTC)
Date:   Thu, 24 Feb 2022 09:33:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 17/36] can: mcp251xfd: mcp251xfd_chip_sleep():
 introduce function to bring chip into sleep mode
Message-ID: <20220224083315.bpyswlmccq7fqprz@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
 <20220223224332.2965690-18-mkl@pengutronix.de>
 <20220223202716.3c198594@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nqaokufcm7c6hnen"
Content-Disposition: inline
In-Reply-To: <20220223202716.3c198594@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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


--nqaokufcm7c6hnen
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.02.2022 20:27:16, Jakub Kicinski wrote:
> On Wed, 23 Feb 2022 23:43:13 +0100 Marc Kleine-Budde wrote:
> > This patch adds a new function to bring the chip into sleep mode, and
> > replaces several occurrences of open coded variants.
> >=20
> > Link: https://lore.kernel.org/all/20220207131047.282110-5-mkl@pengutron=
ix.de
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> Build is broken between patch 17 and patch 18 :(
>=20
> drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c: In function =E2=80=98mcp2=
51xfd_chip_stop=E2=80=99:
> drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c:644:1: error: no return st=
atement in function returning non-void [-Werror=3Dreturn-type]
>   644 | }
>       | ^
>=20

Doh! Sorry for that, fixed and sent a new pull request:

https://lore.kernel.org/all/20220224082726.3000007-1-mkl@pengutronix.de/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nqaokufcm7c6hnen
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIXQskACgkQrX5LkNig
010g2gf8CooAZ4YcCipx015UxtdU6C4YETuOWhFQrsL3B5DuQmV7qSPLZ5qDG4pP
hQ4/FxxWs5273GkyEhfPbbZjPYo/0N4sQsFZ1DS81XNRfmRb1v7tZ2ZQwnwGAfs4
mYg+UVREACOMom8n8CXcYxyfOGNGA1MQclhP9dSZL2rlIl9WjnpVeBylG0qhCoMa
15ykgB3TVxg0URyXpPcMYDwyB+qK/JV8XuAi1gvM9UUR1qTWthMwQsVcDC/BUHG/
16LdmvN/VLE79Yp5TXTbGVbZWF4zn6iB7/Re1e1yEvKiqqTgrfVkd0nDW78J9CRQ
q7A01wzR8kOH4FicRRtJvdXuMSTVoQ==
=r31Q
-----END PGP SIGNATURE-----

--nqaokufcm7c6hnen--
