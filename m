Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15608231370
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgG1UDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:03:19 -0400
Received: from mail-eopbgr00051.outbound.protection.outlook.com ([40.107.0.51]:1035
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728050AbgG1UDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:03:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hce8v2ya19yv9u3YOpha4r4eJLIqWDu7pCoML1WdgLrDlmvuZ5S+4ztZ0GHzXDAePzpU7zsVlNu8PtsP4RoKggI/0Kjcba3pE2/ze0R6HzZ3SNfspWPiPD22fqN8kYUVaVJG7AhS77kD6jHefNRZsP8FQNBYEd7ceb2YgNn3ayIlaRT5gEYN/5VuckKIG2KE+80DaWsEtrJpW09m++b3eqSiZBtfqTkhIOQ0cd1Gz1JrcPh7Vy/7ezoQrfbM9eQFeLGuux9kqTBPHH8ugdxL7iAuAEn8dliR4aWzFuzu4pOYDWV8FbqhZ0A8/I48zOZKXu6L4kETcLH3gNB2Dh3m0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c19yBOh/h6YQ8jYqWMAvv32/E+HB56A6r9qL69tkx5o=;
 b=fXkbG5EZCbrp5usrr01kOjhIG1+f62IjjXQM5e7u7Mz1zJocXCuJ7HvW/CKfMe0FW92PQdIKalfvirj794kmDyaNQf1vJFjR6AoB6G5SX1YeSrAA7WtKCvY7MUoSnN3hip5mYb/JwzS4VESP8Wsjztyn/kL4ponQq07hp808yjeVBpAN5Ff3mz5w19YcY7CS968bPuWQwSY3Hf5jccotGCs6JSS+hg3rMZDehiS87uHQo1uCe6vqCYKMjhaiTeLZB0hc3r1gI1GFfa5ev83ppCmx1pN4gJfW+GtdcSyvBGiuVlonXRcGpuFiiM6FItCFvv1bbEQPAVaIzaQ5Qxw2vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c19yBOh/h6YQ8jYqWMAvv32/E+HB56A6r9qL69tkx5o=;
 b=nd0ifvdNEkeqhW4ZLAAJjZfk33wSUYlOhKIGdnxTAwviyfEth9ukTLB3Nh7siteHaBNpwUWO4m4K/9IcJeptaxsBq+z2sZMvhPQ/LmSD4LAbat05Xpz22QZP0tbXGerELSm2rUegqDwuDcuRXVmFFdHkfEiLoJMcP603obwDP1o=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4576.eurprd04.prod.outlook.com
 (2603:10a6:803:74::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 20:03:15 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 20:03:15 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
Thread-Topic: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
Thread-Index: AQHWZMQ/vSHK8kqdXUWr2Ggsrx/beKkdWgwAgAAHajCAAAasgIAAAIeg
Date:   Tue, 28 Jul 2020 20:03:15 +0000
Message-ID: <VI1PR0402MB3871A275CC602BFCBBCDA63BE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
        <20200728120334.28577106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871C269BF4C0C3EA7CF3B22E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200728125359.1e9f9b92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728125359.1e9f9b92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.95.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d17b63e6-cb50-4653-91f3-08d8333143b4
x-ms-traffictypediagnostic: VI1PR04MB4576:
x-microsoft-antispam-prvs: <VI1PR04MB45764947F033BDD29FC0A35DE0730@VI1PR04MB4576.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tF+xRL4Ij3WdgqT+bhCBSscwArNoY+gyPkTUZdS17O0719M8Lu5oRNsu+TAQQ8vZxpS2rvfBPxIiXt6lFi8jRd2SCI6CCD+APhsMr7yZ6P0M04Giqi79lzqEM1LXWB9pHm9xcPvUk8C35gCNAs85SnbeQNpzxXa3zbosAtAzpm29oh4A6xRN2GaB9mohZppQhuz8cU5iCYJnAdcjLWcA9jIE87JXjozDx07cHVAhDILcsXQaVspsrPx+8kxs0ENQGx4eCB0QbezB/7QIarkMn1iFkuTme/fnPgzDmO38UsKasZ1BQ7VcKQJOwYVfKrPb1kBAYizgEg1nQR3ru//QYAgDYR2YGHPT8jHMTv43nkGK61kCw9ej6Uc7fJKToSwHfL0kQS13DYywJNxXqVHfOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(9686003)(55016002)(186003)(66946007)(86362001)(76116006)(33656002)(66446008)(64756008)(66556008)(66476007)(71200400001)(966005)(4326008)(498600001)(83380400001)(26005)(5660300002)(2906002)(54906003)(7696005)(52536014)(8676002)(8936002)(6916009)(44832011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ws0Vnp0PRFED0saiY1CdwrGHE+N1kkPiWtFyDiZfGQb7jx6nt2X0LN40dRK0IRfD6Y5FNdHaAhaa1kU61Gu0sG7zXdlvQMvwnyTKIPpbVz2y/4qU6cnGZ75VQzED2sGBs0n+w9fXv+Kab4Qp0CE0vY6qRYTMdPyoLh9EqJf6lPbzF9JfG/8oHKZfnitwnBiulBn1S34SkXGUrxk/poy/QlpPcCRPKioxkYzZRAIkO6CDTAMTkHV6MJeXqKd66RSvDyqQhiH/s/JMGZjwumfeEfnEE3fzo1tgUxPkmcmgUYV3mi0GhVjAsPvts4Ma4zw0A760EoJeFn10iNn+K4JFl1IoGT9U3+IYpcgVD4sJt20dG4NRkXAUZoj/K23dzhIKsejfDBMyOIre7scAZmcoekRstFUp8zgrDIi19f8xBqfOHzglfS6pfhCjKdVzhDJtYOeYX+tZVFwI9WQViJ3FlvQ7s9MdIm516NFFqyJkz4I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17b63e6-cb50-4653-91f3-08d8333143b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 20:03:15.3717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MflwTsGfNu/I2YaQF2how8ndYT7NH1fwD5nuaIYayMs65ikx8/sydlWaQ7JCh0cQo20PVa7LD86qKkgIx80b+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugf=
s stats
>=20
> On Tue, 28 Jul 2020 19:33:46 +0000 Ioana Ciornei wrote:
> > > Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for
> > > debugfs stats No, come on, you know what we're going to say to a debu=
gfs
> patch like this...
> >
> > Eh, I figured it was worth a try since I saw that i40e also supports
> > clearing the stats through debugfs.
>=20
> The stuff that got snuck into i40e is the reason I pay very close attenti=
on to Intel
> patches these days.
>=20
> > > Is there anything dpaa2-specific here?  We should be able to add a
> > > common API for this.
> >
> > No, there is nothing dpaa2-specific. The common API would be in the
> > 'ethtool --reset' area or do you have anything other in mind?
>=20
> We have this huge ongoing discussion about devlink reset/reload:
>=20
> https://lore.kernel.org/netdev/1595847753-2234-1-git-send-email-moshe@mel=
lanox.com/
>=20
> Perhaps it could fit in there? I presume your reset is on the device leve=
l? If it's
> per netdev, I'd personally not be opposed to extending the ethtool API.

The reset available is per netdev, that is why I was thinking about ethtool=
 rather than devlink.

Ioana




