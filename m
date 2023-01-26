Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0DE67D819
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 23:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjAZWAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 17:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjAZWAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 17:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0254F73773;
        Thu, 26 Jan 2023 14:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D22BB81F29;
        Thu, 26 Jan 2023 22:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE06C433D2;
        Thu, 26 Jan 2023 22:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674770417;
        bh=mG3PIraFDoP2NR/mGww1RDWi7EAzYTplzCN246slWDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khERF1GxXIngu4mAhc/cQRMghNSkohz9N2rYq8SBOuiAS5r1em1yMmDOGtDK4GGG9
         /gxYH8f+YF2biApjK5+AhIKTEpJ1o1Lh40qQYVVPh79QBULrfTmyomUHn022V5bF/h
         IDcP2U5onKr5ux7dT5JQYKlMv26xt4yFzthbEZkZ/wJ8xt+Tqx5NVDN8DTvgMPmcP7
         Zs9YPPn8aStUk0NizoSpu9xCaTLZIsXX5sBGCI5Jy6WzwQY3jvtXh9jEzeniGXxORw
         7GEbwoePVmFNVk3aJkdEu39VChzUzzpi3eCsWGh/LSAahafnAoSbbx3HOXFqyd5a3L
         3ixe/EFUg6VoQ==
Date:   Thu, 26 Jan 2023 23:00:13 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
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
Subject: Re: [PATCH v2 bpf-next 2/8] drivers: net: turn on XDP features
Message-ID: <Y9L37bVacFMYdqVv@lore-desk>
References: <cover.1674606193.git.lorenzo@kernel.org>
 <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
 <28eedfd5-4444-112b-bfbc-1c7682385c88@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wgPVbgvG3x7so8fA"
Content-Disposition: inline
In-Reply-To: <28eedfd5-4444-112b-bfbc-1c7682385c88@engleder-embedded.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wgPVbgvG3x7so8fA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 25.01.23 01:33, Lorenzo Bianconi wrote:
> > From: Marek Majtyka <alardam@gmail.com>
> >=20
> > A summary of the flags being set for various drivers is given below.
> > Note that XDP_F_REDIRECT_TARGET and XDP_F_FRAG_TARGET are features
> > that can be turned off and on at runtime. This means that these flags
> > may be set and unset under RTNL lock protection by the driver. Hence,
> > READ_ONCE must be used by code loading the flag value.
> >=20
> > Also, these flags are not used for synchronization against the availabi=
lity
> > of XDP resources on a device. It is merely a hint, and hence the read
> > may race with the actual teardown of XDP resources on the device. This
> > may change in the future, e.g. operations taking a reference on the XDP
> > resources of the driver, and in turn inhibiting turning off this flag.
> > However, for now, it can only be used as a hint to check whether device
> > supports becoming a redirection target.
> >=20
> > Turn 'hw-offload' feature flag on for:
> >   - netronome (nfp)
> >   - netdevsim.
> >=20
> > Turn 'native' and 'zerocopy' features flags on for:
> >   - intel (i40e, ice, ixgbe, igc)
> >   - mellanox (mlx5).
> >   - stmmac
> >=20
> > Turn 'native' features flags on for:
> >   - amazon (ena)
> >   - broadcom (bnxt)
> >   - freescale (dpaa, dpaa2, enetc)
> >   - funeth
> >   - intel (igb)
> >   - marvell (mvneta, mvpp2, octeontx2)
> >   - mellanox (mlx4)
> >   - qlogic (qede)
> >   - sfc
> >   - socionext (netsec)
> >   - ti (cpsw)
> >   - tap
> >   - veth
> >   - xen
> >   - virtio_net.
> >=20
> > Turn 'basic' (tx, pass, aborted and drop) features flags on for:
> >   - netronome (nfp)
> >   - cavium (thunder)
> >   - hyperv.
> >=20
> > Turn 'redirect_target' feature flag on for:
> >   - amanzon (ena)
> >   - broadcom (bnxt)
> >   - freescale (dpaa, dpaa2)
> >   - intel (i40e, ice, igb, ixgbe)
> >   - ti (cpsw)
> >   - marvell (mvneta, mvpp2)
> >   - sfc
> >   - socionext (netsec)
> >   - qlogic (qede)
> >   - mellanox (mlx5)
> >   - tap
> >   - veth
> >   - virtio_net
> >   - xen
>=20
> XDP support for tsnep was merged to net-next last week. So this driver
> cannot get XDP feature support in bpf-next as it is not there currently.
> Should I add these flags with a fix afterwards? Or would net-next be the
> better target for this patch series?

It is better to target this series to bpf-next I guess since there are some
libbpf and bpf changes.
I would say we can fix tsnep with a follow-up patch or I can add it to the
series if bpf-next will be rebased before the series is merged, it depends =
on
the upstream discussion.

Regards,
Lorenzo

>=20
> Gerhard

--wgPVbgvG3x7so8fA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9L37QAKCRA6cBh0uS2t
rH69AQChogm+pILXQ5apmdID9EOinCFNzrdmsYfWKZTkNX3DHAD9FLa+koGMdvfi
Sra3pIlrfq3pfEJtrDxxK+cbpWGBfgE=
=Pvrl
-----END PGP SIGNATURE-----

--wgPVbgvG3x7so8fA--
