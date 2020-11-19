Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D212B8F3D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgKSJpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:45:52 -0500
Received: from mail.katalix.com ([3.9.82.81]:46508 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgKSJpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 04:45:51 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 492747EBB6;
        Thu, 19 Nov 2020 09:45:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605779149; bh=qZYA4hRJanvw75BeKRiUx+glJe1ExsAwlK0VZObC4Ic=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=2019=20Nov=202020=2009:45:48=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20siddhant=20gupta=20<siddhantgu
         pta416@gmail.com>|Cc:=20davem@davemloft.net,=20kuba@kernel.org,=20
         corbet@lwn.net,=0D=0A=09netdev@vger.kernel.org,=20linux-doc@vger.k
         ernel.org,=0D=0A=09linux-kernel@vger.kernel.org,=0D=0A=09Mamta=20S
         hukla=20<mamtashukla555@gmail.com>,=0D=0A=09Himadri=20Pandya=20<hi
         madrispandya@gmail.com>|Subject:=20Re:=20[PATCH]=20Documentation:=
         20networking:=20Fix=20Column=20span=20alignment=0D=0A=20warnings=2
         0in=20l2tp.rst|Message-ID:=20<20201119094548.GA3927@katalix.com>|R
         eferences:=20<20201117095207.GA16407@Sleakybeast>=0D=0A=20<2020111
         8102307.GA4903@katalix.com>=0D=0A=20<CA+imup-3pT47CVL7GZn_vJtHGngN
         exBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>|MIME-Version:=201.0|Content
         -Disposition:=20inline|In-Reply-To:=20<CA+imup-3pT47CVL7GZn_vJtHGn
         gNexBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>;
        b=jHGQYkIhlT4bQULB4OuAlUsI4LhjKmSqSOXuzkCBoFdACySbiC5nXHLAu9mrm7fdQ
         WViDVAa1gNUVlbkkq+uJLRW8vXzRExhOo7JqaxI0erR7O13eSLz+Dg5AxBvWfa3aqM
         EFvYm7v0RQy07A3ChOwBXoY5kcU/xW70+fzYgUEKsZ+u+9y44p6FsqCyZasnOwWnto
         pUwp6CPUUfXJwM8NjpDEoM6qUPL6Gfmuo2SnGOybCF/FqCsTLd9fmo+oD735l+bdMJ
         nUSaZ5Neo0Kav2/n8vCLIOLRsSdZWMB2auvBfMcyU/4q09DyH75xlj3OHbM68qUtVq
         +cHxZ2YWsipdQ==
Date:   Thu, 19 Nov 2020 09:45:48 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     siddhant gupta <siddhantgupta416@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: Re: [PATCH] Documentation: networking: Fix Column span alignment
 warnings in l2tp.rst
Message-ID: <20201119094548.GA3927@katalix.com>
References: <20201117095207.GA16407@Sleakybeast>
 <20201118102307.GA4903@katalix.com>
 <CA+imup-3pT47CVL7GZn_vJtHGngNexBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <CA+imup-3pT47CVL7GZn_vJtHGngNexBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Wed, Nov 18, 2020 at 16:44:11 +0530, siddhant gupta wrote:
> On Wed, 18 Nov 2020 at 15:53, Tom Parkin <tparkin@katalix.com> wrote:
> >
> > On  Tue, Nov 17, 2020 at 15:22:07 +0530, Siddhant Gupta wrote:
> > > Fix Column span alignment problem warnings in the file
> > >
> >
> > Thanks for the patch, Siddhant.
> >
> > Could you provide some information on how these warnings were
> > triggered?  Using Sphinx 2.4.4 I can't reproduce any warnings for
> > l2tp.rst using the "make htmldocs" target.
> >
>=20
> I am currently using Sphinx v1.8.5 and I made use of command "make
> htmldocs >> doc_xxx.log 2>&1" for directing the errors into a file and
> the statements in the file showed me these warning, also to confirm
> those I tried using "rst2html" on l2tp.rst file and got same set of
> warnings.

Thanks for confirming.

I tried 1.8.5 here in a new virtualenv and I didn't see warnings there
either.

I can easily imagine different toolchains triggering different
warnings, but it's frustrating we can't reproduce them.

I have no objection to merging the patch, more interested in catching
similar problems in the future.

> > > Signed-off-by: Siddhant Gupta <siddhantgupta416@gmail.com>
> > > ---
> > >  Documentation/networking/l2tp.rst | 26 +++++++++++++-------------
> > >  1 file changed, 13 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/Documentation/networking/l2tp.rst b/Documentation/networ=
king/l2tp.rst
> > > index 498b382d25a0..0c0ac4e70586 100644
> > > --- a/Documentation/networking/l2tp.rst
> > > +++ b/Documentation/networking/l2tp.rst
> > > @@ -171,7 +171,8 @@ DEBUG              N        Debug flags.
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > >  Attribute          Required Use
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > > -CONN_ID            N        Identifies the tunnel id to be queried.
> > > +CONN_ID            N        Identifies the tunnel id
> > > +                            to be queried.
> > >                              Ignored in DUMP requests.
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > >
> > > @@ -208,8 +209,8 @@ onto the new session. This is covered in "PPPoL2T=
P Sockets" later.
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > >  Attribute          Required Use
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > > -CONN_ID            Y        Identifies the parent tunnel id of the s=
ession
> > > -                            to be destroyed.
> > > +CONN_ID            Y        Identifies the parent tunnel id
> > > +                            of the session to be destroyed.
> > >  SESSION_ID         Y        Identifies the session id to be destroye=
d.
> > >  IFNAME             N        Identifies the session by interface name=
=2E If
> > >                              set, this overrides any CONN_ID and SESS=
ION_ID
> > > @@ -222,13 +223,12 @@ IFNAME             N        Identifies the sess=
ion by interface name. If
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > >  Attribute          Required Use
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > > -CONN_ID            Y        Identifies the parent tunnel id of the s=
ession
> > > -                            to be modified.
> > > +CONN_ID            Y        Identifies the parent tunnel
> > > +                            id of the session to be modified.
> > >  SESSION_ID         Y        Identifies the session id to be modified.
> > > -IFNAME             N        Identifies the session by interface name=
=2E If
> > > -                            set, this overrides any CONN_ID and SESS=
ION_ID
> > > -                            attributes. Currently supported for L2TP=
v3
> > > -                            Ethernet sessions only.
> > > +IFNAME             N        Identifies the session by interface name=
=2E If set,
> > > +                            this overrides any CONN_ID and SESSION_ID
> > > +                            attributes. Currently supported for L2TP=
v3 Ethernet sessions only.
> > >  DEBUG              N        Debug flags.
> > >  RECV_SEQ           N        Enable rx data sequence numbers.
> > >  SEND_SEQ           N        Enable tx data sequence numbers.
> > > @@ -243,10 +243,10 @@ RECV_TIMEOUT       N        Timeout to wait whe=
n reordering received
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > >  Attribute          Required Use
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D
> > > -CONN_ID            N        Identifies the tunnel id to be queried.
> > > -                            Ignored for DUMP requests.
> > > -SESSION_ID         N        Identifies the session id to be queried.
> > > -                            Ignored for DUMP requests.
> > > +CONN_ID            N        Identifies the tunnel id
> > > +                            to be queried. Ignored for DUMP requests.
> > > +SESSION_ID         N        Identifies the session id
> > > +                            to be queried. Ignored for DUMP requests.
> > >  IFNAME             N        Identifies the session by interface name.
> > >                              If set, this overrides any CONN_ID and
> > >                              SESSION_ID attributes. Ignored for DUMP
> > > --
> > > 2.25.1
> > >

--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+2PsgACgkQlIwGZQq6
i9BnrQf9FdingP4j1x+yAX6Qfk2Aj1cc9hbxrzarGj/rSXVrR/GaKGJlh3o4tKVg
ijM/GxAoTrEXLcJ4Ovz3BrmrYIesHk3Bks2PXOaKL8RfLvneSRyo8zinMVh1nAva
UcmKyeKDvjPWc2GpCLsnXSHvxICyfSn15vuI2ctlp1vo4p6ohEIH2zPsJaph53IH
ZOANB+IMVFf2tmAZb5cUZijcwPqd9NUrkqHv7MtamjocdTPUKRBrKgs6V58tzHw3
u+sQVHVU60mYmJhZXWIPNoPHdqGbjIHgV1xy5TJWmnTlLhiEUNCbe2/EHq/Hk+rf
TG6Ka9mBBpAXg0lIxrsbmGJoNR8l6A==
=CJrS
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
