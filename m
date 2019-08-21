Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8AAF96FB6
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 04:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfHUCmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 22:42:19 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:48782
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfHUCmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 22:42:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OklyOIZX7LX3BMn0GfraMRmxEKgX0eHk9pL33HwXvC7H549O7+9DArSVFX4rtxRIsCVf22JwcjPscJ6U2ZN1mUrumimI6i/8vkXVDLLa1Kc7FdsxwPCkd2s62IylW82YE0eUSOK6nDG5uReqNaBUgSPkRTdMqAoDUSAbrtxZFI9gQN6yh+B+5YLaQ5EPjTW5Ij2Mqy5GVaiyYpGRyQBZ/tSrPqYeEysvHEBeJ8oGHXQ7yLxgqJrpBxqmNGn8h/fL7NG7JBccUdj7zAjjed7Xz2TyQkCfl2jPPXMgpkwFUNiN2mzgWqhgqa9SLXVSRGyz4cEtMmNCBZRKtmECrF3FCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtu6v425T++j/bRaAVr/iHT7hwgCA5pTKHProD8IYos=;
 b=IIyYQLm992CTV2wmeem2bLYp5MUt6XUvOYsLe3S2NYrqaTmEIg03PQ3uy7Y+G9IYj+Jokigpge1nCoZXj/CZyRaedqkT187xT6RqbIVY8dTuB/635PFT/HEX2DrHco9rAK9y6H54IGdwlftaV8I7sbAtRurfeXwnh1PeyS6nmxnxnLaHnoPwO0IAErcUGtkkptsj8KNEeeKT9FfssgulDgPvNe2vpLSEr4nI327SddV05hs5y0NjVBHHbBsdfOwVe4prKpYD2OhjAc6etiVUzrPV9L6RiESTIW59A8bAjBPRr3C9Ff7EFqAgBBlfCKyYDEy4oEdU7clNEJ/nM1WXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtu6v425T++j/bRaAVr/iHT7hwgCA5pTKHProD8IYos=;
 b=URqBvnV9XP2w8dega8m31c7BIiYl0aGTOXPvCprIoXmCKBxwqcAUoFeP+UsvP8zpMGfK4VGqsmE7bRf13VgrWBTrdThaHxXKMnMOB62Pk/LGsfR4n0P9KBNWQv1e08eD8KJut/W2NA0xlEZCT8rnnLz5ublz5fzhg/tCln5F3Qk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5060.eurprd05.prod.outlook.com (20.176.214.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 02:42:00 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 02:42:00 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAB4NgIAAFSMQgABYcACAAKhrQA==
Date:   Wed, 21 Aug 2019 02:42:00 +0000
Message-ID: <AM0PR05MB4866DF5936E1550EEDFB3B78D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
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
        <AM0PR05MB4866EBB51F7019F2E3D9918CD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820183106.1680d0d9.cohuck@redhat.com>
In-Reply-To: <20190820183106.1680d0d9.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30e43e50-d196-4a0f-74d2-08d725e12466
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5060;
x-ms-traffictypediagnostic: AM0PR05MB5060:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB50603A28D831110740251BFFD1AA0@AM0PR05MB5060.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(189003)(199004)(13464003)(186003)(99286004)(6246003)(229853002)(316002)(26005)(86362001)(81166006)(2906002)(54906003)(76176011)(102836004)(7696005)(25786009)(66066001)(11346002)(76116006)(33656002)(64756008)(66476007)(486006)(66946007)(74316002)(7736002)(4326008)(305945005)(6916009)(66556008)(66446008)(9686003)(8936002)(52536014)(55016002)(446003)(9456002)(476003)(478600001)(6116002)(256004)(53936002)(71190400001)(5660300002)(3846002)(8676002)(81156014)(6436002)(71200400001)(55236004)(14454004)(6506007)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5060;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gFv5iiA/WVPCjDfoFA098zdO/H8nNl++kzLtIZQkpfYvZrb3ahEF/he3GZVb+BExcWP49FGx/zTmjdgPdP8xECtk18/oOPBtPsOk6/mNjX0xIyrb8jPW36b74xDqtfzwcUfAgdcBqdPhHIQ79iJdj5MxtThOnYSuf/S+eOtyJiOJpg0MCyIrGphAEBsWoRF1ZqOXX5bPlHvJIrep9uuXvwuDc4qYrVptpBLufpsYpm0FEiZSlVzZnI/9xoYLPzs6nxNroyqc7RHo+k1RByZG1r1idOXjV86aIst8LmYn2fblh4AadKjjsogMR6mOkbtzvqk1jsEzwk0tCMTC+HBeSE1UaUgHph6491PkpqMGRvLHHbuTr2r1A78BGdH1pGaozlMhIA9UlKOxRq03qANjg58pRVSN3aAkX0ez+wiOuQY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e43e50-d196-4a0f-74d2-08d725e12466
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 02:42:00.3369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g9p/Ihv+ITsGhGs6qg8jGYR+hkyRMUkEtvKMX/w5AU1ms9G5UHWLcUKv2CyKlKiSV441E8dtmRZ6WotoyiZKCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 20, 2019 10:01 PM
> > > > Option-1: mdev index
> > > > Introduce an optional mdev index/handle as u32 during mdev create
> time.
> > > > User passes mdev index/handle as input.
> > > >
> > > > phys_port_name=3DmIndex=3Dm%u
> > > > mdev_index will be available in sysfs as mdev attribute for udev
> > > > to name the
> > > mdev's netdev.
> > > >
> > > > example mdev create command:
> > > > UUID=3D$(uuidgen)
> > > > echo $UUID index=3D10 >
> > > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > > > example netdevs:
> > > > repnetdev=3Dens2f0_m10	/*ens2f0 is parent PF's netdevice */
> > > > mdev_netdev=3Denm10
> > > >
> > > > Pros:
> > > > 1. mdevctl and any other existing tools are unaffected.
> > > > 2. netdev stack, ovs and other switching platforms are unaffected.
> > > > 3. achieves unique phys_port_name for representor netdev 4.
> > > > achieves unique mdev eth netdev name for the mdev using udev/system=
d
> extension.
> > > > 5. Aligns well with mdev and netdev subsystem and similar to
> > > > existing sriov
> > > bdf's.
> > > >
> > > > Option-2: shorter mdev name
> > > > Extend mdev to have shorter mdev device name in addition to UUID.
> > > > such as 'foo', 'bar'.
> > > > Mdev will continue to have UUID.
>=20
> I fail to understand how 'uses uuid' and 'allow shorter device name'
> are supposed to play together?
>=20
Each mdev will have uuid as today. Instead of naming device based on UUID, =
name it based on explicit name given by the user.
Again, I want to repeat, this name parameter is optional.

> > > > phys_port_name=3Dmdev_name
> > > >
> > > > Pros:
> > > > 1. All same as option-1, except mdevctl needs upgrade for newer usa=
ge.
> > > > It is common practice to upgrade iproute2 package along with the ke=
rnel.
> > > > Similar practice to be done with mdevctl.
> > > > 2. Newer users of mdevctl who wants to work with non_UUID names,
> > > > will use
> > > newer mdevctl/tools.
> > > > Cons:
> > > > 1. Dual naming scheme of mdev might affect some of the existing too=
ls.
> > > > It's unclear how/if it actually affects.
> > > > mdevctl [2] is very recently developed and can be enhanced for
> > > > dual naming
> > > scheme.
>=20
> The main problem is not tools we know about (i.e. mdevctl), but those we =
don't
> know about.
>=20
Well, if it not part of the distros, there is very little can do about it b=
y kernel.
I tried mdevctl with mdev named using non UUID and it were able to list the=
m.

> IOW, this (and the IFNAMESIZ change, which seems even worse) are the
> options I would not want at all.
>=20
Ok.

> > > >
> > > > Option-3: mdev uuid alias
> > > > Instead of shorter mdev name or mdev index, have alpha-numeric
> > > > name
> > > alias.
> > > > Alias is an optional mdev sysfs attribute such as 'foo', 'bar'.
> > > > example mdev create command:
> > > > UUID=3D$(uuidgen)
> > > > echo $UUID alias=3Dfoo >
> > > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > > > example netdevs:
> > > > examle netdevs:
> > > > repnetdev =3D ens2f0_mfoo
> > > > mdev_netdev=3Denmfoo
> > > >
> > > > Pros:
> > > > 1. All same as option-1.
> > > > 2. Doesn't affect existing mdev naming scheme.
> > > > Cons:
> > > > 1. Index scheme of option-1 is better which can number large
> > > > number of
> > > mdevs with fewer characters, simplifying the management tool.
> > >
> > > I believe that Alex pointed out another "Cons" to all three options,
> > > which is that it forces user-space to resolve potential race
> > > conditions when creating an index or short name or alias.
> > >
> > This race condition exists for at least two subsystems that I know of, =
i.e.
> netdev and rdma.
> > If a device with a given name exists, subsystem returns error.
> > When user space gets error code EEXIST, and it can picks up different
> identifier(s).
>=20
> If you decouple device creation and setting the alias/index, you make the=
 issue
> visible and thus much more manageable.
>=20
I thought about it. It has two issues.
1. user should be able to set this only once. Repeatedly setting it require=
s changing/notifying it.
2. setting alias translating in creating devlink port doesn't sound correct=
.
Because if user attempts to reset to different value, it required unregistr=
ation, reregistration.
All of such race conditions handling it not worth it.
So setting the index, I liked Alex's term more 'instance number', at instan=
ce creation time is lot more simple.

> >
> > > Also, what happens if `index=3D10` is not provided on the command-lin=
e?
> > > Does that make the device unusable for your purpose?
> > Yes, it is unusable to an extent.
> > Currently we have DEVLINK_PORT_FLAVOUR_PCI_VF in
> > include/uapi/linux/devlink.h Similar to it, we need to have
> DEVLINK_PORT_FLAVOUR_MDEV for mdev eswitch ports.
> > This port flavour needs to generate phys_port_name(). This should be us=
er
> parameter driven.
> > Because representor netdevice name is generated based on this parameter=
.
>=20
> I'm also unsure how the extra parameter is supposed to work; writing it t=
o the
> create attribute does not sound right.
>=20
Why? When you create a device it takes multiple mandatory and optional para=
meters.
This is common for netdev (vxlan, vlan, macvlan, ipvlan, gre and more).

> mdevctl supports setting additional parameters on an already created devi=
ce
> (see the examples provided for vfio-ap), so going that route would actual=
ly
> work out of the box from the tooling side.
>=20
I explained that setting and re-setting attributes for instance create time=
 value is not worth.

> What you would need is some kind of synchronization/locking to make sure =
that
> you only link up to the other device after the extra attribute has been s=
et and
> that you don't allow to change it as long as it is associated with the ot=
her side. I
> do not know enough about the actual devices to suggest something here; if=
 you
> need userspace cooperation, maybe uevents would be an option.
