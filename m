Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446D862E2D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfGICgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:36:24 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:22513
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfGICgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 22:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOa/ZHDWzxE3C11qCA259O/O1vZmOkkAckeKQxJScCY=;
 b=H81ksM+C5nnY4M8Bx2q6iLELOp5HdXHsIY8m34iyvArOkAhZITzGv1pqPZc0x0GRHk6am8/teY6/9tAlfPAS6/xG5AZfddQmJ9qFAZzLa1TPUW01W1mVHHtrSKNPLC3I+mESI0aWtFBQMpi4ah2gKKEkFh+C2CVeL5ML6ET5QGk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5298.eurprd05.prod.outlook.com (20.178.18.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 02:36:20 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 02:36:20 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next v5 3/5] devlink: Introduce PCI PF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v5 3/5] devlink: Introduce PCI PF port flavour
 and port attribute
Thread-Index: AQHVNUPgoLc6st/Fuk+K2ak0BZ7EqKbBOZuAgABZqjA=
Date:   Tue, 9 Jul 2019 02:36:20 +0000
Message-ID: <AM0PR05MB48660BBC17DF4BB2363EFA3ED1F10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190708041549.56601-1-parav@mellanox.com>
        <20190708041549.56601-4-parav@mellanox.com>
 <20190708141403.1c01c5de@cakuba.netronome.com>
In-Reply-To: <20190708141403.1c01c5de@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.186.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8f42d9f-73ca-4c2b-9ba0-08d704163a0c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5298;
x-ms-traffictypediagnostic: AM0PR05MB5298:
x-microsoft-antispam-prvs: <AM0PR05MB5298916D9BE8A38751D99EE8D1F10@AM0PR05MB5298.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(189003)(199004)(13464003)(66446008)(6506007)(66556008)(9686003)(76116006)(64756008)(66476007)(73956011)(66946007)(74316002)(11346002)(55016002)(53546011)(2906002)(476003)(55236004)(446003)(71190400001)(486006)(71200400001)(478600001)(102836004)(229853002)(6116002)(4326008)(3846002)(76176011)(6436002)(33656002)(68736007)(8936002)(99286004)(7696005)(256004)(6246003)(186003)(66066001)(7736002)(53936002)(6916009)(25786009)(8676002)(52536014)(86362001)(26005)(81166006)(81156014)(316002)(14454004)(54906003)(305945005)(5660300002)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5298;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t46yI44e7cbk/l100GkKedhQikmA82cemLmsnteYqfw4lZijHV6R6+n2YgIIWz4Xcwt/aSA+AlPisUKvPHVZjOXJvzTixDhKjK5J7+u1rLksowFk42KPta+0Rx0dws5nLYyZjCu/bhxhAORETGuE/sEjwRi4xb/SJgzDV3CjfTDz75ZtMqX5uoxS5aKzNf4awvcCCrhe/KJyQaKBDA3Vl1tcfZZpgdgD2Yn4n/TV5Qn3KOcvhuCDssltFJa+p4t156cl4L1l1LZ8bVUjx0CXwC47KhCbtzU8V8xYG5Ka5YVFsQiQzlTC1Ipo2EvzMUo7budB5zJ0gA0BuI416ztJ8FwOnpeW13iabTLSLTOuAPnMyRYMDLgCi4Yfp0VJ5WSWQPoo/LdL2cenVmyZkknPot9zxgKAgOdsnigKVFRfsdk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f42d9f-73ca-4c2b-9ba0-08d704163a0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 02:36:20.4671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5298
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, July 9, 2019 2:44 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahamee=
d
> <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next v5 3/5] devlink: Introduce PCI PF port flavo=
ur and
> port attribute
>=20
> On Sun,  7 Jul 2019 23:15:47 -0500, Parav Pandit wrote:
> > diff --git a/net/core/devlink.c b/net/core/devlink.c index
> > 3e5f8204c36f..88b2cf207cb2 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -519,6 +519,11 @@ static int devlink_nl_port_attrs_put(struct sk_buf=
f
> *msg,
> >  	if (devlink_port->attrs.flavour !=3D DEVLINK_PORT_FLAVOUR_PHYSICAL
> &&
> >  	    devlink_port->attrs.flavour !=3D DEVLINK_PORT_FLAVOUR_CPU &&
> >  	    devlink_port->attrs.flavour !=3D DEVLINK_PORT_FLAVOUR_DSA)
> >  		return 0;
> > +	if (devlink_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF) {
>=20
> Thanks for making the changes!  I'm not sure how this would work, tho.
> We return early if flavour is not phys/cpu/dsa, so how can flavour be pci=
 here?..
>=20
My bad. Hunk got applied at wrong place when I split the patch.
Correcting it along with physical to phys name change that Jiri suggested.

> > +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> > +				attrs->pci_pf.pf))
> > +			return -EMSGSIZE;
> > +	}
> >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
> >  			attrs->physical.port_number))
> >  		return -EMSGSIZE;
