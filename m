Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406025B020C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIGKrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIGKrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F8B86056;
        Wed,  7 Sep 2022 03:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11B0661879;
        Wed,  7 Sep 2022 10:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17395C433D6;
        Wed,  7 Sep 2022 10:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662547664;
        bh=I7d1WtBOS6DO0ReoDL4n7WLq/kAOgmrslndzRivgC1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CxApxk10io9pIympZgmC1jEEbL0oVOZCDCaRBNX6DILuvQgV3Wd9QYKZbterG0Xvm
         OzWj6FRgsAQZEYMuDbgqr0iM+1FxEmX7Ok5s9IwlQaDLByhkZ9RS3LniXMe1P7pdNk
         UmF4snGzJiR6xdc7B3XBkgmzRuW2dDbVl7MRrn2gh8C+5/uGdZ+QN00MzMAJK0bPBi
         tdviln7UqjMv0c7jAJKZgZ0k1gI0pIX3d0QXbiMH1aGzqUfDfU0wdobugJiFHUnmUe
         JCdx++csHvCXcjDqbeKRIa0f0m8KgZ4T27Ip+v1DPZ3dgno7qzBKgfahk5/DfxuA48
         ltEs6ydD9xR1g==
Date:   Wed, 7 Sep 2022 12:47:40 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add tests for
 bpf_ct_set_nat_info kfunc
Message-ID: <Yxh2zOZ4Q5OSMXir@lore-desk>
References: <cover.1662383493.git.lorenzo@kernel.org>
 <6e77fb26ae5854061b6c2d004d6547bf971f7dcd.1662383493.git.lorenzo@kernel.org>
 <CAPhsuW7J6UOihzNsmBm=tOk6QzNjok2YEh5S0yVJLXb__7t5eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y9sSKKIaXtmQrFSX"
Content-Disposition: inline
In-Reply-To: <CAPhsuW7J6UOihzNsmBm=tOk6QzNjok2YEh5S0yVJLXb__7t5eA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y9sSKKIaXtmQrFSX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Sep 5, 2022 at 6:15 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Introduce self-tests for bpf_ct_set_nat_info kfunc used to set the
> > source or destination nat addresses/ports.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/config            |  1 +
> >  .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 ++
> >  .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 ++++++++++++++++++-
> >  3 files changed, 28 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftes=
ts/bpf/config
> > index 3fc46f9cfb22..8ce48f7213cb 100644
> > --- a/tools/testing/selftests/bpf/config
> > +++ b/tools/testing/selftests/bpf/config
> > @@ -57,6 +57,7 @@ CONFIG_NF_CONNTRACK=3Dy
> >  CONFIG_NF_CONNTRACK_MARK=3Dy
> >  CONFIG_NF_DEFRAG_IPV4=3Dy
> >  CONFIG_NF_DEFRAG_IPV6=3Dy
> > +CONFIG_NF_NAT=3Dy
> >  CONFIG_RC_CORE=3Dy
> >  CONFIG_SECURITY=3Dy
> >  CONFIG_SECURITYFS=3Dy
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_nf.c
> > index 544bf90ac2a7..f16913f8fca2 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > @@ -115,6 +115,8 @@ static void test_bpf_nf_ct(int mode)
> >         ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update=
 ");
> >         ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing conn=
ection lookup");
> >         ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing=
 connection lookup ctmark");
> > +       ASSERT_EQ(skel->data->test_snat_addr, 0, "Test for source natti=
ng");
> > +       ASSERT_EQ(skel->data->test_dnat_addr, 0, "Test for destination =
natting");
> >  end:
> >         if (srv_client_fd !=3D -1)
> >                 close(srv_client_fd);
> > diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/te=
sting/selftests/bpf/progs/test_bpf_nf.c
> > index 2722441850cc..3f441595098b 100644
> > --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> > @@ -23,6 +23,8 @@ int test_insert_entry =3D -EAFNOSUPPORT;
> >  int test_succ_lookup =3D -ENOENT;
> >  u32 test_delta_timeout =3D 0;
> >  u32 test_status =3D 0;
> > +int test_snat_addr =3D -EINVAL;
> > +int test_dnat_addr =3D -EINVAL;
> >  __be32 saddr =3D 0;
> >  __be16 sport =3D 0;
> >  __be32 daddr =3D 0;
> > @@ -53,6 +55,8 @@ void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
> >  int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
> >  int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
> >  int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
> > +int bpf_ct_set_nat_info(struct nf_conn *, union nf_inet_addr *,
> > +                       __be16 *port, enum nf_nat_manip_type) __ksym;
> >
> >  static __always_inline void
> >  nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple =
*, u32,
> > @@ -140,10 +144,19 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, s=
truct bpf_sock_tuple *, u32,
> >         ct =3D alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_=
def,
> >                       sizeof(opts_def));
> >         if (ct) {
> > +               __be16 sport =3D bpf_get_prandom_u32();
> > +               __be16 dport =3D bpf_get_prandom_u32();
> > +               union nf_inet_addr saddr =3D {};
> > +               union nf_inet_addr daddr =3D {};
> >                 struct nf_conn *ct_ins;
> >
> >                 bpf_ct_set_timeout(ct, 10000);
> > -               bpf_ct_set_status(ct, IPS_CONFIRMED);
>=20
> So this is paired with the IPS_CONFIRMED change in 3/4?

we actually do not need it since it is already done during entry allocation=
 (or
insertion).
Looking again at the code I spotted a bug since we do not really check the =
value
configured with bpf_ct_change_status(ct_lk, IPS_SEEN_REPLY). I will post a =
fix.

Regards,
Lorenzo

>=20
> Thanks,
> Song

--y9sSKKIaXtmQrFSX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYxh2zAAKCRA6cBh0uS2t
rJrSAP4pHpqEwXS9PI3zcOrNBqV09Aoz3hC+ymNR1bE61qjEygD8CY1OVh/hoWiU
AYkVCg8pDVhZcgTVaoj8xFnZajK0Awo=
=NRHP
-----END PGP SIGNATURE-----

--y9sSKKIaXtmQrFSX--
