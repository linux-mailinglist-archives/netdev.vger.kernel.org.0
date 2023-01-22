Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95C8677321
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 00:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjAVXAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 18:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjAVXA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 18:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6618ABD;
        Sun, 22 Jan 2023 15:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 572C060CA4;
        Sun, 22 Jan 2023 23:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D740C433D2;
        Sun, 22 Jan 2023 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674428423;
        bh=uUTTKSl1nNDXWYdwLpdwmCAKDhgMF5jWMT+kNzvGmBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J9n6ZPcCE7LMUifswqqagkI5taZpNjcsdxbFCMsbw4XO8ML5XDkrJ+DDueR4fidEN
         m76zqLzFvYY0QYLgkM8LM57myy66VkbdzZID7/fUEflBjEE8+E6so6dElqvIA//aHB
         QWPmVPsgLZ02+v5+2hi/wDYXeztv8vtHCr1t6/en8G/ZaZZImWaD+4Za4W7TGhxqlp
         qOSe99EL6/COC7JyoSXyjPfMRm+n43t3lo+TsOIOJQhNy3CDISGPXqUwot9ufQnFtV
         BNFAP4cwrs9xcjNRUWQrn2/QVSKgzfsJQNTLD9MNb0LavDCkwUhy4z9vaO7YVljat0
         rDkjhzseHAIFQ==
Date:   Sun, 22 Jan 2023 18:45:56 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, anthony.l.nguyen@intel.com,
        Andy Gospodarek <gospo@broadcom.com>, vladimir.oltean@nxp.com,
        Felix Fietkau <nbd@nbd.name>, john@phrozen.org,
        leon@kernel.org, Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
Message-ID: <Y812VL/IJ5fjrDqI@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
 <CAADnVQLHsV2Y-UiDkEnhwnfvgRxGN4OY8mwi_p-a01WUTdDBNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JG/nnC/faKMKtE/K"
Content-Disposition: inline
In-Reply-To: <CAADnVQLHsV2Y-UiDkEnhwnfvgRxGN4OY8mwi_p-a01WUTdDBNw@mail.gmail.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JG/nnC/faKMKtE/K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 20, Alexei Starovoitov wrote:
> On Fri, Jan 20, 2023 at 9:17 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> > +
> > +#define NETDEV_XDP_ACT_BASIC           (NETDEV_XDP_ACT_DROP |  \
> > +                                        NETDEV_XDP_ACT_PASS |  \
> > +                                        NETDEV_XDP_ACT_TX |    \
> > +                                        NETDEV_XDP_ACT_ABORTED)
>=20
> Why split it into 4?
> Is there a driver that does a subset?

nope, at least all drivers support NETDEV_XDP_ACT_BASIC. I guess we can squ=
ash
them and just add  NETDEV_XDP_ACT_BASIC.

Regards,
Lorenzo

--JG/nnC/faKMKtE/K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY812VAAKCRA6cBh0uS2t
rPuwAP4i5puJyPSRIVKHOHLlPm0UaUEMqwzRZgndVwm2OXUAiQEAo1TMBEHHjutT
scfxZ8+YzP8HXj5bjef2m6Sb7jPt7w0=
=XpP9
-----END PGP SIGNATURE-----

--JG/nnC/faKMKtE/K--
