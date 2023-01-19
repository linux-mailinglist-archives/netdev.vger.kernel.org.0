Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60135674AC8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjATEgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjATEfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:35:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F5CAED9D;
        Thu, 19 Jan 2023 20:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B80BB82491;
        Thu, 19 Jan 2023 14:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C19C433EF;
        Thu, 19 Jan 2023 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674138215;
        bh=jF//NUpq1HN0b0Ns8y/1mrIp01dJ2M8KP6bnPkFL0Pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QP5CbJkXPMLvndjLQvNjPZre9nwiEdaj8L8gv34aK3Otf9uzVr3hRZ07gRufUbIEY
         agchRoYYSlcIUq9G5scJxX0rzXcs/lFAWB3cp/Oj62rwhVMjo/HpOYmCEl2EwvUFB7
         KKevnkP85UC19IYIzAsWLig0fWUz/ZTU4LW0ysYU28O0JTjUu9Lc0nezYpX3KAijfx
         a8NA9sFCnvv4kaFoFAD8qhrlaGfx4tuBdLwZB6UzDu2FDYfm2E/EMO0MNPwyuyvYO4
         WVUwASBd+0RyvrOBxsX5H56Lovom6n7fsFtYcUrrzqORTaNrvdzXwZJfkDVl+lvklp
         7fOk1h5EobDWQ==
Date:   Thu, 19 Jan 2023 15:23:31 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     sdf@google.com
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
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <Y8lSY2rfx5woNJOu@lore-desk>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8hW8IqJTa0zE2aS@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DGAPQT9oFXfrtSAg"
Content-Disposition: inline
In-Reply-To: <Y8hW8IqJTa0zE2aS@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DGAPQT9oFXfrtSAg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 01/14, Lorenzo Bianconi wrote:
> > From: Marek Majtyka <alardam@gmail.com>
>=20

[...]

>=20
> Maybe stupid question: why do we need WRITE_ONCE here?
> And if we do need it, do we need READ_ONCE as well?
>=20
> WRITE_ONCE(*xdp_features, READ_ONCE(*xdp_features) | flags);

This part is from the Marek's original series. I will let him to comment on=
 it.

>=20
> ?
>=20
> Also, would it make sense to drop this __xdp_features_set_redirect_target
> and just define the following:
>=20
> static inline void
> xdp_features_set_redirect_target(xdp_features_t *xdp_features, bool
> support_sg)
> {
> 	xdp_features_t flags =3D NETDEV_XDP_ACT_NDO_XMIT;
>=20
> 	if (support_sg)
> 		flags |=3D NETDEV_XDP_ACT_NDO_XMIT_SG;
> 	*xdp_features |=3D flags; /* or WRITE_ONCE */
> }
>=20
> This should avoid having two different sets of functions. Or does it
> look worse because of that 'naked' true/false argument in the call
> sites?

I did this way because we will mainly run it with support_sg set to false,
but I do not have a strong opinion on it, I am fine both ways. I will fix i=
t.

Regards,
Lorenzo

>=20
>=20
> > +}
> > +
> > +static inline void
> > +xdp_features_clear_redirect_target(xdp_features_t *xdp_features)
> > +{
> > +	WRITE_ONCE(*xdp_features,
> > +		   *xdp_features & ~(NETDEV_XDP_ACT_NDO_XMIT |
> > +				     NETDEV_XDP_ACT_NDO_XMIT_SG));
> > +}
> > +
> > +#else
> > +
> > +static inline void
> > +__xdp_features_set_redirect_target(xdp_features_t *xdp_features, u32
> > flags)
> > +{
> > +}
> > +
> > +static inline void
> > +xdp_features_clear_redirect_target(xdp_features_t *xdp_features)
> > +{
> > +}
> > +
> > +#endif
> > +
> > +static inline void
> > +xdp_features_set_redirect_target(xdp_features_t *xdp_features)
> > +{
> > +	__xdp_features_set_redirect_target(xdp_features,
> > +					   NETDEV_XDP_ACT_NDO_XMIT |
> > +					   NETDEV_XDP_ACT_NDO_XMIT_SG);
> > +}
> > +
> >   #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
>=20
> >   #endif /* __LINUX_NET_XDP_H__ */
> > --
> > 2.39.0
>=20

--DGAPQT9oFXfrtSAg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8lSYwAKCRA6cBh0uS2t
rJtrAPwK/+nlrw98yKOdg+WYuzD06o+yaCcuTx3jjb6lFn3v+wEA6kHNa8gGGDXU
RHgliiOFhY71LPPYr2/wItwtHw9/3Ak=
=s5kN
-----END PGP SIGNATURE-----

--DGAPQT9oFXfrtSAg--
