Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5FA12702F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfLSWBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:01:34 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52543 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSWBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:01:33 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ii3rP-0003mI-L1; Thu, 19 Dec 2019 23:01:31 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1ii3rO-0005Dg-7A; Thu, 19 Dec 2019 23:01:30 +0100
Date:   Thu, 19 Dec 2019 23:01:30 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, g@pengutronix.de
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20191219220130.pedtll3nvtdcy657@pengutronix.de>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
 <20191219203931.GN17475@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4qyc6bbxskpf77vt"
Content-Disposition: inline
In-Reply-To: <20191219203931.GN17475@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:56:29 up 165 days,  4:06, 64 users,  load average: 0.13, 0.12,
 0.16
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4qyc6bbxskpf77vt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2019 at 09:39:31PM +0100, Andrew Lunn wrote:
> On Wed, Dec 18, 2019 at 05:29:19PM +0100, Michael Grzeschik wrote:
> > Some phys support special opcode handling when communicating via mdio.
> > This patch introduces mdio_ll_read/write which makes it possible to set
> > the opcode. It implements these functions in the gpio-bitbang driver,
> > which is capable of setting the opcode on read and write.
> >=20
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>=20
> Hi Michael
>=20
> It is normal to post the user of a new API at the same time as a new
> API. I'm having trouble working out how this is supposed to be used.

Hi Andrew,

so this patch should have been in the series with the ksz8863 driver,
which is using the API. I will send the series again as v3 including
this patch, so it will be clear how this is ment.

Thanks,
Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--4qyc6bbxskpf77vt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl378zYACgkQC+njFXoe
LGTFfg//VcJrCjdpggD5Ug5jqtLF+mEs6dbLOwhSs+86rmaMVqBFYrRC/E1vSph7
ipLA5BtqJMsnJDJ8/hu2/I+8mgHON5kcuJVd4+SuidQAj/oSi15OyIiyygnwpvxS
mcTEaURK2VlhxKR3zkVBnKK6lS7umE4+UGJATV4pJEYqjTZMduwXLMUtvdAcggYq
CpZQPMHucBssnJyJjMPoMv+dI+4RAd1mJs1Ju/aQ+nMvHSXgTNHKNSmFV3rOffDh
spUmBK9sfBqDoAPKr7WYbWYuvKGxiVnNJmlSwewcpjiY57PURhX+IGYdSZ4IYUDM
XSSNRdvu12h5mglnXAYB5eP2j5gdtNHP+pqScAYOM7n95gK5vnGs+pMe/op9X0Nv
O28z3n80sxqq4zC/dGnWlCMilkPbGlQUyPyJbnYSEZLPFzpiwz0DvDDHYmjHCWFn
xSVzaotN/b9Ew9TE/wkBm1j2qXvdqqLNp8AfLVJig/nRTQ1yOWzUbNUOZu+XzWsD
wZ8Ux7J8vc1kW5T/ylzCYeYjDU8R5uDC++kAvmJgcPgKLG2obsq7PDfuzV1rTMfu
oeNk9CfNZLxLqqOiFv2Tn6JSTw/eBUbdZzoUWjdKpcp1YwZACR1KB5QPnjEd5QUJ
ui0dGHKdAqa+dbqxy4yHyiaUS3T7qzjFjLm/EzmOoS2CLUXeW+o=
=7iRK
-----END PGP SIGNATURE-----

--4qyc6bbxskpf77vt--
