Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C1063C28
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfGITtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:49:14 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:35648
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbfGITtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 15:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewyvzam5ay3DdknPpGjylIzhwSGiLKhJ1fUY/CZRJME=;
 b=jtreHa+5E2SswM6tzng5tyw7cosJzHQGhAdP+U4A2YAB0NIO0q+pCATRQhn90QiLIeKhUMvq/JJCpfMQucB1gjRQsRSaU7K4aCv11H9xfJhYFbTQB0lWMxliYK3HQrMNkU9mBp4+EUSLjW0y6Y9J5DeM8xl18boJrFeszeg7DVs=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6242.eurprd05.prod.outlook.com (20.178.119.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 19:49:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 19:49:09 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: RE: [RESEND PATCH iproute2 net-next] devlink: Introduce PCI PF and VF
 port flavour and attribute
Thread-Topic: [RESEND PATCH iproute2 net-next] devlink: Introduce PCI PF and
 VF port flavour and attribute
Thread-Index: AQHVMDsRY4ESbmxXpEO8+7X/rzJfO6bCvVCQ
Date:   Tue, 9 Jul 2019 19:49:09 +0000
Message-ID: <AM0PR05MB4866313BD7B8FF909969D455D1F10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190701183017.25407-1-parav@mellanox.com>
In-Reply-To: <20190701183017.25407-1-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.52.95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b4e094b-b47f-4071-6767-08d704a68297
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6242;
x-ms-traffictypediagnostic: AM0PR05MB6242:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR05MB6242BEDC74D35445FD474D16D1F10@AM0PR05MB6242.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:186;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(13464003)(189003)(199004)(55016002)(2501003)(102836004)(229853002)(66946007)(81156014)(81166006)(11346002)(446003)(8676002)(486006)(476003)(6306002)(9686003)(66556008)(74316002)(52536014)(25786009)(64756008)(6436002)(2906002)(6506007)(53546011)(4326008)(8936002)(305945005)(66446008)(55236004)(33656002)(5660300002)(14454004)(256004)(7736002)(316002)(99286004)(966005)(186003)(71190400001)(107886003)(68736007)(71200400001)(76116006)(86362001)(110136005)(54906003)(7696005)(6246003)(53936002)(66066001)(66476007)(26005)(76176011)(6116002)(3846002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6242;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O/AExvnA1m6cSPdfG1EycvAzHUInEmjC04XMssFuHVmWwIb1CdoKd2FWGoTJ7iIpPuFiL+xYypuQUVz+RQe4MfqFNe56MUcWiqwBYO9rfWLM4Zdy/IigOQjwPJkXg8SoiOkgeC5uSHzHCq+O4Fav5cubcR8rgrW5tIyEfzejDdkbqMnRVIX85kwhyIanW1k1FAHmVsoa7HuAAHYO+yarnyd5nslF4HRym6XSLMzzMaNeZeVd0WB8mLpDPxNo/2tj6e8E1GjTCvXbOKjCzWiY37LEOOl33VUZaTdDHWPrNYXujZ3uTx3klDnpYtE0W/4TvbYn6MBxw+9Nm5FQWnt6dn0dvBxpufCa4tooq6d3ilU1k/q9iTMxq/cYrmF8mvkLzMZCuqLBkia96yf05Axjq4E76b39wfy4A3FkPCxbuYI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4e094b-b47f-4071-6767-08d704a68297
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 19:49:09.7047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6242
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Parav Pandit
> Sent: Tuesday, July 2, 2019 12:00 AM
> To: netdev@vger.kernel.org
> Cc: Saeed Mahameed <saeedm@mellanox.com>;
> jakub.kicinski@netronome.com; Jiri Pirko <jiri@mellanox.com>; Parav Pandi=
t
> <parav@mellanox.com>
> Subject: [RESEND PATCH iproute2 net-next] devlink: Introduce PCI PF and V=
F
> port flavour and attribute
>=20
> Introduce PCI PF and VF port flavour and port attributes such as PF numbe=
r
> and VF number.
>=20
> $ devlink port show
> pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
> pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
> pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1
>=20
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  devlink/devlink.c            | 23 +++++++++++++++++++++++
>  include/uapi/linux/devlink.h | 11 +++++++++++
>  2 files changed, 34 insertions(+)
>
I will resend this patch with updated kernel commit id for the uapi, possib=
ly once unrelated patch [1] is merged, just to avoid merge conflict.

[1] https://patchwork.ozlabs.org/patch/1129927/

