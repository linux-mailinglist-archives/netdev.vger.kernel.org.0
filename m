Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE1A3790
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfH3NLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 09:11:02 -0400
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:39652
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727751AbfH3NLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 09:11:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuDZ9UGrciKrberWuKOlIOLpo+PsDnMFyTm1oCYsNI5SaGMiEsRM0eyGoPpwoPWrfT7pAiLuzB+ZN3nJ5KJeewYGKzhGhL92gvC9ldeStZ2z6Wegx4eYJCvZPI+SHgaGYe/qZmC/5+h7FeKDSzJpalBJ8lHgi3GVQiz4lypnOdg+1Dh38r5SdV69UKThqCpg2ZnvQ/NPK7Y2CwOOhKNgHhC2hdzw1eBN9Kp6BoJFNLXvsX/ky/shBMiwEv1WWH97UFXdpHeR51GvAi1r6G8i2C6hGg0hn9WpxzmotTGRTRvaks8SKdn9SWLOVdehurRJkPkK0Bfi4asib9F/u7T1cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSHQiijsYk7Hp4UQ+bO7Cj0N18ZZq58Cem3IMtsqI8Q=;
 b=Di+dobaZ7TETCm9Qo/0+Gs45K+R8S9f0+ajK9h+8ZSTgNUwTEZQ14mX8bAfB79GBcH2eyF6PEeuE2Wgw7eWo0spbotDlN6FmrcmU91hhZb2A/oZ7mzBmy9TNbi7aFdXSpAUi+XKTtm8Q4bwqzq/lH36Ry2kjOdKwIXgzJtD8Ft7p3GRBZb8XGTGwlnooDHa3W9LySdXgbkDQMnY01vrk4OVvZevvkdhNP6qEG1TAUl2bPULcrNq0xKctcJOnw7DQOY0vMQFLnE+YFvju8mjOobdTtpd34WFLFxHlzdJ5cua1g+EQ6i5fs8+WQSgIDsUKHfwD0htYo2n+FMqUH1y9ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSHQiijsYk7Hp4UQ+bO7Cj0N18ZZq58Cem3IMtsqI8Q=;
 b=iU9HIVLDSVXH9CO16LVhGyGET3yAM60JifxhrG1qmxTKeubMo0/hC5rRWnYNHwVFOy4nJSRoYgW2aZ8gzwvWB3VzIFkQZq80I/jqgAKQEMMJgLCZoLjMygMgIycECoEkTI4KEM2tXP0eOCBGnAJyWdVtZRzvtd0M0/lFF3M5TFE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4946.eurprd05.prod.outlook.com (20.177.40.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Fri, 30 Aug 2019 13:10:17 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 13:10:17 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 5/6] mdev: Update sysfs documentation
Thread-Topic: [PATCH v2 5/6] mdev: Update sysfs documentation
Thread-Index: AQHVXlukaBbEcdZ2I0ipQhJUiMmPLacTpf+AgAADNNA=
Date:   Fri, 30 Aug 2019 13:10:17 +0000
Message-ID: <AM0PR05MB4866372C521F59491838C8E4D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-6-parav@mellanox.com>
 <20190830144927.7961193e.cohuck@redhat.com>
In-Reply-To: <20190830144927.7961193e.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e31d88f-f207-4000-283f-08d72d4b676a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4946;
x-ms-traffictypediagnostic: AM0PR05MB4946:|AM0PR05MB4946:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB49464A17E6575452374DF59FD1BD0@AM0PR05MB4946.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(13464003)(189003)(33656002)(52536014)(66446008)(6436002)(66556008)(64756008)(66476007)(316002)(66946007)(55236004)(76116006)(53546011)(6506007)(99286004)(76176011)(25786009)(7696005)(54906003)(4326008)(53936002)(9686003)(6246003)(55016002)(86362001)(15650500001)(66066001)(14454004)(508600001)(229853002)(5660300002)(8676002)(7736002)(305945005)(81156014)(81166006)(9456002)(8936002)(6916009)(74316002)(102836004)(14444005)(26005)(256004)(6116002)(186003)(2906002)(71200400001)(3846002)(71190400001)(486006)(11346002)(446003)(476003)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4946;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1oDx4PzQftkKT7BVZL5EcFswbxy5P3q2Sv0j9eN5rUv3Av58DzqW4E6E6cXnzeAZOOI3+5/xUaq65On94MnrQVFbHrEYd5OpaJsTLNSAF6Ry9e1cNSS0yKXTpSlYB+SP56A0ecxjJD+JDTHMzO9Hp7cDFNjvyOmgKKc7NWYcsghOzO3oOpJmDcmwyHIns5YR3cypLGcSw98hUcg137jtveLpJ/Ctikrh8oSzHhDl1DB7t1cInOJCDca1WFE88clUCdTbBMw1cMe2b3jG+BzvTp+HhFPfmoYjnGaPN+FeHrDSHbq5YlU9zVmcJ+xtHngWPnQsQmKh7DT2YSQV58Hxbev9+6q8qJd2U3/2cgFQBBRX563ojxu1KutJ5CS0ZBkJaa446Ub0IPmRLfU+SxWvbwwiaZxHHs/K/BSro+pDHWD3wDXbbmainvouzMhsKkbZswy1TOw5W9RNkrUFnOn4Yw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e31d88f-f207-4000-283f-08d72d4b676a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 13:10:17.6692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0rrRMRBTJNk+LdLPThS/IIJSjinOcMaBqTsOJT769blfDUotU5167sSgLs2V6YjEZ6fqcebLhZYrJfLR96bA+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4946
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, August 30, 2019 6:19 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 5/6] mdev: Update sysfs documentation
>=20
> On Thu, 29 Aug 2019 06:19:03 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Updated documentation for optional read only sysfs attribute.
>=20
> I'd probably merge this into the patch introducing the attribute.
>=20
Ok. I will spin v3.

> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  Documentation/driver-api/vfio-mediated-device.rst | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> > b/Documentation/driver-api/vfio-mediated-device.rst
> > index 25eb7d5b834b..0ab03d3f5629 100644
> > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > @@ -270,6 +270,7 @@ Directories and Files Under the sysfs for Each mdev
> Device
> >           |--- remove
> >           |--- mdev_type {link to its type}
> >           |--- vendor-specific-attributes [optional]
> > +         |--- alias [optional]
>=20
> "optional" implies "not always present" to me, not "might return a read e=
rror if
> not available". Don't know if there's a better way to tag this? Or make i=
t really
> optional? :)

May be write it as,

alias [ optional when requested by parent ]

>=20
> >
> >  * remove (write only)
> >
> > @@ -281,6 +282,10 @@ Example::
> >
> >  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
> >
> > +* alias (read only)
> > +Whenever a parent requested to generate an alias, each mdev is
> > +assigned a unique alias by the mdev core. This file shows the alias of=
 the
> mdev device.
>=20
> It's not really the parent, but the vendor driver requesting this, right?=
 Also,
At mdev level, it only knows parent->ops structure, whether parent is regis=
tered by vendor driver or something else.

> "each mdev" is a bit ambiguous,=20
It is in context of the parent. Sentence is not starting with "each mdev".
But may be more verbosely written as,

Whenever a parent requested to generate an alias, Each mdev device of such =
parent is assigned=20
unique alias by the mdev core. This file shows the alias of the mdev device=
.

> created via that driver. Lastly, if we stick with the "returns an error i=
f not
> implemented" approach, that should also be mentioned here.
Ok. Will spin v3 to describe it.

>=20
> > +
> >  Mediated device Hot plug
> >  ------------------------
> >

