Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B3F336F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfKGPgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:36:24 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38725 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfKGPgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 10:36:24 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSjpe-0002G3-SJ; Thu, 07 Nov 2019 16:36:22 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSjpe-0001bi-Av; Thu, 07 Nov 2019 16:36:22 +0100
Date:   Thu, 7 Nov 2019 16:36:22 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, kernel@pengutronix.de,
        Tristram.Ha@microchip.com
Subject: Re: [PATCH v1 0/4] microchip: add support for ksz88x3 driver family
Message-ID: <20191107153622.xeuim5yj2nwfaxom@pengutronix.de>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nvxtsuckxihsp2hu"
Content-Disposition: inline
In-Reply-To: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:32:59 up 122 days, 21:43, 125 users,  load average: 0.25, 0.16,
 0.11
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nvxtsuckxihsp2hu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2019 at 12:00:26PM +0100, Michael Grzeschik wrote:
> This series adds support for the ksz88x3 driver family to the=20
> dsa based ksz drivers. For now the ksz8863 and ksz8873 are compatible.
>=20
> The driver is based on the ksz8895 RFC patch from Tristam Ha:=20
>=20
> https://patchwork.ozlabs.org/patch/822712/
>=20
> And the latest version of the ksz8863.h from Microchip:
>=20
> https://raw.githubusercontent.com/Microchip-Ethernet/UNG8071_old_1.10/mas=
ter/KSZ/linux-drivers/ksz8863/linux-3.14/drivers/net/ethernet/micrel/ksz886=
3.h

After reviewing the code with my colleague, we found out this core is
not very different to the already mainlined ksz8795. So it will be
easier to port the ksz8863 specific changes into that driver.

I will give it a try.

> Michael Grzeschik (4):
>   mdio-bitbang: add SMI0 mode support
>   net: tag: ksz: Add KSZ8863 tag code
>   ksz: Add Microchip KSZ8863 SMI-DSA driver
>   dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
>     switch
>=20
>  .../devicetree/bindings/net/dsa/ksz.txt       |    2 +
>  drivers/net/dsa/microchip/Kconfig             |   16 +
>  drivers/net/dsa/microchip/Makefile            |    2 +
>  drivers/net/dsa/microchip/ksz8863.c           | 1038 +++++++++++++++++
>  drivers/net/dsa/microchip/ksz8863_reg.h       |  605 ++++++++++
>  drivers/net/dsa/microchip/ksz8863_smi.c       |  166 +++
>  drivers/net/dsa/microchip/ksz_common.h        |    1 +
>  drivers/net/phy/mdio-bitbang.c                |   21 +
>  include/linux/phy.h                           |    2 +
>  include/net/dsa.h                             |    2 +
>  net/dsa/tag_ksz.c                             |   60 +
>  11 files changed, 1915 insertions(+)
>  create mode 100644 drivers/net/dsa/microchip/ksz8863.c
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c
>=20
> --=20
> 2.24.0.rc1
>=20
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--nvxtsuckxihsp2hu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl3EOfAACgkQC+njFXoe
LGTA9hAAySQAao0SHrVLEMd7mg5a7AwS2X7NqKLHo3uOauBbuMRPHArBIXhE2eLt
2TqUthbOkZGrURyR1wsDQIjMRoNb0eTQIIQRO3IoKTKnrsbjj5roCMF0da25WOxm
CkQUz7f+TZltZ2oCKnSbR/G9OMzctXLfZHDqXYOSGyArkN8WlBAAvM+eFURtvIxu
g0KH1N5qb/iICSJsueAxHEkEQCLkwF9iod/vHzDVa31LMm8xNSBiU34IMlp6QWrg
Wo6xMzUWGvXF9cb20QNA4yTAIOFDkBW35ZWW9n74dThNQoMl4pNZOydsFLFR3f2/
SxA7Z3o3fb3EtPAQ4z99b8GuiU0gH9ZWypjWdZ2xsJqjsOIr3w4kaiv/QSu+pr1i
R3E6LnsFDlbt4j9kjddrB51fpAa4yfVCeU9BMsP4vr3pja24TV8tCMlySil0asoa
twi3lBrNgwkikBAz4uyoVAqAPhoJ3eyiYsIjs3qkb2IDM+ln9UfVUbCDYk1hiUpm
SLHOZDa8r5dw2Hl1M0JKfZdzYeWlaS2bjmohr4Jbj0Nx+LZGgOgjbUFM3AhyVSO+
tZ1CSzvf3omBIl2oWEIziNEM5G6n5meKh17WNmVDAdiRL1ECTCfjKKFIHSYnv8Pn
midPRFO/rA6ifsGfLXQJxJ3FPmhUIz8qsC43n5pyJW6MzCzenn4=
=Vkgy
-----END PGP SIGNATURE-----

--nvxtsuckxihsp2hu--
