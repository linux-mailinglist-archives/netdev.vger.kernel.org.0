Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB1038BA50
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhETXNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhETXNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 19:13:50 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185E0C061574;
        Thu, 20 May 2021 16:12:28 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FmQVv4XMdz9s1l;
        Fri, 21 May 2021 09:12:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621552345;
        bh=WcMkrUu3k+ohRQ/4F/39KI6wf45Q7hCA8Iv/s7Ip8IE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ouB4UH1wQmBuGDKb54Qq4/V6+AKKYYKXy4xO2z9U8A3BXA3SD/fufSkM0nlk190Qy
         RU415nAlE7b27UXjlh/Hq3YDxBqPZOcyA3/UyXqk9y2HEqHwqfteGSL+RdfnwwKbGo
         5oSzkYegEPDTfYEPbM8zSpGUqO6+VggXyPT17DXAlwjJez04n1uawRrRW5YOB7T2zz
         8XKgjEc/vIhjWJgGNXJ0OJsxKH5MhMTyXQPwpKy4EcVcdQUt+sygIw9m5suRYr2bv2
         nmhgleXgSH3Q6guC+G7Grts+As30QAMkceZ3kg8nqMFR8mAeFjBYZYnYSfR64ziC2J
         7fH4CQ7gsMBqA==
Date:   Fri, 21 May 2021 09:12:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: linux-next: manual merge of the netfilter-next tree with the
 net tree
Message-ID: <20210521091222.3112f371@canb.auug.org.au>
In-Reply-To: <20210519140532.677d1bb6@canb.auug.org.au>
References: <20210519095627.7697ff12@canb.auug.org.au>
        <20210519140532.677d1bb6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0vSKJnr.sGtnbDQ_z8cdll/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/0vSKJnr.sGtnbDQ_z8cdll/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 19 May 2021 14:05:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 19 May 2021 09:56:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Today's linux-next merge of the netfilter-next tree got a conflict in:
> >=20
> >   net/netfilter/nft_set_pipapo.c
> >=20
> > between commit:
> >=20
> >   f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() c=
heck, fallback to non-AVX2 version")
> >=20
> > from the net tree and commit:
> >=20
> >   b1bc08f6474f ("netfilter: nf_tables: prefer direct calls for set look=
ups")
> >=20
> > from the netfilter-next tree.
> >=20
> > I fixed it up (I just used the latter) and can carry the fix as necessa=
ry. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts. =20
>=20
> This merge also needs the following merge resolution patch:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 19 May 2021 13:48:22 +1000
> Subject: [PATCH] fix up for merge involving nft_pipapo_lookup()
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/netfilter/nft_set_pipapo.h | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipap=
o.h
> index d84afb8fa79a..25a75591583e 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -178,8 +178,6 @@ struct nft_pipapo_elem {
> =20
>  int pipapo_refill(unsigned long *map, int len, int rules, unsigned long =
*dst,
>  		  union nft_pipapo_map_bucket *mt, bool match_only);
> -bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> -		       const u32 *key, const struct nft_set_ext **ext);
> =20
>  /**
>   * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
> --=20
> 2.30.2

Actually it appears to also need this:

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter=
/nf_tables_core.h
index 789e9eadd76d..8652b2514e57 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -89,6 +89,8 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
=20
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+			    const u32 *key, const struct nft_set_ext **ext);
 #ifdef CONFIG_RETPOLINE
 bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 		      const u32 *key, const struct nft_set_ext **ext);
@@ -101,8 +103,6 @@ bool nft_hash_lookup_fast(const struct net *net,
 			  const u32 *key, const struct nft_set_ext **ext);
 bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
 		     const u32 *key, const struct nft_set_ext **ext);
-bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-			    const u32 *key, const struct nft_set_ext **ext);
 bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext);
 #else
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9addc0b447f7..dce866d93fee 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -408,7 +408,6 @@ int pipapo_refill(unsigned long *map, int len, int rule=
s, unsigned long *dst,
  *
  * Return: true on match, false otherwise.
  */
-INDIRECT_CALLABLE_SCOPE
 bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext)
 {


--=20
Cheers,
Stephen Rothwell

--Sig_/0vSKJnr.sGtnbDQ_z8cdll/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCm7NYACgkQAVBC80lX
0GyxDAf/Vz6NNCLaAf5gi7TM4rpMIQd8jzf1uEvnYKZhALVYzZiL7RxAhBh+E8Lz
QCJlZA6SCuOXiK/BTDphPhrP9UqCjTq9WDLAosiJLStN4LsKBuOLDVL7ae8mZGi7
VbGwO72SK5gmlbOJGQ7yp5lMqj1POaFOr7gT8D2FVC/jXA28Ky9/eoTdQlY7xett
AYLaiHSO8AhtZWs725TTONgNZMuxZxhQODrghbST50IsXW1tbFaBb0Ixu2lvF8dZ
ZIRnBTxRfeUm7SE+oTLXdV7ZSsSVhHMcgz0kS6sc2iTeJj5aOTRn1/Ti2gQo6iPb
3jmw/8jp6rNFcBKP+1UZ5HmJsZpUAg==
=73UX
-----END PGP SIGNATURE-----

--Sig_/0vSKJnr.sGtnbDQ_z8cdll/--
