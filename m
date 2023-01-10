Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA65664764
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbjAJR0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbjAJR0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:26:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320121120;
        Tue, 10 Jan 2023 09:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8E4E6182E;
        Tue, 10 Jan 2023 17:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE3FC433EF;
        Tue, 10 Jan 2023 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673371609;
        bh=qIMUHEEcxEFfEbsuapq6m8UyQ8u7bBrd1f5qfus81vM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dWyQOYB751j90pvk6Be/N7sAgq8S/NdKvGo/Pq2IDrJqjFRcd8WnRYiAeB2CbdIBX
         PITITR+KfDlhRYo5Nw1srNwDh74Pt76tjHudW8N7HIOqk/VPc0ZAT45XHOhshPmt8j
         dJnDfjxZMtytRAdM7/kfzrtTBzDZUd/Hhx+Ohg8/hW4StQBgh3uqYFG908DIEFDJSy
         3+MHv9rINr7sNPbZtzjWZgw6IjGRy+L5rmq5qmdEPtXjVLoBrzkQhauov1Y3jRkTNd
         PQxX3XiUUF5rV2bJDbRzwLyYtV/S6IB7p2sTL85OTn4Qcvff22DYtsq9gw2oSON908
         8Vrts9C9Ma5IQ==
Date:   Tue, 10 Jan 2023 18:26:45 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com, mst@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC bpf-next 6/8] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <Y72f1U2/dw8jo0/0@lore-desk>
References: <cover.1671462950.git.lorenzo@kernel.org>
 <6cce9b15a57345402bb94366434a5ac5609583b8.1671462951.git.lorenzo@kernel.org>
 <CAEf4BzbOF-S3kjbNVXCZR-K=TGarfi06ZwG1cbNF=HSSodwEfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aGzNKNmdiT3FYYot"
Content-Disposition: inline
In-Reply-To: <CAEf4BzbOF-S3kjbNVXCZR-K=TGarfi06ZwG1cbNF=HSSodwEfg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aGzNKNmdiT3FYYot
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Dec 19, 2022 at 7:42 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >
> > Add functions to get XDP/XSK supported function of netdev over route
> > netlink interface. These functions provide functionalities that are
> > going to be used in upcoming change.
> >
> > The newly added bpf_xdp_query_features takes a fflags_cnt parameter,
> > which denotes the number of elements in the output fflags array. This
> > must be at least 1 and maybe greater than XDP_FEATURES_WORDS. The
> > function only writes to words which is min of fflags_cnt and
> > XDP_FEATURES_WORDS.
> >
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.h   |  1 +
> >  tools/lib/bpf/libbpf.map |  1 +
> >  tools/lib/bpf/netlink.c  | 62 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 64 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index eee883f007f9..9d102eb5007e 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -967,6 +967,7 @@ LIBBPF_API int bpf_xdp_detach(int ifindex, __u32 fl=
ags,
> >                               const struct bpf_xdp_attach_opts *opts);
> >  LIBBPF_API int bpf_xdp_query(int ifindex, int flags, struct bpf_xdp_qu=
ery_opts *opts);
> >  LIBBPF_API int bpf_xdp_query_id(int ifindex, int flags, __u32 *prog_id=
);
> > +LIBBPF_API int bpf_xdp_query_features(int ifindex, __u32 *fflags, __u3=
2 *fflags_cnt);
>=20
> no need to add new API, just extend bpf_xdp_query()?

Hi Andrii,

AFAIK libbpf supports just NETLINK_ROUTE protocol. In order to connect with=
 the
genl family code shared by Jakub we need to add NETLINK_GENERIC protocol su=
pport
to libbf. Is it ok to introduce a libmnl or libnl dependency in libbpf or d=
o you
prefer to add open code to just what we need?
I guess we should have a dedicated API to dump xdp features in this case si=
nce
all the other code relies on NETLINK_ROUTE protocol. What do you think?

Regards,
Lorenzo

>=20
> >
> >  /* TC related API */
> >  enum bpf_tc_attach_point {
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 71bf5691a689..9c2abb58fa4b 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -362,6 +362,7 @@ LIBBPF_1.0.0 {
> >                 bpf_program__set_autoattach;
> >                 btf__add_enum64;
> >                 btf__add_enum64_value;
> > +               bpf_xdp_query_features;
> >                 libbpf_bpf_attach_type_str;
> >                 libbpf_bpf_link_type_str;
> >                 libbpf_bpf_map_type_str;
>=20
> [...]

--aGzNKNmdiT3FYYot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY72f1QAKCRA6cBh0uS2t
rGtIAQD9CU+tItECNI3dIRiliqYGAXnkOOl6g7JU3GkonqJsxAD9EbSrhAp9DY7o
++BFm5/bt/xOJUm02tX2yaQq43S72gQ=
=/rJB
-----END PGP SIGNATURE-----

--aGzNKNmdiT3FYYot--
