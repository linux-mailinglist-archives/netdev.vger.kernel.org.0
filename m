Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBF76F0788
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243943AbjD0Odf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 10:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243577AbjD0Ode (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 10:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7975646AE;
        Thu, 27 Apr 2023 07:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14EE6631EE;
        Thu, 27 Apr 2023 14:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9242C433D2;
        Thu, 27 Apr 2023 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682605987;
        bh=qEJtcniDMy+YySSJjYGgARTsLmXyjwpz6UA9Feh+L9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qFFc3jpf5jcmGvMnYJ3pSMcXCDkAPWcSWF7DIA8iargBrZfliSVUV0PtSvCPBmZNd
         JCcyYh39dK5fDCsaAddBfi7Thlacxu/gPkClF54lDkZ+XMk0Q/TP22rvsDHQbPayFs
         /+rw4iSGX6iIqziE+XrCjV8cZjRqEeuZvfeklz3PrzTc8PUHjwvGcWZItOH0JQlAd/
         9oj9yOkXt1WIIFmYgWaobyE6S5olCz38LZ3q4MMrjNdnnVWPj1WRLh5WY6RbHkjDWn
         lAXU7xzB0JTVxM3AGYWRVvIlECPeW8W9todJw3/DB69aqUVjF0MRnxpAQVMTVYc4I5
         4uSPe8Klj6yBQ==
Date:   Thu, 27 Apr 2023 16:33:03 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Marek Majtyka <alardam@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH net 2/2] selftests/bpf: add xdp_feature selftest for bond
 device
Message-ID: <ZEqHn4/+SKADyvpe@lore-desk>
References: <cover.1682603719.git.lorenzo@kernel.org>
 <b834b5a0c5e0e76a2ae34b1525a7761ef59c20d8.1682603719.git.lorenzo@kernel.org>
 <CAADnVQLy9VRagq_=fTd2=Hw-ceR51hDSPYj3yo3=7v8z6fbtYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Tl1WWHVwV65Rdn0J"
Content-Disposition: inline
In-Reply-To: <CAADnVQLy9VRagq_=fTd2=Hw-ceR51hDSPYj3yo3=7v8z6fbtYw@mail.gmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Tl1WWHVwV65Rdn0J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 27, 2023 at 7:04=E2=80=AFAM Lorenzo Bianconi <lorenzo@kernel.=
org> wrote:
> >
> > Introduce selftests to check xdp_feature support for bond driver.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/xdp_bonding.c    | 121 ++++++++++++++++++
> >  1 file changed, 121 insertions(+)
>=20
> Please always submit patches that touch bpf selftest via bpf tree.
> Otherwise BPF CI doesn't run on them.
> We've seen failures in the past when such patches went through net tree.

ack, I will repost after the "guard" period splitting the series.

Regards,
Lorenzo

--Tl1WWHVwV65Rdn0J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEqHnwAKCRA6cBh0uS2t
rCc6AQC9TInSYIpU3h7knaOxLG3omz5M1Fk6Ogj1pVuSOTjNzAD+MyDs1oINcUWt
PBXZIrpfYXeXynuxADxvEvr2dXyr9wk=
=jn3B
-----END PGP SIGNATURE-----

--Tl1WWHVwV65Rdn0J--
