Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1813570E4E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbfGWAto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:49:44 -0400
Received: from ozlabs.org ([203.11.71.1]:32883 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbfGWAto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 20:49:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45t0HS63rMz9s3Z;
        Tue, 23 Jul 2019 10:49:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1563842981;
        bh=jBu0G6LyfdLlQ4QDdrcU7I+Un+OaoeNp8y0aT+nDIuc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EW0D7T3i9Jefogo6s3HH7TtQsS6HV/Gj2/9IY35QrYgsE/O6TQkEAKF5GFA08XWBC
         WLx/D/Tl3OvSS4uJF+4powZVWfgozGVTzXOsb1PNtvAVH2DsbqxqLYWK91u5hhEJQ6
         Bon2CD+CWfKnuMhnuM5fQ5o+SQqUbkwcwf5LZFyp4gZJZRCJOs7zc/P5Uxn+zcP3Ot
         HnGd8VCrVmjBIVNPWx2LFf/U/SfQWBvUwM9MxV4SXnRscQuYZw9MQbSiJ++GXshTmQ
         WaXXJGjnw3L/rXkPMWqoJKWNH2hpa5LTLLD+1JtfY4bMK+nJOfEJSabZhZKpnSnwaR
         LtSywj7P4D3MA==
Date:   Tue, 23 Jul 2019 10:49:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20190723104940.0adf5524@canb.auug.org.au>
In-Reply-To: <CANP3RGcqGrPnt9eOiAKRbxWVuBkRHRQdWPnANKwrYvtVnTqaSQ@mail.gmail.com>
References: <20190723073518.59fa66e0@canb.auug.org.au>
        <CANP3RGcqGrPnt9eOiAKRbxWVuBkRHRQdWPnANKwrYvtVnTqaSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Zt2g9Tv+QL2CPzT=BHt.MT9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Zt2g9Tv+QL2CPzT=BHt.MT9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Maciej,

On Tue, 23 Jul 2019 09:46:29 +0900 Maciej =C5=BBenczykowski <zenczykowski@g=
mail.com> wrote:
>
> I'm afraid I'm currently travelling and due to an unplanned and f'ed up
> office move I've lost (access to?) my dev workstation so I can't respin
> this.  Might be too late either way?

Yeah, Dave doesn't rebase his trees, so just take this as a lesson for
next time. :-)

--=20
Cheers,
Stephen Rothwell

--Sig_/Zt2g9Tv+QL2CPzT=BHt.MT9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl02WaQACgkQAVBC80lX
0GxIbgf/frRFMoWj8sD3HB2d4J8J+lqC1BgzDcqAgvm9mazSlYtq6bG70LCEFJ0Q
KRnpYclsvCnWb0AmsWWrgso9ZSW2CiMC6Hh/NHy43M7KSNpoMw/xUfTza0qr06og
wBB3aJnTJPqMpTrZngLwCtVyYwWwoVtlPtuOR9lHAPjBkiw3LsVo9CJP5ERGeWQc
ifpS2qNSOxJY19RiB2rNlVAOrOvIdG+qfuDS7x8iw9tcFnoiGCza+hlo0leXJWBI
G1KwVf62s12JNHtV/F8Ve6OL3xXKVuZRH0hKomGGtwERWp+xeorzwVAWxLRupp5B
7VPouMYStir2gp9jtb9H1J1mZozNCQ==
=A0ss
-----END PGP SIGNATURE-----

--Sig_/Zt2g9Tv+QL2CPzT=BHt.MT9--
