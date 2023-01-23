Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28B2678C06
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjAWX3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAWX3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:29:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDF416AFD;
        Mon, 23 Jan 2023 15:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3180CE1379;
        Mon, 23 Jan 2023 23:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739CDC433EF;
        Mon, 23 Jan 2023 23:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674516550;
        bh=Ggo5QP8q+ffH6krbPwKFl4pj1x/CqV1c9NmMozm8TA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsTlxwEQDGypI1iVMP8OE5hNIBZw1xSJI4yB6/ix/Gzj9g1Urb6GVYLfLwUP1ASQO
         lKbVPvX4G9PZalf/FfTN4WcmeEMwui1R05r9HDNIBK8mL09L0arX0CHkOctYfrvDbf
         EcBp4QgIfJ+EiZfT+zB+U5rCVJxxNhhhI1s+78cZb34XNdNv+h5EgfwA0W09+R4qCi
         daDVxxMatyhfYII2mzIzq2nIC40pNQRdssZc8Uqus4Km9S9pWiqU9/MB43CThpci7V
         1/nS6QjaUfJLPg9A1SgAwnzCIGIYpblkxacTzInDOPsK4b4Vr0bRfIkZd86Rmw7wCt
         nsTThmhDksiCw==
Date:   Tue, 24 Jan 2023 00:29:07 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        niklas.soderlund@corigine.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 6/7] bpf: devmap: check XDP features in
 bpf_map_update_elem and __xdp_enqueue
Message-ID: <Y88YQzh1WCjFTmGl@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <acc9460e6e29dfe02cf474735277e196b500d2ef.1674234430.git.lorenzo@kernel.org>
 <d0232e99-862b-3255-aeac-7c04486cb773@linux.dev>
 <Y80odbX/CVjlYalh@lore-desk>
 <20230123120958.741cf5f1@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qziEnyJPquu9LTl8"
Content-Disposition: inline
In-Reply-To: <20230123120958.741cf5f1@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qziEnyJPquu9LTl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 23, Jakub Kicinski wrote:
> On Sun, 22 Jan 2023 13:13:41 +0100 Lorenzo Bianconi wrote:
> > > > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > > > index d01e4c55b376..69ceecc792df 100644
> > > > --- a/kernel/bpf/devmap.c
> > > > +++ b/kernel/bpf/devmap.c
> > > > @@ -474,7 +474,11 @@ static inline int __xdp_enqueue(struct net_dev=
ice *dev, struct xdp_frame *xdpf,
> > > >   {
> > > >   	int err;
> > > > -	if (!dev->netdev_ops->ndo_xdp_xmit)
> > > > +	if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT)) =20
> > >=20
> > > The current "dev->netdev_ops->ndo_xdp_xmit" check is self explaining.
> > > Any plan to put some document for the NETDEV_XDP_ACT_* values?
> > >  =20
> >=20
> > I am not a yaml description expert but I guess we can xdp features desc=
ription
> > in Documentation/netlink/specs/netdev.yaml.
> >=20
> > @Jakub: what do you think?
>=20
> I've added the ability to document enums recently, so you may need
> to rebase. But it should work and render the documentation as kdoc=20
> in the uAPI header (hopefully in a not-too-ugly way).
>=20
> Example of YAML:
> https://github.com/kuba-moo/ynl/blob/dpll/Documentation/netlink/specs/dpl=
l.yaml#L27-L46

ack, it works properly I guess, I got the following kdoc in the uAPI:

/**
 * enum netdev_xdp_act
 * @NETDEV_XDP_ACT_BASIC: XDP feautues set supported by all drivers
 *   (XDP_ABORTED, XDP_DROP, XDP_PASS, XDP_TX)
 * @NETDEV_XDP_ACT_REDIRECT: The netdev supports XDP_REDIRECT
 * @NETDEV_XDP_ACT_NDO_XMIT: This feature informs if netdev implements
 *   ndo_xdp_xmit callback.
 * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports AF=
_XDP
 *   in zero copy mode.
 * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports XDP =
hw
 *   oflloading.
 * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-lin=
ear
 *   XDP buffer support in the driver napi callback.
 * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
 *   non-linear XDP buffer support in ndo_xdp_xmit callback.
 */
enum netdev_xdp_act {
        NETDEV_XDP_ACT_BASIC,
        NETDEV_XDP_ACT_REDIRECT,
        NETDEV_XDP_ACT_NDO_XMIT,
        NETDEV_XDP_ACT_XSK_ZEROCOPY,
        NETDEV_XDP_ACT_HW_OFFLOAD,
        NETDEV_XDP_ACT_RX_SG,
        NETDEV_XDP_ACT_NDO_XMIT_SG,
};

Regards,
Lorenzo

>=20
> I've also talked to the iproute2-py maintainer about generating
> documentation directly from YAML to Sphinx/htmldocs, hopefully=20
> that will happen, too. It would be good to have a few families=20
> to work with before we start that work, tho.

--qziEnyJPquu9LTl8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY88YQwAKCRA6cBh0uS2t
rEWoAP9E7+yhe6xzWNvVhGDtR0Vbhmo4cx8MtqrkRR1v7KgJDAD+Opg5Jj9EYfqC
SGFVAfjquj2QKYGMgbChLVyZs0yjUwk=
=FQIt
-----END PGP SIGNATURE-----

--qziEnyJPquu9LTl8--
