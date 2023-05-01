Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710CB6F316B
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjEANKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 09:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjEANKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 09:10:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8A3138;
        Mon,  1 May 2023 06:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1C7861B6F;
        Mon,  1 May 2023 13:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CEAC433D2;
        Mon,  1 May 2023 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682946603;
        bh=q2LOo8DZ9DzX1K6opUxUJKbSPw9UrShTgYCNc5S37L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TdduOyfNOkTCjAv14d3Lbf9w5DBNPd0/lgbyP4WSEG0XLE0j63VoCXtV6HRv7Z6lC
         OdXXjXNSaZdYRVUw+ukp0soq9TXfKZa/zJhNL53jRsaSrmX++uDC4dTYt0k5MoVOvf
         BRCmGT6SAH0ji9ORNqjd/c5p+H476wR3cczYOIJrVQGyxAhnAVA/31+HMZvfSgl5bs
         G3l2huYI66XslSaCxLVNJfX/Mzg3sTbbq1ClJgPMnrSFLJ/7laYDZ9LGDdwvcptHWT
         gLUz+qqqCzcMM1ftLUE3ArN2c9TXXv4azrxFJyn0N/NfSoeF/q7i/xi/bASMWaUJGu
         BwcdAkeW5y5mQ==
Date:   Mon, 1 May 2023 15:09:58 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, alardam@gmail.com,
        memxor@gmail.com, sdf@google.com, brouer@redhat.com,
        toke@redhat.com
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
Message-ID: <ZE+6JvsLC/n3TfQA@lore-desk>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
 <95779.1682945812@vermin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aZYSzkC+IhWowyJX"
Content-Disposition: inline
In-Reply-To: <95779.1682945812@vermin>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aZYSzkC+IhWowyJX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> >Introduce xdp_features support for bonding driver according to the slave
> >devices attached to the master one. xdp_features is required whenever we
> >want to xdp_redirect traffic into a bond device and then into selected
> >slaves attached to it.
> >
> >Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> >Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> 	The patch looks ok to me, but the description sounds more like
> feature enablement rather than a bug fix as the "Fixes:" tag and net
> tree suggest.
>=20
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Hi Jay,

I think it is a fix because otherwise XDP_REDIRECT into a bond device
is failing and the feature is already in Linus's tree.

Regards,
Lorenzo

>=20
> 	-J
>=20
> >---
> >Change since v1:
> >- remove bpf self-test patch from the series
> >---
> > drivers/net/bonding/bond_main.c    | 48 ++++++++++++++++++++++++++++++
> > drivers/net/bonding/bond_options.c |  2 ++
> > include/net/bonding.h              |  1 +
> > 3 files changed, 51 insertions(+)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_=
main.c
> >index 710548dbd0c1..c98121b426a4 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -1789,6 +1789,45 @@ static void bond_ether_setup(struct net_device *b=
ond_dev)
> > 	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
> > }
> >=20
> >+void bond_xdp_set_features(struct net_device *bond_dev)
> >+{
> >+	struct bonding *bond =3D netdev_priv(bond_dev);
> >+	xdp_features_t val =3D NETDEV_XDP_ACT_MASK;
> >+	struct list_head *iter;
> >+	struct slave *slave;
> >+
> >+	ASSERT_RTNL();
> >+
> >+	if (!bond_xdp_check(bond)) {
> >+		xdp_clear_features_flag(bond_dev);
> >+		return;
> >+	}
> >+
> >+	bond_for_each_slave(bond, slave, iter) {
> >+		struct net_device *dev =3D slave->dev;
> >+
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
> >+			xdp_clear_features_flag(bond_dev);
> >+			return;
> >+		}
> >+
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
> >+			val &=3D ~NETDEV_XDP_ACT_REDIRECT;
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
> >+			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT;
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
> >+			val &=3D ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
> >+			val &=3D ~NETDEV_XDP_ACT_HW_OFFLOAD;
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
> >+			val &=3D ~NETDEV_XDP_ACT_RX_SG;
> >+		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
> >+			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT_SG;
> >+	}
> >+
> >+	xdp_set_features_flag(bond_dev, val);
> >+}
> >+
> > /* enslave device <slave> to bond device <master> */
> > int bond_enslave(struct net_device *bond_dev, struct net_device *slave_=
dev,
> > 		 struct netlink_ext_ack *extack)
> >@@ -2236,6 +2275,8 @@ int bond_enslave(struct net_device *bond_dev, stru=
ct net_device *slave_dev,
> > 			bpf_prog_inc(bond->xdp_prog);
> > 	}
> >=20
> >+	bond_xdp_set_features(bond_dev);
> >+
> > 	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s lin=
k\n",
> > 		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
> > 		   new_slave->link !=3D BOND_LINK_DOWN ? "an up" : "a down");
> >@@ -2483,6 +2524,7 @@ static int __bond_release_one(struct net_device *b=
ond_dev,
> > 	if (!netif_is_bond_master(slave_dev))
> > 		slave_dev->priv_flags &=3D ~IFF_BONDING;
> >=20
> >+	bond_xdp_set_features(bond_dev);
> > 	kobject_put(&slave->kobj);
> >=20
> > 	return 0;
> >@@ -3930,6 +3972,9 @@ static int bond_slave_netdev_event(unsigned long e=
vent,
> > 		/* Propagate to master device */
> > 		call_netdevice_notifiers(event, slave->bond->dev);
> > 		break;
> >+	case NETDEV_XDP_FEAT_CHANGE:
> >+		bond_xdp_set_features(bond_dev);
> >+		break;
> > 	default:
> > 		break;
> > 	}
> >@@ -5874,6 +5919,9 @@ void bond_setup(struct net_device *bond_dev)
> > 	if (BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP)
> > 		bond_dev->features |=3D BOND_XFRM_FEATURES;
> > #endif /* CONFIG_XFRM_OFFLOAD */
> >+
> >+	if (bond_xdp_check(bond))
> >+		bond_dev->xdp_features =3D NETDEV_XDP_ACT_MASK;
> > }
> >=20
> > /* Destroy a bonding device.
> >diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bo=
nd_options.c
> >index f71d5517f829..0498fc6731f8 100644
> >--- a/drivers/net/bonding/bond_options.c
> >+++ b/drivers/net/bonding/bond_options.c
> >@@ -877,6 +877,8 @@ static int bond_option_mode_set(struct bonding *bond,
> > 			netdev_update_features(bond->dev);
> > 	}
> >=20
> >+	bond_xdp_set_features(bond->dev);
> >+
> > 	return 0;
> > }
> >=20
> >diff --git a/include/net/bonding.h b/include/net/bonding.h
> >index c3843239517d..a60a24923b55 100644
> >--- a/include/net/bonding.h
> >+++ b/include/net/bonding.h
> >@@ -659,6 +659,7 @@ void bond_destroy_sysfs(struct bond_net *net);
> > void bond_prepare_sysfs_group(struct bonding *bond);
> > int bond_sysfs_slave_add(struct slave *slave);
> > void bond_sysfs_slave_del(struct slave *slave);
> >+void bond_xdp_set_features(struct net_device *bond_dev);
> > int bond_enslave(struct net_device *bond_dev, struct net_device *slave_=
dev,
> > 		 struct netlink_ext_ack *extack);
> > int bond_release(struct net_device *bond_dev, struct net_device *slave_=
dev);
> >--=20
> >2.40.0
>=20
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

--aZYSzkC+IhWowyJX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZE+6JgAKCRA6cBh0uS2t
rCmDAP0YWdd3vbHbl+csot+5Jm0snxLyVoTDst1/Y324Ff769QD+JtxmO6ksrwt4
9ypI9AL5rUk2JlfdZIv3W8829cnajQA=
=5EAL
-----END PGP SIGNATURE-----

--aZYSzkC+IhWowyJX--
