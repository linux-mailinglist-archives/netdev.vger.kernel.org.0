Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D5E5DD8E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 06:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfGCEqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 00:46:17 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:6486
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfGCEqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 00:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQ1Og//LK+mHvtHJqj01qWT1y3epmRgG0Qerzuh8Dlk=;
 b=Rww0JdqteNCn+llXnNO704ecwH2b99c5TCpWwaqdBBJ5X+Bi8zdEWkQB6ndrccCBlI67Kaaw0Eqx7NwqwV+xB1pvPFVSaRzwxsXUIjarBsrbveletRoll+sSM2FeNqv6Y8h1LojKbjNMKU7cb7hVfamNIeMWS9QKISmyk9fErMA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6577.eurprd05.prod.outlook.com (20.179.33.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 04:46:14 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 04:46:13 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Topic: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Index: AQHVMAhn8T46v1pXDUi3XMXT/4YtI6a2aNkAgABHFVCAAOxagIAAD8wAgABTlQCAACfsUIAAAsAAgAApQ+A=
Date:   Wed, 3 Jul 2019 04:46:13 +0000
Message-ID: <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
        <20190701162650.17854185@cakuba.netronome.com>
        <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190702104711.77618f6a@cakuba.netronome.com>
        <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190702164252.6d4fe5e3@cakuba.netronome.com>
        <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
In-Reply-To: <20190702191536.4de1ac68@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b2fa85f-bd22-4538-c264-08d6ff7160ca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6577;
x-ms-traffictypediagnostic: AM0PR05MB6577:
x-microsoft-antispam-prvs: <AM0PR05MB657725E15853D4D58607B89ED1FB0@AM0PR05MB6577.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(13464003)(186003)(229853002)(26005)(102836004)(5660300002)(7696005)(6506007)(54906003)(99286004)(256004)(9456002)(9686003)(76176011)(53546011)(74316002)(478600001)(4326008)(76116006)(6436002)(2906002)(68736007)(6116002)(3846002)(33656002)(55236004)(7736002)(8936002)(305945005)(66066001)(8676002)(86362001)(53936002)(107886003)(6246003)(64756008)(81166006)(78486014)(66946007)(66446008)(66476007)(66556008)(446003)(316002)(6916009)(71190400001)(55016002)(11346002)(14454004)(71200400001)(81156014)(25786009)(73956011)(476003)(52536014)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6577;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tFWmJbu9N1FoxHEVgLZyQ/i3wT22gw4pjG8JDh6e3cpaoBuT7t3CPUGY72EW7au4yXnp/ndmKAstIoap4bsJA9ZaW+j//evXFy+fmgqqLwMgpTW/pYow85D/k+HMFC0ZyvxSeB8jzqQEoiOtvjFsv+dYoWIjC9q00UOmnM+d9u01Cc3QlDtng52lTluiz5TJzl92vEJsSFwV+BgpoqJbd05IOqtH8IIeYJNcVsToOLVq/gV20/XpIGA7gvwm9FkmJKNrKHXBf/gxYzSIshrJQI17xzm3SOjtFmMVr2gC0Mi6tuZdpVVZuhCNJOXTP6ckjz48pJKYud2Ew09rR6/OoiOoQEuvSCLw+UGxvmwekqk/pHj8azTFfTo61NlrF+sz3mYWE3qF5kSjwWf0p5K9y4AE7xenwxXrPlbL1gfoMfs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2fa85f-bd22-4538-c264-08d6ff7160ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 04:46:13.8112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6577
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, July 3, 2019 7:46 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed
> Mahameed <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour =
and
> port attribute
>=20
> On Wed, 3 Jul 2019 02:08:39 +0000, Parav Pandit wrote:
> > > If you want to expose some device specific eswitch port ID please
> > > add a new attribute for that.
> > > The fact that that ID may match port_number for your device today is
> > > coincidental.  port_number, and split attributes should not be
> > > exposed for PCI ports.
> >
> > So your concern is non mellanox hw has eswitch but there may not be a
> > unique handle to identify a eswitch port?
>=20
> That's not a concern, no.  Like any debug attribute it should be optional=
.
>=20
> > Or that handle may be wider than 32-bit?
>=20
> 64 bit would probably be better, yes, although that wasn't my initial
> concern.
>=20
Why 32-bit is not enough?

> > And instead of treating port_number as handle, there should be
> > different attribute, is that the ask?
>=20
> Yes, the ask, as always, is to not abuse existing attributes to carry
> tangentially related information.

Why it is tangential?
Devlink_port has got a port_number. Depending on flavour this port_number r=
epresents a port.
If it is floavour=3DPHYSICAL, its physical port number.
If it is eswitch pf/vf ports, it represents eswitch port.

Why you see it only as physical_port_number?

Jiri,
Do you see it this way too?

