Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC4F7AC68
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbfG3P2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:28:20 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:24899
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731021AbfG3P2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 11:28:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9geLBFU8NT4yOq5XtIp5USab+ejOVUwGuxJ34kS+X7psHo9hM99+KA08JLPBoLu334282msNCDl7BiMy3Dqj7Knds/JC75F4K/WRqyC/pKvB3EZIdm9S4s1F+VtpVj2aeulqq7BQYxJQPTKWdSfMxGGmLDM3lNuVHBlSnhCz3Bxb7QWVmp+8n2ZCUjVkTYjYBQeh+Kv9Apo4BJbdr+/3Xxw+cdQCbMyEyJJzcdVjPca4JxtCjubRt9KYhGH/iPFce/GspCXuy3zMg0nN9ETkG+5egThDux1q2YO1VeRYytw59aaxV22FkwYNIxGZDJwgERouDHNlqRG48tgvUzvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKp1rvLlRa+aSLPokwjQfQ95CU0nnyosbju1axMrYx0=;
 b=TYcB0Qf12sLzEDyT7jhlRwd9kcL0rHYrWK9ms+Di8f01K+5h0kLQbRBQxIeiNwjoCbTaipizQOFNjkd/xoEJlxshYcX76udV+vKszGMOykikjwGpjMuc9bCVTvvtbSwoc/tiF4zU7cEIekVJ3rSr/S2Ltk0iko55hE14HtQcgF5NKIc04hbXWiK+9D6PWeFH6JRY2/+2aCWsgQeHHZAlrn8H88N+OEO13+VaRkWDfo+eRzHqb7I5bs7F+HZIgNad+RG6HUunkaUFFstjmu8FuUW/spbGknMJ7fiW+xQ/BxSab9xl+rYBHdza+zk94MuGgeEJtbgHQGo9YzNJHaAs1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKp1rvLlRa+aSLPokwjQfQ95CU0nnyosbju1axMrYx0=;
 b=q5IM+Db+jj1QbVwCamBqvhTB4uYOICAYXsbAqUaf2uB+4poKS7ltTOEmhDRZ+0MWIrmwUXsNBD8Ns/bAMLhuC6NJE0CaOVQCUZS9Uz1K3/NejqIvNPB8TO3PptvGIGseyj1cIiRX7MlNLy8zpzaCItE2jatC/5tmoV5/y3lpmnY=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB4847.eurprd04.prod.outlook.com (20.177.49.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 15:28:15 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0%6]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 15:28:15 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] enetc: Fix build error without PHYLIB
Thread-Topic: [PATCH] enetc: Fix build error without PHYLIB
Thread-Index: AQHVRuN4FvRC8RANFUG8NxF+oLMasabjRz7w
Date:   Tue, 30 Jul 2019 15:28:15 +0000
Message-ID: <VI1PR04MB48802D5D08728D1392F4308896DC0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20190730142959.50892-1-yuehaibing@huawei.com>
In-Reply-To: <20190730142959.50892-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 404eb395-010e-46ba-9e9f-08d715028ac5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4847;
x-ms-traffictypediagnostic: VI1PR04MB4847:
x-microsoft-antispam-prvs: <VI1PR04MB4847605F93CD40D1E280432296DC0@VI1PR04MB4847.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(189003)(199004)(13464003)(7696005)(478600001)(52536014)(8676002)(486006)(256004)(446003)(14444005)(81166006)(81156014)(25786009)(86362001)(5660300002)(11346002)(66476007)(4326008)(7736002)(66446008)(44832011)(6246003)(8936002)(66556008)(64756008)(76116006)(68736007)(66946007)(2501003)(6436002)(74316002)(229853002)(76176011)(102836004)(316002)(26005)(9686003)(2906002)(55016002)(476003)(305945005)(33656002)(186003)(66066001)(14454004)(53936002)(71200400001)(6116002)(3846002)(99286004)(110136005)(54906003)(71190400001)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4847;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PN07bS8P45YDKPnNfigQo7sAodRoeEa1Q3+HxQLjRiTJVD5bDOhy9N2KqFWbgdOoFa+e4mG0yt5oDqxNOYac2IBEgjumjQDGEG5xoojI3/FD9kCT6XgTdkbDa1oeYn12pKdG9KzpRPGwLHHgXo2hikzOR3Q9fIBlhHCqOpim8ywjAsdzzwdWyFpdP8epWwEqPYDCaC5/C5KHkdEYAOsYhc1jsa9F8q/+Hpj36ORIAztDKlHgoztwsRgrv/XQD0m9WMW0JzZucDYj9JGkoy0rzdv0RQEP+Hm0kykZlUEAkiD7GswXwYqeDjiAUKG564qjhjPt4XxJEh+5vn5JUlwuXApAQalgGhcQD3WTnXIXsXfm0BXYZrQ4HBBwUewdVsulbYRrwVPJ8g6zRPjvH+JdNL+3ySIkNpj2g2xdDu60LFk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404eb395-010e-46ba-9e9f-08d715028ac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 15:28:15.7340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: YueHaibing <yuehaibing@huawei.com>
>Sent: Tuesday, July 30, 2019 5:30 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>; davem@davemloft.net
>Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; YueHaibing
><yuehaibing@huawei.com>
>Subject: [PATCH] enetc: Fix build error without PHYLIB
>
>If PHYLIB is not set, build enetc will fails:
>
>drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
>enetc.c: undefined reference to `phy_disconnect'
>enetc.c: undefined reference to `phy_start'
>drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
>enetc.c: undefined reference to `phy_stop'
>enetc.c: undefined reference to `phy_disconnect'
>drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference =
to
>`phy_ethtool_get_link_ksettings'
>drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference =
to
>`phy_ethtool_set_link_ksettings'
>drivers/net/ethernet/freescale/enetc/enetc_mdio.o: In function
>`enetc_mdio_probe':
>enetc_mdio.c: undefined reference to `mdiobus_alloc_size'
>enetc_mdio.c: undefined reference to `mdiobus_free'
>
>Reported-by: Hulk Robot <hulkci@huawei.com>
>Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet driv=
ers")
>Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>
