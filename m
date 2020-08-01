Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAC3234EEF
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgHAAfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:35:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43911 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgHAAfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 20:35:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BJQCc1Qg1z9sRN;
        Sat,  1 Aug 2020 10:35:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596242109;
        bh=qptL9rZVDvCzlSjehblBU29W+67xUM1GmzHjZXT5Hb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ddecffKljWBCOn6MIZkGZmxanfhqh9J98Hp1GTbJBJY0eWTVGWz5p45nkGtHMfY/U
         mO9aACcEOOxDIOaIFzp0a1FgkoHff6xghfvw+wL7ZJZbZl2zS5q1JMKmvhGLZFDnq+
         GfOxSLbDgFRTzbc1ENRQMf0Dtbs5FqRdnFDGducMX229ey4Lj/3Byt6NJ/ow7bYiwa
         nOR00vdTWJPvJ2yDZyidQ65veIVLzKv3qPrJxPLjdtLOq1YJtustkn0bfgesJ2Wn4L
         Bhgmh/F7sXexC3aK9uf98/3WNWBkouLELP96BOWkJ0UtsUC2q2Vgm7rAczXiXcVzQl
         5/9+UpckrNc1g==
Date:   Sat, 1 Aug 2020 10:35:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net,
        Brian Vazquez <brianvv@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Jul 31 (net/decnet/ & FIB_RULES)
Message-ID: <20200801103507.03ae069b@canb.auug.org.au>
In-Reply-To: <4c6abcd0-e51b-0cf3-92de-5538c366e685@infradead.org>
References: <20200731211909.33b550ec@canb.auug.org.au>
        <4c6abcd0-e51b-0cf3-92de-5538c366e685@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aAhoT0OmEEIdQxMbbWMirMx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aAhoT0OmEEIdQxMbbWMirMx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 31 Jul 2020 08:53:09 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on i386:
>=20
> ld: net/core/fib_rules.o: in function `fib_rules_lookup':
> fib_rules.c:(.text+0x16b8): undefined reference to `fib4_rule_match'
> ld: fib_rules.c:(.text+0x16bf): undefined reference to `fib4_rule_match'
> ld: fib_rules.c:(.text+0x170d): undefined reference to `fib4_rule_action'
> ld: fib_rules.c:(.text+0x171e): undefined reference to `fib4_rule_action'
> ld: fib_rules.c:(.text+0x1751): undefined reference to `fib4_rule_suppres=
s'
> ld: fib_rules.c:(.text+0x175d): undefined reference to `fib4_rule_suppres=
s'
>=20
> CONFIG_DECNET=3Dy
> CONFIG_DECNET_ROUTER=3Dy
>=20
> DECNET_ROUTER selects FIB_RULES.

I assume that CONFIG_IP_MULTIPLE_TABLES was not set for that build?

Caused by commit

  b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_rul=
es_ops")

from the net-next tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/aAhoT0OmEEIdQxMbbWMirMx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8kuLsACgkQAVBC80lX
0GwErAf/aR9OAWhgszrLS/SC/5se79Mhs6m5ahnU1CLo12hq2AxnEEiew0lv+rGy
QuhEd2bGfRXA3msswury9J1+9gD52q9aME6Wfer9Uc7/hLwCJg6yAvc46l3K3T6N
+wQZdTLHTakS4d0CGxz4DEFnYivWo134xPb6EwhI9q0BTYtuWStZBHXsROim8WT0
jzYbmPTSdi+K/YQy1b7hzHcyBj0OOQIopn4YcmkfGYZL7quB0ZRkMxzQW+nalCp6
LbcgbIxUzFKP4DnOBAStji+X8+dQi0JtN0lQ+dAgiDklzVMf+qD+SJw6+0xzaHUF
kd8e26RJAx863nNjCNPtNi7z5Hqq7w==
=38aF
-----END PGP SIGNATURE-----

--Sig_/aAhoT0OmEEIdQxMbbWMirMx--
