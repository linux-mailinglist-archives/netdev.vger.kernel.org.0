Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD79B279
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395437AbfHWOxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:53:13 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:59878
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388352AbfHWOxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 10:53:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6gl4Rvu0sJ9YWTgu3Fcp7jMLsHeoisiFUckSluQ7vdc5sYkeLnowqn9xdGDgs6V8QJC1FY5SVLH367fZMXDmdpzGVLyokn9/J+S57LjBCPz34cXN3DN9Z7F2o+V3n99QQR1Ec7cehCvVw9Td1Yta65gxG6EpOM45jm2W1cHtQT3i00UQWNAsa51XJssjWuy/mXYH9wWqntxGdS8PxZjrHdj8Ztd+Z705VKdM7998xBpM07elUHoUzdzHvdSYmKIGUv2+vPrW4/GFXgodqV9XHMKJPXeEGcrYv8w5w+120Ya5lB7b+ZkXeCHfEWyMWD4/J32xthcxh/FSwjpiIWCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LR5oPBZ0AnRu2lpuX9hdO6CmfCI5fpnSgIagu0L8s1s=;
 b=nBeKJ2a5xzwr7WU+vhByRc8P1NPHFwo0u1bH+OYxyXrZzYcZIhqPEJjzbeALeJUnD5Lpq43LP1to/+UWXbn1xqqi2tVY2lBkOzmyMTkO1Bj+M34nHyOj6Tawbuu/cDYzbdBYUD3tXBu+E6pYGRc5zqAc7w4dkRImTDbHlM18+DWIyoApk0qUJVGwkF5IADlomwP7HDkhf/Fvp6lYkfd9HDyAiGd3UPDRTgXw+qTmefFm+ccYRjJMBZy6ebaqNFR10BGc/qqeg0c8Ha70TxCuec6sA1+qV4V6GtCIAZgbLC+6BsGJEbrusWbdLnIPzi4i7YsgAx7k0Lsp2n3Y/8OUeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LR5oPBZ0AnRu2lpuX9hdO6CmfCI5fpnSgIagu0L8s1s=;
 b=ipr3DGEFdPwaolo3BezY2CgFyO5mZ9sN0bqiBwF1kAmNUiPs49Y8UND6fjGx2gSmmx+HKLBDYsaaeF4QWmTizLvis3lSoMqwIolF8wryp2ea4h7v+V9wXWSF0/WWvqzZvz6RUEt8y6fddY9GoZkq3mkICHiPp3+/pG6MB7nZFp4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6561.eurprd05.prod.outlook.com (20.179.36.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Fri, 23 Aug 2019 14:53:06 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 14:53:06 +0000
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
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2ACAACadAIAAFGdwgAE42YCAAABasIAAaLIAgAAC1QA=
Date:   Fri, 23 Aug 2019 14:53:06 +0000
Message-ID: <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820232622.164962d3@x1.home>
        <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822092903.GA2276@nanopsycho.orion>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190823082820.605deb07@x1.home>
In-Reply-To: <20190823082820.605deb07@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c89c3969-7092-4515-588e-08d727d99ba3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6561;
x-ms-traffictypediagnostic: AM0PR05MB6561:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB65617DF15E64E60E625D9CF3D1A40@AM0PR05MB6561.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(13464003)(199004)(189003)(476003)(52536014)(102836004)(55236004)(6246003)(66066001)(25786009)(3846002)(316002)(71200400001)(71190400001)(4326008)(53546011)(6506007)(6916009)(6436002)(478600001)(99286004)(8676002)(76176011)(81166006)(81156014)(55016002)(6116002)(74316002)(7696005)(229853002)(9686003)(86362001)(8936002)(14454004)(5660300002)(486006)(186003)(30864003)(305945005)(561944003)(9456002)(33656002)(54906003)(2906002)(64756008)(66446008)(446003)(11346002)(66556008)(66476007)(76116006)(7736002)(53936002)(66946007)(26005)(14444005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6561;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uI+7vo3NYo7KoccN3rphehY8+BsriFigJZSXwapHx0I2/267J4a6KRBOW0cVGmwFxDM0MtPIM+hvh5C4uQZ7x8BI1URkHgBm5sA20ZhwLJSiHfYZlGETMwJaCV9k0Sh1zYZfRQEJuEQ/sKZWHZE+ZjEmbgwbwu6x5SpMhREuSZytdk6rTnW67vQcBkTbiLt3IItCToAyWoIY5wNJ6iWqPxyuyCvQiZqi/Hxx2i172Ye+SdQ1Od6MKNYPzD5qfR9/VuxMOI+bjEpL1MW3R8jSifKQIKsXUVzI0SOp/yaCpFUwsA/2qbl3fZS1HHiLck/N+0mlfhs2xf7OZPBNg+PZ335LCoPe2fx+JEsy9ec1YFNogSQmjG/e5NA5g8UJ/8gl67E5WwGGSGcQGRkcu9jOqakupJD95VBAAd5HCr/MbGI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89c3969-7092-4515-588e-08d727d99ba3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 14:53:06.7595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bj0+0U+mLGY+IgtDJmf/asbzL3WHfGoR2wB/EqBwucBQeLi4YKfdgk2arUlAuwLOmTEUscXv7L/ncmQsFoNwCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6561
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 23, 2019 7:58 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David =
S . Miller
> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>; Cornelia
> Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Fri, 23 Aug 2019 08:14:39 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Hi Alex,
> >
> >
> > > -----Original Message-----
> > > From: Jiri Pirko <jiri@resnulli.us>
> > > Sent: Friday, August 23, 2019 1:42 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
> > > Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> <cohuck@redhat.com>;
> > > kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > <cjia@nvidia.com>; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > Thu, Aug 22, 2019 at 03:33:30PM CEST, parav@mellanox.com wrote:
> > > >
> > > >
> > > >> -----Original Message-----
> > > >> From: Jiri Pirko <jiri@resnulli.us>
> > > >> Sent: Thursday, August 22, 2019 5:50 PM
> > > >> To: Parav Pandit <parav@mellanox.com>
> > > >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > >> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> > > <cohuck@redhat.com>;
> > > >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > >>
> > > >> Thu, Aug 22, 2019 at 12:04:02PM CEST, parav@mellanox.com wrote:
> > > >> >
> > > >> >
> > > >> >> -----Original Message-----
> > > >> >> From: Jiri Pirko <jiri@resnulli.us>
> > > >> >> Sent: Thursday, August 22, 2019 3:28 PM
> > > >> >> To: Parav Pandit <parav@mellanox.com>
> > > >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > >> >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > >> >> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> > > >> <cohuck@redhat.com>;
> > > >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > >> >>
> > > >> >> Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com wrote:
> > > >> >> >
> > > >> >> >
> > > >> >> >> -----Original Message-----
> > > >> >> >> From: Jiri Pirko <jiri@resnulli.us>
> > > >> >> >> Sent: Thursday, August 22, 2019 2:59 PM
> > > >> >> >> To: Parav Pandit <parav@mellanox.com>
> > > >> >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri
> > > >> >> >> Pirko <jiri@mellanox.com>; David S . Miller
> > > >> >> >> <davem@davemloft.net>; Kirti Wankhede
> > > >> >> >> <kwankhede@nvidia.com>; Cornelia Huck
> > > >> >> <cohuck@redhat.com>;
> > > >> >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > >> >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev
> > > >> >> >> core
> > > >> >> >>
> > > >> >> >> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com
> wrote:
> > > >> >> >> >
> > > >> >> >> >
> > > >> >> >> >> -----Original Message-----
> > > >> >> >> >> From: Alex Williamson <alex.williamson@redhat.com>
> > > >> >> >> >> Sent: Wednesday, August 21, 2019 10:56 AM
> > > >> >> >> >> To: Parav Pandit <parav@mellanox.com>
> > > >> >> >> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > > >> >> >> >> <davem@davemloft.net>; Kirti Wankhede
> > > >> >> >> >> <kwankhede@nvidia.com>; Cornelia Huck
> > > >> >> >> >> <cohuck@redhat.com>; kvm@vger.kernel.org;
> > > >> >> >> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> > > >> >> >> >> netdev@vger.kernel.org
> > > >> >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and
> > > >> >> >> >> mdev core
> > > >> >> >> >>
> > > >> >> >> >> > > > > Just an example of the alias, not proposing how i=
t's set.
> > > >> >> >> >> > > > > In fact, proposing that the user does not set
> > > >> >> >> >> > > > > it, mdev-core provides one
> > > >> >> >> >> > > automatically.
> > > >> >> >> >> > > > >
> > > >> >> >> >> > > > > > > Since there seems to be some prefix
> > > >> >> >> >> > > > > > > overhead, as I ask about above in how many
> > > >> >> >> >> > > > > > > characters we actually have to work with in
> > > >> >> >> >> > > > > > > IFNAMESZ, maybe we start with
> > > >> >> >> >> > > > > > > 8 characters (matching your "index"
> > > >> >> >> >> > > > > > > namespace) and expand as necessary for
> > > >> >> >> disambiguation.
> > > >> >> >> >> > > > > > > If we can eliminate overhead in IFNAMESZ,
> > > >> >> >> >> > > > > > > let's start with
> > > >> 12.
> > > >> >> >> >> > > > > > > Thanks,
> > > >> >> >> >> > > > > > >
> > > >> >> >> >> > > > > > If user is going to choose the alias, why does
> > > >> >> >> >> > > > > > it have to be limited to
> > > >> >> >> >> sha1?
> > > >> >> >> >> > > > > > Or you just told it as an example?
> > > >> >> >> >> > > > > >
> > > >> >> >> >> > > > > > It can be an alpha-numeric string.
> > > >> >> >> >> > > > >
> > > >> >> >> >> > > > > No, I'm proposing a different solution where
> > > >> >> >> >> > > > > mdev-core creates an alias based on an
> > > >> >> >> >> > > > > abbreviated sha1.  The user does not provide the
> > > >> >> >> >> alias.
> > > >> >> >> >> > > > >
> > > >> >> >> >> > > > > > Instead of mdev imposing number of characters
> > > >> >> >> >> > > > > > on the alias, it should be best
> > > >> >> >> >> > > > > left to the user.
> > > >> >> >> >> > > > > > Because in future if netdev improves on the
> > > >> >> >> >> > > > > > naming scheme, mdev will be
> > > >> >> >> >> > > > > limiting it, which is not right.
> > > >> >> >> >> > > > > > So not restricting alias size seems right to me=
.
> > > >> >> >> >> > > > > > User configuring mdev for networking devices
> > > >> >> >> >> > > > > > in a given kernel knows what
> > > >> >> >> >> > > > > user is doing.
> > > >> >> >> >> > > > > > So user can choose alias name size as it finds =
suitable.
> > > >> >> >> >> > > > >
> > > >> >> >> >> > > > > That's not what I'm proposing, please read again.
> > > >> >> >> >> > > > > Thanks,
> > > >> >> >> >> > > >
> > > >> >> >> >> > > > I understood your point. But mdev doesn't know how
> > > >> >> >> >> > > > user is going to use
> > > >> >> >> >> > > udev/systemd to name the netdev.
> > > >> >> >> >> > > > So even if mdev chose to pick 12 characters, it
> > > >> >> >> >> > > > could result in
> > > >> >> collision.
> > > >> >> >> >> > > > Hence the proposal to provide the alias by the
> > > >> >> >> >> > > > user, as user know the best
> > > >> >> >> >> > > policy for its use case in the environment its using.
> > > >> >> >> >> > > > So 12 character sha1 method will still work by user=
.
> > > >> >> >> >> > >
> > > >> >> >> >> > > Haven't you already provided examples where certain
> > > >> >> >> >> > > drivers or subsystems have unique netdev prefixes?
> > > >> >> >> >> > > If mdev provides a unique alias within the
> > > >> >> >> >> > > subsystem, couldn't we simply define a netdev prefix
> > > >> >> >> >> > > for the mdev subsystem and avoid all other
> > > >> >> >> >> > > collisions?  I'm not in favor of the user providing
> > > >> >> >> >> > > both a uuid and an alias/instance.  Thanks,
> > > >> >> >> >> > >
> > > >> >> >> >> > For a given prefix, say ens2f0, can two UUID->sha1
> > > >> >> >> >> > first 9 characters have
> > > >> >> >> >> collision?
> > > >> >> >> >>
> > > >> >> >> >> I think it would be a mistake to waste so many chars on
> > > >> >> >> >> a prefix, but
> > > >> >> >> >> 9 characters of sha1 likely wouldn't have a collision
> > > >> >> >> >> before we have 10s of thousands of devices.  Thanks,
> > > >> >> >> >>
> > > >> >> >> >> Alex
> > > >> >> >> >
> > > >> >> >> >Jiri, Dave,
> > > >> >> >> >Are you ok with it for devlink/netdev part?
> > > >> >> >> >Mdev core will create an alias from a UUID.
> > > >> >> >> >
> > > >> >> >> >This will be supplied during devlink port attr set such
> > > >> >> >> >as,
> > > >> >> >> >
> > > >> >> >> >devlink_port_attrs_mdev_set(struct devlink_port *port,
> > > >> >> >> >const char *mdev_alias);
> > > >> >> >> >
> > > >> >> >> >This alias is used to generate representor netdev's
> phys_port_name.
> > > >> >> >> >This alias from the mdev device's sysfs will be used by
> > > >> >> >> >the udev/systemd to
> > > >> >> >> generate predicable netdev's name.
> > > >> >> >> >Example: enm<mdev_alias_first_12_chars>
> > > >> >> >>
> > > >> >> >> What happens in unlikely case of 2 UUIDs collide?
> > > >> >> >>
> > > >> >> >Since users sees two devices with same phys_port_name, user
> > > >> >> >should destroy
> > > >> >> recently created mdev and recreate mdev with different UUID?
> > > >> >>
> > > >> >> Driver should make sure phys port name wont collide,
> > > >> >So when mdev creation is initiated, mdev core calculates the
> > > >> >alias and if there
> > > >> is any other mdev with same alias exist, it returns -EEXIST error
> > > >> before progressing further.
> > > >> >This way user will get to know upfront in event of collision
> > > >> >before the mdev
> > > >> device gets created.
> > > >> >How about that?
> > > >>
> > > >> Sounds fine to me. Now the question is how many chars do we want t=
o
> have.
> > > >>
> > > >12 characters from Alex's suggestion similar to git?
> > >
> > > Ok.
> > >
> >
> > Can you please confirm this scheme looks good now? I like to get patche=
s
> started.
>=20
> My only concern is your comment that in the event of an abbreviated
> sha1 collision (as exceptionally rare as that might be at 12-chars), we'd=
 fail the
> device create, while my original suggestion was that vfio-core would add =
an
> extra character to the alias.  For non-networking devices, the sha1 is
> unnecessary, so the extension behavior seems preferred.  The user is only
> responsible to provide a unique uuid.  Perhaps the failure behavior could=
 be
> applied based on the mdev device_api.  A module option on mdev to specify=
 the
> default number of alias chars would also be useful for testing so that we=
 can set
> it low enough to validate the collision behavior.  Thanks,
>=20

Idea is to have mdev alias as optional.
Each mdev_parent says whether it wants mdev_core to generate an alias or no=
t.
So only networking device drivers would set it to true.
For rest, alias won't be generated, and won't be compared either during cre=
ation time.
User continue to provide only uuid.
I am tempted to have alias collision detection only within children mdevs o=
f the same parent, but doing so will always mandate to prefix in netdev nam=
e.
And currently we are left with only 3 characters to prefix it, so that may =
not be good either.
Hence, I think mdev core wide alias is better with 12 characters.

I do not understand how an extra character reduces collision, if that's wha=
t you meant.
Module options are almost not encouraged anymore with other subsystems/driv=
ers.

For testing collision rate, a sample user space script and sample mtty is e=
asy and get us collision count too.
We shouldn't put that using module option in production kernel.
I practically have the code ready to play with; Changing 12 to smaller valu=
e is easy with module reload.

#define MDEV_ALIAS_LEN 12

> Alex
>=20
> > > >> >> in this case that it does
> > > >> >> not provide 2 same attrs for 2 different ports.
> > > >> >> Hmm, so the order of creation matters. That is not good.
> > > >> >>
> > > >> >> >>
> > > >> >> >> >I took Ethernet mdev as an example.
> > > >> >> >> >New prefix 'm' stands for mediated device.
> > > >> >> >> >Remaining 12 characters are first 12 chars of the mdev alia=
s.
> > > >> >> >>
> > > >> >> >> Does this resolve the identification of devlink port represe=
ntor?
> > > >> >> >Not sure if I understood your question correctly, attemping
> > > >> >> >to answer
> > > >> below.
> > > >> >> >phys_port_name of devlink port is defined by the first 12
> > > >> >> >characters of mdev
> > > >> >> alias.
> > > >> >> >> I assume you want to use the same 12(or so) chars, don't you=
?
> > > >> >> >Mdev's netdev will also use the same mdev alias from the
> > > >> >> >sysfs to rename
> > > >> >> netdev name from ethX to enm<mdev_alias>, where en=3DEtherenet,
> > > >> m=3Dmdev.
> > > >> >> >
> > > >> >> >So yes, same 12 characters are use for mdev's netdev and mdev
> > > >> >> >devlink port's
> > > >> >> phys_port_name.
> > > >> >> >
> > > >> >> >Is that what are you asking?
> > > >> >>
> > > >> >> Yes. Then you have 3 chars to handle the rest of the name (pci,=
 pf)...

