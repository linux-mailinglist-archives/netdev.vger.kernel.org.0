Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD4374134
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfGXWC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:02:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:45850 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbfGXWC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 18:02:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 15:02:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="asc'?scan'208";a="181258921"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 24 Jul 2019 15:02:56 -0700
Message-ID: <fabcf55573fc09b49eacdb7cb625863df3596b06.camel@intel.com>
Subject: Re: [PATCH -next] net/ixgbevf: fix a compilation error of skb_frag_t
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Qian Cai <cai@lca.pw>, willy@infradead.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Jul 2019 15:02:48 -0700
In-Reply-To: <1563975157-30691-1-git-send-email-cai@lca.pw>
References: <1563975157-30691-1-git-send-email-cai@lca.pw>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pbYDAA7WOEFmJEH4Imqn"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-pbYDAA7WOEFmJEH4Imqn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-07-24 at 09:32 -0400, Qian Cai wrote:
> The linux-next commit "net: Rename skb_frag_t size to bv_len" [1]
> introduced a compilation error on powerpc as it forgot to rename
> "size"
> to "bv_len" for ixgbevf.
>=20
> [1]=20
> https://lore.kernel.org/netdev/20190723030831.11879-1-willy@infradead.org=
/T/#md052f1c7de965ccd1bdcb6f92e1990a52298eac5
>=20
> In file included from ./include/linux/cache.h:5,
>                  from ./include/linux/printk.h:9,
>                  from ./include/linux/kernel.h:15,
>                  from ./include/linux/list.h:9,
>                  from ./include/linux/module.h:9,
>                  from
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:12:
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function
> 'ixgbevf_xmit_frame_ring':
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:4138:51: error:
> 'skb_frag_t' {aka 'struct bio_vec'} has no member named 'size'
>    count +=3D TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
>                                                    ^
> ./include/uapi/linux/kernel.h:13:40: note: in definition of macro
> '__KERNEL_DIV_ROUND_UP'
>  #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
>                                         ^
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:4138:12: note: in
> expansion of macro 'TXD_USE_COUNT'
>    count +=3D TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
>=20
> Signed-off-by: Qian Cai <cai@lca.pw>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-pbYDAA7WOEFmJEH4Imqn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl041YgACgkQ5W/vlVpL
7c6ETw//Z5SxxG4VI74sOLbJK41JH57EfCLR88CEkf1osB53luH8DjIFYMvjWBhI
U96TpuH4/SBhHZvRub/9Qk18ezkumYZ5K8hgmp0Z6uDwimH+QemyyMU2fOunAZJH
NTuZU2vglig0NZR9OTxqs+WC8xkJJQpXPPHqVfYTGcv/VVgvOSDJfqFEgUVF+puh
5il0qCCbgSrPsFtnyu39k2KaS7bihRWNUkW8nZk0YKU4Z7BV/gwX85YwccPbWXGo
HUaSmXzLArC7W03E4XM9GkcRSOM0F8lMJyGdW1bMtvjuZ/YxJwmQ+kaXlaE0yqM9
L4n0XxA9QDz5VsihsQPtLzpMGQWeerRaqSWI7ovn7MMPuHmtCIrXny1BJ+YHr1hm
JA1tYHFTwXKrdHgXPskBvFhNr60MIiOYvq4FHZ/vQpuP+Dt0epBmkqN6dauFGuXb
oEmOjarfnRE8bvp7oUl/aBAPGxVX5luUK5FAhpKXkxuMyXaaVU9McwPH3g1ntoMQ
ynQ8PytGSNTq4vDe1l5gA0SBh0hsL6lrgrUhK4xUbQujFJmOfajiBSqJbdsP9bwb
u8b8BE6GPYFpGHN340f5hVqvPs1pBFUa6C1zglUb+RfJKwpJ+/la2m1oYaUonTO4
eTusZIXpOysi43rm6t5lNkPsvBGv5jRc6+b8qMn7GtpoI+I4Dfo=
=keuC
-----END PGP SIGNATURE-----

--=-pbYDAA7WOEFmJEH4Imqn--

