Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D944A2DC911
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgLPWmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:42:03 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52662 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgLPWmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:42:02 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 89B401C0BB7; Wed, 16 Dec 2020 23:41:19 +0100 (CET)
Date:   Wed, 16 Dec 2020 23:41:19 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>, marek.behun@nic.cz,
        linux-leds@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add LED mode behavior/select properties and handle
Message-ID: <20201216224118.GA31740@amd>
References: <20201209140501.17415-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20201209140501.17415-1-i.mikhaylov@yadro.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> In KSZ9131 PHY it is possible to control LEDs blink behavior via
> LED mode behavior and select registers. Add DTS properties plus handles
> of them inside micrel PHY driver.
>=20
> I've some concerns about passing raw register values into LED mode
> select and behavior. It can be passed via array like in microchip
> driver(Documentation/devicetree/bindings/net/microchip,lan78xx.txt).
> There is the problem in this particular driver - there is a lot of other =
PHYs
> and led mode behavior/select states may intersect, that's the reason why
> I did it this way. Is there any good ways to make it look more
> properly?

Lets... not do this?

We have a LED subsystem which should probably control the LEDs... so
user can specify behaviours at run-time, instead of them being
hard-coded in the device tree.

Plus, LED subsystem will use same interface for networks LEDs as for
=2E.. other LEDs.

Best regards,
									Pavel
--=20
http://www.livejournal.com/~pavelmachek

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/ajQ4ACgkQMOfwapXb+vJkFgCggsCdZ7gIF83/69L3RoId265i
3U0AoK8IrS8opXUCI3h/8leg09mxtTTY
=Yvel
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
