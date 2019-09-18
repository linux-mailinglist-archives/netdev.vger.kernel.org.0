Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BAEB68CB
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 19:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbfIRRQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 13:16:03 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:6305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbfIRRQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 13:16:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFck5S15JJiV7PN/BFJJ8s3cr3UVgDoVqWOL7+c03XssBrZCpox3OTZG/Oi/6Bid6Kk7osy4qmzkBhEGl+E5+OOp+H3wbmuT2X6PqBiv0g7YA+UAm6Fi2SzymtucehCiXwxaa+V089iOOHPbpVTxngfLhBMdp+2mydjSe0d91ZAAtiWwvStK/m2mOhUdsNbT8foDvVxGnId2EA6FPIIe3y0kjgJykF2guxSD59EYzx4Rfvin7d7+l62Gjb3Ab65U1eEakR83/KVMo5vWuwL5XinfzHARMDuCgquz/zZD49S5WLhB0G1Ed82/IgY8FRnoxh59FeVfumdxbBBbFev/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9dczobqtw8rbBsi6y3LaHyll5Q64WXKqJNZRuiPQ5U=;
 b=WXhF6DHdmKLeQfzZ12IeuSB2XlM/9uwZJ0oF2SRCpPiZhAqzmfEB8UGH0HJU/nV/df8ldGUzypmbAq4y+gp/9+6Iu6EypIAC4ClufxY/b7FXZ8AuQuz4NHfA/rU2cmgJZSH9VefAHANI3NLk7hDPIgpUQsMe4D5jkgbyzyMvKxKg+oiiUaLxYsQG7sKFRJs7JxBUslBtO73B27Mf7psSpL9hYurSBeKxzptB1hNIbtWbBgZ9SBP48j4baQc36ZarQI56Ph5T/OEdz6jQ4/IwVzhSGeo/BFuNGLSnYTFArO0Up8/ATbtFuMQja9JRpX660HvtXEC/XLtgN78YYUdLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9dczobqtw8rbBsi6y3LaHyll5Q64WXKqJNZRuiPQ5U=;
 b=YhdXqXnoJ2DeVUi99LPNQzCj9j+VwjJShrMCxSNQCdvPCm33itUthSeQ8Qo5EHgDzHELDwBGxmZysqoh3/TwWFdRrCnB1LyVU8ZMh9mX8jO3XOaXXp8P1BGLKwy2a42Vn1Kbhe9+sGmFSwsHE60Z7cdyYBizGoovT6tr3/xXF5U=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6388.eurprd05.prod.outlook.com (20.179.35.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Wed, 18 Sep 2019 17:15:58 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2263.023; Wed, 18 Sep 2019
 17:15:58 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Topic: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Index: AQHVYUZdAS6KYIr8SUO1vQ8myuXcNacvvq6AgAIHUSA=
Date:   Wed, 18 Sep 2019 17:15:58 +0000
Message-ID: <AM0PR05MB4866EA74D8C47F28C7435B0CD18E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
 <20190917121357.02480c09.cohuck@redhat.com>
In-Reply-To: <20190917121357.02480c09.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 068a336b-8ebb-44bc-6ad9-08d73c5bdf70
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6388;
x-ms-traffictypediagnostic: AM0PR05MB6388:|AM0PR05MB6388:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6388F295205372DD6C405C71D18E0@AM0PR05MB6388.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(189003)(199004)(13464003)(54534003)(51914003)(8936002)(7736002)(66946007)(478600001)(66446008)(486006)(8676002)(66066001)(316002)(33656002)(476003)(25786009)(54906003)(4326008)(229853002)(81156014)(81166006)(52536014)(2906002)(6306002)(55016002)(76176011)(3846002)(86362001)(26005)(446003)(11346002)(102836004)(186003)(305945005)(6246003)(6506007)(74316002)(53546011)(71190400001)(9686003)(66476007)(6916009)(14444005)(256004)(64756008)(966005)(66556008)(71200400001)(76116006)(99286004)(7696005)(5660300002)(6436002)(6116002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6388;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H/LqQOlhkHlsgw0qbJE2eUi/Q+f9X06e0HoQvGfm7fGlAAkV+wub+sCnuOEooUEpcD29OBQqpl3M66LVLZV7rhODtouCUIMkmRb6hnJ07nyOWZ3sV2mXtWIyKT16UpVEMteg9e2E7vYVJbzUt5VLqZGSgpZzSQ5SLJPtZbAmHiG/5YWOUVGSOIXWnojwizbcX5XLFtjs3OV2VZTQaimXp7FGWuzPMeNk4bTwZEyePDcUa6/JYc+rPw14JjGTO10U5egE4QyCl7Li9xdBU/VmZlksPTIrH7Hf5f9jGIdLIHnHEQtJml7u6+ce3UNICT5ExwZzCaj3LqCCCartzlXlesF6mQzfcqWKOqzC1sA3yFkhgBdNpY/c17+XfWyYtTlTMO/Ct1I0AMDKxKtMYgIbOs9PUpmIYAmbg68OK8Lw8+8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068a336b-8ebb-44bc-6ad9-08d73c5bdf70
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2019 17:15:58.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xlz5265V5Pji2UY6vs5lkpsGIzxkgwfOvTAsxtvEeL42MPxeZ/kGWbZ6QPM+hwUId9Xk8bhJMtVygGhBKngelQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6388
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cornelia,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, September 17, 2019 5:14 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
>=20
> On Sun,  1 Sep 2019 23:24:31 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > To have consistent naming for the netdevice of a mdev and to have
> > consistent naming of the devlink port [1] of a mdev, which is formed
> > using phys_port_name of the devlink port, current UUID is not usable
> > because UUID is too long.
> >
> > UUID in string format is 36-characters long and in binary 128-bit.
> > Both formats are not able to fit within 15 characters limit of netdev
> > name.
> >
> > It is desired to have mdev device naming consistent using UUID.
> > So that widely used user space framework such as ovs [2] can make use
> > of mdev representor in similar way as PCIe SR-IOV VF and PF representor=
s.
> >
> > Hence,
> > (a) mdev alias is created which is derived using sha1 from the mdev nam=
e.
> > (b) Vendor driver describes how long an alias should be for the child
> > mdev created for a given parent.
> > (c) Mdev aliases are unique at system level.
> > (d) alias is created optionally whenever parent requested.
> > This ensures that non networking mdev parents can function without
> > alias creation overhead.
> >
> > This design is discussed at [3].
> >
> > An example systemd/udev extension will have,
> >
> > 1. netdev name created using mdev alias available in sysfs.
> >
> > mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > mdev 12 character alias=3Dcd5b146a80a5
> >
> > netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethernet link =
m =3D
> > mediated device
> >
> > 2. devlink port phys_port_name created using mdev alias.
> > devlink phys_port_name=3Dpcd5b146a80a5
> >
> > This patchset enables mdev core to maintain unique alias for a mdev.
> >
> > Patch-1 Introduces mdev alias using sha1.
> > Patch-2 Ensures that mdev alias is unique in a system.
> > Patch-3 Exposes mdev alias in a sysfs hirerchy, update Documentation
> > Patch-4 Introduces mdev_alias() API.
> > Patch-5 Extends mtty driver to optionally provide alias generation.
> > This also enables to test UUID based sha1 collision and trigger error
> > handling for duplicate sha1 results.
> >
> > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > [3] https://patchwork.kernel.org/cover/11084231/
> >
> > ---
> > Changelog:
> > v2->v3:
> >  - Addressed comment from Yunsheng Lin
> >  - Changed strcmp() =3D=3D0 to !strcmp()
> >  - Addressed comment from Cornelia Hunk
> >  - Merged sysfs Documentation patch with syfs patch
> >  - Added more description for alias return value
> > v1->v2:
> >  - Corrected a typo from 'and' to 'an'
> >  - Addressed comments from Alex Williamson
> >  - Kept mdev_device naturally aligned
> >  - Added error checking for crypt_*() calls
> >  - Moved alias NULL check at beginning
> >  - Added mdev_alias() API
> >  - Updated mtty driver to show example mdev_alias() usage
> >  - Changed return type of generate_alias() from int to char*
> > v0->v1:
> >  - Addressed comments from Alex Williamson, Cornelia Hunk and Mark
> > Bloch
> >  - Moved alias length check outside of the parent lock
> >  - Moved alias and digest allocation from kvzalloc to kzalloc
> >  - &alias[0] changed to alias
> >  - alias_length check is nested under get_alias_length callback check
> >  - Changed comments to start with an empty line
> >  - Added comment where alias memory ownership is handed over to mdev
> > device
> >  - Fixed cleaunup of hash if mdev_bus_register() fails
> >  - Updated documentation for new sysfs alias file
> >  - Improved commit logs to make description more clear
> >  - Fixed inclusiong of alias for NULL check
> >  - Added ratelimited debug print for sha1 hash collision error
> >
> > Parav Pandit (5):
> >   mdev: Introduce sha1 based mdev alias
> >   mdev: Make mdev alias unique among all mdevs
> >   mdev: Expose mdev alias in sysfs tree
> >   mdev: Introduce an API mdev_alias
> >   mtty: Optionally support mtty alias
> >
> >  .../driver-api/vfio-mediated-device.rst       |   9 ++
> >  drivers/vfio/mdev/mdev_core.c                 | 142 +++++++++++++++++-
> >  drivers/vfio/mdev/mdev_private.h              |   5 +-
> >  drivers/vfio/mdev/mdev_sysfs.c                |  26 +++-
> >  include/linux/mdev.h                          |   5 +
> >  samples/vfio-mdev/mtty.c                      |  13 ++
> >  6 files changed, 190 insertions(+), 10 deletions(-)
> >
>=20
> The patches on their own look sane (and I gave my R-b), but the consumer =
of
> this new API should be ready before this is merged, as already discussed =
below.

Thanks for the review. I will send v4 here to address all comments and to a=
dd your R-b tag.
I am waiting for Saeed to post other prep series of mlx5_core to be merged =
before I post actual consumer series, as it depends on it.
I will also drop the mtty sample patch and change-log to avoid confusion wi=
th versions when I combine them with consumer series.

