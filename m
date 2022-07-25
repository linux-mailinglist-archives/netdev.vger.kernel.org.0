Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A157FF14
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiGYMiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbiGYMiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:38:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82426DEFD
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:38:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oFxLc-0004gS-Ep; Mon, 25 Jul 2022 14:38:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 68AB6B98C1;
        Mon, 25 Jul 2022 12:38:05 +0000 (UTC)
Date:   Mon, 25 Jul 2022 14:38:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Max Staudt <max@enpas.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/6] can: slcan: remove legacy infrastructure
Message-ID: <20220725123804.ofqpq4j467qkbtzn@pengutronix.de>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
 <20220725065419.3005015-3-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e3oacdo4nyrbeooo"
Content-Disposition: inline
In-Reply-To: <20220725065419.3005015-3-dario.binacchi@amarulasolutions.com>
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


--e3oacdo4nyrbeooo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2022 08:54:15, Dario Binacchi wrote:
> Taking inspiration from the drivers/net/can/can327.c driver and at the
> suggestion of its author Max Staudt, I removed legacy stuff like
> `SLCAN_MAGIC' and `slcan_devs' resulting in simplification of the code
> and its maintainability.
>=20
> The use of slcan_devs is derived from a very old kernel, since slip.c
> is about 30 years old, so today's kernel allows us to remove it.
>=20
> The .hangup() ldisc function, which only called the ldisc .close(), has
> been removed since the ldisc layer calls .close() in a good place
> anyway.
>=20
> The old slcanX name has been dropped in order to use the standard canX
> interface naming. It has been assumed that this change does not break
> the user space as the slcan driver provides an ioctl to resolve from tty
> fd to netdev name.

Is there a man page that documents this iotcl? Please add it and/or the
IOCTL name.

> The `maxdev' module parameter has also been removed.
>=20
> CC: Max Staudt <max@enpas.org>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
> Changes in v2:

Nitpick:
Changes since RFC: https://lore.kernel.org/all/20220716170007.2020037-1-dar=
io.binacchi@amarulasolutions.com

> - Update the commit description.
> - Drop the old "slcan" name to use the standard canX interface naming.
>=20
>  drivers/net/can/slcan/slcan-core.c | 318 ++++++-----------------------
>  1 file changed, 63 insertions(+), 255 deletions(-)
>=20
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/s=
lcan-core.c
> index c3dd7468a066..2c546f4a7981 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c

[...]

> @@ -898,72 +799,49 @@ static int slcan_open(struct tty_struct *tty)
>  	if (!tty->ops->write)
>  		return -EOPNOTSUPP;
> =20
> -	/* RTnetlink lock is misused here to serialize concurrent
> -	 * opens of slcan channels. There are better ways, but it is
> -	 * the simplest one.
> -	 */
> -	rtnl_lock();
> +	dev =3D alloc_candev(sizeof(*sl), 1);
> +	if (!dev)
> +		return -ENFILE;
> =20
> -	/* Collect hanged up channels. */
> -	slc_sync();
> +	sl =3D netdev_priv(dev);
> =20
> -	sl =3D tty->disc_data;
> +	/* Configure TTY interface */
> +	tty->receive_room =3D 65536; /* We don't flow control */
> +	sl->rcount   =3D 0;
> +	sl->xleft    =3D 0;

Nitpick: Please use 1 space in front of the =3D.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--e3oacdo4nyrbeooo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLejqkACgkQrX5LkNig
010mfgf/cH0YEhypTig+kCqgox8q4agiCCilkZAvzfxC/Krv3IF286RMEQTCQEXW
gNG6EGyWJ63niB/Kum4fsG3Rbb7DxiTcjMqqALC7fWmJ1mKro6/lSN2SbO8LAU2B
FCa3Cd3HujrZpbaiTo+DXIwQptbEH32GAFWqUL3Pr5IeclMMiaPeAxpPgTXYyP6/
UqOldpT16NDyk+HdxPoieUPkK4ULcUqj7sAJzmPf+1rQWPZCPmFDI9K1l63ZswRz
Eoh0S6j1LOKBzYLMmjSyNXts4iEDgxAOpkc188o4vkja9Y0fJghhany+/ojhHn+q
TWKAVA20tMR12QAHA5xKhcBRWWtdMg==
=I1Pq
-----END PGP SIGNATURE-----

--e3oacdo4nyrbeooo--
