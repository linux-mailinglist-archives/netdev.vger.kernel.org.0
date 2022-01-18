Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571384930A2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349910AbiARWXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349906AbiARWXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:23:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67D3C061574;
        Tue, 18 Jan 2022 14:23:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F89AB816E1;
        Tue, 18 Jan 2022 22:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8A6C340E0;
        Tue, 18 Jan 2022 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642544596;
        bh=hL8i0Ck3qNpQ9NParDC1L9x1Piqn3M/3xN4hX6O4sl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ta6xL4auhxFYxMoJmZoFy8k1dIgQFTnGlAorNpg31r3G0QVycV+deRkEJfKOUZtad
         GF/iuCKCUfMPW3iCHzpXi0/Z0Pk5ohlM1ArwCeiisWU3ObKjcZS547kxjwHwy9gsg5
         6KggqAwUePnEumkQD+jo7wFi36QsvfbHd1xNFOmBimiFdgA9HV51JSqxzoC1re9ZLH
         gfQgvqBbuAC7ndCUHFBMO0gS0ezpDEWZfnjLzuWp9/7OE20Eh6k4bYB5Mleir+sXkU
         fKgFYo10iSB/qtVofpYZDPDLIa6I/1qXJGBYqX37kc0BtwhSxjQdwtIq2p/8pX3V2K
         5TyZ5ct5Ve4tw==
Date:   Tue, 18 Jan 2022 23:23:12 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 17/23] bpf: selftests: update
 xdp_adjust_tail selftest to include multi-frags
Message-ID: <Yec90EIkR931IGwA@lore-desk>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <f7d7d5ba9c132be0dbbebe3a2e4c2377ffa05834.1642439548.git.lorenzo@kernel.org>
 <20220118201647.lwnexycnk2dq25z3@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PL2zuOkGpTAB21Jd"
Content-Disposition: inline
In-Reply-To: <20220118201647.lwnexycnk2dq25z3@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PL2zuOkGpTAB21Jd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jan 17, 2022 at 06:28:29PM +0100, Lorenzo Bianconi wrote:
> > +
> > +	CHECK(err || retval !=3D XDP_TX || size !=3D exp_size,
> > +	      "9k-10b", "err %d errno %d retval %d[%d] size %d[%u]\n",
> > +	      err, errno, retval, XDP_TX, size, exp_size);
> ...
> > +	CHECK(err || retval !=3D XDP_TX || size !=3D exp_size,
> > +	      "9k-1p", "err %d errno %d retval %d[%d] size %d[%u]\n",
> > +	      err, errno, retval, XDP_TX, size, exp_size);
> ...
> > +	CHECK(err || retval !=3D XDP_TX || size !=3D exp_size,
> > +	      "9k-2p", "err %d errno %d retval %d[%d] size %d[%u]\n",
> > +	      err, errno, retval, XDP_TX, size, exp_size);
>=20
> CHECK is deprecated.
> That nit was mentioned many times. Please address it in all patches.

I kept the CHECK macro because there were other CHECK occurrences in
xdp_adjust_tail.c (e.g. in test_xdp_adjust_tail_grow()).
I guess we can add a preliminary patch to convert the other CHECK
occurrences used in xdp_adjust_tail.c (the same for xdp_bpf2bpf.c).
What do you think?

Regards,
Lorenzo

--PL2zuOkGpTAB21Jd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYec9zwAKCRA6cBh0uS2t
rAcUAQCQyoYWrvAKkaVk+r0RpPtEDvl01+qSh1csVjO3eOLjuQEAipD9Zy9t/Jvs
OhIYylbYHemO1X8mVeIjTy5PGRzPDwU=
=C3MK
-----END PGP SIGNATURE-----

--PL2zuOkGpTAB21Jd--
