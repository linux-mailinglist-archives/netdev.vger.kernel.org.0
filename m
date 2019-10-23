Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1977DE1CF2
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405962AbfJWNj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:39:58 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:55622
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391615AbfJWNj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 09:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cs6pmjCoV/REcDQXHqmD7W075iQqYV05NGDAzFgkmxV7lbKKkyGxbNChoTn4yycMiw6QxYetO3Vb0iyuv5WXn8ZQHmkyKI4TN1eSy+MuC/hQXqE+O/HC67TX4gAtVDvdtOHyvVn2tS78rcBOA08cZslq4ELXL8Yuegv/qi+WZh5GtW9OYkcXzlhep1tfbx5Tj0P4HeW0qgAc8E4oBZ+TmcxgmZegeI5C2YlJWrhGYoUuimV6Jh2LQuJs2hp5mmkJA2OlSVZiRQT6lYll1z3prDq/yeQvhuy+rLvQLHwYykiS7zOR7aCZKOk5gAGRT4yh+v8V3bU7by1ELIVn82PSQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZJBJpb/Vrp3wpI4jZ490YkycFD39uJrh1RocIhLbPA=;
 b=FM+s4/3H5ocuJUDRahXxPnv45sHLvs3H2LpgDYf/sHZbeF4YuVuubXKKtDm4RqyqNOuye3JWWSFUjQ148wfUC0EDM0AgjvSMqrBW2EDfmxbnNRFhVF6ftARZPP0C++WOaOu4+1yTe9+Y67v/Fngb8AfOzbfy1fvKaiI/EGOuT8xcDfRTFQoBXdIWZPFUQkqwF6XZ8lBTd3BTua7qCnmWpvLl9tW/myIHCVjII3slRqmfJCX48duz/wXaUBNNN33Z0ab2D+cM/4KiuG4Pho60qnN4AAFz0tA9aVmhxWkZqd4OgXBI1NN2bbICm7vv/NMthoSamOSmbcBeb7v1uRULIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZJBJpb/Vrp3wpI4jZ490YkycFD39uJrh1RocIhLbPA=;
 b=ST6Pjkp4HA7tVOWU9kLKlpTtv0HAy7tPBPCcE/77IZ5TcLIMkkpWKGHr2NRUzGVV6q/A1P8UcosjjF5R7pP91h/32b6cFDcrEg7+GphrFrDMPXZXeBw16LZvLqpOsNtEPlGzxkrzUNXvR7e/hzHziUu8LaWvj+d1P1zTSt+Ks00=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2893.eurprd04.prod.outlook.com (10.175.25.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 13:39:47 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.025; Wed, 23 Oct
 2019 13:39:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Topic: [PATCH net-next v2 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Index: AQHViaAGQDTLcKZjAkqD4DCGkX3wAQ==
Date:   Wed, 23 Oct 2019 13:39:46 +0000
Message-ID: <VI1PR0402MB280016EEF9BCC6F7113B7A4DE06B0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571834829-29560-1-git-send-email-ioana.ciornei@nxp.com>
 <1571834829-29560-5-git-send-email-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.124.196.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5707a3f8-dd68-4bed-48c0-08d757be7857
x-ms-traffictypediagnostic: VI1PR0402MB2893:|VI1PR0402MB2893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2893A497584F15213D867FF8E06B0@VI1PR0402MB2893.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(199004)(189003)(81156014)(305945005)(54906003)(74316002)(66446008)(66556008)(110136005)(4326008)(6436002)(316002)(64756008)(66476007)(76116006)(66066001)(66946007)(30864003)(478600001)(486006)(229853002)(446003)(25786009)(26005)(6246003)(9686003)(55016002)(52536014)(476003)(102836004)(99286004)(6116002)(3846002)(6506007)(53546011)(76176011)(71190400001)(86362001)(81166006)(186003)(5660300002)(14454004)(256004)(8936002)(2906002)(44832011)(7736002)(14444005)(8676002)(7696005)(33656002)(2501003)(5024004)(71200400001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2893;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zoP1HylDYW6FPhE5R4GxXA2fhvmX9s2dIr0ZBSdm4g2MGjrbpIFCwlLsXQY6KpsDjBtzbiTKtgxHXtqYFOvueuXvOm+Y7RQlpJ1U5+dC7pxE0U/sUnSBlJfhPHKJxskXryDVUXVTPd9hapVgvcscgGgGbTm32hD0c/5qfk1pLWeAuS4Ov6B5Bcnv5Rx2IFc+DxgFv7M00OVh4lpos3H+evBE6qX0u3nSPHF82J/VhXxIsRLdITK5L4A5zSrOoKD1J8S63v93KHp12ja5XZxyy+zW6q2g6DLBh/BvjiDjZ307gbWKEyizqCNPIusf2YQs4BrmDHQBfTZ5QZL2K/rF8i7W8ezEjvm9PKBZYxgkoQKfakgbQ2vL23UMjlLbabi5T2/7Ti2No/u/xWzAItI+ktVS3zYiMqa/bAYfJAEZU9awJGTO3/tkuGPsSQYqwMer
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5707a3f8-dd68-4bed-48c0-08d757be7857
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 13:39:46.8614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bb+oIbnX0nr4hNs/uJej5yGHwg27vryf3WFoNDoMsz4qwt/3ChIY5zdmiijoTqpuE0eU/JXlNKPpBO1Xv5sF3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2893
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/19 3:47 PM, Ioana Ciornei wrote:=0A=
> The dpaa2-eth driver now has support for connecting to its associated=0A=
> PHY device found through standard OF bindings.=0A=
> =0A=
> This happens when the DPNI object (that the driver probes on) gets=0A=
> connected to a DPMAC. When that happens, the device tree is looked up by=
=0A=
> the DPMAC ID, and the associated PHY bindings are found.=0A=
> =0A=
> The old logic of handling the net device's link state by hand still=0A=
> needs to be kept, as the DPNI can be connected to other devices on the=0A=
> bus than a DPMAC: other DPNI, DPSW ports, etc. This logic is only=0A=
> engaged when there is no DPMAC (and therefore no phylink instance)=0A=
> attached.=0A=
> =0A=
> The MC firmware support multiple type of DPMAC links: TYPE_FIXED,=0A=
> TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC management from=
=0A=
> Linux side, and as such, the driver will not handle such a DPMAC.=0A=
> =0A=
> Although PHYLINK typically handles SFP cages and in-band AN modes, for=0A=
> the moment the driver only supports the RGMII interfaces found on the=0A=
> LX2160A. Support for other modes will come later.=0A=
=0A=
I unfortunately left a compile warning slip in this patch.=0A=
I'll send out a v3 once I can bundle it with any other changes.=0A=
=0A=
Sorry for this,=0A=
Ioana=0A=
=0A=
> =0A=
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
> ---=0A=
> Changes in v2:=0A=
>   - move the locks to rtnl outside of dpaa2_eth_[dis]connect_mac function=
s=0A=
>   - remove setting supported/advertised from .validate()=0A=
> =0A=
>   MAINTAINERS                                        |   2 +=0A=
>   drivers/net/ethernet/freescale/dpaa2/Makefile      |   2 +-=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 117 ++++++--=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   3 +=0A=
>   .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  25 ++=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 302 ++++++++++++++=
+++++++=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |  32 +++=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   |  62 +++++=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 149 ++++++++++=0A=
>   drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 144 ++++++++++=0A=
>   10 files changed, 817 insertions(+), 21 deletions(-)=0A=
>   create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c=0A=
>   create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h=0A=
>   create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h=0A=
>   create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c=0A=
>   create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h=0A=
> =0A=
> diff --git a/MAINTAINERS b/MAINTAINERS=0A=
> index aaa6ee71c000..d0e562d3ce5b 100644=0A=
> --- a/MAINTAINERS=0A=
> +++ b/MAINTAINERS=0A=
> @@ -5046,7 +5046,9 @@ M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>=0A=
>   L:	netdev@vger.kernel.org=0A=
>   S:	Maintained=0A=
>   F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-eth*=0A=
> +F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*=0A=
>   F:	drivers/net/ethernet/freescale/dpaa2/dpni*=0A=
> +F:	drivers/net/ethernet/freescale/dpaa2/dpmac*=0A=
>   F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h=0A=
>   F:	drivers/net/ethernet/freescale/dpaa2/Makefile=0A=
>   F:	drivers/net/ethernet/freescale/dpaa2/Kconfig=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/=
ethernet/freescale/dpaa2/Makefile=0A=
> index d1e78cdd512f..69184ca3b7b9 100644=0A=
> --- a/drivers/net/ethernet/freescale/dpaa2/Makefile=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/Makefile=0A=
> @@ -6,7 +6,7 @@=0A=
>   obj-$(CONFIG_FSL_DPAA2_ETH)		+=3D fsl-dpaa2-eth.o=0A=
>   obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+=3D fsl-dpaa2-ptp.o=0A=
>   =0A=
> -fsl-dpaa2-eth-objs	:=3D dpaa2-eth.o dpaa2-ethtool.o dpni.o=0A=
> +fsl-dpaa2-eth-objs	:=3D dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o d=
pmac.o=0A=
>   fsl-dpaa2-eth-${CONFIG_DEBUG_FS} +=3D dpaa2-eth-debugfs.o=0A=
>   fsl-dpaa2-ptp-objs	:=3D dpaa2-ptp.o dprtc.o=0A=
>   =0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.c=0A=
> index 602d5118e928..35288a5d231d 100644=0A=
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c=0A=
> @@ -1,6 +1,6 @@=0A=
>   // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)=0A=
>   /* Copyright 2014-2016 Freescale Semiconductor Inc.=0A=
> - * Copyright 2016-2017 NXP=0A=
> + * Copyright 2016-2019 NXP=0A=
>    */=0A=
>   #include <linux/init.h>=0A=
>   #include <linux/module.h>=0A=
> @@ -1276,6 +1276,12 @@ static int link_state_update(struct dpaa2_eth_priv=
 *priv)=0A=
>   		   !!(state.options & DPNI_LINK_OPT_ASYM_PAUSE);=0A=
>   	dpaa2_eth_set_rx_taildrop(priv, !tx_pause);=0A=
>   =0A=
> +	/* When we manage the MAC/PHY using phylink there is no need=0A=
> +	 * to manually update the netif_carrier.=0A=
> +	 */=0A=
> +	if (priv->mac)=0A=
> +		goto out;=0A=
> +=0A=
>   	/* Chech link state; speed / duplex changes are not treated yet */=0A=
>   	if (priv->link_state.up =3D=3D state.up)=0A=
>   		goto out;=0A=
> @@ -1312,17 +1318,21 @@ static int dpaa2_eth_open(struct net_device *net_=
dev)=0A=
>   			   priv->dpbp_dev->obj_desc.id, priv->bpid);=0A=
>   	}=0A=
>   =0A=
> -	/* We'll only start the txqs when the link is actually ready; make sure=
=0A=
> -	 * we don't race against the link up notification, which may come=0A=
> -	 * immediately after dpni_enable();=0A=
> -	 */=0A=
> -	netif_tx_stop_all_queues(net_dev);=0A=
> +	if (!priv->mac) {=0A=
> +		/* We'll only start the txqs when the link is actually ready;=0A=
> +		 * make sure we don't race against the link up notification,=0A=
> +		 * which may come immediately after dpni_enable();=0A=
> +		 */=0A=
> +		netif_tx_stop_all_queues(net_dev);=0A=
> +=0A=
> +		/* Also, explicitly set carrier off, otherwise=0A=
> +		 * netif_carrier_ok() will return true and cause 'ip link show'=0A=
> +		 * to report the LOWER_UP flag, even though the link=0A=
> +		 * notification wasn't even received.=0A=
> +		 */=0A=
> +		netif_carrier_off(net_dev);=0A=
> +	}=0A=
>   	enable_ch_napi(priv);=0A=
> -	/* Also, explicitly set carrier off, otherwise netif_carrier_ok() will=
=0A=
> -	 * return true and cause 'ip link show' to report the LOWER_UP flag,=0A=
> -	 * even though the link notification wasn't even received.=0A=
> -	 */=0A=
> -	netif_carrier_off(net_dev);=0A=
>   =0A=
>   	err =3D dpni_enable(priv->mc_io, 0, priv->mc_token);=0A=
>   	if (err < 0) {=0A=
> @@ -1330,13 +1340,17 @@ static int dpaa2_eth_open(struct net_device *net_=
dev)=0A=
>   		goto enable_err;=0A=
>   	}=0A=
>   =0A=
> -	/* If the DPMAC object has already processed the link up interrupt,=0A=
> -	 * we have to learn the link state ourselves.=0A=
> -	 */=0A=
> -	err =3D link_state_update(priv);=0A=
> -	if (err < 0) {=0A=
> -		netdev_err(net_dev, "Can't update link state\n");=0A=
> -		goto link_state_err;=0A=
> +	if (!priv->mac) {=0A=
> +		/* If the DPMAC object has already processed the link up=0A=
> +		 * interrupt, we have to learn the link state ourselves.=0A=
> +		 */=0A=
> +		err =3D link_state_update(priv);=0A=
> +		if (err < 0) {=0A=
> +			netdev_err(net_dev, "Can't update link state\n");=0A=
> +			goto link_state_err;=0A=
> +		}=0A=
> +	} else {=0A=
> +		phylink_start(priv->mac->phylink);=0A=
>   	}=0A=
>   =0A=
>   	return 0;=0A=
> @@ -1411,8 +1425,12 @@ static int dpaa2_eth_stop(struct net_device *net_d=
ev)=0A=
>   	int dpni_enabled =3D 0;=0A=
>   	int retries =3D 10;=0A=
>   =0A=
> -	netif_tx_stop_all_queues(net_dev);=0A=
> -	netif_carrier_off(net_dev);=0A=
> +	if (!priv->mac) {=0A=
> +		netif_tx_stop_all_queues(net_dev);=0A=
> +		netif_carrier_off(net_dev);=0A=
> +	} else {=0A=
> +		phylink_stop(priv->mac->phylink);=0A=
> +	}=0A=
>   =0A=
>   	/* On dpni_disable(), the MC firmware will:=0A=
>   	 * - stop MAC Rx and wait for all Rx frames to be enqueued to software=
=0A=
> @@ -3342,12 +3360,56 @@ static int poll_link_state(void *arg)=0A=
>   	return 0;=0A=
>   }=0A=
>   =0A=
> +static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)=0A=
> +{=0A=
> +	struct fsl_mc_device *dpni_dev, *dpmac_dev;=0A=
> +	struct dpaa2_mac *mac;=0A=
> +	int err;=0A=
> +=0A=
> +	dpni_dev =3D to_fsl_mc_device(priv->net_dev->dev.parent);=0A=
> +	dpmac_dev =3D fsl_mc_get_endpoint(dpni_dev);=0A=
> +	if (!dpmac_dev || dpmac_dev->dev.type !=3D &fsl_mc_bus_dpmac_type)=0A=
> +		return 0;=0A=
> +=0A=
> +	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))=0A=
> +		return 0;=0A=
> +=0A=
> +	mac =3D kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);=0A=
> +	if (!mac)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	mac->mc_dev =3D dpmac_dev;=0A=
> +	mac->mc_io =3D priv->mc_io;=0A=
> +	mac->net_dev =3D priv->net_dev;=0A=
> +=0A=
> +	err =3D dpaa2_mac_connect(mac);=0A=
> +	if (err) {=0A=
> +		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");=
=0A=
> +		kfree(mac);=0A=
> +		return err;=0A=
> +	}=0A=
> +	priv->mac =3D mac;=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
> +static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)=0A=
> +{=0A=
> +	if (!priv->mac)=0A=
> +		return;=0A=
> +=0A=
> +	dpaa2_mac_disconnect(priv->mac);=0A=
> +	kfree(priv->mac);=0A=
> +	priv->mac =3D NULL;=0A=
> +}=0A=
> +=0A=
>   static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)=0A=
>   {=0A=
>   	u32 status =3D ~0;=0A=
>   	struct device *dev =3D (struct device *)arg;=0A=
>   	struct fsl_mc_device *dpni_dev =3D to_fsl_mc_device(dev);=0A=
>   	struct net_device *net_dev =3D dev_get_drvdata(dev);=0A=
> +	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);=0A=
>   	int err;=0A=
>   =0A=
>   	err =3D dpni_get_irq_status(dpni_dev->mc_io, 0, dpni_dev->mc_handle,=
=0A=
> @@ -3363,6 +3425,13 @@ static irqreturn_t dpni_irq0_handler_thread(int ir=
q_num, void *arg)=0A=
>   	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {=0A=
>   		set_mac_addr(netdev_priv(net_dev));=0A=
>   		update_tx_fqids(priv);=0A=
> +=0A=
> +		rtnl_lock();=0A=
> +		if (priv->mac)=0A=
> +			dpaa2_eth_disconnect_mac(priv);=0A=
> +		else=0A=
> +			dpaa2_eth_connect_mac(priv);=0A=
> +		rtnl_unlock();=0A=
>   	}=0A=
>   =0A=
>   	return IRQ_HANDLED;=0A=
> @@ -3539,6 +3608,10 @@ static int dpaa2_eth_probe(struct fsl_mc_device *d=
pni_dev)=0A=
>   		priv->do_link_poll =3D true;=0A=
>   	}=0A=
>   =0A=
> +	err =3D dpaa2_eth_connect_mac(priv);=0A=
> +	if (err)=0A=
> +		goto err_connect_mac;=0A=
> +=0A=
>   	err =3D register_netdev(net_dev);=0A=
>   	if (err < 0) {=0A=
>   		dev_err(dev, "register_netdev() failed\n");=0A=
> @@ -3553,6 +3626,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dp=
ni_dev)=0A=
>   	return 0;=0A=
>   =0A=
>   err_netdev_reg:=0A=
> +	dpaa2_eth_disconnect_mac(priv);=0A=
> +err_connect_mac:=0A=
>   	if (priv->do_link_poll)=0A=
>   		kthread_stop(priv->poll_thread);=0A=
>   	else=0A=
> @@ -3595,6 +3670,8 @@ static int dpaa2_eth_remove(struct fsl_mc_device *l=
s_dev)=0A=
>   #ifdef CONFIG_DEBUG_FS=0A=
>   	dpaa2_dbg_remove(priv);=0A=
>   #endif=0A=
> +	dpaa2_eth_disconnect_mac(priv);=0A=
> +=0A=
>   	unregister_netdev(net_dev);=0A=
>   =0A=
>   	if (priv->do_link_poll)=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.h=0A=
> index 686b651edcb2..7635db3ef903 100644=0A=
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h=0A=
> @@ -17,6 +17,7 @@=0A=
>   =0A=
>   #include "dpaa2-eth-trace.h"=0A=
>   #include "dpaa2-eth-debugfs.h"=0A=
> +#include "dpaa2-mac.h"=0A=
>   =0A=
>   #define DPAA2_WRIOP_VERSION(x, y, z) ((x) << 10 | (y) << 5 | (z) << 0)=
=0A=
>   =0A=
> @@ -415,6 +416,8 @@ struct dpaa2_eth_priv {=0A=
>   #ifdef CONFIG_DEBUG_FS=0A=
>   	struct dpaa2_debugfs dbg;=0A=
>   #endif=0A=
> +=0A=
> +	struct dpaa2_mac *mac;=0A=
>   };=0A=
>   =0A=
>   #define DPAA2_RXH_SUPPORTED	(RXH_L2DA | RXH_VLAN | RXH_L3_PROTO \=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drive=
rs/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c=0A=
> index dc9a6c36cac0..0883620631b8 100644=0A=
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c=0A=
> @@ -85,6 +85,10 @@ static void dpaa2_eth_get_drvinfo(struct net_device *n=
et_dev,=0A=
>   {=0A=
>   	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);=0A=
>   =0A=
> +	if (priv->mac)=0A=
> +		return phylink_ethtool_ksettings_get(priv->mac->phylink,=0A=
> +						     link_settings);=0A=
> +=0A=
>   	link_settings->base.autoneg =3D AUTONEG_DISABLE;=0A=
>   	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))=0A=
>   		link_settings->base.duplex =3D DUPLEX_FULL;=0A=
> @@ -93,12 +97,29 @@ static void dpaa2_eth_get_drvinfo(struct net_device *=
net_dev,=0A=
>   	return 0;=0A=
>   }=0A=
>   =0A=
> +static int=0A=
> +dpaa2_eth_set_link_ksettings(struct net_device *net_dev,=0A=
> +			     const struct ethtool_link_ksettings *link_settings)=0A=
> +{=0A=
> +	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);=0A=
> +=0A=
> +	if (!priv->mac)=0A=
> +		return -ENOTSUPP;=0A=
> +=0A=
> +	return phylink_ethtool_ksettings_set(priv->mac->phylink, link_settings)=
;=0A=
> +}=0A=
> +=0A=
>   static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,=0A=
>   				     struct ethtool_pauseparam *pause)=0A=
>   {=0A=
>   	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);=0A=
>   	u64 link_options =3D priv->link_state.options;=0A=
>   =0A=
> +	if (priv->mac) {=0A=
> +		phylink_ethtool_get_pauseparam(priv->mac->phylink, pause);=0A=
> +		return;=0A=
> +	}=0A=
> +=0A=
>   	pause->rx_pause =3D !!(link_options & DPNI_LINK_OPT_PAUSE);=0A=
>   	pause->tx_pause =3D pause->rx_pause ^=0A=
>   			  !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);=0A=
> @@ -118,6 +139,9 @@ static int dpaa2_eth_set_pauseparam(struct net_device=
 *net_dev,=0A=
>   		return -EOPNOTSUPP;=0A=
>   	}=0A=
>   =0A=
> +	if (priv->mac)=0A=
> +		return phylink_ethtool_set_pauseparam(priv->mac->phylink,=0A=
> +						      pause);=0A=
>   	if (pause->autoneg)=0A=
>   		return -EOPNOTSUPP;=0A=
>   =0A=
> @@ -728,6 +752,7 @@ static int dpaa2_eth_get_ts_info(struct net_device *d=
ev,=0A=
>   	.get_drvinfo =3D dpaa2_eth_get_drvinfo,=0A=
>   	.get_link =3D ethtool_op_get_link,=0A=
>   	.get_link_ksettings =3D dpaa2_eth_get_link_ksettings,=0A=
> +	.set_link_ksettings =3D dpaa2_eth_set_link_ksettings,=0A=
>   	.get_pauseparam =3D dpaa2_eth_get_pauseparam,=0A=
>   	.set_pauseparam =3D dpaa2_eth_set_pauseparam,=0A=
>   	.get_sset_count =3D dpaa2_eth_get_sset_count,=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c=0A=
> new file mode 100644=0A=
> index 000000000000..c4e9da845d44=0A=
> --- /dev/null=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c=0A=
> @@ -0,0 +1,302 @@=0A=
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)=0A=
> +/* Copyright 2019 NXP */=0A=
> +=0A=
> +#include "dpaa2-eth.h"=0A=
> +#include "dpaa2-mac.h"=0A=
> +=0A=
> +#define phylink_to_dpaa2_mac(config) \=0A=
> +	container_of((config), struct dpaa2_mac, phylink_config)=0A=
> +=0A=
> +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)=0A=
> +{=0A=
> +	switch (eth_if) {=0A=
> +	case DPMAC_ETH_IF_RGMII:=0A=
> +		return PHY_INTERFACE_MODE_RGMII;=0A=
> +	default:=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +}=0A=
> +=0A=
> +/* Caller must call of_node_put on the returned value */=0A=
> +static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)=0A=
> +{=0A=
> +	struct device_node *dpmacs, *dpmac =3D NULL;=0A=
> +	u32 id;=0A=
> +	int err;=0A=
> +=0A=
> +	dpmacs =3D of_find_node_by_name(NULL, "dpmacs");=0A=
> +	if (!dpmacs)=0A=
> +		return NULL;=0A=
> +=0A=
> +	while ((dpmac =3D of_get_next_child(dpmacs, dpmac)) !=3D NULL) {=0A=
> +		err =3D of_property_read_u32(dpmac, "reg", &id);=0A=
> +		if (err)=0A=
> +			continue;=0A=
> +		if (id =3D=3D dpmac_id)=0A=
> +			break;=0A=
> +	}=0A=
> +=0A=
> +	of_node_put(dpmacs);=0A=
> +=0A=
> +	return dpmac;=0A=
> +}=0A=
> +=0A=
> +static int dpaa2_mac_get_if_mode(struct device_node *node,=0A=
> +				 struct dpmac_attr attr)=0A=
> +{=0A=
> +	int if_mode;=0A=
> +=0A=
> +	if_mode =3D of_get_phy_mode(node);=0A=
> +	if (if_mode >=3D 0)=0A=
> +		return if_mode;=0A=
> +=0A=
> +	if_mode =3D phy_mode(attr.eth_if);=0A=
> +	if (if_mode >=3D 0)=0A=
> +		return if_mode;=0A=
> +=0A=
> +	return -ENODEV;=0A=
> +}=0A=
> +=0A=
> +static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,=0A=
> +					phy_interface_t interface)=0A=
> +{=0A=
> +	switch (interface) {=0A=
> +	case PHY_INTERFACE_MODE_RGMII:=0A=
> +	case PHY_INTERFACE_MODE_RGMII_ID:=0A=
> +	case PHY_INTERFACE_MODE_RGMII_RXID:=0A=
> +	case PHY_INTERFACE_MODE_RGMII_TXID:=0A=
> +		return (interface !=3D mac->if_mode);=0A=
> +	default:=0A=
> +		return true;=0A=
> +	}=0A=
> +}=0A=
> +=0A=
> +static void dpaa2_mac_validate(struct phylink_config *config,=0A=
> +			       unsigned long *supported,=0A=
> +			       struct phylink_link_state *state)=0A=
> +{=0A=
> +	struct dpaa2_mac *mac =3D phylink_to_dpaa2_mac(config);=0A=
> +	struct dpmac_link_state *dpmac_state =3D &mac->state;=0A=
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };=0A=
> +=0A=
> +	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&=0A=
> +	    dpaa2_mac_phy_mode_mismatch(mac, state->interface)) {=0A=
> +		goto empty_set;=0A=
> +	}=0A=
> +=0A=
> +	phylink_set_port_modes(mask);=0A=
> +	phylink_set(mask, Autoneg);=0A=
> +	phylink_set(mask, Pause);=0A=
> +	phylink_set(mask, Asym_Pause);=0A=
> +=0A=
> +	switch (state->interface) {=0A=
> +	case PHY_INTERFACE_MODE_RGMII:=0A=
> +	case PHY_INTERFACE_MODE_RGMII_ID:=0A=
> +	case PHY_INTERFACE_MODE_RGMII_RXID:=0A=
> +	case PHY_INTERFACE_MODE_RGMII_TXID:=0A=
> +		phylink_set(mask, 10baseT_Full);=0A=
> +		phylink_set(mask, 100baseT_Full);=0A=
> +		phylink_set(mask, 1000baseT_Full);=0A=
> +		break;=0A=
> +	default:=0A=
> +		goto empty_set;=0A=
> +	}=0A=
> +=0A=
> +	linkmode_and(supported, supported, mask);=0A=
> +	linkmode_and(state->advertising, state->advertising, mask);=0A=
> +=0A=
> +	return;=0A=
> +=0A=
> +empty_set:=0A=
> +	linkmode_zero(supported);=0A=
> +}=0A=
> +=0A=
> +static void dpaa2_mac_config(struct phylink_config *config, unsigned int=
 mode,=0A=
> +			     const struct phylink_link_state *state)=0A=
> +{=0A=
> +	struct dpaa2_mac *mac =3D phylink_to_dpaa2_mac(config);=0A=
> +	struct dpmac_link_state *dpmac_state =3D &mac->state;=0A=
> +	int err;=0A=
> +=0A=
> +	if (state->speed !=3D SPEED_UNKNOWN)=0A=
> +		dpmac_state->rate =3D state->speed;=0A=
> +=0A=
> +	if (state->duplex !=3D DUPLEX_UNKNOWN) {=0A=
> +		if (!state->duplex)=0A=
> +			dpmac_state->options |=3D DPMAC_LINK_OPT_HALF_DUPLEX;=0A=
> +		else=0A=
> +			dpmac_state->options &=3D ~DPMAC_LINK_OPT_HALF_DUPLEX;=0A=
> +	}=0A=
> +=0A=
> +	if (state->an_enabled)=0A=
> +		dpmac_state->options |=3D DPMAC_LINK_OPT_AUTONEG;=0A=
> +	else=0A=
> +		dpmac_state->options &=3D ~DPMAC_LINK_OPT_AUTONEG;=0A=
> +=0A=
> +	if (state->pause & MLO_PAUSE_RX)=0A=
> +		dpmac_state->options |=3D DPMAC_LINK_OPT_PAUSE;=0A=
> +	else=0A=
> +		dpmac_state->options &=3D ~DPMAC_LINK_OPT_PAUSE;=0A=
> +=0A=
> +	if (!!(state->pause & MLO_PAUSE_RX) ^ !!(state->pause & MLO_PAUSE_TX))=
=0A=
> +		dpmac_state->options |=3D DPMAC_LINK_OPT_ASYM_PAUSE;=0A=
> +	else=0A=
> +		dpmac_state->options &=3D ~DPMAC_LINK_OPT_ASYM_PAUSE;=0A=
> +=0A=
> +	err =3D dpmac_set_link_state(mac->mc_io, 0,=0A=
> +				   mac->mc_dev->mc_handle, dpmac_state);=0A=
> +	if (err)=0A=
> +		netdev_err(mac->net_dev, "dpmac_set_link_state() =3D %d\n", err);=0A=
> +}=0A=
> +=0A=
> +static void dpaa2_mac_link_up(struct phylink_config *config, unsigned in=
t mode,=0A=
> +			      phy_interface_t interface, struct phy_device *phy)=0A=
> +{=0A=
> +	struct dpaa2_mac *mac =3D phylink_to_dpaa2_mac(config);=0A=
> +	struct dpmac_link_state *dpmac_state =3D &mac->state;=0A=
> +	int err;=0A=
> +=0A=
> +	dpmac_state->up =3D 1;=0A=
> +	err =3D dpmac_set_link_state(mac->mc_io, 0,=0A=
> +				   mac->mc_dev->mc_handle, dpmac_state);=0A=
> +	if (err)=0A=
> +		netdev_err(mac->net_dev, "dpmac_set_link_state() =3D %d\n", err);=0A=
> +}=0A=
> +=0A=
> +static void dpaa2_mac_link_down(struct phylink_config *config,=0A=
> +				unsigned int mode,=0A=
> +				phy_interface_t interface)=0A=
> +{=0A=
> +	struct dpaa2_mac *mac =3D phylink_to_dpaa2_mac(config);=0A=
> +	struct dpmac_link_state *dpmac_state =3D &mac->state;=0A=
> +	int err;=0A=
> +=0A=
> +	dpmac_state->up =3D 0;=0A=
> +	err =3D dpmac_set_link_state(mac->mc_io, 0,=0A=
> +				   mac->mc_dev->mc_handle, dpmac_state);=0A=
> +	if (err)=0A=
> +		netdev_err(mac->net_dev, "dpmac_set_link_state() =3D %d\n", err);=0A=
> +}=0A=
> +=0A=
> +static const struct phylink_mac_ops dpaa2_mac_phylink_ops =3D {=0A=
> +	.validate =3D dpaa2_mac_validate,=0A=
> +	.mac_config =3D dpaa2_mac_config,=0A=
> +	.mac_link_up =3D dpaa2_mac_link_up,=0A=
> +	.mac_link_down =3D dpaa2_mac_link_down,=0A=
> +};=0A=
> +=0A=
> +bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,=0A=
> +			     struct fsl_mc_io *mc_io)=0A=
> +{=0A=
> +	struct dpmac_attr attr;=0A=
> +	bool fixed =3D false;=0A=
> +	u16 mc_handle =3D 0;=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D dpmac_open(mc_io, 0, dpmac_dev->obj_desc.id,=0A=
> +			 &mc_handle);=0A=
> +	if (err || !mc_handle)=0A=
> +		return false;=0A=
> +=0A=
> +	err =3D dpmac_get_attributes(mc_io, 0, mc_handle, &attr);=0A=
> +	if (err)=0A=
> +		goto out;=0A=
> +=0A=
> +	if (attr.link_type =3D=3D DPMAC_LINK_TYPE_FIXED)=0A=
> +		fixed =3D true;=0A=
> +=0A=
> +out:=0A=
> +	dpmac_close(mc_io, 0, mc_handle);=0A=
> +=0A=
> +	return fixed;=0A=
> +}=0A=
> +=0A=
> +int dpaa2_mac_connect(struct dpaa2_mac *mac)=0A=
> +{=0A=
> +	struct fsl_mc_device *dpmac_dev =3D mac->mc_dev;=0A=
> +	struct net_device *net_dev =3D mac->net_dev;=0A=
> +	struct device_node *dpmac_node;=0A=
> +	struct phylink *phylink;=0A=
> +	struct dpmac_attr attr;=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,=0A=
> +			 &dpmac_dev->mc_handle);=0A=
> +	if (err || !dpmac_dev->mc_handle) {=0A=
> +		netdev_err(net_dev, "dpmac_open() =3D %d\n", err);=0A=
> +		return -ENODEV;=0A=
> +	}=0A=
> +=0A=
> +	err =3D dpmac_get_attributes(mac->mc_io, 0, dpmac_dev->mc_handle, &attr=
);=0A=
> +	if (err) {=0A=
> +		netdev_err(net_dev, "dpmac_get_attributes() =3D %d\n", err);=0A=
> +		goto err_close_dpmac;=0A=
> +	}=0A=
> +=0A=
> +	dpmac_node =3D dpaa2_mac_get_node(attr.id);=0A=
> +	if (!dpmac_node) {=0A=
> +		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);=0A=
> +		err =3D -ENODEV;=0A=
> +		goto err_close_dpmac;=0A=
> +	}=0A=
> +=0A=
> +	err =3D dpaa2_mac_get_if_mode(dpmac_node, attr);=0A=
> +	if (err < 0) {=0A=
> +		err =3D -EINVAL;=0A=
> +		goto err_put_node;=0A=
> +	}=0A=
> +	mac->if_mode =3D err;=0A=
> +=0A=
> +	/* The MAC does not have the capability to add RGMII delays so=0A=
> +	 * error out if the interface mode requests them and there is no PHY=0A=
> +	 * to act upon them=0A=
> +	 */=0A=
> +	if (of_phy_is_fixed_link(dpmac_node) &&=0A=
> +	    (mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||=0A=
> +	     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||=0A=
> +	     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)) {=0A=
> +		netdev_err(net_dev, "RGMII delay not supported\n");=0A=
> +		err =3D -EINVAL;=0A=
> +		goto err_put_node;=0A=
> +	}=0A=
> +=0A=
> +	mac->phylink_config.dev =3D &net_dev->dev;=0A=
> +	mac->phylink_config.type =3D PHYLINK_NETDEV;=0A=
> +=0A=
> +	phylink =3D phylink_create(&mac->phylink_config,=0A=
> +				 of_fwnode_handle(dpmac_node), mac->if_mode,=0A=
> +				 &dpaa2_mac_phylink_ops);=0A=
> +	if (IS_ERR(phylink)) {=0A=
> +		err =3D PTR_ERR(phylink);=0A=
> +		goto err_put_node;=0A=
> +	}=0A=
> +	mac->phylink =3D phylink;=0A=
> +=0A=
> +	err =3D phylink_of_phy_connect(mac->phylink, dpmac_node, 0);=0A=
> +	if (err) {=0A=
> +		netdev_err(net_dev, "phylink_of_phy_connect() =3D %d\n", err);=0A=
> +		goto err_phylink_destroy;=0A=
> +	}=0A=
> +=0A=
> +	of_node_put(dpmac_node);=0A=
> +=0A=
> +	return 0;=0A=
> +=0A=
> +err_phylink_destroy:=0A=
> +	phylink_destroy(mac->phylink);=0A=
> +err_put_node:=0A=
> +	of_node_put(dpmac_node);=0A=
> +err_close_dpmac:=0A=
> +	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);=0A=
> +	return err;=0A=
> +}=0A=
> +=0A=
> +void dpaa2_mac_disconnect(struct dpaa2_mac *mac)=0A=
> +{=0A=
> +	if (!mac->phylink)=0A=
> +		return;=0A=
> +=0A=
> +	phylink_disconnect_phy(mac->phylink);=0A=
> +	phylink_destroy(mac->phylink);=0A=
> +	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);=0A=
> +}=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.h=0A=
> new file mode 100644=0A=
> index 000000000000..8634d0de7ef3=0A=
> --- /dev/null=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h=0A=
> @@ -0,0 +1,32 @@=0A=
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */=0A=
> +/* Copyright 2019 NXP */=0A=
> +#ifndef DPAA2_MAC_H=0A=
> +#define DPAA2_MAC_H=0A=
> +=0A=
> +#include <linux/of.h>=0A=
> +#include <linux/of_mdio.h>=0A=
> +#include <linux/of_net.h>=0A=
> +#include <linux/phylink.h>=0A=
> +=0A=
> +#include "dpmac.h"=0A=
> +#include "dpmac-cmd.h"=0A=
> +=0A=
> +struct dpaa2_mac {=0A=
> +	struct fsl_mc_device *mc_dev;=0A=
> +	struct dpmac_link_state state;=0A=
> +	struct net_device *net_dev;=0A=
> +	struct fsl_mc_io *mc_io;=0A=
> +=0A=
> +	struct phylink_config phylink_config;=0A=
> +	struct phylink *phylink;=0A=
> +	phy_interface_t if_mode;=0A=
> +};=0A=
> +=0A=
> +bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,=0A=
> +			     struct fsl_mc_io *mc_io);=0A=
> +=0A=
> +int dpaa2_mac_connect(struct dpaa2_mac *mac);=0A=
> +=0A=
> +void dpaa2_mac_disconnect(struct dpaa2_mac *mac);=0A=
> +=0A=
> +#endif /* DPAA2_MAC_H */=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/n=
et/ethernet/freescale/dpaa2/dpmac-cmd.h=0A=
> new file mode 100644=0A=
> index 000000000000..96a9b0d0992e=0A=
> --- /dev/null=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h=0A=
> @@ -0,0 +1,62 @@=0A=
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */=0A=
> +/* Copyright 2013-2016 Freescale Semiconductor Inc.=0A=
> + * Copyright 2019 NXP=0A=
> + */=0A=
> +#ifndef _FSL_DPMAC_CMD_H=0A=
> +#define _FSL_DPMAC_CMD_H=0A=
> +=0A=
> +/* DPMAC Version */=0A=
> +#define DPMAC_VER_MAJOR				4=0A=
> +#define DPMAC_VER_MINOR				4=0A=
> +#define DPMAC_CMD_BASE_VERSION			1=0A=
> +#define DPMAC_CMD_2ND_VERSION			2=0A=
> +#define DPMAC_CMD_ID_OFFSET			4=0A=
> +=0A=
> +#define DPMAC_CMD(id)	(((id) << DPMAC_CMD_ID_OFFSET) | DPMAC_CMD_BASE_VE=
RSION)=0A=
> +#define DPMAC_CMD_V2(id) (((id) << DPMAC_CMD_ID_OFFSET) | DPMAC_CMD_2ND_=
VERSION)=0A=
> +=0A=
> +/* Command IDs */=0A=
> +#define DPMAC_CMDID_CLOSE		DPMAC_CMD(0x800)=0A=
> +#define DPMAC_CMDID_OPEN		DPMAC_CMD(0x80c)=0A=
> +=0A=
> +#define DPMAC_CMDID_GET_ATTR		DPMAC_CMD(0x004)=0A=
> +#define DPMAC_CMDID_SET_LINK_STATE	DPMAC_CMD_V2(0x0c3)=0A=
> +=0A=
> +/* Macros for accessing command fields smaller than 1byte */=0A=
> +#define DPMAC_MASK(field)        \=0A=
> +	GENMASK(DPMAC_##field##_SHIFT + DPMAC_##field##_SIZE - 1, \=0A=
> +		DPMAC_##field##_SHIFT)=0A=
> +=0A=
> +#define dpmac_set_field(var, field, val) \=0A=
> +	((var) |=3D (((val) << DPMAC_##field##_SHIFT) & DPMAC_MASK(field)))=0A=
> +#define dpmac_get_field(var, field)      \=0A=
> +	(((var) & DPMAC_MASK(field)) >> DPMAC_##field##_SHIFT)=0A=
> +=0A=
> +struct dpmac_cmd_open {=0A=
> +	__le32 dpmac_id;=0A=
> +};=0A=
> +=0A=
> +struct dpmac_rsp_get_attributes {=0A=
> +	u8 eth_if;=0A=
> +	u8 link_type;=0A=
> +	__le16 id;=0A=
> +	__le32 max_rate;=0A=
> +};=0A=
> +=0A=
> +#define DPMAC_STATE_SIZE	1=0A=
> +#define DPMAC_STATE_SHIFT	0=0A=
> +#define DPMAC_STATE_VALID_SIZE	1=0A=
> +#define DPMAC_STATE_VALID_SHIFT	1=0A=
> +=0A=
> +struct dpmac_cmd_set_link_state {=0A=
> +	__le64 options;=0A=
> +	__le32 rate;=0A=
> +	__le32 pad0;=0A=
> +	/* from lsb: up:1, state_valid:1 */=0A=
> +	u8 state;=0A=
> +	u8 pad1[7];=0A=
> +	__le64 supported;=0A=
> +	__le64 advertising;=0A=
> +};=0A=
> +=0A=
> +#endif /* _FSL_DPMAC_CMD_H */=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/e=
thernet/freescale/dpaa2/dpmac.c=0A=
> new file mode 100644=0A=
> index 000000000000..b75189deffb1=0A=
> --- /dev/null=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c=0A=
> @@ -0,0 +1,149 @@=0A=
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)=0A=
> +/* Copyright 2013-2016 Freescale Semiconductor Inc.=0A=
> + * Copyright 2019 NXP=0A=
> + */=0A=
> +#include <linux/fsl/mc.h>=0A=
> +#include "dpmac.h"=0A=
> +#include "dpmac-cmd.h"=0A=
> +=0A=
> +/**=0A=
> + * dpmac_open() - Open a control session for the specified object.=0A=
> + * @mc_io:	Pointer to MC portal's I/O object=0A=
> + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'=0A=
> + * @dpmac_id:	DPMAC unique ID=0A=
> + * @token:	Returned token; use in subsequent API calls=0A=
> + *=0A=
> + * This function can be used to open a control session for an=0A=
> + * already created object; an object may have been declared in=0A=
> + * the DPL or by calling the dpmac_create function.=0A=
> + * This function returns a unique authentication token,=0A=
> + * associated with the specific object ID and the specific MC=0A=
> + * portal; this token must be used in all subsequent commands for=0A=
> + * this specific object=0A=
> + *=0A=
> + * Return:	'0' on Success; Error code otherwise.=0A=
> + */=0A=
> +int dpmac_open(struct fsl_mc_io *mc_io,=0A=
> +	       u32 cmd_flags,=0A=
> +	       int dpmac_id,=0A=
> +	       u16 *token)=0A=
> +{=0A=
> +	struct dpmac_cmd_open *cmd_params;=0A=
> +	struct fsl_mc_command cmd =3D { 0 };=0A=
> +	int err;=0A=
> +=0A=
> +	/* prepare command */=0A=
> +	cmd.header =3D mc_encode_cmd_header(DPMAC_CMDID_OPEN,=0A=
> +					  cmd_flags,=0A=
> +					  0);=0A=
> +	cmd_params =3D (struct dpmac_cmd_open *)cmd.params;=0A=
> +	cmd_params->dpmac_id =3D cpu_to_le32(dpmac_id);=0A=
> +=0A=
> +	/* send command to mc*/=0A=
> +	err =3D mc_send_command(mc_io, &cmd);=0A=
> +	if (err)=0A=
> +		return err;=0A=
> +=0A=
> +	/* retrieve response parameters */=0A=
> +	*token =3D mc_cmd_hdr_read_token(&cmd);=0A=
> +=0A=
> +	return err;=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * dpmac_close() - Close the control session of the object=0A=
> + * @mc_io:	Pointer to MC portal's I/O object=0A=
> + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'=0A=
> + * @token:	Token of DPMAC object=0A=
> + *=0A=
> + * After this function is called, no further operations are=0A=
> + * allowed on the object without opening a new control session.=0A=
> + *=0A=
> + * Return:	'0' on Success; Error code otherwise.=0A=
> + */=0A=
> +int dpmac_close(struct fsl_mc_io *mc_io,=0A=
> +		u32 cmd_flags,=0A=
> +		u16 token)=0A=
> +{=0A=
> +	struct fsl_mc_command cmd =3D { 0 };=0A=
> +=0A=
> +	/* prepare command */=0A=
> +	cmd.header =3D mc_encode_cmd_header(DPMAC_CMDID_CLOSE, cmd_flags,=0A=
> +					  token);=0A=
> +=0A=
> +	/* send command to mc*/=0A=
> +	return mc_send_command(mc_io, &cmd);=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * dpmac_get_attributes - Retrieve DPMAC attributes.=0A=
> + *=0A=
> + * @mc_io:	Pointer to MC portal's I/O object=0A=
> + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'=0A=
> + * @token:	Token of DPMAC object=0A=
> + * @attr:	Returned object's attributes=0A=
> + *=0A=
> + * Return:	'0' on Success; Error code otherwise.=0A=
> + */=0A=
> +int dpmac_get_attributes(struct fsl_mc_io *mc_io,=0A=
> +			 u32 cmd_flags,=0A=
> +			 u16 token,=0A=
> +			 struct dpmac_attr *attr)=0A=
> +{=0A=
> +	struct dpmac_rsp_get_attributes *rsp_params;=0A=
> +	struct fsl_mc_command cmd =3D { 0 };=0A=
> +	int err;=0A=
> +=0A=
> +	/* prepare command */=0A=
> +	cmd.header =3D mc_encode_cmd_header(DPMAC_CMDID_GET_ATTR,=0A=
> +					  cmd_flags,=0A=
> +					  token);=0A=
> +=0A=
> +	/* send command to mc*/=0A=
> +	err =3D mc_send_command(mc_io, &cmd);=0A=
> +	if (err)=0A=
> +		return err;=0A=
> +=0A=
> +	/* retrieve response parameters */=0A=
> +	rsp_params =3D (struct dpmac_rsp_get_attributes *)cmd.params;=0A=
> +	attr->eth_if =3D rsp_params->eth_if;=0A=
> +	attr->link_type =3D rsp_params->link_type;=0A=
> +	attr->id =3D le16_to_cpu(rsp_params->id);=0A=
> +	attr->max_rate =3D le32_to_cpu(rsp_params->max_rate);=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * dpmac_set_link_state() - Set the Ethernet link status=0A=
> + * @mc_io:      Pointer to opaque I/O object=0A=
> + * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'=0A=
> + * @token:      Token of DPMAC object=0A=
> + * @link_state: Link state configuration=0A=
> + *=0A=
> + * Return:      '0' on Success; Error code otherwise.=0A=
> + */=0A=
> +int dpmac_set_link_state(struct fsl_mc_io *mc_io,=0A=
> +			 u32 cmd_flags,=0A=
> +			 u16 token,=0A=
> +			 struct dpmac_link_state *link_state)=0A=
> +{=0A=
> +	struct dpmac_cmd_set_link_state *cmd_params;=0A=
> +	struct fsl_mc_command cmd =3D { 0 };=0A=
> +=0A=
> +	/* prepare command */=0A=
> +	cmd.header =3D mc_encode_cmd_header(DPMAC_CMDID_SET_LINK_STATE,=0A=
> +					  cmd_flags,=0A=
> +					  token);=0A=
> +	cmd_params =3D (struct dpmac_cmd_set_link_state *)cmd.params;=0A=
> +	cmd_params->options =3D cpu_to_le64(link_state->options);=0A=
> +	cmd_params->rate =3D cpu_to_le32(link_state->rate);=0A=
> +	dpmac_set_field(cmd_params->state, STATE, link_state->up);=0A=
> +	dpmac_set_field(cmd_params->state, STATE_VALID,=0A=
> +			link_state->state_valid);=0A=
> +	cmd_params->supported =3D cpu_to_le64(link_state->supported);=0A=
> +	cmd_params->advertising =3D cpu_to_le64(link_state->advertising);=0A=
> +=0A=
> +	/* send command to mc*/=0A=
> +	return mc_send_command(mc_io, &cmd);=0A=
> +}=0A=
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/e=
thernet/freescale/dpaa2/dpmac.h=0A=
> new file mode 100644=0A=
> index 000000000000..4efc410a479e=0A=
> --- /dev/null=0A=
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h=0A=
> @@ -0,0 +1,144 @@=0A=
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */=0A=
> +/* Copyright 2013-2016 Freescale Semiconductor Inc.=0A=
> + * Copyright 2019 NXP=0A=
> + */=0A=
> +#ifndef __FSL_DPMAC_H=0A=
> +#define __FSL_DPMAC_H=0A=
> +=0A=
> +/* Data Path MAC API=0A=
> + * Contains initialization APIs and runtime control APIs for DPMAC=0A=
> + */=0A=
> +=0A=
> +struct fsl_mc_io;=0A=
> +=0A=
> +int dpmac_open(struct fsl_mc_io *mc_io,=0A=
> +	       u32 cmd_flags,=0A=
> +	       int dpmac_id,=0A=
> +	       u16 *token);=0A=
> +=0A=
> +int dpmac_close(struct fsl_mc_io *mc_io,=0A=
> +		u32 cmd_flags,=0A=
> +		u16 token);=0A=
> +=0A=
> +/**=0A=
> + * enum dpmac_link_type -  DPMAC link type=0A=
> + * @DPMAC_LINK_TYPE_NONE: No link=0A=
> + * @DPMAC_LINK_TYPE_FIXED: Link is fixed type=0A=
> + * @DPMAC_LINK_TYPE_PHY: Link by PHY ID=0A=
> + * @DPMAC_LINK_TYPE_BACKPLANE: Backplane link type=0A=
> + */=0A=
> +enum dpmac_link_type {=0A=
> +	DPMAC_LINK_TYPE_NONE,=0A=
> +	DPMAC_LINK_TYPE_FIXED,=0A=
> +	DPMAC_LINK_TYPE_PHY,=0A=
> +	DPMAC_LINK_TYPE_BACKPLANE=0A=
> +};=0A=
> +=0A=
> +/**=0A=
> + * enum dpmac_eth_if - DPMAC Ethrnet interface=0A=
> + * @DPMAC_ETH_IF_MII: MII interface=0A=
> + * @DPMAC_ETH_IF_RMII: RMII interface=0A=
> + * @DPMAC_ETH_IF_SMII: SMII interface=0A=
> + * @DPMAC_ETH_IF_GMII: GMII interface=0A=
> + * @DPMAC_ETH_IF_RGMII: RGMII interface=0A=
> + * @DPMAC_ETH_IF_SGMII: SGMII interface=0A=
> + * @DPMAC_ETH_IF_QSGMII: QSGMII interface=0A=
> + * @DPMAC_ETH_IF_XAUI: XAUI interface=0A=
> + * @DPMAC_ETH_IF_XFI: XFI interface=0A=
> + * @DPMAC_ETH_IF_CAUI: CAUI interface=0A=
> + * @DPMAC_ETH_IF_1000BASEX: 1000BASEX interface=0A=
> + * @DPMAC_ETH_IF_USXGMII: USXGMII interface=0A=
> + */=0A=
> +enum dpmac_eth_if {=0A=
> +	DPMAC_ETH_IF_MII,=0A=
> +	DPMAC_ETH_IF_RMII,=0A=
> +	DPMAC_ETH_IF_SMII,=0A=
> +	DPMAC_ETH_IF_GMII,=0A=
> +	DPMAC_ETH_IF_RGMII,=0A=
> +	DPMAC_ETH_IF_SGMII,=0A=
> +	DPMAC_ETH_IF_QSGMII,=0A=
> +	DPMAC_ETH_IF_XAUI,=0A=
> +	DPMAC_ETH_IF_XFI,=0A=
> +	DPMAC_ETH_IF_CAUI,=0A=
> +	DPMAC_ETH_IF_1000BASEX,=0A=
> +	DPMAC_ETH_IF_USXGMII,=0A=
> +};=0A=
> +=0A=
> +/**=0A=
> + * struct dpmac_attr - Structure representing DPMAC attributes=0A=
> + * @id:		DPMAC object ID=0A=
> + * @max_rate:	Maximum supported rate - in Mbps=0A=
> + * @eth_if:	Ethernet interface=0A=
> + * @link_type:	link type=0A=
> + */=0A=
> +struct dpmac_attr {=0A=
> +	u16 id;=0A=
> +	u32 max_rate;=0A=
> +	enum dpmac_eth_if eth_if;=0A=
> +	enum dpmac_link_type link_type;=0A=
> +};=0A=
> +=0A=
> +int dpmac_get_attributes(struct fsl_mc_io *mc_io,=0A=
> +			 u32 cmd_flags,=0A=
> +			 u16 token,=0A=
> +			 struct dpmac_attr *attr);=0A=
> +=0A=
> +/**=0A=
> + * DPMAC link configuration/state options=0A=
> + */=0A=
> +=0A=
> +/**=0A=
> + * Enable auto-negotiation=0A=
> + */=0A=
> +#define DPMAC_LINK_OPT_AUTONEG			BIT_ULL(0)=0A=
> +/**=0A=
> + * Enable half-duplex mode=0A=
> + */=0A=
> +#define DPMAC_LINK_OPT_HALF_DUPLEX		BIT_ULL(1)=0A=
> +/**=0A=
> + * Enable pause frames=0A=
> + */=0A=
> +#define DPMAC_LINK_OPT_PAUSE			BIT_ULL(2)=0A=
> +/**=0A=
> + * Enable a-symmetric pause frames=0A=
> + */=0A=
> +#define DPMAC_LINK_OPT_ASYM_PAUSE		BIT_ULL(3)=0A=
> +=0A=
> +/**=0A=
> + * Advertised link speeds=0A=
> + */=0A=
> +#define DPMAC_ADVERTISED_10BASET_FULL		BIT_ULL(0)=0A=
> +#define DPMAC_ADVERTISED_100BASET_FULL		BIT_ULL(1)=0A=
> +#define DPMAC_ADVERTISED_1000BASET_FULL		BIT_ULL(2)=0A=
> +#define DPMAC_ADVERTISED_10000BASET_FULL	BIT_ULL(4)=0A=
> +#define DPMAC_ADVERTISED_2500BASEX_FULL		BIT_ULL(5)=0A=
> +=0A=
> +/**=0A=
> + * Advertise auto-negotiation enable=0A=
> + */=0A=
> +#define DPMAC_ADVERTISED_AUTONEG		BIT_ULL(3)=0A=
> +=0A=
> +/**=0A=
> + * struct dpmac_link_state - DPMAC link configuration request=0A=
> + * @rate: Rate in Mbps=0A=
> + * @options: Enable/Disable DPMAC link cfg features (bitmap)=0A=
> + * @up: Link state=0A=
> + * @state_valid: Ignore/Update the state of the link=0A=
> + * @supported: Speeds capability of the phy (bitmap)=0A=
> + * @advertising: Speeds that are advertised for autoneg (bitmap)=0A=
> + */=0A=
> +struct dpmac_link_state {=0A=
> +	u32 rate;=0A=
> +	u64 options;=0A=
> +	int up;=0A=
> +	int state_valid;=0A=
> +	u64 supported;=0A=
> +	u64 advertising;=0A=
> +};=0A=
> +=0A=
> +int dpmac_set_link_state(struct fsl_mc_io *mc_io,=0A=
> +			 u32 cmd_flags,=0A=
> +			 u16 token,=0A=
> +			 struct dpmac_link_state *link_state);=0A=
> +=0A=
> +#endif /* __FSL_DPMAC_H */=0A=
> =0A=
=0A=
