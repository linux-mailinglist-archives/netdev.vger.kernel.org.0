Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF65AFFC9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiIGJBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiIGJBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:01:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D993A060B;
        Wed,  7 Sep 2022 02:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABF31B81BBB;
        Wed,  7 Sep 2022 09:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086C9C433D6;
        Wed,  7 Sep 2022 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662541267;
        bh=rH6TTBqa/Bz0QhJHyUANa4AuDGXX3ecMpobbjz6gRfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AShtNBs5ji0EgTLzQupsf1gReGro8yuTQDq4Xv56jP/rJk6DUS8ARBfWZXlpBRzVE
         mxuT7jShmgf2NJKvcQ71IBoTPn6hEonTw3vwFUDy23/9P4Uwlu4subQntwiZ1FY4VY
         ZLZbiZu9q2XHlKcRJE3NrC04c9kLuq+3vwavpgYmmJkOjUccM8bm49KrauNt7wXXhY
         adPhmqIcV+mpFilqY6Hdx90scmhLoStut0c25zfEFLWCI2DsKNH5f09zSMn2eCj2cR
         WzxCPLalCny33WrzhFH8JE7IhTfIWExj0v9PqG2s/oqmFSygLVl7+MQUcYDDXPLH65
         5S5Ss0mNxUNqQ==
Date:   Wed, 7 Sep 2022 11:01:03 +0200
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
Subject: Re: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
Message-ID: <Yxhdz47DZiL8V4JE@lore-desk>
References: <cover.1662383493.git.lorenzo@kernel.org>
 <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
 <CAPhsuW5P=K7463Ka0CGxFD0BGChrEffbeO6UqReDtr80osDJLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Bjcyid3/P3gYQ/y/"
Content-Disposition: inline
In-Reply-To: <CAPhsuW5P=K7463Ka0CGxFD0BGChrEffbeO6UqReDtr80osDJLg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Bjcyid3/P3gYQ/y/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Sep 5, 2022 at 6:15 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> > destination nat addresses/ports in a new allocated ct entry not inserted
> > in the connection tracking table yet.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/netfilter/nf_conntrack_bpf.c | 49 +++++++++++++++++++++++++++++++-
> >  1 file changed, 48 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntr=
ack_bpf.c
> > index 1cd87b28c9b0..85b8c7ee00af 100644
> > --- a/net/netfilter/nf_conntrack_bpf.c
> > +++ b/net/netfilter/nf_conntrack_bpf.c
> > @@ -14,6 +14,7 @@
> >  #include <net/netfilter/nf_conntrack.h>
> >  #include <net/netfilter/nf_conntrack_bpf.h>
> >  #include <net/netfilter/nf_conntrack_core.h>
> > +#include <net/netfilter/nf_nat.h>
> >
> >  /* bpf_ct_opts - Options for CT lookup helpers
> >   *
> > @@ -134,7 +135,6 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf=
_sock_tuple *bpf_tuple,
> >
> >         memset(&ct->proto, 0, sizeof(ct->proto));
> >         __nf_ct_set_timeout(ct, timeout * HZ);
> > -       ct->status |=3D IPS_CONFIRMED;
> >
> >  out:
> >         if (opts->netns_id >=3D 0)
> > @@ -339,6 +339,7 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn_=
__init *nfct_i)
> >         struct nf_conn *nfct =3D (struct nf_conn *)nfct_i;
> >         int err;
> >
> > +       nfct->status |=3D IPS_CONFIRMED;
> >         err =3D nf_conntrack_hash_check_insert(nfct);
> >         if (err < 0) {
> >                 nf_conntrack_free(nfct);
> > @@ -424,6 +425,51 @@ int bpf_ct_change_status(struct nf_conn *nfct, u32=
 status)
> >         return nf_ct_change_status_common(nfct, status);
> >  }
>=20
> Why do we need the above two changes in this patch?

nf_nat_setup_info() does not really add the nat info in the connection trac=
king
entry if it is already confirmed (it just returns NF_ACCEPT). I moved
IPS_CONFIRMED in bpf_ct_insert_entry() since we can run bpf_ct_set_nat_info=
()
just if the entry has not inserted in the table yet.

Regards,
Lorenzo

>=20
> Thanks,
> Song

--Bjcyid3/P3gYQ/y/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYxhdzwAKCRA6cBh0uS2t
rFQAAP9N6QFmTiFwKPuVU9Xq3PxrGlPWKdybMgExG+P8ncCOxgEAstVttxKiizOI
3Qutbjz+rzRm/1EyVR08VmoT9DV/Yg8=
=o5De
-----END PGP SIGNATURE-----

--Bjcyid3/P3gYQ/y/--
