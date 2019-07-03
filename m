Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E89D5E87B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfGCQNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:13:21 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:22501
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfGCQNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 12:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tz6mlnb0S7Jzil7xfbTcOsxJajvYNvTxMQKr5Mx5r0=;
 b=EZUg0ISRGLh+DZeZfPXkqcK31RUW/7cdKfcJHuLCY//0+gTP1aC1k+NAEM6e2qtRqS8KyTI73sDXw99OyGB3YJJdR8hg0ufahLDP3G+tW48/mabj4H8HJSNQnUe7El4GVIj98IijMJ5cy/8Vm95JTHzipkP3UmnR0Wyan8jeGJo=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4738.eurprd05.prod.outlook.com (52.133.59.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 16:13:18 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 16:13:18 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Topic: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Index: AQHVMAhn8T46v1pXDUi3XMXT/4YtI6a2aNkAgABHFVCAAOxagIAAD8wAgABTlQCAACfsUIAAAsAAgAApQ+CAAGLsAIAAO2kAgAAG3ICAABtdcA==
Date:   Wed, 3 Jul 2019 16:13:17 +0000
Message-ID: <AM0PR05MB48665F6CA614A3770D6ABCF4D1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701162650.17854185@cakuba.netronome.com>
 <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190703103720.GU2250@nanopsycho> <20190703140958.GB18473@lunn.ch>
 <20190703143431.GC2250@nanopsycho>
In-Reply-To: <20190703143431.GC2250@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.186.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 879dbfcd-9fab-46e0-58a7-08d6ffd15c46
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4738;
x-ms-traffictypediagnostic: AM0PR05MB4738:
x-microsoft-antispam-prvs: <AM0PR05MB4738A12E529CF5A67430FE86D1FB0@AM0PR05MB4738.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(13464003)(189003)(316002)(11346002)(476003)(446003)(186003)(74316002)(305945005)(5660300002)(66476007)(66946007)(73956011)(478600001)(71200400001)(71190400001)(4326008)(7736002)(8676002)(81166006)(81156014)(25786009)(76116006)(64756008)(66446008)(66556008)(8936002)(52536014)(256004)(486006)(33656002)(3846002)(2906002)(6246003)(6116002)(6506007)(14454004)(9686003)(229853002)(68736007)(14444005)(55016002)(54906003)(110136005)(76176011)(86362001)(66066001)(99286004)(7696005)(6436002)(53936002)(55236004)(26005)(53546011)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4738;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4YRNhdNXRfeCd+itMEWlSBHuEFpc/k0r5br+wF6Ufn1rWayDV57dS17DzfuQ46HBtYaZ5EvhWkbc2KKvb0IkJFTZ/CQ6G+DBf+cbMBtfWr3dnE78aYvZTXwPHSSuHgXuvpdXDUPattA1IR6VRb2sqKDclS5HteS4ugEaJTAMV38iOIoPdx9+LO2v3kpkpuzgEJNO+NrF4Agt/bluBCD0nTvVfO9HWwCtiFHQcg7prsDm/xiLcKFohFSeF7mEJD1naIVo9/bbQ86b5eKVQLetqoG6yO/Oh1iHfezB34GFtDbf23+mvzsBsgMHS7bRumYvt2mpwHf5ILYtqn73DuqqDs0oII5Wanrh2i7xgHTzFtVmr+RXyJvTliZz+v1Ja1KUWW9gT07stpkhysyQOXzbsxDhfXxs7ODp1j+REXetA8k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879dbfcd-9fab-46e0-58a7-08d6ffd15c46
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 16:13:17.9506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4738
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 3, 2019 8:05 PM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Parav Pandit <parav@mellanox.com>; Jakub Kicinski
> <jakub.kicinski@netronome.com>; Jiri Pirko <jiri@mellanox.com>;
> netdev@vger.kernel.org; Saeed Mahameed <saeedm@mellanox.com>;
> vivien.didelot@gmail.com; f.fainelli@gmail.com
> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour =
and
> port attribute
>=20
> Wed, Jul 03, 2019 at 04:09:58PM CEST, andrew@lunn.ch wrote:
> >> However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
> >> DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
> >> Ccing Florian, Andrew and Vivien.
> >> What do you guys think?
> >
> >Hi Jiri
> >
> >DSA and CPU ports are physical ports of the switch. And there can be
> >multiple DSA ports, and maybe sometime real soon now, multiple CPU
> >ports. So having a number associated with them is useful.
>=20
> Okay. Makes sense.
>=20
Ok. I should probably update the comment section for port_number as its sco=
pe is expanded.
Should I revise the series with updated comment?

> >
> >       Andrew
