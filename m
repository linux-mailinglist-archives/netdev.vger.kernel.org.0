Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0916800F3
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbjA2Ssk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjA2Ssf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:48:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176BD1F4BA;
        Sun, 29 Jan 2023 10:48:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4010B80CBB;
        Sun, 29 Jan 2023 18:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA412C433D2;
        Sun, 29 Jan 2023 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675018085;
        bh=wqWSHpwy3MUpVmsntNqQHtsxLsPh+QcU+TX0EB5Z+4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nz1tZKtoo2WWyX7mMEDJ0juSHAcoJaOdpTBcbcWkG+P8/FhbZM+UEhpuuleS+FLUd
         4OzJ1t+ZdgzDeJ+nJ4yDp/amMYIlrdWBGOEzygjP42g2g245qB9D3YSX7Pbdh7NvOW
         5G4KuVbsuWWQ0KnKKM0iPK/t2i+ekATc7EwjAmIiuv6cHg1mOiOx/9Ws+QUbW+Wz9U
         iOyZMdtrQfBGEEPLquar3kg/yHDyqjMVltQbV/uB/96KSSE2RytjjXyE4kAIQ1je0/
         KSX1gPVLOhpWEHgNY+q/tEpVTXmBZVKNPWb4FJ1+jipdegmwISU77c+1qKZg14IB+2
         gkfbLrJHYVGKg==
Date:   Sun, 29 Jan 2023 19:48:01 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, anthony.l.nguyen@intel.com,
        Andy Gospodarek <gospo@broadcom.com>, vladimir.oltean@nxp.com,
        Felix Fietkau <nbd@nbd.name>, john@phrozen.org,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH v4 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
Message-ID: <Y9a/YWBBU/cjofIr@lore-desk>
References: <cover.1674913191.git.lorenzo@kernel.org>
 <a7eaa7e3e4c0a7e70f68c32314a7f75c9bba4465.1674913191.git.lorenzo@kernel.org>
 <CAADnVQJhdxM6eqvxRZ7JjxEc+fDG5CwnV_FAGs+H+djNye0e=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Nx0wHPKtgW7QyJuF"
Content-Disposition: inline
In-Reply-To: <CAADnVQJhdxM6eqvxRZ7JjxEc+fDG5CwnV_FAGs+H+djNye0e=w@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Nx0wHPKtgW7QyJuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 28, Alexei Starovoitov wrote:
> On Sat, Jan 28, 2023 at 6:07 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> > diff --git a/tools/testing/selftests/bpf/xdp_features.h b/tools/testing=
/selftests/bpf/xdp_features.h
> > new file mode 100644
> > index 000000000000..28d7614c4f02
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/xdp_features.h
> > @@ -0,0 +1,33 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +/* test commands */
> > +enum test_commands {
> > +       CMD_STOP,               /* CMD */
> > +       CMD_START,              /* CMD + xdp feature */
> > +       CMD_ECHO,               /* CMD */
> > +       CMD_ACK,                /* CMD + data */
> > +       CMD_GET_XDP_CAP,        /* CMD */
> > +       CMD_GET_STATS,          /* CMD */
> > +};
> > +
> > +#define DUT_CTRL_PORT  12345
> > +#define DUT_ECHO_PORT  12346
> > +
> > +struct tlv_hdr {
> > +       __be16 type;
> > +       __be16 len;
> > +       __be32 data[];
> > +};
> > +
> > +enum {
> > +       XDP_FEATURE_ABORTED,
> > +       XDP_FEATURE_DROP,
> > +       XDP_FEATURE_PASS,
> > +       XDP_FEATURE_TX,
> > +       XDP_FEATURE_REDIRECT,
> > +       XDP_FEATURE_NDO_XMIT,
> > +       XDP_FEATURE_XSK_ZEROCOPY,
> > +       XDP_FEATURE_HW_OFFLOAD,
> > +       XDP_FEATURE_RX_SG,
> > +       XDP_FEATURE_NDO_XMIT_SG,
> > +};
>=20
> This doesn't match the kernel.
> How did you test this?
> What should be the way to prevent such mistakes in the future?

Hi Alexei,

I added the XDP_FEATURE_* enum above since the XDP compliance test tool nee=
ds
to differentiate between actions in NETDEV_XDP_ACT_BASIC (e.g XDP_TX and
XDP_PASS or XDP_REDIRECT are handled differently in the ebpf programs insta=
lled
on the tester and DUT devices). However, combining netdev_xdp_act and xdp_a=
ction
enum definitions, I think we can keep this logic in xdp_feature userspace p=
art
and we can get rid of the XDP_FEATURE_* enum above.
I will fix it in v5.

Regards,
Lorenzo

--Nx0wHPKtgW7QyJuF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9a/YQAKCRA6cBh0uS2t
rA0MAQD14qKZyBuuTUx+gcvcXc9dncuAjpGH/LEYEmvcdZpjPgD/evMoa3V8P0ut
zGEhB25aPtnf/qiDteYI2cvq8czggAw=
=A3gE
-----END PGP SIGNATURE-----

--Nx0wHPKtgW7QyJuF--
