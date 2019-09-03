Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06837A5FEE
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 05:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfICDxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 23:53:16 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:47450
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfICDxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 23:53:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwMIW3aXmLKy+ylkC7qO53deeIqcx9WGqWmk6zfwzuDuEKfTpZPkgv1wgcO0l/5rD6RQfUZO94PlkoiQhnLG+qwxHT2xaD0f1oREpTkql84/mE3K/gVvQ5/wrz8WlR83Wgs5XbseY/lV8JevJxS00tKYq9lzsW2mfXIDQNcsRxsufqIsrRvwAtjcw7YEcuQoljzJd1+Vs3s5jtqBT/Bp5mRgMthu7k17uO8K5u5a42Ne5ZQRoR0YTEkH093/KmqZ4CBb/js+G/0vBXhNNm9pl8f1g/z2uANckrhlRSfYRejmHgHQclvqmCgbIPY5VH+JvlKBrdoQL1YeoL1k0W+Ldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sf6+LwRqV6sey/uQTzAY9iQSu87mQAHDP05mlKFSonk=;
 b=VP5M9DpHapINwxbOwX63LbB3qEyBG6neMPGBT0v6MPZMDELWOjo8J4PfTQl9oFg8gcKHQsdNciCk9kTiPtFj7TW+v6Jod3K2l6GkRPZeW7K07eQKsFQa3YsJ6Hq+hHqH8Luj9zbbydkgeYbcqns7m0P9ecTKCOPOlWzkATKsQ9E0Zm4Nls2XelVDFGjqexOm5AtYW2XfPo/nF6exGIuCpHQSY6He0lGArADckocekaAtm/wrgvc6RiHY9dGLYgedAMSYonUSrQkHadvKWd1AvWZqOK2b55VXQ+18+YWa5PvjkYXrI6s/7eDCspoBf3SUeAu6sLUO3IaKSTuI3o8VXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sf6+LwRqV6sey/uQTzAY9iQSu87mQAHDP05mlKFSonk=;
 b=NO88nIykHZB678mSN38h/PWYnKTXCuyzdn8jmt98oH0foinxSc1mW4k2FlhqgzFJu/XPKQ/hUL6Hq0y6XwMaLisV0F3nAIdWKPWToCdtsH0aIM4IQ7+equGixMDi9XWSoByNzYSrkglPKowGCC3Lmsf6yjRs9XQ7DZyEsmD6JFQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4161.eurprd05.prod.outlook.com (52.134.91.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Tue, 3 Sep 2019 03:53:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2220.022; Tue, 3 Sep 2019
 03:53:09 +0000
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
Thread-Index: AQHVXlukaBbEcdZ2I0ipQhJUiMmPLacTpf+AgAADNNCABNHVAIAA3UqQ
Date:   Tue, 3 Sep 2019 03:53:09 +0000
Message-ID: <AM0PR05MB4866F561B753094BE0824411D1B90@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-6-parav@mellanox.com>
        <20190830144927.7961193e.cohuck@redhat.com>
        <AM0PR05MB4866372C521F59491838C8E4D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190902163658.51fc48d2.cohuck@redhat.com>
In-Reply-To: <20190902163658.51fc48d2.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e844a223-3403-4940-0435-08d730223c85
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4161;
x-ms-traffictypediagnostic: AM0PR05MB4161:|AM0PR05MB4161:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB416149D81F2AE745EE276BF1D1B90@AM0PR05MB4161.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(13464003)(189003)(199004)(6916009)(71190400001)(71200400001)(66066001)(53936002)(11346002)(52536014)(486006)(15650500001)(476003)(6436002)(6246003)(5660300002)(446003)(6116002)(14444005)(256004)(55016002)(55236004)(86362001)(76116006)(102836004)(478600001)(26005)(66556008)(66476007)(64756008)(66446008)(9686003)(53546011)(6506007)(74316002)(316002)(3846002)(186003)(9456002)(99286004)(2906002)(8936002)(7736002)(76176011)(305945005)(33656002)(229853002)(54906003)(4326008)(8676002)(66946007)(7696005)(25786009)(81166006)(81156014)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4161;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vnToOFCyiwEhldOus2W3oQ1QvrEHbojTtyrl/sGbu8IbmoXcdLjSJJL1UQEPbEtojAlbRz4tu2/PQZbAGse0ti7tshTSQxq2KNVaC7aMkBSpGuPyPaiO6C3IVqbaVTcD0UfWq8MFqygJUJ/r3Z3d/ccFwjrRMtzLB2m9B448dfw3jzgikKnZ5W9VQp7FWbUfe+PDyQ7rx+YuBEu42HAoafhSlqrVs3KdJlo+184iGcRCtqJUJ3fUX5EMl+0kWpmTQCt++6v05wbvAzp/RwIXH8zTv3WHtMM2ZEwKZw8LGOJQww60QNmBOTDKNrwY3nrnsvG90Q/VlRXt44Ft4+CxIdcOuGKXrhxGNoZVrWZM5WsciRW+2lwoWAy57p/j3Uqwbebv06R9TE9jsj+vKIpbBuYnWR9bDnkPOmHerzcXVVI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e844a223-3403-4940-0435-08d730223c85
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 03:53:09.7416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HbS5Ke6weJVEdcSVZXP8G80ClH5XJKKQqgBW1rd5QsA+s/2vWwZx26Ok7S6V/NdJAqY5A/Afh0c/IKs2GVH0eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, September 2, 2019 8:07 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 5/6] mdev: Update sysfs documentation
>=20
> On Fri, 30 Aug 2019 13:10:17 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Friday, August 30, 2019 6:19 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 5/6] mdev: Update sysfs documentation
> > >
> > > On Thu, 29 Aug 2019 06:19:03 -0500
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > Updated documentation for optional read only sysfs attribute.
> > >
> > > I'd probably merge this into the patch introducing the attribute.
> > >
> > Ok. I will spin v3.
> >
> > > >
> > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > ---
> > > >  Documentation/driver-api/vfio-mediated-device.rst | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> > > > b/Documentation/driver-api/vfio-mediated-device.rst
> > > > index 25eb7d5b834b..0ab03d3f5629 100644
> > > > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > > > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > > > @@ -270,6 +270,7 @@ Directories and Files Under the sysfs for Each
> > > > mdev
> > > Device
> > > >           |--- remove
> > > >           |--- mdev_type {link to its type}
> > > >           |--- vendor-specific-attributes [optional]
> > > > +         |--- alias [optional]
> > >
> > > "optional" implies "not always present" to me, not "might return a
> > > read error if not available". Don't know if there's a better way to
> > > tag this? Or make it really optional? :)
> >
> > May be write it as,
> >
> > alias [ optional when requested by parent ]
>=20
> I'm not sure what 'optional when requested' is supposed to mean...
> maybe something like 'content optional' or so?
>=20
> >
> > >
> > > >
> > > >  * remove (write only)
> > > >
> > > > @@ -281,6 +282,10 @@ Example::
> > > >
> > > >  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
> > > >
> > > > +* alias (read only)
> > > > +Whenever a parent requested to generate an alias, each mdev is
> > > > +assigned a unique alias by the mdev core. This file shows the
> > > > +alias of the
> > > mdev device.
> > >
> > > It's not really the parent, but the vendor driver requesting this,
> > > right? Also,
> > At mdev level, it only knows parent->ops structure, whether parent is
> registered by vendor driver or something else.
>=20
> Who else is supposed to create the mdev device?
If you nitpick the language what is the vendor id for sample mttty driver?
Mtty is not a 'vendor driver' per say.

>=20
> >
> > > "each mdev" is a bit ambiguous,
> > It is in context of the parent. Sentence is not starting with "each mde=
v".
> > But may be more verbosely written as,
> >
> > Whenever a parent requested to generate an alias, Each mdev device of
> > such parent is assigned unique alias by the mdev core. This file shows =
the
> alias of the mdev device.
>=20
> I'd really leave the parent out of this: this seems more like an
> implementation detail. It's more that alias may either contain an alias, =
or
> return a read error if no alias has been generated. Who requested the ali=
as
> to be generated is probably not really of interest to the userspace reade=
r.
>

The documentation is for user and developer both.
It is not the right claim that 'only user care' for this.
Otherwise all the .ko diagrams and API description etc doesn't make any sen=
se to the user.

For user it doesn't matter whether alias length is provided by 'vendor driv=
er' or 'registered parent'.
This note on who should specify the alias length is mainly for the develope=
rs.
=20
> >
> > > created via that driver. Lastly, if we stick with the "returns an
> > > error if not implemented" approach, that should also be mentioned
> here.
> > Ok. Will spin v3 to describe it.
> >
> > >
> > > > +
> > > >  Mediated device Hot plug
> > > >  ------------------------
> > > >
> >

