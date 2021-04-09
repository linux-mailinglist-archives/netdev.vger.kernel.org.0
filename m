Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9666435A56C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhDISNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234306AbhDISNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4FB6100B;
        Fri,  9 Apr 2021 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617992008;
        bh=W/O/4g7oqijqwdJkWpFCz+CVQBTFbgcIGkCZnpObCYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VkkpkRjEA+Wdi1emZ6uqUQD/9ZBmFDH5SIcxSRVbdlK3mNn9+YquCLnp91QCSHPtb
         kWbnIiwncstHfW1Lbltr8rmBIq7qyuMa6nG+KSEr0q5oU5z/Wha/78XGwSP7C7njVO
         QLBbMJlS7GuGgLQfWosfh+belxJ0xNs9NyYMCu1m2PA881yVi7A0Ip0ogQQKmPyvP/
         NNEqtASyf7tjvqo17ILBEPJUSqslbIkJyXafNwm/HCqVhA36ZvSACBTEe6BPPVoINK
         quBIKEc10biqNb/HreSjs8jQnWRMExPHX72iPq4LHqXan6jOsdn7Td70fdnwcgAk8V
         SIytMCxuG3qTQ==
Date:   Fri, 9 Apr 2021 20:13:24 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 08/14] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <YHCZRAFL61LRpA9n@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <427bd05d147a247fc30fd438be94b5d51845b05f.1617885385.git.lorenzo@kernel.org>
 <20210408191547.zlriol6gm2tdhhxi@skbuf>
 <20210408205454.hqh7nawjrtgv4vdi@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Von1s4nGaXXhVCwN"
Content-Disposition: inline
In-Reply-To: <20210408205454.hqh7nawjrtgv4vdi@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Von1s4nGaXXhVCwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 08, 2021 at 10:15:47PM +0300, Vladimir Oltean wrote:
> > > +		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
> > > +				       xdp_sinfo->data_length -
> > > +				       ETH_HLEN)))
> >=20
> > Also: should we have some sort of helper for calculating the total
> > length of an xdp_frame (head + frags)? Maybe it's just me, but I find it
> > slightly confusing that xdp_sinfo->data_length does not account for
> > everything.
>=20
> I see now that xdp_buff :: frame_length is added in patch 10. It is a
> bit strange to not use it wherever you can? Could patch 10 be moved
> before patch 8?

yes, I agree we can change the patch order

Regards,
Lorenzo

--Von1s4nGaXXhVCwN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHCZPwAKCRA6cBh0uS2t
rIwAAPwOt7pXUJRmEWTVKoYXPwwqZin54G79HTOXW/K5K0ctzgEAkSQoxtnKy0AB
Z8YmZa0xWX2dEVdOw6SoNjd/SPoXuAM=
=SGRd
-----END PGP SIGNATURE-----

--Von1s4nGaXXhVCwN--
