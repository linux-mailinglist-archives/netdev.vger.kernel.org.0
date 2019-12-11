Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5B11C082
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfLKXZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:25:16 -0500
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:62212
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbfLKXZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:25:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMSCvQRLk/feNPeD1aLZAkGoBFumBGUgkR9YbYTolqAUTCDiEEfrs2qiNz6JoOaXMZ/c9XBVDkqSjT8jLnEUEQELqmIppOTPaSHSc+tP/EA3I2OcHHgp1jsiOJ3ooP+Xg3H7CS6aJ8qhblbmC1xu04y1SyRUPxBuZrAc/qwlqyicoiuGPaIKQrse9QsuXz0uiBruwm2H1++5P7OQbCYxS0xaT4CA98RHRCquWTfJLaOmymYmZWrFB0qXmZR6kNJUeAbQkJv/Jd5UFgm7y3Pa+DKWyxeyP8AHywfsmB/mnwKn83/jw9RLOIHRti5jwe+Z0KsKkZ0pn565LHw4vSTUqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrPWbRnhcCW+HATEapINcyaPYKBAzAx6rl9bsrSMh1o=;
 b=aww7IltZPxQNIUltIH+rapiWzUIsxjeY2x9a8yMmc8SqCZ5yhWTx4WjTHpFccFX/wh6goPx433q2jIzC9g3vHby2SiaSCm6HdI/lrqVdX0yRsGpCcixR7+Xc4Sogga4PaJFk+c8EDSwN9ukwEfTltxBmQD+ylVsl6K08FOMzcgx13MS/0R6aSPKycCDlVbav6E1aLK655oQo/4Y6HGa9L/aGd5AmnG4XaaqEYZdczvGX3GTnq33jzLOg6VdnLTep/ahQp+tQdrAclqRDfYAVXutMNGEIMN7pJRlrNMMEvkxCPxGBdY+a+NZio67DBolJ+VEaXuqiX3B1G12hnfGBlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrPWbRnhcCW+HATEapINcyaPYKBAzAx6rl9bsrSMh1o=;
 b=s+gLBbMF10hqEZIVan1X9x2aCb5gshKrd5EmtkVj9OZ0QoVDPI2s81e794EAZBbWiFgjuREf4N6t4xZ0V53BPP9DX1F/lRTY27FKdqyRDQXDc8sL+/TjvUBHSRpc/CA2OGquuAfQdqg24b2Ouyjsiq0mxmFG9J7Pmx46PS9StD8=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB4261.eurprd05.prod.outlook.com (52.135.165.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 11 Dec 2019 23:25:09 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.016; Wed, 11 Dec 2019
 23:25:09 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkA==
Date:   Wed, 11 Dec 2019 23:25:09 +0000
Message-ID: <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191211142401.742189cf@cakuba.netronome.com>
In-Reply-To: <20191211142401.742189cf@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d54cea21-21f9-43b8-b83d-08d77e915d10
x-ms-traffictypediagnostic: AM6PR05MB4261:|AM6PR05MB4261:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB4261E91AFBD6CD0AF7B08E8BC55A0@AM6PR05MB4261.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(189003)(199004)(13464003)(51914003)(9686003)(2906002)(478600001)(7696005)(8936002)(186003)(26005)(8676002)(55016002)(81156014)(81166006)(86362001)(4326008)(5660300002)(316002)(76116006)(71200400001)(52536014)(33656002)(64756008)(66446008)(6506007)(54906003)(66476007)(66556008)(66946007)(53546011)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4261;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oYSePND5cITKFLmHYbHO7orevOi+F2l2ZTIOxSVO7RKKV7wReJw4FTzg2u7X4bKTnmlGrirUyCa7dGO4Zo76TWXkrvXkY2z+sPqeZmw4ZJDwKsd+wQTk6Oy5FXgLy13AbMkrVhlW/NG32Z91s2xLZAgbrBhKMdSCxkL8ihwLqOCMq8mjRxjMwcO3eGwX1jptAd65z1J1eOjrQ4UjJP8X3U+xuz9LyRBVk2Y8B7LpzNchAU5stE8w3PoGiSY3ZOCOcl4FBOJt5iXDqx7WsgWSao5RMgB+tkjIFzwWlVETpcAUfpcnrVfxbhE4U+RKmSmqxIApkGwtuDkPFsY1k5X4nZN6fNGP0U50bsWY4qjYRJJc3n+XhxsjNxboKv6czdI2m/7LfW7anNL6XN0x/pDfrQfWdI02RbWQu8nhGBEC3t0eD3hzHluaUYRja8bCNDnNgnCTtDtmPH9CYusrU+VsRKZhAvQkrs+MMVXFbefZkM+5W/x9fSmnWLdKCXyl+sYadhsgcYQgwWHNjR4qjcSweg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d54cea21-21f9-43b8-b83d-08d77e915d10
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 23:25:09.2169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ITUTXKp9DJ3O2Lm5/Xfdds8C2t0bajjiJbBDVsQfMi0f/b66xmsY6+78PnSmPeE73MPLyAW9rYW3BPEht8RVng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, December 11, 2019 2:24 PM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Wed, 11 Dec 2019 19:57:34 +0000, Yuval Avnery wrote:
> > > -----Original Message-----
> > > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > Sent: Wednesday, December 11, 2019 11:16 AM
> > > To: Yuval Avnery <yuvalav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > >
> > > On Wed, 11 Dec 2019 18:19:56 +0000, Yuval Avnery wrote:
> > > > > On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:
> > > > > > Currently there is no limit to the number of VFs netdevsim can
> enable.
> > > > > > In a real systems this value exist and used by driver.
> > > > > > Fore example, Some features might need to consider this value
> > > > > > when allocating memory.
> > > > >
> > > > > Thanks for the patch!
> > > > >
> > > > > Can you shed a little bit more light on where it pops up? Just
> > > > > for my
> > > curiosity?
> > > >
> > > > Yes, like we described in the subdev threads.
> > > > User should be able to configure some attributes before the VF was
> > > enabled.
> > > > So all those (persistent) VF attributes should be available for
> > > > query and configuration before VF was enabled.
> > > > The driver can allocate an array according to max_vfs to hold all
> > > > that data, like we do here in" vfconfigs".
> > >
> > > I was after more practical reasoning, are you writing some tests for
> > > subdev stuff that will depend on this change? :)
> >
> > Yes we are writing tests for subdev with this.
>=20
> Okay, please post v2 together with the tests. We don't accept netdevsim
> features without tests any more.

I think the only test I can currently write is the enable SR-IOV max_vfs en=
forcement.
Because subdev is not in yet.
Will that be good enough?

>=20
> > This is the way mlx5 works.. is that practical enough?
> >
> > > > > > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > > > > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > > > >
> > > > > > diff --git a/drivers/net/netdevsim/bus.c
> > > > > > b/drivers/net/netdevsim/bus.c index 6aeed0c600f8..f1a0171080cb
> > > > > > 100644
> > > > > > --- a/drivers/net/netdevsim/bus.c
> > > > > > +++ b/drivers/net/netdevsim/bus.c
> > > > > > @@ -26,9 +26,9 @@ static struct nsim_bus_dev
> > > > > > *to_nsim_bus_dev(struct device *dev)  static int
> > > > > > nsim_bus_dev_vfs_enable(struct nsim_bus_dev
> > > > > *nsim_bus_dev,
> > > > > >  				   unsigned int num_vfs)
> > > > > >  {
> > > > > > -	nsim_bus_dev->vfconfigs =3D kcalloc(num_vfs,
> > > > > > -					  sizeof(struct
> nsim_vf_config),
> > > > > > -					  GFP_KERNEL);
> > > > >
> > > > > You're changing the semantics of the enable/disable as well now.
> > > > > The old values used to be wiped when SR-IOV is disabled, now
> > > > > they will be retained across disable/enable pair.
> > > > >
> > > > > I think it'd be better if that wasn't the case. Users may expect
> > > > > a system to be in the same state after they enable SR-IOV,
> > > > > regardless if someone else used SR-IOV since last reboot.
> > > >
> > > > Right,
> > > > But some values should retain across enable/disable, for example
> > > > MAC
> > > address which is persistent.
> > > > So maybe we need to retain some values, while resetting others on
> > > disable?
> > > > Would that work?
> > >
> > > Mmm. That is a good question. For all practical purposes SR-IOV used
> > > to be local to the host that enables it until Smart/middle box NICs
> emerged.
> > >
> > > Perhaps the best way forward would be to reset the config that was
> > > set via legacy APIs and keep only the MACs provisioned via persistent
> devlink API?
> > >
> > > So for now we'd memset, and once devlink API lands reset selectively?
> >
> > Legacy is also persistent.
> > Currently when you set mac address with "ip link vf set mac" it is pers=
istent
> (at least in mlx5).
>=20
> "Currently in mlx5" - maybe, but this is netdevsim. Currently it clears t=
he
> config on re-enable which I believe to be preferable as explained before.
>=20
> > But ip link only exposes enabled VFS, so driver on VF has to reload to
> acquire this MAC.
> > With devlink subdev it will be possible to set the MAC before VF was
> enabled.
>=20
> Yup, sure. As I said, once subdev is implemented, we will treat the addre=
sses
> set by it differently. Those are inherently persistent or rather their li=
fe time is
> independent of just the SR-IOV host.

Ok, got it.
I am just wondering how this works when you have "ip link" and devlink sett=
ing the MAC independently.
Will they show the same MAC?
Or ip link will show the non-persistent MAC And devlink the persistent?

>=20
> > I think we need to distinguish here between:
> > - PF sets MAC to a VF - persistent.
> > - VF sets MAC to itself - not persistent.
> >
> > But is the second case relevant in netdevsim?
>=20
> Not sure where you're going with this. Second case, i.e. if VF sets its M=
AC, is
> not exposed in the hypervisor. I think iproute2 should still list the MAC=
 it
> provisioned, or 00:00.. if unset.

Yes, these are two different unrelated MACs.

>=20
> The two cases I'm differentiating is reset behaviour for addresses set vi=
a PF
> vs via devlink.
>=20
> > > > > Could you add a memset(,0,) here?
> > > > >
> > > > > > +	if (nsim_bus_dev->max_vfs < num_vfs)
> > > > > > +		return -ENOMEM;
> > > > > > +
> > > > > >  	if (!nsim_bus_dev->vfconfigs)
> > > > > >  		return -ENOMEM;
> > > > >
> > > > > This check seems useless now, no? We will always have vfconfigs
