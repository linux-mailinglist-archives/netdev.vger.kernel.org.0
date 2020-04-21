Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF61E1B2529
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 13:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgDULde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 07:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDULdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 07:33:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F58C061A0F
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 04:33:33 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQr9e-0003uu-0M; Tue, 21 Apr 2020 13:33:30 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jQr9Y-0004UG-8h; Tue, 21 Apr 2020 13:33:24 +0200
Date:   Tue, 21 Apr 2020 13:33:24 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: dsa: sja1105: regression after patch: "net: dsa: configure the MTU
 for switch ports"
Message-ID: <20200421113324.vxh2lyasylf5kgkz@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hghpggdvhp4grwzw"
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:27:14 up 158 days,  2:45, 159 users,  load average: 0.02, 0.06,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hghpggdvhp4grwzw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

I have a regression after this patch:
|commit bfcb813203e619a8960a819bf533ad2a108d8105                           =
                          =20
|Author:     Vladimir Oltean <vladimir.oltean@nxp.com>                     =
                          =20
|
|  net: dsa: configure the MTU for switch ports

with following log:
[    3.044065] sja1105 spi1.0: Probed switch chip: SJA1105Q                =
                         =20
[    3.071385] sja1105 spi1.0: Enabled switch tagging                      =
                         =20
[    3.076484] sja1105 spi1.0: error -34 setting MTU on port 0             =
                         =20
[    3.082795] sja1105: probe of spi1.0 failed with error -34

this is devicetree snippet for the port 0:
	port@0 {
		reg =3D <0>;
		label =3D "usb";
		phy-handle =3D <&usbeth_phy>;
		phy-mode =3D "rmii";
	};


Is it know issue?

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--hghpggdvhp4grwzw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6e2f8ACgkQ4omh9DUa
UbPTBg//dQT6aptvcG5H+S3tx/Ybvcz2FtnLl7DZ0/KFpYpUT9ERYr7mKnEuXD5Z
vxisv5rCf5p3HKtYMdQK0H/0MYf7frkZlHT8QZKToFMW3TCfQTyokA424d9bsu8s
Z34/4HgWNa1+DaBkFEKhrSZo3WVATKdzG2goGWVimmKgvdWhDkTAVSJnru0v3zLX
Mez4G2WHsdWbGAlvtKlO2p9l0u6YAGTP3lzsPIb/dc3IBWx6Cg+tUlx3C2AD4Uuq
MWYrO8qTlBgcllr8Pjb9Ewrl+5ue/Q3QljIGKPsd/93V2zlbn0Qrp43/xTh063mr
xE9p4LLpdrEOqlY8SxYR/4fNjBaTxay2xnRE1uVngIiz/UXaQCAMfAz/VOmJibnN
tZZ7BGYVvXIYnHJ8Jdva4nDMBISB1vm6hdHhCAo9rpcQSMPZo7WjVSKstlEmcfrm
NnyWR1xQWOI70o4QaI4hRvT6+F3KJCl2Dh+uPfNaVD7PsWeJrHHVhh3A6Znmw/V1
alIo1IeknV9Boo11KhGANkoDbJ6SD1jM+RdGLtyx8Hx29J5zqBR29NFTOpZqrkOJ
zsjfZoM1WtHiVqiP1J0lILwgQkea4saK+QhkQRQZSVHa/2zrJItLdUyalM5GTjWI
SR4lStyCuSor/WO/QvTwXknzzq51jwU8Rpapd9I/Kp/B1xMynUQ=
=lckD
-----END PGP SIGNATURE-----

--hghpggdvhp4grwzw--
