Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F092D72F6
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437496AbgLKJhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:37:03 -0500
Received: from mail.katalix.com ([3.9.82.81]:56648 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405635AbgLKJgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 04:36:53 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id DF87488904;
        Fri, 11 Dec 2020 09:36:09 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1607679370; bh=EXUb0pfDfYMAwM5IH1CiciwOIy0uI8NLjI6kaBiVzvo=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Fri,=2011=20Dec=202020=2009:36:09=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20David=20Miller=20<davem@daveml
         oft.net>|Cc:=20gnault@redhat.com,=20netdev@vger.kernel.org,=20jcha
         pman@katalix.com|Subject:=20Re:=20[PATCH=20v4=20net-next=200/2]=20
         add=20ppp_generic=20ioctl(s)=20to=20bridge=0D=0A=20channels|Messag
         e-ID:=20<20201211093609.GA5112@katalix.com>|References:=20<2020121
         0155058.14518-1-tparkin@katalix.com>=0D=0A=20<20201210171309.GC157
         78@linux.home>=0D=0A=20<20201210171645.GB4413@katalix.com>=0D=0A=2
         0<20201210.142134.777780809639324675.davem@davemloft.net>|MIME-Ver
         sion:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<20201210
         .142134.777780809639324675.davem@davemloft.net>;
        b=Qe314yLrHScZrzfk1AveH7Sf5zfNLLBWrrbg82LYyouFdfrgHbkdcJv8uAqIsXMGI
         OkqxoCQE0FV0YYhs9LiTX6OEK3zK0sSWhkBTrcoVWH+BRB/vib3jlAwzPzrQdSUiIP
         ASbHNS4oxwKBXrtUXwCDuVnH/lWX3kzzCpZNguTheEifpe2uvnXJfmhT1lOQw9qJV+
         4llzzbrPKqqKTewZ1qkYfhr6bQP3/wwo4uHlEegBuF6Os13pp7nJ/eAdLVaCC94N2F
         dkUpfl2awN93lI8z0gK71luX8xQBzeMkyhTRfU0Wh0o5WmTPlMoAdvwqJtjsqRKqyC
         ++Kfk4vgeaujg==
Date:   Fri, 11 Dec 2020 09:36:09 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     David Miller <davem@davemloft.net>
Cc:     gnault@redhat.com, netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v4 net-next 0/2] add ppp_generic ioctl(s) to bridge
 channels
Message-ID: <20201211093609.GA5112@katalix.com>
References: <20201210155058.14518-1-tparkin@katalix.com>
 <20201210171309.GC15778@linux.home>
 <20201210171645.GB4413@katalix.com>
 <20201210.142134.777780809639324675.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20201210.142134.777780809639324675.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Dec 10, 2020 at 14:21:34 -0800, David Miller wrote:
> From: Tom Parkin <tparkin@katalix.com>
> Date: Thu, 10 Dec 2020 17:16:45 +0000
>=20
> > On  Thu, Dec 10, 2020 at 18:13:09 +0100, Guillaume Nault wrote:
> >> On Thu, Dec 10, 2020 at 03:50:56PM +0000, Tom Parkin wrote:
> >> > Following on from my previous RFC[1], this series adds two ioctl cal=
ls
> >> > to the ppp code to implement "channel bridging".
> >> >=20
> >> > When two ppp channels are bridged, frames presented to ppp_input() on
> >> > one channel are passed to the other channel's ->start_xmit function =
for
> >> > transmission.
> >> >=20
> >> > The primary use-case for this functionality is in an L2TP Access
> >> > Concentrator where PPP frames are typically presented in a PPPoE ses=
sion
> >> > (e.g. from a home broadband user) and are forwarded to the ISP netwo=
rk in
> >> > a PPPoL2TP session.
> >>=20
> >> Looks good to me now. Thanks Tom!
> >>=20
> >> Reviewed-by: Guillaume Nault <gnault@redhat.com>
> >>=20
> >=20
> > Thanks again for your review and help with the series :-)
>=20
> Series applied.

Thanks Dave.  Nice to see you back :-)

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/TPYQACgkQlIwGZQq6
i9Dh7AgAiq6rWXYmUr/CrEKOE2PyqL0C9uubgyZjiHJwJ5hbCtQCcKbLW1FS2Xco
HDIhqiHXwAvxGlv1cHt2IuzxMrsUw5T9J3MofsteY04L8Yd8k3Nkf9Ier7E9SKHS
ISBmCemRcatzrCT7h9eX9oeqxyA5h2hIYL14KZF5e32CkwyeRTBWZnxjoWakGLro
+Rh2iy6hygqUHK9lagzcJaym1Eh/mgMZUyglA0Z4aqRVUdTbGTbR5+EpMoQmLFTk
aB+Ty33I8hsLQar1ytBnUVxjf676loLQi2jNQUhuQiquE9OrnvlfebRmH/aI/xCW
ihDTyFI84rD0hbfc9t7/7fUqgj9/uA==
=3B3t
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
