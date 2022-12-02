Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7C640912
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiLBPN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbiLBPNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:13:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F26BB7C1
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 07:13:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p17jG-0005zw-Mv; Fri, 02 Dec 2022 16:13:30 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5D0E413176E;
        Fri,  2 Dec 2022 15:13:29 +0000 (UTC)
Date:   Fri, 2 Dec 2022 16:13:20 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] can: esd_usb: Allow REC and TEC to return to zero
Message-ID: <20221202151320.7pimdtgqehi4x77k@pengutronix.de>
References: <20221130202242.3998219-1-frank.jungclaus@esd.eu>
 <20221130202242.3998219-2-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zbmgx7pa7b3psdf2"
Content-Disposition: inline
In-Reply-To: <20221130202242.3998219-2-frank.jungclaus@esd.eu>
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


--zbmgx7pa7b3psdf2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.11.2022 21:22:42, Frank Jungclaus wrote:
> We don't get any further EVENT from an esd CAN USB device for changes
> on REC or TEC while those counters converge to 0 (with ecc =3D=3D 0).
> So when handling the "Back to Error Active"-event force
> txerr =3D rxerr =3D 0, otherwise the berr-counters might stay on
> values like 95 forever ...
>=20
> Also, to make life easier during the ongoing development a
> netdev_dbg() has been introduced to allow dumping error events send by
> an esd CAN USB device.
>=20
> Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>

Added to linux-can. It will go into the net/master after v6.1.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zbmgx7pa7b3psdf2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKFg0ACgkQrX5LkNig
010xqQf+KEMYSuEJz87Zms6RXIkVZFKmW8TXTACOZazR4adl2kyi+FwSwp3TmD1a
hurLZLlXR6v475v0rdPebdtUpEk/glg9FfdHhQuCUL+eHEUEkOC0Ou/Yrqsnkl75
25k/+qzmXKo4Wcf1g5lRCRku76kybdbkPyhlLzqx9qzuZREkZ1vjXGFYTFbBYnTJ
XOeCDKqker45QQ2Zh7pQjxI8Alg/CGOGpkgpUhZBohWpS5Vcmric2t7Le10Dnikd
BB3vion2stmKazY3iK6SeihDp4EkvbT08V05ptnD1EJ77FlAaX+AAXegKSIeDXmG
91o3GwICCcr6tWeKDBNu88/HE1sLUQ==
=48WK
-----END PGP SIGNATURE-----

--zbmgx7pa7b3psdf2--
