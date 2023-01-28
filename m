Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93E867F7DA
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjA1Msx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjA1Msw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:48:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D12126F3;
        Sat, 28 Jan 2023 04:48:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5E8DB80921;
        Sat, 28 Jan 2023 12:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6647C433D2;
        Sat, 28 Jan 2023 12:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674910127;
        bh=q4YmhCFGMeK7V/V0+kIKf74gh6MkUEKWKYKZr0Q1zcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DPaiMQg27zAkIo+OpClY8AEt4CVLMA7gO+1YHJDC4A1QYsiQN3DAFrSjJR0++Q9om
         XTq6Pr9y+zogKe3Smxba9zOL4172/aDqY3ZfBCGCP1IRq6DrebB7Bj9oeVDEcefC4C
         20EwOPn/AWtNSpu0Iis/oQuIuugkPbDNeOzAenp1SslJg61Eo3UDFYhL2YAqJsP7Eu
         sBgMi2v9YqTAT9518gmPm8YaBzUFpvm9+nmMjMPDa7vVpp+XWWnufFxBnHbs0/QUni
         jYJbQmE4yzWsi/cR75E+4Zk3QpLnWDDgnayXeh5878o+i0ilnKAb1qTRhssZf1ujQn
         5s2AcclSllVqw==
Date:   Sat, 28 Jan 2023 13:48:43 +0100
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
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev
Subject: Re: [PATCH v3 bpf-next 5/8] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <Y9UZqxwNPDQ9jEu3@lore-desk>
References: <cover.1674737592.git.lorenzo@kernel.org>
 <a7e6e8da5b2ba24f44f0d5b44a234e2bf90220fd.1674737592.git.lorenzo@kernel.org>
 <CAEf4BzYjt3J5_ESMKjRFRh6ROg-CN=QazAZpKd9wnaSxjjKbAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="H5r5tXaizAjuuM7h"
Content-Disposition: inline
In-Reply-To: <CAEf4BzYjt3J5_ESMKjRFRh6ROg-CN=QazAZpKd9wnaSxjjKbAg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--H5r5tXaizAjuuM7h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Jan 26, 2023 at 4:59 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > Extend bpf_xdp_query routine in order to get XDP/XSK supported features
> > of netdev over route netlink interface.
> > Extend libbpf netlink implementation in order to support netlink_generic
> > protocol.
> >
> > Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.h  |  3 +-
> >  tools/lib/bpf/netlink.c | 99 +++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/nlattr.h  | 12 +++++
> >  3 files changed, 113 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 898db26e42e9..29cb7040fa77 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -982,9 +982,10 @@ struct bpf_xdp_query_opts {
> >         __u32 hw_prog_id;       /* output */
> >         __u32 skb_prog_id;      /* output */
> >         __u8 attach_mode;       /* output */
> > +       __u64 fflags;           /* output */
> >         size_t :0;
> >  };
> > -#define bpf_xdp_query_opts__last_field attach_mode
> > +#define bpf_xdp_query_opts__last_field fflags
>=20
> is "fflags" an obvious name in this context? I'd expect
> "feature_flags", especially that there are already "flags". Is saving
> a few characters worth the confusion?

ack, I will fix it.

>=20
>=20
> >
> >  LIBBPF_API int bpf_xdp_attach(int ifindex, int prog_fd, __u32 flags,
> >                               const struct bpf_xdp_attach_opts *opts);
> > diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> > index d2468a04a6c3..674e4d61e67e 100644
> > --- a/tools/lib/bpf/netlink.c
> > +++ b/tools/lib/bpf/netlink.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/if_ether.h>
> >  #include <linux/pkt_cls.h>
> >  #include <linux/rtnetlink.h>
> > +#include <linux/netdev.h>
> >  #include <sys/socket.h>
> >  #include <errno.h>
> >  #include <time.h>
> > @@ -39,6 +40,12 @@ struct xdp_id_md {
> >         int ifindex;
> >         __u32 flags;
> >         struct xdp_link_info info;
> > +       __u64 fflags;
> > +};
> > +
> > +struct xdp_features_md {
> > +       int ifindex;
> > +       __u64 flags;
> >  };
> >
> >  static int libbpf_netlink_open(__u32 *nl_pid, int proto)
>=20
> [...]
>=20
> >  int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opt=
s *opts)
> >  {
> >         struct libbpf_nla_req req =3D {
> > @@ -393,6 +460,38 @@ int bpf_xdp_query(int ifindex, int xdp_flags, stru=
ct bpf_xdp_query_opts *opts)
> >         OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
> >         OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
> >
> > +       if (OPTS_HAS(opts, fflags)) {
>=20
> maybe invert condition, return early, reduce nesting of the following cod=
e?

ack, fine, I will fix it.

>=20
> > +               struct xdp_features_md md =3D {
> > +                       .ifindex =3D ifindex,
> > +               };
> > +               __u16 id;
> > +
> > +               err =3D libbpf_netlink_resolve_genl_family_id("netdev",
> > +                                                           sizeof("net=
dev"),
> > +                                                           &id);
>=20
> nit: if it fits under 100 characters, let's leave it on a single line

ack, fine, I will fix it (I am still used to 79 char limits :))

Regards,
Lorenzo

>=20
> > +               if (err < 0)
> > +                       return libbpf_err(err);
> > +
> > +               memset(&req, 0, sizeof(req));
> > +               req.nh.nlmsg_len =3D NLMSG_LENGTH(GENL_HDRLEN);
> > +               req.nh.nlmsg_flags =3D NLM_F_REQUEST;
> > +               req.nh.nlmsg_type =3D id;
> > +               req.gnl.cmd =3D NETDEV_CMD_DEV_GET;
> > +               req.gnl.version =3D 2;
> > +
> > +               err =3D nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex,
> > +                                sizeof(ifindex));
> > +               if (err < 0)
> > +                       return err;
> > +
> > +               err =3D libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> > +                                              parse_xdp_features, NULL=
, &md);
> > +               if (err)
> > +                       return libbpf_err(err);
> > +
> > +               opts->fflags =3D md.flags;
> > +       }
> > +
> >         return 0;
> >  }
> >
>=20
> [...]

--H5r5tXaizAjuuM7h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9UZqwAKCRA6cBh0uS2t
rBxoAP0cbq7hs6/E0Xww1WyBoVO/koarQuFXB5dQjh+u7148WAD+IB9ZdSVQzt5f
ogltg73yhQG8hmRf64y75STgSRlB6Qc=
=/DWr
-----END PGP SIGNATURE-----

--H5r5tXaizAjuuM7h--
