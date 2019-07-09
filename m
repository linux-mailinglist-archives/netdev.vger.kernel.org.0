Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A16A63061
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbfGIGU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:20:56 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:33978
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbfGIGU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 02:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQgyGnQ/v7lPepsuj5rFonkTdzzFY+jVi+NXaYtLx9s=;
 b=dE1b+/lJGUhiUqFRZCxKxEzfFg+Y4Fn8qjqAQvWYqSmwqCVixLEiZ2BlNghO7NY3Zwo42zjGdql21yiel14MkrVnYDJ6VJuVSPsnNM+LVjdjughn/LPvWmqwSnq6pngCiCZ9cecqA3cM/jURO2D4YMyipd2GYwoXO2VVHfQ1Uw0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4516.eurprd05.prod.outlook.com (52.133.57.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 06:20:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 06:20:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Thread-Topic: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Thread-Index: AQHVNg1tsiPOY/l61Umq9TRaQKUK/6bBxXIAgAAKU9A=
Date:   Tue, 9 Jul 2019 06:20:52 +0000
Message-ID: <AM0PR05MB48666760758E8CD1656A15E0D1F10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190709041739.44292-1-parav@mellanox.com>
 <20190708224012.0280846c@cakuba.netronome.com>
In-Reply-To: <20190708224012.0280846c@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.186.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa3f9fa7-e4e4-4e24-d69d-08d7043597f7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4516;
x-ms-traffictypediagnostic: AM0PR05MB4516:
x-microsoft-antispam-prvs: <AM0PR05MB45164E4A6E7355DFBEB0E276D1F10@AM0PR05MB4516.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(13464003)(189003)(199004)(478600001)(2906002)(7696005)(68736007)(316002)(6116002)(4326008)(76176011)(3846002)(55016002)(73956011)(52536014)(6246003)(9686003)(66556008)(76116006)(107886003)(66946007)(66476007)(66446008)(6916009)(6436002)(256004)(64756008)(53936002)(229853002)(33656002)(99286004)(102836004)(7736002)(305945005)(11346002)(446003)(486006)(476003)(74316002)(66066001)(71200400001)(5660300002)(26005)(54906003)(186003)(6506007)(53546011)(71190400001)(25786009)(8676002)(86362001)(81166006)(81156014)(8936002)(14454004)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4516;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5G6ZaZclcyBXYhzBRz1FH9Z5+aEhd4x0ZCe+stZyUXtWPERJWmzFm/LfGu+l6IpNaFf1DW4mKnRZArWlX8vHo2MNdmtsiRCvG5oFt3FMnnn0la9pzOijRfys2LZpJitdyvBcEJnFlSCCLOf0C2hXOAhGuCLvueUxRyyJlcDQtSwlf9pd/qFmkQDzCbIxpiF7WNYnQube6DTmRi4nmZ8IKWh76jm+UgqXVPT+dirlWlkxTd42QKBgwewk97vz6GijKjvbd5pODXnvDAJQRfjlZBCRPgn2SPu+DbX9g/TsarevFUwKVKR25cO0Lq/6xEU/lWPkFO7KJc9hadckvGdi0GU+cVvRJzoZICBGcQZ7hoeJwAGxGZ6XwbaWeHMUIOLI8G8LfxD3fVyjdSCQuoCm4QBMuS6pS8rmiYt8aQdsmpg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3f9fa7-e4e4-4e24-d69d-08d7043597f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 06:20:52.4694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4516
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, July 9, 2019 11:10 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahamee=
d
> <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports =
and
> attributes
>=20
> On Mon,  8 Jul 2019 23:17:34 -0500, Parav Pandit wrote:
> > This patchset carry forwards the work initiated in [1] and discussion
> > futher concluded at [2].
> >
> > To improve visibility of representor netdevice, its association with
> > PF or VF, physical port, two new devlink port flavours are added as
> > PCI PF and PCI VF ports.
> >
> > A sample eswitch view can be seen below, which will be futher extended
> > to mdev subdevices of a PCI function in future.
> >
> > Patch-1 moves physical port's attribute to new structure
> > Patch-2 enhances netlink response to consider port flavour
> > Patch-3,4 extends devlink port attributes and port flavour
> > Patch-5 extends mlx5 driver to register devlink ports for PF, VF and
> > physical link.
>=20
> The coding leaves something to be desired:
>=20
> 1) flavour handling in devlink_nl_port_attrs_put() really calls for a
>    switch statement,
> 2) devlink_port_attrs_.*set() can take a pointer to flavour specific
>    structure instead of attr structure for setting the parameters,
> 3) the "ret" variable there is unnecessary,
> 4) there is inconsistency in whether there is an empty line between
>    if (ret) return; after __devlink_port_attrs_set() and attr setting,
> 5) /* Associated PCI VF for of the PCI PF for this port. */ doesn't
>    read great;
> 6) mlx5 functions should preferably have an appropriate prefix - f.e.
>    register_devlink_port() or is_devlink_port_supported().
>=20
Those two static helper functions doesn't need mlx5_ prefix.
ndo ops are prefixed appropriately.

> But I'll leave it to Jiri and Dave to decide if its worth a respin :) Fun=
ctionally I
> think this is okay.
>=20
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
