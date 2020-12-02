Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B622CB3EC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgLBE2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:28:15 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5031 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbgLBE2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 23:28:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc717b70000>; Tue, 01 Dec 2020 20:27:35 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 04:27:32 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Dec 2020 04:27:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxSOcUecYBylc/rOKOuCosXWYD1RDZk3ECBZfMH5E9aoFTEv2Vb13qxxyNcBFH7UI9pnobOGdeRCntc5V1S8pnBz3hEfKk54iT2Y8O8PpUVzcoKMILlKygn0FJ+5ZTwkVeYv1g3fojsOHofRZjZSCEPG5+4UB9ReaeN/ajD35+JGvbwv5NWFvAhom7BPutmggaavTNMKotVd5RlMHoLh0ab/Hi+isDh/2Bfi9GglMeVFNkrtAgbpFHMErRjdZyS41l/+mgSOGg3W6SX/wZM4kZOO/UZjYtIOhrWWetG4OlZzIrcafPUOSj8b6AO0dItomh6Un8jxlvPvoztLEB94eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RD8mEQlASAlUiwAmdkm6QEywc63UyjJEPGGp8W+rRN8=;
 b=mi6hqawP4BAg7m73Gl2wIxQX264wKBKF1AOi5mLxpXE6fIQ4QkIKKvywq6zxkF+rSuAghMRS4MxAHEUSP6rpV1objziCfpLlmpumBMgkIN0CIMY0SwRZDy+oL1ufDeJPPflHU0SIdLzAbVbpR6PV+wUlyaEa0ccMTRh42nUqQpAekn9hroBrTI6rfj2yNydKPdWOALAXAIpQykDab8Gj8V6zyCUyhRonb5NVQVduFV99i++AJ6yucJa5MpuaPzMElLMUgFmGYCcYODOii2r3f8J0kzj/MYOw7eokE+Z8sHzUd6MTOFcuxwrFiVjZDBNkhzWHOwAIxzOTEsUUZTtsNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3809.namprd12.prod.outlook.com (2603:10b6:a03:1aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 2 Dec
 2020 04:27:30 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 04:27:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v2] devlink: Add devlink port documentation
Thread-Index: AQHWx1ONAO60w5g4sUGx6JSfvAwuqKnjB/SAgAAoKZA=
Date:   Wed, 2 Dec 2020 04:27:30 +0000
Message-ID: <BY5PR12MB4322E990BCAF8BD6B2248E72DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201130200025.573239-1-parav@nvidia.com>
 <20201201173441.229a94c7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201173441.229a94c7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c21ee3fa-e700-403a-3cfd-08d8967a9503
x-ms-traffictypediagnostic: BY5PR12MB3809:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB38093F06B9AA34AB6841ACBFDCF30@BY5PR12MB3809.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YmwhRZsdBabKN8Y7D53O4ONdbrX39gSIVRxCP3GMrgGNW8F5ZiNScwYRX8T8ZxvbAX2mUF9kzZFt1KFVGT3pr/keQe+d2+yfG7/LG1Xc4SVyVE7rqHLneoXoRBm4G91ELxpLOLGDjHLSbD962yqoXBbxfgRqX0NPqoQFoW1r217PWEs31dbmmk8w3rrTKErCM/q5yJ0XC+YAPyhJ7g4XFiilhyoJ+LGOpnXjvI6KDGPuzH46NBZaRvvMuMN5M2Ety2YXNwnfeY1lfrBixhbbmXDiNiS+35GcFc9t0FUCQMF9a88ol1aYp5NPjENNxYWWjGiclj4q+9uE0h1s0GU2/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(7696005)(8676002)(55236004)(55016002)(478600001)(83380400001)(52536014)(186003)(6506007)(66446008)(66556008)(64756008)(66946007)(76116006)(26005)(66476007)(2906002)(6916009)(9686003)(5660300002)(86362001)(71200400001)(4326008)(33656002)(316002)(8936002)(107886003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VINtDdB98+D+Kbrcj9tP1vGXRJmcadWHvwJ+QU0mPNYClcsK5HpdT9KRoQXF?=
 =?us-ascii?Q?Vb0YPZRu2yA2YBueMv/CzdtHEGvQWHPFlSGZ0g2Koj/LBJYs631Idx1YVNrF?=
 =?us-ascii?Q?LMBdFR+QC9HRmCLTyjSvRyGEiwvs7MZ+QHxj1yTolk4NTCgvEJs7ixtUfxwY?=
 =?us-ascii?Q?h0YXP6Wizocrda1MgBBD+RObaYz0SPHg7Y0pp0rayZkiRrO2hJECfPLHYzGB?=
 =?us-ascii?Q?dI5FSHycXxgHaFUxxGPXWGNhopqA+ZKbX+tQyVYgYkkgin1McepObxbYpXzr?=
 =?us-ascii?Q?5fGVtCLde2UvY5hRiOv1P9PBy0SihOVQJ8qyW3Y4cwv+aL76GgOTm2EQglmw?=
 =?us-ascii?Q?43LB/yUyAKU0hlQamBR8tnBB+yZgQbvnSsfjtezoxPVP16upfH4T5U2Ykrbe?=
 =?us-ascii?Q?a+cNixi9+BDYfea/udZva6Q+Ie+hWnketqS6QLRBtUXGhIKNg83GP81NtdRm?=
 =?us-ascii?Q?oYuuwsJXxUyYLi6SZZIQRThMpfRvwdomFy/tITUr49PEdnkG/Ml46lfAexDY?=
 =?us-ascii?Q?DOEWB59qqgkVxem5YNnXAqWg9899OMEzwqkB3fKP3KaQ7pWVFRCjrTtSN0GL?=
 =?us-ascii?Q?vpAXbOo4Nmn9/AoO+95ry+3mfODx8Ydl3FTQxpxWGiPbjJ4/KMDV6OyiEfj8?=
 =?us-ascii?Q?1P1UE/cyHo+E3Ofs7qezfGAKC+a/4fN1IcyUCXOBVAqjCm5rffOzyKvSncXT?=
 =?us-ascii?Q?7RD6aB5wqA3I8tltimAgG32bgiS+o6kYUAf3a+Xh8aVs/qOY1MC+Syv7cRfp?=
 =?us-ascii?Q?UNeJLJGxmWbbfPmw63r8vssQmfF5L7w7CJMxQC5rjv2VueZF/KTw9HNJAill?=
 =?us-ascii?Q?zjRY4riE6AEPr8bnIO5B8XjRXki2pPQ5GWcLQq2XJ6CmxCGCs4WYY32/8chW?=
 =?us-ascii?Q?IyoPjrsXJVeYzlDH+UZnnOTH5cOFwT1Vlm+Tlg/4x1e+wFdfV0XaNe/GYct+?=
 =?us-ascii?Q?ooD+1VPvHaziMUxVxPvGBGHyX7YR9dj8TXBuZrsTIfI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21ee3fa-e700-403a-3cfd-08d8967a9503
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 04:27:30.2681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7Kkyd05n6dPzV35V/6HP/c96xf6QRocbgQ+MQkEFjVngugqeamN6LCp2kt2RfEaruMp3aJALLRIE7cC/pJgqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3809
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606883255; bh=RD8mEQlASAlUiwAmdkm6QEywc63UyjJEPGGp8W+rRN8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=HJ9OwzrSsOVcaL7vUOBOfKDNhk0hRvHJr+zVJZlaCidP1b4VoPbp+K8nPEF27gUiy
         PNfqc1HYymUtNzmOnvAWItWTLu0mXYNWFL8SCAhDOVBuZU9zqcB112DL9G6vzkrMaQ
         G9gn/vgW39HN9gDYISOxTXFZvbZjzIm4axJ1QbncIyIJ58PoQY/l8XqULwi1kWCoWx
         lqS8++evdsmOXyE/Uxh++6pjJ3fn4i+ttWtQWozfwthilWekNHxUJgcKIIAHoh0fmO
         V6ArDJkCE2S3q8Hzv7zJV2xfJKbQInNMOOjwalwdb/TzwARN1Z80/KxYwXHVHw/gQT
         AvVswH1Oq/f7Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 2, 2020 7:05 AM
>=20
> On Mon, 30 Nov 2020 22:00:25 +0200 Parav Pandit wrote:
> > Added documentation for devlink port and port function related commands=
.
> >
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>=20
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +Devlink Port
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +``devlink-port`` provides capability for a driver to expose various
> > +flavours of ports which exist on device. A devlink port can be of an
> > +embedded switch (eswitch) present on the device.
>=20
> The wording is a little awkward here.
>=20
> The first paragraph should clarify what object represents.
>=20
> This just says it exposes ports that exist.
>=20
> A better phrasing would be to say that these are ports of an eswitch, in =
trivial
> case the only ports will be the physical ports of the card.
>
Sometimes it is eswitch port, sometimes its physical port on card, sometime=
s virtual port.
Will rephase.
=20
> > +A devlink port can be of 3 diffferent types.
>=20
> "can be of" repeated from the previous line
>=20
Will rephase.

> > +.. list-table:: List of devlink port types
> > +   :widths: 23 90
> > +
> > +   * - Type
> > +     - Description
> > +   * - ``DEVLINK_PORT_TYPE_ETH``
> > +     - This type is set for a devlink port when a physical link layer
> > + of the port
>=20
> Is "physical link layer" a thing? I the common names are physical layer a=
nd a
> (data) link layer. I don't think I've seen physical link layer, or would =
know what it
> is...
I will drop 'physical'. And just say link layer.

>=20
> > +       is Ethernet.
> > +   * - ``DEVLINK_PORT_TYPE_IB``
> > +     - This type is set for a devlink port when a physical link layer =
of the port
> > +       is InfiniBand.
> > +   * - ``DEVLINK_PORT_TYPE_AUTO``
> > +     - This type is indicated by the user when user prefers to set the=
 port type
> > +       to be automatically detected by the device driver.
>=20
> IMO type should be after flavor. Flavor is a higher level attribute, only=
 physical
> ports have a type.
>=20
I will shift flavour up.
virtual port flavour also has type as eth/ib.

> > +Devlink port can be of few different flavours described below.
> > +
> > +.. list-table:: List of devlink port flavours
> > +   :widths: 33 90
> > +
> > +   * - Flavour
> > +     - Description
> > +   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
> > +     - Any kind of port which is physically facing the user. This can
> > + be
>=20
> Hm. Not a great phrasing :(
>=20
> It faces a physical networking layer. To me PCIe faces the user.
>
PCIe and physical networking ports, both are visible to users.
Former is usually inside the server, later is more frequently visible outsi=
de where networking cable is connected.
=20
So, how about wording it as,

Any kind of physical networking port.

> > +       a eswitch physical port or any other physical port on the devic=
e.
> > +   * - ``DEVLINK_PORT_FLAVOUR_CPU``
> > +     - This indicates a CPU port.
>=20
> You need to mention this is a DSA-only thing.
>=20
Ok. will add.

> > +   * - ``DEVLINK_PORT_FLAVOUR_DSA``
> > +     - This indicates a interconnect port in a distributed switch arch=
itecture.
>=20
> (DSA)
>=20
> > +   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
> > +     - This indicates an eswitch port representing PCI physical functi=
on(PF).
> > +   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
> > +     - This indicates an eswitch port representing PCI virtual functio=
n(VF).
> > +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> > +     - This indicates a virtual port facing the user.
>=20
> No idea what that means from the description.
>
Let me rephase it as below.

This indicates a virtual port for the virtual PCI device such as PCI VF.
=20
> > +A devlink port may be for a controller consisting one or more PCI devi=
ce(s).
>=20
> Port can have multiple PCI devices?
For each PCI device there is a port as depicted in the diagram from commit =
3a2d9588c4f7.

>=20
> > +A devlink instance holds ports of two types of controllers.
> > +
> > +(1) controller discovered on same system where eswitch resides This
> > +is the case where PCI PF/VF of a controller and devlink eswitch
> > +instance both are located on a single system.
> > +
> > +(2) controller located on external host system.
> > +This is the case where a controller is located in one system and its
> > +devlink eswitch ports are located in a different system.
> > +
> > +An example view of two controller systems::
> > +
> > +                 -----------------------------------------------------=
----
> > +                 |                                                    =
   |
> > +                 |           --------- ---------         ------- -----=
-- |
> > +    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s=
)| |
> > +    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/-=
-- |
> > +    | pci rc  |=3D=3D=3D | pf0 |______/________/       | pf1 |___/____=
___/     |
> > +    | connect |  | -------                       -------              =
   |
> > +    -----------  |     | controller_num=3D1 (no eswitch)              =
     |
> > +                 ------|----------------------------------------------=
----
> > +                 (internal wire)
> > +                       |
> > +                 -----------------------------------------------------=
----
> > +                 | devlink eswitch ports and reps                     =
   |
> > +                 | ---------------------------------------------------=
-- |
> > +                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0=
 | |
> > +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN=
 | |
> > +                 | ---------------------------------------------------=
-- |
> > +                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1=
 | |
> > +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN=
 | |
> > +                 | ---------------------------------------------------=
-- |
> > +                 |                                                    =
   |
> > +                 |                                                    =
   |
> > +                 |           --------- ---------         ------- -----=
-- |
> > +                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s=
)| |
> > +                 | -------   ----/---- ---/----- ------- ---/--- ---/-=
-- |
> > +                 | | pf0 |______/________/       | pf1 |___/_______/  =
   |
> > +                 | -------                       -------              =
   |
> > +                 |                                                    =
   |
> > +                 |  local controller_num=3D0 (eswitch)                =
     |
> > +
> > + ---------------------------------------------------------
> > +
> > +Port function configuration
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > +
> > +When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
> > +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the port of a PCI funct=
ion.
> > +A user can configure the port function attributes before enumerating
> > +the function. For example user may set the hardware address of the
> > +function represented by the devlink port.
> > diff --git a/Documentation/networking/devlink/index.rst
> > b/Documentation/networking/devlink/index.rst
> > index d82874760ae2..aab79667f97b 100644
> > --- a/Documentation/networking/devlink/index.rst
> > +++ b/Documentation/networking/devlink/index.rst
> > @@ -18,6 +18,7 @@ general.
> >     devlink-info
> >     devlink-flash
> >     devlink-params
> > +   devlink-port
> >     devlink-region
> >     devlink-resource
> >     devlink-reload

