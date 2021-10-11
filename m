Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3C428A25
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 11:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbhJKJux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 05:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235607AbhJKJuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 05:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E835F60E8B;
        Mon, 11 Oct 2021 09:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633945730;
        bh=PhsR/ZnLmZ4MFPZ1GZtfeun3Q/yhTWkDBOGurKoP+ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pX4ycGtia4q9UNlhO325KnJ+UKoWtcXgnmYiLgA0K3rPh3r81zvjIFPIuqJoIw9YJ
         XckQKpgrmhcpnxEI78HqF5EW1x33mvLEFikbJfNVQ2gzu+2EOCYXwSXtUNsWQ+8o1h
         ML8SP+MFlZK3qaRADCr2rxnIjhOb7+cTuhMbXUwnyaLYjl7uo+9+ditMiWABNIQHaD
         IbwlCIm9yOXuhI6B/P/nggTerNiUgJaChYQVTZWIObiEtL2VlnhZ96ShNaG1GavcOu
         4nH+DnwuhSizzW3EK0q6JOuB+os8Vn7QAI+oz50zM+0tK9QbHeliPIpeSb+mrZyuz4
         HKEw1FY3Vjdtw==
Date:   Mon, 11 Oct 2021 11:48:44 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v15 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YWQIfIjqdm1fzZwu@lore-desk>
References: <cover.1633697183.git.lorenzo@kernel.org>
 <20211008181435.742e1e44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87fstajqt8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4Y8Wu7HEDp7r9l2D"
Content-Disposition: inline
In-Reply-To: <87fstajqt8.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4Y8Wu7HEDp7r9l2D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > On Fri,  8 Oct 2021 14:49:38 +0200 Lorenzo Bianconi wrote:
> >> Changes since v14:
> >> - intrudce bpf_xdp_pointer utility routine and
> >>   bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
> >> - drop bpf_xdp_adjust_data helper
> >> - drop xdp_frags_truesize in skb_shared_info
> >> - explode bpf_xdp_mb_adjust_tail in bpf_xdp_mb_increase_tail and
> >>   bpf_xdp_mb_shrink_tail
> >
> > I thought the conclusion of the discussion regarding backward
> > compatibility was that we should require different program type
> > or other explicit opt in. Did I misinterpret?
>=20
> No, you're right. I think we settled on using the 'flags' field instead
> of program type, but either way this should be part of the initial patch
> set.

ops, right. I will add it in the v16. Sorry for the noise.

Are you fine with bpf_xdp_load_bytes/bpf_xdp_store_bytes proposed solution?

Regards,
Lorenzo

>=20
> -Toke
>=20

--4Y8Wu7HEDp7r9l2D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYWQIfAAKCRA6cBh0uS2t
rAbpAP41WVwfcNEE2EuwQtfXwL70lV4ElMVyPuBUznC5hhGXhwD+MwYDdxzhmAvc
a3yzsGKVyXgVFVHXnQTMkQHITkXYNwQ=
=QoZ0
-----END PGP SIGNATURE-----

--4Y8Wu7HEDp7r9l2D--
