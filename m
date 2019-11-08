Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96063F4ED7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfKHPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:01:36 -0500
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:41830
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbfKHPBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:01:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASPP/9y6BXBHhebjAV+exsywJfRjfoO6Ky2dlvYS+MetTpq2yHros49YpCqKKCGeyqV2UKFukZ43D3BNrLUQGTcSJhxoCPFHG7NUDRfTvya3BRliQAJ1FZAkKVSN+nb5DkOBXC4lUxJgyw6po7sTdGhNvh/6QcfNRq/MoJyHPW++mVDX6h2PL7B/MU6fNJ9Q+pceoACWVPl0LN7eY8YlP4xe5I7pYYg/X9/tS/EV/xieA+DfDVsaSo1C2aRDwVDfpdz5i6Mx3q1JW809scUkpS1koBSHU9G04ZLvb3HHQOEqIf2O5kGMgUCskJQDz1QdLEJ6CV15ubbXsfU6xrpbJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3YaUxjo2GMN+WkQ6wy2G6JbgSERYgHP+iuVXFOPmps=;
 b=gL0RvrqdqsfjYYNUWUTzCGHYRov9nURN6JH1sJdtQfUGRja4UcOZHhEi1IS5/DkmIsipjkqrUBqI4IRBCfSs4QqHEswa3uZNLGgmjh/JN32l4EJgf/8zdp3PLhlnfZ0g5eoLu9gaNW+pzmWBe4vopMBILWiuncy56Jq0UjbldgWGH0HDi2xg9iXKfZ85nvh0vltEnT8bOCk1f+b5XMoM1nnWNSB4LGSbIKxd+iC8h71S86a9uqJzY6BGTdTC3qHL/BC8iDLzL/vQXH2Efj9cZ4bIwWVsagKpRtHFn7/x/yKMvb/McKa9lxFE/oPpmU3qYTcmqAawK6vmSKxzFJDe7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3YaUxjo2GMN+WkQ6wy2G6JbgSERYgHP+iuVXFOPmps=;
 b=VuW0mjf7eu8JKGXgJhyoUBnBB2yE9rnSFB0Bt1T4Qa7ESZ6GAN9RfRFZKTPD9SxlkjRvnc4+ZIsQFwpk3NbXsWuRXcqkOFHclIFxx5wMQhqDYcH9Mkg2rL//dKk2zThyW0RDoOMWtnBHwEHKRblmlkeRsNpY+Zs6pUY9Ty72gZg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6354.eurprd05.prod.outlook.com (20.179.35.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 15:01:32 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:01:32 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scad/75GAgAAxHKCAAK1lgIAAkO0A
Date:   Fri, 8 Nov 2019 15:01:31 +0000
Message-ID: <AM0PR05MB4866EB53FBE379BD87B1CBD7D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107170341.GM6763@unreal>
 <AM0PR05MB4866BE0BA3BEA9523A034EDDD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108062003.GN6763@unreal>
In-Reply-To: <20191108062003.GN6763@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec9a311b-1155-48d7-34ac-08d7645c8a8a
x-ms-traffictypediagnostic: AM0PR05MB6354:|AM0PR05MB6354:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6354A06A728BFEB8ADF458FDD17B0@AM0PR05MB6354.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(13464003)(199004)(46003)(486006)(25786009)(53546011)(14454004)(316002)(99286004)(81156014)(6916009)(478600001)(81166006)(2906002)(8676002)(6506007)(71200400001)(52536014)(6246003)(102836004)(229853002)(446003)(6436002)(71190400001)(9686003)(8936002)(86362001)(186003)(6116002)(33656002)(14444005)(305945005)(5660300002)(76116006)(66476007)(66556008)(64756008)(66446008)(55016002)(66946007)(76176011)(7696005)(54906003)(256004)(476003)(11346002)(4326008)(74316002)(7736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6354;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CZVvECSCSlH/caafG+aUmK1ovn9Taz6RqIE/aw1Br3tUOMfr0ZVZPRdTPHAEGF+7PmFUzA+3p5fkIsVWYxd/Z8ZjZrj82oBxq8hl4MvFooALbQy6CH3di+YMPpmwOV1Jr5+IpxyVpezlA728+PC7rnnLa/jLHupYLGapAPxmi6u63jRhVaKJ9tfJI1pUfczWBBRF3VDYiu38NA7hpIRYdC6162V6TIJA4llSPTe+OigGX8kyrfvAkT89Og7QEzNRqsm8PtJvQbpjv6mh9hSg8z0viORgBG8qYQGYNXU1Fr7WyiT/xzmF5qBF/R6+sBacuZBUJu1lgZXLnNDe1bzjLM/b5h0q/l+oSUWY8UHUkjV5W85t8g0sv/U1ObPlhz89HOW8fzgA8GCsK5CbnwnWBLCUK30FCxGlxb7KtemMr/0xP7ZMbCNBB7/+OQF9riig
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9a311b-1155-48d7-34ac-08d7645c8a8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:01:31.9157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gxs9RlVVodmFjm0HCe14SVI7F+qS3jdip6nRMrVM2qNRHGHxivUuKjA/cV6gQPAmfe1j4vGhzUE49idD1Ip8Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Friday, November 8, 2019 12:20 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; cohuck@redhat.com;
> Jiri Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
>=20
> On Thu, Nov 07, 2019 at 08:10:45PM +0000, Parav Pandit wrote:
> > Hi Leon,
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Thursday, November 7, 2019 11:04 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > > <saeedm@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; Jiri
> > > Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> > > Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function
> > > support
> > >
> > > On Thu, Nov 07, 2019 at 10:04:48AM -0600, Parav Pandit wrote:
> > > > Hi Dave, Jiri, Alex,
> > > >
> > >
> > > <...>
> > >
> > > > - View netdevice and (optionally) RDMA device using iproute2 tools
> > > >     $ ip link show
> > > >     $ rdma dev show
> > >
> > > You perfectly explained how ETH devices will be named, but what
> > > about RDMA?
> > > How will be named? I feel that rdma-core needs to be extended to
> > > support such mediated devices.
> > >
> > rdma devices are named by default using mlx_X.
> > After your persistent naming patches, I thought we have GUID based
> naming scheme which doesn't care about its underlying bus.
>=20
> No, it is not how it is done. RDMA persistent naming is modeled exactly a=
s
> ETH naming, it means that we do care about bus and we don't use GUID
> unless user explicitly asked, exactly as MAC based names in ETH world.
>=20
> > So mdevs will be able to use current GUID based naming scheme we
> already have.
>=20
> Unfortunately, no.
>=20
> >
> > Additionally, if user prefers, mdev alias, we can extend systemd/udev t=
o
> use mdev alias based names (like PCI bdf).
>=20
> It is not "Additionally", but "must".
>
Ok. So will do post this series with similar naming scheme.
Will update the cover letter to describe rdma naming too.
=20
> > Such as,
> > rocem<alias1>
> > ibm<alias2>
> > Format is:
> > <link_layer><m><alias>
> > m -> stands for mdev device (similar to 'p' for PCI)
