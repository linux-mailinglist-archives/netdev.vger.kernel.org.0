Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5C98FE1
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfHVJmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:42:20 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:44153
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729797AbfHVJmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 05:42:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkmZ9U050D5ChFfsuHcroeBXhAOwZsNf7HD0xsjhCGwcWzVWJzUVfPbz670lQNzp56Xj1opzZngFcksS92GYGo2O4xE86c8yk2VKpLdlvdVYlEvYEL13FKCyn1k+2BoJHilmqxqhZHo76Prk/VV5qE9mV7cYmNFirByKS9ib99/X/J3h8ogutUljlgvoLP8f5hqzXfQtoVy0zD6otnNNF04wWerHaf9+FaDNATmE0nGgSEaECyzFK63ZjKV4wixkQgb+cNspNbcfB5S7Y/W0ruO0nrgKVOi1Rw2OSeW2tYPVsiH6zfIE833GRqmTfd7Mhyk6NxF2Ik6j98/Obfspug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbfAVnbGAdTMS+v3e+Fwn0qRVn4NLgJYNNBNaQZ/kE4=;
 b=lFri583kIW9LzQsi2dnQ+FNSVeVhp4m8ilYiTpuesQLsLYqNrKnC+PH37sZhK/sprFQ3WHrYMMzIlgVuPtheuEwEVu1M6Nx7ndDUOQA66/oyd/1BOHyfCaHTxnzUeFWf5cOqOndmD0cfBK07kx21JfSXUO6+ZHT4fpg9k9OfiZ1LJx5F1MWZDFVwcfGh8wwFeUrhHWbzifpEkVcYLwVWPXYZM6EQNhp2Yp3ONV9TI8tb/RvNInXR4gSdg6hzLaHn7UamfrSPx9FWtRO2EjeLHkTq/Lj9Z9fTWj4/LpBRytVHqWh12VLdn2RD/T6RuvzlDOSZbCkBMr1oB1Lu6HShqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbfAVnbGAdTMS+v3e+Fwn0qRVn4NLgJYNNBNaQZ/kE4=;
 b=HOULSG03zivnUsNbDlnMZGxneb3UnoWssuwVgk5Ny/pYBeY6+ukpZLcuM7RrQUtOqns2x0E2X0XWdxx/xBtH7OKrn6MA5yS039q2f7s0WLOLaiLCr6Mtwh9Y9358tui6p4I3hmfb/EXaebKaNWjwLc1yNmWK9F94lJ744CNt+LQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6035.eurprd05.prod.outlook.com (20.178.118.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 09:42:14 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 09:42:14 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEA==
Date:   Thu, 22 Aug 2019 09:42:13 +0000
Message-ID: <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820111904.75515f58@x1.home>
 <AM0PR05MB486686D3C311F3C61BE0997DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820222051.7aeafb69@x1.home>
 <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820225722.237a57d2@x1.home>
 <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
 <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822092903.GA2276@nanopsycho.orion>
In-Reply-To: <20190822092903.GA2276@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27b9c828-1a31-4989-f5ea-08d726e50352
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6035;
x-ms-traffictypediagnostic: AM0PR05MB6035:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB603547EA8616357D6DC77621D1A50@AM0PR05MB6035.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39830400003)(346002)(396003)(366004)(136003)(376002)(199004)(189003)(13464003)(71200400001)(561944003)(71190400001)(102836004)(446003)(478600001)(9686003)(2906002)(14444005)(256004)(476003)(11346002)(55236004)(52536014)(486006)(66556008)(64756008)(8676002)(6506007)(53546011)(6436002)(55016002)(9456002)(3846002)(6116002)(66446008)(25786009)(186003)(14454004)(66476007)(53936002)(66946007)(6916009)(26005)(66066001)(74316002)(5660300002)(86362001)(81166006)(4326008)(81156014)(229853002)(76116006)(305945005)(7736002)(76176011)(6246003)(7696005)(316002)(8936002)(33656002)(54906003)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6035;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TY8X6W4qrXusZc5+Yzsmy+1yFTAjJaIxpS/JCNYrKmkGsFv9ACirroSzZ7qTpgov71CgeJtcQGVebBRLWx/N2PYaXKTsHsWjO82FUz+zj35eVznNvv1eJLWnuR2BuhPfXhCOjTqr9T4f3DpOCP4Y1qG0Jr3gYOYTw8n4kZ48hNogn+9aoV4c6AYWsMg3OrBFi71FC7gQL9mY1a5T1y5A2XAOtNNixZ5kZV/7Wjavxpiy1Myr9Zc14im0xMM8XNiY23uLWEY9c8cG+ag7H0TxEGR8gjDyUeqyV4cEId92YwnoOgBUwZRUncaE7P3tSwu0y/W5JGmPsguo7RuKIMUhJIaaaAMh6yvL5bhK9oQL6PaUvbniha7Hs62Xif0QTAUvlEHDJMGpTRa1+YM5d5JSKUrfKbXoDDisB6M4Nx126bA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b9c828-1a31-4989-f5ea-08d726e50352
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 09:42:13.9720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2xSYgMY2sDTOSHpopKcXcrDwl87DY9n7AumgPf1i/j6Hp54YaCEy8YG7lFc3bmfAe8fCY2EesmaGUsi/EfuSfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6035
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, August 22, 2019 2:59 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
> Wankhede <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>=
;
> netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Alex Williamson <alex.williamson@redhat.com>
> >> Sent: Wednesday, August 21, 2019 10:56 AM
> >> To: Parav Pandit <parav@mellanox.com>
> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> >> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> >> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> >> netdev@vger.kernel.org
> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> >>
> >> > > > > Just an example of the alias, not proposing how it's set.  In
> >> > > > > fact, proposing that the user does not set it, mdev-core
> >> > > > > provides one
> >> > > automatically.
> >> > > > >
> >> > > > > > > Since there seems to be some prefix overhead, as I ask
> >> > > > > > > about above in how many characters we actually have to
> >> > > > > > > work with in IFNAMESZ, maybe we start with 8 characters
> >> > > > > > > (matching your "index" namespace) and expand as necessary =
for
> disambiguation.
> >> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start with=
 12.
> >> > > > > > > Thanks,
> >> > > > > > >
> >> > > > > > If user is going to choose the alias, why does it have to
> >> > > > > > be limited to
> >> sha1?
> >> > > > > > Or you just told it as an example?
> >> > > > > >
> >> > > > > > It can be an alpha-numeric string.
> >> > > > >
> >> > > > > No, I'm proposing a different solution where mdev-core
> >> > > > > creates an alias based on an abbreviated sha1.  The user does
> >> > > > > not provide the
> >> alias.
> >> > > > >
> >> > > > > > Instead of mdev imposing number of characters on the alias,
> >> > > > > > it should be best
> >> > > > > left to the user.
> >> > > > > > Because in future if netdev improves on the naming scheme,
> >> > > > > > mdev will be
> >> > > > > limiting it, which is not right.
> >> > > > > > So not restricting alias size seems right to me.
> >> > > > > > User configuring mdev for networking devices in a given
> >> > > > > > kernel knows what
> >> > > > > user is doing.
> >> > > > > > So user can choose alias name size as it finds suitable.
> >> > > > >
> >> > > > > That's not what I'm proposing, please read again.  Thanks,
> >> > > >
> >> > > > I understood your point. But mdev doesn't know how user is
> >> > > > going to use
> >> > > udev/systemd to name the netdev.
> >> > > > So even if mdev chose to pick 12 characters, it could result in =
collision.
> >> > > > Hence the proposal to provide the alias by the user, as user
> >> > > > know the best
> >> > > policy for its use case in the environment its using.
> >> > > > So 12 character sha1 method will still work by user.
> >> > >
> >> > > Haven't you already provided examples where certain drivers or
> >> > > subsystems have unique netdev prefixes?  If mdev provides a
> >> > > unique alias within the subsystem, couldn't we simply define a
> >> > > netdev prefix for the mdev subsystem and avoid all other
> >> > > collisions?  I'm not in favor of the user providing both a uuid
> >> > > and an alias/instance.  Thanks,
> >> > >
> >> > For a given prefix, say ens2f0, can two UUID->sha1 first 9
> >> > characters have
> >> collision?
> >>
> >> I think it would be a mistake to waste so many chars on a prefix, but
> >> 9 characters of sha1 likely wouldn't have a collision before we have
> >> 10s of thousands of devices.  Thanks,
> >>
> >> Alex
> >
> >Jiri, Dave,
> >Are you ok with it for devlink/netdev part?
> >Mdev core will create an alias from a UUID.
> >
> >This will be supplied during devlink port attr set such as,
> >
> >devlink_port_attrs_mdev_set(struct devlink_port *port, const char
> >*mdev_alias);
> >
> >This alias is used to generate representor netdev's phys_port_name.
> >This alias from the mdev device's sysfs will be used by the udev/systemd=
 to
> generate predicable netdev's name.
> >Example: enm<mdev_alias_first_12_chars>
>=20
> What happens in unlikely case of 2 UUIDs collide?
>=20
Since users sees two devices with same phys_port_name, user should destroy =
recently created mdev and recreate mdev with different UUID?
>=20
> >I took Ethernet mdev as an example.
> >New prefix 'm' stands for mediated device.
> >Remaining 12 characters are first 12 chars of the mdev alias.
>=20
> Does this resolve the identification of devlink port representor?=20
Not sure if I understood your question correctly, attemping to answer below=
.
phys_port_name of devlink port is defined by the first 12 characters of mde=
v alias.
> I assume you want to use the same 12(or so) chars, don't you?
Mdev's netdev will also use the same mdev alias from the sysfs to rename ne=
tdev name from ethX to enm<mdev_alias>, where en=3DEtherenet, m=3Dmdev.

So yes, same 12 characters are use for mdev's netdev and mdev devlink port'=
s phys_port_name.

Is that what are you asking?
