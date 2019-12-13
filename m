Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C3211EB7B
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfLMUFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:05:06 -0500
Received: from mail-eopbgr00072.outbound.protection.outlook.com ([40.107.0.72]:46052
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728736AbfLMUFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 15:05:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEgQjzZdmkxEXGGlfr4iXc1fUPE3Po9jO3Ns+lA3Hw/1XNDueDeHnE5LvrijKzFTd6+SxZpNM1Pp58xV2qw0qhn1fnYYLf5F/qXI3eMPcUmHBMco9pjXHS32Xc/CIBK/ZJvoxD7G6rzTubOnRQF+tZyGXTIlxfE6PJMA3M6yENzmEl1sZ6IfDnEUwCNfegywPLj55p372SHq5HWfMnGCLdOiu2iKsE+uDays2LKwb8YZfoDVG80VRXKzGKUgBSVNXY8JbcJKnCSpRzOi/jH+LUolx8HBuO/EgtP3hza8xJxksaFMuXM2XKLudtXIPzOQi3R8HOc5hfxKCgKtfXP4hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLejNOpoJDgaOzMDvIIlQwPjlaZVYyJqxT19CKZnIGE=;
 b=laGt8S0m3baovssY8k9p4AzHjwFOE44ZgNy645uG3P77qlutA4A70DLpSVcyfgY6J4rFnqvyy81/Gi+MJvaN6EtMLuK7/P6CN0jAsRECFFXQ+ALLFPYY9K9FjLoX4YGGIIPaNKvAgP67mFNFkZPI33j+VVsNj1jQVnHspioheF8FsA6JeZ8mbj7i3pb/sDwFnh1vC2Ld2/EfK569vBsu2NPCbKaWcdfTM4TWAD+liLpyiYalWh9ez93aqK3/JD8rfNGUqrcR7mp5hP0oY/8Xt9UaW+wruz71y0EJ3ru0JoF6yMNadJFkvgiK4GAqcRVovdV8MAubzPFk5WS+5CpCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLejNOpoJDgaOzMDvIIlQwPjlaZVYyJqxT19CKZnIGE=;
 b=V8hTwpNRwNFuVmzaTIN6YO0x6n42zrLD89NMc3zevwF9n/zaq9YiRAzZh0hp67eZrNpcR7u4vrDRcm+vsc4uorHvrW1EEtSM8x8G2UvxEzShpjby/F/hkSg4Y4tNBPN50PApUZKEEkqjaBASV7OBcO9sW+bl6bS8Gi5SckvIIhQ=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB4872.eurprd05.prod.outlook.com (20.177.35.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Fri, 13 Dec 2019 20:05:00 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 20:05:00 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkIAAC50AgABVJmCAAOJ/gIAAIpgggABa3ACAABH7IIAA/jMAgAAW14A=
Date:   Fri, 13 Dec 2019 20:05:00 +0000
Message-ID: <AM6PR05MB51422CE9C249DB03F486CB63C5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211154952.50109494@cakuba.netronome.com>
        <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212102517.602a8a5d@cakuba.netronome.com>
        <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212175418.3b07b7a9@cakuba.netronome.com>
        <AM6PR05MB514261CD6F95F104C0353A4BC5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191213100828.6767de6e@cakuba.netronome.com>
In-Reply-To: <20191213100828.6767de6e@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00ebf884-c424-482e-898a-08d78007bbff
x-ms-traffictypediagnostic: AM6PR05MB4872:|AM6PR05MB4872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB487249C0833633A2B4296CE3C5540@AM6PR05MB4872.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(13464003)(55016002)(9686003)(26005)(6506007)(53546011)(186003)(7696005)(4326008)(316002)(66476007)(66556008)(66446008)(107886003)(33656002)(52536014)(64756008)(66946007)(76116006)(71200400001)(6916009)(5660300002)(8676002)(478600001)(8936002)(54906003)(81156014)(86362001)(81166006)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4872;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TBjZFLChoC1kHVRS3/2loDxAC0e3GoTijoZ7dDDRxBzIsSsuhetzPXgSTZhN1Qp+MBwWmrdA3HEiTjWWnm9lX+pRABBV5sfwv7GduuAiDqZS8ORzXKRhieR1XOBCPL+WAmengCD2Q48a1mPe/zQ/TgrrsK/pRragWppYGLJHYp4Smz55uLm92jBo1KF7zqzKJUec9v1EGwUf6ipYQr0TT/tFPwdjXQmK81f3JapCF22a8HFeVx/mPTn9ZGiqAATztGLFbt4h6OuaaiCop3Im/r7aG0RnO0tu44+azIEj6EfvZvGB+KCdoROgKSIzcXCm7jGsiKBm47GeTF3TRMsB47FBroUvx8FNN+TSr7hsFR20zauljIDVXucuR050MUWgVc5DcjZy0BfNuOrMAtGzOx816pRY1BmZzeuf85rzdMMOblzvn6OIifnrF4feGyHf7m2C0jgxe5GkEAS3d4RqW76/AuKIesb55Eiuk+HckV0QtG+7PJ+UL6xjQ9zyXGPx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ebf884-c424-482e-898a-08d78007bbff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 20:05:00.1838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vLvomEFwfvhZ1uZKICI5wBOzsBrEkxpXqDx7WrBlbqF6GxbjplWGdsab59FO55nXzOA5D77yormsv12WSx7yeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Friday, December 13, 2019 10:08 AM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> <andy@greyhouse.net>
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Fri, 13 Dec 2019 03:21:02 +0000, Yuval Avnery wrote:
> > > I see, is this a more fine grained capability or all or nothing for S=
R-IOV
> control?
> > > I'd think that if the SmartNIC's eswitch just encapsulates all the
> > > frames into a
> > > L4 tunnel it shouldn't care about L2 addresses.
> >
> > People keep saying that, but there are customers who wants this
> > capability :)
>=20
> Right, but we should have a plan for both, right? Some form of a switch
> between L4/no checking/ip link changes are okay vs strict checking/L2/
> SmartNIC provisions MAC addrs?

I am not sure I understand
The L2 checks will be on NIC, not on the switch.
Packet decapsulated and forwarded to the NIC, Where the MAC matters..

>=20
> > > > > What happens if the SR-IOV host changes the MAC? Is it used by
> > > > > HW or is the MAC provisioned by the control CPU used for things
> > > > > like spoof check?
> > > >
> > > > Host shouldn't have privileges to do it.
> > > > If it does, then it's under the host ownership (like in non-smartni=
c
> mode).
> > >
> > > I see so the MAC is fixed from bare metal host's PoV? And it has to
> > > be set
> >
> > Yes
> >
> > > through some high level cloud API (for live migration etc)?
> > > Do existing software stacks like libvirt handle not being able to
> > > set the MAC happily?
> >
> > I am not sure what you mean.
> > What we are talking about here is the E-switch manager setting a MAC to
> another VF.
> > When the VF driver loads it will query this MAC from the NIC. This is
> > the way It works today with "ip link set _vf_ mac"
> >
> > Or in other words we are replacing "ip link set _vf_ mac" and not "ip l=
ink set
> address"
> > So that it can work from the SmartNic embedded system.
> > There is nothing really new here, ip link will not work from a
> > SmartNic, this is why need devlink subdev.
>=20
> Ack, but are we targeting the bare metal cloud scenario here or something
> more limited? In a bare metal cloud AFAIU the customers can use SR-IOV on
> the host, but the MACs need to be communicated/ /requested from the
> cloud management system.

Yes, so the cloud management system communicates with the Control CPU, not =
the host,
Not whatever customer decides to run on the hypervisor. The host PF is powe=
rless here (almost like VF).

>=20
> IOW the ip link and the devlink APIs are in different domains of control.
> Customer has access to ip link and provider has access to devlink.

For host VF - Customer has access to ip link exactly like in non-smartnic m=
ode.
For host PF - "ip link set vf" will return error. Everything running on the=
 host is not-trusted.

>=20
> So my question is does libvirt run by the customer handle the fact that i=
t can't
> poke at ip link gracefully, and if live migration is involved how is the =
customer
> supposed to ask the provider to move an address?

I don't understand the question because I don't understand why is it differ=
ent
from non-smartnic where the host hypervisor is in-charge.

