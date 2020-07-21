Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94522791A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgGUGyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGUGyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 02:54:35 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B27CC061794;
        Mon, 20 Jul 2020 23:54:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9q8K5v03z9sQt;
        Tue, 21 Jul 2020 16:54:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595314472;
        bh=mJsTszFvnCYvpWubjtgvg98U0MICF1p5OyjYGn6wYAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oih2Qp+Nu5cR+e5iFKw29doka1pPdYxf7DOvZzXdqHrkhZyxL5zoZeMWBGkgw5B6Z
         mo+tXGmeXESAzMQIKZ5ZFNWlIOgWsIdY9ybMcnLmepOyyQtBQyOx7WWDffTMVmkWuh
         jxT47UkDugIQBNHJY8FVdsH/TUPqfD5GXQNudcpLXwGlASXEz1qY5VrvhkZqT8lGi7
         jugJZ0b/n3RK3BeQ/0AGyDFkv8r1Zq0TvfmKWsBh2JXIAMrXm4DZIc6BsD5pDaRBhr
         Ct7HhytX1IKiYnx0wBXtOxyG07YvEuhstEK88LD2Y9TigpYgC+C4niV+uVlkhThl3L
         5Z7IG3olGOtOg==
Date:   Tue, 21 Jul 2020 16:54:24 +1000
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
Message-ID: <20200721165424.4aa21b81@canb.auug.org.au>
In-Reply-To: <536c2421-7ae2-5657-ff31-fbd80bd71784@infradead.org>
References: <20200721020722.6C7YAze1t%akpm@linux-foundation.org>
        <536c2421-7ae2-5657-ff31-fbd80bd71784@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9zIg8IHnPNH650=BUHEpwdZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9zIg8IHnPNH650=BUHEpwdZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 20 Jul 2020 23:09:34 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on i386:
>=20
> ld: net/ipv6/ip6_vti.o: in function `vti6_rcv_tunnel':
> ip6_vti.c:(.text+0x2d11): undefined reference to `xfrm6_tunnel_spi_lookup'

Caused by commit

  08622869ed3f ("ip6_vti: support IP6IP6 tunnel processing with .cb_handler=
")

from the linux-next ipsec-next tree.

CONFIG_INET6_XFRM_TUNNEL=3Dm
--=20
Cheers,
Stephen Rothwell

--Sig_/9zIg8IHnPNH650=BUHEpwdZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8WkSAACgkQAVBC80lX
0GypDQf+J1VwO4D8LazPteqDAJk+Cjpltx0+scco6H/nuwwMjcnCP0hGiSdGj3+Q
SQHviHlbpqbO+iSdPq/Zg8ITkqg59NHbDECNq2iHxNV2jXe6OhJwvjko25dTtbKK
n/OQVrMKhpduCWmUx7XJDvPseEzrNtHW5J9R7KvlnD30d6yXCnU35ETgM1mIjdJk
LzQxqZLt0OPIMPYu9mk4kH2PoKvgaSYe1fnPfiIPzlXvwNf7tHUY388ZsU56Og/d
vD/jpWb3QFraRv6do9m/k5+RL3HWdRyBXkfa+VCS8Lb9Ye9UKFRRaOuBZJQD74ml
7HXQiJQmc+m9k2xK7qZpWtp6u31vQQ==
=uNPM
-----END PGP SIGNATURE-----

--Sig_/9zIg8IHnPNH650=BUHEpwdZ--
