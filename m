Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF111C528
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 06:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLLFLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 00:11:17 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:60319
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbfLLFLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 00:11:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhqGYOVnafdsqGcwJdWL2m47soNSfsxjGxd7mzSm9KpmqvLum8BGQZN9Y4PQqVSqXogeR3OAPNc1YZjFLHEchyG/Cn4cJ8br9FEd4cto32aS7IIBfBGogLwrPwSXQHUJ61mFzIsisYSB4zr+xJa4tHYQTaxRg/1GruKrML3F5cTo8NyTJC0Lr+GURwAENAFthq7lX+cvKO210VrmvQkCXsWU5qw3aJk9PdelFFk0WcCupOZUYfwKeAow7xrLRrblT1mBbNRzYl0efPtgNL1UsJMeQVYBttV+UoBlNytY0Sm3JIVo8N/O+j6Oftak7dX/c4wXHIkfsltYXOYAiFP/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVkwxwhZPr4eWZquHBtRYnUSF28kjuIdjitjSlEhGh4=;
 b=dMoBjkEjWEfa7Cl2VoelqI6wzYJ6O7UZh491cY1+8Y9syQlLqkqBp1RCM/ZpAyypgD1ZLEe7w+wNBdtcNZThNlwXykrlx/EqNJlxKdeLf065Y8UstZp6euFuD7Q2M/6yuYsB1y1JuWfsCU+nxodeMm44w5JCZVB+VTYCpJGTguACIcYtQ9JsaCv3XGVAyPVN+fee2xg8NTk1Gvnn9gV63/lYpcAWSYSwNZbshfnjlt+vkkGh2P132aVF+PRhPeREeSPZvcs/JkSKkTJxgz02QiYGabZf2dYYoS4iNFPYqDomOZVoidiYUSp10KlbB/lPncBmF5hJf3wuMl4x1Z6vjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVkwxwhZPr4eWZquHBtRYnUSF28kjuIdjitjSlEhGh4=;
 b=I5XwWjWbD0YmP3tiO8yM5gY3HZxuIERnfurtMLhQbjUWI4n5AwB4A5S4bfs89fm6rfsufYNR8qxXC5ddAWLUGzCZFHo5qoak5vxAuJZ1iKRgGj74C/p0KzX2KCU/Slldn4wyZxXqKz7t3tWdTZhyqOMz9mWidp0wczUIcFxhjYc=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB5443.eurprd05.prod.outlook.com (20.177.117.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.16; Thu, 12 Dec 2019 05:11:12 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 05:11:12 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkIAAC50AgABVJmA=
Date:   Thu, 12 Dec 2019 05:11:12 +0000
Message-ID: <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191211154952.50109494@cakuba.netronome.com>
In-Reply-To: <20191211154952.50109494@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11b89d97-da03-4d1e-404a-08d77ec1b4fe
x-ms-traffictypediagnostic: AM6PR05MB5443:|AM6PR05MB5443:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB544336EC288420984408048AC5550@AM6PR05MB5443.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(189003)(199004)(13464003)(51914003)(186003)(81166006)(81156014)(4326008)(26005)(86362001)(8936002)(71200400001)(6916009)(33656002)(478600001)(2906002)(9686003)(52536014)(7696005)(66476007)(64756008)(53546011)(6506007)(8676002)(55016002)(316002)(66946007)(54906003)(66556008)(66446008)(76116006)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5443;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o8x26Gpq6O3M7OPg/eD2UGVT1tGQ83hrkspIMGNjIa6Yo1NxOiIqGfpaP4rrbyZnHvvL3SCXiPpC+rTKmu6ktIZjuX48rowpOAau/WrMb/8jeCOlJiCR+padpihzMA1UNw+Yw19KuHGn3EiOqzLMzf7TeZVUTvqyf2rBMtEaKMr239poOEHeanASyiwLZ0k4mGynjKUUXifdEO+0TAw+EMWFx6lade0IMNvqver2/qwA89PBF14KsvhR6CyRb38TgSl0IECoMFS32v9t/6QhNt4Z1IMRSe457XS5erQPICIUfdWY2GmpJd9tyspjl2alR8Yxg+tZrAJlTbDhwYrnCAT2cR94hLJeBeVydl2wG+OR6nYSZtNkLHussiw6CaiWQiGOcP4yqJBQ9ubPm87I6ateJStJhj+lz7x4kjO9ypFW1u8QMmEmXeost+wLNzwZq+1oi8zLvMa7K5ZHYK+41QCOQJBSZ5LmCVVD6oMPeFDm8y3+OeeglTJx+hIrAVX8B7TRCsxokmyGrsiRvVSV9Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b89d97-da03-4d1e-404a-08d77ec1b4fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 05:11:12.4784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfZaMyi7wj5y6YBHgqWX1R7sx4nmBwYkSdL3hg/6f6fxu+GqrKFQ+NbvLC8sMka1w72W4eL2qn0Vsz3e80cSlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5443
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, December 11, 2019 3:50 PM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Wed, 11 Dec 2019 23:25:09 +0000, Yuval Avnery wrote:
> > > -----Original Message-----
> > > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > Sent: Wednesday, December 11, 2019 2:24 PM
> > > To: Yuval Avnery <yuvalav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > >
> > > On Wed, 11 Dec 2019 19:57:34 +0000, Yuval Avnery wrote:
> > > > > -----Original Message-----
> > > > > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > > > Sent: Wednesday, December 11, 2019 11:16 AM
> > > > > To: Yuval Avnery <yuvalav@mellanox.com>
> > > > > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > > > >
> > > > > On Wed, 11 Dec 2019 18:19:56 +0000, Yuval Avnery wrote:
> > > > > > > On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:
> > > > > > > > Currently there is no limit to the number of VFs netdevsim =
can
> enable.
> > > > > > > > In a real systems this value exist and used by driver.
> > > > > > > > Fore example, Some features might need to consider this
> > > > > > > > value when allocating memory.
> > > > > > >
> > > > > > > Thanks for the patch!
> > > > > > >
> > > > > > > Can you shed a little bit more light on where it pops up?
> > > > > > > Just for my
> > > > > curiosity?
> > > > > >
> > > > > > Yes, like we described in the subdev threads.
> > > > > > User should be able to configure some attributes before the VF
> > > > > > was
> > > > > enabled.
> > > > > > So all those (persistent) VF attributes should be available
> > > > > > for query and configuration before VF was enabled.
> > > > > > The driver can allocate an array according to max_vfs to hold
> > > > > > all that data, like we do here in" vfconfigs".
> > > > >
> > > > > I was after more practical reasoning, are you writing some tests
> > > > > for subdev stuff that will depend on this change? :)
> > > >
> > > > Yes we are writing tests for subdev with this.
> > >
> > > Okay, please post v2 together with the tests. We don't accept
> > > netdevsim features without tests any more.
> >
> > I think the only test I can currently write is the enable SR-IOV max_vf=
s
> enforcement.
> > Because subdev is not in yet.
> > Will that be good enough?
>=20
> It'd be good to test some netdev API rather than just the enforcement its=
elf
> which is entirely in netdevsim, I think.
>=20
> So max_vfs enforcement plus checking that ip link lists the correct numbe=
r of
> entries (and perhaps the entries are in reset state after
> enable) would do IMO.

Ok, but this is possible regardless of my patch (to enable vfs).

>=20
> > > > This is the way mlx5 works.. is that practical enough?
> > > >
> > > > > > > > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > > > > > > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > > > > > >
> > > > > > > > diff --git a/drivers/net/netdevsim/bus.c
> > > > > > > > b/drivers/net/netdevsim/bus.c index
> > > > > > > > 6aeed0c600f8..f1a0171080cb
> > > > > > > > 100644
> > > > > > > > --- a/drivers/net/netdevsim/bus.c
> > > > > > > > +++ b/drivers/net/netdevsim/bus.c
> > > > > > > > @@ -26,9 +26,9 @@ static struct nsim_bus_dev
> > > > > > > > *to_nsim_bus_dev(struct device *dev)  static int
> > > > > > > > nsim_bus_dev_vfs_enable(struct nsim_bus_dev
> > > > > > > *nsim_bus_dev,
> > > > > > > >  				   unsigned int num_vfs)  {
> > > > > > > > -	nsim_bus_dev->vfconfigs =3D kcalloc(num_vfs,
> > > > > > > > -					  sizeof(struct
> > > nsim_vf_config),
> > > > > > > > -					  GFP_KERNEL);
> > > > > > >
> > > > > > > You're changing the semantics of the enable/disable as well n=
ow.
> > > > > > > The old values used to be wiped when SR-IOV is disabled, now
> > > > > > > they will be retained across disable/enable pair.
> > > > > > >
> > > > > > > I think it'd be better if that wasn't the case. Users may
> > > > > > > expect a system to be in the same state after they enable
> > > > > > > SR-IOV, regardless if someone else used SR-IOV since last reb=
oot.
> > > > > >
> > > > > > Right,
> > > > > > But some values should retain across enable/disable, for
> > > > > > example MAC
> > > > > address which is persistent.
> > > > > > So maybe we need to retain some values, while resetting others
> > > > > > on
> > > > > disable?
> > > > > > Would that work?
> > > > >
> > > > > Mmm. That is a good question. For all practical purposes SR-IOV
> > > > > used to be local to the host that enables it until Smart/middle
> > > > > box NICs
> > > emerged.
> > > > >
> > > > > Perhaps the best way forward would be to reset the config that
> > > > > was set via legacy APIs and keep only the MACs provisioned via
> > > > > persistent
> > > devlink API?
> > > > >
> > > > > So for now we'd memset, and once devlink API lands reset
> selectively?
> > > >
> > > > Legacy is also persistent.
> > > > Currently when you set mac address with "ip link vf set mac" it is
> > > > persistent
> > > (at least in mlx5).
> > >
> > > "Currently in mlx5" - maybe, but this is netdevsim. Currently it
> > > clears the config on re-enable which I believe to be preferable as
> explained before.
> > >
> > > > But ip link only exposes enabled VFS, so driver on VF has to
> > > > reload to
> > > acquire this MAC.
> > > > With devlink subdev it will be possible to set the MAC before VF
> > > > was
> > > enabled.
> > >
> > > Yup, sure. As I said, once subdev is implemented, we will treat the
> > > addresses set by it differently. Those are inherently persistent or
> > > rather their life time is independent of just the SR-IOV host.
> >
> > Ok, got it.
> > I am just wondering how this works when you have "ip link" and devlink
> setting the MAC independently.
> > Will they show the same MAC?
> > Or ip link will show the non-persistent MAC And devlink the persistent?
>=20
> My knee jerk reaction is that we should populate the values to those set =
via
> devlink upon SR-IOV enable, but then if user overwrites those values that=
's
> their problem.
>=20
> Sort of mirror how VF MAC addrs work, just a level deeper. The VF default=
s
> to the MAC addr provided by the PF after reset, but it can change it to
> something else (things may stop working because spoof check etc. will dro=
p
> all its frames, but nothing stops the VF in legacy HW from writing its MA=
C
> addr register).
>=20
> IOW the devlink addr is the default/provisioned addr, not necessarily the
> addr the PF has set _now_.
>=20
> Other options I guess are (a) reject the changes of the address from the =
PF
> once devlink has set a value; (b) provide some device->control CPU notifi=
er
> which can ack/reject a request from the PF to change devlink's value..?
>=20
> You guys posted the devlink patches a while ago, what was your
> implementation doing?

devlink simply calls the driver with set or get.
It is up to the vendor driver/HW if to make this address persistent or not.
The address is not saved in the devlink layer.
The MAC address in mlx5 is stored in the HW and
persistent (until PF reset) , whether it is set by devlink or ip link.

So from what I understand, we have the freedom to choose how netdevsim
behave in this case, which means non-persistent is ok.

