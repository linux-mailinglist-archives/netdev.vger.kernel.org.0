Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12592247B7
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgGRB1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRB1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:27:32 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D339BC0619D2;
        Fri, 17 Jul 2020 18:27:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B7r2P6Vgdz9sRN;
        Sat, 18 Jul 2020 11:27:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595035649;
        bh=o2jh73wY/BEWuyLoEG0bvrwZazd7N4PFTPPub5B2atU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JOo7strTfjmVttCTTxg9WE902GNbyorNyCSRtpe1qJcuy5IqV/2Rravo2f6wEteQ5
         LZXtc0XRKfrQ5lqks/rhkF08X8yzJb6NCgE3UMuhMVCN2vJImqGGQGLGNEs/GMjW/C
         jA+hprzlBI2C8N98g1vKn7UCCHfKKsKRXnYAxvlIlO6dDh6Y94UynyB2i8mtajsNMT
         2yXaMZvciqHGpD/KpMVg0UA17oThSqKRZqwXzO8aLjO90RYkWP2k3y6uFVL5bh09Bn
         hNNQ2sgK0BGCQ0kNRS18vS1c1TLGR2xCENTlVSKSPN53z4mFQ5oVkFUE7Qo+wHxNgB
         UX8/Bv/a+ENRw==
Date:   Sat, 18 Jul 2020 11:27:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Andrew Sy Kim <kim.andrewsy@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: mmotm 2020-07-16-22-52 uploaded (net: IPVS)
Message-ID: <20200718112724.7942017c@canb.auug.org.au>
In-Reply-To: <88196a8a-2778-0324-8005-d63bfee86c4e@infradead.org>
References: <20200717055300.ObseZH9Vs%akpm@linux-foundation.org>
        <88196a8a-2778-0324-8005-d63bfee86c4e@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6ak9qiB1pzNzTN7Qt/ByRlc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6ak9qiB1pzNzTN7Qt/ByRlc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 17 Jul 2020 08:30:04 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> (also in linux-next)
>=20
> Many of these errors:
>=20
> In file included from ../net/netfilter/ipvs/ip_vs_conn.c:37:0:
> ../include/net/ip_vs.h: In function =E2=80=98ip_vs_enqueue_expire_nodest_=
conns=E2=80=99:
> ../include/net/ip_vs.h:1536:61: error: parameter name omitted
>  static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs) =
{}

Caused by commit

  04231e52d355 ("ipvs: queue delayed work to expire no destination connecti=
ons if expire_nodest_conn=3D1")

from the netfilter-next tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/6ak9qiB1pzNzTN7Qt/ByRlc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8ST/wACgkQAVBC80lX
0GwhJAf/WDhQQAL1Uga5wpadcYayjYDyaTpTRnOgRLnpg48OnZPko+sV0eWpp0IB
mqaR3TDlbrHjUet2nRQM31RYJ233lU1qd7aIUGqM5w0bQz1pkKlusyjXj+Hv2+HT
XHbG6JSr7bqjGPVQYGAaopAT66JMBkpR7esgV6XsRN5HtaIeHilMC5YJxwTuROrO
33rn4uwH0yQ1biSFtsdhvZ9ZKs760KdZz5i1a2lqimdU/3nbGAduwIWsaFnHlckP
MxYLfVff2IQPwr7hmMSMs3qUmc0Kx4vbY1YqU0gG6LeZAtQX6qEEnMG+/PymZp5C
7WZCeYid/h3KZNZWWo4ohCAwycwDkw==
=YDgM
-----END PGP SIGNATURE-----

--Sig_/6ak9qiB1pzNzTN7Qt/ByRlc--
