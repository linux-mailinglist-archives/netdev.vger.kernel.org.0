Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A612FFD78
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbhAVHgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbhAVHgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:36:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7EAC0617A7
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:35:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2qxq-0007E4-Mh; Fri, 22 Jan 2021 08:34:38 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:aed1:e241:8b32:9cc0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9F94B5CA50A;
        Fri, 22 Jan 2021 07:34:32 +0000 (UTC)
Date:   Fri, 22 Jan 2021 08:34:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v1 2/2] isa: Make the remove callback for isa drivers
 return void
Message-ID: <20210122073431.a3igyqh3rucmiy5y@hardanger.blackshift.org>
References: <20210121204812.402589-1-uwe@kleine-koenig.org>
 <20210121204812.402589-3-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zjvnr6y4kfwj4bce"
Content-Disposition: inline
In-Reply-To: <20210121204812.402589-3-uwe@kleine-koenig.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zjvnr6y4kfwj4bce
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 09:48:12PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> The driver core ignores the return value of the remove callback, so
> don't give isa drivers the chance to provide a value.
>=20
> Adapt all isa_drivers with a remove callbacks accordingly; they all
> return 0 unconditionally anyhow.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org>
> ---
>  drivers/net/can/sja1000/tscan1.c     | 4 +---

For the can driver:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zjvnr6y4kfwj4bce
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAKgAUACgkQqclaivrt
76nKFwf/Qh+ytJZ22nqfhmCPbPHzMEovze0rf40PzuBbydukQ2E77J1a91Ol+M6I
1ETmnULm8kVPDDxAcJDMCpVjyMJxgwLzxAFUbO/AXMpj94QvNurQZQfJvFSuDDIi
b8bMue+b3+Bir9bDAQW+GAfmyMa6ARm5kpQFvnnMvLOerD9r3iPfMvMFmAM3tlpJ
QBlvhC3avamtLNyYuNZUDq4Mq8AqsJOHy+0GHptbO7JGN6TS7tkuUo4blKU4XI2j
JizmoGti3M6q+jHuUDOnLpHh6JDaetW68A+M4ggQIhoFVEvbS93ROd8v7exaUwrK
f/iFuhnPc/++doJnCc4XvQg1N02pYA==
=HgrA
-----END PGP SIGNATURE-----

--zjvnr6y4kfwj4bce--
