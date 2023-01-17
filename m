Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82107670E95
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjARA0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjARAZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:25:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E62D10D2;
        Tue, 17 Jan 2023 15:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAAB561582;
        Tue, 17 Jan 2023 23:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76AFC433D2;
        Tue, 17 Jan 2023 23:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673999148;
        bh=/isgHAWViwVBgIFKVjs/C/z6ulRns3DI5YKLAnx/VSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FFSVm6hnYS7+aXKcCJ7GhRG6Qhdb9j8tkzbANLp+ULvVBo1lhALCbmo4OvZInbzgE
         WYiZG5nJvE5hYq+XDBsVtMp6eeFRP8vCPHuzwKDfQ936nJZ76mtyR6+xDBu9f0lNie
         ETYoHpsBZeGfs2geHaVIJzK+qaw+FRbOPUsGO1z6Cfs4J2Gavn+FsWDhZOSgQEsOZ9
         3OV/peuB3w9qTraxwoKYUw/w82WjrR3oQ/KV/fYC9pY3MPYSNZnLb5tX+HDnIsquIi
         Bncax33JsTc/kRlrHiDTqdlqxuNb7wEfkmh1ZIShvENZKxiy/yAphEV715PlCgvSMS
         eQi7l9TTTkWvg==
Date:   Wed, 18 Jan 2023 00:45:44 +0100
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
Message-ID: <Y8czKD8/yXywbl+f@lore-desk>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Uje9DHp9XZ6F6Ayi"
Content-Disposition: inline
In-Reply-To: <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Uje9DHp9XZ6F6Ayi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo and Marek,
>=20
> Thanks for your work.
>=20
> On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:
>=20
> [...]
>=20
> >=20
> > Turn 'hw-offload' feature flag on for:
> >  - netronome (nfp)
> >  - netdevsim.
>=20
> Is there a definition of the 'hw-offload' written down somewhere? From=20
> reading this series I take it is the ability to offload a BPF program? =
=20

correct

> It would also be interesting to read documentation for the other flags=20
> added in this series.

maybe we can add definitions in Documentation/netlink/specs/netdev.yaml?

>=20
> [...]
>=20
> > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c=20
> > b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > index 18fc9971f1c8..5a8ddeaff74d 100644
> > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_net =
*nn)
> >  	netdev->features &=3D ~NETIF_F_HW_VLAN_STAG_RX;
> >  	nn->dp.ctrl &=3D ~NFP_NET_CFG_CTRL_RXQINQ;
> > =20
> > +	nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
> > +				      NETDEV_XDP_ACT_HW_OFFLOAD;
>=20
> If my assumption about the 'hw-offload' flag above is correct I think=20
> NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmware=
=20
> flavor is in use.
>=20
>     nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC;
>=20
>     if (nn->app->type->id =3D=3D NFP_APP_BPF_NIC)
>         nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_HW_OFFLOAD;

ack, I will fix it.

>=20
> > +
> >  	/* Finalise the netdev setup */
> >  	switch (nn->dp.ops->version) {
> >  	case NFP_NFD_VER_NFD3:
> >  		netdev->netdev_ops =3D &nfp_nfd3_netdev_ops;
> > +		nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_XSK_ZEROCOPY;
> >  		break;
> >  	case NFP_NFD_VER_NFDK:
> >  		netdev->netdev_ops =3D &nfp_nfdk_netdev_ops;
>=20
> This is also a wrinkle I would like to understand. Currently NFP support=
=20
> zero-copy on NFD3, but not for offloaded BPF programs. But with the BPF=
=20
> firmware flavor running the device can still support zero-copy for=20
> non-offloaded programs.
>=20
> Is it a problem that the driver advertises support for both=20
> hardware-offload _and_ zero-copy at the same time, even if they can't be=
=20
> used together but separately?

xdp_features should export NIC supported features in the current
configuration and it is expected they can be used concurrently.

Regards,
Lorenzo

>=20
> --=20
> Kind Regards,
> Niklas S=F6derlund

--Uje9DHp9XZ6F6Ayi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8czKAAKCRA6cBh0uS2t
rLC/AP4pKRhBqfnI57ccjG64UDZk7/3FQsd+XwPmAo4AmLieEgEAgi5h5wtcUwPr
+43wVYoWmaUlSUvAqHKqt3R3OBdYQwY=
=C3/L
-----END PGP SIGNATURE-----

--Uje9DHp9XZ6F6Ayi--
