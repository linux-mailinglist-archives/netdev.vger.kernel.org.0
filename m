Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0D676CB1
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 13:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjAVMNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 07:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjAVMNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 07:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D834A1ABCA;
        Sun, 22 Jan 2023 04:13:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 897B1B80AAD;
        Sun, 22 Jan 2023 12:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD95AC433D2;
        Sun, 22 Jan 2023 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674389625;
        bh=nejjdNUwfU0DIrqoZxOV5br+QIBkmnp0CISUYJT/5Qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ITtVZ7Ndr10M6em5OTP/bLAVZ3qKxXv/6Qb84zRWZogu72llAjYmYIiVUthsCa/Gz
         vbT3xv2JIhXdeV/dCCd77gywboNBPKxn57/flP3wPdlVUtIr9sN+RgBWS0gGeCh3aw
         oycDNN4zwS1vmuO7ArZva8dSREyQecLdZ+BM247/FzhRtxAatSmUR42UoOBVJzK6pt
         9tP5eu30tP59hx0+fjSpud8upT79ln7bYT25yiJsTWL2LLy8nduLrrlJuyy7Oq5r+U
         DsJHwePEncpclqNX2F1E1/mrJhUox0j7i6eP/uuIFX4lC0cQXd8p+XTUzbYkOa9oLZ
         ApOa7PrGVz/9g==
Date:   Sun, 22 Jan 2023 13:13:41 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 6/7] bpf: devmap: check XDP features in
 bpf_map_update_elem and __xdp_enqueue
Message-ID: <Y80odbX/CVjlYalh@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <acc9460e6e29dfe02cf474735277e196b500d2ef.1674234430.git.lorenzo@kernel.org>
 <d0232e99-862b-3255-aeac-7c04486cb773@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xWUqnwFWf7284WXp"
Content-Disposition: inline
In-Reply-To: <d0232e99-862b-3255-aeac-7c04486cb773@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xWUqnwFWf7284WXp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 1/20/23 9:16 AM, Lorenzo Bianconi wrote:
> > ---
> >   kernel/bpf/devmap.c | 25 +++++++++++++++++++++----
> >   net/core/filter.c   | 13 +++++--------
> >   2 files changed, 26 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > index d01e4c55b376..69ceecc792df 100644
> > --- a/kernel/bpf/devmap.c
> > +++ b/kernel/bpf/devmap.c
> > @@ -474,7 +474,11 @@ static inline int __xdp_enqueue(struct net_device =
*dev, struct xdp_frame *xdpf,
> >   {
> >   	int err;
> > -	if (!dev->netdev_ops->ndo_xdp_xmit)
> > +	if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
>=20
> The current "dev->netdev_ops->ndo_xdp_xmit" check is self explaining.
> Any plan to put some document for the NETDEV_XDP_ACT_* values?
>=20

I am not a yaml description expert but I guess we can xdp features descript=
ion
in Documentation/netlink/specs/netdev.yaml.

@Jakub: what do you think?

Regards,
Lorenzo

--xWUqnwFWf7284WXp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY80odQAKCRA6cBh0uS2t
rOZZAP4xiweG52WS6f8PS7IkQtzz2xIQ3sDMfAU6uQvmNajMXwEA2UFIc2hPjg7J
X/vug32zo0B7cWy9Cy2A9j+RGGE+rAk=
=csRR
-----END PGP SIGNATURE-----

--xWUqnwFWf7284WXp--
