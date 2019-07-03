Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF74A5E5BC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGCNt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:49:56 -0400
Received: from mail-eopbgr50052.outbound.protection.outlook.com ([40.107.5.52]:47781
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbfGCNtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 09:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ESDwWlQQ8Kki/pY9CcSCfF2Zs+0gGtRrotelTMZqsU=;
 b=e5t6hsk0wOS1PmJHpPib0goX4i1ieNBbAw1hrdT1niFGL3k/0ziebSVqKLz1xvx/niFha7Sqg6XP/GTFN9iSxS3LvRVTMepjBteDAgAiXiy6te8WsdXJs7fD2XaKV9bDEwicO6GXqQ1Ge8FlEn12l+xhYUEoYgc2L0srZKBifnU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4131.eurprd05.prod.outlook.com (52.134.93.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 13:49:51 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 13:49:51 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Topic: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Index: AQHVMAhn8T46v1pXDUi3XMXT/4YtI6a2aNkAgABHFVCAAOxagIAAD8wAgABTlQCAACfsUIAAAsAAgAApQ+CAAGLsAIAANQgw
Date:   Wed, 3 Jul 2019 13:49:51 +0000
Message-ID: <AM0PR05MB4866675A8CB5BDB2890E14BBD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190701122734.18770-2-parav@mellanox.com>
 <20190701162650.17854185@cakuba.netronome.com>
 <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190703103720.GU2250@nanopsycho>
In-Reply-To: <20190703103720.GU2250@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.186.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c6186d4-08d0-4829-de4b-08d6ffbd523e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4131;
x-ms-traffictypediagnostic: AM0PR05MB4131:
x-microsoft-antispam-prvs: <AM0PR05MB41312B4E202F5D3D2D4EA2A5D1FB0@AM0PR05MB4131.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(13464003)(199004)(189003)(8676002)(25786009)(476003)(446003)(6506007)(55236004)(11346002)(53546011)(102836004)(81166006)(52536014)(14454004)(486006)(8936002)(99286004)(4326008)(6246003)(68736007)(478600001)(54906003)(14444005)(6916009)(256004)(5660300002)(81156014)(66556008)(66476007)(73956011)(316002)(2906002)(186003)(53936002)(7696005)(66946007)(76176011)(6436002)(3846002)(55016002)(66066001)(76116006)(64756008)(26005)(229853002)(6116002)(66446008)(33656002)(305945005)(7736002)(71190400001)(86362001)(74316002)(71200400001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4131;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /5K1csLZmO8IfoOjukRjUIic5hOrzFpp4P2rwrjRnPgbSGFGLuyDEcE4HALr9GntukQlA3wy+UK18I3q2+vYV5IkeNmZBSqCw+fFqjmsJ6yq7G9xzYB5+cbzO6Fq1v4LISBnL5wi9e3Ua/LB++y7oEm2FENNea10CUzDUGfK5D5GF10ez9fIR9Ci79STHj9SvB6Iyh/XSHTD7ND50jPIhmQ25HPJS6W7Ze2/J7p9BDkLIM1slowGLnwOzh3vFNJhYxBv4XFVzDflciGN+SI7qjtNWtU1a+oj6yod7IMEIHD0ywIXiwYkIc3axaDO87wL0bZv+7wVc0SB6YkHqgkgCl46q+1uxQv2O3iOJP3NrCPJ/HT+KH32mwXnNOZRtGHOd08h3rl5QrtfDiPA9P4jCzEVZMOHi6trc57wiRAMD8k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6186d4-08d0-4829-de4b-08d6ffbd523e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 13:49:51.1558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 3, 2019 4:07 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>; Jiri Pirko
> <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; vivien.didelot@gmail.com; andrew@lunn.ch;
> f.fainelli@gmail.com
> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour =
and
> port attribute
>=20
> Wed, Jul 03, 2019 at 06:46:13AM CEST, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> Sent: Wednesday, July 3, 2019 7:46 AM
> >> To: Parav Pandit <parav@mellanox.com>
> >> Cc: Jiri Pirko <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed
> >> Mahameed <saeedm@mellanox.com>
> >> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port
> >> flavour and port attribute
> >>
> >> On Wed, 3 Jul 2019 02:08:39 +0000, Parav Pandit wrote:
> >> > > If you want to expose some device specific eswitch port ID please
> >> > > add a new attribute for that.
> >> > > The fact that that ID may match port_number for your device today
> >> > > is coincidental.  port_number, and split attributes should not be
> >> > > exposed for PCI ports.
> >> >
> >> > So your concern is non mellanox hw has eswitch but there may not be
> >> > a unique handle to identify a eswitch port?
> >>
> >> That's not a concern, no.  Like any debug attribute it should be optio=
nal.
> >>
> >> > Or that handle may be wider than 32-bit?
> >>
> >> 64 bit would probably be better, yes, although that wasn't my initial
> >> concern.
> >>
> >Why 32-bit is not enough?
> >
> >> > And instead of treating port_number as handle, there should be
> >> > different attribute, is that the ask?
> >>
> >> Yes, the ask, as always, is to not abuse existing attributes to carry
> >> tangentially related information.
> >
> >Why it is tangential?
> >Devlink_port has got a port_number. Depending on flavour this port_numbe=
r
> represents a port.
> >If it is floavour=3DPHYSICAL, its physical port number.
> >If it is eswitch pf/vf ports, it represents eswitch port.
> >
> >Why you see it only as physical_port_number?
>=20
> The original intention was like that. See the desc of
> devlink_port_attrs_set():
>=20
>  *      @port_number: number of the port that is facing user, for example
>  *                    the front panel port number
>=20
> For vf/pf representors, this is not applicable and should be indeed avoid=
ed.
>=20
Physical port number is not applicable but this is useful information that =
completes the eswitch picture.
Because eswitch has this termination end point anyway.
Instead of inventing some new vendor specific field, I see value in using e=
xisting port_number field.
Will wait for others inputs.

> However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
> DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
> Ccing Florian, Andrew and Vivien.
> What do you guys think?
>=20
> Perhaps we should have:
> 	if (attrs->flavour =3D=3D DEVLINK_PORT_FLAVOUR_PHYSICAL &&
> 	    nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs-
> >port_number))
>                 return -EMSGSIZE;
> in devlink_nl_port_attrs_put()

