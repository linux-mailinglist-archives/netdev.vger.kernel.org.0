Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF0C48E153
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 00:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbiAMX6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 18:58:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54946 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiAMX6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 18:58:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C18F7CE216E;
        Thu, 13 Jan 2022 23:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819F8C36AEA;
        Thu, 13 Jan 2022 23:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642118325;
        bh=EVg3Hrvzx6GYLATr0TyYWQDZofLGcg+Ix9ZtVWkVQAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gTKsiYTFhJgSt+ecVm+dxiGao711y7GTcNfO5DC7CtR+Le0PvkZZFzPdnrR9KdHHp
         8IdQu3s7P0IzIghAupvbajuvhmMJBHT/8hCw0KnXkI1/lLFdV0VRAQcx9T4bXcPMYq
         DV0QOlTDBtotFwvOYKUHGgqK9joMOL21TYXbVcG1ZkKN7kekx+0Xky5yLjBo0BnDM0
         ClVN72cRqp16NQ4Nr3AZMKO89eKvNqffMq1eDReB3m4LWN9w0UgTJiY/0PE4Ck519C
         wn2wYhmBtErWyVnW/W2IbFeD+YtdQ0rgs/zbWFXYr3hyKVy+bHKGzqciKTWUuBIUsK
         1dsXEWvOT3urQ==
Date:   Fri, 14 Jan 2022 00:58:40 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Message-ID: <YeC8sOAeZjpc4j8+@lore-desk>
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk>
 <8735lshapk.fsf@toke.dk>
 <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk>
 <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nZm/TQme1PjwK7dz"
Content-Disposition: inline
In-Reply-To: <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nZm/TQme1PjwK7dz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Jan 13, 2022 at 2:22 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> > > > >
> > > > > I would prefer to keep the "_mb" postfix, but naming is hard and =
I am
> > > > > polarized :)
> > > >
> > > > I would lean towards keeping _mb as well, but if it does have to be
> > > > changed why not _mbuf? At least that's not quite as verbose :)
> > >
> > > I dislike the "mb" abbreviation as I forget it stands for multi-buffe=
r.
> > > I like the "mbuf" suggestion, even-though it conflicts with (Free)BSD=
 mbufs
> > > (which is their SKB).
> >
> > If we all agree, I can go over the series and substitute mb postfix wit=
h mbuf.
> > Any objections?
>=20
> mbuf has too much bsd taste.
>=20
> How about ".frags" instead?

I am fine with this (for me it is better than mb or mbuf).
Do we all agree or do we prefer the "mb" suffix?

> Then xdp_buff_is_mb() will be xdp_buff_has_frags().
>=20
> I agree that it's not obvious what "mb" suffix stands for,
> but I don't buy at all that it can be confused with "megabyte".
> It's the context that matters.
> In "100mb" it's obvious that "mb" is likely "megabyte",
> but in "xdp.mb" it's certainly not "xdp megabyte".
> Such a sentence has no meaning.
> Imagine we used that suffix for "tc"...
> it would be "tc.mb"... "Traffic Control Megabyte" ??
>=20
> Anyway "xdp.frags" ?

agree

>=20
> Btw "xdp_cpumap" should be cleaned up.
> xdp_cpumap is an attach type. It's not prog type.
> Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?

so for xdp "mb" or xdp "frags" it will be xdp/cpumap.mb (xdp/devmap.mb) or
xdp/cpumap.frags (xdp/devmap.frags), right?

>=20
> In patch 22 there is a comment:
> /* try to attach BPF_XDP_DEVMAP multi-buff program"
>=20
> It creates further confusion. There is no XDP_DEVMAP program type.
> It should probably read
> "Attach BPF_XDP program with frags to devmap"

ack, I will fix it.

>=20
> Patch 21 still has "CHECK". Pls replace it with ASSERT.

ack, I will fix it.

Regards,
Lorenzo

--nZm/TQme1PjwK7dz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYeC8sAAKCRA6cBh0uS2t
rOf4AQCaGzSEnw1hXKEWatDwR6JQ1FvtR+J0EzPZ+3qZ6vVIdgEA6pCHTZoY9aPr
mSjJ5Pms7CXEJt7PVDR2CJujxM5XfQ8=
=UXis
-----END PGP SIGNATURE-----

--nZm/TQme1PjwK7dz--
