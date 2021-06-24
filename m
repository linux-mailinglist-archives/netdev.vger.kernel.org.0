Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACC23B3959
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhFXWno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:43:44 -0400
Received: from ozlabs.org ([203.11.71.1]:39751 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhFXWnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:43:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G9w8q4svlz9sV8;
        Fri, 25 Jun 2021 08:41:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624574477;
        bh=Dzv52F0SnnFNYtb+bHVaVYmqTSKv7JgbUkh4dGMK1G4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rljYfYqLBYPqi3yaoU8df5DSATRX2yaxSAUCltw/4bX3jJuERSFCSYH885HrGPNQ4
         Tah0CKLhvnev+bEVMgMZueWnrsD0iQLv8OnB9oAal+7BGQgt8ITE+2m8AA9wu51aJJ
         K94xkURch6Ioy2MycJEj/6ZO5X+FrkRotl3yNJT3EnQ5BFsAvwyZaDfg0d8XK/d/uT
         Dj3o10RhlnFYb067vVNhDrenyhCgNl40Oa5NJbAZ+hq1e/h4jOKgt8HYl83aiETzPy
         Y6Qn5AwRslPHjKoycanOO4TQTZLTEHrAEU43EOzIjn84nu0VamSey4Rw3eyHFTT1xh
         hUTuXIQC6WVMg==
Date:   Fri, 25 Jun 2021 08:41:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210625084114.4126dd02@canb.auug.org.au>
In-Reply-To: <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
References: <20210624082911.5d013e8c@canb.auug.org.au>
        <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
        <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain>
        <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
        <20210624185430.692d4b60@canb.auug.org.au>
        <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fsjcmTTZ98dxqF2S9vcrms2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fsjcmTTZ98dxqF2S9vcrms2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Marcin,

On Thu, 24 Jun 2021 16:25:57 +0200 Marcin Wojtas <mw@semihalf.com> wrote:
>
> Just to understand correctly - you reverted merge from the local
> branch (I still see the commits on Dave M's net-next/master). I see a

Yes, I reverted the merge in linux-next only.

> quick solution, but I'm wondering how I should proceed. Submit a
> correction patch to the mailing lists against the net-next? Or the
> branch is going to be reverted and I should resubmit everything as v4?

I see others have answered this.

--=20
Cheers,
Stephen Rothwell

--Sig_/fsjcmTTZ98dxqF2S9vcrms2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDVCgoACgkQAVBC80lX
0GzmWwf/fr8EWOF5GQYVveJX5NrFqj8EcNIrHX9mXjVZPvXEWqQiyvnDEBXxkzmf
9B+CQIKIyMkAnJOS3P3jJVteoy2+9SzTzEbHtYDp2yelazNDNG80Oe5H0UwZ7nYU
mY+ba2x6vs88YoO8NB24WnIV56zul+tEo3SJH8bwdCg7ayX5HwpvjCHu+XEqf3Dw
cUErzauWomCu5lBSBfifO5tpr7+Zl2T/1xVRSSVBr70KlwigvCKIqy5oSMR5YY7R
f5cB9/H0Zemr2qj7zRjUUEPYjlOzksM5tTbl4PB0EUw5QJevCed/q5vVTb3cVUQn
XaMJ79suCXHMJLIso5B/pgazhPL8nQ==
=yG3T
-----END PGP SIGNATURE-----

--Sig_/fsjcmTTZ98dxqF2S9vcrms2--
