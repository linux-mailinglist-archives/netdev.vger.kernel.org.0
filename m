Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F7F32280D
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhBWJtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:49:17 -0500
Received: from mail.katalix.com ([3.9.82.81]:41956 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhBWJsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 04:48:21 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 3AAC37D7D7;
        Tue, 23 Feb 2021 09:47:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1614073643; bh=tnwzJC31IFWWC25m+1HLNpSOksVzpW1SfEzxLEto8B8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2023=20Feb=202021=2009:47:22=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Kicinski=20<kuba@kerne
         l.org>|Cc:=20Matthias=20Schiffer=20<mschiffer@universe-factory.net
         >,=0D=0A=09netdev@vger.kernel.org,=20"David=20S.=20Miller"=20<dave
         m@davemloft.net>,=0D=0A=09linux-kernel@vger.kernel.org|Subject:=20
         Re:=20[PATCH=20net]=20net:=20l2tp:=20reduce=20log=20level=20when=2
         0passing=20up=20invalid=0D=0A=20packets|Message-ID:=20<20210223094
         722.GB12377@katalix.com>|References:=20<f2a482212eed80b5ba22cb590e
         89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>=0D=0
         A=20<20210219201201.GA4974@katalix.com>=0D=0A=20<2e75a78b-afa2-377
         6-2695-f9f6ac93eb67@universe-factory.net>=0D=0A=20<20210222114907.
         GA4943@katalix.com>=0D=0A=20<ec0f874e-b5af-1007-5a83-e3de7399ef29@
         universe-factory.net>=0D=0A=20<20210222143138.5711048a@kicinski-fe
         dora-pc1c0hjn.dhcp.thefacebook.com>|MIME-Version:=201.0|Content-Di
         sposition:=20inline|In-Reply-To:=20<20210222143138.5711048a@kicins
         ki-fedora-pc1c0hjn.dhcp.thefacebook.com>;
        b=gyQ8a+rkRdOgFSq2tz7n6m1l+XrGAVBtWhs+cW20E3HoCWpnt2NyDweturYAWvL3j
         Y/uN80ZgR0V8/7/D2S38eVXt6qXgzFWQcyxnSZxywg7dwTlwuBU1VzO5TLsp3SRlvl
         okEByXSlvnuE0EBfn7+72Po6EanXa/zbJn+S87AanxF4M7B9YMIS5Jx1Z+iCA57N82
         Vxko8NsR0XclubeZAsju0v4pbamuP4D5++5RfyKJ0tpOfiG83d8DGwfzBsaB8t+Tv7
         Ha64RGlwBLYkOE8wEDRnsuvED3XaYhNm3dPfEk1cYKXmcBk/vtLVsL0qhrpfH3c4++
         ZCLkQt7b4/uAA==
Date:   Tue, 23 Feb 2021 09:47:22 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matthias Schiffer <mschiffer@universe-factory.net>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <20210223094722.GB12377@katalix.com>
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
 <20210222114907.GA4943@katalix.com>
 <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
 <20210222143138.5711048a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20210222143138.5711048a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Feb 22, 2021 at 14:31:38 -0800, Jakub Kicinski wrote:
> On Mon, 22 Feb 2021 17:40:16 +0100 Matthias Schiffer wrote:
> > >> This will not be sufficient for my usecase: To stay compatible with =
older
> > >> versions of fastd, I can't set the T flag in the first packet of the
> > >> handshake, as it won't be known whether the peer has a new enough fa=
std
> > >> version to understand packets that have this bit set. Luckily, the s=
econd
> > >> handshake byte is always 0 in fastd's protocol, so these packets fai=
l the
> > >> tunnel version check and are passed to userspace regardless.
> > >>
> > >> I'm aware that this usecase is far outside of the original intention=
s of the
> > >> code and can only be described as a hack, but I still consider this a
> > >> regression in the kernel, as it was working fine in the past, without
> > >> visible warnings.
> > >> =20
> > >=20
> > > I'm sorry, but for the reasons stated above I disagree about it being
> > > a regression. =20
> >=20
> > Hmm, is it common for protocol implementations in the kernel to warn ab=
out=20
> > invalid packets they receive? While L2TP uses connected sockets and thu=
s=20
> > usually no unrelated packets end up in the socket, a simple UDP port sc=
an=20
> > originating from the configured remote address/port will trigger the "s=
hort=20
> > packet" warning now (nmap uses a zero-length payload for UDP scans by=
=20
> > default). Log spam caused by a malicous party might also be a concern.
>=20
> Indeed, seems like appropriate counters would be a good fit here?=20
> The prints are both potentially problematic for security and lossy.

Yes, I agree with this argument.

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmA0zyoACgkQlIwGZQq6
i9CH3Qf/clG5lDtXNq2mS54GSGRPZIAIt1VSkxdJ1FtHsdq5AJ+xjGXus4+wTpaQ
+DHRlcHmqmQS1qXPva6YQtOE67sxCeIhDw7qjyQH1aJMUrCGl0OnjnhgDwT8ma/L
sAS6Nh093X2uzJMfr83VOMaHWZ16zByaoNWSEiCZIQavBN+3ViSyeAApcii2fo4e
+mNsyraEkpRJNHEaDBZSJ5EjzaYK8VBLv7YaUpMjkL22Gtt6HlGVKnxpGfORK700
SatkR4kUQm4X+JV4YxdGRPJqQivGP0OdHyTb53/M7eDoKcKKd2ynQo1LydK0jdNT
bhEWN26GgFg35fLHr998UsTYdyYeIA==
=mF6k
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
