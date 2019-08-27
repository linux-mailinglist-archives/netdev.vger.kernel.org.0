Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F4A9E8C7
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfH0NLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:11:25 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:28227
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbfH0NLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:11:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gH0lY8bFP4lILtFshstE/vE+NtaIbPfblUHKGj8GUzp6atjsGTrICy9BB55oniesEW0Ao2gxusxTQJ065IsCP3WJgvXBzBHcM8PPkOZflsiQA6VTQkaMhpSEydnawtBxB9LJ4ZTugoQC/OSGLbB0zb35888gZ/5bWKfCMrri+DLqOkBX7YkjvWyAm5RxvW9ZeDIztTVWQMy0NWABHuxqxh8rY029ukNLQMEDEx/xZhpZilMho+otGfjHV2ycwYpieCfb/20iC80TPFiYAgnCX5OeleAOPfZfJ+yx3k7CC3vbvzljjlyCzzBuMw1A4cY4pLrSFAWmasOtk8Iuzxq8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2sF5PmCOM3P72E+iKf+9b1pFo6P365bQaKfUnevJ7k=;
 b=R/TGl9zkS1NfH93ud4Mnp89E1l4KWNBrbbfxmdLLGqcA/NESQcmXn7pV+SYuZxfRCSUT3FAG1FhsS7xnq2wmE9pE+nIV+bl+p5n6aVGqpAPMeUd/bUaL7rPjg74Y32ov2IRuffYXMUEcUrwgynHHhmy7bF1slSlZ/tQV+58MxU2hzxk89IChLGfrx2fC4mDAhlmr4qwPSZoB0UJymnDgnlUxTI11QAObD+SgnGYBzSctdk+eS/pvsE5Xo8fIOjdH4f87kV2Q5IhSoL2stIvk9lF1OuD0nIBz8X2q8BwEHb4/uQ0/hQuWYt12VruPUREtPN6142esQuzAO5eic3n4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2sF5PmCOM3P72E+iKf+9b1pFo6P365bQaKfUnevJ7k=;
 b=fJTzz1u/yNFN0q7fIhM1r8zCyuOKwPK14ZQQE93P2ur1/0GkmJf/gn5WA5hh6ezHrHvRi7xMUjaQnbdz25Y0zQiH3Xaj6AnjP0sl7dyPKJ374RC07nWeqE5MnMXETLob6k+M+EBW8YZJoI9iBjDjaNCObpn1T4B3JB3j3YBJAYE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5700.eurprd05.prod.outlook.com (20.178.115.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 27 Aug 2019 13:11:18 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 13:11:18 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 0/4] Introduce variable length mdev alias
Thread-Topic: [PATCH 0/4] Introduce variable length mdev alias
Thread-Index: AQHVXE6oE0YRBz0PMky+S05YIDBwe6cO90Uw
Date:   Tue, 27 Aug 2019 13:11:17 +0000
Message-ID: <AM0PR05MB4866A24FF3D283F0F3CB3CDAD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
In-Reply-To: <20190826204119.54386-1-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46f87e37-894b-4515-4a6f-08d72af00c39
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5700;
x-ms-traffictypediagnostic: AM0PR05MB5700:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5700614E2E38C6B039D5AABCD1A00@AM0PR05MB5700.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(132844002)(199004)(189003)(13464003)(446003)(8676002)(6506007)(53546011)(102836004)(7736002)(55236004)(3846002)(5660300002)(74316002)(86362001)(26005)(64756008)(6436002)(66066001)(9686003)(7696005)(71200400001)(71190400001)(76116006)(256004)(4326008)(2501003)(53936002)(478600001)(66556008)(99286004)(66476007)(76176011)(25786009)(2201001)(55016002)(33656002)(14444005)(6116002)(110136005)(316002)(54906003)(8936002)(52536014)(2906002)(229853002)(14454004)(66946007)(9456002)(186003)(81166006)(81156014)(66446008)(11346002)(476003)(305945005)(6246003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5700;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nI7DJreF3bF2kWUj4OHotDkoXRABz49wTj/brcL03qaa46USMmOC6HfHH9AzsMv5oiOxSDr02+RYADMZMEnUhuvKMMpqZqoqTUWxfveIfrfcTF3PlfkPrSpLtiz+VQpmgZCcxeB2kaDACCu4vHxs0kNwIuKpzSuGrg5ByFgkeaIzaadR2kLsQlPiY79WKTD4uKU5zEpc2PXP0R1vLvHVxHDEVy5R+8c82VTHLcHj7/Mc7P/WBvYRdSoml97iNO1VMNDRlRV7o5jPjF17XXr61qloiUTudZCCdUVHTpwSfd+grHxOUqvlGX4Ap5i3Fsxirkwyqr6sFzhtzIOj/c9gZY1tJeCsVY1q39FWFQGMEFm9nYY5jm/Fmigq9qOzwFD+ji/R0qEMHrchYrcDXdH8oIIiSrz2NWRmX95PjecJ9WY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f87e37-894b-4515-4a6f-08d72af00c39
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 13:11:18.0793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UW3nCzZU47FGjF3tDJ3S9ZfAUDKZshc9sz6bx+QM4SuVvsfUQumUsMDr39c/qx0URtgLO5NMXmBZZFfpMVgkrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5700
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex, Cornelia,

> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Parav Pandit
> Sent: Tuesday, August 27, 2019 2:11 AM
> To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> Subject: [PATCH 0/4] Introduce variable length mdev alias
>=20
> To have consistent naming for the netdevice of a mdev and to have consist=
ent
> naming of the devlink port [1] of a mdev, which is formed using
> phys_port_name of the devlink port, current UUID is not usable because UU=
ID
> is too long.
>=20
> UUID in string format is 36-characters long and in binary 128-bit.
> Both formats are not able to fit within 15 characters limit of netdev nam=
e.
>=20
> It is desired to have mdev device naming consistent using UUID.
> So that widely used user space framework such as ovs [2] can make use of
> mdev representor in similar way as PCIe SR-IOV VF and PF representors.
>=20
> Hence,
> (a) mdev alias is created which is derived using sha1 from the mdev name.
> (b) Vendor driver describes how long an alias should be for the child mde=
v
> created for a given parent.
> (c) Mdev aliases are unique at system level.
> (d) alias is created optionally whenever parent requested.
> This ensures that non networking mdev parents can function without alias
> creation overhead.
>=20
> This design is discussed at [3].
>=20
> An example systemd/udev extension will have,
>=20
> 1. netdev name created using mdev alias available in sysfs.
>=20
> mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> mdev 12 character alias=3Dcd5b146a80a5
>=20
> netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethernet link m =
=3D
> mediated device
>=20
> 2. devlink port phys_port_name created using mdev alias.
> devlink phys_port_name=3Dpcd5b146a80a5
>=20
> This patchset enables mdev core to maintain unique alias for a mdev.
>=20
> Patch-1 Introduces mdev alias using sha1.
> Patch-2 Ensures that mdev alias is unique in a system.
> Patch-3 Exposes mdev alias in a sysfs hirerchy.
> Patch-4 Extends mtty driver to optionally provide alias generation.
> This also enables to test UUID based sha1 collision and trigger error han=
dling
> for duplicate sha1 results.
>=20
> In future when networking driver wants to use mdev alias, mdev_alias() AP=
I will
> be added to derive devlink port name.
>=20
Now that majority of above patches looks in shape and I addressed all comme=
nts,
In next v1 post, I was considering to include mdev_alias() and have example=
 use in mtty driver.

This way, subsequent series of mlx5_core who intents to use mdev_alias() AP=
I makes it easy to review and merge through Dave M, netdev tree.
Is that ok with you?
