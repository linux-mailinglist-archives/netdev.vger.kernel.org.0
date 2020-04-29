Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C331BD82D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgD2J0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726688AbgD2J0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 05:26:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0D0C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 02:26:34 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jTiyy-0007rD-OA; Wed, 29 Apr 2020 11:26:20 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jTiyu-00011L-62; Wed, 29 Apr 2020 11:26:16 +0200
Date:   Wed, 29 Apr 2020 11:26:16 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch>
 <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f37udlmunv3yqdec"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:46:27 up 166 days, 5 min, 179 users,  load average: 0.11, 0.06,
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


--f37udlmunv3yqdec
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Wed, Apr 29, 2020 at 10:45:35AM +0200, Geert Uytterhoeven wrote:
> Hi Philippe,
>=20
> On Tue, Apr 28, 2020 at 6:16 PM Philippe Schenker
> <philippe.schenker@toradex.com> wrote:
> > On Tue, 2020-04-28 at 17:47 +0200, Andrew Lunn wrote:
> > > On Tue, Apr 28, 2020 at 05:28:30PM +0200, Geert Uytterhoeven wrote:
> > > > This triggers on Renesas Salvator-X(S):
> > > >
> > > >     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00:
> > > > *-skew-ps values should be used only with phy-mode =3D "rgmii"
> > > >
> > > > which uses:
> > > >
> > > >         phy-mode =3D "rgmii-txid";
> > > >
> > > > and:
> > > >
> > > >         rxc-skew-ps =3D <1500>;
> > > >
> > > > If I understand Documentation/devicetree/bindings/net/ethernet-
> > > > controller.yaml
> > > > correctly:
> > >
> > > Checking for skews which might contradict the PHY-mode is new. I think
> > > this is the first PHY driver to do it. So i'm not too surprised it has
> > > triggered a warning, or there is contradictory documentation.
> > >
> > > Your use cases is reasonable. Have the normal transmit delay, and a
> > > bit shorted receive delay. So we should allow it. It just makes the
> > > validation code more complex :-(
> >
> > I reviewed Oleksij's patch that introduced this warning. I just want to
> > explain our thinking why this is a good thing, but yes maybe we change
> > that warning a little bit until it lands in mainline.
> >
> > The KSZ9031 driver didn't support for proper phy-modes until now as it
> > don't have dedicated registers to control tx and rx delays. With
> > Oleksij's patch this delay is now done accordingly in skew registers as
> > best as possible. If you now also set the rxc-skew-ps registers those
> > values you previously set with rgmii-txid or rxid get overwritten.
> >
> > We chose the warning to occur on phy-modes 'rgmii-id', 'rgmii-rxid' and
> > 'rgmii-txid' as on those, with the 'rxc-skew-ps' value present,
> > overwriting skew values could occur and you end up with values you do
> > not wanted. We thought, that most of the boards have just 'rgmii' set in
> > phy-mode with specific skew-values present.
> >
> > @Geert if you actually want the PHY to apply RXC and TXC delays just
> > insert 'rgmii-id' in your DT and remove those *-skew-ps values. If you
>=20
> That seems to work for me, but of course doesn't take into account PCB
> routing.

On boards with simple design, the clock lines have nearly same length as da=
ta
lines. To provide needed clock delay, you should make clock line ~17
centimeter longer than data lines. Or configure PHY or MAC side to
provide needed delay.
Since "phy-mode =3D "rgmii-txid"" was ignored till my patch. And the
"rxc-skew-ps =3D <1500>" will add a delay of 0.6 nano seconds. Your
configuration was:
TX delay =3D 1.2ns
RX delay =3D 0.6ns

Is it really reflects the configuration of you PCB?

> > need custom timing due to PCB routing it was thought out to use the phy-
> > mode 'rgmii' and do the whole required timing with the *-skew-ps values.
>=20
> That mean we do have to provide all values again?

No. Using proper phy-mode should be enough. If you using default TX dealy a=
nd
configuring RX delay manually, the phy-mode =3D "rgmii-id" is
the right choice for you.

> Using "rgmii" without any skew values makes DHCP fail on R-Car H3 ES2.0,
> M3-W (ES1.0), and M3-N (ES1.0). Interestingly, DHCP still works on R-Car
> H3 ES1.0.

The TX delay affects MAC to PHY path. The RX delay affects PHY to MAC
path. On my HW, disabling TX delays, didn't affected the communication
in any measurable way. Even with clock line length is equal to the data
lines length. So, it may work just on the edge of the spec.

> Note that I'm not too-familiar with the actual skew values needed
> (CC Mizuguchi-san).
>=20
> Related commits:
>   - 0e45da1c6ea6b186 ("arm64: dts: r8a7795: salvator-x: Fix
> EthernetAVB PHY timing")
>   - dda3887907d74338 ("arm64: dts: r8a7795: Use rgmii-txid phy-mode
> for EthernetAVB")
>   - 7eda14afb8843a0d ("arm64: dts: renesas: r8a77990: ebisu: Fix
> EthernetAVB phy mode to rgmii")

Regards,
Oleksij.
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--f37udlmunv3yqdec
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6pSDQACgkQ4omh9DUa
UbPJAQ/+LKRfA0dP7eKYb/DDX4v/6S1nJMmwoCCWrjVB2nGeUL5a/T7s4AwotKvp
D3uzbGzyVgzYo41Sl+OUDqxVA9vJ2/dKG2AooUL641ptkc03zh4ihhQajjhrIb9h
1ig4lARM60ngONJprFehqGRbDw7MP+QmYWc9zHfh16xEDeHG/jYnvsCs9bUyIMts
YMcwCngMANU6qDG2xxsYwAgCp+wuUVbXsn4Syh2kaL5LaoM/4sMEE1nyjQ/a/DZP
rQN92+rX2KPS2Rp3xY2qD2Cz20c4kcuXfMNOnFJRuyBqNggdFmkezxl+QvRhTULe
VcGMSwH9uOSVh0zze72JdCI2zj3VZd/iS7Bs94wvQpbYhlB27SpG5eq1msJ7RX8c
tTjIBm98l4fSRRpDne5dXa+A2ThifkOeh1bGnFjJCIyXffQ1UC2PEgLVp8WW2stf
wQfOgZnv8c8FXbSx+IgBuIcgiZtCkd3f9Nyn+MbFZqVthqRZdt5Dc2o9UiljABQP
Rg/JMcuCjYZUWWgFNmvFCKi45I4Xh6RRCwk3TTMQUOmOanMJEY77s8/Jymjsx3tA
PIbqTf8Nmcv+rGGHAgMm3AWmQc+kGNBoydKtdZ64yfNZjY9FzNAaU7ZmIRLz99UH
SzocUdqZt91pTtN4G33dJLSTyWgOS1WFdpQJsbrAQl9z0u+0hkU=
=ZopQ
-----END PGP SIGNATURE-----

--f37udlmunv3yqdec--
