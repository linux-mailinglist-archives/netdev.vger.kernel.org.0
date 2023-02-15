Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4CB6979C3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjBOKUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbjBOKU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:20:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAE537B61
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:20:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pSEtO-0000ix-SZ; Wed, 15 Feb 2023 11:20:02 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6014:f321:bfec:f7c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2E9EB17A07B;
        Wed, 15 Feb 2023 08:52:29 +0000 (UTC)
Date:   Wed, 15 Feb 2023 09:52:27 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] can: esd_usb: Some more preparation for
 supporting esd CAN-USB/3
Message-ID: <20230215085227.sqpqtzprsmpzdthu@pengutronix.de>
References: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4irvznxndggari5u"
Content-Disposition: inline
In-Reply-To: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
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


--4irvznxndggari5u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.02.2023 17:02:20, Frank Jungclaus wrote:
> Another small batch of patches to be seen as preparation for adding
> support of the newly available esd CAN-USB/3 to esd_usb.c.
>=20
> Due to some unresolved questions adding support for
> CAN_CTRLMODE_BERR_REPORTING has been postponed to one of the future
> patches.
>=20
> *Resend of the whole series as v2 for easier handling.*

As Vincent pointed out in review of a completely different patch series,
bu this applies here, too:

| For the titles, please use imperative (e.g. add) instead of past tense
| (e.g. Added). This also applies to the description.

Further, the subject ob patches 1 and 2 can be improved a bit, e.g.
patch 1 could mention to move the SJA1000_ECC_SEG for a specific reason.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4irvznxndggari5u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPsnUgACgkQvlAcSiqK
BOjykgf9GgEzqesqTvurBmGYMYtYtRIf0caqQYhbycWjabYH4DmHYEgVo73nTjjV
52eSMJ29gikMy9bNO9WW2D1VEAdGdPAwHtCWCc4z4YP5VqC0T92zdDa2K7a3Eaqp
YV2b9aQqovOHhvV5tKk1AAlqgqkj8o16o5WRnu5ZKzCwpTonHumNgOyreUPXAtJj
KCHUACfZHVdbhL5JTGWiUvdPCTCD3WAk15i10kKoQkpYBZgKBR2wKeQKwVuEAQUK
mefWPYsDG2RL8Y/k9G9O+F/HY670A9+UAGD3RzXeygjx9vwES0OZ0QjJxfZkoJ/K
sHWxHfMH9AOGIjbTyYY8lpiSjpZNhg==
=9mVM
-----END PGP SIGNATURE-----

--4irvznxndggari5u--
