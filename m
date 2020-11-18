Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC8C2B7B2D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 11:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgKRKXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 05:23:11 -0500
Received: from mail.katalix.com ([3.9.82.81]:35484 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgKRKXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 05:23:10 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E39117D2ED;
        Wed, 18 Nov 2020 10:23:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605694988; bh=ItgvLUg3BFBdy1rDlKm0Fjw9nHRiHse7t99eLqmeSE4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=2018=20Nov=202020=2010:23:07=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Siddhant=20Gupta=20<siddhantgu
         pta416@gmail.com>|Cc:=20davem@davemloft.net,=20kuba@kernel.org,=20
         corbet@lwn.net,=0D=0A=09netdev@vger.kernel.org,=20linux-doc@vger.k
         ernel.org,=0D=0A=09linux-kernel@vger.kernel.org,=20mamtashukla555@
         gmail.com,=0D=0A=09himadrispandya@gmail.com|Subject:=20Re:=20[PATC
         H]=20Documentation:=20networking:=20Fix=20Column=20span=20alignmen
         t=0D=0A=20warnings=20in=20l2tp.rst|Message-ID:=20<20201118102307.G
         A4903@katalix.com>|References:=20<20201117095207.GA16407@Sleakybea
         st>|MIME-Version:=201.0|Content-Disposition:=20inline|In-Reply-To:
         =20<20201117095207.GA16407@Sleakybeast>;
        b=KxppM36001NtVJ/Oawpy21dGdXzlrsz8LWtETzMfm290w6mQwl/DBXN2A+Tcrurz+
         kXpVZ09RCUm1snROcPHwOngOc11md3quI4MEileVG+Xizm6xd0hh3JkI0UHCkwFT66
         fZqQsb4rCLCRwNBIVpL61s2hobb4udL5c9AaUd6tZ+hm4bY/4AJvML0anQQPccghkg
         rAoESa8Pzp1WMDHgf+j7t7dov7O5mAA4AnClut1ev0zX8CyXslUbQBYKDt/MeTbb8A
         dVinZQ+abW/ir9UGq6GpWLxpbHiQRB8k3Hj15g6ECqcAilUeicKUk4FwzWk7990kU3
         A7zeJfg88qMJQ==
Date:   Wed, 18 Nov 2020 10:23:07 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Siddhant Gupta <siddhantgupta416@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mamtashukla555@gmail.com,
        himadrispandya@gmail.com
Subject: Re: [PATCH] Documentation: networking: Fix Column span alignment
 warnings in l2tp.rst
Message-ID: <20201118102307.GA4903@katalix.com>
References: <20201117095207.GA16407@Sleakybeast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20201117095207.GA16407@Sleakybeast>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Nov 17, 2020 at 15:22:07 +0530, Siddhant Gupta wrote:
> Fix Column span alignment problem warnings in the file
>

Thanks for the patch, Siddhant.

Could you provide some information on how these warnings were
triggered?  Using Sphinx 2.4.4 I can't reproduce any warnings for
l2tp.rst using the "make htmldocs" target.

> Signed-off-by: Siddhant Gupta <siddhantgupta416@gmail.com>
> ---
>  Documentation/networking/l2tp.rst | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking=
/l2tp.rst
> index 498b382d25a0..0c0ac4e70586 100644
> --- a/Documentation/networking/l2tp.rst
> +++ b/Documentation/networking/l2tp.rst
> @@ -171,7 +171,8 @@ DEBUG              N        Debug flags.
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
>  Attribute          Required Use
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
> -CONN_ID            N        Identifies the tunnel id to be queried.
> +CONN_ID            N        Identifies the tunnel id=20
> +                            to be queried.
>                              Ignored in DUMP requests.
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
> =20
> @@ -208,8 +209,8 @@ onto the new session. This is covered in "PPPoL2TP So=
ckets" later.
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
>  Attribute          Required Use
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
> -CONN_ID            Y        Identifies the parent tunnel id of the sessi=
on
> -                            to be destroyed.
> +CONN_ID            Y        Identifies the parent tunnel id=20
> +                            of the session to be destroyed.
>  SESSION_ID         Y        Identifies the session id to be destroyed.
>  IFNAME             N        Identifies the session by interface name. If
>                              set, this overrides any CONN_ID and SESSION_=
ID
> @@ -222,13 +223,12 @@ IFNAME             N        Identifies the session =
by interface name. If
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
>  Attribute          Required Use
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
> -CONN_ID            Y        Identifies the parent tunnel id of the sessi=
on
> -                            to be modified.
> +CONN_ID            Y        Identifies the parent tunnel=20
> +                            id of the session to be modified.
>  SESSION_ID         Y        Identifies the session id to be modified.
> -IFNAME             N        Identifies the session by interface name. If
> -                            set, this overrides any CONN_ID and SESSION_=
ID
> -                            attributes. Currently supported for L2TPv3
> -                            Ethernet sessions only.
> +IFNAME             N        Identifies the session by interface name. If=
 set,
> +                            this overrides any CONN_ID and SESSION_ID
> +                            attributes. Currently supported for L2TPv3 E=
thernet sessions only.
>  DEBUG              N        Debug flags.
>  RECV_SEQ           N        Enable rx data sequence numbers.
>  SEND_SEQ           N        Enable tx data sequence numbers.
> @@ -243,10 +243,10 @@ RECV_TIMEOUT       N        Timeout to wait when re=
ordering received
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
>  Attribute          Required Use
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D =3D=3D=3D
> -CONN_ID            N        Identifies the tunnel id to be queried.
> -                            Ignored for DUMP requests.
> -SESSION_ID         N        Identifies the session id to be queried.
> -                            Ignored for DUMP requests.
> +CONN_ID            N        Identifies the tunnel id=20
> +                            to be queried. Ignored for DUMP requests.
> +SESSION_ID         N        Identifies the session id=20
> +                            to be queried. Ignored for DUMP requests.
>  IFNAME             N        Identifies the session by interface name.
>                              If set, this overrides any CONN_ID and
>                              SESSION_ID attributes. Ignored for DUMP
> --=20
> 2.25.1
>=20

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+09gYACgkQlIwGZQq6
i9DTxwf/SLwfWCMrHaCrc4Y+s2s8cVTn2d4yH1dKDB3Wx9wXpNjw/OeG92gDOGvF
HREPGel/uM92rPitEZ+rfWAAm3sQzOTX1hGLmovprJWEK2EznlDEToh+1dkmTVNN
UYC/iUKEFkQ32nrF3D5SX8iaHax/8rZUW3h0G9qbZCIk1y2jfOqI978uC5zTCC8Q
URN+h+/W6ULEttnH9J+yRBZmRzEApF/JgOkxLYCcqPn2ZI4/TerWaUOnHNT5O16K
b62YofMIDz6Wb749dDzzr1OLUMINNG2+JnycxvBwtVNW8YELizqS66uAdtaua6AS
O++/glHN4Htiel173mJFhpml2sRj5Q==
=1GS3
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
