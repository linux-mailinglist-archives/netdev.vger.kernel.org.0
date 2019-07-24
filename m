Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1157273417
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfGXQjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:39:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:28345 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfGXQjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 12:39:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 09:39:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="asc'?scan'208";a="160622639"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 24 Jul 2019 09:39:34 -0700
Message-ID: <4b5abf35a7b78ceae788ad7c2609d84dd33e5e9e.camel@intel.com>
Subject: Re: [PATCH -next v2] net/ixgbevf: fix a compilation error of
 skb_frag_t
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 24 Jul 2019 09:39:26 -0700
In-Reply-To: <1563985079-12888-1-git-send-email-cai@lca.pw>
References: <1563985079-12888-1-git-send-email-cai@lca.pw>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-F6fZM87JRmivafPk4uC1"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-F6fZM87JRmivafPk4uC1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-07-24 at 12:17 -0400, Qian Cai wrote:
> The linux-next commit "net: Rename skb_frag_t size to bv_len" [1]
> introduced a compilation error on powerpc as it forgot to deal with
> the
> renaming from "size" to "bv_len" for ixgbevf.
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
> ---
>=20
> v2: Use the fine accessor per Matthew.
>=20
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Dave I will pick this up and add it to my queue.

--=-F6fZM87JRmivafPk4uC1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl04ib4ACgkQ5W/vlVpL
7c4wqQ//d5wSgI19pzFA1TS42JBY9kbi3DqHUyu1zqzekCNGU8RHpfOcKtie35Y/
ZSpYAcCY1M0QiUzJfYzp9RU8rslF5+1lcLe0TPuwkohIS2qPG+nfBy8hWk9iNcCj
xvbGqikLhFPENbtjvI6td7XgXCBOJ0sFwnRZw4nrloLDQjiLZCvC1YjcgpDMml9b
rA+qo2YililXXDW5C58F8yd8DgjvWCbWgCxo81pSP6OW8PylcOcgQAgyFhq+P+ap
yKolY090gtUYgTcnLwZOrH2bWgJ+9mdPxc19qs5KofEMFmNTrqeed2PF50IO4Qoa
u3JxbrGedZHFGY56GpjUgS0BMvgou4o51yBmfCRkQpJ/jG1GQ2ZwL0d3ZtQzZAQ4
IYKUUJhxvayILfqenCRhlyYAadxt+TvpGSqUM92NmchNb4/1+MdZk8hzg2N58zf7
eU4W46tIbmEIK0vCZ7kCrV8oX9HsYmiN41b2VY8bUzenOF7E3p/MBdE9cN274JD2
mLi/s/m5ze5mPc9HaTST3ugJAgkDk/qhF+69v8rTXEEKptJ9MvgwnCyLJtYgDj4t
0o78vkW0buBu0/Rm76uZx1jxXwwk9S3nI03UcuVe5nriWqojKyDJH4jfa5wxkN8Q
dNbXK8LySVrtgFXMgG6FIVs90TIndVIxOFHH82dx87iwyiLOtyk=
=9hqy
-----END PGP SIGNATURE-----

--=-F6fZM87JRmivafPk4uC1--

