Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7461E2B5EEC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgKQMM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQMMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 07:12:25 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D9D2C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 04:12:25 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 44A3096F0C;
        Tue, 17 Nov 2020 12:12:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605615144; bh=MANyvRZgnIQBpIfrUZpEpqwqqM1Ce1CZZc+w4DGC5Pk=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2017=20Nov=202020=2012:12:23=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[RFC=20PATCH=200/2]=20add=20ppp_generic=20ioctl=20to
         =20bridge=20channels|Message-ID:=20<20201117121223.GA4640@katalix.
         com>|References:=20<20201106181647.16358-1-tparkin@katalix.com>=0D
         =0A=20<20201109225153.GL2366@linux.home>=0D=0A=20<20201110115407.G
         A5635@katalix.com>=0D=0A=20<20201115115959.GD11274@linux.home>|MIM
         E-Version:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<202
         01115115959.GD11274@linux.home>;
        b=qgqgygKv33M1gjqbn2+rytY3Au8P9lTZ3TWJysu8i40krqgS+opFqZx+Giv2mthqj
         F3m/3uDp20aLfs05Bi2xzCgTlaxBsSncZTgywWC5cKY9CGmn2ttOwkcKJM/hcnw7Y3
         g+OpcIYFNDF/5fOneW0fUw1e0pfxPXuXLkz76aV8fFYB0naLpLQBw36n+s97kyD1q2
         qoh5GvuXPdIJNqYc5D5sEpLTgqLhfD++tGNz7jo5zAt7nhMSIuul1NkqjVIvfPqZT+
         J71xVleehlmDfG68sKQfI4zNQex7yhU12yuzxoe0id9szO9inEFsnQ+0PDk0KdE4zr
         rlSTrc497zbmA==
Date:   Tue, 17 Nov 2020 12:12:23 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201117121223.GA4640@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109225153.GL2366@linux.home>
 <20201110115407.GA5635@katalix.com>
 <20201115115959.GD11274@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20201115115959.GD11274@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Sun, Nov 15, 2020 at 12:59:59 +0100, Guillaume Nault wrote:
> On Tue, Nov 10, 2020 at 11:54:07AM +0000, Tom Parkin wrote:
> > On  Mon, Nov 09, 2020 at 23:51:53 +0100, Guillaume Nault wrote:
> > > BTW, shouldn't we have an "UNBRIDGE" command to remove the bridge
> > > between two channels?
> >=20
> > I'm not sure of the usecase for it to be honest.  Do you have
> > something specific in mind?
>=20
> I don't know if there'd be a real production use case. I proposed it
> because, in my experience, the diffucult part of any new feature is
> the "undo" operation. That's where many race conditions are found.
>=20
> Having a way to directly revert a BRIDGE operation might help testing
> the undo path (otherwise it's just triggered as a side effect of
> closing a file descriptor). I personally find that having symmetrical
> "do" and "undo" operations helps me thinking precisely about how to
> manage concurency. But that's probably a matter of preference. And that
> can even be done without exposing the "undo" operation to user space
> (it's just more difficult to test).
>=20
> Anyway, that was just a suggestion. I have no strong opinion.

Thanks for clarifying the point -- I agree with you about the "undo"
operation helping to expose race conditions.

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+zviMACgkQlIwGZQq6
i9DbswgAnKo7rb065az6+378BAThse6ktPWd0llPDvR+Fkc88NHn2p02hHI2DBBi
tKopsbJsAZ7eQQQ9kiQZ4HMCurEKSf6sEX3sLImelJY2uo2UKV2AspKYTuDD95VJ
puS7jA7SNiWNXXDVvOAjO9taDSrnfiqs4iyq15f+VV1hi+9nvpk8hv9hyinFJS5m
99VVT2/XQyYe2cjoDkJMR1T2vrDUfDhjSGXet9wJSpQnT4nLO9YhVWJ9ImGHzCpq
ToyFkocccTk+R0iPTP6l01W79nBe3YxCy4pJuIXWKFeMBiFWnub/xdLxjwXMVmz2
yE0KzFGvbF0e5PcnjkccZB8YwggOIw==
=oZNM
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
