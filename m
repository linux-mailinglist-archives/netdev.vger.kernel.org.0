Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A441995D4A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbfHTLZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:25:12 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:9285
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729748AbfHTLZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:25:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAzpJkwku6B34XKIWyf4qJHFz8YlEoDJccyrUEWrPk7SYoOHAfgWDlA/9v2jSDOoGkI8CX9on2+eC/fYGjk8t4ntx19I5Kg6J/kddfx+bTlWg6fhxe57Wk9ppwA0/IEhyYXS2X5E/8xrFUxyn14T+dv2gFhWkraR4ovsDB1rx/Yuf+aYLxg67Jhaac47yqVTKPi4nJTbIwQ6kHSRGFQGBjiYLHCneFSSECMEV/cRg/5SIsLNMEsUDja8gTStg4CemfiabH9P4K5ARltjj7TbGGSlfMTZlgxMkzJ2biZqopFllvASxliv9oiJRaurWsIYGgbQcHOr5FNIxVOnhln8uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qaxmEjJq8TTXQSLiF5GUyfuoLfNXUg9Q5h9wPZ8CR8=;
 b=FCuI9QFR1i6RFtTwCvj1w+xrOPbLmZPGR2JNhfYvYgILtOPfAsenrz8Du6HqpTx6DfRtAWN+3u8grEotTtH8uKlLHTjkQnkGQruJiPLX/lPwx/XVijMOXsS4TeK5QeAkUW9U0mfJySMPfPFfgI38ggzyf10d/no45WIO7iAYWI8y5KdegK1mCj3VueDI14PpbA2YwgIPvsItCxjsdMThUPoEY6iL88HI4arLZJdIqvDc6CAnCor4QN0nhKJsuZ8drMgVxRnC7+Z42CuN400rKAu0Ff2vLoZ1Cbvg2Nhuq4IXU7K+vpE9nuByu45gm5ZbuzO8mWyhdiO1Cg7FIiWXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qaxmEjJq8TTXQSLiF5GUyfuoLfNXUg9Q5h9wPZ8CR8=;
 b=fpG7/fsGFRMb7nFszAvaAZ4KnnfFLuOphO9wNWiQi5fJ1ito88i00pdas8XnsIembjb76GeSSfgFj00DyAQwr5zCzf4CNxADKYTZ+O5RsHpR3Ri0VFOvwp2ouC/S11zb7fyemCWlMcCLmsA/LO71UyaMMb6PMHEU3tyHhKnOSPM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4435.eurprd05.prod.outlook.com (52.134.95.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 11:25:05 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 11:25:05 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
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
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAB4NgIAAFSMQ
Date:   Tue, 20 Aug 2019 11:25:05 +0000
Message-ID: <AM0PR05MB4866EBB51F7019F2E3D9918CD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
 <20190808141255.45236-1-parav@mellanox.com> <20190808170247.1fc2c4c4@x1.home>
 <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
 <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190813085246.1d642ae5@x1.home>
 <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190813111149.027c6a3c@x1.home>
 <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190814100135.1f60aa42.cohuck@redhat.com>
 <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190814150911.296da78c.cohuck@redhat.com>
 <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190814085746.26b5f2a3@x1.home>
 <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <m1o90kduow.fsf@dinechin.org>
In-Reply-To: <m1o90kduow.fsf@dinechin.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9770445e-51e3-4888-a2c3-08d725610ce1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4435;
x-ms-traffictypediagnostic: AM0PR05MB4435:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4435AF67574A538A23D4B3CBD1AB0@AM0PR05MB4435.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(189003)(13464003)(199004)(478600001)(71190400001)(256004)(71200400001)(99286004)(14454004)(14444005)(76176011)(66476007)(55016002)(66946007)(76116006)(8676002)(66556008)(81156014)(8936002)(81166006)(25786009)(4326008)(64756008)(66446008)(229853002)(9456002)(9686003)(6436002)(102836004)(186003)(486006)(5660300002)(52536014)(6916009)(6246003)(53936002)(66066001)(6116002)(55236004)(3846002)(6506007)(446003)(476003)(11346002)(2906002)(7696005)(54906003)(7736002)(305945005)(316002)(86362001)(74316002)(26005)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4435;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jj1biMZZXt2N7oDUyLqDWih3TfbI0TlwmUekEsTtoDLYVSVwhSSKeXlQpciIuvEunsrHXVeRK+ZDEH/n+RAJ8UpTQmwQcVKmfujsuSHKBqDpwLArDMee/WAyxb1GueMZeBjVU4Xhr8CqpqgXNZqZH/DxCiPtxjCehPR62yWqurZcS6mYjTmZX+T6fJFHywSwM2FIst+Shx/Zwau6VqJKwjtPYMOM19qh4t3L3OZWZmRCYHufxZqH8kgI9YcBJRzJVYW40ZNeDcgidNxTNGCHwSTyG1PHkf1eKoEOydAKAi0POouRIVCPMjJPQElzVbj5SCAkJtSmsIzpbYnzzxvaH+CYakSEhnz9adwZs/ERWzo1Mm2flgQ3bA7OCu5KKIPf1TDRVWWCtWF7KQDo6fqCZXARa0AdeXoqevyUIVLiQDU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9770445e-51e3-4888-a2c3-08d725610ce1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 11:25:05.3104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7/0SRiC2o1Znck68T+KxeN+jvNo8aeAqTdRwTzSBxKVfGHi72M9jG133d+yQ1+aOnULSdsr0PLYsp0JMG0/60Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4435
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Christophe de Dinechin <christophe.de.dinechin@gmail.com>
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
>=20
> Parav Pandit writes:
>=20
> > + Dave.
> >
> > Hi Jiri, Dave, Alex, Kirti, Cornelia,
> >
> > Please provide your feedback on it, how shall we proceed?
> >
> > Hence, I would like to discuss below options.
> >
> > Option-1: mdev index
> > Introduce an optional mdev index/handle as u32 during mdev create time.
> > User passes mdev index/handle as input.
> >
> > phys_port_name=3DmIndex=3Dm%u
> > mdev_index will be available in sysfs as mdev attribute for udev to nam=
e the
> mdev's netdev.
> >
> > example mdev create command:
> > UUID=3D$(uuidgen)
> > echo $UUID index=3D10 >
> > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > example netdevs:
> > repnetdev=3Dens2f0_m10	/*ens2f0 is parent PF's netdevice */
> > mdev_netdev=3Denm10
> >
> > Pros:
> > 1. mdevctl and any other existing tools are unaffected.
> > 2. netdev stack, ovs and other switching platforms are unaffected.
> > 3. achieves unique phys_port_name for representor netdev 4. achieves
> > unique mdev eth netdev name for the mdev using udev/systemd extension.
> > 5. Aligns well with mdev and netdev subsystem and similar to existing s=
riov
> bdf's.
> >
> > Option-2: shorter mdev name
> > Extend mdev to have shorter mdev device name in addition to UUID.
> > such as 'foo', 'bar'.
> > Mdev will continue to have UUID.
> > phys_port_name=3Dmdev_name
> >
> > Pros:
> > 1. All same as option-1, except mdevctl needs upgrade for newer usage.
> > It is common practice to upgrade iproute2 package along with the kernel=
.
> > Similar practice to be done with mdevctl.
> > 2. Newer users of mdevctl who wants to work with non_UUID names, will u=
se
> newer mdevctl/tools.
> > Cons:
> > 1. Dual naming scheme of mdev might affect some of the existing tools.
> > It's unclear how/if it actually affects.
> > mdevctl [2] is very recently developed and can be enhanced for dual nam=
ing
> scheme.
> >
> > Option-3: mdev uuid alias
> > Instead of shorter mdev name or mdev index, have alpha-numeric name
> alias.
> > Alias is an optional mdev sysfs attribute such as 'foo', 'bar'.
> > example mdev create command:
> > UUID=3D$(uuidgen)
> > echo $UUID alias=3Dfoo >
> > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > example netdevs:
> > examle netdevs:
> > repnetdev =3D ens2f0_mfoo
> > mdev_netdev=3Denmfoo
> >
> > Pros:
> > 1. All same as option-1.
> > 2. Doesn't affect existing mdev naming scheme.
> > Cons:
> > 1. Index scheme of option-1 is better which can number large number of
> mdevs with fewer characters, simplifying the management tool.
>=20
> I believe that Alex pointed out another "Cons" to all three options, whic=
h is that
> it forces user-space to resolve potential race conditions when creating a=
n index
> or short name or alias.
>=20
This race condition exists for at least two subsystems that I know of, i.e.=
 netdev and rdma.
If a device with a given name exists, subsystem returns error.
When user space gets error code EEXIST, and it can picks up different ident=
ifier(s).

> Also, what happens if `index=3D10` is not provided on the command-line?
> Does that make the device unusable for your purpose?
Yes, it is unusable to an extent.
Currently we have DEVLINK_PORT_FLAVOUR_PCI_VF in include/uapi/linux/devlink=
.h
Similar to it, we need to have DEVLINK_PORT_FLAVOUR_MDEV for mdev eswitch p=
orts.
This port flavour needs to generate phys_port_name(). This should be user p=
arameter driven.
Because representor netdevice name is generated based on this parameter.
