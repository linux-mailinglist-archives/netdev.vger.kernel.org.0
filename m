Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D82B3AFC
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfIPNIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:08:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45310 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfIPNIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k+3BYnF4kFHi6zZm7HZmWrnbCqUoVkQzERbtDvovQeI=; b=SkSXT4oAi7khmRjUoB0Dl4Y8Jx
        gkhN1qprinpi7bQUwekjbGizfAyI9oKj0qP+nJkdkvzuSJVnWXFxtIUMTfotjdQ/e2AMiM1bK3/7J
        2o9+twiZYdzhz40bQrZzQS2C44RzwDp3OoSnBlejEsT6BGX4k4wGLUIrc9UOwXXbNqLj4FfpO6qnl
        OSTAusonyp7fUIcM19/le2rdeTNz6vIeW1OrYM0fH1Ju8MQn7+j4C6h54E0XiYGk3qcRDEvQ8YfEZ
        SjOBn9D4BfdcQctfdsde4gMk/KfSZGEFROA3L3U1DGareaYRrF2yQzVbE+LuOHj3VXx1Ll2Oj84Fq
        uWTEcdTQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i9qjl-0006A8-Gw; Mon, 16 Sep 2019 14:08:13 +0100
Date:   Mon, 16 Sep 2019 14:08:12 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: bridge: drop a broken include
Message-ID: <20190916130811.GA29776@azazel.net>
References: <20190916000517.45028-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20190916000517.45028-1-kilobyte@angband.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-16, at 02:05:16 +0200, Adam Borowski wrote:
> This caused a build failure if CONFIG_NF_CONNTRACK_BRIDGE is set but
> CONFIG_NF_TABLES=3Dn -- and appears to be unused anyway.
>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c
> b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 4f5444d2a526..844ef5a53f87 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -18,7 +18,6 @@
>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
> -#include <net/netfilter/nf_tables.h>
>
>  #include "../br_private.h"
>
> --
> 2.23.0

This is the build-failure (reproduced with v5.3):

  In file included from net/bridge/netfilter/nf_conntrack_bridge.c:21:
  ./include/net/netfilter/nf_tables.h: In function =E2=80=98nft_gencursor_n=
ext=E2=80=99:
  ./include/net/netfilter/nf_tables.h:1223:14: error: =E2=80=98const struct=
 net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
   1223 |  return net->nft.gencursor + 1 =3D=3D 1 ? 1 : 0;
        |              ^~~
        |              nf
  In file included from ./include/linux/export.h:45,
                   from ./include/linux/linkage.h:7,
                   from ./include/linux/kernel.h:8,
                   from ./include/linux/skbuff.h:13,
                   from ./include/linux/ip.h:16,
                   from net/bridge/netfilter/nf_conntrack_bridge.c:3:
  ./include/net/netfilter/nf_tables.h: In function =E2=80=98nft_genmask_cur=
=E2=80=99:
  ./include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struct=
 net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |                             ^~~
  ./include/linux/compiler.h:261:17: note: in definition of macro =E2=80=98=
__READ_ONCE=E2=80=99
    261 |  union { typeof(x) __val; char __c[1]; } __u;   \
        |                 ^
  ./include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro =
=E2=80=98READ_ONCE=E2=80=99
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |              ^~~~~~~~~
  ./include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struct=
 net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |                             ^~~
  ./include/linux/compiler.h:263:22: note: in definition of macro =E2=80=98=
__READ_ONCE=E2=80=99
    263 |   __read_once_size(&(x), __u.__c, sizeof(x));  \
        |                      ^
  ./include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro =
=E2=80=98READ_ONCE=E2=80=99
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |              ^~~~~~~~~
  ./include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struct=
 net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |                             ^~~
  ./include/linux/compiler.h:263:42: note: in definition of macro =E2=80=98=
__READ_ONCE=E2=80=99
    263 |   __read_once_size(&(x), __u.__c, sizeof(x));  \
        |                                          ^
  ./include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro =
=E2=80=98READ_ONCE=E2=80=99
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |              ^~~~~~~~~
  ./include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struct=
 net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |                             ^~~
  ./include/linux/compiler.h:265:30: note: in definition of macro =E2=80=98=
__READ_ONCE=E2=80=99
    265 |   __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
        |                              ^
  ./include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro =
=E2=80=98READ_ONCE=E2=80=99
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |              ^~~~~~~~~
  ./include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struct=
 net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |                             ^~~
  ./include/linux/compiler.h:265:50: note: in definition of macro =E2=80=98=
__READ_ONCE=E2=80=99
    265 |   __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
        |                                                  ^
  ./include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro =
=E2=80=98READ_ONCE=E2=80=99
   1234 |  return 1 << READ_ONCE(net->nft.gencursor);
        |              ^~~~~~~~~

There are already changes in the net-next tree that will fix it.

J.

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1/iTIACgkQ0Z7UzfnX
9sOK8xAAvY5f+1bR87Qur/38s63jdaafLhaFsehamTw5p8IYoSs7aiVwNHNaXw3x
fb2Igqje5jmyETPmR+GlgJCrAJN9jZqPrUSohhhYZeCTf5Kdz7ZPu9N8I2eNVYwM
99R/YChxiinoLI6hvSd7Mmc6PammrPIU1U6gg7rd7sXcKKOY8ZhMKO6sRsvdG5cU
qmRzEtIw4WhGeVK6v0x3UpCd69Gu/i8TC1IvIoL9d+9vFRkATIQ3HAPTvYmWe1CN
UXjtRlrVElptOfV4MMiaxKxavshrJHy07QBhuNZoR8JvCH8dKw/IycvtcRQyScm9
rl9zHfr98piRnCSriMisx+TFjbUfAnjScAgMnOMKe1BQeSsl7L0xJ9YniFZUdA4V
/HOIhex1cAj/PfZuMmvQffPyVYn40qIxM6eCjGfnkZGDkquJE2IAQP5s1rVb1mBq
6xECwauuOdw9AneSiWBdh5f6m1UPPTyc7K2EmjEq9Ywy9RaGwwAzR1F+IpjNVG8a
dXB9a7+L8HW63zDbV7rQEv5mffXNMfiqcV0f61zM0AxEPAOW79dBk+a8veZcUtS9
/nyk6rehZ/YQiQVCjxTUzpcRj7cXaHWjo5rr6VtLQyj6S6mQ7JlSAOoNN3DlWAi9
bhmL1vdalD0/sujF4VXv7+oqE9l7UqYP6oQSGzTeufSoegOuQls=
=jHqt
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
