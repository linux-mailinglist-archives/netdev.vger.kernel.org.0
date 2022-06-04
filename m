Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0188353D689
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 13:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiFDL1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 07:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbiFDL1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 07:27:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B376B1A078
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 04:27:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxRvw-00019X-Jr; Sat, 04 Jun 2022 13:27:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C13388C2E5;
        Sat,  4 Jun 2022 11:27:07 +0000 (UTC)
Date:   Sat, 4 Jun 2022 13:27:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/7] can: Kconfig: turn menu "CAN Device Drivers" into
 a menuconfig using CAN_DEV
Message-ID: <20220604112707.z4zjdjydqy5rkyfe@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nsn6qtiymrhpcwlo"
Content-Disposition: inline
In-Reply-To: <20220603102848.17907-3-mailhol.vincent@wanadoo.fr>
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


--nsn6qtiymrhpcwlo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.06.2022 19:28:43, Vincent Mailhol wrote:
> In the next patches, the software/virtual drivers (slcan, v(x)can)
> will depend on drivers/net/can/dev/skb.o.
>=20
> This patch changes the scope of the can-dev module to include the
> above mentioned drivers.
>=20
> To do so, we reuse the menu "CAN Device Drivers" and turn it into a
> configmenu using the config symbol CAN_DEV (which we released in
> previous patch). Also, add a description to this new CAN_DEV
> menuconfig.
>=20
> The symbol CAN_DEV now only triggers the build of skb.o. For this
> reasons, all the macros from linux/module.h are deported from
> drivers/net/can/dev/dev.c to drivers/net/can/dev/skb.c.
>=20
> Finally, drivers/net/can/dev/Makefile is adjusted accordingly.
>=20
> Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/can/Kconfig      | 29 ++++++++++++++++++++++++++---
>  drivers/net/can/dev/Makefile | 16 +++++++++-------
>  drivers/net/can/dev/dev.c    |  9 +--------
>  drivers/net/can/dev/skb.c    |  7 +++++++
>  4 files changed, 43 insertions(+), 18 deletions(-)
>=20

> diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> index 5b4c813c6222..919f87e36eed 100644
> --- a/drivers/net/can/dev/Makefile
> +++ b/drivers/net/can/dev/Makefile
> @@ -1,9 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0
> =20
> -obj-$(CONFIG_CAN_NETLINK) +=3D can-dev.o
       ^^^^^^^^^^^^^^^^^^^^^

Nitpick: I think you can directly use "y" here.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nsn6qtiymrhpcwlo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbQYgACgkQrX5LkNig
0114iwgAgOXlzqpe1RifsdUg7ptDPm5yYnu4hcnrssBkFSEZVvtCRcdmV+FapA2J
HB5UqN03uD/JxpuCuhzDPl39oGx8c9m+MtXGOCkyYFzqjUc631tM0Y9dSf3vSj5b
rkRPA3xcApXgt0pDlLLmooJjEfx8g2FUUljRRk8BQDNT1lo3i98wIIT0VSFnwTkR
S8xg6OQysZaCjk3GtWn+94STiDDokJKa7ue3Xu7sdJPMdMvuFXBY4DzbjeEKYSk6
VzgIhEgT+kloeETZBpu6EyyPMB6kRs2z+TweliXlrz3LMUuMDNDkYuYloilkUnAW
YTPJ/h2TnEEwitzBb8VQTBNIA14lGg==
=RtEe
-----END PGP SIGNATURE-----

--nsn6qtiymrhpcwlo--
