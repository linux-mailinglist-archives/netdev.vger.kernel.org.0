Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4E92DA170
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503211AbgLNUXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:23:03 -0500
Received: from ozlabs.org ([203.11.71.1]:55687 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503125AbgLNUWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:22:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cvt8j6SJ2z9sTL;
        Tue, 15 Dec 2020 07:21:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607977320;
        bh=B3wuRWTcLJoeWP3BtRp0iftn36UsXN/g07DQz0v7oqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rh/abQmriFXZR/ZDdJVrQ4W8qHsKY7MYlbzOkR2Boe6bKW73yXpnQqmIn4hxI4MSL
         Y9AtYb+BQ0BI30nPZ5vrirUkxQhZr1d79JYoqj/UiPrL5ubNFKkB11Msl+GZ66C9iB
         hY0JYEpDt7A3lv8jXuuZNsRklBcteEfBp8RfDvHoaNfWr9aAvIst9GFBojdAislOSI
         4oIY3EnIf+D1q1N66MUtZMcvc2WVUcyxp3jhk/ujJfEQ/KqFK/eM6ARRMLknuN5fAL
         waMuFJljVjMzWupLCfBFN3tzuk1GYPeoQ/U3DPzalJUf9iPvjTBcWgDAWo2pi5rJf2
         qMLSqjKFijqUQ==
Date:   Tue, 15 Dec 2020 07:21:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20201215072156.1988fabe@canb.auug.org.au>
In-Reply-To: <20201204202005.3fb1304f@canb.auug.org.au>
References: <20201204202005.3fb1304f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IG37xDU4Ku3Zo8Iw2=8I4Ig";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IG37xDU4Ku3Zo8Iw2=8I4Ig
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 4 Dec 2020 20:20:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the akpm-current tree got conflicts in:
>=20
>   include/linux/memcontrol.h
>   mm/memcontrol.c
>=20
> between commit:
>=20
>   bcfe06bf2622 ("mm: memcontrol: Use helpers to read page's memcg data")
>=20
> from the bpf-next tree and commits:
>=20
>   6771a349b8c3 ("mm/memcg: remove incorrect comment")
>   c3970fcb1f21 ("mm: move lruvec stats update functions to vmstat.h")
>=20
> from the akpm-current tree.
>=20
> I fixed it up (see below - I used the latter version of memcontrol.h)
> and can carry the fix as necessary. This is now fixed as far as
> linux-next is concerned, but any non trivial conflicts should be
> mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer
> of the conflicting tree to minimise any particularly complex conflicts.
>=20
> I also added this merge fix patch:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 4 Dec 2020 19:53:40 +1100
> Subject: [PATCH] fixup for "mm: move lruvec stats update functions to vms=
tat.h"
>=20
> conflict against "mm: memcontrol: Use helpers to read page's memcg data"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/memcontrol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6f5733779927..3b6db4e906b5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -851,16 +851,17 @@ void __mod_lruvec_page_state(struct page *page, enu=
m node_stat_item idx,
>  			     int val)
>  {
>  	struct page *head =3D compound_head(page); /* rmap on tail pages */
> +	struct mem_cgroup *memcg =3D page_memcg(head);
>  	pg_data_t *pgdat =3D page_pgdat(page);
>  	struct lruvec *lruvec;
> =20
>  	/* Untracked pages have no memcg, no lruvec. Update only the node */
> -	if (!head->mem_cgroup) {
> +	if (!memcg) {
>  		__mod_node_page_state(pgdat, idx, val);
>  		return;
>  	}
> =20
> -	lruvec =3D mem_cgroup_lruvec(head->mem_cgroup, pgdat);
> +	lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>  	__mod_lruvec_state(lruvec, idx, val);
>  }
> =20
> --=20
> 2.29.2
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc include/linux/memcontrol.h
> index 320369c841f5,ff02f831e7e1..000000000000
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> diff --cc mm/memcontrol.c
> index 7535042ac1ec,c9a5dce4343d..000000000000
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@@ -2880,9 -2984,9 +2975,9 @@@ static void cancel_charge(struct mem_cg
>  =20
>   static void commit_charge(struct page *page, struct mem_cgroup *memcg)
>   {
>  -	VM_BUG_ON_PAGE(page->mem_cgroup, page);
>  +	VM_BUG_ON_PAGE(page_memcg(page), page);
>   	/*
> - 	 * Any of the following ensures page->mem_cgroup stability:
> + 	 * Any of the following ensures page's memcg stability:
>   	 *
>   	 * - the page lock
>   	 * - LRU isolation
> @@@ -6977,11 -7012,10 +6997,10 @@@ void mem_cgroup_migrate(struct page *ol
>   		return;
>  =20
>   	/* Page cache replacement: new page already charged? */
>  -	if (newpage->mem_cgroup)
>  +	if (page_memcg(newpage))
>   		return;
>  =20
> - 	/* Swapcache readahead pages can get replaced before being charged */
>  -	memcg =3D oldpage->mem_cgroup;
>  +	memcg =3D page_memcg(oldpage);
>   	if (!memcg)
>   		return;
>  =20

Just a reminder that this conflict still exists.  Commit bcfe06bf2622
is now in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/IG37xDU4Ku3Zo8Iw2=8I4Ig
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/XyWQACgkQAVBC80lX
0GwynQgAlfCe0thKDt294OVZOl+2aA785d1wRdcPUy+DIReItT2L/MRLre2OW9K0
+BGeGIV5hxuxnpdkC81DOCFIIUbAi+jLWDI69ob1RTRfO5iGIzkz9EhLTrsg/aBv
wI9XomYFLIViQFKo5oPums3GjJ6Fv+cE6HW387DRFtRS5Viw5EpFidw1QrV5hGOv
SzFwKR6f2xUmzbOqZkD9iLfNhEydPdO/+SIvhe9LDWGePdeiE8rhx+mbzp257O/7
RH3XW2h5NVhxb5ofe0TXdZl9JH5TqVgpy47IcB14Tio7vBwn85JbyST1IVUwFYRw
74wnExMTPyxIiGL2a57qQwQiRreE/g==
=K/ll
-----END PGP SIGNATURE-----

--Sig_/IG37xDU4Ku3Zo8Iw2=8I4Ig--
