Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D9B173847
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgB1N0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:26:55 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46859 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgB1N0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:26:54 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1j7ffG-00051B-1D; Fri, 28 Feb 2020 14:26:50 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1j7ffE-0006RR-91; Fri, 28 Feb 2020 14:26:48 +0100
Date:   Fri, 28 Feb 2020 14:26:48 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v8 1/1] net: ag71xx: port to phylink
Message-ID: <20200228132648.fgeoify3qdeb53qn@pengutronix.de>
References: <20200226054624.14199-1-o.rempel@pengutronix.de>
 <20200226092138.GV25745@shell.armlinux.org.uk>
 <20200228114753.GN18808@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4s5yhyplebixnzcf"
Content-Disposition: inline
In-Reply-To: <20200228114753.GN18808@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:25:56 up 105 days,  4:44, 122 users,  load average: 0.47, 0.18,
 0.11
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4s5yhyplebixnzcf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2020 at 11:47:53AM +0000, Russell King - ARM Linux admin wr=
ote:
> On Wed, Feb 26, 2020 at 09:21:38AM +0000, Russell King - ARM Linux admin =
wrote:
> > On Wed, Feb 26, 2020 at 06:46:24AM +0100, Oleksij Rempel wrote:
> > > The port to phylink was done as close as possible to initial
> > > functionality.
> > >=20
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > > changes v8:
> > > - set the autoneg bit
> > > - provide implementations for the mac_pcs_get_state and mac_an_restart
> > >   methods
> > > - do phylink_disconnect_phy() on _stop()
> > > - rename ag71xx_phy_setup() to ag71xx_phylink_setup()=20
> >=20
> > There will be one more change required; I'm changing the prototype for
> > the mac_link_up() function, and I suggest as you don't support in-band
> > AN that most of the setup for speed and duplex gets moved out of your
> > mac_config() implementation to mac_link_up().
> >=20
> > The patches have been available on netdev for just over a week now.
>=20
> The patches are now in net-next.  Please respin your patch against these
> changes, which basically means the code which programs the speed and
> duplex in ag71xx_mac_config() needs to be moved to ag71xx_mac_link_up().

OK, Thank you!
I'll  update it.

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--4s5yhyplebixnzcf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5ZFRMACgkQ4omh9DUa
UbNtTxAAhCmNOMd5vUqbiJM1/w/s11cV8lfHjVZxuDKKrAeo6h+/L1xs+/Aw8ybN
AFt2LojGejRo96MkotlhDcM5XjRpG2J7SA5tnPziTaRXwTuuyhItsxJtHcCJJrf7
HFRnVmrEOclwfzGXFhnUsttaNgtTQrheEVgQzzfZi22o0qLOVp8jtnMoRk5XUWFB
YtWCGMxsGyK72L3UpyXufYalpTKWnIAcWcEtL0SzAkrMIg55MoJDq3lHrecvyP1/
FnjCToGwFDYBA0/ym0gQtlsGCeMJ4+qfgnHnMz1H8nUd9t7T5uXJOENXo3Ua/a/c
d2BEbtgXX42QsDz3SEQDWdeQtpZv5lWPiO3xmBentFjpqkXldhLdVSSXOT+lwF0K
puY8vSQqOt0OLoPedABEFLhUUrjndcndERdAzfuyjAtbUgSDKgiDnBW8ihjfVt9n
Q3yWtrnSlltE8QgRlbok8DpyjZ1SoTnm3GIvlaZbHVnVWLSC1d8OY4Ev4fRr78K3
JwmstQibR0AWWvKUsil0IPGrrNPk+AzR2lDJbdLCpnXOEHHpPLYL0dSVk103G9mx
ntVYCNfd6BARiT55cwWrLU9zVb0n3Or8KMryTZZ9G0Vr6f+HTWr1bu7q5QrfY+Md
c4NDy37wq1UelojjiYIg5Heli/nR6VSCvYfJyhcmp0Q9Dz56rpg=
=vVIQ
-----END PGP SIGNATURE-----

--4s5yhyplebixnzcf--
