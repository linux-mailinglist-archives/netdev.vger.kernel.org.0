Return-Path: <netdev+bounces-3548-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D1B707D73
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA8DB281899
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33B711CAC;
	Thu, 18 May 2023 10:00:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D2AAD46
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:00:09 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5CB1716
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:00:07 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzaQU-0001ZA-4G; Thu, 18 May 2023 12:00:02 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 518761C7B79;
	Thu, 18 May 2023 10:00:01 +0000 (UTC)
Date: Thu, 18 May 2023 12:00:00 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Frank Jungclaus <frank.jungclaus@esd.eu>
Cc: linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] can: esd_usb: Make use of existing kernel macros
Message-ID: <20230518-grower-film-ea8b5f853f3e-mkl@pengutronix.de>
References: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
 <20230517192251.2405290-2-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xuxstbtrrmjtjzza"
Content-Disposition: inline
In-Reply-To: <20230517192251.2405290-2-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--xuxstbtrrmjtjzza
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.05.2023 21:22:46, Frank Jungclaus wrote:
> As suggested by Vincent Mailhol make use of existing kernel macros:
> - Use the unit suffixes from linux/units.h for the controller clock
> frequencies
> - Use the BIT() macro to set specific bits in some constants
> - Use CAN_MAX_DLEN (instead of directly using the value 8) for the
> maximum CAN payload length
>=20
> Additionally:
> - Spend some commenting for the previously changed constants
> - Add the current year to the copyright notice
> - While adding the header linux/units.h to the list of include files
> also sort that list alphabetically
>=20
> Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDF=
mqpd++aBzZQg@mail.gmail.com/
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 38 ++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index d33bac3a6c10..042dda98b3db 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -3,19 +3,20 @@
>   * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
>   *
>   * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias F=
uchs <socketcan@esd.eu>
> - * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jungc=
laus@esd.eu>
> + * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <frank.=
jungclaus@esd.eu>
>   */
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +#include <linux/can/error.h>
> +
>  #include <linux/ethtool.h>
> -#include <linux/signal.h>
> -#include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/signal.h>
> +#include <linux/slab.h>
> +#include <linux/units.h>
>  #include <linux/usb.h>
> =20
> -#include <linux/can.h>
> -#include <linux/can/dev.h>
> -#include <linux/can/error.h>
> -
>  MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
>  MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
>  MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CA=
N-USB/Micro interfaces");
> @@ -27,8 +28,8 @@ MODULE_LICENSE("GPL v2");
>  #define USB_CANUSBM_PRODUCT_ID	0x0011
> =20
>  /* CAN controller clock frequencies */
> -#define ESD_USB2_CAN_CLOCK	60000000
> -#define ESD_USBM_CAN_CLOCK	36000000
> +#define ESD_USB2_CAN_CLOCK	(60 * MEGA) /* Hz */
> +#define ESD_USBM_CAN_CLOCK	(36 * MEGA) /* Hz */
> =20
>  /* Maximum number of CAN nets */
>  #define ESD_USB_MAX_NETS	2
> @@ -42,20 +43,21 @@ MODULE_LICENSE("GPL v2");
>  #define CMD_IDADD		6 /* also used for IDADD_REPLY */
> =20
>  /* esd CAN message flags - dlc field */
> -#define ESD_RTR			0x10
> +#define ESD_RTR	BIT(4) /* 0x10 */

Nitpick, personal style preference, maintainability: For me the hex
constant is redundant information, and it's not checked by the compiler,
please remove it.

> +
> =20
>  /* esd CAN message flags - id field */
> -#define ESD_EXTID		0x20000000
> -#define ESD_EVENT		0x40000000
> -#define ESD_IDMASK		0x1fffffff
> +#define ESD_EXTID	BIT(29) /* 0x20000000 */
> +#define ESD_EVENT	BIT(30) /* 0x40000000 */
> +#define ESD_IDMASK	0x1fffffff

Please use GEN_MASK.

> =20
>  /* esd CAN event ids */
>  #define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic dat=
a */
> =20
>  /* baudrate message flags */
> -#define ESD_USB_UBR		0x80000000
> -#define ESD_USB_LOM		0x40000000
> -#define ESD_USB_NO_BAUDRATE	0x7fffffff
> +#define ESD_USB_LOM	BIT(30) /* 0x40000000, Listen Only Mode */
> +#define ESD_USB_UBR	BIT(31) /* 0x80000000, User Bit Rate (controller BTR=
) in bits 0..27 */
> +#define ESD_USB_NO_BAUDRATE	0x7fffffff /* bit rate unconfigured */

You might use GEN_MASK here, too.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--xuxstbtrrmjtjzza
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRl9x0ACgkQvlAcSiqK
BOg+cAf+KzVa9cmUPggy1Tcco5Isoib0g1IdvOmpg9f/yNn8bvRP7hh3eiwkZD8z
txb3kHedg4loWwnlGnZtjFebuyRPwOVgRnwDoWvHG6rhJ40YSyPHbcGMXl5e+oht
iAwx+Fd46Bz5WANelqEcGXmnZBix+pKvVhzCeRwhaksf1nE6YfpUNyHguVqiUXul
N8LuE+eWcG49PbilEJ7xwBY77S5ymnO7giaG/AbA24XZ3aPBwk1E83wkJWmyXYes
t7NFLaDm5vlhSoOSjfVi74b9FIL9mBVnBbXOKwfXG/MKAAjzJ12RxcffuggPtXrC
AYwijWBPDmUCWw42kDiO4X6XBYtekw==
=lOIs
-----END PGP SIGNATURE-----

--xuxstbtrrmjtjzza--

