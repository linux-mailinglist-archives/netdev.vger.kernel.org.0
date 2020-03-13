Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5393D184486
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 11:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCMKMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 06:12:18 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35951 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgCMKMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 06:12:15 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jChIV-0005CP-9b; Fri, 13 Mar 2020 11:12:07 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jChIU-000271-00; Fri, 13 Mar 2020 11:12:05 +0100
Date:   Fri, 13 Mar 2020 11:12:05 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 2/2] ARM: dts: imx6q-marsboard: properly define rgmii
 PHY
Message-ID: <20200313101205.pxctcainreac7a6j@pengutronix.de>
References: <20200313053224.8172-1-o.rempel@pengutronix.de>
 <20200313053224.8172-3-o.rempel@pengutronix.de>
 <20200313095545.GD14553@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="btk4uzvcft3s7ycb"
Content-Disposition: inline
In-Reply-To: <20200313095545.GD14553@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:11:16 up 119 days,  1:29, 146 users,  load average: 0.01, 0.07,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--btk4uzvcft3s7ycb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 10:55:45AM +0100, Andrew Lunn wrote:
> On Fri, Mar 13, 2020 at 06:32:24AM +0100, Oleksij Rempel wrote:
> > The Atheros AR8035 PHY can be autodetected but can't use interrupt
> > support provided on this board. Define MDIO bus and the PHY node to make
> > it work properly.
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  arch/arm/boot/dts/imx6q-marsboard.dts | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm/boot/dts/imx6q-marsboard.dts b/arch/arm/boot/dts/=
imx6q-marsboard.dts
> > index 84b30bd6908f..1f31d86a217b 100644
> > --- a/arch/arm/boot/dts/imx6q-marsboard.dts
> > +++ b/arch/arm/boot/dts/imx6q-marsboard.dts
> > @@ -111,8 +111,21 @@ &fec {
> >  	pinctrl-names =3D "default";
> >  	pinctrl-0 =3D <&pinctrl_enet>;
> >  	phy-mode =3D "rgmii-id";
> > -	phy-reset-gpios =3D <&gpio3 31 GPIO_ACTIVE_LOW>;
> >  	status =3D "okay";
>=20
> Hi Oleksij=20
>=20
> I don't see a phy-handle here. So is it still using phy_find_first()?

Uff... right. Thx for pointing it.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--btk4uzvcft3s7ycb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5rXHEACgkQ4omh9DUa
UbPogg//XjGtdb1pUZbPSkZBCCQhrYX8rLqM7CcGPmyDbDMo1EMZycc/B8pUPYir
Ea/Xipv8Uj0SFZ8Sd3NApY1u+wtotDYyIYFe3oh9QCD9W8RI3o1DyiD6d7w4DjKR
JqjSuj7pKbpRaFlGz6d724tuf8xImEumliUHJj7Smjhvz2srctfWBK5SODa1gj2x
CE8Y3fVmSDIbiq9tlJCNgjyUe9rzjgQAOAbKyTaRuUi/WJNOu0SUT3l+Ggh5f6VQ
OWXFKposcaFJWMVWyeqRttdsE+7396Pyk5T1W14YLKkBOY8CQrmdD7EnvjwYwsKX
WbGfYU/TTyCjcMI3YbuiachfU6k+uZO/uIihnlYax/tzNIslZg7Pi+8GAGadNpxo
pgZ6PUUUvAKEmfPNc2w9FJ9EGTHDrG6+KxobutnliGbsOtLSki6anNbbd/9cB3Qg
4ZCkD5oXOeH340aSzTG19QMdf0ACBKpwoMUHA97KWFMSLgl/7WHi9+ZogAb/bII2
+kb65UNwWsXdEOhtTcDWDk5hVTIRVmiSndJkdjam6LAdidZjEPct7ByXvPmefcHA
/qWcFUxPP1Wmoy5CJLALzRqIsW5LyonWhxnBwDA+Hl0u9POP28oCU7TY8qRoTCeS
oRR0ZGXS10zVLRJGC99Di0g5elRP8xyaOcuEK/zPxD0bBVlzGRA=
=ucl/
-----END PGP SIGNATURE-----

--btk4uzvcft3s7ycb--
