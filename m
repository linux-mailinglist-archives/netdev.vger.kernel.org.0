Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA79BBF7
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 07:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfHXFWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 01:22:53 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:31515
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfHXFWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 01:22:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hD7LkrqdTMR7dfaF2PTOyxo02f6rACvouCoQTJ66WyIuzxH45JasvMbgq2zZrEnRRYjDeSCX7YsBPhEI5NYgpjPkaaR5k37OP9s1tpxdnxuvVd0b70+EVMigs7nxwAAa1lWP0dzWj6mpk1PSKQdo01Fj6Fn4BXd9+jaKUVQjL/0ziBUzwLwUcBjwPVdCyawvnrsC7LEyGkaNNedRq/PaBaUTsi+oLyobxPgEY0fGw5/mg0qwLzUYXR5mjYVpl4Z3D8p9ZNsD789gwgVqTcxIiNlYXOZOqxcc+ngiX9iht3JOfiyqz1KzFAqgqzzI23E1gRBcMjpA8UBro4ftRcoZpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO2zTCqx23vNsph5s/ZNdEkbSrBd/gzN7Lkci9DhJwA=;
 b=Bf1P27Pfk/feQlYofWHOUdSKFkEbxR0knAmjwCOlztuhQ0038uBvVqz8R6QKl5+KFnqPZHAmLfrGLr0403zH5pPyTiRQ6QXVE+fHVxrboQo4JzuzmHUhqqOz2Z2csEgq1t2tpUEjN3ypi7DKcrutPo9TQmEq+jaIrLgN1dJ+MfozMG0w0mNWTQ+2fiIAW7jr3yBzSiWAzJlfdEZZ8XUEAk43sWEgtZGSb+Yi1dnuL4V7NkJjYNsyODPmES4VaSc8xvRkaDgvZo5MUaOG0fbgU1NAEP7je+slmvoxLf77nKlfxmHDWLwpMA/+CiWLgMAeqctPdh4w2iP6l4vYz8za7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO2zTCqx23vNsph5s/ZNdEkbSrBd/gzN7Lkci9DhJwA=;
 b=ricEaYLCiYgD48a1p3hsmtVxwvw22VvxiPfAcxYWuYMOgb8WWgsJk7IA4ZjazCrG1y1RDKf5xdcGLEFAfeJNftiwbAGqwosK1XJ3Gh0mZ4dT+GsGnQP7bYzdnF6bTbOtz8T/hF9pJgi8VKMRE6KmrjMBf/QwGvUGvhp0eX2a1G0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6306.eurprd05.prod.outlook.com (20.179.35.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Sat, 24 Aug 2019 05:22:46 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 05:22:46 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2ACAACadAIAAFGdwgAE42YCAAABasIAAaLIAgAAC1QCAABSugIAAA+pAgAATnYCAAAO7UIAAJVKAgACGAeCAABVOgIAABI+Q
Date:   Sat, 24 Aug 2019 05:22:46 +0000
Message-ID: <AM0PR05MB4866EEC687C9C46189939103D1A70@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823082820.605deb07@x1.home>
        <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823095229.210e1e84@x1.home>
        <AM0PR05MB4866E33AF7203DE47F713FAAD1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823111641.7f928917@x1.home>
        <AM0PR05MB486648FF7E6624F34842E425D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823134337.37e4b215@x1.home>
        <AM0PR05MB4866008B0571B90DAFFADA97D1A70@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190823225929.38fd86f5@x1.home>
In-Reply-To: <20190823225929.38fd86f5@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ac9f60c-64c3-406e-5d76-08d728531956
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6306;
x-ms-traffictypediagnostic: AM0PR05MB6306:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6306A655D3E87B21A3E3D281D1A70@AM0PR05MB6306.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(13464003)(199004)(189003)(66556008)(478600001)(53936002)(52536014)(186003)(33656002)(3846002)(71200400001)(71190400001)(9686003)(55016002)(99286004)(25786009)(6116002)(76176011)(7696005)(11346002)(305945005)(7736002)(6436002)(8936002)(66066001)(2906002)(74316002)(26005)(229853002)(8676002)(4326008)(86362001)(5660300002)(64756008)(66446008)(81166006)(53546011)(55236004)(102836004)(446003)(486006)(14454004)(9456002)(14444005)(476003)(66946007)(66476007)(76116006)(54906003)(81156014)(256004)(6506007)(6916009)(6246003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6306;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BI8GnnTssYFYLqwtWFs6qLhq3YouRInPMLjUxm/YdU7sVhWpEbFuQfGuJZ1uqB7sG3G/7Pt9Uw3c2NIoU+zPNgZuV+4qmOIPagWeTV/Hp549Ht9HvNzwi69BFW48V4tAS82PGJq4ApjLv5f01aqgdErQMqihWIrR/izq3KlCZifp4z6PMRD0nNZG5CSdQLycOth/Y4tAujSAwWYm4HmWcbNd9d0s/EU0k3FS5DhDa3iJG+BTXwzJzHEqWIzadsD66zBqPs+e6kxIgTBhzSP5SUnMThzDrV4vj5YxpLwNPf8E9A1a0CjUZEgDMicIqc8qlTUFnvNULndGp2EMMm1hfy8r9a6PHa9IHSQGzpsNTXl481H8Axm8KbYO1QQm7yeHt69R2jJJfXADnEFFicQMgftVrhoFg/MAEDbj/9qzbmQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac9f60c-64c3-406e-5d76-08d728531956
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 05:22:46.7302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kz2pL8XHURLWRLg8YJGbixvXS0DSFNAdh3p1xAUoPzrpMdgJFQrvsyNA6KMNkIzhC0CC2D+Xs2Vu4GGf+azVsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6306
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, August 24, 2019 10:29 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David =
S .
> Miller <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Sat, 24 Aug 2019 03:56:08 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Saturday, August 24, 2019 1:14 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>;
> > > David S . Miller <davem@davemloft.net>; Kirti Wankhede
> > > <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
> > > kvm@vger.kernel.org; linux- kernel@vger.kernel.org; cjia
> > > <cjia@nvidia.com>; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Fri, 23 Aug 2019 18:00:30 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, August 23, 2019 10:47 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko
> > > > > <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > > > Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> > > > > <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> > > > > kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> > > > > netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >
> > > > > On Fri, 23 Aug 2019 16:14:04 +0000 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >
> > > > > > > > Idea is to have mdev alias as optional.
> > > > > > > > Each mdev_parent says whether it wants mdev_core to
> > > > > > > > generate an alias or not. So only networking device drivers
> would set it to true.
> > > > > > > > For rest, alias won't be generated, and won't be compared
> > > > > > > > either during creation time. User continue to provide only =
uuid.
> > > > > > >
> > > > > > > Ok
> > > > > > >
> > > > > > > > I am tempted to have alias collision detection only within
> > > > > > > > children mdevs of the same parent, but doing so will
> > > > > > > > always mandate to prefix in netdev name. And currently we
> > > > > > > > are left with only 3 characters to prefix it, so that may n=
ot be
> good either.
> > > > > > > > Hence, I think mdev core wide alias is better with 12 chara=
cters.
> > > > > > >
> > > > > > > I suppose it depends on the API, if the vendor driver can
> > > > > > > ask the mdev core for an alias as part of the device
> > > > > > > creation process, then it could manage the netdev namespace
> > > > > > > for all its devices, choosing how many characters to use,
> > > > > > > and fail the creation if it can't meet a uniqueness
> > > > > > > requirement.  IOW, mdev-core would always provide a full
> > > > > > > sha1 and therefore gets itself out of the uniqueness/collisio=
n
> aspects.
> > > > > > >
> > > > > > This doesn't work. At mdev core level 20 bytes sha1 are
> > > > > > unique, so mdev core allowed to create a mdev.
> > > > >
> > > > > The mdev vendor driver has the opportunity to fail the device
> > > > > creation in mdev_parent_ops.create().
> > > > >
> > > > That is not helpful for below reasons.
> > > > 1. vendor driver doesn't have visibility in other vendor's alias.
> > > > 2. Even for single vendor, it needs to maintain global list of
> > > > devices to see
> > > collision.
> > > > 3. multiple vendors needs to implement same scheme.
> > > >
> > > > Mdev core should be the owner. Shifting ownership from one layer
> > > > to a lower layer in vendor driver doesn't solve the problem (if
> > > > there is one, which I think doesn't exist).
> > > >
> > > > > > And then devlink core chooses
> > > > > > only 6 bytes (12 characters) and there is collision. Things
> > > > > > fall apart. Since mdev provides unique uuid based scheme, it's
> > > > > > the mdev core's ownership to provide unique aliases.
> > > > >
> > > > > You're suggesting/contemplating multiple solutions here, 3-char
> > > > > prefix + 12- char sha1 vs <parent netdev> + ?-char sha1.  Also,
> > > > > the 15-char total limit is imposed by an external subsystem,
> > > > > where the vendor driver is the gateway between that subsystem
> > > > > and mdev.  How would mdev integrate with another subsystem that
> > > > > maybe only has 9-chars available?  Would the vendor driver API
> > > > > specify "I need an alias" or would it specify "I need an X-char l=
ength
> alias"?
> > > > Yes, Vendor driver should say how long the alias it wants.
> > > > However before we implement that, I suggest let such
> > > > vendor/user/driver arrive which needs that. Such variable length
> > > > alias can be added at that time and even with that alias collision
> > > > can be detected by single mdev module.
> > >
> > > If we agree that different alias lengths are possible, then I would
> > > request that minimally an mdev sample driver be modified to request
> > > an alias with a length that can be adjusted without recompiling in or=
der
> to exercise the collision path.
> > >
> > Yes. this can be done. But I fail to understand the need to do so.
> > It is not the responsibility of the mdev core to show case sha1
> > collision efficiency/deficiency. So why do you insist exercise it?
>=20
> I don't understand what you're trying to imply with "show case sha1 colli=
sion
> efficiency/deficiency".  Are you suggesting that I'm asking for this feat=
ure to
> experimentally test the probability of collisions at different character
> lengths?  We can use shell scripts for that.
> I'm simply observing that collisions are possible based on user input, bu=
t
> they're not practical to test for at the character lengths we're using.
> Therefore, how do I tell QA to develop a tests to make sure the kernel an=
d
> userspace tools that might be involved behave correctly when this rare ev=
ent
> occurs?
>
Ok. so you want to have code coverage and want to add a knob for that.
That is fine. I will have the mdev_parent->ops.alias_len as API instead of =
bool.
And extend mtty module parameter to set the alias length.

Unfortunately similar code coverage doesn't exist for API like mdev_get/set=
_iommu_device() in sample of real vendor driver.
And QA is not able to test this functionality without tainting the kernel.
