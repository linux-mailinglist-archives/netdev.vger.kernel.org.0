Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908AF670E82
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjARATL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjARAS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:18:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF5351C49;
        Tue, 17 Jan 2023 15:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C97A161582;
        Tue, 17 Jan 2023 23:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EA8C433D2;
        Tue, 17 Jan 2023 23:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673998445;
        bh=vjs3q6bsR2pHna86wjXL8AslohMK3OxlyjG1u0ig/WU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VgIiFuTCNXnCX6fPe7+/H4pRIJ54Ca3A52w6NrBUO1F/sene+fEmSdqhi6Xqim3Bx
         Pb1KAdlRy1HIEEZ/zvvcSFT4Lv9JG07Sw7NwCu2NxRCcf0qWUFJ5q2T2fEicfM1eU3
         m8rpPHg9UJxVTw54J6wsjOJQthBaoK6MK9eIYMEBBz9o1G9YYKdeTI+eTOexvwsSPh
         0WI61ygRV7Mx/l8j7f37wVoLkLDaB292KEQgUu+kLZj+iXpokOddr5evzIV+7kVVRv
         imm+k/gB+6TZ3fGsyefTSbwXTJwN2XpR2veX5FMtqVH5/mAmorWJV6kpSX4qZ5QKWG
         j2vXhiJEkXZfQ==
Date:   Wed, 18 Jan 2023 00:34:01 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Yonghong Song <yhs@meta.com>
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
Subject: Re: [RFC v2 bpf-next 3/7] xsk: add usage of XDP features flags
Message-ID: <Y8cwaVPDG/CN/JsU@lore-desk>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <36956338853442e6d546687678a93470a164ff17.1673710867.git.lorenzo@kernel.org>
 <5e20044c-6057-e5c7-624b-a1373c30fc12@meta.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vPJhlgCQKsEzlrAt"
Content-Disposition: inline
In-Reply-To: <5e20044c-6057-e5c7-624b-a1373c30fc12@meta.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vPJhlgCQKsEzlrAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 1/14/23 7:54 AM, Lorenzo Bianconi wrote:
> > From: Marek Majtyka <alardam@gmail.com>
> >=20
> > Change necessary condition check for XSK from ndo functions to
> > xdp features flags.
> >=20
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   net/xdp/xsk_buff_pool.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index ed6c71826d31..2e6fa082142a 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -178,8 +178,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
> >   		/* For copy-mode, we are done. */
> >   		return 0;
> > -	if (!netdev->netdev_ops->ndo_bpf ||
> > -	    !netdev->netdev_ops->ndo_xsk_wakeup) {
> > +	if ((netdev->xdp_features & NETDEV_XDP_ACT_ZC) !=3D NETDEV_XDP_ACT_ZC=
) {
>=20
> Maybe:
> 	if (!(netdev->xdp_features & NETDEV_XDP_ACT_ZC))

I would say it not equivalent since:

NETDEV_XDP_ACT_ZC =3D 0x5f

and we want the device supports all the ZC requested features. Agree?

Regards,
Lorenzo

> ?
>=20
> >   		err =3D -EOPNOTSUPP;
> >   		goto err_unreg_pool;
> >   	}

--vPJhlgCQKsEzlrAt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8cwaQAKCRA6cBh0uS2t
rBs3AQDXuAXS4DxM+X4Q/ORhsZeogOkEybJCJEW6N92Bhiq0QgD/SO1ZZLKk4NXg
n9vkEm23Z5PvEqfYV4y/CMOMynatFg0=
=3buO
-----END PGP SIGNATURE-----

--vPJhlgCQKsEzlrAt--
