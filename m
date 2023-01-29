Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3B167FF49
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 14:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjA2NFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 08:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjA2NFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 08:05:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B201E5EA;
        Sun, 29 Jan 2023 05:05:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B5B860D2F;
        Sun, 29 Jan 2023 13:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDFFC433D2;
        Sun, 29 Jan 2023 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674997511;
        bh=YRnCFG8ntf0bBC/MtPuhGtlsw+ZD+Y1feXB+ZAguOFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pM7mbhS46Zc3vsSb/cRYRpSBpu4zsXFLTKZKoi2W9W8Gn1mIszVsY3goULoFTBdsL
         6N7rc9XSk4HmChaH+vMU5CV8tWptrMWwNKzc/fklambxb7qw0KSOA20MjTIwmbBUFD
         oWhrrJqewgPnftnf8iSQVGr1o8U6saypScis+5Ryll0IjJEFexqbYhzhG4KjXdjPVr
         rfhVyjmo/z4Chd3f7VXs/+ZQqgWPIVnjQJO+/kXDdupYlDwig+GMIFY5veiNobNGkx
         88YpSDlIyIZTFbzEWtTNBY0pDEPIxzKptAN2zcX3lFcJ4MPxvSknnTUhv1Q8+iWtiM
         c8isIlzzXMAdg==
Date:   Sun, 29 Jan 2023 14:05:07 +0100
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
Message-ID: <Y9ZvA7+RMwbNlFoy@lore-desk>
References: <cover.1674606193.git.lorenzo@kernel.org>
 <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
 <28eedfd5-4444-112b-bfbc-1c7682385c88@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="U7/gIV1/sudiaFss"
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


--U7/gIV1/sudiaFss
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

bpf-next has been rebased on top of net-next so we can add tsnep support to=
 the
series. Do you think the patch below is fine?

Regards,
Lorenzo

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ether=
net/engleder/tsnep_main.c
index c3cf427a9409..6982aaa928b5 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1926,6 +1926,10 @@ static int tsnep_probe(struct platform_device *pdev)
 	netdev->features =3D NETIF_F_SG;
 	netdev->hw_features =3D netdev->features | NETIF_F_LOOPBACK;
=20
+	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			       NETDEV_XDP_ACT_NDO_XMIT |
+			       NETDEV_XDP_ACT_NDO_XMIT_SG;
+
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
=20
>=20
> Gerhard

--U7/gIV1/sudiaFss
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9ZvAwAKCRA6cBh0uS2t
rNw7AP0alud03ewTG9GBiClcWsJQ6C9O0dUGXriI2e1W5/22hAEAyOa3eNzEGfre
fkTdDTwpzezmuA3GUsyCVIEgbzhVrA0=
=Vws7
-----END PGP SIGNATURE-----

--U7/gIV1/sudiaFss--
