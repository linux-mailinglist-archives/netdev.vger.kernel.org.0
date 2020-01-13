Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E89138BB3
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 07:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733187AbgAMGMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 01:12:16 -0500
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:55264
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726480AbgAMGMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 01:12:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgpfADQ+/wH241dxTjK/KfEsCyuENM5EAZzc1OBu2OVTzCUqCRFeagUCqwT2GuJVXMGGJQIHt+jnLzoNFs0GeKWOj+1MFEeTdFFv3NU6VGSAIqxqEm626AiBjwZB9WMY0OIu0cC/rWvX2jFwaSKb8s4ddNAfKrAcVG0i99NIDQVa6/Szpx31v/UQicHNvXhuGm6LeMJOnuvCTtG5KaI+j6ZQkJVPK2ZorefwQS0PIQSLYhzOg+HHCV7yKUyPLhdLa72FEtGNWvLrHYgE3QIAQCIw8dzelZ1YGKyK9k2EPSs/oH03CFL8PFZDeMuvdztQ/EF//RUvbRGRYBYmjEw9iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeLb/RbhQZSDQoQJ/eWbzkLqeR8+z7ElgOb5/VTxEy4=;
 b=SazQKbSjnRxB1l0+IhrBd/Glu3Kn4g8C2Y0MwSS/xF4TbkX+QnW0Tzn10FNnQ4zMh7H9OEBVEDML7hMLqaYtASW06fkSomZeIbscZqkrnHi6MxN2V7nFzgO2SfNG32SPK0AsygGcCCTjzx8FIQNdQ3OsAAKz3mMLyXHwbjNp3me3v/BHZNziXORaJrx4Uv5eq8OVjza6kd5kvpZ0I6DFcY40MRWt9mVu8q0BZ6mSAtknxUKNyTXyZ32wLKsS8SIDINC7sBMOhAIRDQxeTMEgeCm/BEhaV2WnUWM5THFvWQ11Qk3HDxPzenHYxuZVxGuo5mwKjFV7vou/DPlzCge0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeLb/RbhQZSDQoQJ/eWbzkLqeR8+z7ElgOb5/VTxEy4=;
 b=rOewxgNJBGSrO4m/zZCEDpQohiIBCtYRL8iDhw/MmSN5qMsDq/DWNU6doUcNTR6tF2n0/YWHkqHvqeoO9AGgwGSVUMlpWLNBwNb8/9u3e19YuOLBGWY/myscifw1YlxnSPPxL8N2nBG3VOc4BdTVzu052mVpADBLojc3HHkB5Co=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6632.namprd02.prod.outlook.com (10.141.156.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 06:12:11 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 06:12:10 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 09/14] net: axienet: Add mii-tool support
Thread-Topic: [PATCH 09/14] net: axienet: Add mii-tool support
Thread-Index: AQHVx6y7unY7S2F2T0yZeT1nU7iHwafoHtrA
Date:   Mon, 13 Jan 2020 06:12:10 +0000
Message-ID: <CH2PR02MB700089E502A8C146D71C67C8C7350@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-10-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-10-andre.przywara@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 632de85d-79bf-45d1-7c2e-08d797ef86b9
x-ms-traffictypediagnostic: CH2PR02MB6632:|CH2PR02MB6632:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6632377B72E13B34F18E0567C7350@CH2PR02MB6632.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(396003)(366004)(346002)(136003)(189003)(199004)(66476007)(66446008)(2906002)(6506007)(53546011)(26005)(71200400001)(66556008)(64756008)(66946007)(76116006)(33656002)(186003)(7696005)(86362001)(52536014)(5660300002)(8936002)(4326008)(81166006)(316002)(9686003)(478600001)(8676002)(55016002)(81156014)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6632;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mY8ne1LYocl0i01S7yPGT+XqI79esG6e25g21897Yq/JGrLZ+wVgzB0deudikyWvPpifw18t/xHnktc5IZe01fyLLCtyIomyr2yDm8+ju/EK+IvGxRZxLRukQ1BzVJPSfM0bZST2KjwLgZgv9DgRSOKE91/xspXGRkXue2Zmwi4xfHtgHBtl+xN50+x2XOWsboDaUicofSqPPVNVCM7/zFZ99Dsc4UiSTDWDP9AiEAY45AfbqLj5+6h2tBrBZfwd12wdXrX8U5xD/bVBrqJeFGmnTCMHAlbMgOQeOieYgCbBEdGOmdRfocyy/69QBYgQ55eTmJI9AkSeZRE2egiDXGvJGQLjsb8Ru51OEGkdcfBTVaJx63+pl+EjOM4ODJ5hdv1flEs8RAYLKFAtFC5Ap4slXJMNaoyg7o//Nqodhz2Md2FBcTjVxQW2Q5BhEeWG
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632de85d-79bf-45d1-7c2e-08d797ef86b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 06:12:10.6558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Q8RWQR1U/j7avijrcT4EYIpX3ydu0hQIE/3PBCVWxsRVxLg0E2Gb95//5EvwQDus8P3Zn0mqG4rwJ9iNREjsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6632
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Friday, January 10, 2020 5:24 PM
> To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 09/14] net: axienet: Add mii-tool support
>=20
> mii-tool is useful for debugging, and all it requires to work is to wire
> up the ioctl ops function pointer.
> Add this to the axienet driver to enable mii-tool.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 7a747345e98e..64f799f3d248 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1152,6 +1152,16 @@ static void axienet_poll_controller(struct net_dev=
ice
> *ndev)
>  }
>  #endif
>=20
> +static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int c=
md)
> +{
> +	struct axienet_local *lp =3D netdev_priv(dev);
> +
> +	if (!netif_running(dev))
> +		return -EINVAL;

I think phy ioctl should be allowed even if the device is not up.=20
Or is there any specific reason for keeping it?

> +
> +	return phylink_mii_ioctl(lp->phylink, rq, cmd);
> +}
> +
>  static const struct net_device_ops axienet_netdev_ops =3D {
>  	.ndo_open =3D axienet_open,
>  	.ndo_stop =3D axienet_stop,
> @@ -1159,6 +1169,7 @@ static const struct net_device_ops
> axienet_netdev_ops =3D {
>  	.ndo_change_mtu	=3D axienet_change_mtu,
>  	.ndo_set_mac_address =3D netdev_set_mac_address,
>  	.ndo_validate_addr =3D eth_validate_addr,
> +	.ndo_do_ioctl =3D axienet_ioctl,
>  	.ndo_set_rx_mode =3D axienet_set_multicast_list,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller =3D axienet_poll_controller,
> --
> 2.17.1

