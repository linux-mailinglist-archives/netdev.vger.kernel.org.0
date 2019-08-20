Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496A495A81
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfHTI6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:58:13 -0400
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:50830
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728545AbfHTI6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 04:58:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0gCe9uEejnRZdLWstAT3lzufpbbw9oSK3AincxJg3wkS8mMroeNuVuLN28mR8EIMFY1V1Td16h7gL7lK5Tk7k3VVLWPf159ch376iyCazNfYe/+OnDMX0H0kQrwDf6TYh+xngJH9+qDymg5gQKfvpUoedL5C4ZuSKqnh7yCM1E/jQ1JiF0Fg/zDGRrp3DR+3om0cTkkj7Awkmo1EcMuDxGj8usixtY6WvGow0zw6p0jWQNIpUXBO91LwnwwYRiKlQeMJzzbnDR6GfZISccPcLcQfW5T/ce8NPytZKdwBXAOaZrRrURf3h775BoQMPe+Gy6qEznZAQoipQRYrE1FLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85bQhWw+oG2z5LNphI8+rTtQJ+c/eg8pcGpJoWaw1T0=;
 b=MgoF5PO/VhC+j53e4F90cRPsRjNFWl4aFfbod06TE0ioOP2TuqYcuqn1OHwP248FKCzL49K7QRZNWQ3BSvPFjOsKFCmTt0QFNTnrD+/1GUb+SF5zzkrAmjITNYCgqjy72ajf+r0NhlRFXEAE3osD74hvXBou1EEcoMzj6JxxiHKzvToQj9NHub2QZCy0o+YCZXfzae5zxIOKdlfs3+YHkKLU5CYuNHO1f6QO0IfPer8UjnYPjDvYc4t179wvlO9zLnK68nM09nk+C8Y4R5WhhDiBqnegPgJNpWa97b4nBGfKoqCfr40Ns0uBvmYdDk26DaVHmqXIZ40riiOXtROsLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85bQhWw+oG2z5LNphI8+rTtQJ+c/eg8pcGpJoWaw1T0=;
 b=llEv6mRYzRKYZPrAtomRoWvdpk/+87SR6CPMky4xN5r0JaXZz54IsEo01ZETEGYVWccQ6FcN2GcY2JWr7bOnI+21g6E830RS/H2SVSH5vp+JLkw5vLl7Hftyk+BmX/1B//H2GmFLUfvp5zwrN4n60XKvqXiUVZTbn0xuERaezc8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5908.eurprd05.prod.outlook.com (20.178.117.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 08:58:03 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 08:58:03 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulA=
Date:   Tue, 20 Aug 2019 08:58:02 +0000
Message-ID: <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
     <20190808170247.1fc2c4c4@x1.home>
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
In-Reply-To: <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccc1dcb1-fe28-423e-a29b-08d7254c8296
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5908;
x-ms-traffictypediagnostic: AM0PR05MB5908:
x-ms-exchange-purlcount: 7
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB59088A363086B4CEF7A30D16D1AB0@AM0PR05MB5908.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(13464003)(199004)(189003)(51444003)(229853002)(6436002)(478600001)(5660300002)(66446008)(64756008)(52536014)(110136005)(66476007)(54906003)(33656002)(66556008)(25786009)(2906002)(9686003)(6306002)(53946003)(14454004)(71200400001)(316002)(6116002)(71190400001)(3846002)(30864003)(256004)(86362001)(476003)(446003)(66066001)(966005)(55016002)(14444005)(11346002)(5024004)(76116006)(486006)(74316002)(305945005)(53546011)(6506007)(7736002)(186003)(102836004)(55236004)(26005)(6246003)(99286004)(7696005)(4326008)(8936002)(81166006)(81156014)(8676002)(9456002)(53376002)(76176011)(53936002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5908;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F+BzJJdVh6fP7VIljuQbSVJUwyNNpQbKblwTn3W17nQcZwbYvfGlmN3q3iKrwKHP7yceFV6n/BgDQMEZVon9zWPt93mfkEIKu7+IE+nnUcts/UoaBsiWlZ/BWcpozrL2icrs3PEVIz82VnPdKLawafnIX4Mgwb7evUSJeNCiSnoI3AjYEHbt2xwHeBLBfgVTyvglQSV8VGD7xt/CD6HtL2CqJxW4PV4FUXRUKpE+IILqeyEBoM/GORCveeJWiOnM7X9ViKJxoVU+hdnap0SOmwcbThQOFzajscos3ZBbNryv92SS2a+t6I0KE6jhjqDttvMsf0z9p9IFZR4lV7g7rXuIcxCKtOIoMTMgZeunoT51+BpIUFlNHKO2KsiJm/xHv0MBOpCAmhk2gCTIYibHHppt9hvSrNWMX1iCcFWWzYY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc1dcb1-fe28-423e-a29b-08d7254c8296
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 08:58:03.3477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4+VUwXzbZ9DMjOCQm90NXdpLvIpmI/svSMgMSCB/YNLl8mL1gIDwKa6gTPv+BQDaq8WndKO/IBGgsVJvftODnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5908
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Dave.

Hi Jiri, Dave, Alex, Kirti, Cornelia,

Please provide your feedback on it, how shall we proceed?

Short summary of requirements.
For a given mdev (mediated device [1]), there is one representor netdevice =
and devlink port in switchdev mode (similar to SR-IOV VF),
And there is one netdevice for the actual mdev when mdev is probed.

(a) representor netdev and devlink port should be able derive phys_port_nam=
e().
So that representor netdev name can be built deterministically across reboo=
ts.

(b) for mdev's netdevice, mdev's device should have an attribute.
This attribute can be used by udev rules/systemd or something else to renam=
e netdev name deterministically.

(c) IFNAMSIZ of 16 bytes is too small to fit whole UUID.
A simple grep IFNAMSIZ in stack hints hundreds of users of IFNAMSIZ in driv=
ers, uapi, netlink, boot config area and more.
Changing IFNAMSIZ for a mdev bus doesn't really look reasonable option to m=
e.

Hence, I would like to discuss below options.

Option-1: mdev index
Introduce an optional mdev index/handle as u32 during mdev create time.
User passes mdev index/handle as input.

phys_port_name=3DmIndex=3Dm%u
mdev_index will be available in sysfs as mdev attribute for udev to name th=
e mdev's netdev.

example mdev create command:
UUID=3D$(uuidgen)
echo $UUID index=3D10 > /sys/class/net/ens2f0/mdev_supported_types/mlx5_cor=
e_mdev/create
example netdevs:
repnetdev=3Dens2f0_m10	/*ens2f0 is parent PF's netdevice */
mdev_netdev=3Denm10

Pros:
1. mdevctl and any other existing tools are unaffected.
2. netdev stack, ovs and other switching platforms are unaffected.
3. achieves unique phys_port_name for representor netdev
4. achieves unique mdev eth netdev name for the mdev using udev/systemd ext=
ension.
5. Aligns well with mdev and netdev subsystem and similar to existing sriov=
 bdf's.

Option-2: shorter mdev name
Extend mdev to have shorter mdev device name in addition to UUID.
such as 'foo', 'bar'.
Mdev will continue to have UUID.
phys_port_name=3Dmdev_name

Pros:
1. All same as option-1, except mdevctl needs upgrade for newer usage.
It is common practice to upgrade iproute2 package along with the kernel.
Similar practice to be done with mdevctl.
2. Newer users of mdevctl who wants to work with non_UUID names, will use n=
ewer mdevctl/tools.
Cons:
1. Dual naming scheme of mdev might affect some of the existing tools.
It's unclear how/if it actually affects.
mdevctl [2] is very recently developed and can be enhanced for dual naming =
scheme.

Option-3: mdev uuid alias
Instead of shorter mdev name or mdev index, have alpha-numeric name alias.
Alias is an optional mdev sysfs attribute such as 'foo', 'bar'.
example mdev create command:
UUID=3D$(uuidgen)
echo $UUID alias=3Dfoo > /sys/class/net/ens2f0/mdev_supported_types/mlx5_co=
re_mdev/create
example netdevs:
examle netdevs:
repnetdev =3D ens2f0_mfoo
mdev_netdev=3Denmfoo

Pros:
1. All same as option-1.
2. Doesn't affect existing mdev naming scheme.
Cons:
1. Index scheme of option-1 is better which can number large number of mdev=
s with fewer characters, simplifying the management tool.

Option-4: extend IFNAMESZ to be 64 bytes Extended IFNAMESZ from 16 to 64 by=
tes phys_port_name=3Dmdev_UUID_string mdev_netdev_name=3DenmUUID

Pros:
1. Doesn't require mdev extension
Cons:
1. netdev stack, driver, uapi, user space, boot config wide changes
2. Possible user space extensions who assumed name size being 16 characters
3. Single device type demands namesize change for all netdev types

[1] https://www.kernel.org/doc/Documentation/vfio-mediated-device.txt
[2] https://github.com/mdevctl/mdevctl

Regards,
Parav Pandit

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Parav Pandit
> Sent: Wednesday, August 14, 2019 9:51 PM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia@nvidia.com; Jiri Pirko <jiri@mellanox.com>;
> netdev@vger.kernel.org
> Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
>=20
>=20
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, August 14, 2019 8:28 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>; Kirti Wankhede
> > <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; cjia@nvidia.com; Jiri Pirko
> > <jiri@mellanox.com>; netdev@vger.kernel.org
> > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> >
> > On Wed, 14 Aug 2019 13:45:49 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >
> > > > -----Original Message-----
> > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > Sent: Wednesday, August 14, 2019 6:39 PM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> > > > <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > > > kernel@vger.kernel.org; cjia@nvidia.com; Jiri Pirko
> > > > <jiri@mellanox.com>; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > >
> > > > On Wed, 14 Aug 2019 12:27:01 +0000 Parav Pandit
> > > > <parav@mellanox.com> wrote:
> > > >
> > > > > + Jiri, + netdev
> > > > > To get perspective on the ndo->phys_port_name for the
> > > > > representor netdev
> > > > of mdev.
> > > > >
> > > > > Hi Cornelia,
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > > Sent: Wednesday, August 14, 2019 1:32 PM
> > > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > > Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti
> > > > > > Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > > > > > kernel@vger.kernel.org; cjia@nvidia.com
> > > > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > > >
> > > > > > On Wed, 14 Aug 2019 05:54:36 +0000 Parav Pandit
> > > > > > <parav@mellanox.com> wrote:
> > > > > >
> > > > > > > > > I get that part. I prefer to remove the UUID itself from
> > > > > > > > > the structure and therefore removing this API makes lot
> > > > > > > > > more
> > sense?
> > > > > > > >
> > > > > > > > Mdev and support tools around mdev are based on UUIDs
> > > > > > > > because it's
> > > > > > defined
> > > > > > > > in the documentation.
> > > > > > > When we introduce newer device naming scheme, it will update
> > > > > > > the
> > > > > > documentation also.
> > > > > > > May be that is the time to move to .rst format too.
> > > > > >
> > > > > > You are aware that there are existing tools that expect a uuid
> > > > > > naming scheme, right?
> > > > > >
> > > > > Yes, Alex mentioned too.
> > > > > The good tool that I am aware of is [1], which is 4 months old.
> > > > > Not sure if it is
> > > > part of any distros yet.
> > > > >
> > > > > README also says, that it is in 'early in development. So we
> > > > > have scope to
> > > > improve it for non UUID names, but lets discuss that more below.
> > > >
> > > > The up-to-date reference for mdevctl is
> > > > https://github.com/mdevctl/mdevctl. There is currently an effort
> > > > to get this packaged in Fedora.
> > > >
> > > Awesome.
> > >
> > > > >
> > > > > > >
> > > > > > > > I don't think it's as simple as saying "voila, UUID
> > > > > > > > dependencies are removed, users are free to use arbitrary
> > > > > > > > strings".  We'd need to create some kind of naming policy,
> > > > > > > > what characters are allows so that we can potentially
> > > > > > > > expand the creation parameters as has been proposed a
> > > > > > > > couple times, how do we deal with collisions and races,
> > > > > > > > and why should we make such a change when a UUID is a
> > > > > > > > perfectly reasonable devices name.  Thanks,
> > > > > > > >
> > > > > > > Sure, we should define a policy on device naming to be more
> relaxed.
> > > > > > > We have enough examples in-kernel.
> > > > > > > Few that I am aware of are netdev (vxlan, macvlan, ipvlan,
> > > > > > > lot more), rdma
> > > > > > etc which has arbitrary device names and ID based device names.
> > > > > > >
> > > > > > > Collisions and race is already taken care today in the mdev c=
ore.
> > > > > > > Same
> > > > > > unique device names continue.
> > > > > >
> > > > > > I'm still completely missing a rationale _why_ uuids are
> > > > > > supposedly bad/restricting/etc.
> > > > > There is nothing bad about uuid based naming.
> > > > > Its just too long name to derive phys_port_name of a netdev.
> > > > > In details below.
> > > > >
> > > > > For a given mdev of networking type, we would like to have
> > > > > (a) representor netdevice [2]
> > > > > (b) associated devlink port [3]
> > > > >
> > > > > Currently these representor netdevice exist only for the PCIe SR-=
IOV
> VFs.
> > > > > It is further getting extended for mdev without SR-IOV.
> > > > >
> > > > > Each of the devlink port is attached to representor netdevice [4]=
.
> > > > >
> > > > > This netdevice phys_port_name should be a unique derived from
> > > > > some
> > > > property of mdev.
> > > > > Udev/systemd uses phys_port_name to derive unique representor
> > > > > netdev
> > > > name.
> > > > > This netdev name is further use by orchestration and switching
> > > > > software in
> > > > user space.
> > > > > One such distro supported switching software is ovs [4], which
> > > > > relies on the
> > > > persistent device name of the representor netdevice.
> > > >
> > > > Ok, let me rephrase this to check that I understand this correctly.
> > > > I'm not sure about some of the terms you use here (even after
> > > > looking at the linked doc/code), but that's probably still ok.
> > > >
> > > > We want to derive an unique (and probably persistent?) netdev name
> > > > so that userspace can refer to a representor netdevice. Makes sense=
.
> > > > For generating that name, udev uses the phys_port_name (which
> > > > represents the devlink port, IIUC). Also makes sense.
> > > >
> > > You understood it correctly.
> > >
> > > > >
> > > > > phys_port_name has limitation to be only 15 characters long.
> > > > > UUID doesn't fit in phys_port_name.
> > > >
> > > > Understood. But why do we need to derive the phys_port_name from
> > > > the mdev device name? This netdevice use case seems to be just one
> > > > use case for using mdev devices? If this is a specialized mdev
> > > > type for this setup, why not just expose a shorter identifier via a=
n extra
> attribute?
> > > >
> > > Representor netdev, represents mdev's switch port (like PCI SRIOV
> > > VF's switch
> > port).
> > > So user must be able to relate this two objects in similar manner as
> > > SRIOV
> > VFs.
> > > Phys_port_name is derived from the PCI PF and VF numbering scheme.
> > > Similarly mdev's such port should be derived from mdev's
> id/name/attribute.
> > >
> > > > > Longer UUID names are creating snow ball effect, not just in
> > > > > networking stack
> > > > but many user space tools too.
> > > >
> > > > This snowball effect mainly comes from the device name ->
> > > > phys_port_name setup, IIUC.
> > > >
> > > Right.
> > >
> > > > > (as opposed to recently introduced mdevctl, are they more mdev
> > > > > tools which has dependency on UUID name?)
> > > >
> > > > I am aware that people have written scripts etc. to manage their md=
evs.
> > > > Given that the mdev infrastructure has been around for quite some
> > > > time, I'd say the chance of some of those scripts relying on uuid
> > > > names is
> > non-zero.
> > > >
> > > Ok. but those scripts have never managed networking devices.
> > > So those scripts won't break because they will always create mdev
> > > devices
> > using UUID.
> > > When they use these new networking devices, they need more things
> > > than
> > their scripts.
> > > So user space upgrade for such mixed mode case is reasonable.
> >
> > Tools like mdevctl are agnostic of the type of mdev device they're
> > managing, it shouldn't matter than they've never managed a networking
> > mdev previously, it follows the standards of mdev management.
> >
> > > > >
> > > > > Instead of mdev subsystem creating such effect, one option we
> > > > > are
> > > > considering is to have shorter mdev names.
> > > > > (Similar to netdev, rdma, nvme devices).
> > > > > Such as mdev1, mdev2000 etc.
> >
> > Note that these are kernel generated names, as are the other examples.
> No. I probably gave the wrong examples.
> Mdev user provided names can be 'foo', 'bar', 'foo1'.
>=20
> > In the case of mdev, the user is providing the UUID, which becomes the
> > device name.  When a user writes to the create attribute, there needs
> > to be determinism that the user can identify the device they created
> > vs another that may have been created concurrently.  I don't see that
> > we can put users in the path of managing device instance numbers.
> No. Its just user provided names.
>=20
> >
> > > > > Second option I was considering is to have an optional alias for
> > > > > UUID based
> > > > mdev.
> > > > > This name alias is given at time of mdev creation.
> > > > > Devlink port's phys_port_name is derived out of this shorter
> > > > > mdev name
> > > > alias.
> > > > > This way, mdev remains to be UUID based with optional extension.
> > > > > However, I prefer first option to relax mdev naming scheme.
> > > >
> > > > Actually, I think that second option makes much more sense, as you
> > > > avoid potentially breaking existing tooling.
> > > Let's first understand of what exactly will break with existing tool
> > > if they see non_uuid based device.
> >
> > Do we really want a mixed namespace of device names, some UUID, some...
> > something else?  That seems like a mess.
> >
> So you prefer alias as an attribute? If so, it should be an optional addi=
tional
> parameter during create time, because it is desired to not invent new cal=
lbacks
> for such attributes setting and (and rewrite them).
>=20
> > > Existing tooling continue to work with UUID devices.
> > > Do you have example of what can break if they see non_uuid based
> > > device name? I think you are clear, but to be sure, UUID based
> > > creation will continue to be there. Optionally mdev will be created
> > > with alpha-numeric string, if we don't it as additional attribute.
> >
> > I'm not onboard with a UUID being just one of the possible naming
> > strings via which we can create mdev devices.  I think that becomes
> > untenable for userspace.  I don't think a sufficient argument has been
> > made against the alias approach, which seems to keep the UUID as a
> > canonical name, providing a consistent namespace, augmented with user o=
r
> kernel provided short alias.
> > Thanks,
> >
> If I understand you correctly, you prefer alias name approach to keep UUI=
D
> naming scheme intact in mdev?
>=20
> > Alex
> >
> > > > >
> > > > > > We want to uniquely identify a device, across different types
> > > > > > of vendor drivers. An uuid is a unique identifier and even a
> > > > > > well-defined one. Tools (e.g. mdevctl) are relying on it for
> > > > > > mdev devices
> > > > today.
> > > > > >
> > > > > > What is the problem you're trying to solve?
> > > > > Unique device naming is still achieved without UUID scheme by
> > > > > various
> > > > subsystems in kernel using alpha-numeric string.
> > > > > Having such string based continue to provide unique names.
> > > > >
> > > > > I hope I described the problem and two solutions above.
> > > > >
> > > > > [1] https://github.com/awilliam/mdevctl
> > > > > [2]
> > > > > https://elixir.bootlin.com/linux/v5.3-rc4/source/drivers/net/eth
> > > > > er
> > > > > net/
> > > > > mellanox/mlx5/core/en_rep.c [3]
> > > > > http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > > > [4]
> > > > > https://elixir.bootlin.com/linux/v5.3-rc4/source/net/core/devlink=
.
> > > > > c#L6
> > > > > 921
> > > > > [5] https://www.openvswitch.org/
> > > > >
> > >

