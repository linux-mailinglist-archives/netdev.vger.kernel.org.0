Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A722791D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgGUGz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:55:57 -0400
Received: from ozlabs.org ([203.11.71.1]:58821 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgGUGz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:55:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9qB25lVGz9sSJ;
        Tue, 21 Jul 2020 16:55:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595314555;
        bh=Q7OXuH3IujvF32fVyUqHqhi4eviDa7shPE0mEDAD2ZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fqWzcFW4+XcuCOAf46YhWOrzWlu2gVqyBUv/krZuWxTDgJ2iaDueazKri5ocAzx0m
         JBNiWfGczJ0LP4Sem67zSo1mAeK5z9QpIGw+XqH2axGw9C8b2rdxHqnEQuJ3EPZz1U
         TARgd/JcGF94kXfOdhQqnOFipqj/L+4dvWXw7OM5ej6uVi101S99u5qXkrZw91KVWa
         eUbWPnZ2E70kF5VxeZAeWNZfD5SDiljFZn6e1gf7nHTEFgpdlMh1q1Mz7jADF3umVQ
         zf+JTJOq3s7/ZqpAXwLM1ETZX6vpPSl71fdSpVEaSLV/JZswMJmgR6trRT+NCYIB3L
         doizQfpjqaZLw==
Date:   Tue, 21 Jul 2020 16:55:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Miller <davem@davemloft.net>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: mmotm 2020-07-20-19-06 uploaded (net/ipv6/ip6_vti.o)
Message-ID: <20200721165553.713c51b3@canb.auug.org.au>
In-Reply-To: <20200721165424.4aa21b81@canb.auug.org.au>
References: <20200721020722.6C7YAze1t%akpm@linux-foundation.org>
        <536c2421-7ae2-5657-ff31-fbd80bd71784@infradead.org>
        <20200721165424.4aa21b81@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/euP/RBZrNT3uFkFfv5_O0cu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/euP/RBZrNT3uFkFfv5_O0cu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 21 Jul 2020 16:54:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 20 Jul 2020 23:09:34 -0700 Randy Dunlap <rdunlap@infradead.org> w=
rote:
> >
> > on i386:
> >=20
> > ld: net/ipv6/ip6_vti.o: in function `vti6_rcv_tunnel':
> > ip6_vti.c:(.text+0x2d11): undefined reference to `xfrm6_tunnel_spi_look=
up' =20
>=20
> Caused by commit
>=20
>   08622869ed3f ("ip6_vti: support IP6IP6 tunnel processing with .cb_handl=
er")
>=20
> from the linux-next ipsec-next tree.
>=20
> CONFIG_INET6_XFRM_TUNNEL=3Dm

I need to read ahead in my email :-)

--=20
Cheers,
Stephen Rothwell

--Sig_/euP/RBZrNT3uFkFfv5_O0cu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8WkXkACgkQAVBC80lX
0Gy0pwf+OeRTrgcltii+j/ic9m/VaekZvTVtd1SKbimSlVNOEZFPvI4Qm7hhsR9g
2czTCUKJQmJKyvjtgG9hHzMu0ahA7DPfeuBvv1hitKnTwvQexl9BW9Vm6pNtkEN6
gulxuRMM30xucyIoPmggcBNPTXBGSQ+oAZ6UQww75wwaurmcdoENFNgn80nsb59/
wqN7W47bWJ9OZAESIBEq1B75DJ7IZo/6OHrzWV0MJggEY7QTqUKd9M2o8ucGeEBf
vo4o3J+3q+o9dLIXmwG2D1MQwVpwEI7oMiOzgVZvCyjUmPTXwhH7klV3FrReOt99
9q6JBD4ZKGAOhqBEfqGwn1270NsnVg==
=WkFR
-----END PGP SIGNATURE-----

--Sig_/euP/RBZrNT3uFkFfv5_O0cu--
