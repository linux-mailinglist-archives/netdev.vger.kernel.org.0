Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2F2EC6CE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbhAFXUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:20:51 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:60601 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbhAFXUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 18:20:50 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DB51g2BkMz9sVm;
        Thu,  7 Jan 2021 10:20:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1609975208;
        bh=DJN3TBR7HBX0MH3urn36IhtdNpfrvjW2AVcJoxG+GQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sfpONZczjK1FwAm8LXekG3+aiG4gMcswTMseN/DrttN3l8Hb0XIqoXkuybhfLF5PV
         bJ0i1qMEm0I6uBLLeCnoalEcJEKDBxhapRtWI3IOGlAIj1nyTn1wCkjHZmimqatA5I
         iVV1YdzqBbPPBV9CR4MWPd5ebXINE3qwhX7YP/ls9qqhY9rGq3ZTCbYjHy3JS93yCz
         m9Jg7oumVJSeQGjOmX+YlpVb84ifKXbx2uznvC9iHSY1EZzsXKkvlW0/xMamfXR3kP
         an+lgoz8GKPfyJUwCxeFNZ9D81TvmVoBSjM2DSkVdD7IRb9U5EXvnSQxJNPYrruC5l
         77HjuMGDadcQQ==
Date:   Thu, 7 Jan 2021 10:20:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the origin tree
Message-ID: <20210107102006.2fd2460c@canb.auug.org.au>
In-Reply-To: <5d8482756d40df615f908d7f24decdbb9ccb0ac3.camel@sipsolutions.net>
References: <20210107090550.725f9dc9@canb.auug.org.au>
        <220ccdfe5f7fad6483816cf470a506d250277a1a.camel@sipsolutions.net>
        <20210107094414.607e884e@canb.auug.org.au>
        <5d8482756d40df615f908d7f24decdbb9ccb0ac3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5TKbKUEcHup3XUNhed6rmVS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5TKbKUEcHup3XUNhed6rmVS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Wed, 06 Jan 2021 23:46:45 +0100 Johannes Berg <johannes@sipsolutions.net=
> wrote:
>
> > > Right, thanks. I believe I also fixed it in the patch I sent a few da=
ys
> > > ago that fixed the other documentation warning related to SAR that you
> > > reported. =20
> >=20
> > I don't think so :-(  I did a htmldocs build with your patch ([PATCH
> > v2] cfg80211/mac80211: fix kernel-doc for SAR APIs) on top of Linus'
> > tree and still got this warning.  That patch did not touch
> > include/net/mac80211.h ... =20
>=20
> Umm, I don't know what to say. I even added "cfg80211/mac80211" to the
> subject, but somehow lost the change to mac80211.h. Sorry about that :(

No worries.

> I'll get a v3 out.

Thanks.
--=20
Cheers,
Stephen Rothwell

--Sig_/5TKbKUEcHup3XUNhed6rmVS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/2RaYACgkQAVBC80lX
0GzDXAf+LHyWITaVHMe0IY514xDxQKXdZnVdJ3aTNxqxOqq8RzUnnJJMCZWOeO0f
YKD3X+Sll1Aw5i1DpESzlnNqz5u852c1z0bldJns+L1O63RG0lg3SNAz7/bIRxdy
I3GwBSm1AmX/ko/RmCKwfOBoJpkq2jpe8BTtRl1z/UuZgADQ8mSwgJa7BJuVvoQ8
O12yX3HJUBuAQnUAZwnE/izE/Mf2UQuwyk0rlSDGAD62ioKp48mNCBS9pavivV26
PP5rVbOJxGdd2L/LgOFb2pNaXrbYBrhYGLU7c+VFH43qtN0Zsa+hsDQPfjgLiVIH
UbYIWbrHKyhrQhlQtmrMtc2AGhLnUg==
=Q9GU
-----END PGP SIGNATURE-----

--Sig_/5TKbKUEcHup3XUNhed6rmVS--
