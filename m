Return-Path: <netdev+bounces-11778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 179787346C0
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABBA72810B3
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69965210F;
	Sun, 18 Jun 2023 15:05:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D505E1386;
	Sun, 18 Jun 2023 15:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63C9C433C0;
	Sun, 18 Jun 2023 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687100739;
	bh=W3TuHkD0XoGM6WZnbov0mmXZtSsTLvn/2dJTUP01g8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aM2StNDqUpzbOjEV5niNht7TTtAlZezuuXp9VYVI9j+1eB/WVgZMsEVZEuiC8Ggb6
	 I7VXkXJVC16oxowwMZJjjjYfzXj10sLYPwYuIy3wJQJovIu9mO7rqjLCaCnaildUoK
	 9wxImsjxTIxcnjKAWxVL823FgnSiilZhrxuLTW+3HSKAOsARRJ+DSH0vwpZ3PV1+Wv
	 TUJ61U+UQkaGXxQ4U3hi0ILGsLpVOmKCpSXPXmuHd8n0OWF71GgsLKniT91Izp9Xcq
	 KV3xfsTbvARav29T478YD5pOYmbAL7pQv7x6l+/eV098au2AUoEWGV2lHxW/gwPUrK
	 WTw7stC6t63lQ==
Date: Sun, 18 Jun 2023 17:05:35 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Jesper Dangaard Brouer <jbrouer@redhat.com>, brouer@redhat.com,
	Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Maryam Tahhan <mtahhan@redhat.com>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
Message-ID: <ZI8dP5+guKdR7IFE@lore-desk>
References: <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
 <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com>
 <dcc9db4c-207b-e118-3d84-641677cd3d80@huawei.com>
 <f8ce176f-f975-af11-641c-b56c53a8066a@redhat.com>
 <CAKgT0UfzP30OiBQu+YKefLD+=32t+oA6KGzkvsW6k7CMTXU8KA@mail.gmail.com>
 <699563f5-c4fa-0246-5e79-61a29e1a8db3@redhat.com>
 <CAKgT0UcNOYwxRP_zkaBaZh-VBL-CriL8dFG-VY7-FUyzxfHDWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KbyKaA638ZtQOEdn"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcNOYwxRP_zkaBaZh-VBL-CriL8dFG-VY7-FUyzxfHDWw@mail.gmail.com>


--KbyKaA638ZtQOEdn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> >
> > Yes, precisely.
> > I distinctly remember what I tried to poke you and Eric on this approach
> > earlier, but I cannot find a link to that email.
> >
> > I would really appreciate, if you Alex, could give the approach in
> > veth_convert_skb_to_xdp_buff() some review, as I believe that is a huge
> > potential for improvements that will lead to large performance
> > improvements. (I'm sure Maryam will be eager to help re-test performance
> > for her use-cases).
>=20
> Well just looking at it the quick and dirty answer would be to look at
> making use of something like page_frag_cache. I won't go into details
> since it isn't too different from the frag allocator, but it is much
> simpler since it is just doing reference count hacks instead of having
> to do the extra overhead to keep the DMA mapping in place. The veth
> would then just be sitting on at most an order 3 page while it is
> waiting to fully consume it rather than waiting on a full pool of
> pages.

Hi,

I did some experiments using page_frag_cache/page_frag_alloc() instead of
page_pools in a simple environment I used to test XDP for veth driver.
In particular, I allocate a new buffer in veth_convert_skb_to_xdp_buff() fr=
om
the page_frag_cache in order to copy the full skb in the new one, actually
"linearizing" the packet (since we know the original skb length).
I run an iperf TCP connection over a veth pair where the
remote device runs the xdp_rxq_info sample (available in the kernel source
tree, with action XDP_PASS):

TCP clietn -- v0 =3D=3D=3D v1 (xdp_rxq_info) -- TCP server

net-next (page_pool):
- MTU 1500B: ~  7.5 Gbps
- MTU 8000B: ~ 15.3 Gbps

net-next + page_frag_alloc:
- MTU 1500B: ~  8.4 Gbps
- MTU 8000B: ~ 14.7 Gbps

It seems there is no a clear "win" situation here (at least in this environ=
ment
and we this simple approach). Moreover:
- can the linearization introduce any issue whenever we perform XDP_REDIRECT
  into a destination device?
- can the page_frag_cache introduce more memory fragmentation (IIRC we were
  experiencing this issue in mt76 before switching to page_pools).

What do you think?

Regards,
Lorenzo

>=20
> Alternatively it could do something similar to page_frag_alloc_align
> itself and just bypass doing a custom allocator. If it went that route
> it could do something almost like a ring buffer and greatly improve
> the throughput since it would be able to allocate a higher order page
> and just copy the entire skb in so the entire thing would be linear
> rather than having to allocate a bunch of single pages.

--KbyKaA638ZtQOEdn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZI8dPwAKCRA6cBh0uS2t
rEdfAP9+NbpPdH6eOTBT4FRjZ3on1c7BcweNquvtJmBV5sasawD/ZqLC5dg4llbj
GNHcTygUY3/ity5LCv42OtfiEvz4qgo=
=rjhq
-----END PGP SIGNATURE-----

--KbyKaA638ZtQOEdn--

