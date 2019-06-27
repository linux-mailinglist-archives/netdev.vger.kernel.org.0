Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9032657907
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 03:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfF0Bpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 21:45:40 -0400
Received: from ozlabs.org ([203.11.71.1]:57969 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfF0Bpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 21:45:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Z2m11dlfz9sCJ;
        Thu, 27 Jun 2019 11:45:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561599937;
        bh=81FSZHDgH28AVa4MeUVlcelNCGqVcxfM0/bSKVPs9ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h6+/Ds+TV3xmRNYImuUdT8vJq7WYBxOZVqat7KMasdshUkVhYP6Mapcw1iGwtttl9
         IEYP6fTawKj6m46pzDEkYqfhRV5hawe8mTorcHW6TMUOQBQvVxgcB4j/wgCtSolYl4
         //aSKfuFp3IvxovjgNtCskC55wxzqKQ6ssuVJO8Jff6uD6SBTiYg9NhW8N2ad8qdCd
         rRPFB0C2IHv7EX8W9ftWPYTl8OZK0hKiVTY5Uhn8lzgvwz+S/WA+Dtd/o9IiocToTh
         7U4rq0276UHtgNQ7ixHzbr3K4hyF6Iqbqn4O/uud0TQIn0hxu3WTBFxDbOK8l92vvb
         cA2bGr4/wI/8A==
Date:   Thu, 27 Jun 2019 11:45:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
Message-ID: <20190627114536.09c08f5d@canb.auug.org.au>
In-Reply-To: <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
References: <20190627080521.5df8ccfc@canb.auug.org.au>
        <20190626221347.GA17762@tower.DHCP.thefacebook.com>
        <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7u90A+dZmO=x5m+8WaV.bo8"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7u90A+dZmO=x5m+8WaV.bo8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 26 Jun 2019 16:36:50 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> On Wed, Jun 26, 2019 at 3:14 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Jun 27, 2019 at 08:05:21AM +1000, Stephen Rothwell wrote: =20
> > >
> > > In commit
> > >
> > >   12771345a467 ("bpf: fix cgroup bpf release synchronization")
> > >
> > > Fixes tag
> > >
> > >   Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from
> > >
> > > has these problem(s):
> > >
> > >   - Subject has leading but no trailing parentheses
> > >   - Subject has leading but no trailing quotes
> > >
> > > Please don't split Fixes tags across more than one line. =20
> >
> > Oops, sorry.
> >
> > Alexei, can you fix this in place?
> > Or should I send an updated version? =20
>=20
> I cannot easily do it since -p and --signoff are incompatible flags.
> I need to use -p to preserve merge commits,
> but I also need to use --signoff to add my sob to all
> other commits that were committed by Daniel
> after your commit.
>=20
> Daniel, can you fix Roman's patch instead?
> you can do:
> git rebase -i -p  12771345a467^
> fix Roman's, add you sob only to that one
> and re-push the whole thing.

It's probably not worth fixing, just use this as a learning
experience ...

--=20
Cheers,
Stephen Rothwell

--Sig_/7u90A+dZmO=x5m+8WaV.bo8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0UH8AACgkQAVBC80lX
0GzJ0Qf/ajJwCOWDbYQEf7IpMsA/fgyGl9ocfvMMJxPvVBl7p1ApAgXv+BVbkewh
hxEHSEMikoY3UYzkb5B8yz7EtRbh10h8a9trdmlmWW3mKqNSp5H3CjMkJUJDz6Ob
HQ6h+iiijHozutoa65mVPa5GkKwR00cuY0dvu/trghiSgx2wGWkaq8rhYPezIbTw
P/zWzYrg2T+Hdll7+KDVEizhb40JhQIM8gycHr+lR7srsKEJ1kj6mSm2rJQbJDVS
HQDKmbV65WawDlw1jkdfM1OIVB3PcvvfpKjZFHfURQ5sy+zBFSD40sdpMQEkF71O
wkx/IoqyGQlzuHi9KR8DbbrJPFtbbw==
=3WPY
-----END PGP SIGNATURE-----

--Sig_/7u90A+dZmO=x5m+8WaV.bo8--
