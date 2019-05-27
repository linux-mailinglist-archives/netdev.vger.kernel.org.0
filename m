Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD292ACCD
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 03:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfE0BcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 21:32:04 -0400
Received: from mail-eopbgr00050.outbound.protection.outlook.com ([40.107.0.50]:29920
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725859AbfE0BcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 21:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RtqtaNgvK5bZqGma5TWhdBdyPR9HCC1NQ4lpVScoog=;
 b=E1FsfJLEqnmo8Eikt5vndIhR6GBhR+hkxzYQeoFD8RA+ShrkEqvoV8w42rX8sCNKFP/lViuWXzYWmw37PaGVl31Yb165IW0tUX6854P6tpz1X4f6UVc+VBN5N5HQiwylNev/DY9aWiwQjRMgWXKYHYi8waPhyFH7L0hMCIgslnk=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3550.eurprd04.prod.outlook.com (52.134.4.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Mon, 27 May 2019 01:32:00 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 01:31:59 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>
Subject: RE: [EXT] Re: [PATCH net,stable 1/1] net: fec: add defer probe for
 of_get_mac_address
Thread-Topic: [EXT] Re: [PATCH net,stable 1/1] net: fec: add defer probe for
 of_get_mac_address
Thread-Index: AQHVEQqVg7EbGrOZ7EyghRTbLf7Z5aZ6t7sAgAN9jlA=
Date:   Mon, 27 May 2019 01:31:59 +0000
Message-ID: <VI1PR0402MB36002FA05E1C053B00D9EBD7FF1D0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
 <20190524.131144.357456710258151289.davem@davemloft.net>
In-Reply-To: <20190524.131144.357456710258151289.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9eafbf54-00e0-4f91-c91b-08d6e2431d2d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3550;
x-ms-traffictypediagnostic: VI1PR0402MB3550:
x-microsoft-antispam-prvs: <VI1PR0402MB3550D7C91B2BFBC9626B4F39FF1D0@VI1PR0402MB3550.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:350;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(346002)(396003)(376002)(199004)(189003)(6436002)(86362001)(5660300002)(52536014)(486006)(478600001)(229853002)(446003)(256004)(476003)(316002)(66066001)(6116002)(3846002)(14454004)(11346002)(2906002)(71190400001)(71200400001)(25786009)(8676002)(81166006)(8936002)(7696005)(4744005)(6916009)(76176011)(4326008)(7736002)(76116006)(305945005)(186003)(66476007)(64756008)(66946007)(66556008)(66446008)(73956011)(26005)(68736007)(99286004)(53936002)(55016002)(9686003)(54906003)(102836004)(6246003)(74316002)(6506007)(81156014)(33656002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3550;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q9ylJe7HtcRold5FCoRXHsnTXOhAwdV2Rx1Cd2aHmz77gV7bCI25zTRLU39AhBAmsvRxcAzSbfre1j4Y7HSuPALtyZN2vycDkh5F9qWysVIH0ELq9Yw2Ts56pbrAuewYKv1H1/TEwyRq0GT3US55j+FuHN07v7BDSzBKQVZxGDBRykS2LmbqtkqjOmqEr5b6ZV0jhuwyYu2LpE014WnE5gsn/Ho7tN2foVgwUKJhFt4Z95CkL9aIIJJNnQjNLZhHoTBKsYRD4xksrUtzgN+UMUcQDP5ufkNzrmDUYgErSv7QmGrGTH9QUoPCR75GCdBhCJRn2GC/UvqPFMoWciqWL2gOstaU7YLwjC4YGnErcfak4RaAoa0XB7qa0EwZFAtgWKOCoTMogAyPhAEBA/diwmKUkad84CLx321nirSVP9s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eafbf54-00e0-4f91-c91b-08d6e2431d2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 01:31:59.7561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Saturday, May 25, 2019 4:12 =
AM
> From: Andy Duan <fugang.duan@nxp.com>
> Date: Thu, 23 May 2019 01:55:23 +0000
>=20
> > @@ -3146,7 +3150,10 @@ static int fec_enet_init(struct net_device *ndev=
)
> >       memset(cbd_base, 0, bd_size);
> >
> >       /* Get the Ethernet address */
> > -     fec_get_mac(ndev);
> > +     ret =3D fec_get_mac(ndev);
> > +     if (ret)
> > +             return ret;
>=20
> You're leaking the queues allocated by fec_enet_alloc_queue().

Good caught, thanks David.
I will send two patches for the V2 to fix the exisited queue memory leak.
