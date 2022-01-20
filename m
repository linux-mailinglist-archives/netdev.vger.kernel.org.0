Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F11495511
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347222AbiATTvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 14:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiATTvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:51:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C34C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:51:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nAdSY-0007Mg-Tt; Thu, 20 Jan 2022 20:51:02 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3C0831E958;
        Thu, 20 Jan 2022 19:50:55 +0000 (UTC)
Date:   Thu, 20 Jan 2022 20:50:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, ore@pengutronix.de,
        alexandru.tachici@analog.com
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <20220120195051.pb4k24uazqqe6ecd@pengutronix.de>
References: <20220119131117.30245-1-kabel@kernel.org>
 <20220120084914.ga7o372lyynbn4ly@pengutronix.de>
 <20220120190155.717f2d52@thinkpad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ig2sp3rdmyz7xxgk"
Content-Disposition: inline
In-Reply-To: <20220120190155.717f2d52@thinkpad>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ig2sp3rdmyz7xxgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.01.2022 19:01:55, Marek Beh=C3=BAn wrote:
> On Thu, 20 Jan 2022 09:49:14 +0100
> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>=20
> > On 19.01.2022 14:11:17, Marek Beh=C3=BAn wrote:
> > > Common PHYs and network PCSes often have the possibility to specify
> > > peak-to-peak voltage on the differential pair - the default voltage
> > > sometimes needs to be changed for a particular board.
> > >=20
> > > Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for th=
is
> > > purpose. The second property is needed to specify the mode for the
> > > corresponding voltage in the `tx-p2p-microvolt` property, if the volt=
age
> > > is to be used only for speficic mode. More voltage-mode pairs can be
> > > specified.
> > >=20
> > > Example usage with only one voltage (it will be used for all supported
> > > PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> > > case):
> > >=20
> > >   tx-p2p-microvolt =3D <915000>;
> > >=20
> > > Example usage with voltages for multiple modes:
> > >=20
> > >   tx-p2p-microvolt =3D <915000>, <1100000>, <1200000>;
> > >   tx-p2p-microvolt-names =3D "2500base-x", "usb", "pcie";
> > >=20
> > > Add these properties into a separate file phy/transmit-amplitude.yaml,
> > > which should be referenced by any binding that uses it. =20
> >=20
> > If I understand your use-case correctly, you need different voltage p2p
> > levels in the connection between the Ethernet MAC and the Ethernet
> > switch or Ethernet-PHY?
>=20
> This is a SerDes differential pair amplitude. So yes to your question,
> if the MII interface uses differential pair, like sgmii, 10gbase-r, ...
>=20
> > Some of the two wire Ethernet standards (10base-T1S, 10base-T1L,
> > 100base-T1, 1000base-T1) defines several p2p voltage levels on the wire,
> > i.e. between the PHYs. Alexandru has posed a series where you can
> > specify the between-PHY voltage levels:
> >=20
> > | https://lore.kernel.org/all/20211210110509.20970-8-alexandru.tachici@=
analog.com/
>=20
> Copper ethernet is something different, so no conflict
>=20
> > Can we make clear that your binding specifies the voltage level on the
> > MII interface, in contrast Alexandru's binding?
>=20
> The binding explicitly says "common PHY", not ethernet PHY. I don't
> thing there will be any confusion. It can also be specified for USB3+
> differential pairs, or PCIe differential pairs, or DisplayPort
> differential pairs...

Thanks for the clarification.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ig2sp3rdmyz7xxgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHpvRkACgkQqclaivrt
76lZvAf9H8GhbUiGcplGx0asB/AtptboYzDuuhpMpI/RluV2pGEH2Qyf7RU92oy8
D01mIBwRnZIbOABBYVLf+gTbppmd9043lXuQwVKPijz0kqZsHthXDBP4QOQqDzRT
Flamo7qjNMv3EOdbj20Ylx6KVVRejZopRDBAHF1RqoXQm7ZM4GWU0EBol4d9wbRa
JZvOiIB0MAMIqs+NwsxXZPyfScZTsYMqXFNZXm9VKcilI61MnQ3sr/7Ls/XDkaQy
XnRjZxOWPKsxGNf5xMMXp5SniUa4uOzMzeZr/r7gUYw/d4SD2ak+vS4P8efzxnLD
HVwyYTjf+z0UKKfK/iK2LOc79zeETg==
=IZJg
-----END PGP SIGNATURE-----

--ig2sp3rdmyz7xxgk--
