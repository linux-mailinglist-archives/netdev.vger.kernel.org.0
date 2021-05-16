Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF6382104
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 22:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhEPUl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 16:41:29 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:55108 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhEPUl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 16:41:27 -0400
Received: from [2a02:a03f:8a9b:b00:d507:f325:75ff:c8d1] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1liNYZ-0006pT-S9; Sun, 16 May 2021 22:40:11 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1liNYX-0004Cj-JY; Sun, 16 May 2021 22:40:09 +0200
Message-ID: <df0269f3bae01c37a7dbeaa4a8bb4b3fd0277d24.camel@decadent.org.uk>
Subject: Re: [PATCH] Fix warning due to format mismatch for field width
 argument to fprintf()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org
Date:   Sun, 16 May 2021 22:40:09 +0200
In-Reply-To: <CAEyMn7ap3RL_oh0ucerH9POP+S4VGKfULhJQSb3AVeNFjR4VZw@mail.gmail.com>
References: <20210515064907.28235-1-heiko.thiery@gmail.com>
         <CAEyMn7a_ig6-FRjyY0uv1q28KNTjcf4AHG3NZaGch_Zeo3P49g@mail.gmail.com>
         <CAEyMn7ap3RL_oh0ucerH9POP+S4VGKfULhJQSb3AVeNFjR4VZw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-KLp2UWrQX3Gop3O9Z5VU"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:a03f:8a9b:b00:d507:f325:75ff:c8d1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-KLp2UWrQX3Gop3O9Z5VU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2021-05-16 at 20:11 +0200, Heiko Thiery wrote:
> Hi all,
>=20
> Am Sa., 15. Mai 2021 um 09:59 Uhr schrieb Heiko Thiery <heiko.thiery@gmai=
l.com>:
> >=20
> > Added Ben's other mail addresses.
> >=20
> > Am Sa., 15. Mai 2021 um 08:49 Uhr schrieb Heiko Thiery <heiko.thiery@gm=
ail.com>:
> > >=20
> > > bnxt.c:66:54: warning: format =E2=80=98%lx=E2=80=99 expects argument =
of type =E2=80=98long unsigned int=E2=80=99, but argument 3 has type =E2=80=
=98unsigned int=E2=80=99 [-Wformat=3D]
> > > =C2=A0=C2=A0=C2=A066 |   fprintf(stdout, "Length is too short, expect=
ed 0x%lx\n",
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|                                =
                    ~~^
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|                                =
                      |
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|                                =
                      long unsigned int
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|                                =
                    %x
> > >=20
> > > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > > ---
> > > =C2=A0bnxt.c | 2 +-
> > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/bnxt.c b/bnxt.c
> > > index b46db72..0c62d1e 100644
> > > --- a/bnxt.c
> > > +++ b/bnxt.c
> > > @@ -63,7 +63,7 @@ int bnxt_dump_regs(struct ethtool_drvinfo *info __m=
aybe_unused, struct ethtool_r
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (regs->len < (BNXT=
_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
> > > -               fprintf(stdout, "Length is too short, expected 0x%lx\=
n",
> > > +               fprintf(stdout, "Length is too short, expected 0x%x\n=
",
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
>=20
> This does not solve the issue. The provided patch only works on 32bit
> systems. It seems there is a problem with 32bit vs 64bit.

It looks like the type of BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN will
be size_t, so the correct format is "%zx".

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-KLp2UWrQX3Gop3O9Z5VU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmChgykACgkQ57/I7JWG
EQlVNhAApwwetoL1lo/ghhe69x9unlc7E17W5m2kmonlDpMuwS4XPlUrFWm2TJ+d
Nsw2T3dRYgX/7y2TmNXPRD+EcMSlKI5DZCRngMU4CKXpO0zK4P7+5qHeWY8cbP10
5P0qBmG5QhkpdX2bFofKA/Kj6ouLbJ9Q4pSYiQGSS2EfJlIXNPQ2Ipi4zYBiLL68
n3Sb4yDyetvGYEI0N73L5d7txF6Ij93gYzbyCknXFcV/8Oq/NtoKyTzMKGSaqTM9
EeLLjlRCaV5okuMraQ+t+3tGlYtzUUeP6SpnPdZf7fWCYBJMEFNbCAzDRtXbsdmP
/fL0MTRrmhTzMOJS3+Twwmw3GENwiULYSIOAb8RunVAu9dqzJvjDoCGUvgh7IDPH
qeNPVcWbGPNBqEh2R6CM6z2GKuu/bH8G727oC64LDw8fPfPZgK6KWBhdOYm/5Gwz
QOBocW4KtxeHpXSHQKDiWlcCr68m07TBeY/N7QUBYiXxSKsaafXgFJ5hy0l3f6qf
arqyjKjSE7XoycS4E1O2QlZXF6kX/FfiHacSdatdos5Z1ZQ0EIJRj1JVFUmmbfeQ
OyDabRw1GHRwY5fZX205CBkvZW6WroVWsxpfNT3gsOlFeBl8hanUq7Dv3SUbvUG5
PU/7rWyy3h+ZuiGWCYAPKkeiJyqmIEc0htMDzFfMf9Qz8yDqRvE=
=nMmX
-----END PGP SIGNATURE-----

--=-KLp2UWrQX3Gop3O9Z5VU--
