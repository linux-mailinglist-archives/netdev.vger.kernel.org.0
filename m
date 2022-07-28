Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502D4583965
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiG1HXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiG1HX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:23:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113A35B7AD
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:23:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGxrV-0008Vr-Qp; Thu, 28 Jul 2022 09:23:13 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 946E2BC9FD;
        Thu, 28 Jul 2022 07:23:11 +0000 (UTC)
Date:   Thu, 28 Jul 2022 09:23:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/7] can: slcan: extend supported features (step 2)
Message-ID: <20220728072308.4nqpakfh4p7mqjmz@pengutronix.de>
References: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="foufu2vyxmopq526"
Content-Disposition: inline
In-Reply-To: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
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


--foufu2vyxmopq526
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.07.2022 09:02:47, Dario Binacchi wrote:
> With this series I try to finish the task, started with the series [1],
> of completely removing the dependency of the slcan driver from the
> userspace slcand/slcan_attach applications.
>=20
> The series also contains patches that remove the legacy stuff (slcan_devs,
> SLCAN_MAGIC, ...) and do some module cleanup.
>=20
> The series has been created on top of the patches:
>=20
> can: slcan: convert comments to network style comments
> can: slcan: slcan_init() convert printk(LEVEL ...) to pr_level()
> can: slcan: fix whitespace issues
> can: slcan: convert comparison to NULL into !val
> can: slcan: clean up if/else
> can: slcan: use scnprintf() as a hardening measure
> can: slcan: do not report txerr and rxerr during bus-off
> can: slcan: do not sleep with a spin lock held
>=20
> applied to linux-next.
>=20
> [1] https://lore.kernel.org/all/20220628163137.413025-1-dario.binacchi@am=
arulasolutions.com/

Thanks a lot for your work! Applied to linux-can/master.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--foufu2vyxmopq526
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLiOVoACgkQrX5LkNig
011oDAf+NvXWyUVvM5r+0vxXcpKYNPRy5EzINyaY+ob3JhoYXK3LH4fJ96/znppO
seBnubIc7iU4VG88t3m5lhZJz0xYwQa6pDd+CBOmN8o/px4v9HEm+lzHFSbWgJiG
+Fp0/UQqDoTMXXVjmG1tvjg43b5uqKi5PxzePQiKXOpItsysX8h3S9RkC9LYq60E
gPhlICtZZawRK8Yj2baaDcx7gU3HPmNO5IztLgVlFwo/m8Iw9oSye4Kv0gsctO23
Vu9XJzuZHwT2CeaZcKmJaNU9tuNGPsQFH8IHquXNaNco0nFzIVopyC91eHOOqcvj
IZWOSO6dEtUM+B0LDQYqjEFxFY5dbA==
=KdVv
-----END PGP SIGNATURE-----

--foufu2vyxmopq526--
