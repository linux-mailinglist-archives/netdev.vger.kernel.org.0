Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA6699D59
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBPUFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBPUFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:05:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5776497FB
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:05:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pSkVX-00064S-R0; Thu, 16 Feb 2023 21:05:31 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:607c:35c5:286c:4c04])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BB85217B6B3;
        Thu, 16 Feb 2023 20:05:30 +0000 (UTC)
Date:   Thu, 16 Feb 2023 21:05:29 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] can: esd_usb: Some more preparation for
 supporting esd CAN-USB/3
Message-ID: <20230216200529.4l575byozepn5eui@pengutronix.de>
References: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dkexnjhh6bovflqu"
Content-Disposition: inline
In-Reply-To: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dkexnjhh6bovflqu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.02.2023 20:04:47, Frank Jungclaus wrote:
> Another small batch of patches to be seen as preparation for adding
> support of the newly available esd CAN-USB/3 to esd_usb.c.
>=20
> Due to some unresolved questions adding support for
> CAN_CTRLMODE_BERR_REPORTING has been postponed to one of the future
> patches.
>=20
> *Resend of the whole series as v3 for easier handling.*

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dkexnjhh6bovflqu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPujIYACgkQvlAcSiqK
BOieBQf/b3CSt6LPL/bkjmZsXT7fNScDbJPZVxd/w9Jlg1wOcMohFAZtsaXzeIA3
4e7rAD3nMgt/0AfsD5F9O36cadKjOXFyLgBkFP0Itagkutglo+v8n0/Oqlco+mYe
znsLgeDCYnj+P82nkYSdcnB9gMMZ8j9mluwnRBxvcSWCHqG24ucYe3/FXob9deSm
1euBQ71uga0u1nqdQZp7/viuiPK9g1kaCDxGlTrc24zWkPGBXD548e/RggJnNTJH
I+q+cVqxIAKFOghGPoozY0/xEMHYPwyqYY725Rn1UjNaER+YI7xB+6JTGfiVTDxZ
po3Zfc1jGKmDFv4YAXDVGJXsKouP9g==
=h+DM
-----END PGP SIGNATURE-----

--dkexnjhh6bovflqu--
