Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9711BB8F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbfLKSUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:20:00 -0500
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:34725
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729296AbfLKSUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 13:20:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaxwoTc5pYOqOwg8S2lQqp+wltto9twUXDeoXTT1ZdjevXHI3V6YuYXKPiY+PY/Utlc3mfjzUAP6pECV2/ZWtAaB8lunxGYE/76Mnt3qcFQzQJFkGCXC/1iw/LBhoW9CkSL97Wd0LQhk3PO6fQ+v/DLWyDe1hZ8atiuGaoOvitguMNMr6YXrGKU8r4y7rYTLC6QPcZdcHFaJpbl1LUxRKpQ79W3GzTqcH2a577tR3nTBU0xjRnonhZCgKVV2NljfBcLX5gpnpHlYkjzgmgLSyHUi1FL8Lqm1asaNBx2JQSWrKEUSVM2yN9SNh5co7Wfebh94txlV6QJlaeZ5Sb0FCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zeh6KJpFa4o8VfTiwkKI1pqbjVf30vRdaFic9rfo0Xo=;
 b=lZf2JP280eNOthkTAz3c9iT3po/owG7J0XLrtC0yr3Y8FFS07u95ToztDeeE8zMq2hxEgaF3YtY5Fp5tIpLAQBG4A0hlsgb9Yu+kx2N2BohUFLMe4Af3GKuStTQ1+k5ibY+iyGgWyDgOO+rGLGTRyloHKT8pu7A2srB5CN8zBuETBPSrYutqHmjKXl5/NtKj1oaMlGaPNzWqH6ND+BKY+78pafSp8SESbRa3He2H0XsujTrT4IxFb5zjutJMCFCotBvDw0ltRHc5WpiN6tz8TrdTrnlyLCeKVrBp+jPAkLtvpQgPf7p5OuboCpxOuG1UylKaWAZ8TU8NnFRRRtiUTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zeh6KJpFa4o8VfTiwkKI1pqbjVf30vRdaFic9rfo0Xo=;
 b=iPAuwHCvdZJTcjZFkxvFcEtiUd8jirPFDrZMiojSXcHosjZYTMuOsLhA7aLpCUVgRrJMSZrRP6DazSr3R1lObTZVm3Kc4kS2ZGpAD9le+Z8eFq0PywP/NcFBrdsL1npMnPJlWBHBoyoFlwmzaazoXcekDVFn0fI3FrURmuCF+ME=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB6262.eurprd05.prod.outlook.com (20.177.34.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Wed, 11 Dec 2019 18:19:56 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.016; Wed, 11 Dec 2019
 18:19:56 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gA=
Date:   Wed, 11 Dec 2019 18:19:56 +0000
Message-ID: <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
 <20191211095854.6cd860f1@cakuba.netronome.com>
In-Reply-To: <20191211095854.6cd860f1@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 315209ea-e569-41f5-7c70-08d77e66b9a0
x-ms-traffictypediagnostic: AM6PR05MB6262:|AM6PR05MB6262:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6262E06A1F7414DF797DC595C55A0@AM6PR05MB6262.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(189003)(199004)(13464003)(51914003)(5660300002)(9686003)(186003)(26005)(4326008)(55016002)(54906003)(316002)(2906002)(53546011)(6916009)(66476007)(33656002)(81166006)(52536014)(66446008)(8936002)(64756008)(66556008)(8676002)(76116006)(7696005)(81156014)(66946007)(6506007)(478600001)(71200400001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6262;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ly3VhCPW6ZOv3oEBI/j9uI7ub2ERmC0kTbFfU7gkNJ/N+CNgz/zhWaAfeRx3RGAYcNCndB3//kaJhvcmu0WWGqXb1A5D1HDZftwAdkHlN0rMDLgULcTLmXqhJI8eJVjGaUt5fNAB7WTuruRYNMsvzxRIdFf6xWo1JWqJamNZNH29aBSTs4jLLRIrIU6gBuGTHsnUUQZRX5Vm2LvKZl2LyQ4y9pTnwa+ZeW2zUEz7HZ3BUoBb5aX5QrKAMj98do2m5ygrpUYdhyfkFMDHWAqQ8RWBq+jj0n2goYq6s9LzCEfE/pRvEUxC9G3XF69FoyEClkJkoHfjM2P0G9/QFJQ4qJhqUOpekfW47Zp6xBhWZCbcRp9njZ0y86dNP9WsW9rsyi3xJjCL/lRqiCXLSZSm+4eRDfAck/QQG95UgEYytj+rw0TAqcq0P0A0fqBvESDrbawtPtY3zA2dp7gKMNO9ERKoPq3wgJHUth3RnStEaqXqlv5Nd+NmtLysZN8gSUw9RwKjJ4VqZe1AMNza5H9Apg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315209ea-e569-41f5-7c70-08d77e66b9a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 18:19:56.1631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pnq1PpHMGmyhit8nfFOBG5q9OdjbiR7RE5E0CWADOVkxEw/RoKGqW1Usq30e5shEFn3uoEgXQhxmAtapeF9HQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6262
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, December 11, 2019 9:59 AM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:
> > Currently there is no limit to the number of VFs netdevsim can enable.
> > In a real systems this value exist and used by driver.
> > Fore example, Some features might need to consider this value when
> > allocating memory.
>=20
> Thanks for the patch!
>=20
> Can you shed a little bit more light on where it pops up? Just for my cur=
iosity?

Yes, like we described in the subdev threads.
User should be able to configure some attributes before the VF was enabled.
So all those (persistent) VF attributes should be available for query and c=
onfiguration
before VF was enabled.
The driver can allocate an array according to max_vfs to hold all that data=
,
like we do here in" vfconfigs".

>=20
> > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
>=20
> > diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> > index 6aeed0c600f8..f1a0171080cb 100644
> > --- a/drivers/net/netdevsim/bus.c
> > +++ b/drivers/net/netdevsim/bus.c
> > @@ -26,9 +26,9 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct
> > device *dev)  static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev
> *nsim_bus_dev,
> >  				   unsigned int num_vfs)
> >  {
> > -	nsim_bus_dev->vfconfigs =3D kcalloc(num_vfs,
> > -					  sizeof(struct nsim_vf_config),
> > -					  GFP_KERNEL);
>=20
> You're changing the semantics of the enable/disable as well now.
> The old values used to be wiped when SR-IOV is disabled, now they will be
> retained across disable/enable pair.
>=20
> I think it'd be better if that wasn't the case. Users may expect a system=
 to be
> in the same state after they enable SR-IOV, regardless if someone else us=
ed
> SR-IOV since last reboot.

Right,=20
But some values should retain across enable/disable, for example MAC addres=
s which is persistent.
So maybe we need to retain some values, while resetting others on disable?
Would that work?

>=20
> Could you add a memset(,0,) here?
>=20
> > +	if (nsim_bus_dev->max_vfs < num_vfs)
> > +		return -ENOMEM;
> > +
> >  	if (!nsim_bus_dev->vfconfigs)
> >  		return -ENOMEM;
>=20
> This check seems useless now, no? We will always have vfconfigs
>=20
> >  	nsim_bus_dev->num_vfs =3D num_vfs;
> > @@ -38,8 +38,6 @@ static int nsim_bus_dev_vfs_enable(struct
> > nsim_bus_dev *nsim_bus_dev,
> >
> >  static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev
> > *nsim_bus_dev)  {
> > -	kfree(nsim_bus_dev->vfconfigs);
> > -	nsim_bus_dev->vfconfigs =3D NULL;
> >  	nsim_bus_dev->num_vfs =3D 0;
> >  }
> >
> > @@ -154,22 +152,29 @@ static struct device_type nsim_bus_dev_type =3D {
> > };
> >
> >  static struct nsim_bus_dev *
> > -nsim_bus_dev_new(unsigned int id, unsigned int port_count);
> > +nsim_bus_dev_new(unsigned int id, unsigned int port_count,
> > +		 unsigned int max_vfs);
> > +
> > +#define NSIM_BUS_DEV_MAX_VFS 4
> >
> >  static ssize_t
> >  new_device_store(struct bus_type *bus, const char *buf, size_t count)
> > {
> >  	struct nsim_bus_dev *nsim_bus_dev;
> >  	unsigned int port_count;
> > +	unsigned int max_vfs;
> >  	unsigned int id;
> >  	int err;
> >
> > -	err =3D sscanf(buf, "%u %u", &id, &port_count);
> > +	err =3D sscanf(buf, "%u %u %u", &id, &port_count, &max_vfs);
> >  	switch (err) {
> >  	case 1:
> >  		port_count =3D 1;
> >  		/* fall through */
> >  	case 2:
> > +		max_vfs =3D NSIM_BUS_DEV_MAX_VFS;
> > +		/* fall through */
> > +	case 3:
> >  		if (id > INT_MAX) {
> >  			pr_err("Value of \"id\" is too big.\n");
> >  			return -EINVAL;
>=20
> Is 0 VFs okay? will kcalloc(0, size, flags) behave correctly?

Right, I will fix.

>=20
> > @@ -179,7 +184,7 @@ new_device_store(struct bus_type *bus, const char
> *buf, size_t count)
> >  		pr_err("Format for adding new device is \"id port_count\"
> (uint uint).\n");
> >  		return -EINVAL;
> >  	}
> > -	nsim_bus_dev =3D nsim_bus_dev_new(id, port_count);
> > +	nsim_bus_dev =3D nsim_bus_dev_new(id, port_count, max_vfs);
> >  	if (IS_ERR(nsim_bus_dev))
> >  		return PTR_ERR(nsim_bus_dev);
> >
> > @@ -267,7 +272,8 @@ static struct bus_type nsim_bus =3D {  };
> >
> >  static struct nsim_bus_dev *
> > -nsim_bus_dev_new(unsigned int id, unsigned int port_count)
> > +nsim_bus_dev_new(unsigned int id, unsigned int port_count,
> > +		 unsigned int max_vfs)
> >  {
> >  	struct nsim_bus_dev *nsim_bus_dev;
> >  	int err;
> > @@ -284,12 +290,24 @@ nsim_bus_dev_new(unsigned int id, unsigned int
> port_count)
> >  	nsim_bus_dev->dev.type =3D &nsim_bus_dev_type;
> >  	nsim_bus_dev->port_count =3D port_count;
> >  	nsim_bus_dev->initial_net =3D current->nsproxy->net_ns;
> > +	nsim_bus_dev->max_vfs =3D max_vfs;
> > +
> > +	nsim_bus_dev->vfconfigs =3D kcalloc(nsim_bus_dev->max_vfs,
> > +					  sizeof(struct nsim_vf_config),
> > +					  GFP_KERNEL);
> > +	if (!nsim_bus_dev->vfconfigs) {
> > +		err =3D -ENOMEM;
> > +		goto err_nsim_bus_dev_id_free;
> > +	}
> >
> >  	err =3D device_register(&nsim_bus_dev->dev);
> >  	if (err)
> > -		goto err_nsim_bus_dev_id_free;
> > +		goto err_nsim_vfconfigs_free;
> > +
> >  	return nsim_bus_dev;
> >
> > +err_nsim_vfconfigs_free:
> > +	kfree(nsim_bus_dev->vfconfigs);
> >  err_nsim_bus_dev_id_free:
> >  	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> >  err_nsim_bus_dev_free:
> > @@ -301,6 +319,7 @@ static void nsim_bus_dev_del(struct nsim_bus_dev
> > *nsim_bus_dev)  {
> >  	device_unregister(&nsim_bus_dev->dev);
> >  	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> > +	kfree(nsim_bus_dev->vfconfigs);
> >  	kfree(nsim_bus_dev);
> >  }
> >
> > diff --git a/drivers/net/netdevsim/netdevsim.h
> > b/drivers/net/netdevsim/netdevsim.h
> > index 94df795ef4d3..e2049856add8 100644
> > --- a/drivers/net/netdevsim/netdevsim.h
> > +++ b/drivers/net/netdevsim/netdevsim.h
> > @@ -238,6 +238,7 @@ struct nsim_bus_dev {
> >  	struct net *initial_net; /* Purpose of this is to carry net pointer
> >  				  * during the probe time only.
> >  				  */
> > +	unsigned int max_vfs;
> >  	unsigned int num_vfs;
> >  	struct nsim_vf_config *vfconfigs;
> >  };

