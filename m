Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B853288EA0
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 00:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfHJWAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 18:00:38 -0400
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:60292
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbfHJWAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 18:00:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcH0Sr9LYSWJIPY+43rXQRh6ns58pvI8xUZmgL6y7A4k5GWtrKUPEw0pClo+bR7R/LCRx21GqxYeu3J8+CCmgGjIYxbvibMGnQfCx/AW2rtV1NnD4BdhrTVWiZehRt01DxK5mS3bmGyjanv82DTv/G8WkrlX6Lev85nE07zMAtRd1K69AHBWI/rfL4nHv4nXsZ8hiZehU7X8g4H164qxT/P8ubjYyu9MKB1pxpQsRfBH8W+je77byDNZE9YZ/FtjKy6jhqaXGuzb9/Zd43dFZLKz1M31QcxdEk/DGl2BNUlNBejQR5Q+oiFdd1tUSITr9p5ymC4rMLK3klcYKKL8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi29vGyviWfkDCuIgHpwZtE7R770hUPPxlwwjrevQvg=;
 b=G35xBA6dKnoM4mwK9V6uUQcOlrIxAtzDpttkL1ELax0n/GagfNlaL7F1fwrP3wkLLbGr/49IRmnLGO7V0JIZJ7i9hU62pF6pyCSu+0v2c7Wx5tcTG3MUqz+OIGzwrp6A/j2gQW/XEpxXPIfxECzaTj9LuPEkp1fUQ9TWp1+n6W/uz3cKknCsBSO1zN6/+hXIUbwgJXeTfPPDEqzQSNUHrw1Fic6hDMRjvUmgI6o7WeVXFIauf6k5rVXYYP5t2Iwq6Nyc/3r5LdgAEny5KtR0xk92yzeCwYwaExVd8c0c+Mch+qp+PjjuR5SRBDuJo8mxhA/Mc1spjyvFNI1SSjTDXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi29vGyviWfkDCuIgHpwZtE7R770hUPPxlwwjrevQvg=;
 b=DAgfYN+N4BbX+94tmGIv054IvKJccaEIAKkXuXgPnuxFCQtHRVHzQy5UUs27BFWSkIXw/DiZwyojS8OytXB38ryEV0gz7ki8b2iPdgQARFkJvw2rJeMiVzO4C9TtMexHmsrkXxaMF/jXRUvmduT+TT23ZjSkPf0JbGYkU62a/qw=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2877.eurprd04.prod.outlook.com (10.175.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Sat, 10 Aug 2019 21:45:23 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::85d1:9f00:3d4c:1860]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::85d1:9f00:3d4c:1860%7]) with mapi id 15.20.2157.022; Sat, 10 Aug 2019
 21:45:22 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out of
 staging
Thread-Topic: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Thread-Index: AQHVTsse6Qsm2zNpN0akGPBvGQTj7Q==
Date:   Sat, 10 Aug 2019 21:45:22 +0000
Message-ID: <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
 <20190809190459.GW27917@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.91.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09533701-0dad-4ce6-7690-08d71ddc0c20
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2877;
x-ms-traffictypediagnostic: VI1PR0402MB2877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28776D0CE8515B5BC9F8E828E0D10@VI1PR0402MB2877.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 012570D5A0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(189003)(199004)(26005)(76176011)(7696005)(6246003)(53946003)(102836004)(446003)(6916009)(476003)(53546011)(53936002)(6506007)(486006)(14454004)(44832011)(66066001)(81166006)(81156014)(229853002)(8676002)(478600001)(4326008)(25786009)(256004)(6116002)(33656002)(6436002)(3846002)(52536014)(5660300002)(316002)(2906002)(30864003)(71190400001)(71200400001)(76116006)(54906003)(9686003)(55016002)(305945005)(8936002)(186003)(86362001)(66446008)(14444005)(66476007)(99286004)(66946007)(66556008)(64756008)(7736002)(74316002)(579004)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2877;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: COOdcqLINdKCK75BBeLxfrH7iu1BCBRTiqDZSMzm0HtcN5xvCGmn57nU2WJeEhQIXs7wkR1pA0v2DI7ny2yGexEt+FgcujmYK8d5tMM66ZlyxIg0xGrhkijY5yC3DPKcCkrMA8lpxJeW8z32Wz1iYTMETzs3VXX0snWnDfJEZBxLhnPeyVB9SnNfz88zAJWjU0evpYdPbsgN/nBzzX4GOFqffX5LdKvHIOpzQFZHiQ1GfLBSvG1iZ2pzHFCX319eKMs2ypL0ijhHm3q8/YDCbXXQ76TZWzwG27fp7cndCPtfffhlb//fExxxvtqDZ2VWzshZfy7iWAZzHU36jWHRvO3InxmJaohk0SGsoUUa4Iuf3qkHc25xEcm9msth/COJeO8q5dI0lJEGF+mQx+K7+ZfVzZLpQl6YOcTXVgJlC6k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09533701-0dad-4ce6-7690-08d71ddc0c20
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2019 21:45:22.8529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZiU/GrJOYO7nS+GhEh4M83hVlqNmBuKB5vLQpD+03U4YjqgeAYn4ZU6l3vn9/V5V0/VyvHj2bwLkLAHdukqgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2877
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 10:05 PM, Andrew Lunn wrote:=0A=
 > Hi Ioana=0A=
=0A=
Hi Andrew,=0A=
=0A=
 >=0A=
 >> +static int=0A=
 >> +ethsw_get_link_ksettings(struct net_device *netdev,=0A=
 >> +			 struct ethtool_link_ksettings *link_ksettings)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	struct dpsw_link_state state =3D {0};=0A=
 >> +	int err =3D 0;=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,=0A=
 >> +				     port_priv->ethsw_data->dpsw_handle,=0A=
 >> +				     port_priv->idx,=0A=
 >> +				     &state);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev, "ERROR %d getting link state", err);=0A=
 >> +		goto out;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	/* At the moment, we have no way of interrogating the DPMAC=0A=
 >> +	 * from the DPSW side or there may not exist a DPMAC at all.=0A=
 >=0A=
 > What use is a switch port without a MAC?=0A=
=0A=
In the DPAA2 architecture MACs are not the only entities that can be =0A=
connected to a switch port.=0A=
Below is an exemple of a 4 port DPAA2 switch which is configured to =0A=
interconnect 2 DPNIs (network interfaces) and 2 DPMACs.=0A=
=0A=
=0A=
  [ethA]     [ethB]     [ethC]     [ethD]     [ethE]     [ethF]=0A=
     :          :          :          :          :          :=0A=
     :          :          :          :          :          :=0A=
[eth drv]  [eth drv]  [                ethsw drv              ]=0A=
     :          :          :          :          :          :        kernel=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
     :          :          :          :          :          : =0A=
hardware=0A=
  [DPNI]      [DPNI]     [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D DPSW =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D]=0A=
     |          |          |          |          |          |=0A=
     |           ----------           |       [DPMAC]    [DPMAC]=0A=
      -------------------------------            |          |=0A=
                                                 |          |=0A=
                                               [PHY]      [PHY]=0A=
=0A=
You can see it as a hardware-accelerated software bridge where=0A=
forwarding rules are managed from the host software partition.=0A=
=0A=
=0A=
 >=0A=
 >> +	 * Report only autoneg state, duplexity and speed.=0A=
 >> +	 */=0A=
 >> +	if (state.options & DPSW_LINK_OPT_AUTONEG)=0A=
 >> +		link_ksettings->base.autoneg =3D AUTONEG_ENABLE;=0A=
 >> +	if (!(state.options & DPSW_LINK_OPT_HALF_DUPLEX))=0A=
 >> +		link_ksettings->base.duplex =3D DUPLEX_FULL;=0A=
 >> +	link_ksettings->base.speed =3D state.rate;=0A=
 >> +=0A=
 >> +out:=0A=
 >> +	return err;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int=0A=
 >> +ethsw_set_link_ksettings(struct net_device *netdev,=0A=
 >> +			 const struct ethtool_link_ksettings *link_ksettings)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	struct dpsw_link_cfg cfg =3D {0};=0A=
 >> +	int err =3D 0;=0A=
 >> +=0A=
 >> +	netdev_dbg(netdev, "Setting link parameters...");=0A=
 >> +=0A=
 >> +	/* Due to a temporary MC limitation, the DPSW port must be down=0A=
 >> +	 * in order to be able to change link settings. Taking steps to let=
=0A=
 >> +	 * the user know that.=0A=
 >> +	 */=0A=
 >> +	if (netif_running(netdev)) {=0A=
 >> +		netdev_info(netdev, "Sorry, interface must be brought down =0A=
first.\n");=0A=
 >> +		return -EACCES;=0A=
 >> +	}=0A=
 >=0A=
 > This is quite common. The Marvell switches require the port is=0A=
 > disabled while reconfiguring the port. So we just disable it,=0A=
 > reconfigure it, and enable it again.=0A=
 >=0A=
 > Why are you making the user do this?=0A=
=0A=
There is no strong reason for this, we could just disable the port =0A=
behind the scenes.=0A=
=0A=
=0A=
 >=0A=
 >> +=0A=
 >> +	cfg.rate =3D link_ksettings->base.speed;=0A=
 >> +	if (link_ksettings->base.autoneg =3D=3D AUTONEG_ENABLE)=0A=
 >> +		cfg.options |=3D DPSW_LINK_OPT_AUTONEG;=0A=
 >> +	else=0A=
 >> +		cfg.options &=3D ~DPSW_LINK_OPT_AUTONEG;=0A=
 >> +	if (link_ksettings->base.duplex  =3D=3D DUPLEX_HALF)=0A=
 >> +		cfg.options |=3D DPSW_LINK_OPT_HALF_DUPLEX;=0A=
 >> +	else=0A=
 >> +		cfg.options &=3D ~DPSW_LINK_OPT_HALF_DUPLEX;=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_set_link_cfg(port_priv->ethsw_data->mc_io, 0,=0A=
 >> +				   port_priv->ethsw_data->dpsw_handle,=0A=
 >> +				   port_priv->idx,=0A=
 >> +				   &cfg);=0A=
 >> +	if (err)=0A=
 >> +		/* ethtool will be loud enough if we return an error; no point=0A=
 >> +		 * in putting our own error message on the console by default=0A=
 >> +		 */=0A=
 >> +		netdev_dbg(netdev, "ERROR %d setting link cfg", err);=0A=
 >=0A=
 > Why even bother with a dbg message?=0A=
 >=0A=
=0A=
True, will remove.=0A=
=0A=
=0A=
 >> +static void ethsw_ethtool_get_stats(struct net_device *netdev,=0A=
 >> +				    struct ethtool_stats *stats,=0A=
 >> +				    u64 *data)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	int i, err;=0A=
 >> +=0A=
 >> +	memset(data, 0,=0A=
 >> +	       sizeof(u64) * ETHSW_NUM_COUNTERS);=0A=
 >=0A=
 > Is this really needed? It seems like the core should be doing this?=0A=
 >=0A=
=0A=
The ethtool core indeed zeroes the data before calling =0A=
get_ethtool_stats. Will remove.=0A=
=0A=
=0A=
 >> +static int ethsw_add_vlan(struct ethsw_core *ethsw, u16 vid)=0A=
 >> +{=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	struct dpsw_vlan_cfg	vcfg =3D {=0A=
 >> +		.fdb_id =3D 0,=0A=
 >> +	};=0A=
 >> +=0A=
 >> +	if (ethsw->vlans[vid]) {=0A=
 >> +		dev_err(ethsw->dev, "VLAN already configured\n");=0A=
 >> +		return -EEXIST;=0A=
 >> +	}=0A=
 >=0A=
 > Can this happen? It seems like the core should be preventing this.=0A=
 >=0A=
=0A=
In regard to the core preventing this, it seems that there are no checks.=
=0A=
The problem here is that the firmware errors out when we add the same =0A=
VLAN twice. Other drivers just return 0 in that case.=0A=
Can we keep the check but do the same thing?=0A=
=0A=
=0A=
 >> +=0A=
 >> +	err =3D dpsw_vlan_add(ethsw->mc_io, 0,=0A=
 >> +			    ethsw->dpsw_handle, vid, &vcfg);=0A=
 >> +	if (err) {=0A=
 >> +		dev_err(ethsw->dev, "dpsw_vlan_add err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +	ethsw->vlans[vid] =3D ETHSW_VLAN_MEMBER;=0A=
 >> +=0A=
 >> +	return 0;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int ethsw_port_set_pvid(struct ethsw_port_priv *port_priv, =0A=
u16 pvid)=0A=
 >> +{=0A=
 >> +	struct ethsw_core *ethsw =3D port_priv->ethsw_data;=0A=
 >> +	struct net_device *netdev =3D port_priv->netdev;=0A=
 >> +	struct dpsw_tci_cfg tci_cfg =3D { 0 };=0A=
 >> +	bool is_oper;=0A=
 >> +	int err, ret;=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_get_tci(ethsw->mc_io, 0, ethsw->dpsw_handle,=0A=
 >> +			      port_priv->idx, &tci_cfg);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev, "dpsw_if_get_tci err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	tci_cfg.vlan_id =3D pvid;=0A=
 >> +=0A=
 >> +	/* Interface needs to be down to change PVID */=0A=
 >> +	is_oper =3D netif_oper_up(netdev);=0A=
 >> +	if (is_oper) {=0A=
 >> +		err =3D dpsw_if_disable(ethsw->mc_io, 0,=0A=
 >> +				      ethsw->dpsw_handle,=0A=
 >> +				      port_priv->idx);=0A=
 >> +		if (err) {=0A=
 >> +			netdev_err(netdev, "dpsw_if_disable err %d\n", err);=0A=
 >> +			return err;=0A=
 >> +		}=0A=
 >> +	}=0A=
 >=0A=
 > Is this not inconsistent with ethsw_set_link_ksettings()?=0A=
 >=0A=
=0A=
It's indeed inconsistent. I'll change the ethsw_set_link_ksettings() to =0A=
also disable and=0A=
re-enable the interface behind the scenes.=0A=
=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_set_tci(ethsw->mc_io, 0, ethsw->dpsw_handle,=0A=
 >> +			      port_priv->idx, &tci_cfg);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev, "dpsw_if_set_tci err %d\n", err);=0A=
 >> +		goto set_tci_error;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	/* Delete previous PVID info and mark the new one */=0A=
 >> +	port_priv->vlans[port_priv->pvid] &=3D ~ETHSW_VLAN_PVID;=0A=
 >> +	port_priv->vlans[pvid] |=3D ETHSW_VLAN_PVID;=0A=
 >> +	port_priv->pvid =3D pvid;=0A=
 >> +=0A=
 >> +set_tci_error:=0A=
 >> +	if (is_oper) {=0A=
 >> +		ret =3D dpsw_if_enable(ethsw->mc_io, 0,=0A=
 >> +				     ethsw->dpsw_handle,=0A=
 >> +				     port_priv->idx);=0A=
 >> +		if (ret) {=0A=
 >> +			netdev_err(netdev, "dpsw_if_enable err %d\n", ret);=0A=
 >> +			return ret;=0A=
 >> +		}=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	return err;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int ethsw_set_learning(struct ethsw_core *ethsw, u8 flag)=0A=
 >> +{=0A=
 >=0A=
 > Seems like a bool would be better than u8 for flag. An call it enable?=
=0A=
 >=0A=
=0A=
Sure.=0A=
=0A=
 >> +	enum dpsw_fdb_learning_mode learn_mode;=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	if (flag)=0A=
 >> +		learn_mode =3D DPSW_FDB_LEARNING_MODE_HW;=0A=
 >> +	else=0A=
 >> +		learn_mode =3D DPSW_FDB_LEARNING_MODE_DIS;=0A=
 >> +=0A=
 >> +	err =3D dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, =0A=
ethsw->dpsw_handle, 0,=0A=
 >> +					 learn_mode);=0A=
 >> +	if (err) {=0A=
 >> +		dev_err(ethsw->dev, "dpsw_fdb_set_learning_mode err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +	ethsw->learning =3D !!flag;=0A=
 >> +=0A=
 >> +	return 0;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int ethsw_port_set_flood(struct ethsw_port_priv *port_priv, =0A=
u8 flag)=0A=
 >> +{=0A=
 >=0A=
 > Another bool?=0A=
 >=0A=
=0A=
Yep, will change.=0A=
=0A=
=0A=
 >> +static int port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],=0A=
 >> +			struct net_device *dev, const unsigned char *addr,=0A=
 >> +			u16 vid, u16 flags,=0A=
 >> +			struct netlink_ext_ack *extack)=0A=
 >> +{=0A=
 >> +	if (is_unicast_ether_addr(addr))=0A=
 >> +		return ethsw_port_fdb_add_uc(netdev_priv(dev),=0A=
 >> +					     addr);=0A=
 >> +	else=0A=
 >> +		return ethsw_port_fdb_add_mc(netdev_priv(dev),=0A=
 >> +					     addr);=0A=
 >=0A=
 > Do you need to do anything special with link local MAC addresses?=0A=
 > Often they are considered as UC addresses.=0A=
 >=0A=
=0A=
Not at the moment, no. Once we add control traffic support we'll add =0A=
default ACL rules=0A=
that match on link local addresses and redirect traffic to the control =0A=
interface.=0A=
=0A=
=0A=
 >> +static int port_carrier_state_sync(struct net_device *netdev)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	struct dpsw_link_state state;=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,=0A=
 >> +				     port_priv->ethsw_data->dpsw_handle,=0A=
 >> +				     port_priv->idx, &state);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev, "dpsw_if_get_link_state() err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	WARN_ONCE(state.up > 1, "Garbage read into link_state");=0A=
 >> +=0A=
 >> +	if (state.up !=3D port_priv->link_state) {=0A=
 >> +		if (state.up)=0A=
 >> +			netif_carrier_on(netdev);=0A=
 >> +		else=0A=
 >> +			netif_carrier_off(netdev);=0A=
 >> +		port_priv->link_state =3D state.up;=0A=
 >> +	}=0A=
 >> +	return 0;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int port_open(struct net_device *netdev)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	/* No need to allow Tx as control interface is disabled */=0A=
 >> +	netif_tx_stop_all_queues(netdev);=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_enable(port_priv->ethsw_data->mc_io, 0,=0A=
 >> +			     port_priv->ethsw_data->dpsw_handle,=0A=
 >> +			     port_priv->idx);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev, "dpsw_if_enable err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	/* sync carrier state */=0A=
 >> +	err =3D port_carrier_state_sync(netdev);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev,`<=0A=
 >> +			   "port_carrier_state_sync err %d\n", err);=0A=
 >=0A=
 > port_carrier_state_sync() already does a netdev_err(). There are a lot=
=0A=
 > of netdev_err() in this code. I wonder how many are really needed? And=
=0A=
 > how often you get a cascade of error message like this?=0A=
 >=0A=
 > I think many of them can be downgraded to netdev_dbg(), or removed.=0A=
 >=0A=
=0A=
I'll do a sweep of the code and remove/downgrade where necessary.=0A=
=0A=
=0A=
 >> +		goto err_carrier_sync;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	return 0;=0A=
 >> +=0A=
 >> +err_carrier_sync:=0A=
 >> +	dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,=0A=
 >> +			port_priv->ethsw_data->dpsw_handle,=0A=
 >> +			port_priv->idx);=0A=
 >> +	return err;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int port_stop(struct net_device *netdev)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	err =3D dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,=0A=
 >> +			      port_priv->ethsw_data->dpsw_handle,=0A=
 >> +			      port_priv->idx);=0A=
 >> +	if (err) {=0A=
 >> +		netdev_err(netdev, "dpsw_if_disable err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	return 0;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static netdev_tx_t port_dropframe(struct sk_buff *skb,=0A=
 >> +				  struct net_device *netdev)=0A=
 >> +{=0A=
 >> +	/* we don't support I/O for now, drop the frame */=0A=
 >> +	dev_kfree_skb_any(skb);=0A=
 >> +=0A=
 >=0A=
 > Ah. Does this also mean it cannot receive?=0A=
 >=0A=
=0A=
Yes, at the moment dpaa2-ethsw does not support either RX nor TX on the =0A=
switch ports.=0A=
=0A=
 > That makes some of this code pointless and untested.=0A=
 >=0A=
 > I'm not sure we would be willing to move this out of staging until it=0A=
 > can transmit and receive. The whole idea is that switch ports are just=
=0A=
 > linux interfaces. Some actions can be accelerated using hardware, and=0A=
 > what cannot be accelerated the network stack does. However, if you=0A=
 > cannot receive and transmit, you break that whole model. The network=0A=
 > stack is mostly pointless.=0A=
=0A=
=0A=
I get that. I'll first work on adding support for termination.=0A=
=0A=
 >=0A=
 >> +static void ethsw_links_state_update(struct ethsw_core *ethsw)=0A=
 >> +{=0A=
 >> +	int i;=0A=
 >> +=0A=
 >> +	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++)=0A=
 >> +		port_carrier_state_sync(ethsw->ports[i]->netdev);=0A=
 >> +}=0A=
 >> +=0A=
 >> +static irqreturn_t ethsw_irq0_handler_thread(int irq_num, void *arg)=
=0A=
 >> +{=0A=
 >> +	struct device *dev =3D (struct device *)arg;=0A=
 >> +	struct ethsw_core *ethsw =3D dev_get_drvdata(dev);=0A=
 >> +=0A=
 >> +	/* Mask the events and the if_id reserved bits to be cleared on =0A=
read */=0A=
 >> +	u32 status =3D DPSW_IRQ_EVENT_LINK_CHANGED | 0xFFFF0000;=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	err =3D dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,=0A=
 >> +				  DPSW_IRQ_INDEX_IF, &status);=0A=
 >> +	if (err) {=0A=
 >> +		dev_err(dev, "Can't get irq status (err %d)", err);=0A=
 >> +=0A=
 >> +		err =3D dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,=
=0A=
 >> +					    DPSW_IRQ_INDEX_IF, 0xFFFFFFFF);=0A=
 >> +		if (err)=0A=
 >> +			dev_err(dev, "Can't clear irq status (err %d)", err);=0A=
 >> +		goto out;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	if (status & DPSW_IRQ_EVENT_LINK_CHANGED)=0A=
 >> +		ethsw_links_state_update(ethsw);=0A=
 >=0A=
 > So there are no per-port events? You have no idea which port went=0A=
 > up/down, you have to poll them all?=0A=
 >=0A=
=0A=
Yes, the firmware just notifies that at least one of the links has changed.=
=0A=
We then need to check them all and update if necessary.=0A=
=0A=
=0A=
 >> +=0A=
 >> +out:=0A=
 >> +	return IRQ_HANDLED;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int port_lookup_address(struct net_device *netdev, int is_uc,=
=0A=
 >> +			       const unsigned char *addr)=0A=
 >> +{=0A=
 >> +	struct netdev_hw_addr_list *list =3D (is_uc) ? &netdev->uc : =0A=
&netdev->mc;=0A=
 >> +	struct netdev_hw_addr *ha;=0A=
 >> +=0A=
 >> +	netif_addr_lock_bh(netdev);=0A=
 >> +	list_for_each_entry(ha, &list->list, list) {=0A=
 >> +		if (ether_addr_equal(ha->addr, addr)) {=0A=
 >> +			netif_addr_unlock_bh(netdev);=0A=
 >> +			return 1;=0A=
 >> +		}=0A=
 >> +	}=0A=
 >> +	netif_addr_unlock_bh(netdev);=0A=
 >> +	return 0;=0A=
 >=0A=
 > I know i have shot myself in the foot a few times with this structure=0A=
 > of returning in the middle of a loop while holding a lock, forgetting=0A=
 > to unlock, and then later deadlocking. I always do something like:=0A=
 >=0A=
 > 	ret =3D 0;=0A=
 > 	netif_addr_lock_bh(netdev);=0A=
 > 	list_for_each_entry(ha, &list->list, list) {=0A=
 > 		if (ether_addr_equal(ha->addr, addr)) {=0A=
 > 			ret =3D 1;=0A=
 > 			break;=0A=
 > 		}=0A=
 > 	}=0A=
 > 	netif_addr_unlock_bh(netdev);=0A=
 >=0A=
 > 	return ret;=0A=
 > }=0A=
=0A=
Thanks a lot for the tip, will change.=0A=
=0A=
 >=0A=
 > Also, this function should probably return a bool, not int.=0A=
 >=0A=
=0A=
Indeed, a bool is more appropriate.=0A=
=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int port_mdb_add(struct net_device *netdev,=0A=
 >> +			const struct switchdev_obj_port_mdb *mdb,=0A=
 >> +			struct switchdev_trans *trans)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	if (switchdev_trans_ph_prepare(trans))=0A=
 >> +		return 0;=0A=
 >> +=0A=
 >> +	/* Check if address is already set on this port */=0A=
 >> +	if (port_lookup_address(netdev, 0, mdb->addr))=0A=
 >> +		return -EEXIST;=0A=
 >=0A=
 > You are looking at core data structures to determine if the address is=
=0A=
 > already on the port. Is it possible for the core to ask you to add=0A=
 > this address, if the core has the information needed to determine=0A=
 > itself if the port already has the address.=0A=
 >=0A=
 > This seems to be a general theme in this code. You don't trust the=0A=
 > core. If you have real examples of the core doing the wrong thing,=0A=
 > please point them out.=0A=
 >=0A=
=0A=
In this specific case, it seems that the core already checks for =0A=
duplicates and our check is not needed.=0A=
We'll remove.=0A=
=0A=
 >> +/* For the moment, only flood setting needs to be updated */=0A=
 >> +static int port_bridge_join(struct net_device *netdev,=0A=
 >> +			    struct net_device *upper_dev)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
 >> +	struct ethsw_core *ethsw =3D port_priv->ethsw_data;=0A=
 >> +	int i, err;=0A=
 >> +=0A=
 >> +	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++)=0A=
 >> +		if (ethsw->ports[i]->bridge_dev &&=0A=
 >> +		    (ethsw->ports[i]->bridge_dev !=3D upper_dev)) {=0A=
 >> +			netdev_err(netdev,=0A=
 >> +				   "Another switch port is connected to %s\n",=0A=
 >> +				   ethsw->ports[i]->bridge_dev->name);=0A=
 >> +			return -EINVAL;=0A=
 >> +		}=0A=
 >=0A=
 > Am i reading this correct? You only support a single bridge?  The=0A=
 > error message is not very informative. Also, i think you should be=0A=
 > returning EOPNOTSUPP, indicating the offload is not possible. Linux=0A=
 > will then do it in software. If it could actually receive/transmit the=
=0A=
 > frames....=0A=
 >=0A=
=0A=
Yes, we only support a single bridge. I'll change the error message to =0A=
make it descriptive.=0A=
Once we can Rx/Tx on the switch ports the restriction could be lifted.=0A=
=0A=
 >> +static int ethsw_open(struct ethsw_core *ethsw)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D NULL;=0A=
 >> +	int i, err;=0A=
 >> +=0A=
 >> +	err =3D dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);=0A=
 >> +	if (err) {=0A=
 >> +		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++) {=0A=
 >> +		port_priv =3D ethsw->ports[i];=0A=
 >> +		err =3D dev_open(port_priv->netdev, NULL);=0A=
 >> +		if (err) {=0A=
 >> +			netdev_err(port_priv->netdev, "dev_open err %d\n", err);=0A=
 >> +			return err;=0A=
 >> +		}=0A=
 >> +	}=0A=
 >=0A=
 > Why is this needed? When the user configures the interface up, won't=0A=
 > the core call dev_open()?=0A=
 >=0A=
=0A=
You're indeed right. Only dpsw_enable() is needed on switch probe.=0A=
I'll refactor this part.=0A=
=0A=
 >> +=0A=
 >> +	return 0;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int ethsw_stop(struct ethsw_core *ethsw)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv =3D NULL;=0A=
 >> +	int i, err;=0A=
 >> +=0A=
 >> +	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++) {=0A=
 >> +		port_priv =3D ethsw->ports[i];=0A=
 >> +		dev_close(port_priv->netdev);=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	err =3D dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);=0A=
 >> +	if (err) {=0A=
 >> +		dev_err(ethsw->dev, "dpsw_disable err %d\n", err);=0A=
 >> +		return err;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	return 0;=0A=
 >> +}=0A=
 >> +=0A=
 >> +static int ethsw_init(struct fsl_mc_device *sw_dev)=0A=
 >> +{=0A=
 >> +	stp_cfg.vlan_id =3D DEFAULT_VLAN_ID;=0A=
 >> +	stp_cfg.state =3D DPSW_STP_STATE_FORWARDING;=0A=
 >> +=0A=
 >> +	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++) {=0A=
 >> +		err =3D dpsw_if_set_stp(ethsw->mc_io, 0, ethsw->dpsw_handle, i,=0A=
 >> +				      &stp_cfg);=0A=
 >=0A=
 > Maybe you should actually configure the STP state to blocked? You can=0A=
 > move it to forwarding when the interface is opened.=0A=
 >=0A=
=0A=
That's probably better. Will try.=0A=
=0A=
=0A=
 >> +static int ethsw_port_init(struct ethsw_port_priv *port_priv, u16 port=
)=0A=
 >> +{=0A=
 >> +	const char def_mcast[ETH_ALEN] =3D {0x01, 0x00, 0x5e, 0x00, 0x00, 0x0=
1};=0A=
 >=0A=
 > There should be some explanation about what the MAC address is, and=0A=
 > why it needs adding.=0A=
 >=0A=
=0A=
It's an IGMP multicast address... but since we do not support =0A=
termination there is no need for this entry.=0A=
I'll remove it.=0A=
=0A=
=0A=
 >> +static int ethsw_probe_port(struct ethsw_core *ethsw, u16 port_idx)=0A=
 >> +{=0A=
 >> +	struct ethsw_port_priv *port_priv;=0A=
 >> +	struct device *dev =3D ethsw->dev;=0A=
 >> +	struct net_device *port_netdev;=0A=
 >> +	int err;=0A=
 >> +=0A=
 >> +	port_netdev =3D alloc_etherdev(sizeof(struct ethsw_port_priv));=0A=
 >> +	if (!port_netdev) {=0A=
 >> +		dev_err(dev, "alloc_etherdev error\n");=0A=
 >> +		return -ENOMEM;=0A=
 >> +	}=0A=
 >> +=0A=
 >> +	port_priv =3D netdev_priv(port_netdev);=0A=
 >> +	port_priv->netdev =3D port_netdev;=0A=
 >> +	port_priv->ethsw_data =3D ethsw;=0A=
 >> +=0A=
 >> +	port_priv->idx =3D port_idx;=0A=
 >> +	port_priv->stp_state =3D BR_STATE_FORWARDING;=0A=
 >> +=0A=
 >> +	/* Flooding is implicitly enabled */=0A=
 >> +	port_priv->flood =3D true;=0A=
 >> +=0A=
 >> +	SET_NETDEV_DEV(port_netdev, dev);=0A=
 >> +	port_netdev->netdev_ops =3D &ethsw_port_ops;=0A=
 >> +	port_netdev->ethtool_ops =3D &ethsw_port_ethtool_ops;=0A=
 >> +=0A=
 >> +	/* Set MTU limits */=0A=
 >> +	port_netdev->min_mtu =3D ETH_MIN_MTU;=0A=
 >> +	port_netdev->max_mtu =3D ETHSW_MAX_FRAME_LENGTH;=0A=
 >> +=0A=
 >> +	err =3D register_netdev(port_netdev);=0A=
 >> +	if (err < 0) {=0A=
 >> +		dev_err(dev, "register_netdev error %d\n", err);=0A=
 >> +		goto err_register_netdev;=0A=
 >> +	}=0A=
 >=0A=
 > At this point, the interface if live.=0A=
 >=0A=
 >> +=0A=
 >> +	ethsw->ports[port_idx] =3D port_priv;=0A=
 >> +=0A=
 >> +	err =3D ethsw_port_init(port_priv, port_idx);=0A=
 >> +	if (err)=0A=
 >> +		goto err_ethsw_port_init;=0A=
 >=0A=
 > What would happen if the interface was asked to do something before=0A=
 > these two happen? You should only call register_netdev() when you=0A=
 > really are ready to go.=0A=
 >=0A=
=0A=
Indeed the register_netdev call should be after the ethsw_port_init.=0A=
A bridge join between these two calls would probably fail.=0A=
=0A=
 >> +static int ethsw_probe(struct fsl_mc_device *sw_dev)=0A=
 >> +{=0A=
 >> +=0A=
 >> +	/* Switch starts up enabled */=0A=
 >> +	rtnl_lock();=0A=
 >> +	err =3D ethsw_open(ethsw);=0A=
 >> +	rtnl_unlock();=0A=
 >=0A=
 > What exactly do you mean by that?=0A=
 >=0A=
 >       Andrew=0A=
 >=0A=
=0A=
I think this is leftover from an earlier version of the driver.=0A=
=0A=
What should be done at probe time is just to enable the switch and each =0A=
port is enabled on=0A=
dev_open as you suggested. I'll change this.=0A=
=0A=
=0A=
Thanks a lot for the review, I have some cleanup and also the control =0A=
traffic on my TODO list.=0A=
=0A=
Ioana=0A=
=0A=
