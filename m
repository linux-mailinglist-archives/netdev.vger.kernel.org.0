Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203C76F45DA
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjEBOOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbjEBOOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:14:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D521B5;
        Tue,  2 May 2023 07:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0A966242A;
        Tue,  2 May 2023 14:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C37C433D2;
        Tue,  2 May 2023 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683036884;
        bh=SFFzJZVdI5uOuvwv0ZaqpmR4yNxDgh7Pewux0LCaph0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SdqLkxw7ftT7G+Qmjai/y4/IRm2q7eLtGR5AmexFzShipE+lA3gYowHg90w85hkp6
         6YMREyDOnSm58wTLUqf1Z5w38JHLqskPiyj98y75d5tlFA14zWP0oX0xxlo8MsWBTh
         hLPE5gA/2zKppMcFWpSxhf14XrO0kTXOVkvX4PkCJsWeaCKmydSzejfFU0hDTDBkMM
         xfM1M4PgsSYPO8hrD1EhA4V2gKMQY/NB+oHqvjT4D5S8ySmgAkAL/iTk6xUYLx78oH
         3atgJXaJBwt48kn9LGZoR4Nkfgg1nvd+lRZVmHC3v2QEgYCziC6P72JdhMCgeKeSn8
         bTtXau0PE64Dg==
Date:   Tue, 2 May 2023 16:14:40 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
        mykolal@fb.com, ast@kernel.org, martin.lau@linux.dev,
        alardam@gmail.com, memxor@gmail.com, sdf@google.com,
        brouer@redhat.com, toke@redhat.com, Jussi Maki <joamaki@gmail.com>
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
Message-ID: <ZFEa0DfUbOZToXVi@lore-desk>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
 <1260d53a-1a05-9615-5a39-4c38171285fd@iogearbox.net>
 <5a1c7de53daaa6180b207ff42d1736f50b5d90b9.camel@redhat.com>
 <ZFDbBmdgCDSvYZgG@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yrdTt4i0lg3ViV6E"
Content-Disposition: inline
In-Reply-To: <ZFDbBmdgCDSvYZgG@lore-desk>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrdTt4i0lg3ViV6E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > On Mon, 2023-05-01 at 15:33 +0200, Daniel Borkmann wrote:
> > > On 4/30/23 12:02 PM, Lorenzo Bianconi wrote:
> > > > Introduce xdp_features support for bonding driver according to the =
slave
> > > > devices attached to the master one. xdp_features is required whenev=
er we
> > > > want to xdp_redirect traffic into a bond device and then into selec=
ted
> > > > slaves attached to it.
> > > >=20
> > > > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > >=20
> > > Please also keep Jussi in Cc for bonding + XDP reviews [added here].
> >=20
> > Perhaps worth adding such info to the maintainer file for future
> > memory?
> >=20
> > > > ---
> > > > Change since v1:
> > > > - remove bpf self-test patch from the series
> > >=20
> > > Given you targeted net tree, was this patch run against BPF CI locall=
y from
> > > your side to avoid breakage again?
> > >=20
> > > Thanks,
> > > Daniel
> > >=20
> > > > ---
> > > >   drivers/net/bonding/bond_main.c    | 48 +++++++++++++++++++++++++=
+++++
> > > >   drivers/net/bonding/bond_options.c |  2 ++
> > > >   include/net/bonding.h              |  1 +
> > > >   3 files changed, 51 insertions(+)
> > > >=20
> > > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/=
bond_main.c
> > > > index 710548dbd0c1..c98121b426a4 100644
> > > > --- a/drivers/net/bonding/bond_main.c
> > > > +++ b/drivers/net/bonding/bond_main.c
> > > > @@ -1789,6 +1789,45 @@ static void bond_ether_setup(struct net_devi=
ce *bond_dev)
> > > >   	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
> > > >   }
> > > >  =20
> > > > +void bond_xdp_set_features(struct net_device *bond_dev)
> > > > +{
> > > > +	struct bonding *bond =3D netdev_priv(bond_dev);
> > > > +	xdp_features_t val =3D NETDEV_XDP_ACT_MASK;
> > > > +	struct list_head *iter;
> > > > +	struct slave *slave;
> > > > +
> > > > +	ASSERT_RTNL();
> > > > +
> > > > +	if (!bond_xdp_check(bond)) {
> > > > +		xdp_clear_features_flag(bond_dev);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	bond_for_each_slave(bond, slave, iter) {
> > > > +		struct net_device *dev =3D slave->dev;
> > > > +
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
> > > > +			xdp_clear_features_flag(bond_dev);
> > > > +			return;
> > > > +		}
> > > > +
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
> > > > +			val &=3D ~NETDEV_XDP_ACT_REDIRECT;
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
> > > > +			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT;
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
> > > > +			val &=3D ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
> > > > +			val &=3D ~NETDEV_XDP_ACT_HW_OFFLOAD;
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
> > > > +			val &=3D ~NETDEV_XDP_ACT_RX_SG;
> > > > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
> > > > +			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT_SG;
> >=20
> > Can we expect NETDEV_XDP_ACT_MASK changing in the future (e.g. new
> > features to be added)? If so the above code will break silently, as the
> > new features will be unconditionally enabled. What about adding a
> > BUILD_BUG() to catch such situation?=20
>=20
> I used NETDEV_XDP_ACT_MASK here in order to enable all the XDP features w=
hen
> we do not have any slave device attache to the bond one. If we add a new
> feature to netdev_xdp_act in the future I would say it is fine we inherit=
 it
> here otherwise we will need to explicitly add it.
>=20
> Regards,
> Lorenzo

Looking again at the code we can generalize it a bit taking into account ev=
en
new features added in the future, something like:

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index c98121b426a4..9c9f25c8f9bc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1805,24 +1805,18 @@ void bond_xdp_set_features(struct net_device *bond_=
dev)
=20
 	bond_for_each_slave(bond, slave, iter) {
 		struct net_device *dev =3D slave->dev;
+		int f;
=20
 		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
 			xdp_clear_features_flag(bond_dev);
 			return;
 		}
=20
-		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
-			val &=3D ~NETDEV_XDP_ACT_REDIRECT;
-		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
-			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT;
-		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
-			val &=3D ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
-		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
-			val &=3D ~NETDEV_XDP_ACT_HW_OFFLOAD;
-		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
-			val &=3D ~NETDEV_XDP_ACT_RX_SG;
-		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
-			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT_SG;
+		for (f =3D NETDEV_XDP_ACT_REDIRECT; f < NETDEV_XDP_ACT_MASK;
+		     f <<=3D 1) {
+			if (!(dev->xdp_features & f))
+				val &=3D ~f;
+		}
 	}
=20
 	xdp_set_features_flag(bond_dev, val);

Regards,
Lorenzo

>=20
> >=20
> > >=20
> > Cheers,
> >=20
> > Paolo
> >=20



--yrdTt4i0lg3ViV6E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZFEa0AAKCRA6cBh0uS2t
rDd4AQC8yDZ93AZtatHTmPBppuR/8RnIUH7la7kZR2V/d8SXsQD/VoRR6YYa7ppD
ywNNnJoNw9D4dpi6L7ISn3QNzgYJUg8=
=Iq6F
-----END PGP SIGNATURE-----

--yrdTt4i0lg3ViV6E--
