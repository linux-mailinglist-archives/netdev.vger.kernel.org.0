Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB996446486
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhKEOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232604AbhKEOAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 10:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E0961165;
        Fri,  5 Nov 2021 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636120675;
        bh=hNLT3H0esuANe/K5ztUqHSATo6Yu85tKFtZJ9FhxvnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtZlLPN2dLbw/1IT5cuiGAf4Q3GDmqoYyY8JvBG3kO6jV8CJTotnE/T0H+MGgZxlG
         BnFmIqgWLuz45fReTf0/+vDcg3CIBM1NLMvv/og2mqR1dBxQiUeRK3FQnoRckn0/iq
         toKJ9RJaNiAK8jCB0Wx0YADsJNYQKwi/f/ZbvGYqzCuJtVzZVFfsp2577Pvz9M6yjr
         NIWBjnyIrsNDSLMTGr8L4NQ/0JSt3SD8Af7iruFZ4DjnZryPSET1tuFGICHpEoYSXD
         TKGhrZPN1e3rhCB4J3I+QLJc+i4sQxKx6cKI9ZGEF18zoHrkrFnFUozFyA7dwEC7Tb
         J+jtfiRVcjaHA==
Date:   Fri, 5 Nov 2021 14:57:51 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <YYU4X6cLs1pB6+Ff@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
 <20211104191641.3bc9d873@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l8Y9Ld+yicHGP8LD"
Content-Disposition: inline
In-Reply-To: <20211104191641.3bc9d873@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l8Y9Ld+yicHGP8LD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu,  4 Nov 2021 18:35:32 +0100 Lorenzo Bianconi wrote:
> > +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	int i, n_frags_free =3D 0, len_free =3D 0, tlen_free =3D 0;
>=20
> clang says tlen_free set but not used.

ack, right. It is a leftover of a previous refactor. I will wait for other
feedbacks and then I will repost. Thanks :)

Regards,
Lorenzo

--l8Y9Ld+yicHGP8LD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYYU4XwAKCRA6cBh0uS2t
rFJbAQCvBifc0Dq0KJsT7UbBOulYbfiOfGknn2biSMbNBAF0KQEAyRQvfXIYKrOl
+nW/vYSdZugQxZ+KKNC0zT5cxm3rZAA=
=e88q
-----END PGP SIGNATURE-----

--l8Y9Ld+yicHGP8LD--
