Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA91BD735
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 10:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgD2IYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 04:24:14 -0400
Received: from ozlabs.org ([203.11.71.1]:36145 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2IYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 04:24:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Bs492gLvz9sSM;
        Wed, 29 Apr 2020 18:24:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588148651;
        bh=syudK3ycUSJ0xlTm8LxvK+FlS93PkfQA7GEviu2GQjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=egh/oqyIh5YrPqtO2x5VeYEiNFDrRaCxS9XLAKOdF2AiKaNEM5jaHt+Q+/iyvz3y7
         GyHWi5UrTNttiPjwhzgNiYRx4dEuPcRyQsw5Yu7b1s1g3qImLmuhTSlFqMYhwxk5Eo
         flrELQY+FKT+Zp9EXiYPEY4siEhOrKFdGxle8tamFRYtht3wgPPxQAAsVIiMQw8LIw
         KqHVdZrPAR7mf3iDDla31yoxfM/eFnqjg/i7jQiNbZ0Ufz25z5BqRgVpepxX1xANFD
         TOmOu1A9XlzU3+dgcGR1UOpwQN7rYbXPTTXm0zp2Lm9gXUpJEIeeWinaAzeYmNmLcN
         /gePv+09WPyfQ==
Date:   Wed, 29 Apr 2020 18:24:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20200429182406.67582a6a@canb.auug.org.au>
In-Reply-To: <20200429065404.GA32139@lst.de>
References: <20200429164507.35ac444b@canb.auug.org.au>
        <20200429064702.GA31928@lst.de>
        <CAADnVQJWLPpt6tEGo=KkLBaHLpwZFLBfZX7UB4Z6+hMf6g220w@mail.gmail.com>
        <20200429065404.GA32139@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/W8DO522oYpzojNSk.1B7cDm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/W8DO522oYpzojNSk.1B7cDm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, 29 Apr 2020 08:54:04 +0200 Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Apr 28, 2020 at 11:49:34PM -0700, Alexei Starovoitov wrote:
> > On Tue, Apr 28, 2020 at 11:47 PM Christoph Hellwig <hch@lst.de> wrote: =
=20
> > >
> > > On Wed, Apr 29, 2020 at 04:45:07PM +1000, Stephen Rothwell wrote: =20
> > > >
> > > > Today's linux-next merge of the akpm-current tree got a conflict in:
> > > >
> > > >   kernel/sysctl.c
> > > >
> > > > between commit:
> > > >
> > > >   f461d2dcd511 ("sysctl: avoid forward declarations")
> > > >
> > > > from the bpf-next tree and commits: =20
> > >
> > > Hmm, the above should have gone in through Al.. =20
> >=20
> > Al pushed them into vfs tree and we pulled that tag into bpf-next. =20
>=20
> Ok.  And Stephen pulled your tree first.

No, it is not in the branch I fetch from Al yet.

--=20
Cheers,
Stephen Rothwell

--Sig_/W8DO522oYpzojNSk.1B7cDm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6pOaYACgkQAVBC80lX
0GyfPgf5AfDRR+uaAmpYyPjYWiIziyaXRfGhaZxYrS0542Jel2ojgZZlJOPKqEYJ
UGHZgKYR8CYrHZzQg8/4+oSPk0qGhFz5tg8BjCQpaqTMTDSKeZ9WraDohke4CoJf
8TyBurjmVASZqwiVBAJJSvIYyszdUmK1D1XzeZ7qb9snSADRKDT8wKkeSRzwdL8a
MVRCdXbkXyI6jlBvqocsPe13WNaHMgNk/7iXRfpkoEclxylotRwhH7iBrl100pgw
SkBQOKW1R8RQBAZDjPqXPAqIBYPzENFecb4NKKjWNsFEQ6dkqnz0dcjwEkCGLr3w
ItdEZpCS//knWCcZnw1cc68FbPgEXw==
=U/RL
-----END PGP SIGNATURE-----

--Sig_/W8DO522oYpzojNSk.1B7cDm--
