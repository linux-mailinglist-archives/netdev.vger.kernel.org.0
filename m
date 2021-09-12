Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EA6407CD1
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhILKPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 06:15:53 -0400
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:62944
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229568AbhILKPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 06:15:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXhyTG2EmNeFFaq9Bq0K352cTcMDX1SZfD/gKX7gueKA258+Bcd7pIDWrmVTFztuvVtks/vpZZKmRxbmZrgPStL1szk1oUWX16PKDCKODX8vkC091n6WOq9Te1GYb4IkZ58kkVXV/OmDxMn3UudzLb52zRQrZX0a0dHPpTv3j4mG8f6Hc2oDsQeKui4O0jJfbDh7RKCTEzCE0H1IOwaSk1PCkKEXs6DyRtpTbDAq/zQk5FTe0VBYw409coqS/9Ety7PVK4YcA2ZKDSLpL9WY0yD2hp1bDxOTeGA4ee6EcCwJEozSjCXnFMDaXzHv0or9Yl/L7PtpenQYQ6Imd83Nng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BX46RYN2HT1Cte5GHoZpP2nAHPkvEIebLpcWfrx3bUQ=;
 b=kOGjsIP2wbnVoZgyxBJA8yI1nTvM7pr90f4xviJs0iESDdGjOjLOxhuCxjY4V50Krd8f/N2EOf+/v41MN+D/H9uUpHN6QggoA5cT/etBXX4fv1xvRzN/ZmTZvDHOpWEW/C1V6eOPa4Wp+coEY+kj+gz0bL+YmxgFf8j2+SD5IhWohLeXQj9+pyYiwEPfftAhMcR/fPZqMbeRQXXxNgH3BdTa2P8C5LBonnHHiZUkrQonScHgndp9aE/m02rT0gR+QFNHvgEc+9OWjD9rexbXZm8Kao0MxRWAQkwF/0WCxKEpBjK4C85/OtNKK9H3f9n6vZ/rVhJaj+6Auw/sFFrdZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BX46RYN2HT1Cte5GHoZpP2nAHPkvEIebLpcWfrx3bUQ=;
 b=iBq5fImSuFnTlBAlEkWy9p5zHzjsVP2NNdd0gRLtKNHS2OPvLbmpdLDOQDF2pMxxmDUOeI/pKnLLPW8ANKhjSf+jzKFPKLNf9RvCbBqLBI/W0wFGUijd/zUmp+5lcJzem6UfvAmNShl+RJTcX9VnSC2jcRSQgYTW2y6m6NCTHKQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Sun, 12 Sep
 2021 10:14:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 10:14:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH AUTOSEL 5.4 22/37] MIPS: mscc: ocelot: mark the phy-mode
 for internal PHY ports
Thread-Topic: [PATCH AUTOSEL 5.4 22/37] MIPS: mscc: ocelot: mark the phy-mode
 for internal PHY ports
Thread-Index: AQHXpdnoz9fi1RBYPEig4OnDY7Pba6ugMkEA
Date:   Sun, 12 Sep 2021 10:14:33 +0000
Message-ID: <20210912101432.6ego3nlw7q6h33yc@skbuf>
References: <20210910002143.175731-1-sashal@kernel.org>
 <20210910002143.175731-22-sashal@kernel.org>
In-Reply-To: <20210910002143.175731-22-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 713f39ed-ed13-4a9e-6fc0-08d975d61dda
x-ms-traffictypediagnostic: VI1PR04MB4686:
x-microsoft-antispam-prvs: <VI1PR04MB46869CE30254BF42E2E0303DE0D89@VI1PR04MB4686.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQrUBm4+PyqdXi7FxfELNLn7K7KUjlEJReYpFsKE4Q3AA6EuXEquaVr0wFHXJJI1GyKHFrHgzr7p2ICwG3MXjUUmGSnPL3tTEohdjZC5zU4Yt5b4OkFN34Bi50db5kDb0mQLF9Lw7nLc3I6h8KZHpw+MM7WCdQzWhM4Y/XEDTEd0+BH3BcSwjWgtK4kciFM/OEdQwYuO4+s13Mm6fg1be5FBiM93NXhIXWKhJZUvLHPiSEgsEQh7gRbYtMWxkx40nN2ELTobcmyjxRJ2HCJjVN4ththsK4TKo8W7fj2mG+NUsxG2X7faShyIC0/tM5P7VJuPh4Hrhg03irq6JcSJsR02iJW5YSbFiX+fnJgKwFHhdh313JO7YwUZLhFClSI7TEtlBudCDGCvu57+GODuJX8yUAlLm9qo9qDDYWvmsmP8/x7GM2UGLOhY3Vjw6DT4mjKrbkJ4q0tPSQ8NN5AVbwYLMnqg01LOuMd6sd45BMsJesUS+zy4j+cHge234F3JvkQUztKc9NrkYUBzIQmOuyXoEIyNNi3YR0VI63EJtxeFQRtEwWL81etx4i0Ow7mqhD1XwIik3GqqmgbfMRjWsiohtjM2N5c3CFFT/bNekSGsEyaiTsDHJSuZpR9Wqj272sDcmPu1fWSDqhddwoKeu6a8e4fqhVqO5qa6r535Vc4t3ZQiLUEaon1U2eqe1EsVxWHe5gDnFqFVRF5R0HsR32w1lpD61GYHwmFJLPmuxcX4NrDyO88k6ymFfHp7Pb6OaMeIemkeCRnGRXeHia6L7o4EbEwrrX6a6gmB774LKM0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(44832011)(478600001)(186003)(1076003)(2906002)(316002)(6506007)(6486002)(76116006)(66946007)(122000001)(33716001)(26005)(66476007)(66556008)(64756008)(66446008)(8936002)(4744005)(38070700005)(6512007)(9686003)(86362001)(5660300002)(4326008)(8676002)(71200400001)(38100700002)(6916009)(54906003)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vv7dg/CAIWgzaJwvb6i0C1IVAN8fAFey1eBtN2EnQ7W5R6mo36QNCY2XwvWX?=
 =?us-ascii?Q?swQUAij82wFqyjOrLFrmscUG2WhlIpDTdr4Np1XoMOpic3C61noSQ6MAYXmz?=
 =?us-ascii?Q?7tdhreYxM3/qE3/f3J7lUzpclhciPDAiHqoF9UEckzy7bzcj6s8Om+DZ/CXU?=
 =?us-ascii?Q?y/Zkw73CzrgOUZjIMxTcB5CtdRuyKvDf7PqXqDyb78QXdZaDW7PSnHjvNVvC?=
 =?us-ascii?Q?hJAf4wU8NN5pa3HdssU2P5KX7aS+jc2ntsP2jGOkYxIxJtRS+OTDistk8WUO?=
 =?us-ascii?Q?KP2tRvt2o8XctLd8+AyCEEyrkqw3d8pLsKg6KdKy4lmNNmfvu/CtzmQO+J11?=
 =?us-ascii?Q?OYmw1S6ekQK/I3k1Iih7cybGH3lgeo0gNuA2KVsGiMY9CGpbfiKKUjrG4rfj?=
 =?us-ascii?Q?EY2bzVHTxdrVkRh8PJ5AzCt9VlfHpivH1W4Gtzxdggr9a43tLZpOsEXk2Xuv?=
 =?us-ascii?Q?5cFqGzqyXkNRGYa96Qfe+8vInGukuhnRz0l5OI2cNronejjLRb/VTK8XSHVg?=
 =?us-ascii?Q?FF1S8j03Ql1qIew3K85CbpRT/DIVJQD1WgdI8sanqLLnW8tYIuiam2FyO737?=
 =?us-ascii?Q?QUUBED76Bi8iYmxNwPb/JlC7zpS6UqWsQdcuXk0hrjI4cSjAdErXOnzO+mAT?=
 =?us-ascii?Q?B/CYixq+pbAKsaVYaHG09hnv9bwiH/tBoHZOX/Nx5wJWkJlQugyfpkDXWFA1?=
 =?us-ascii?Q?IHsBa5yx9fqbcnAE7xEg9oC/jikRwBXDw7A9gj1Zh99r2M5EBWLWfD39MzxL?=
 =?us-ascii?Q?gADXcDzv3jEOtbwu91tD5+Stx+j/3yGUX1NsiOcxz7wjO7OTIa2G5zfnscx7?=
 =?us-ascii?Q?mJEZ2OsUayAQcNTKtgImu9HOBHu+QlC1sSpXu0cR4r1UtYFxIOPi9fH92BrB?=
 =?us-ascii?Q?4v1vK9fWV/6laNXYrsASp7CIusO9EASrZQuvaAoPWXJqCOxGG02WgNEpzg2O?=
 =?us-ascii?Q?3Sopmytne7cuzlO1hDfdfTFWa4uEAtCUPhFAnsQY0AdL5ALaQyj8Oll8yCYn?=
 =?us-ascii?Q?H8WzfDqMCNKPrRrvYIf0/6Sora3IpMx722rKqxMVaEn/XlK4GdtK4hfClvJh?=
 =?us-ascii?Q?ty7/TfLGnjQ5DQ5kEHYo18402RA1lNm+x3VHmRbQ/jgJpfHfZ3TNPI9+3KgI?=
 =?us-ascii?Q?2I+6cSXDTwNcms7nsxECZighYV2ee2lPeUJAG1d4KQf3FQbLVIQkqDDUJqR2?=
 =?us-ascii?Q?WyrPKlpDUGcAVxFioATuvpydyMc4N7nYu+627oqqpYZb592TQe6+4/Xm07El?=
 =?us-ascii?Q?jkG+MiNWcWwLRDmHnV7d60Gw/o3GsNtdo5gXa2Hfjp6SxDzEVhSw3ep3Ml7I?=
 =?us-ascii?Q?1Hsqww8uZJPS0gr+xWxAOsXW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78E94934732A274B9854B27D454E540C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713f39ed-ed13-4a9e-6fc0-08d975d61dda
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2021 10:14:33.2852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4kp0ggWfftegRTcJO5jMKC6xFlIzuBWxzHuaJHijVQERJcFYyVWznv98XYCqXPi7yOdpEoiXs6e4bJNXwRqmGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Thu, Sep 09, 2021 at 08:21:27PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit eba54cbb92d28b4f6dc1ed5f73f5187b09d82c08 ]
>=20
> The ocelot driver was converted to phylink, and that expects a valid
> phy_interface_t. Without a phy-mode, of_get_phy_mode returns
> PHY_INTERFACE_MODE_NA, which is not ideal because phylink rejects that.
>=20
> The ocelot driver was patched to treat PHY_INTERFACE_MODE_NA as
> PHY_INTERFACE_MODE_INTERNAL to work with the broken DT blobs, but we
> should fix the device trees and specify the phy-mode too.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Could you please drop this patch?

As discussed here, I did not bother to patch the ocelot switch driver on
stable kernels to support the new device tree binding too:
https://lore.kernel.org/lkml/YR6b15zKkjWFoM1X@piout.net/

So backporting the device tree change would break the old driver.=
