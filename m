Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB82CE47A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgLDAcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgLDAcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:32:42 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A10DC061A4F;
        Thu,  3 Dec 2020 16:32:02 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CnDCn2BB5zQlRT;
        Fri,  4 Dec 2020 01:31:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1607041891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lU6imtD55u/pDJ6N7h+Eks+7m79KdnO2IrLRSxISA2U=;
        b=OiMoZN79Twu5OaiBrakaIhX/HjqqN+sJIqvyI454trnK2tPgn7tfbxqLQ7D1DXcu2I6Vni
        I9QNI0t23XpbfZKbggU4LHr906xzucuun0of0MRSejXhyX19qRcXIaxRPjBUzxZSWEzkIb
        p9royYlwrYveaNkMqBZoO2dzkSoc17zDlZzGoA4t/zf7+863w1aUSXSdl6AaxIQA1CiE3C
        3IJ78HI5DfV57PGuYlDw98uqRadK9kQGMiffagdYNmEyUkyEzAXTsgYfIvqKmtxOnQqvFx
        74tG42pOoCHIH6d9qddM9h+RZ2yuECyiUhBq5sAeN37EL5jhDJzT7uizWiHz5Q==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id optUOlzHfIIc; Fri,  4 Dec 2020 01:31:29 +0100 (CET)
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
References: <20201203220347.13691-1-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300
 and xRX330
Message-ID: <a453631e-cd05-74e1-7318-53c25de45bf1@hauke-m.de>
Date:   Fri, 4 Dec 2020 01:31:12 +0100
MIME-Version: 1.0
In-Reply-To: <20201203220347.13691-1-olek2@wp.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ouhSTEVzUycfcgh2tsU6iVjPjYqhrPBnB"
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -6.46 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4897B1832
X-Rspamd-UID: 6fa7d2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ouhSTEVzUycfcgh2tsU6iVjPjYqhrPBnB
Content-Type: multipart/mixed; boundary="efFc3RZRLgNvpyhUhZkhEoD6QyfUi8ya6";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: Aleksander Jan Bajkowski <olek2@wp.pl>, andrew@lunn.ch,
 vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
Message-ID: <a453631e-cd05-74e1-7318-53c25de45bf1@hauke-m.de>
Subject: Re: [PATCH 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300
 and xRX330
References: <20201203220347.13691-1-olek2@wp.pl>
In-Reply-To: <20201203220347.13691-1-olek2@wp.pl>

--efFc3RZRLgNvpyhUhZkhEoD6QyfUi8ya6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

This looks good.

I haven't checked all the differences between the SoCs, but found some=20
minor problems in the code for the port configuration.


On 12/3/20 11:03 PM, Aleksander Jan Bajkowski wrote:
> From: Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
>=20
> This patch allows you to use all phs on GRX300 and GRX330. The ARX300 h=
as 3
> and the GRX330 has 4 integrated PHYs connected to different ports compa=
red
> to VRX200.
>=20
> Port configurations:
>=20
> xRX200:
> GMAC0: RGMII port
> GMAC1: RGMII port
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
>=20
> xRX300:
> GMAC0: RGMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
>=20
> xRX330:
> GMAC0: RGMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY3 (GMII)
GMAC3: GPHY3 (GMII) or GPHY0 (MII)
This can be changed in GSWIP_MII_CFG3 (0xc3)

> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port

You also have to change gswip_mii_mask_cfg() it only supports port 0, 1=20
and 5, but this SoC can not change port 1 (always connected to internal=20
GPHY, but it can change port 3 (change between GPHY0/MII/0x0 and=20
PHY3/GMII/0x1)

>=20
> Tested on D-Link DWR966 with OpenWRT.
>=20
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>   drivers/net/dsa/lantiq_gswip.c | 110 +++++++++++++++++++++++++++++++-=
-
>   1 file changed, 104 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gs=
wip.c
> index 09701c17f3f6..540cf99ad7fe 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -222,6 +222,7 @@
>   struct gswip_hw_info {
>   	int max_ports;
>   	int cpu_port;
> +	struct dsa_switch_ops *ops;
>   };
>  =20
>   struct xway_gphy_match_data {
> @@ -1409,9 +1410,9 @@ static int gswip_port_fdb_dump(struct dsa_switch =
*ds, int port,
>   	return 0;
>   }
>  =20
> -static void gswip_phylink_validate(struct dsa_switch *ds, int port,
> -				   unsigned long *supported,
> -				   struct phylink_link_state *state)
> +static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int p=
ort,
> +					  unsigned long *supported,
> +					  struct phylink_link_state *state)
>   {
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
>  =20
> @@ -1471,7 +1472,70 @@ static void gswip_phylink_validate(struct dsa_sw=
itch *ds, int port,
>   	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>   	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
>   		phy_modes(state->interface), port);
> +}
> +
> +static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int p=
ort,
> +					  unsigned long *supported,
> +					  struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> +
> +	switch (port) {
> +	case 0:
> +		if (!phy_interface_mode_is_rgmii(state->interface) &&
> +		    state->interface !=3D PHY_INTERFACE_MODE_MII &

MII is not support on port 0

> +		    state->interface !=3D PHY_INTERFACE_MODE_REVMII &&

REVMII is not support on port 0

> +		    state->interface !=3D PHY_INTERFACE_MODE_RMII)

GMII is now supported with 0x9

> +			goto unsupported;
> +		break;
> +	case 1:
> +	case 2:
> +	case 3:
> +	case 4:
> +		if (state->interface !=3D PHY_INTERFACE_MODE_INTERNAL)
> +			goto unsupported;
> +		break;
> +	case 5:
> +		if (!phy_interface_mode_is_rgmii(state->interface) &&
> +		    state->interface !=3D PHY_INTERFACE_MODE_INTERNAL)
> +			goto unsupported;
port 5 also supports RMIIM with bit 0x3 on xrx300 and xrx330

> +		break;
> +	default:
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> +		return;
> +	}
> +
> +	/* Allow all the expected bits */
> +	phylink_set(mask, Autoneg);
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	/* With the exclusion of MII and Reverse MII, we support Gigabit,
> +	 * including Half duplex
> +	 */
> +	if (state->interface !=3D PHY_INTERFACE_MODE_MII &&
> +	    state->interface !=3D PHY_INTERFACE_MODE_REVMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseT_Half);
> +	}
> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
You can put this block into a common function it is also used the the=20
xrx200  validate block.

>   	return;
> +
> +unsupported:
> +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
> +		phy_modes(state->interface), port);
>   }
>  =20
>   static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,=

> @@ -1614,7 +1678,7 @@ static int gswip_get_sset_count(struct dsa_switch=
 *ds, int port, int sset)
>   	return ARRAY_SIZE(gswip_rmon_cnt);
>   }
>  =20
> -static const struct dsa_switch_ops gswip_switch_ops =3D {
> +static const struct dsa_switch_ops gswip_xrx200_switch_ops =3D {
>   	.get_tag_protocol	=3D gswip_get_tag_protocol,
>   	.setup			=3D gswip_setup,
>   	.port_enable		=3D gswip_port_enable,
> @@ -1630,7 +1694,32 @@ static const struct dsa_switch_ops gswip_switch_=
ops =3D {
>   	.port_fdb_add		=3D gswip_port_fdb_add,
>   	.port_fdb_del		=3D gswip_port_fdb_del,
>   	.port_fdb_dump		=3D gswip_port_fdb_dump,
> -	.phylink_validate	=3D gswip_phylink_validate,
> +	.phylink_validate	=3D gswip_xrx200_phylink_validate,
> +	.phylink_mac_config	=3D gswip_phylink_mac_config,
> +	.phylink_mac_link_down	=3D gswip_phylink_mac_link_down,
> +	.phylink_mac_link_up	=3D gswip_phylink_mac_link_up,
> +	.get_strings		=3D gswip_get_strings,
> +	.get_ethtool_stats	=3D gswip_get_ethtool_stats,
> +	.get_sset_count		=3D gswip_get_sset_count,
> +};
> +
> +static const struct dsa_switch_ops gswip_xrx300_switch_ops =3D {
> +	.get_tag_protocol	=3D gswip_get_tag_protocol,
> +	.setup			=3D gswip_setup,
> +	.port_enable		=3D gswip_port_enable,
> +	.port_disable		=3D gswip_port_disable,
> +	.port_bridge_join	=3D gswip_port_bridge_join,
> +	.port_bridge_leave	=3D gswip_port_bridge_leave,
> +	.port_fast_age		=3D gswip_port_fast_age,
> +	.port_vlan_filtering	=3D gswip_port_vlan_filtering,
> +	.port_vlan_prepare	=3D gswip_port_vlan_prepare,
> +	.port_vlan_add		=3D gswip_port_vlan_add,
> +	.port_vlan_del		=3D gswip_port_vlan_del,
> +	.port_stp_state_set	=3D gswip_port_stp_state_set,
> +	.port_fdb_add		=3D gswip_port_fdb_add,
> +	.port_fdb_del		=3D gswip_port_fdb_del,
> +	.port_fdb_dump		=3D gswip_port_fdb_dump,
> +	.phylink_validate	=3D gswip_xrx300_phylink_validate,
>   	.phylink_mac_config	=3D gswip_phylink_mac_config,
>   	.phylink_mac_link_down	=3D gswip_phylink_mac_link_down,
>   	.phylink_mac_link_up	=3D gswip_phylink_mac_link_up,
> @@ -1892,7 +1981,7 @@ static int gswip_probe(struct platform_device *pd=
ev)
>   	priv->ds->dev =3D dev;
>   	priv->ds->num_ports =3D priv->hw_info->max_ports;
>   	priv->ds->priv =3D priv;
> -	priv->ds->ops =3D &gswip_switch_ops;
> +	priv->ds->ops =3D priv->hw_info->ops;
>   	priv->dev =3D dev;
>   	version =3D gswip_switch_r(priv, GSWIP_VERSION);
>  =20
> @@ -1973,10 +2062,19 @@ static int gswip_remove(struct platform_device =
*pdev)
>   static const struct gswip_hw_info gswip_xrx200 =3D {
>   	.max_ports =3D 7,
>   	.cpu_port =3D 6,
> +	.ops =3D &gswip_xrx200_switch_ops,
> +};
> +
> +static const struct gswip_hw_info gswip_xrx300 =3D {
> +	.max_ports =3D 7,
> +	.cpu_port =3D 6,
> +	.ops =3D &gswip_xrx300_switch_ops,
>   };
>  =20
>   static const struct of_device_id gswip_of_match[] =3D {
>   	{ .compatible =3D "lantiq,xrx200-gswip", .data =3D &gswip_xrx200 },
> +	{ .compatible =3D "lantiq,xrx300-gswip", .data =3D &gswip_xrx300 },
> +	{ .compatible =3D "lantiq,xrx330-gswip", .data =3D &gswip_xrx300 },
>   	{},
>   };
>   MODULE_DEVICE_TABLE(of, gswip_of_match);
>=20



--efFc3RZRLgNvpyhUhZkhEoD6QyfUi8ya6--

--ouhSTEVzUycfcgh2tsU6iVjPjYqhrPBnB
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl/Jg1EACgkQ8bdnhZyy
68ekvAf2K5LfY+I578nkEv8j5FcU0D1Oa9BjqaxFyHZN6vc5igHIYa0P/pyXm74p
NlKVls2pJfhKEHZb1uWygzi7EkXEzdam1E2+Rt/AU/hy1sLkoYdaf+8tt7YpZqE8
b74aJ0tkHVOEyWKj7cz+8zriT3i1nWPo2g9vaE3wawqz2UZA9PiS2Sb/cbt4VGsm
Q0/rxS9L1KMnGQL9LIt1qOkMa08ZrkUVo1GdPhuCBjIiZoliuj/jcX1iQ96V5bJD
qTxU6yU6+/0rKZ/tdoA3q9KAyVvm0OCuIx9suMnY43MoVg6tILNCSwHT8+CRcV0E
nFI4VA7ZMdyqGUH3Kv+jPApSvthx
=ePf4
-----END PGP SIGNATURE-----

--ouhSTEVzUycfcgh2tsU6iVjPjYqhrPBnB--
