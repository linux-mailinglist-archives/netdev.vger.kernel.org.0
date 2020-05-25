Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5104F1E1523
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389889AbgEYURt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:17:49 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49202 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388994AbgEYURt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:17:49 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D8C551C02CC; Mon, 25 May 2020 22:17:46 +0200 (CEST)
Date:   Mon, 25 May 2020 22:17:46 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        robh+dt@kernel.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, jianxin.pan@amlogic.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/8] dt-bindings: net: meson-dwmac: Add the
 amlogic,rx-delay-ns property
Message-ID: <20200525201746.GA5528@duo.ucw.cz>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
 <20200512211103.530674-2-martin.blumenstingl@googlemail.com>
 <20200524212843.GF1192@bug>
 <d3f596d7-fb7f-5da7-4406-b5c0e9e9dc3f@gmail.com>
 <20200525090718.GB16796@amd>
 <20200525135728.GE752669@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20200525135728.GE752669@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-05-25 15:57:28, Andrew Lunn wrote:
> > > standardizing on rx-delay-ps and tx-delay-ps would make sense since t=
hat
> > > is the lowest resolution and the property would be correctly named wi=
th
> > > an unit in the name.
> >=20
> > Seems like similar patch is already being reviewed from Dan Murphy (?)
> > from TI.
>=20
> Dan is working on the PHY side. But there is probably code which can
> be shared.
>=20
> One question to consider, do we want the same properties names for MAC
> and PHY, or do we want to make them different, to avoid confusion?

We have same properties accross different hardware (compatible, reg),
so same property between MAC and PHY seems to make sense.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXswn6gAKCRAw5/Bqldv6
8i7zAJ4jCAV144tVxiIyf3sNBn1JDz7j+QCgvR80vjeIJZeqGeR77nVrZk4D4ck=
=JqOQ
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
