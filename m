Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB16F324A
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjEAOuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 10:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjEAOuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 10:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEED10FB;
        Mon,  1 May 2023 07:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7438E60A4B;
        Mon,  1 May 2023 14:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F709C433EF;
        Mon,  1 May 2023 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682952604;
        bh=Xxsx+44g+QaWfO+YO+cDgToNnZ+iX15tlyRcwDaMeJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQ8kBItrjCK/il7hOrOwHvr2qDMa7Lb1iqDw1VqAzN0sNfakYaYvGM68sFvZgSe93
         rnTrbzPrkcjxUzbbOx0CEB/EeqGsxWPAD4wc9mQVBnoNKK7M0TW4cp9sB1ev/fY0wa
         EHLitOGMzpVDDY9v+Kv2Wi3/WK4V/+QOmXgKWnhJK8KIhBFIbUWk+98RbLvjTkCECG
         Fiz0zSS+k7hXHmqcZpm0+IiEMc1EzArnedkCys8f3MsAyJL+eeIUt0yRCfivjll61V
         DjSLIkr6Uq/2Rhbu1CuT/+7IBq7sJEj/3hLHavnOEgPyF6e3sagCIwmkgM2N8P9P7j
         pzaj29LKyM4NQ==
Date:   Mon, 1 May 2023 16:50:00 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, andrii@kernel.org, mykolal@fb.com,
        ast@kernel.org, martin.lau@linux.dev, alardam@gmail.com,
        memxor@gmail.com, sdf@google.com, brouer@redhat.com,
        toke@redhat.com, Jussi Maki <joamaki@gmail.com>
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
Message-ID: <ZE/RmKJoR+CtaOmS@lore-desk>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
 <1260d53a-1a05-9615-5a39-4c38171285fd@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fWld63/A0/Lp7SdI"
Content-Disposition: inline
In-Reply-To: <1260d53a-1a05-9615-5a39-4c38171285fd@iogearbox.net>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fWld63/A0/Lp7SdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 4/30/23 12:02 PM, Lorenzo Bianconi wrote:
> > Introduce xdp_features support for bonding driver according to the slave
> > devices attached to the master one. xdp_features is required whenever we
> > want to xdp_redirect traffic into a bond device and then into selected
> > slaves attached to it.
> >=20
> > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Please also keep Jussi in Cc for bonding + XDP reviews [added here].

ack, will do

>=20
> > ---
> > Change since v1:
> > - remove bpf self-test patch from the series
>=20
> Given you targeted net tree, was this patch run against BPF CI locally fr=
om
> your side to avoid breakage again?

yes, I tested it locally and opening a PR upstream [0] (upstream xdp bonding
tests are fine but the PR fails, however the issue seems not related to the
code I added and the error is in common even with some previous pending PR).

Regards,
Lorenzo

[0] https://github.com/kernel-patches/bpf/pull/5021

>=20
> Thanks,
> Daniel
>=20
> > ---
> >   drivers/net/bonding/bond_main.c    | 48 ++++++++++++++++++++++++++++++
> >   drivers/net/bonding/bond_options.c |  2 ++
> >   include/net/bonding.h              |  1 +
> >   3 files changed, 51 insertions(+)
> >=20
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond=
_main.c
> > index 710548dbd0c1..c98121b426a4 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -1789,6 +1789,45 @@ static void bond_ether_setup(struct net_device *=
bond_dev)
> >   	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
> >   }
> > +void bond_xdp_set_features(struct net_device *bond_dev)
> > +{
> > +	struct bonding *bond =3D netdev_priv(bond_dev);
> > +	xdp_features_t val =3D NETDEV_XDP_ACT_MASK;
> > +	struct list_head *iter;
> > +	struct slave *slave;
> > +
> > +	ASSERT_RTNL();
> > +
> > +	if (!bond_xdp_check(bond)) {
> > +		xdp_clear_features_flag(bond_dev);
> > +		return;
> > +	}
> > +
> > +	bond_for_each_slave(bond, slave, iter) {
> > +		struct net_device *dev =3D slave->dev;
> > +
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
> > +			xdp_clear_features_flag(bond_dev);
> > +			return;
> > +		}
> > +
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
> > +			val &=3D ~NETDEV_XDP_ACT_REDIRECT;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
> > +			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
> > +			val &=3D ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
> > +			val &=3D ~NETDEV_XDP_ACT_HW_OFFLOAD;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
> > +			val &=3D ~NETDEV_XDP_ACT_RX_SG;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
> > +			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT_SG;
> > +	}
> > +
> > +	xdp_set_features_flag(bond_dev, val);
> > +}
> > +
> >   /* enslave device <slave> to bond device <master> */
> >   int bond_enslave(struct net_device *bond_dev, struct net_device *slav=
e_dev,
> >   		 struct netlink_ext_ack *extack)
> > @@ -2236,6 +2275,8 @@ int bond_enslave(struct net_device *bond_dev, str=
uct net_device *slave_dev,
> >   			bpf_prog_inc(bond->xdp_prog);
> >   	}
> > +	bond_xdp_set_features(bond_dev);
> > +
> >   	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s l=
ink\n",
> >   		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
> >   		   new_slave->link !=3D BOND_LINK_DOWN ? "an up" : "a down");
> > @@ -2483,6 +2524,7 @@ static int __bond_release_one(struct net_device *=
bond_dev,
> >   	if (!netif_is_bond_master(slave_dev))
> >   		slave_dev->priv_flags &=3D ~IFF_BONDING;
> > +	bond_xdp_set_features(bond_dev);
> >   	kobject_put(&slave->kobj);
> >   	return 0;
> > @@ -3930,6 +3972,9 @@ static int bond_slave_netdev_event(unsigned long =
event,
> >   		/* Propagate to master device */
> >   		call_netdevice_notifiers(event, slave->bond->dev);
> >   		break;
> > +	case NETDEV_XDP_FEAT_CHANGE:
> > +		bond_xdp_set_features(bond_dev);
> > +		break;
> >   	default:
> >   		break;
> >   	}
> > @@ -5874,6 +5919,9 @@ void bond_setup(struct net_device *bond_dev)
> >   	if (BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP)
> >   		bond_dev->features |=3D BOND_XFRM_FEATURES;
> >   #endif /* CONFIG_XFRM_OFFLOAD */
> > +
> > +	if (bond_xdp_check(bond))
> > +		bond_dev->xdp_features =3D NETDEV_XDP_ACT_MASK;
> >   }
> >   /* Destroy a bonding device.
> > diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/b=
ond_options.c
> > index f71d5517f829..0498fc6731f8 100644
> > --- a/drivers/net/bonding/bond_options.c
> > +++ b/drivers/net/bonding/bond_options.c
> > @@ -877,6 +877,8 @@ static int bond_option_mode_set(struct bonding *bon=
d,
> >   			netdev_update_features(bond->dev);
> >   	}
> > +	bond_xdp_set_features(bond->dev);
> > +
> >   	return 0;
> >   }
> > diff --git a/include/net/bonding.h b/include/net/bonding.h
> > index c3843239517d..a60a24923b55 100644
> > --- a/include/net/bonding.h
> > +++ b/include/net/bonding.h
> > @@ -659,6 +659,7 @@ void bond_destroy_sysfs(struct bond_net *net);
> >   void bond_prepare_sysfs_group(struct bonding *bond);
> >   int bond_sysfs_slave_add(struct slave *slave);
> >   void bond_sysfs_slave_del(struct slave *slave);
> > +void bond_xdp_set_features(struct net_device *bond_dev);
> >   int bond_enslave(struct net_device *bond_dev, struct net_device *slav=
e_dev,
> >   		 struct netlink_ext_ack *extack);
> >   int bond_release(struct net_device *bond_dev, struct net_device *slav=
e_dev);
> >=20
>=20

--fWld63/A0/Lp7SdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZE/RmAAKCRA6cBh0uS2t
rE01AQCcD38V37gBx0Qlc/wqZqlgwd9JSZo5eD0KH90NtsoJ4wD9GZVaYIbm3/xa
ASOmK0ysX8wi1Kj74rXgUfy6lexfFws=
=BbyX
-----END PGP SIGNATURE-----

--fWld63/A0/Lp7SdI--
