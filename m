Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699F11D381B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgENR1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgENR1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:27:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A2EC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 10:27:08 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jZHdR-00015V-Hp; Thu, 14 May 2020 19:27:05 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jZHdO-0001fQ-8R; Thu, 14 May 2020 19:27:02 +0200
Date:   Thu, 14 May 2020 19:27:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Herber <christian.herber@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test
 support
Message-ID: <20200514172702.pra445q73dcjdnjc@pengutronix.de>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
 <20200513180140.GK499265@lunn.ch>
 <20200514120959.b24cszsmkjvfzss6@pengutronix.de>
 <20200514133823.GO527401@lunn.ch>
 <AM0PR04MB704193C938ECC28DE9A1B28E86BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
 <20200514160152.GU499265@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q4jkrtkhuasass7j"
Content-Disposition: inline
In-Reply-To: <20200514160152.GU499265@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:20:52 up 181 days,  8:39, 196 users,  load average: 0.06, 0.10,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q4jkrtkhuasass7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2020 at 06:01:52PM +0200, Andrew Lunn wrote:
> On Thu, May 14, 2020 at 03:47:16PM +0000, Christian Herber wrote:
> > Hi Andrew,
> >=20
> > > On Wed, May 13, 2020 at 03:39:00PM +0200, Andrew Lunn wrote:
> > >> On Thu, May 14, 2020 at 02:09:59PM +0200, Oleksij Rempel wrote:
> > >>  ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER - the link partner is ac=
tive.
> > >>
> > >>      The TJA1102 is able to detect it if partner link is master.
> > >>
> > > master is not a cable diagnostics issue. This is a configuration
> > > issue.
> >=20
>=20
> > Master is very relevant for cable diagnostics, as a cable
> > measurement should not be done with an active link partner on the
> > other end (i.e. a PHY in master mode trying to train the link).
>=20
> > So if the measurement detects an active link partner disturbing the
> > measurement, it is important to report this to the user.
>=20
> So with 'normal' PHYs, we use autoneg to make the link go quiet. But
> you don't have autoneg.
>=20
> If there is no way to force the link quiet, then
> ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER makes sense. But we need to
> keep the meaning generic. I don't want it to mean a T1 PHY with an
> active master peer. It should be usable for any reason the link cannot
> be made to go quiet.

It looks for me, like AT803X_CDT_STATUS_STAT_FAIL has the same reason as
ACTIVE PERTNER (Master) on TJA11xx.

What kind of meaning, naming would be generic?


--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--q4jkrtkhuasass7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl69f2UACgkQ4omh9DUa
UbOUsBAAo/JeyRMJ9ErfyT34aNbM7lE/k/QARpoXCynhOi745cr1Aa4WpbSo7NiY
yOowx2C6MQFPpT+EEVtBtQJHFRnVF1Kyayx0ctQKVD1wWRJAdBLxXIUbRyy6r757
EPmX+9M8DcOIvLxYw2d26HOG8jOxvI2veXeBxhJW3v03UDt51UY00GxoyFL5qCtp
NNS1XPJaYFzzJ1v4GJnSTb8m8GCMT79ril0gVspqzHY9c/K0sB7srgSac9sEehw1
Pq+By2boRmI4ddljXL03DdrwdPclXv4+MVjreKSebkXORaJSnnzvS3ZoAjAv8XIQ
VFkC9xLTWs7pKeckhazMGNOXPm2gKpZSnmfRKE2ClN8teccMrsKNxxsy/wLvV2uB
3fhSET1quizFVcQBsDUpk3I9FyzX9DwIWNu1MiTvlXQaMsgCy9gU1Rm22TGpNp9t
Atn3pNdAYqSNWrDbvQTgovSo+2SfIP/zD4f9YEDRPmJgLnj5WHz9sOIbzQt4K6om
2//D07QAKw+gSnfVYvg7caF0sfds1z5Q8UWZMGJM1xz1k0lGibp5rGWpVgv1Gski
FSNLJRvEGLjbgAvPCaWO9LCoySdpscbuWv/WGkJJgxqHokWFVX7SPvTpWOSlKJKb
htmo62DB22NUgcopXgXDDmfyCkaxI/NhSVhD+sZzVmKYZqDXcCI=
=DafH
-----END PGP SIGNATURE-----

--q4jkrtkhuasass7j--
