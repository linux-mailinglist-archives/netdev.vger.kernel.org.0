Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1E2971BD
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 07:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfHUF4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 01:56:01 -0400
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:43254
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfHUF4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 01:56:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwXKPfFCEoJxQ5dIe1XX+82y/Z7gwl9kebDp6/ruDSrYMHvzZ1xs24BVFcZuKiyPhIs52E8WtDVA8M8f9pqs8jqwPTYw3nIb6rUQN7NFx4HLjErwiowT/2bdizpu10LWE+BYBSuPdQ4cg+uAxpeLJ2jYuYncwHWPk3aM4cJutYN9HHO+VFl2yshXfzj789CCvWXXq067KBo+yhCafsXvNhG8ihTVkkVY7JRD0HTUvuYCo6qPZJYWfq1gZ5DCiBckecQfYL0NXmUOEgUL16S176guRl1o48/nF9al8BQS9OovgoYJy9EjV9HUAZ5+ow/rsSw6HQewxUSp+G+SqNRbPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJbLQkWyeeiqRGjzTXa3X4rAmsebjO8/l7iLXju6mkw=;
 b=aVzz+KfuefQrn3Uj1N9reIEvjcz6I6TgZ7q1G6bPXDZUvn122DyMzO7fqJM0en2Dhc5OOA2xSQEpTotJy49jOOEX0JEs97O0o/u3nlB/TmxKnGoZQ/RVXhsC3cXQqcyCXY5eO8Dc7x/E5Syded/TttBB3vrq01MfWPZq19xO9BAqLXmysEym7cKO0O9Dtefve56T5iuyLp1SqMiDFC03xWJHSq1LRpDiylx+JLF1AwM8R//9z7DXFpKajvAws1uwFhGMRrQA1gM5vzws4Ahbs5KtI9UzEvYIMeWbCQsnf0TNqoumy9Dy9VlA9kw0N7ykHXvKXPAGHqd8pMmcIhrdWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJbLQkWyeeiqRGjzTXa3X4rAmsebjO8/l7iLXju6mkw=;
 b=sdjqzNWE0dMSvxhY8qGQLNyWSL5aSGa46gqvIDx48r2BT07XR8d3p2JF5XKMYijmp2XFceR4sb9iIZ3RiFONvoinWNLJcKjjuZ0bfcqLQvVaVRz50cDrpkcjsclpQuYqRCotkZJ8PmKxCDTfYybQX9IyZsIZfdtn5/TwdgnUpKM=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2768.eurprd04.prod.outlook.com (10.175.24.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 05:55:56 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 05:55:56 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Marco Hartmann <marco.hartmann@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write
 support
Thread-Topic: [EXT] Re: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write
 support
Thread-Index: AQHVVrEbaaUHZXnfyUWEGTy4sTss5acDFLIAgAA3lHCAALXSgIABGbBw
Date:   Wed, 21 Aug 2019 05:55:56 +0000
Message-ID: <VI1PR0402MB360003CE20EB1412F7E0EF0CFFAA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
 <20190819225422.GD29991@lunn.ch>
 <VI1PR0402MB360079EAAE7042048B2F5AC8FFAB0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <20190820130403.GH29991@lunn.ch>
In-Reply-To: <20190820130403.GH29991@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6fe9dd5-f07d-45bb-f7ce-08d725fc3be4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2768;
x-ms-traffictypediagnostic: VI1PR0402MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2768EA01B7500D0015B131F8FFAA0@VI1PR0402MB2768.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(81156014)(8676002)(33656002)(8936002)(81166006)(25786009)(229853002)(76116006)(66556008)(66946007)(64756008)(66476007)(66446008)(53936002)(4326008)(6246003)(7736002)(5660300002)(52536014)(6916009)(3846002)(6116002)(54906003)(71190400001)(2906002)(7696005)(316002)(71200400001)(99286004)(256004)(14444005)(102836004)(6506007)(186003)(446003)(26005)(86362001)(55016002)(66066001)(6436002)(9686003)(11346002)(476003)(486006)(478600001)(76176011)(14454004)(305945005)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2768;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UdaS8WQBLfCqh6Z1SiWa/jGx8ZJMrQ6IEr5s98ehaucS9LSllZeyx/nV4h2sKpqTQN/xG3h31bmdnWtoUd6KKmjoDLdlBrbD4RUU0tfZ9d8UOl/IVHYygEfLcMi3wWZZ8/c84cRLjQWAOVyiC4dKL3mmfIwlt5E2QWuoHh3T+Q962GMEYxktnGFlqvvpW6xnrDK+Y2OLqgtWWkWfvyLwIPwDd8H+1yXxtFTUlZ/zTkCE7ufdwH6rIC6/k6VkjOBqNPSZJt4JFbd9mUTDPLmAQ6RZudyT0QM3l/6lkifWKlcTceztCI+GSNkHX9J/NnshgK2dfIblUhAkVcYaHlFeHq8MFJia+FBR0CSjZJKv5HVbS1Duq+S/70JbYDYSriGSrDyDwFL5+dJqS906BfrzX6EhqecTyx9xFD/m8zQy9JI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fe9dd5-f07d-45bb-f7ce-08d725fc3be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 05:55:56.2062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sa1o5Kitd8N4p466dn8n4XsUTUdDW0zSY8cOHvkcKyqnAgey01uKGmJSsLdZxpXOFCDjNO4on8QWMOcKBRI5RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, August 20, 2019 9:04 PM
> On Tue, Aug 20, 2019 at 02:32:26AM +0000, Andy Duan wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > > On Mon, Aug 19, 2019 at 05:11:14PM +0000, Marco Hartmann wrote:
> > > > As of yet, the Fast Ethernet Controller (FEC) driver only supports
> > > > Clause 22 conform MDIO transactions. IEEE 802.3ae Clause 45
> > > > defines a modified MDIO protocol that uses a two staged access
> > > > model in order to increase the address space.
> > > >
> > > > This patch adds support for Clause 45 conform MDIO read and write
> > > > operations to the FEC driver.
> > >
> > > Hi Marco
> > >
> > > Do all versions of the FEC hardware support C45? Or do we need to
> > > make use of the quirk support in this driver to just enable it for so=
me
> revisions of FEC?
> > >
> > > Thanks
> > >         Andrew
> >
> > i.MX legacy platforms like i.MX6/7 series, they doesn't support Write &=
 Read
> Increment.
> > But for i.MX8MQ/MM series, it support C45 full features like Write & Re=
ad
> Increment.
> >
> > For the patch itself, it doesn't support Write & Read Increment, so I
> > think the patch doesn't need to add quirk support.
>=20
> Hi Andy
>=20
> So what happens with something older than a i.MX8MQ/MM when a C45
> transfer is attempted? This patch adds a new write. Does that write
> immediately trigger a completion interrupt? Does it never trigger an inte=
rrupt,
> and we have to wait FEC_MII_TIMEOUT?
>=20
> Ideally, if the hardware does not support C45, we want it to return
> EOPNOTSUPP.
>=20
> Thanks
>         Andrew

It still trigger an interrupt to wakeup the completion, we have to wait FEC=
_MII_TIMEOUT.
Older chips just support part of C45 feature just like the patch implementa=
tion.=20
