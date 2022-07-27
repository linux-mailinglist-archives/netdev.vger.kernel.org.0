Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673095832D8
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiG0TFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiG0TFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:05:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AA3C2A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:32:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGlos-0000OO-EA; Wed, 27 Jul 2022 20:31:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 54871BC544;
        Wed, 27 Jul 2022 18:31:34 +0000 (UTC)
Date:   Wed, 27 Jul 2022 20:31:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Hao Chen <chenhao288@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Yufeng Mo <moyufeng@huawei.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/9] can: slcan: extend supported features (step 2)
Message-ID: <20220727183133.2n6b2scaahrnrgws@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2qvjhjmgxrqvnzor"
Content-Disposition: inline
In-Reply-To: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
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


--2qvjhjmgxrqvnzor
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.07.2022 23:02:08, Dario Binacchi wrote:
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
>=20
> Changes in v3:
> - Update the commit message.
> - Use 1 space in front of the =3D.
> - Put the series as RFC again.

No need to change the series to RFC again :)

> - Pick up the patch "can: slcan: use KBUILD_MODNAME and define pr_fmt to =
replace hardcoded names".
> - Add the patch "ethtool: add support to get/set CAN bit time register"
>   to the series.
> - Add the patch "can: slcan: add support to set bit time register (btr)"
>   to the series.
> - Replace the link https://marc.info/?l=3Dlinux-can&m=3D165806705927851&w=
=3D2 with
>   https://lore.kernel.org/all/507b5973-d673-4755-3b64-b41cb9a13b6f@hartko=
pp.net.
> - Add the `Suggested-by' tag.

Please post a v4 with both BTR patches dropped and add Max Staudt's
Reviewed-by to patch 3.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2qvjhjmgxrqvnzor
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLhhIIACgkQrX5LkNig
012GYggAh6V/9hqrrLehCLoGuydxrDM1rdCB2FyiwWqN+uEYbWoU/uZi5Vzn6ZKI
VSy0ML7e7/IajaxumfhSyLm+wbHnsU1RjYDAQEyBVyFtd4wF3ThKmyNQQ4g0DHVx
Rde/d0Jv+aEOedsWyF6AT4SUJk/6tuoXriKt+VIUzg7cPLszkJKe7tiPm1JwAOz3
MHmI3meaJbJw0usbt0pguj4KbU1/U8V28R4OmE+ZIaQunwc1oQziK68Q/z6QpG4L
cjd73E2aChtIgbO3Trg2MYEzOlHbSgUsUt6mMsXEm+72jXz+lfPEYBvcOVSwmMMb
8ThhDpGFZWbbfBeaa3FlW+P/NOYqFQ==
=s9bc
-----END PGP SIGNATURE-----

--2qvjhjmgxrqvnzor--
