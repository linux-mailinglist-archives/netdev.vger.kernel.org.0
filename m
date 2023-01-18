Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA5A671903
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjARKf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjARKcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:32:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D746BFF4C;
        Wed, 18 Jan 2023 01:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 648296174A;
        Wed, 18 Jan 2023 09:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A854C433F0;
        Wed, 18 Jan 2023 09:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674034729;
        bh=Wp7SIfyM1gO8OrC9XajKRdbO1OmnZftFUcrZn5tA//M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oyDTDalpqxaonpaJBV8oor4IuPzbrf2AdRuvJ1KPaGcugs0fU5jJJEV7/Hob5wec1
         IOsWwltDfvPl4XGHckz02xs3iDFj0fr71qDZM8RixGS2IRZJUegZAPRBkygWX3+tBL
         1+0BFNk931x0kUpjLWJ5VBFAW3Lf9yUhb8CL2g4GDD91FLuVvEpmmKDLbYHSXVEdiH
         YHEY1Oem7zXy+sgKuiReFABUTZkIeZb7uvpYDXOYnl9JMQb+jHXrqzAlxVK575Qwc7
         Gu9kNoQiCKb7Zzgvjs4QC9OgRnOdL/mkZca9nNsEHFbpjFWCyNZFEKix1FNrid0Kv5
         eiTNeD5ssTYzQ==
Date:   Wed, 18 Jan 2023 10:38:45 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
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
Message-ID: <Y8e+JVtrEqtZemF3@lore-desk>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
 <Y8czKD8/yXywbl+f@lore-desk>
 <Y8ey7Sg3BcPfsU9d@sleipner.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hD3us42baC0rGwVf"
Content-Disposition: inline
In-Reply-To: <Y8ey7Sg3BcPfsU9d@sleipner.dyn.berto.se>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hD3us42baC0rGwVf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> On 2023-01-18 00:45:44 +0100, Lorenzo Bianconi wrote:
> > > Hi Lorenzo and Marek,
> > >=20
> > > Thanks for your work.
> > >=20
> > > On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:
> > >=20
> > > [...]
> > >=20
> > > >=20
> > > > Turn 'hw-offload' feature flag on for:
> > > >  - netronome (nfp)
> > > >  - netdevsim.
> > >=20
> > > Is there a definition of the 'hw-offload' written down somewhere? Fro=
m=20
> > > reading this series I take it is the ability to offload a BPF program=
? =20
> >=20
> > correct
> >=20
> > > It would also be interesting to read documentation for the other flag=
s=20
> > > added in this series.
> >=20
> > maybe we can add definitions in Documentation/netlink/specs/netdev.yaml?
> >=20
> > >=20
> > > [...]
> > >=20
> > > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c=20
> > > > b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > > index 18fc9971f1c8..5a8ddeaff74d 100644
> > > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > > @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_=
net *nn)
> > > >  	netdev->features &=3D ~NETIF_F_HW_VLAN_STAG_RX;
> > > >  	nn->dp.ctrl &=3D ~NFP_NET_CFG_CTRL_RXQINQ;
> > > > =20
> > > > +	nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
> > > > +				      NETDEV_XDP_ACT_HW_OFFLOAD;
> > >=20
> > > If my assumption about the 'hw-offload' flag above is correct I think=
=20
> > > NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmw=
are=20
> > > flavor is in use.
> > >=20
> > >     nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC;
> > >=20
> > >     if (nn->app->type->id =3D=3D NFP_APP_BPF_NIC)
> > >         nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_HW_OFFLOAD;
> >=20
> > ack, I will fix it.
>=20
> Thanks. I have just been informed from Yinjun Zhang that this check is=20
> not enough as this function is reused for VF where nn->app is not set. I=
=20
> think a better check would be
>=20
>     if (nn->app && nn->app->type->id =3D=3D NFP_APP_BPF_NIC)
>=20
> Yinjun also informed me that you can make this code a bit neater by,
>=20
>     s/nn->dp.netdev->xdp_features/netdev->xdp_features/
>=20
> Thanks again for your work.

ack thx Niklas, I will fix it.

Regards,
Lorenzo

>=20
> >=20
> > >=20
> > > > +
> > > >  	/* Finalise the netdev setup */
> > > >  	switch (nn->dp.ops->version) {
> > > >  	case NFP_NFD_VER_NFD3:
> > > >  		netdev->netdev_ops =3D &nfp_nfd3_netdev_ops;
> > > > +		nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > > >  		break;
> > > >  	case NFP_NFD_VER_NFDK:
> > > >  		netdev->netdev_ops =3D &nfp_nfdk_netdev_ops;
> > >=20
> > > This is also a wrinkle I would like to understand. Currently NFP supp=
ort=20
> > > zero-copy on NFD3, but not for offloaded BPF programs. But with the B=
PF=20
> > > firmware flavor running the device can still support zero-copy for=20
> > > non-offloaded programs.
> > >=20
> > > Is it a problem that the driver advertises support for both=20
> > > hardware-offload _and_ zero-copy at the same time, even if they can't=
 be=20
> > > used together but separately?
> >=20
> > xdp_features should export NIC supported features in the current
> > configuration and it is expected they can be used concurrently.
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > --=20
> > > Kind Regards,
> > > Niklas S=F6derlund
>=20
>=20
>=20
> --=20
> Kind Regards,
> Niklas S=F6derlund

--hD3us42baC0rGwVf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8e+JQAKCRA6cBh0uS2t
rNsWAP9IWlqhjMPf1TD9MZNwspDMNKBoSGgWXHpRq3zu+fJHDQD/aizWK7i8NwAJ
0Mw7uKi5IULG/hLknsC/LDOiVgt1pAI=
=/s9e
-----END PGP SIGNATURE-----

--hD3us42baC0rGwVf--
