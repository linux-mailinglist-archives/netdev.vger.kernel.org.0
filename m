Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E131C9DC00
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 05:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfH0DaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 23:30:15 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:17216
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbfH0DaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 23:30:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvZd5WRoxKw/uK7+8fM+q5OOj/r6S7QGOZCCocu/s77WiHrZAG5sk0PzNTmpUK6zwVRJi7vNjmvVFmlwqAB67MNxdi4q+JzTO/eJTelZqqmdJKBId0ou/uLcrmtCj2hd86lqlIcpO61iQe9ca5BqothskVU7b0vEEKtID1+NWwkZn03sbEyB3DLFY3auP3DySYTwN7PRNibzU+hNz5uNrxyh5zE0yjY9HA4DB71o+vv/v6IcGlh24zUNrcpl12TiYBQnXPYfhsp+EPIYUPjW4oq8EgJ9tEDXZs4uFZeAEWRjOyYIeoduy03K+BjhLicQBqZvOR6DnUHXOcOb7+CNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZSPlNOCwUZMj6XR9sCV1bZ05G8t4bbAfCYBuVyT5Jg=;
 b=CFVFwSXoYj4gMUGEdaXvSEmqBJLV5UC8c/3SHxcuOvIn5uDP+5UEf8I2dNMZEj7GVePrHjzKw4IJozFMoRcwHyFoPpR/xx0LCuRzEaPPIce2NNUREaMVwT3pbmOfYgAeYoAOvkZGGCtkGsXN+NP0+/gkRiiJQWk/u/PVy5WxBiXRaSUgmeZ+K3eo8Vmmlwxs5xT76iwtBY4x/FcZTwQ84bhb/ECzlN4y5+A3ljT2MSKsCG7EkMgXOAPtz1UDX6Lz9ELOQOtdapxYmT0Z58P2mf8FwlPCYPVpeSDP/ecL16s/t3SQEmQxQLqfDF79JlIVlLRSD4po6Vmm1gq2tLptww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZSPlNOCwUZMj6XR9sCV1bZ05G8t4bbAfCYBuVyT5Jg=;
 b=jnVRYejzI2B9kwlIs/rZf8d7pN/CxOeGC8WUV4Z2ZbmwcSIUlDc2cQfTVWhZn3DWK0oImANvYQdv7GCaPbncUwGDOwiaqDqHZ1ILVzOSqBoJ3gxztfOr4U9ZnTH682r5857kv65x3p6K9AVuZ4UBCP7kSYwU9aX4OYvhheeY7zo=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6211.eurprd05.prod.outlook.com (20.178.116.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 03:30:11 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 03:30:11 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Thread-Topic: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Thread-Index: AQHVXE6v3Mg2zMVvBUG6schRq+9Lx6cOO+yAgAAZDuA=
Date:   Tue, 27 Aug 2019 03:30:10 +0000
Message-ID: <AM0PR05MB486636E2D53BCF051CA776F4D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com> <20190826195349.2ed6c1dc@x1.home>
In-Reply-To: <20190826195349.2ed6c1dc@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44dc3441-8c7c-47aa-d88e-08d72a9eddce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6211;
x-ms-traffictypediagnostic: AM0PR05MB6211:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB621147CB6C5ECA429BCE8C23D1A00@AM0PR05MB6211.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(13464003)(189003)(199004)(99286004)(6506007)(53546011)(81156014)(81166006)(26005)(71200400001)(102836004)(25786009)(2906002)(6116002)(8676002)(7736002)(186003)(6246003)(76176011)(71190400001)(55236004)(3846002)(8936002)(66066001)(256004)(7696005)(53936002)(9686003)(54906003)(14454004)(6916009)(316002)(4326008)(55016002)(229853002)(478600001)(33656002)(5660300002)(74316002)(6436002)(486006)(476003)(11346002)(446003)(9456002)(66476007)(76116006)(86362001)(52536014)(66946007)(66446008)(64756008)(66556008)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6211;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 08S7veonT8DR/+a58CW04I2b2SuHaDQPPWsb/JrZ41ttynnvQv/oNyVpRAsDKWZVVw11OGgd5XmuMU6Auh8QfW7jxJswFVIzadOaArkiqZefi6HYcX3Jxlg9RZEE47QosNMfyjhr40C9foILTDMIAiiqyLw/D2sCkuAQ/qESsi19epm6psZ/fS/NsHQWezr++aQ0FyAPaXYuXPVMilcEfMo/LHYbEgEbvUuSFoC5Gtzl2UdVp4CyM1XEY0dH/ofGsjwmDBhtgbYcNcyhbJZ2OnET0J9wLIsU9S29tCjNgZCC9CGR1+9nnmXohSHRfGDHy9GNbm1zhhVfS8JO9tgfj7XH4js8TKSnbmEneFPS9G8J4OR1UW+bwkDt03aLEzI81Su7en1X60DQk4vA+Av73qhBccSehbNnB718wcKJFnE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dc3441-8c7c-47aa-d88e-08d72a9eddce
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 03:30:10.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p1comWh3NxvqEai440wAQMG24K/rC7wPXaI1n996J9o2E0a9qvaquSkN5MjQO2GPfCjaaU44ANqXW5i/lRU82A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6211
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 27, 2019 7:24 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
>=20
> On Mon, 26 Aug 2019 15:41:18 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Expose mdev alias as string in a sysfs tree so that such attribute can
> > be used to generate netdevice name by systemd/udev or can be used to
> > match other kernel objects based on the alias of the mdev.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_sysfs.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> > b/drivers/vfio/mdev/mdev_sysfs.c index 43afe0e80b76..59f4e3cc5233
> > 100644
> > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > @@ -246,7 +246,20 @@ static ssize_t remove_store(struct device *dev,
> > struct device_attribute *attr,
> >
> >  static DEVICE_ATTR_WO(remove);
> >
> > +static ssize_t alias_show(struct device *device,
> > +			  struct device_attribute *attr, char *buf) {
> > +	struct mdev_device *dev =3D mdev_from_dev(device);
> > +
> > +	if (!dev->alias)
> > +		return -EOPNOTSUPP;
>=20
> Wouldn't it be better to not create the alias at all?  Thanks,
>=20
In other subsystem such as netdev sysfs files are always created that retur=
ns either returns EOPNOTSUPP or attribute value.
I guess overhead of create multiple groups or creating individual sysfs fil=
es outweigh the simplify of single group.
I think its ok to keep it simple this way.

> Alex
>=20
> > +
> > +	return sprintf(buf, "%s\n", dev->alias); } static
> > +DEVICE_ATTR_RO(alias);
> > +
> >  static const struct attribute *mdev_device_attrs[] =3D {
> > +	&dev_attr_alias.attr,
> >  	&dev_attr_remove.attr,
> >  	NULL,
> >  };

