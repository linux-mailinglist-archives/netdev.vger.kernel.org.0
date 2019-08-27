Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE79F219
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfH0SLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:11:39 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:50551
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727887AbfH0SLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 14:11:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfyG/8vLVx2pAX6BnBnjn4S+hQPZ2eR/XvWL+SN10evUvnOOqiTnxEAPNHVQHDUy1YY9r7A0tpMT9szqDZZvNRYn6yQrFMK9BYAAUpaysHE3OgpdDgDPFpKwuutnwocB7VcqRkaK64cwyLpd1ABoAA9mKZyJpstlJqMr3xGfyKVEWUbcddZHs4usKIOafJryeXq7it1zRdE/51Dev4jOzMH/EQEDz5pfCAylpUV5KcmGhTd8CvPpNLGpryHNtcu22egV7gInYcxrnk9tHOS/r1l0y6hsBsy9ugdwKY2vFiVXqbo91LI8QxWKADuAfjeyfYVkXwNAECvDDfdGG6MZgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUXkmyXVak3F7G1Nqv5fB8j/CABnPalvwGpZujIrrAE=;
 b=VShp5JA+wUrHxcPorZ9re+2jjWT24gBPt0PkOV9ReehaCPYnJgOR8bfRGojOkRt+gwFS0eIwKWJX/s0seSTPIBU+SrVYLAsLGtC+JbNPxu/E+Tl8Co28L4WNIYqbm49g1UD/VmSg5pUS2vIfoIXtoAmnjO1PtuEC2ZufnhoXuyn6f56In8IDxxGbpjTlOlyrkkgpI16RqNRekzGaSMPVyPDd8pniQiiUQJHJ1QgJCBBEPIAt0hqvOEISglSW01d9LqgL9hN4OfuDUjl20sQ4qyqeTz1LnNojRjcT+zIJ73lmMNILA9zGCTM4apMLtnuilRXC5NgzO+UVWfgda9KWfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUXkmyXVak3F7G1Nqv5fB8j/CABnPalvwGpZujIrrAE=;
 b=Rq8zqfOeR5q1SUrvdfuh9tOrH+XcSLbNZ9xWcnZ9AfDG7qDGNS/qMyUv8CGt9H+UhaKqnB9X0o8YtRSs1/D3WYBkH2N1FhRBOHMjjXqyzZH8FAAminbew2T/0PoW762vG2+dBaoHBy3cwroWhZN6Sb+ellwNKbURfHdURpkRtb0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5233.eurprd05.prod.outlook.com (20.178.16.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Tue, 27 Aug 2019 18:11:33 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 18:11:33 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 0/4] Introduce variable length mdev alias
Thread-Topic: [PATCH 0/4] Introduce variable length mdev alias
Thread-Index: AQHVXE6oE0YRBz0PMky+S05YIDBwe6cO90UwgABPfgCAAASicA==
Date:   Tue, 27 Aug 2019 18:11:32 +0000
Message-ID: <AM0PR05MB4866E5EA8D8ABFB1A40F60DCD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <AM0PR05MB4866A24FF3D283F0F3CB3CDAD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827114852.499dd8cf@x1.home>
In-Reply-To: <20190827114852.499dd8cf@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bc9e8c4-7d61-4a82-6c7e-08d72b19fde7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5233;
x-ms-traffictypediagnostic: AM0PR05MB5233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB52333E976D60D42F02D82069D1A00@AM0PR05MB5233.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(189003)(199004)(132844002)(13464003)(76116006)(7736002)(26005)(8936002)(186003)(99286004)(305945005)(9456002)(14454004)(86362001)(76176011)(102836004)(53546011)(6506007)(2906002)(478600001)(7696005)(74316002)(55236004)(6916009)(5660300002)(55016002)(71190400001)(9686003)(66066001)(25786009)(476003)(8676002)(11346002)(446003)(81156014)(81166006)(53936002)(4326008)(66476007)(66556008)(64756008)(66446008)(6246003)(3846002)(6116002)(229853002)(54906003)(52536014)(14444005)(256004)(316002)(6436002)(71200400001)(486006)(33656002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5233;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E1A3i9F/sBmukH2Eq1aSo+eD/J/QBI4P413YDUd8/FSpq41kOK8tx4vonAC2zSUY0TzFFA4/zO0g/1JkHQO2gGmWMebAZGf0+varne9IhosvuEP66eCcc7VAVcMS+jg5fzu+Fl0z9qDTp8Yq/aSUCXNpt5dNBo19uTQug6IfxGywMFu+8Cxa9TKCcnOwh/QEJyxQ5SROQ9+lHiZPKGeCkuN/AXSHDaerC4aHtfj0OFLb7IS5Nt5WZU3QtH9ICKsPL9o0Eop/GQlKTwyCrqFcsfAYucsduI0LF0fKZtyeKJH1Hxo/ks7rWSS071H+1Lc4P7XrVdUDCnBYY7nqZZIwSH7ogApLYo/Krhto6Pmdseio0Gxm8sj73Kf2qIm3Px1UNkTWW//WmF5oki8Nolj/R86GEMiLK3quSkReVOBFnK4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc9e8c4-7d61-4a82-6c7e-08d72b19fde7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 18:11:32.8024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OQCTsUguT7yFpyGaL7bJXDzn6AHasyK7TPuAiZH+ABACAem1e2Q6teXJOehsZbeISjLumoz0Fii63Q40DfqRug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 27, 2019 11:19 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 0/4] Introduce variable length mdev alias
>=20
> On Tue, 27 Aug 2019 13:11:17 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Hi Alex, Cornelia,
> >
> > > -----Original Message-----
> > > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
> > > Behalf Of Parav Pandit
> > > Sent: Tuesday, August 27, 2019 2:11 AM
> > > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > > Subject: [PATCH 0/4] Introduce variable length mdev alias
> > >
> > > To have consistent naming for the netdevice of a mdev and to have
> > > consistent naming of the devlink port [1] of a mdev, which is formed
> > > using phys_port_name of the devlink port, current UUID is not usable
> > > because UUID is too long.
> > >
> > > UUID in string format is 36-characters long and in binary 128-bit.
> > > Both formats are not able to fit within 15 characters limit of netdev
> name.
> > >
> > > It is desired to have mdev device naming consistent using UUID.
> > > So that widely used user space framework such as ovs [2] can make
> > > use of mdev representor in similar way as PCIe SR-IOV VF and PF
> representors.
> > >
> > > Hence,
> > > (a) mdev alias is created which is derived using sha1 from the mdev
> name.
> > > (b) Vendor driver describes how long an alias should be for the
> > > child mdev created for a given parent.
> > > (c) Mdev aliases are unique at system level.
> > > (d) alias is created optionally whenever parent requested.
> > > This ensures that non networking mdev parents can function without
> > > alias creation overhead.
> > >
> > > This design is discussed at [3].
> > >
> > > An example systemd/udev extension will have,
> > >
> > > 1. netdev name created using mdev alias available in sysfs.
> > >
> > > mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > > mdev 12 character alias=3Dcd5b146a80a5
> > >
> > > netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethernet lin=
k m
> > > =3D mediated device
> > >
> > > 2. devlink port phys_port_name created using mdev alias.
> > > devlink phys_port_name=3Dpcd5b146a80a5
> > >
> > > This patchset enables mdev core to maintain unique alias for a mdev.
> > >
> > > Patch-1 Introduces mdev alias using sha1.
> > > Patch-2 Ensures that mdev alias is unique in a system.
> > > Patch-3 Exposes mdev alias in a sysfs hirerchy.
> > > Patch-4 Extends mtty driver to optionally provide alias generation.
> > > This also enables to test UUID based sha1 collision and trigger
> > > error handling for duplicate sha1 results.
> > >
> > > In future when networking driver wants to use mdev alias,
> > > mdev_alias() API will be added to derive devlink port name.
> > >
> > Now that majority of above patches looks in shape and I addressed all
> > comments, In next v1 post, I was considering to include mdev_alias()
> > and have example use in mtty driver.
> >
> > This way, subsequent series of mlx5_core who intents to use
> > mdev_alias() API makes it easy to review and merge through Dave M,
> > netdev tree. Is that ok with you?
>=20
> What would be the timing for the mlx5_core use case?  Can we coordinate
> within the same development cycle?  I wouldn't want someone to come
> clean up the sample driver and remove the API ;)  Thanks,
>=20
We targeted it for 5.4. mdev_alias was the only known user interface issue,=
 which is resolved.
Some more internal reviews are in progress.
It might be tight for 5.4, if not 5.4, it should happen in 5.5.

I agree, that is why I was holding up to be part of this series.
Since its very small API, even if there is any merge conflict, it is easy t=
o resolve.
If this change can be merged through netdev tree, its better to include it =
as part of mlx5_core's mdev series.
So both options are fine, a direction from you is better to have.
