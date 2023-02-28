Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F081E6A622E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjB1WMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjB1WMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:12:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FD21A3F;
        Tue, 28 Feb 2023 14:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B841611E4;
        Tue, 28 Feb 2023 22:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21AFC433EF;
        Tue, 28 Feb 2023 22:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677622319;
        bh=Ko8B2Ke9vuu9enxqAJfFgtkV4iIhtcxQhPpeZO6LJZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B49WSNmZNSoOAYuuji8BrzI2neC5SBuPf8A2Ey5Rt6OaxZQ5rgwSNCIqHEuf/iIqv
         7J6AE4mqsVAawMdBgL4w2jYG6DsENOwSUbruH30cCVvrH68BdOKz1TWdbDMj62pKJH
         WPCHlZ752a9J31MGt6wmY45TMzHSLOtNQc3pMzpF/NnHixaNTedROFSeeZ5C4EUuLg
         /1N/FyFBbYgbrQYe/+iOYKNXVbKnZ2SRNEQCx0kcrpr/rFK3xCZ6dsq2nIvnEAe3Qi
         NzI42z8sGwUxepJ66pjcHUSb93T6LHfw/a/pd/XNhXKKAZ3JmFWnshE+cVlS3wBWgA
         kl0SBtr14etqA==
Date:   Tue, 28 Feb 2023 23:11:55 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        hawk@kernel.org, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev, sdf@google.com
Subject: Re: [PATCH v4 bpf-next 2/8] drivers: net: turn on XDP features
Message-ID: <Y/58Kzah/ERCYMGD@lore-desk>
References: <cover.1674913191.git.lorenzo@kernel.org>
 <948292cc7d72f2bc04b5973008ecf384f9296677.1674913191.git.lorenzo@kernel.org>
 <pj41zlcz5v1kkg.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2LGuPtBJE1KxgoLc"
Content-Disposition: inline
In-Reply-To: <pj41zlcz5v1kkg.fsf@u570694869fb251.ant.amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2LGuPtBJE1KxgoLc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > From: Marek Majtyka <alardam@gmail.com>
> >=20
> > ...
> >=20
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > index e8ad5ea31aff..d3999db7c6a2 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > @@ -597,7 +597,9 @@ static int ena_xdp_set(struct net_device *netdev,
> > struct netdev_bpf *bpf)
> >  				if (rc)
> >  					return rc;
> >  			}
> > +			xdp_features_set_redirect_target(netdev, false);
> >  		} else if (old_bpf_prog) {
> > + xdp_features_clear_redirect_target(netdev);
> >  			rc =3D  ena_destroy_and_free_all_xdp_queues(adapter);
> >  			if (rc)
> >  				return rc;
> > @@ -4103,6 +4105,8 @@ static void ena_set_conf_feat_params(struct
> > ena_adapter *adapter,
> >  	/* Set offload features */
> >  	ena_set_dev_offloads(feat, netdev);
> >   +	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
> > NETDEV_XDP_ACT_REDIRECT;
> > +
> >  	adapter->max_mtu =3D feat->dev_attr.max_mtu;
> >  	netdev->max_mtu =3D adapter->max_mtu;
> >  	netdev->min_mtu =3D ENA_MIN_MTU;
> >=20
>=20
> Hi, thanks for the time you put in adjusting the ENA driver as well.

Hi Shay,

>=20
> Why did you set NETDEV_XDP_ACT_NDO_XMIT dynamically for some drivers (like
> ENA and mlx5) and statically for others (like atlantic driver which also
> redirects packets only when XDP program is loaded) ?
> Is it only for the sake of notifying the user that an XDP program has been
> loaded ?

there are some drivers (e.g. mvneta) where NETDEV_XDP_ACT_NDO_XMIT is always
supported while there are other drivers (e.g. intel drivers) where it
depends on other configurations (e.g. if the driver needs to reserve
some queues for xdp).

Regards,
Lorenzo

>=20
> Thanks,
> Shay
>=20
> > ...
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index a5a7ecf6391c..82727b47259d 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -773,3 +773,21 @@ static int __init xdp_metadata_init(void)
> >  	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP,
> > &xdp_metadata_kfunc_set);
> >  }
> >  late_initcall(xdp_metadata_init);
> > +
> > +void xdp_features_set_redirect_target(struct net_device *dev, bool
> > support_sg)
> > +{
> > +	dev->xdp_features |=3D NETDEV_XDP_ACT_NDO_XMIT;
> > +	if (support_sg)
> > +		dev->xdp_features |=3D NETDEV_XDP_ACT_NDO_XMIT_SG;
> > +
> > +	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_features_set_redirect_target);
> > +
> > +void xdp_features_clear_redirect_target(struct net_device *dev)
> > +{
> > +	dev->xdp_features &=3D ~(NETDEV_XDP_ACT_NDO_XMIT |
> > +			       NETDEV_XDP_ACT_NDO_XMIT_SG);
> > +	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_features_clear_redirect_target);
>=20

--2LGuPtBJE1KxgoLc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/58KwAKCRA6cBh0uS2t
rLKPAQDQyKfTANyIcDmS/mWg8vodAL3S9+fGnbTjTcIElAlHxwD9EWMFpLyzB8od
kMPPssGYZhGW38vxvWYGIyRAEAIMaAM=
=Y0Sa
-----END PGP SIGNATURE-----

--2LGuPtBJE1KxgoLc--
