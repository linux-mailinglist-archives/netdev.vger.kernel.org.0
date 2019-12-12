Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6DA11D804
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbfLLUoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:44:38 -0500
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:57776
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730834AbfLLUoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 15:44:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm9ULOjILEB9u2KdCtpgovt6m9nG7dui0ksgCPHRl3kVS8Co1eQM8a5A/fmzTuxrFruAvtMMHS1usAdOcNVCQNKa38GFVX3f2P/WTrneN0tO0IgepIleIngikVElZ5vZkCccqHFQv/nZk4aG2y5AhkjdnCO0FI8LPi6PF8If74xkSwSTpviidOFqDxyg6Z4kn1WDWYztS8AnJ06MGt/cA1evLYs0AMz1glcKTz7Vx3BxrLKR9vitEv71ktmmfomjHR0u86T04glbSxDj5MXXZVDIsno2b9eNoIdRi+elsMpRvuRWGfHJvORH/Z7VHYgFOWphA8qBbLPGQKRBBpMlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9HWt9uVFJSUCUB6qFlY484epjm1V3kcUmgU812hKhI=;
 b=gHzWvZHuoOm/vAa+mBvVPfFGBnyYAcCM0k+KemOEXJ/1qmmGXHu2GzYwzseYg6e0a9JeAedhc1WjzqgF7YcMvkOc8BLLArUdLvxFKioWKjnBsZkpCw6F+gEzhKlOscfN28X+kTmRAOe2oBcTmaNnNc6Cv7xBjRZL9Dv35783jUBIiFrizDXiqGoUYaeei7S9xkflRBDpeEV8dwfHfoaWySbt3PfWY6pObdQy0Tq4jzrrhAHWMs1+mj4o5WvXOHLTu+u1burz+LXrtw/QXmfBwEhNBW6jCr3vw6VgvSrnzy07Rsz8QXfTtk/gWoiHsWwdwGW4pT7fHkOCuFHG/RvrTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9HWt9uVFJSUCUB6qFlY484epjm1V3kcUmgU812hKhI=;
 b=QJE5hItilxgDLZeAakXn9kMje+bHNNhwgIOe0LHzJhCARo5gzMnwey/mwHsh/ehS1X1PH9CFUAyZM9Pq0HJT8npZ8NsNYfWUc9jnAjrvj5nKQktQFOFAECGd18KrGkvPfSarKEJYm+QwLgconDEWZL1GAp7PjwURZyr9cFvEO8E=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB6615.eurprd05.prod.outlook.com (20.179.1.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Thu, 12 Dec 2019 20:44:32 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 20:44:31 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkIAAC50AgABVJmCAAOJ/gIAAIpgg
Date:   Thu, 12 Dec 2019 20:44:31 +0000
Message-ID: <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
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
In-Reply-To: <20191212102517.602a8a5d@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e7d083f-2bb7-46a3-f393-08d77f441732
x-ms-traffictypediagnostic: AM6PR05MB6615:|AM6PR05MB6615:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6615B29E6DBF8F1A1E371F81C5550@AM6PR05MB6615.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(13464003)(8936002)(478600001)(5660300002)(6506007)(53546011)(2906002)(7696005)(81156014)(54906003)(66556008)(86362001)(316002)(6916009)(8676002)(33656002)(4326008)(26005)(186003)(52536014)(71200400001)(55016002)(81166006)(76116006)(66476007)(64756008)(66946007)(9686003)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6615;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hI4edV+cRMBDxtYxmGQ7lHfL3cp7KDIXbv0soHg9A5yNilZm5RQ+MBmPNubb4fmjwDi0lM/sDKPBa/wDj4NgtqF8Ootst60rhPqil8+V3iZuIKCG38nASpsqlDriPoswPzMJjGYFc0F4pf1NSr2tNvPtE8QZec2s+68yXB0CqC+96dVZZiexwabvuNPSt6hfTC7kgnLRxQ9dqvH+eYa1rBjeX8VnC9xGyLIFpx7Sl8l6h/7QKXAcYieVKDQ/cESgt/5Vi42dQYRn2u9HccwuoiaRYU0RB6rs67uHumT9n0+nGgG1sse1nSv2JTpNJkiGKquEaF+riG4ie5yq+Wb/ZigzAwSc6gRQNFVmqlkUatHc7ZLo1QxgRz5PYp/u7K3ZtWdUz0mt4QiGIWtroLwEHIFMGy067TOMju0hV15O0jN0vRmd+hoI2wGueeVNNAXp7/rlzHZNfz6pKPXOhxodi3ZnA5cNQHXupbSMPHqURQZ+1uzay2JugNq8Yh+7ZSdv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7d083f-2bb7-46a3-f393-08d77f441732
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 20:44:31.8554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DDtLOOaP0GLG91d3fbixuToLcVGvNmQVoyKhRJbpEh6enJarbNM2/+gD9fQIit34hcI4Wgyw1X13ziDu/2ELw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, December 12, 2019 10:25 AM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> <andy@greyhouse.net>
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Thu, 12 Dec 2019 05:11:12 +0000, Yuval Avnery wrote:
> > > > > Okay, please post v2 together with the tests. We don't accept
> > > > > netdevsim features without tests any more.
> > > >
> > > > I think the only test I can currently write is the enable SR-IOV
> > > > max_vfs enforcement. Because subdev is not in yet.
> > > > Will that be good enough?
> > >
> > > It'd be good to test some netdev API rather than just the
> > > enforcement itself which is entirely in netdevsim, I think.
> > >
> > > So max_vfs enforcement plus checking that ip link lists the correct
> > > number of entries (and perhaps the entries are in reset state after
> > > enable) would do IMO.
> >
> > Ok, but this is possible regardless of my patch (to enable vfs).
>=20
> I was being lenient :) Your patch is only really needed when the devlink =
API
> lands, since devlink will display all max VFs not enabled.
>=20
> > > My knee jerk reaction is that we should populate the values to those
> > > set via devlink upon SR-IOV enable, but then if user overwrites
> > > those values that's their problem.
> > >
> > > Sort of mirror how VF MAC addrs work, just a level deeper. The VF
> > > defaults to the MAC addr provided by the PF after reset, but it can
> > > change it to something else (things may stop working because spoof
> > > check etc. will drop all its frames, but nothing stops the VF in
> > > legacy HW from writing its MAC addr register).
> > >
> > > IOW the devlink addr is the default/provisioned addr, not
> > > necessarily the addr the PF has set _now_.
> > >
> > > Other options I guess are (a) reject the changes of the address from
> > > the PF once devlink has set a value; (b) provide some
> > > device->control CPU notifier which can ack/reject a request from the =
PF
> to change devlink's value..?
> > >
> > > You guys posted the devlink patches a while ago, what was your
> > > implementation doing?
> >
> > devlink simply calls the driver with set or get.
> > It is up to the vendor driver/HW if to make this address persistent or =
not.
> > The address is not saved in the devlink layer.
>=20
> It'd be preferable for the behaviour of the kernel API to not be vendor
> specific. That defeats the purpose of having an operating system as a HW
> abstraction layer. SR-IOV devices of today are so FW heavy we can make
> them behave whatever way we choose makes most sense.
>=20
> > The MAC address in mlx5 is stored in the HW and persistent (until PF
> > reset) , whether it is set by devlink or ip link.
>=20
> Okay, let's see if I understand. The devlink and ip link interfaces basic=
ally do
> the same thing but one reaches from control CPU and the other one from
> the SR-IOV host? And on SR-IOV host reset the addresses go back to 00:00.=
.
> i.e. any?

No,
This will work only in non-SmartNic mode, when e-switch manager is on the h=
ost,
MAC will be accessible through devlink and legacy tools..
For smartnic, only devlink from the embedded OS will work. Ip link from the=
 host will not work.

>=20
> What happens if the SR-IOV host changes the MAC? Is it used by HW or is t=
he
> MAC provisioned by the control CPU used for things like spoof check?

Host shouldn't have privileges to do it.
If it does, then it's under the host ownership (like in non-smartnic mode).

>=20
> Does the control CPU get a notification for SR-IOV host reset? In that ca=
se
> the control CPU driver could restore the MAC addr.

Yes, but this is irrelevant here, the MAC is already stored in HW/FW.
The MAC will reset only when the E-switch manager (on the control CPU) rese=
t.

>=20
> > So from what I understand, we have the freedom to choose how
> netdevsim
> > behave in this case, which means non-persistent is ok.
>=20
> To be clear - by persistent I meant that it survives the SR-IOV host's re=
sets,
> not necessarily written to NVRAM of any sort.

Yes, this is my view as well.
For non-smartnic it will survive VF disable/enable.
MAC is not stored on NVRAM, it will disappear once the driver on the contro=
l CPU resets.

>=20
> I'd like to see netdevsim to also serve as sort of a reference model for =
device
> behaviour. Vendors who are not first to implement a feature always
> complain that there is no documentation on how things should work.

Yes, this is a good idea.
But it seems we are always held back by legacy tools with no well-defined b=
ehavior.
