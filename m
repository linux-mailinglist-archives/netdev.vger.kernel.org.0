Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D41CCDFD0
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfJGLCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:02:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52920 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbfJGLCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:02:43 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 10BD780552; Mon,  7 Oct 2019 13:02:24 +0200 (CEST)
Date:   Mon, 7 Oct 2019 13:02:39 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Matthias Kaehlcke <mka@chromium.org>, jacek.anaszewski@gmail.com,
        linux-leds@vger.kernel.org, dmurphy@ti.com,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
Message-ID: <20191007110239.GA21484@amd>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-5-mka@chromium.org>
 <20190816201342.GB1646@bug>
 <20190816212728.GW250418@google.com>
 <20190817140502.GA5878@amd>
 <20190819003757.GB8981@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20190819003757.GB8981@lunn.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-08-19 02:37:57, Andrew Lunn wrote:
> > Yes, I believe the integration is neccessary. Using same binding is
> > neccessary for that, but not sufficient. For example, we need
> > compatible trigger names, too.
>=20
> Hi Pavel
>=20
> Please could you explain what you mean by compatible trigger names?

Well, you attempted to put trigger names in device tree. That means
those names should work w.r.t. LED subsystem, too.

> > So... I'd really like to see proper integration is possible before we
> > merge this.
>=20
> Please let me turn that around. What do you see as being impossible at
> the moment? What do we need to convince you about?

That locking requirements are compatible, that triggers you invented
can be implemented by LED subsystem, ...

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2bG08ACgkQMOfwapXb+vLTsACguaZUSA7o5wiU8LUngEzV9LZ2
S4QAoIuXQiHHVs6amdFdbIvXRo7LFifl
=yXXm
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
