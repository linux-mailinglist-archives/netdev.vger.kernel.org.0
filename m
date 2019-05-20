Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DFE2333D
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 14:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732623AbfETMJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 08:09:57 -0400
Received: from sauhun.de ([88.99.104.3]:50406 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfETMJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 08:09:57 -0400
Received: from localhost (p54B333DA.dip0.t-ipconnect.de [84.179.51.218])
        by pokefinder.org (Postfix) with ESMTPSA id 4F4432C2761;
        Mon, 20 May 2019 14:09:55 +0200 (CEST)
Date:   Mon, 20 May 2019 14:09:54 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Simon Horman <horms@verge.net.au>
Cc:     Ulrich Hecht <uli@fpond.eu>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, magnus.damm@gmail.com
Subject: Re: [PATCH] ravb: implement MTU change while device is up
Message-ID: <20190520120954.ffz2ius5nvojkxlh@katana>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
 <1f7be29e-c85a-d63d-c83f-357a76e8ca45@cogentembedded.com>
 <20190508165219.GA26309@bigcity.dyn.berto.se>
 <434070244.1141414.1557385064484@webmail.strato.com>
 <20190509101020.4ozvazptoy53gh55@verge.net.au>
 <344020243.1186987.1557415941124@webmail.strato.com>
 <20190513121807.cutayiact3qdbxt4@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4onpowlsgc4ggi7t"
Content-Disposition: inline
In-Reply-To: <20190513121807.cutayiact3qdbxt4@verge.net.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4onpowlsgc4ggi7t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > > > >    How about the code below instead?
> > > > > >=20
> > > > > > 	if (netif_running(ndev))
> > > > > > 		ravb_close(ndev);
> > > > > >=20
> > > > > >  	ndev->mtu =3D new_mtu;
> > > > > > 	netdev_update_features(ndev);
> > > > >=20
> > > > > Is there a need to call netdev_update_features() even if the if i=
s not=20
> > > > > running?
> > > >=20
> > > > In my testing, it didn't seem so.
> > >=20
> > > That may be because your testing doesn't cover cases where it would m=
ake
> > > any difference.
> >=20
> > Cases other than changing the MTU while the device is up?
>=20
> I was thinking of cases where listeners are registered for the
> notifier that netdev_update_features() triggers.

Where are we here? Is this a blocker?


--4onpowlsgc4ggi7t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlzimRIACgkQFA3kzBSg
KbY2ig/+OwxRKe5IvhMytGuTfw9DwJ67C/b6eNAe3iSX2v/VZTIBkYZvIkiP+O1z
+T6LxyQSiB2ceJvEfQXInI8gBydL6ZPmo0qzWUTUmJXVr3L3DaBwCaKA0PsGqP23
C5XV4FtwDGo2SYunFCqSYsA6u5+TWKdagtdv2br2CSF5f1k+9PSzuRcrwFy9mA8Q
xaLiiOYTaKgYvZE5geV7dQdngpNzRoiZw+YKIzSyNFkLB1WVTl4IJgvE9rAzJ6yb
gUpkRfuvoBmUSKbUHX1iJzboYeoTMrf4m2si/nQeotgZUtgejBecUVWCmBC+BvSX
c/o/U1uBMUBO0n9/AnHu0gqJ+h3lBDx0u5qpeo6eKd6pu8u2SKO1SWD6lP0/wil8
qKcmDdghqMbrbq5pZgAA7JvGjsHR+U+VxmgPKvGEcPlSB1aOE+AIIVQbI80xVNWi
75g1Ar9EveaGF2A3vd6rgeMlSRhEFXb0ByrDPd++iuIFcuUtrDjNUdjwgcJbShET
ZJwK6+XSMl5HsKiRuQR69znCEFL6KpmTkgJZzzOXVBGHctOb3/Ut7s7PjK1tErEn
cPmXKDCXJR37zMx2TQPFnIUjMNGDVhdjCdBId5sNXWL15EEicS4pWSA1XMFqA8pd
EM36Tt6gpFvWXuPzk6rqYSAnj+eurhDRxlRqsevoAQkcnkbNaI0=
=EEaJ
-----END PGP SIGNATURE-----

--4onpowlsgc4ggi7t--
