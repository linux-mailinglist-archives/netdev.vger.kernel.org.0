Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A11AF12
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 05:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfEMDKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 23:10:17 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:37127
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727148AbfEMDKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 May 2019 23:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsWCPDUZcYuuHwUmAyUc6ABqBcp8ZOJOZDKXwWIQh6Q=;
 b=NnqC1tKLRVVjYLkMtqfueiAUufyFBRfCvkZlLIhcmpWS/c+Gi5aStGmPLF7jeG3ioFolGYLawxiZQZ2vLRlWwDWeLphPRfRWEUGok7jqT9jKIyVx3f9/GRPOrZP+16ZLhrukjyGtQtxhLGs09TLJy535JW6ihp1hwWVvCRqCoe4=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3424.eurprd04.prod.outlook.com (52.134.3.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 03:10:11 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 03:10:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>
Subject: RE: [EXT] Re: [PATCH net 1/3] net: ethernet: add property
 "nvmem_macaddr_swap" to swap macaddr bytes order
Thread-Topic: [EXT] Re: [PATCH net 1/3] net: ethernet: add property
 "nvmem_macaddr_swap" to swap macaddr bytes order
Thread-Index: AQHVBwm4BewhjCi/Zkaqy4SJng2qbqZkquiAgAO5X3A=
Date:   Mon, 13 May 2019 03:10:11 +0000
Message-ID: <VI1PR0402MB36002AB0B02D044825CC618EFF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <20190510181631.GE11588@lunn.ch>
In-Reply-To: <20190510181631.GE11588@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f534a09f-ce17-4e31-ec48-08d6d7508315
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3424;
x-ms-traffictypediagnostic: VI1PR0402MB3424:
x-microsoft-antispam-prvs: <VI1PR0402MB3424CCCC5EB1C7E65FDE8B78FF0F0@VI1PR0402MB3424.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(66066001)(86362001)(6246003)(71200400001)(71190400001)(76176011)(6506007)(53936002)(74316002)(14454004)(68736007)(478600001)(5660300002)(54906003)(4744005)(7696005)(99286004)(4326008)(102836004)(33656002)(66476007)(66556008)(64756008)(66446008)(26005)(66946007)(446003)(76116006)(73956011)(486006)(476003)(11346002)(25786009)(316002)(8936002)(6916009)(186003)(7736002)(52536014)(14444005)(256004)(81156014)(81166006)(2906002)(229853002)(55016002)(8676002)(6436002)(3846002)(6116002)(305945005)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3424;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Qfo6JaWOUJoDEuRKZOBAIxbbDZ//ek6PtzJgtfcyThAJZE2tqfp7R9QtLu0oFIzgLTWtXFOh4daz5bOruOnX/QFlJc58eSnz8+Mi5dlKh0Ugy5zHzgfVeEnYU2Rgxflt+FMDpZkK2I1lY5Y6HyFy4wGbP2h2XDdpbTJkt3sMQ9iEkAze/2ZfFd+ftdkjLf1RQCUlkcx2NWjL0aFM0sAaTvvzOxwaWzUjR4N2Lry7QxRHbYbdnZPuMjRck0W0V93xkXm8i4ETNHgVxQjK89ZrdD75yefqEodMpOjKVZbwd/IpSr1Jq+T6mKhsSfs/t92SlytHl1exuuF0yddFrXRYZK11EPupf4w6rXdpogT9aeTMspU2lcz3dTWXhTcdSKfz22HRPGneXt9mOmSZcGsTz0wa6tT0hOg2w1y12IN2z1k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f534a09f-ce17-4e31-ec48-08d6d7508315
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 03:10:11.4880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, May 11, 2019 2:17 AM
> On Fri, May 10, 2019 at 08:24:00AM +0000, Andy Duan wrote:
> > ethernet controller driver call .of_get_mac_address() to get the mac
> > address from devictree tree, if these properties are not present, then
> > try to read from nvmem.
> >
> > For example, read MAC address from nvmem:
> > of_get_mac_address()
> >       of_get_mac_addr_nvmem()
> >               nvmem_get_mac_address()
> >
> > i.MX6x/7D/8MQ/8MM platforms ethernet MAC address read from nvmem
> ocotp
> > eFuses, but it requires to swap the six bytes order.
> >
> > The patch add optional property "nvmem_macaddr_swap" to swap
>=20
> Please use nvmem-macaddr-swap. It is very unusal to use _ in property
> names.
>=20
>         Andrew

Thanks, "nvmem-macaddr-swap" string is better.=20
I will change "_" to "-" in next version.
