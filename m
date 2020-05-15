Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A901D5A08
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgEOTbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:31:22 -0400
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:64833
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbgEOTbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:31:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Suhs4MSSHG+yULELwhsHUWFcSTZBgZVTOT5zPmkc/pWi3nNLR80SPbKA4mlLLakJnNkzHgH0ch0tWjtxWjcCfFISadHuWYQdEiAYR08yw1nZzYIJJCWbeF5AL/YHjyeEKwoiIz/JeEl5mSAcpKzrYcXfpGtfAQ0LPnxxLOA3wijUSt3anrVUKDjDw+jiwEvJijL+usg16FoIOn1h8w8EjtAYrjEkXMwdrylGajTjyWGOBJVILVb3FGCNF+Sgtx06YiIwZ7Z4v9b2sRYJybJD3gAVxu9f0bTp/CK/Oki3LG2GRW8ZrN1VVG1LuyxdLelxfMuYf/ADbO601gToZSw3zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYBfs34HUPz0PonL9oE5FEzoj4AS0tgbSZy6AbXrads=;
 b=mWGf6OxPQ6Tk8Yj2+JRfhJ33l41CcxXqmiVq0SAdvffgrK1yzbJ/JQii9S1RdsKK42XZMv1d+htMTgTHvccw3Yn2oky/lgGKf55VS08wrmaP//Aoy7uh0YRTrGx87sS++DmNDx4Ywb3dNOcu2dKfR5b5yVJTI3eQMJAsGoKkc3b+IWWVUcZ/97v5YOcRSVqungD+cLHja8Nj5XnrJlMqSKaj9uf30MGp7hHeQftMzk4+0g66eNBxnOT0G1l6HbRai9W2uBT6BcyRgUqdcUdtVFuuM629RzonFXfgCdvd+S+tuEPCqau24OT15Qyklyw743CeoywlhIPiLQh0ndI7Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYBfs34HUPz0PonL9oE5FEzoj4AS0tgbSZy6AbXrads=;
 b=lugHkAXTjr8BWw5eGvKP/sxZoIK1kl1EVtSk45ECR79sUoqts1K8KOu96+P3rhY7hlUklZ6RmCcnLE5ejL0CKckaTPD9aim5Swl2kM9iDe/r93qSrWsUaUsf/MBFxucqp+vHUkYtD7+nMG8V7NjlFWUxchjD2E1WF9tlA+HC5CE=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2894.eurprd04.prod.outlook.com
 (2603:10a6:800:b5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Fri, 15 May
 2020 19:31:18 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 19:31:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOEA=
Date:   Fri, 15 May 2020 19:31:18 +0000
Message-ID: <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
 <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16189941-9015-4d1d-bc66-08d7f9068a6a
x-ms-traffictypediagnostic: VI1PR0402MB2894:
x-microsoft-antispam-prvs: <VI1PR0402MB2894733763E676132D86EC84E0BD0@VI1PR0402MB2894.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HP0GwVW2dYL15FcSH4A5QOPLVjYUS/rq/9Mvl7p3vN0KcLOeC3l/I4u45zDklUkuw83rx7s/qlAJpaXNoyQYG73/z/shQ06ezOecObGg/J0TiooTgo2YianbEB0/IknZsTpxB/dlj6FvR5leAJaJ2JmzyeHys0l6+L3V5oogjt20H5fso1AcoofIL1/+OpH0Y9lCfYvuTl0g5jv+d25hXlO/JLu9IlAlmNoc4lSx2rzJ4EtkaZ5SCEKGzL8TGsRkp5/H0yrFKvqoSRAzKpUtMZTyN7+vh1I/w7HA0ldK5AUH6JFVsMVl2aDmWDEVKaVd7KJ7PZxZFVxZ9EbT2lZv7Lrbp2W1T3zhFsurq6VljbggpOd+fpp7ta8JkZ0tWF+pSZSBMYn79XuUS8ySPfkUEZtTNUGJGtTLGMQ+HQszxnV8nbeC01Y4BuFowgP3mv8I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(6916009)(6506007)(316002)(66946007)(52536014)(478600001)(66476007)(66556008)(76116006)(186003)(2906002)(66446008)(26005)(44832011)(64756008)(54906003)(71200400001)(7696005)(4326008)(5660300002)(9686003)(55016002)(86362001)(8676002)(8936002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sdVZmubAuL7uPBnFoClfxoBDinYclIymGhCo9ZBixFwMzyoi5FqPDho7FS2PMB2+P7L8ESPNsnYZzS3lAHmBkoV5LmxWkc+luqpk4vz8c8Pww7h5BWBDRy9nRo4NTFpuyeQ/UkpLj3txrkjUaAzziFkhoNJzI448jtOldj7VSUQqnPzeMWAQhNeYudWrzxpJDOh85gPoafzPCj6/+4aOjz+E3SiRKWWYyrXNB8sSLX66blustin0rdZ7KaUFEGxq9Epm2HSmRL6BZl7gSxa1Sunduewx2XN6+B9uvwlz0L7L+1yBwv73vXsyTp4uLFX7wIP29xiSkfGSJ5Jz5cPGhBaRnt2yAvqYJ/dq6P9b0KMYhEk1bDe84KDpIPa2lFeWE4OcRVE5bFt9BXSH7QMXUqZQR+C7p1spjwMwejl6zeAE1mF3b4icymvzpVd0UcQCcdBvYmgVU4PpJuxnBGL18gjd6rcxz1sNY050V+eIOcg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16189941-9015-4d1d-bc66-08d7f9068a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 19:31:18.2366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2TF3SEN5AWRHWL5LR70+pWpchbJWHQuFsk7dacdEFsAMEPGNXcSPCGZg1U5VlM06QaQhNQXMNtZpe9XHAKTqqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2894
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Fri, 15 May 2020 21:47:46 +0300 Ioana Ciornei wrote:
> > This patch set adds support for Rx traffic classes on DPAA2 Ethernet
> > devices.
> >
> > The first two patches make the necessary changes so that multiple
> > traffic classes are configured and their statistics are displayed in
> > the debugfs. The third patch adds a static distribution to said
> > traffic classes based on the VLAN PCP field.
> >
> > The last patches add support for the congestion group taildrop
> > mechanism that allows us to control the number of frames that can
> > accumulate on a group of Rx frame queues belonging to the same traffic =
class.
>=20
> Ah, I miseed you already sent a v2. Same question applies:
>=20
> > How is this configured from the user perspective? I looked through the
> > patches and I see no information on how the input is taken from the
> > user.

There is no input taken from the user at the moment. The traffic class id i=
s statically selected based on the VLAN PCP field. The configuration for th=
is is added in patch 3/7.

Ioana
