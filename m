Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC102D4733
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbgLIQwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbgLIQwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:52:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42096C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 08:51:54 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kn2gy-0006Rl-Ly; Wed, 09 Dec 2020 17:51:52 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kn2gx-00008D-19; Wed, 09 Dec 2020 17:51:51 +0100
Date:   Wed, 9 Dec 2020 17:51:48 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, mci@pengutronix.de
Cc:     netdev@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
Subject: Re: [PATCH] net: ethernet: fec: Clear stale flag in IEVENT register
 before MII transfers
Message-ID: <20201209165148.6kbntgmjopymomx5@pengutronix.de>
References: <20201209102959.2131-1-u.kleine-koenig@pengutronix.de>
 <20201209144413.GJ2611606@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vbllrhxuquf4jur4"
Content-Disposition: inline
In-Reply-To: <20201209144413.GJ2611606@lunn.ch>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vbllrhxuquf4jur4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, Dec 09, 2020 at 03:44:13PM +0100, Andrew Lunn wrote:
> On Wed, Dec 09, 2020 at 11:29:59AM +0100, Uwe Kleine-K=F6nig wrote:
> Do you have
>=20
> ommit 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc
> Author: Greg Ungerer <gerg@linux-m68k.org>
> Date:   Wed Oct 28 15:22:32 2020 +1000
>=20
>     net: fec: fix MDIO probing for some FEC hardware blocks
>    =20
>     Some (apparently older) versions of the FEC hardware block do not like
>     the MMFR register being cleared to avoid generation of MII events at
>     initialization time. The action of clearing this register results in =
no
>     future MII events being generated at all on the problem block. This m=
eans
>     the probing of the MDIO bus will find no PHYs.
>    =20
>     Create a quirk that can be checked at the FECs MII init time so that
>     the right thing is done. The quirk is set as appropriate for the FEC
>     hardware blocks that are known to need this.
>=20
> in your tree?

Unless I did something wrong I also saw the failure with v5.10-rc$latest
earlier today.

=2E.. some time later ...

Argh, I checked my git reflog and the newest release I tested was
5.9-rc8.

I wonder if my patch is a simpler and more straight forward fix for the
problem however, but that might also be because I don't understand the
comment touched by 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc without
checking the reference manual (which I didn't).

@Marian: As it's you who has to work on this i.MX25 machine, can you
maybe test if using a kernel > 5.10-rc3 (or cherry-picking
1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc) fixes the problem for you?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--vbllrhxuquf4jur4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl/RAKEACgkQwfwUeK3K
7Ak3VQf+Ogr70EBy+POvEXFZKGXcb458OT5Ar8JyVSDGLV/RXVpwKZxIMs99l6a3
DFqtyAk6anA3dLrKvQaYeWDjNWUXR60EjRHTUDuWwA+wa1BjAxjIH7pT4Zu1sQRF
VpIHwg0TD5kG4VL8VakZIZnTvji7h2TnOTPtGdqTfGWuIqAWx7Fg17XH/ay0PfhE
g/JllLUimmUn20mpqDrkFlvIB51bKsDZFutsADAZuHFNZY+Jem+UDQsLZDqZIRpG
m1lloJcnaXCPXUwu7KbK8oZSnlGXCe6QnRFCSTfthlnHHZu/dwDMRhqxI09+mDQS
V+VXxcM3SkDtSJk3b8tVp9/76UhOng==
=FmSA
-----END PGP SIGNATURE-----

--vbllrhxuquf4jur4--
