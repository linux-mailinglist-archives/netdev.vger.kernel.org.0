Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010291C811E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 06:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgEGElG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 00:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbgEGElG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 00:41:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33503C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 21:41:06 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jWYLF-0003h9-8y; Thu, 07 May 2020 06:41:01 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jWYLA-0004p6-67; Thu, 07 May 2020 06:40:56 +0200
Date:   Thu, 7 May 2020 06:40:56 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH next] ARM: dts: am437x: fix networking on boards with
 ksz9031 phy
Message-ID: <20200507044056.4smicagmxve5yshn@pengutronix.de>
References: <20200506190835.31342-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rlbyhlusgguuba5b"
Content-Disposition: inline
In-Reply-To: <20200506190835.31342-1-grygorii.strashko@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:38:58 up 173 days, 19:57, 178 users,  load average: 0.00, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rlbyhlusgguuba5b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grygorii,

thank you for you patches!

On Wed, May 06, 2020 at 10:08:35PM +0300, Grygorii Strashko wrote:
> Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
> KSZ9031 PHY") the networking is broken on boards:
>  am437x-gp-evm
>  am437x-sk-evm
>  am437x-idk-evm
>=20
> All above boards have phy-mode =3D "rgmii" and this is worked before, bec=
ause
> KSZ9031 PHY started with default RGMII internal delays configuration (TX
> off, RX on 1.2 ns) and MAC provided TX delay. After above commit, the
> KSZ9031 PHY starts handling phy mode properly and disables RX delay, as
> result networking is become broken.
>=20
> Fix it by switching to phy-mode =3D "rgmii-rxid" to reflect previous
> behavior.
>=20
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Philippe Schenker <philippe.schenker@toradex.com>
> Fixes: commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for t=
he KSZ9031 PHY")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts  | 2 +-
>  arch/arm/boot/dts/am437x-idk-evm.dts | 2 +-
>  arch/arm/boot/dts/am437x-sk-evm.dts  | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am43=
7x-gp-evm.dts
> index 811c8cae315b..d692e3b2812a 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -943,7 +943,7 @@
> =20
>  &cpsw_emac0 {
>  	phy-handle =3D <&ethphy0>;
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-rxid";
>  };
> =20
>  &elm {
> diff --git a/arch/arm/boot/dts/am437x-idk-evm.dts b/arch/arm/boot/dts/am4=
37x-idk-evm.dts
> index 9f66f96d09c9..a7495fb364bf 100644
> --- a/arch/arm/boot/dts/am437x-idk-evm.dts
> +++ b/arch/arm/boot/dts/am437x-idk-evm.dts
> @@ -504,7 +504,7 @@
> =20
>  &cpsw_emac0 {
>  	phy-handle =3D <&ethphy0>;
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-id";
>  };

Do you have here really rgmii-id?


>  &rtc {
> diff --git a/arch/arm/boot/dts/am437x-sk-evm.dts b/arch/arm/boot/dts/am43=
7x-sk-evm.dts
> index 25222497f828..4d5a7ca2e25d 100644
> --- a/arch/arm/boot/dts/am437x-sk-evm.dts
> +++ b/arch/arm/boot/dts/am437x-sk-evm.dts
> @@ -833,13 +833,13 @@
> =20
>  &cpsw_emac0 {
>  	phy-handle =3D <&ethphy0>;
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-rxid";
>  	dual_emac_res_vlan =3D <1>;
>  };
> =20
>  &cpsw_emac1 {
>  	phy-handle =3D <&ethphy1>;
> -	phy-mode =3D "rgmii";
> +	phy-mode =3D "rgmii-rxid";
>  	dual_emac_res_vlan =3D <2>;
>  };
> =20
> --=20
> 2.17.1

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--rlbyhlusgguuba5b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6zkVMACgkQ4omh9DUa
UbO2Og//azHJ/HWp+TB9hH+8UujDum628rQwsaH2rFDUmtm0XYBoRTp4L4v4Yn10
u1eSJxvBl38sfyvDqM2v2visX1Hrr72khBrpSlsZZi+SBaN59cLs97vDRqZxohS6
R8U2SfVYIHMuiJY0v7J9XuScocVNtQCRJ/tiy9sY2FIQp9U0ny2ghqDpDXkw4FYG
uzQKPyPSHbqanUlvU2lqapPj8JP6EBprJcUS00DTv5Tqkw9t2A5Xi+S2tfT9CtZj
jsmQcjpgAKgPuuYsbHzAouvv2E2yxPiOSYrFoKoB+q4STtIojdzAkUxb7G2f/kPi
u+d2t2lvjaAbVj3fhOmXKqUZVu9fwCqhXTZQzv2pYy4vV4Qi3AgzRSCh42NOZjvU
Bp/3HiBOiDZsFI2DFjJtk1bPgGbVcStgPW6a853ZrfLZy4RJBopddqedWJBsu8jj
pHmubJQiZeUu2eAtdxSFNbvTeEzyk+1vuf/zHiO1guXA0Sndm5pbv8b8RE+Uwghf
CwLUxVRq9AnNDcFZujrFOH3yDN4tYPYG+TjtoxSultHge+7gKs78FirA18DuGpIN
qh+DSsiOuRLEkN8NzWU/1Xve7qpYb9gOmMoL1WLq96GlgINjcjw0XlEGRJFjl/LU
hTGgNMOCdxZZJ42p69ESuYZL6bRCH9XphXlYllOfcU0RDYltl+Q=
=Tt1L
-----END PGP SIGNATURE-----

--rlbyhlusgguuba5b--
