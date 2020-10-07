Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4C8285CE8
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgJGKbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:31:40 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:53259
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbgJGKbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:31:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWj+YxcAhrISfZecs37QKJ2cziUclwdm2QRZ0/cAq/NUWnUa9lWU/oVJ0ktY3PgpmyToqdNPkGByhB29r0+yndwtnTjupbcZSUVeGukUcITlfUILhgIFCvhUcsfMshV/u6FUKqPQji3Cep6kQWpvKVbnk9MHVJT3YOYxYulGfhCdF7PDtDPMgNQb1OBkU4wRPvvUg0twX8K+y49MGoa6DbskmbyYMrSAiEYysYrgRNdq4zgok1T/BkVjyob7dFx2whIsu74fNyraj7tXGE6ATUDTsj4mj/T3EtEX2BagIzxtXWZKShSy80gbsyjk5iuRLKyY8z4l3vZlJAaDbVXmIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5I5xJzO+W/UaGyv/Nup4banfKru1HLvq1hiWqLMBDI=;
 b=ibkJfcuqZHUo5OyFotEVijwauLm1y3ToKyrYYLpXcwLFYJ58RCLPqzYCzDjy/L51GvkEXaq+jNRePhAfjZ8enLEj5RN3sPyTPuCYb1kIcHg5UfrudFV9mD9ogVXRVFkUsO14x4sl7iffM6F61Z1wldqxPc8QjaDAWcFk5oWc+gEoVreYGaXzN6HkhRSFpd044p3ONfLg1HrCycNCG3fhMbNTDP7d3nCq9Ao3j7PLRFhjhOfwZI+WbI1piK0yD+oNZWVbg+7IY3jwrwzwCGF7x1zNsSZcCSlN3ACIA28icbi51bnQYJ0Dwpf5oAW0MtrDJAlKOvHcDGU9m2Nz0e+s5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5I5xJzO+W/UaGyv/Nup4banfKru1HLvq1hiWqLMBDI=;
 b=pFNlQZ/wH34BcZDd5jnIG99jRx2xExUkoZOlWb47WlASzOAYdeAKQroqfqp8EQT2cr1/WAhyDXfhrzZ5/GFld8bViilb5NRayHsxHQfz5RSTZTMOmv3RVUYonMVhWr8bfrMimfM5FGOSzeVnFgxtnEUOXgEeZaXyBfADN1zIS/M=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 7 Oct
 2020 10:31:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 10:31:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 3/4] arm64: dts: fsl-ls1028a-rdb: Specify
 in-band mode for ENETC port 0
Thread-Topic: [PATCH net-next v2 3/4] arm64: dts: fsl-ls1028a-rdb: Specify
 in-band mode for ENETC port 0
Thread-Index: AQHWnI8IcHrTOW4nj0yuLRLwaBVdJamL8PGA
Date:   Wed, 7 Oct 2020 10:31:36 +0000
Message-ID: <20201007103135.ivhpfves3cwjfx2p@skbuf>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
 <20201007094823.6960-4-claudiu.manoil@nxp.com>
In-Reply-To: <20201007094823.6960-4-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 49edbb1c-0d47-46d8-517e-08d86aac2b02
x-ms-traffictypediagnostic: VI1PR04MB4912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4912393466E21F545306E5F8E00A0@VI1PR04MB4912.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6pHmBtCJpaXl1OD3JuGs7g5Oo2EQUQTEmhqTMQAPJ5Tk+gHWhQtOxu7JGdy5u0QwpfufNw38i5i30UKOnzONAzKscjIeUYQ3kuPDxOUHwWlBF9+8xUSIGLmqo8iru9bgusTaaFOktZjZxFNboC6d8in3B3YZAHiJxSdhOzNb7vHJfyyitFjnrPlKA/HIkdIPh2KaBifPGWhCg3aoc5ev8oGsKU8vj8V/uU7v7CDzYyjTHWaynxUROgfTBHwM4XHCLSUfpkrEkk8+eev2Y669oAen/j5NF+n9kK5pwBbJCN0PWL81De10TxAKfdlmUV7XLfeUG3NiK6gDpxKSomw1kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(346002)(39860400002)(376002)(366004)(8676002)(71200400001)(54906003)(1076003)(316002)(5660300002)(478600001)(6636002)(9686003)(76116006)(66476007)(66946007)(4744005)(91956017)(64756008)(66446008)(33716001)(4326008)(66556008)(6512007)(26005)(186003)(44832011)(6486002)(6862004)(86362001)(8936002)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Kc8vS9SYNcqHHftebpqthcCEzOYRrRDSuLXLlrU3EJXoFwmPbgvw13mJRgevAfzULDYlIX9BqbzBVhmrvRULrr6QAc+6zptBLTfiyH8V/WkpjTIiiU8q2565soGngWqJlZGYoYXUFi/FCSxzyrsejOXAR5Z/cvJdzypjgVCdTK2qY/BHDh6EsO8FhElWQ21Q/ADNmGhGCyDc0x343QeuewIjZjIMhQ9Hrx6QABhwwBMSn+akIyZDWr0+12tHAE+WDF4nlM1DJoctqrykOBRSC8nVzBhtHoD1JwKwnS4qZx0vsKIcRnEix5gHx5c4S0WQLv9tgmUPKFfV2WlVdAg1F5bwnG6SByTOTTqWLCgIGpciUlax4WBn+Mhq4olxq5ySgz8cZDgMcMwM+WzEkNgQJkv7Ty3n1+SPBz8PayzUleOP2qRBv733YklW5A/LCpP2hIFtYLkQmLfvWmXeUHKZez5JUwx1/NYZncr34nb22/DZkIRwlU7dHnWQ7Kz7DdmqYMYB4V7WDBDw5FRnrPHHsTo/l0LHjUDYAhvjl782uwwnzamw54hgy5g7ViaYb5o/82K7e9C1hfrHbodN/lPiFPbrvTkmcEwKUB8cARfoTjG5wyRafTrV8/67L5TvVonXzb5Vnn6xKxAxXnS0QNEQfA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC1A336827C3504EA1C0308021F32C67@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49edbb1c-0d47-46d8-517e-08d86aac2b02
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 10:31:36.0467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NG4o1SwhG9ZOUaCtsklbST8pYjHXeZz2jfkJyGFzLgbqhDZBYbscrGikm2yAs3pMvHxPK3qeh7M1fttuMSNigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:48:22PM +0300, Claudiu Manoil wrote:
> As part of the transition of the enetc ethernet driver from phylib
> to phylink, the in-band operation mode of the SGMII interface
> from enetc port 0 needs to be specified explicitly for phylink.
>=20
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> v3: none

v2, not v3.

>=20
>  arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm=
64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> index c2dc1232f93f..1efb61cff454 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> @@ -199,6 +199,7 @@
>  &enetc_port0 {
>  	phy-handle =3D <&sgmii_phy0>;
>  	phy-connection-type =3D "sgmii";
> +	managed =3D "in-band-status";
>  	status =3D "okay";
> =20
>  	mdio {
> --=20
> 2.17.1
> =
