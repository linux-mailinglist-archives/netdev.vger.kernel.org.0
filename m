Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1301DBBB1
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETRja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgETRj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:39:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5F8C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 10:39:29 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jbSgd-0004fn-Kl; Wed, 20 May 2020 19:39:23 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jbSgZ-0007iT-1Q; Wed, 20 May 2020 19:39:19 +0200
Date:   Wed, 20 May 2020 19:39:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200520173918.esu3uzlx6j3bvjbp@pengutronix.de>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
 <20200520062915.29493-2-o.rempel@pengutronix.de>
 <20200520144544.GB8771@lion.mk-sys.cz>
 <20200520150711.rj4b22g3zhzej2aw@pengutronix.de>
 <20200520153001.GG652285@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="njydaegebt5fxpfa"
Content-Disposition: inline
In-Reply-To: <20200520153001.GG652285@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:38:50 up 187 days,  8:57, 194 users,  load average: 0.01, 0.28,
 0.35
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--njydaegebt5fxpfa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2020 at 05:30:01PM +0200, Andrew Lunn wrote:
> > > I'm not sure if it's a good idea to define two separate callbacks. It
> > > means adding two pointers instead of one (for every instance of the
> > > structure, not only those implementing them), doing two calls, running
> > > the same checks twice, locking twice, checking the result twice.
> > >=20
> > > Also, passing a structure pointer would mean less code changed if we
> > > decide to add more related state values later.
> > >=20
> > > What do you think?
> > >=20
> > > If you don't agree, I have no objections so
> > >=20
> > > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> >=20
> > I have no strong opinion on it. Should I rework it?
>=20
> It is an internal API, so we can change it any time we want.
>=20
> I did wonder if MAX should just be a static value. It seems odd it
> would change at run time. But we can re-evaulate this once we got some
> more users.

OK, then let's keep it for now.

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--njydaegebt5fxpfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7Fa0MACgkQ4omh9DUa
UbOwnBAAr9pwdhhEGB66WDzWYri4K5m1Kr7b18zNnZYFiSvhQO/yjPjmrySuUxww
KENSUd9wdlT9AWhFvW9y0UT4nRI/SzaocZHvpSc+B+oIZRDaIjNQTKEcK247xRz3
Y98GGlLLRF4FL5vmmxHPsqWk/8Oa3JqJL6jw9SkHcr8JkO9GR7tE78HL1H3jl8hj
jyUbv7vv2dsRcFntX0v+KTiblhBdfocbtdUgZEa44coVDWrqntTE6Dcxg/Vp4naz
ZWh95G6iRKFqK4n7ilkA5/qi/0Uqbt5ihUq5oQbcLx/KwTPcQRFwIt9ugRQGX4I9
oJzFq9RbF19N9nKVQn9byls0a0CABWomcdmghp3CiQyV/AzHpKa/Iq36T/t9dqB3
4mTAOaL95N5b91Zv1cOIziqYYOwtaygslqWJM0Qje4iG9f6tAIvo20tP/hk+h70C
JPcI5/HfpTN8gPLFjlZDdvkHIV/Tm2DX1kTScrMJV3n/dSzgAezkylJzuWxlBCNb
vwBNCNvVWdiwOCqHtb1Ve3vBbYf687FSh7onS7sPJSFzVL0nwXzjo5yoMXQaN9pT
aOgqhRIlxVQSyI2/zRC18BwXPiNory9xfvtKFrHP9Ds5/XWi7HNR/USXi16/7x87
XZl5JnCy14sikU+lxUSoQGEeqbufVUmMylY8cIZ+91IsGO4rTiE=
=+CCT
-----END PGP SIGNATURE-----

--njydaegebt5fxpfa--
