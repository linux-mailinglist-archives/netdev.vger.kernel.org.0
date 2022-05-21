Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EEE52FA79
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 12:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbiEUJ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 05:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiEUJ4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 05:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07235710C;
        Sat, 21 May 2022 02:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59FCB60FE1;
        Sat, 21 May 2022 09:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325F1C385A9;
        Sat, 21 May 2022 09:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653126980;
        bh=J8Kl5QDh8G+60wtyKm/zQ9HhPyt2i6OdeEYkmZ3BVvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dAjv74qHO4EfDSQWLqA0PaKO0yJrasf+pxkt1VZWq+8RDjaA546ve+YaNo8HTkcPC
         qR5E8alM4IIixPPC1DDHyw/cub+xov3uifJJl73it+V/WRSHXWEKHM9U7D+XyTBbyT
         z6B6ewShVvpgtkp842ad77p/wxLJf58YaMC+Ci13J6EWyOOCqyYHN9C8Zfmh/TEv/p
         MZLISYH9ihoKkG7XV9S4vkDEfhle9PmN0ojXP6KKkEtVQDj7zrfg0pJrFTb+4d1QG+
         RTLzKMlyPh7ClLlv9weorocYVd6SRS20/GNW0GCOfjJSmoEPcMoa88H44kLDoDQ0Se
         h5BnmvQgxZjag==
Date:   Sat, 21 May 2022 11:56:16 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: add selftest for
 bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc
Message-ID: <Yoi3QLuCD5Q5iG46@lore-desk>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
 <CAEf4BzZuKOR2y1LOzZLWm1sMFw3psPuzFcoYJ-yj0+PgzB2C1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Lh+jlsCfG/elROdQ"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZuKOR2y1LOzZLWm1sMFw3psPuzFcoYJ-yj0+PgzB2C1g@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Lh+jlsCfG/elROdQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, May 18, 2022 at 3:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > Introduce selftests for the following kfunc helpers:
> > - bpf_xdp_ct_add
> > - bpf_skb_ct_add
> > - bpf_ct_refresh_timeout
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../testing/selftests/bpf/prog_tests/bpf_nf.c |  4 ++
> >  .../testing/selftests/bpf/progs/test_bpf_nf.c | 72 +++++++++++++++----
> >  2 files changed, 64 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_nf.c
> > index dd30b1e3a67c..be6c5650892f 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > @@ -39,6 +39,10 @@ void test_bpf_nf_ct(int mode)
> >         ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONE=
T for bad but valid netns_id");
> >         ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT =
for failed lookup");
> >         ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EA=
FNOSUPPORT for invalid len__tuple");
> > +       ASSERT_EQ(skel->bss->test_add_entry, 0, "Test for adding new en=
try");
> > +       ASSERT_EQ(skel->bss->test_succ_lookup, 0, "Test for successful =
lookup");
> > +       ASSERT_TRUE(skel->bss->test_delta_timeout > 9 && skel->bss->tes=
t_delta_timeout <=3D 10,
> > +                   "Test for ct timeout update");
>=20
> if/when this fails we'll have "true !=3D false" message not knowing what
> was the actual value of skel->bss->test_delta_timeout.
>=20
> This is equivalent to a much better:
>=20
> ASSERT_GT(skel->bss->test_delta_timeout, 9, "ct_timeout1");
> ASSERT_LE(skel->bss->test_delta_timeout, 10, "ct_timeout2");

ack, I will fix it in the next version.

Regards,
Lorenzo

>=20
> >  end:
> >         test_bpf_nf__destroy(skel);
> >  }
>=20
>=20
> [...]

--Lh+jlsCfG/elROdQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoi3QAAKCRA6cBh0uS2t
rFLUAP9rOXf1/ICvLv8w6S0EJMMsADYMvo0Sd9xeb08Pr0JaCgD9FNDYMzWbuZAj
mFKaos0hE8FQfvkk6HZ1VMPy6p8VpgY=
=02hG
-----END PGP SIGNATURE-----

--Lh+jlsCfG/elROdQ--
