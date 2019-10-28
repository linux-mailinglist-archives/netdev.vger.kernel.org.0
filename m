Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BB1E7981
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfJ1UCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:02:17 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:41793
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfJ1UCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 16:02:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djzUZYzBR7HxfDaoyUOCRXYj6jPyfN+tALPPau2a76hMwa2F+dOSznEjfisO+alsd+gCsvFtxzWPsl+LfqCvCHuGvoHjSF03ZCwp7cOat3Ip14pczb+jZS1e8VsNJmW/09y3sOBHPPRfZxrnoR/tM24uWhUHjXq14Dg/YZ/FC3kMFnT3aqvyvFjuFGQuRLi8M9gTPR+3Qr/XiziypeMaQBpkMv83R/uoZt+wenjSnPY5zq9Tzk5XL76F1qMaeIfOGgE1CI3xb+66B2DHqKaHrIFzT3WjeI+ne6NMGrkoG9ei6f11gJE6t/6oUUjXbysy38OzQK4N6sX9R0EsOivZBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5fQkN4Ox/J3j7fpO4yZUSgweErGCnbaOCZ0mFk1vkw=;
 b=FdLvNg7gVn7j4wz7eqKz8NMogdU8rw7yJWDot5rAfCOnnsC6FfhEqpxg/+wseD4W2wLU2/Waqik15f8zkIC1DBis1Bi9pKjZfEhVxBknakGpmMEOFMsPI56z0bxNcWrHRC83W3go0p6g6UiuPeDpngczmXY0XzrykfFxS8YB17Elh1nFAKnOS/nfoFK3lhDJ5/N9Z4rSiZj9ez5ZKWx2xBdfHo1+fOkh3YYclUX6M1yUoqTk0Taxi91OsxvtRUnPhwmOAfRifoOCfiU0rtIOW5trryhjTOmr/xmKxAjlGohv5MqEzsPYKjw9R8MlTEVUaEREWq+B+vjVrOPfgOmYJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5fQkN4Ox/J3j7fpO4yZUSgweErGCnbaOCZ0mFk1vkw=;
 b=lJgI8zJleHtIzmRnW1RrShJranOn5kdaCPFlp43MefLqXgxxS6n/w9+r0E5Ty9C4czFCM2/ppAzbcgCM6QY5u+SV9FL10uueq4cTVhNT0Qm5LjXig7AMgLvMJ7gRC7kj9d7JJUDcI6IxCH6HGJ60j7vOnW8JRV2UnAs8bwTisyw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6737.eurprd05.prod.outlook.com (10.186.174.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 20:02:06 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2387.019; Mon, 28 Oct 2019
 20:02:06 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Yuval Avnery <yuvalav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 0/9] devlink vdev
Thread-Topic: [PATCH net-next 0/9] devlink vdev
Thread-Index: AQHViQAzNybbKwGptUuLvXy+Vpqae6dollkAgAAG1ACAAC80gIAAIN8AgAAsrICAAl1MAIAFBfLw
Date:   Mon, 28 Oct 2019 20:02:06 +0000
Message-ID: <AM0PR05MB486640F7A27F6D894450F1C2D1660@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
 <20191023120046.0f53b744@cakuba.netronome.com>
 <20191023192512.GA2414@nanopsycho>
 <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
 <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
 <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
 <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
In-Reply-To: <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eff4ba2b-aebf-4c22-0edd-08d75be1b558
x-ms-traffictypediagnostic: AM0PR05MB6737:|AM0PR05MB6737:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6737F6A4037EC5E8B83ABE11D1660@AM0PR05MB6737.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(199004)(189003)(13464003)(74316002)(486006)(229853002)(186003)(6246003)(71200400001)(8936002)(110136005)(54906003)(71190400001)(6436002)(66556008)(66476007)(2906002)(66946007)(4326008)(66446008)(305945005)(8676002)(99286004)(55016002)(81166006)(81156014)(64756008)(446003)(9686003)(52536014)(6306002)(25786009)(76116006)(7736002)(14454004)(476003)(66066001)(11346002)(53546011)(86362001)(7696005)(33656002)(316002)(966005)(5660300002)(6506007)(102836004)(3846002)(76176011)(6116002)(256004)(26005)(14444005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6737;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q4J29r0931ZPLzztcVf4cvU4mGjLnFrbZsoQrdvrKMROEwBhTB3/nhvXEEEbAxjVcVWzBoF1fT01hbsF1wbVu5aavjx3rB44VArDakiLr83l4aetqCDyV17hhBhk+4fAZJ4Lz0jQLlXxwxCNqlFHiHXMj0cAHG5gGuHsMAe4OpJRa+pCLMYDPjj2SocULz5K0LYm6Tt2OqjNdCr60VBZJ5jw0VIgEBh6RTTAKCKVUkfwwMyieV/a1cbhipu02pvVPt66zG7kkTquPHh1M+XMFI+3HNQXvcTHDIAnuWq48H/KfuOOgR0GkVPUF9QJL7awvvzLIOWwPo+mPtA+q7spUSDKOybsTRTQr3+5JhlKYwN4Rh42BWCqdwTKktOGSa0kQVujVvRDK7y++zteXItN4xKN8FbuO4WDOhTVd5GppY1rmwXHVtks16AJ0Ad2Z+w4jAegbCmOpqBFP8KNFTnFUYUX9EqK5TEmzT6PR4JSr2k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff4ba2b-aebf-4c22-0edd-08d75be1b558
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 20:02:06.2282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKqMQCHfimmhfb7J6U5hWKmuj6DWqX4NqMg4+3nPnhux9LsRZ0VNbfkRRBAjlyoczf9g/DLSoSMiKdUpT5XLig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6737
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, Jakub,

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andy Gospodarek
> Sent: Friday, October 25, 2019 9:58 AM
> To: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Yuval Avnery <yuvalav@mellanox.com>; Jiri Pirko <jiri@resnulli.us>;
> netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahameed
> <saeedm@mellanox.com>; leon@kernel.org; davem@davemloft.net;
> shuah@kernel.org; Daniel Jurgens <danielj@mellanox.com>;
> andrew.gospodarek@broadcom.com; Michael Chan
> <michael.chan@broadcom.com>
> Subject: Re: [PATCH net-next 0/9] devlink vdev
>=20
> On Wed, Oct 23, 2019 at 07:51:41PM -0700, Jakub Kicinski wrote:
> > On Thu, 24 Oct 2019 00:11:48 +0000, Yuval Avnery wrote:
> > > >>> We need some proper ontology and decisions what goes where. We
> > > >>> have half of port attributes duplicated here, and hw_addr which
> > > >>> honestly makes more sense in a port (since port is more of a
> > > >>> networking construct, why would ep storage have a hw_addr?).
> > > >>> Then you say you're going to dump more PCI stuff in here :(
> > > >> Well basically what this "vdev" is is the "port peer" we
> > > >> discussed couple of months ago. It provides possibility for the
> > > >> user on bare metal to cofigure things for the VF - for example.
> > > >>
> > > >> Regarding hw_addr vs. port - it is not correct to make that a
> > > >> devlink port attribute. It is not port's hw_addr, but the port's p=
eer
> hw_addr.
> > > > Yeah, I remember us arguing with others that "the other side of
> > > > the wire" should not be a port.
> > > >
> > > >>> "vdev" sounds entirely meaningless, and has a high chance of
> > > >>> becoming a dumping ground for attributes.
> > > >> Sure, it is a madeup name. If you have a better name, please share=
.
> > > > IDK. I think I started the "peer" stuff, so it made sense to me.
> > > > Now it sounds like you'd like to kill a lot of problems with this
> > > > one stone. For PCIe "vdev" is def wrong because some of the config
> > > > will be for PF (which is not virtual). Also for PCIe the config
> > > > has to be done with permanence in mind from day 1, PCI often
> > > > requires HW reset to reconfig.
> > >
> > > The PF is "virtual" from the SmartNic embedded CPU point of view.
> >
> > We also want to configure PCIe on local host thru this in non-SmartNIC
> > case, having the virtual in the name would be confusing there.
> >
> > > Maybe gdev is better? (generic)
> >
How about naming it 'subdev' -> as sub device?
Since these are the sub devices of one or different class which are getting=
 managed.

> > Let's focus on the scope and semantics of the object we are modelling
> > first. Can we talk goals, requirements, user scenarios etc.?
> >
> > IMHO the hw_addr use case is kind of weak, clouds usually do
> > tunnelling so nobody cares which MAC customer has assigned in the overl=
ay.
> >
> > CCing Andy and Michael from Broadcom for their perspective and
> > requirements.
>=20
> Thanks, Jakub, I'm happy to chime in based on our deployment experience.
> We definitely understand the desire to be able to configure properties of
> devices on the SmartNIC (the kind with general purpose cores not the kind=
 with
> only flow offload) from the server side.
>=20
> In addition to addressing NVMe devices, I'd also like to be be able to cr=
eate
> virtual or real serial ports as well as there is an interest in
> *sometimes* being able to gain direct access to the SmartNIC console not =
just
> a shell via ssh.  So my point is that there are multiple use-cases.
>=20
Yes. we also see that use case/desire of accessing it sometimes.
We believe that current direction of vdev is good starting point with your =
example below.
Actually want to call it 'subdev' for rest of the discussion below and in u=
pdated v1 series.

s/vdev/subdev

> Arm are also _extremely_ interested in developing a method to enable some
> form of SmartNIC discovery method and while lots of ideas have been throw=
n
> around, discovery via devlink is a reasonable option. =20
Great.=20
> So while doing all this will
> be much more work than simply handling this case where we set the peer or
> local MAC for a vdev, I think it will be worth it to make this more usabl=
e for
> all^W more types of devices.  I also agree that not everything on the oth=
er side
> of the wire should be a port.
>=20
Right. Having a generic object named 'subdev' of different flavours (simila=
r to port flavours), is very useful and extendible
For subdev flavours as,
(a) PCI PF,
(b) PCI VF,
(b) mdev
(c) serial/console device

> So if we agree that addressing this device as a PCIe device then it feels=
 like we
> would be better served to query device capabilities and depending on what
> capabilities exist we would be able to configure properties for those.  I=
n an
> ideal world, I could query a device using devlink ('devlink info'?) and i=
t would
> show me different devices that are available for configuration on the Sma=
rtNIC
> and would also give me a way to address them.  So while I like the idea o=
f being
> able to address and set parameters as shown in patch 05 of this series, I=
 would
> like to see a bit more flexibility to define what type of device is avail=
able and
> how it might be configured.
>=20
> So if we took the devlink info command as an example (whether its the pro=
per
> place for this or not), it could look _like_ this:
>=20
> $ devlink dev info pci/0000:03:00.0
$ devlink subdev info pci/0000:03:00.0
This will show all subdevices of different class and based on their class w=
ill show attributes?

I also liked your idea of resources (more than capabilities).
Using 'resource' will give visibility/information about what resources exis=
t.
Immediate one that becomes useful is total_msix_vectors of the device and t=
hen how much of this vectors(resource) to provision to a VF.
So each subdev will show much resource is being assigned to it.

Devlink already has notion of 'resource' as described in [1]. However it is=
 bit complex to parse and use, though mlxsw I think uses it.

Jiri,
What is your opinion on 'devlink resource'?

[1] http://man7.org/linux/man-pages/man8/devlink-resource.8.html

> pci/0000:03:00.0:
>   driver foo
>   serial_number 8675309
>   versions:
> [...]
>   capabilities:
>       storage 0
>       console 1
>       mdev 1024
>       [something else] [limit]
>=20
> (Additionally rather than putting this as part of 'info' the device capab=
ilities and
> limits could be part of the 'resource' section and frankly may make more =
sense
> if this is part of that.)
>=20
> and then those capabilities would be something that could be set using th=
e
> 'vdev' or whatever-it-is-named interface:
>=20
> # devlink vdev show pci/0000:03:00.0
> pci/0000:03:00.0/console/0: speed 115200 device /dev/ttySNIC0
> pci/0000:03:00.0/mdev/0: hw_addr 02:00:00:00:00:00 [...]
> pci/0000:03:00.0/mdev/1023: hw_addr 02:00:00:00:03:ff
>=20
> # devlink vdev set pci/0000:03:00.0/mdev/0 hw_addr 00:22:33:44:55:00
>=20

> Since these Arm/RISC-V based SmartNICs are going to be used in a variety =
of
> different ways and will have a variety of different personalities (not ju=
st
> different SKUs that vendors will offer but different ways in which these =
will be
> deployed), I think it's critical that we consider more than just the
> mdev/representer case from the start.
>=20
I completely agree with you.
Yuval patches are showing VF/mdev as starting example, but are not limited =
to it.

> > > >> Basically it is something that represents VF/mdev - the other
> > > >> side of devlink port. But in some cases, like NVMe, there is no
> > > >> associated devlink port - that is why "devlink port peer" would no=
t work
> here.
> > > > What are the NVMe parameters we'd configure here? Queues etc. or
> > > > some IDs? Presumably there will be a NVMe-specific way to configure
> things?
> > > > Something has to point the NVMe VF to a backend, right?
> > > >
> > > > (I haven't looked much into NVMe myself in case that's not obvious
> > > > ;))
It doesn't matter a given PCI VF class is nvme/network/gpu or other.
Since devlink framework handles the generic PCI device, having well defined=
 PCI VF object and handling generic PCI VF properties in common way is desi=
red.

So at minimum, I see following changes to be made to this series.

1. Update the cover letter for below items.
(a) Provide crisply, limitation of $ ip link set vf mac, and how is it over=
come here
(b) describe future updates to use resources for device resource configurat=
ion (one example is irq vectors)
(c) rename vdev to 'subdev' or any suggestion for better name?
(d) explicitly mention the current purpose and use case for future extensio=
n

2. update patches from vdev to subdev.

