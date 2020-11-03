Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC072A4BB5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgKCQha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:37:30 -0500
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:32790
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727688AbgKCQh3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 11:37:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivx2lITx6p6Ep9VFDju64MmTw/FrfhwqGmqMpivCESnUeY4lJXLSJWRnUWyYxC3Cmwd5LuffEyc3nGGwN1PeheRr3kXYx5ZFR9zvT7dV01nwvnyBacXil5fEKSOT5JHCZOquTo7MCyNVRAD1YsOHqCFF8GgUoMwJB1Gtmp5lO/GGXlE0zOqOEF9DBrBR8F6dARQTUApfD4hdaw8DPCOT2mYPiTx0EeDGQ76fQJfH8PS5xWbhp7BhlYYS5AIQGRDkNG5Pj/FKxBM8wVGPK+GglL1zRLy7TjJKetbHnKxK+pPE5OJEwSbU3qp8+gVwaYBzXD/IYKQ0hO9hLoBs5+97pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFdzf3oyz9Glb5dYfuk158AQoa0OJW3UN5g3sK4RRwo=;
 b=G1ZAd0C9t2pMgKU4QkmkewEYxhaISbK/uGvlcaYVkZlcB6vX4C+JX0heT4EnljgvZ0AQ0m9nTUT6GvKK1/oNcxypqnU7MWsrOWYT+3hSg+oAQ14Dve7dNoN2d1Blyq+hLNHox6LBgmSuYmwVeFl4tDbWsWWEWKvjoBsOTdgjSu5teING6dRU1jE3KNWtfKAmTfI/66SE5V581vlvsGhS1er87KN8VxeajiHN5gz9leweXsDkG/3KNtXTScfFRxAaHZGAPhopsdoRjhixbokfSZ05w9Rk5Dw1oawH3kx4ve5laBWlAiJG0js7PxycJmGYID8VApk7cJJRtJPGNlhxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFdzf3oyz9Glb5dYfuk158AQoa0OJW3UN5g3sK4RRwo=;
 b=Oedlrfx+8Hxedcy+PJCydXJeD8GfLQrAYFr/S7wdusJAsEQ/2Ot4gTR5QJbT7Xetc6BavdgDTEJNelg62SZJE+sAAxZjyhwg+aJB5vw49QK3Cy/o3SOe9a3qAneCkMiFn64ND2sz8UJkZ9fqfYqZIeC6ScdMPPKXug7YKRGJAfo=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3453.eurprd04.prod.outlook.com (2603:10a6:803:6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 16:37:26 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51%6]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 16:37:26 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
Thread-Topic: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
Thread-Index: AQHWsUbTq09p7ZfpSEicfYj7MDbkSqm2luyQ
Date:   Tue, 3 Nov 2020 16:37:26 +0000
Message-ID: <VI1PR04MB58073450C08552820A7755AAF2110@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1604339942.git.camelia.groza@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b5f2d56-2991-4512-8abc-08d88016bf99
x-ms-traffictypediagnostic: VI1PR0402MB3453:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB345314E9B94C185FD5CEFAF2F2110@VI1PR0402MB3453.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ueux0kFNcBlahKT+cw7MSEwi+nSmqhyU3KQIbKlTGVl8jlqaTpUbcf3QMcUe4PVycyAXH4zhROb8NU02KvX09E7JjdwT+CPJqjupNLzgz6cPRvPsYYBgPPhxcIfgZGpGw110PwXnKXbQh9GAh4qJQw9Ecj4OhvtpIxToqPimCEiaZrfobKOUOT//ol0z2ayRTbhhXE0crr1cIBdQCuDBrcfNxV+y5DW58uF5EwQBf5fGLE4fd9LAhpmRQD09ObhC/pC5l8f6MiQIAiHHObZhBHAYCcmj1mLRsU17BnP7EcIDpbOJ0jGpjUV7MQDtUPHDGVphZiC+7rTXcvKQFqeWhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(136003)(346002)(376002)(4744005)(52536014)(8676002)(7696005)(86362001)(8936002)(55016002)(2906002)(9686003)(5660300002)(66446008)(54906003)(478600001)(66556008)(76116006)(33656002)(66946007)(64756008)(316002)(83380400001)(186003)(26005)(6506007)(4326008)(71200400001)(53546011)(66476007)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: EV5A+WIfVuuMKm4iZjVXMiSpUc2mQG+zJu0KlXWY6xvupVhZtGUv485scAj2MHCksPhTZmf1o0R9D4iqj0+LF+SwAIGVqabNp7f3agOHmSdj33V5d9MLRlWNFG4uOjy5ZZv/ugv8Q7oF3wypBkSQB9Ar/6yZtdUA8V7G2iNyoOmK3RA/uXt3PLZZvJpeCaBpHrheVDjq1H0CswNEKy2c2urbUL5wMsvA06kLY1J/fs6oHZkTIVeDLDe1tRxXwH/Y70go6PaNjbGdGJXe5maphW72zO9SN2Xh/zLkGu5ypsb0f9DJC8bUokMTAuhsRLE5XnK5aHCeM7uDTPBgO8j95z0/vzSz+TnRLOkYXAskC4vQiQBfpZVlBDnZW92+DS86MtYuiIxgRqz88O9vgmMxaTPTrFr3TfsPyEo6madbf4C2LuASZSP2cO41TXUMN9TWblYKqAXpCVo/mQt+hI/FEtt0pwiH0XdK73mRWu6t1hieCxHjASPm01KBlG+9GSj3aZnmEoft0oXwYfWDwmKuRDC6ynfQo5tl7s8KC/wpv9SX7M194XSsmvBPwotX8h2L71/cQEAjKZCJVuY6y8+LSIrz+lXrL6mcMtzvgeXer4r08A1S6jJqTr0kyZjgibm/cdMqcHMKmgi2kIFdBmMD5A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5f2d56-2991-4512-8abc-08d88016bf99
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 16:37:26.3792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SITm/6p/4lTepexfLjicfswPlAPfj7zn2A3PPB8kV0pgMkEueaE9DEvhf4CsiWIKsqhGAxmPiDKylmHSqiyZeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3453
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Camelia Groza <camelia.groza@nxp.com>
> Sent: Monday, November 2, 2020 20:35
> To: willemdebruijn.kernel@gmail.com; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; Camelia Alexandra Groza
> <camelia.groza@nxp.com>
> Subject: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
>=20
> The patches are related to the software workaround for the A050385
> erratum.
> The first patch ensures optimal buffer usage for non-erratum scenarios. T=
he
> second patch fixes a currently inconsequential discrepancy between the
> FMan and Ethernet drivers.
>=20

Jakub, when are you planning the next merger of net into net-next? I have a=
 patch set for net-next depending on this one.

Thanks!
Camelia
