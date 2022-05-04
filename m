Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE2451A1E3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351164AbiEDONd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351126AbiEDONU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:13:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6317419AE
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 07:09:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nmFgM-0000h2-LG; Wed, 04 May 2022 16:08:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a00:20:7019:a9b6:6aae:fc9e:d3ef:96db])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 347A975CE1;
        Wed,  4 May 2022 14:08:34 +0000 (UTC)
Date:   Wed, 4 May 2022 16:08:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Message-ID: <20220504140833.b2itvapuqlssm74k@pengutronix.de>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
 <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vz3cm7jicnfhqyjt"
Content-Disposition: inline
In-Reply-To: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
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


--vz3cm7jicnfhqyjt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.05.2022 16:44:47, Andy Shevchenko wrote:
> Switch mpc5xxx_get_bus_frequency() to use fwnode in order to help
> cleaning up other parts of the kernel from OF specific code.
>=20
> No functional change intended.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  arch/powerpc/include/asm/mpc5xxx.h            |  9 +++-
>  arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |  2 +-
>  arch/powerpc/sysdev/mpc5xxx_clocks.c          | 41 ++++++++++---------
>  drivers/ata/pata_mpc52xx.c                    |  2 +-
>  drivers/i2c/busses/i2c-mpc.c                  |  7 ++--
>  drivers/net/can/mscan/mpc5xxx_can.c           |  2 +-
>  drivers/net/ethernet/freescale/fec_mpc52xx.c  |  2 +-
>  .../net/ethernet/freescale/fec_mpc52xx_phy.c  |  3 +-
>  .../net/ethernet/freescale/fs_enet/mii-fec.c  |  4 +-
>  drivers/spi/spi-mpc52xx.c                     |  2 +-
>  drivers/tty/serial/mpc52xx_uart.c             |  4 +-
>  11 files changed, 44 insertions(+), 34 deletions(-)

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for mscan/mpc5xxx_can

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vz3cm7jicnfhqyjt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJyiN4ACgkQrX5LkNig
010OIAf8CBk7q4SlnkqYRtXPIROz3oNFhMidCM6GZg2jjdclJJWBQBKZcqVIqVOE
d8lOgUvYv1HV6YvQfoaTflFSAabkzzrzJHOzvrPjpQN8m/g/jQWrtgnLsnXR6DQ8
+IlS6l/ePviEK1b1wBflbpnXNDvqyuZ1JI6raS33OtF23UfR9i3okaA7vtWhBH2p
w/pqkLeh9WHNBneeJaf9q5ag2Z99PothsCek8lEUrwJYaw9/bn0is0JWC8Zjze4C
skOkxpOERxfSedvx4WSFuU7U+CNYXk4/BkWQa/1dcLbzFuW/WdgAJDKFOtWTOI9C
od+uCAGiK4UNsWkGX3PG24Mrvry9iw==
=o7Bz
-----END PGP SIGNATURE-----

--vz3cm7jicnfhqyjt--
