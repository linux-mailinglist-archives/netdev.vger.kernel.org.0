Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367B368A072
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjBCRgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBCRgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:36:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9183A9D79;
        Fri,  3 Feb 2023 09:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD7261FB6;
        Fri,  3 Feb 2023 17:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B20C433D2;
        Fri,  3 Feb 2023 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675445739;
        bh=ijwHAleeIaclM8f+Bu9zVC1Ch+njpvXpVWr4XsvMWeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joyc2iZeOziuFblivFSRgb0FVfrW4Zag8+TDk6F2dFU4XFWv2I9lTux4jLKa2b7uo
         lJh+HXddeot5EN7IQYbfxDUIX8jHaFs6e1S2FjNYzEOnxywY9l1hRgq15Lfyft0v5J
         KDQhZG3bHrFpCkGkm2eAOU1xFU8wR2iK2+0YZ7rC57BlS3YDSNVKIviYBVNbYcjOCF
         ttiwE7inssrWGSWexjCzgVq14l08OXTNGtCyxbYujwlAJJ5CBIdl7kQZcquSHj0d+x
         Xc/Lcru8A0iG9aJE6R8dlRDPPLOqN217LkrWpnG6jRuC//z52JWEMnV75CT2yWHTA8
         WGMjkpl/8rtDw==
Date:   Fri, 3 Feb 2023 18:36:44 +0100
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
        Stanislav Fomichev <sdf@google.com>,
        gerhard@engleder-embedded.com
Subject: Re: [PATCH v5 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
Message-ID: <Y91GLP4LCqsGE8kX@localhost.localdomain>
References: <cover.1675245257.git.lorenzo@kernel.org>
 <7c1af8e7e6ef0614cf32fa9e6bdaa2d8d605f859.1675245258.git.lorenzo@kernel.org>
 <CAADnVQLTBSTCr4O2kGWSz3ihOZxpXHz-8TuwbwXe6=7-XhiDkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BGAE9fS73UeimlfR"
Content-Disposition: inline
In-Reply-To: <CAADnVQLTBSTCr4O2kGWSz3ihOZxpXHz-8TuwbwXe6=7-XhiDkA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BGAE9fS73UeimlfR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Feb 1, 2023 at 2:25 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Introduce xdp_features tool in order to test XDP features supported by
> > the NIC and match them against advertised ones.
> > In order to test supported/advertised XDP features, xdp_features must
> > run on the Device Under Test (DUT) and on a Tester device.
> > xdp_features opens a control TCP channel between DUT and Tester devices
> > to send control commands from Tester to the DUT and a UDP data channel
> > where the Tester sends UDP 'echo' packets and the DUT is expected to
> > reply back with the same packet. DUT installs multiple XDP programs on =
the
> > NIC to test XDP capabilities and reports back to the Tester some XDP st=
ats.
>=20
>=20
> 'DUT installs...'? what? The device installs XDP programs ?

Hi Alexei,

DUT stands for Device Under Test, I was thinking it is quite a common term.
Sorry for that.

>=20
> > +
> > +       ctrl_sockfd =3D accept(*sockfd, (struct sockaddr *)&ctrl_addr, =
&addrlen);
> > +       if (ctrl_sockfd < 0) {
> > +               fprintf(stderr, "Failed to accept connection on DUT soc=
ket\n");
>=20
> Applied, but overuse of the word 'DUT' is incorrect and confusing.
>=20
> 'DUT socket' ? what is that?
> 'Invalid DUT address' ? what address?
> The UX in general is not user friendly.
>=20
> ./xdp_features
> Invalid ifindex
>=20
> This is not a helpful message.
>=20
> ./xdp_features eth0
> Starting DUT on device 3
> Failed to accept connection on DUT socket
>=20
> 'Starting DUT' ? What did it start?

I will post a follow-up patch to clarify them.

Regards,
Lorenzo

--BGAE9fS73UeimlfR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY91GKQAKCRA6cBh0uS2t
rFyeAQDjdxG2+NmNQt0HVAYJOIIXnYZMPQ9cnQgTOE1ivyToggD/TVESetmIn9aL
sGJ7s0tHO7M9dMMlQuiexvyDiUCGJw4=
=MZvV
-----END PGP SIGNATURE-----

--BGAE9fS73UeimlfR--
