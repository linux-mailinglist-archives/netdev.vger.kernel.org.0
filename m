Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901BF279F89
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgI0INf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:13:35 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:11985
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbgI0INf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:13:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQW+MTemdwEGGO3s+K+lpQjHgdDy9BiQPix0CFm673J+o6lldJlTBtcWW9OkYBEr+wlRuvmd84OTyGvO6lU9Mnd8W9U19cRcQ1IP7MizfVVI0UuRZeu2yaHfgw1FB/A8iDmA28sLP/a2+ofbEdU0+wYHb3fKjNxv/A7i2tIf3mkQbLlzw7ANfB+3NmtSOix9jBRKEO2RPA4kGeV6GqECGwODLDUw/VcO4vbTxH3riMv1UDvi8ES2u3HAhiU34LY9IvEetxNcqZzxGxVY8blw9/WAHyShlDpkbq6EThx0nEn2f4+DRPjZH1/gKCxYFcKwmizoJe3O+gTlnaMqXyDm7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQsBTwpcTpKmtV0t0RMRZgYhgZ8Jema/bVLlwRvEalk=;
 b=jV12DMdD1pczC/T4CahNZbxuM9YxlTPKSG/++kZKRIJzjxs6BoblVfN/Myw8t/IuSSaKDqsSTE8w8Au8bNvUh8M6oVUlEWEEv89/hNMAzkLRE0vUVqZzGen0y4XykDdXVTfyUHvZawVMnOpauMidjSvzJFI5z1Y+LAU13eQDc/YrsD1mgprBk4yR3+rHC/EBKuvC+lBOfZQgCTLWzdruCAhN7Uz7/0UFXE/Mc2GNDu2zPatMMl1KMusLIBGDJ4MrmMD+IrBc6KvKOmxZLfDSUuJEClOuF6Psj3WeaEzw9PKwPB3gwcRrkzEbOuuKb5dtC2tvcEbhnIbhAlgXIVe22g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQsBTwpcTpKmtV0t0RMRZgYhgZ8Jema/bVLlwRvEalk=;
 b=ArCnWWd3FC88Ey05BJAZqhsIIvdmJbD+/5Z+aJWqTDch3SKd7JSl449oK9TtxykeYs5XcstS6wRNjun7pya/Mq6bdfKKv5uP0TwVhTwYyUVx9NtCChFaY+YnVx7PM19GsJCyJlpxWalMiCb92kv7bk5aIUyPZRHCfWTsLdTXWBo=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM5PR04MB3075.eurprd04.prod.outlook.com (2603:10a6:206:b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Sun, 27 Sep
 2020 08:13:31 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%6]) with mapi id 15.20.3412.026; Sun, 27 Sep 2020
 08:13:30 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: linux-next: Tree for Sep 21
 (drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c)
Thread-Topic: linux-next: Tree for Sep 21
 (drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c)
Thread-Index: AQHWkC3MBN+BZYzHxEqOSGzA5HTXSKl8K4AQ
Date:   Sun, 27 Sep 2020 08:13:30 +0000
Message-ID: <AM7PR04MB6885B840191C5BA936B6D085F8340@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200921192429.4c7aca86@canb.auug.org.au>
 <5c9dbb6f-a951-aadc-27c7-6d67aade4876@infradead.org>
In-Reply-To: <5c9dbb6f-a951-aadc-27c7-6d67aade4876@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 483f219a-330e-4ebf-2326-08d862bd388b
x-ms-traffictypediagnostic: AM5PR04MB3075:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR04MB3075669E16BB804CA081FF7BF8340@AM5PR04MB3075.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D9ygNTdfMRF4z4be118IwlajZIr1ysIIeBTLBMu/JEklEZIkaH0Og+4kCE0hyBb+eLckXvvpeiIcZ2yZO+766Eshnz+DLYL4GqJZiEEXw1olbUoOh6dly7cvgLwcDEiORsFGTflAICV1GEoRvpLdtgL7uHxqGFOJFLxOzjNtmPrsxgeODCQAcAVMcItuhNkI3jDZDBnYPST12IBIKHha5w6I8z7wJeYyEBMejhd9/j6pdtAh5G9gUSD94lKGKbg/zY0MBlRprN4a+t9BJZqIzgaK0nIwopG0Wi/yb2a5Z3IFOupXpjnJx1VB2jbC+DtOhk4KFytOdAeQvRGVKiDCOVkxWIJShKV4qEaazlaemMutEv1f8N23u6kL1UVQmjCKjF3OiX9Zx5vp1m18qFWczxfvFAwUS7QE9b68FcJSKPO46Z1ZydwMzyVePSILe+fbvXntZf+2pOC8sjCuI8TvaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(346002)(366004)(376002)(7696005)(55016002)(86362001)(110136005)(54906003)(52536014)(33656002)(5660300002)(2906002)(8936002)(9686003)(71200400001)(478600001)(186003)(966005)(8676002)(83380400001)(6506007)(76116006)(53546011)(316002)(4326008)(26005)(66946007)(66446008)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WjdJ501/363l6bVD1cLFamHQZErCDt5qVkzpl09dScUsYN9JV37hdLN7RFbzxeZ+zATc4Lfr5ZsKdz+1rSed54LvEhKKvXzfT7jr8+4k5YTcglM2WOrhcjVXH260wQPOoGFTfztVIoUO/uat5f8WGGdcuTcKBB71hYw1YhYZ6A80S4XxM+8dxlxq2JF+dwloKK7r/uebZrisnjjLsDB+s8/BW3q+eA7KGHmU0iJ3PhsNm3aDp77YICG/0LKd7ZU/3SQsbKX64WZeN78GYN52QeSstqZHMaRrXif/3wfaY7OJvNn7kXG7gwQECwjf6dAC4WrVHf2Q0GDA59d6b2EiLIK4Z+EzFVxCstcJGy3V0ErCOcDS2AGepSSvE6S0sIKp90WrdPr6dmsiyJV04wEK0JM+oJMNy4/dF3lT4gdlq1x4+tobdnUUwcENqEXtj9kVjqS2p3AOSkaBQwrOtBfS4N48ZCWHgRhybzlXm6oRbfPPEzskzvK3eq3OCBsRYXqp0aDdkUsZi/TUZlsEuj0Bttn0JDOpfs8f69sQ0BvIH1VYDfa1OxVOba2uPYc6zJ1gjGW59VmChwXpRmt+GwzVOCpoWOyGSvfrrXaf/pfb/uY1ovv9fBa26WT2FU9xuYAtv+FT93hEIpX+9FMpBZz+iQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483f219a-330e-4ebf-2326-08d862bd388b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 08:13:30.8664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8le136XE/o3ofugMIy2Oc9x0lVWpO06lHI1K0+VkTRHZVZww3T8eTbJ1eBnPD7dFHQ31/PlwsjKtBB1lvKhPHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Randy Dunlap <rdunlap@infradead.org>
> Sent: Monday, September 21, 2020 11:42 PM
> To: Stephen Rothwell <sfr@canb.auug.org.au>; Linux Next Mailing List
> <linux-next@vger.kernel.org>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>;
> netdev@vger.kernel.org; Y.b. Lu <yangbo.lu@nxp.com>; Ioana Ciornei
> <ioana.ciornei@nxp.com>; Ioana Ciocoi Radulescu
> <ruxandra.radulescu@nxp.com>
> Subject: Re: linux-next: Tree for Sep 21
> (drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c)
>=20
> On 9/21/20 2:24 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20200918:
> >
>=20
> on i386:
>=20
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function
> 'dpaa2_eth_ptp_parse':
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:585:13: error: implic=
it
> declaration of function 'ptp_get_msgtype'; did you mean 'get_fs_type'?
> [-Werror=3Dimplicit-function-declaration]
>   *msgtype =3D ptp_get_msgtype(hdr, ptp_class);
>              ^~~~~~~~~~~~~~~
>              get_fs_type

I think a stub function is missing in ptp_classify.h. I sent a fix-up patch=
.
https://patchwork.ozlabs.org/project/netdev/patch/20200927080150.8479-1-yan=
gbo.lu@nxp.com/
Thanks.

>=20
>=20
> Full randconfig file is attached.
>=20
>=20
> --
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
