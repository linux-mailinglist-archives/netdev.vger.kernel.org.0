Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F58F65629
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 13:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfGKLwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 07:52:45 -0400
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:23104
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728502AbfGKLwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 07:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpC0IO2IjILIEotGbBTV3O8QSHvTjnjgYGJzm/ZD6RM=;
 b=WeW9sPUD7astuSQ1f67hJSHUdXADJR/XxcA97ql0ZtUsm5FVRIOKpwL1/U1WqYODlyYt62Br8qo+1zV9gl9OTbAYSrJadAxpNKG461r0EhyL/7fTUQlrCmiW2PyAviRNu1EgE/pEopLpnYM9yRBFgccZAszZSCT6TdWJT+yL8VU=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5965.eurprd05.prod.outlook.com (20.178.126.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 11 Jul 2019 11:52:42 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 11:52:42 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: Re: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVNgpSNqxsVllq5U23Am+RwOaE5KbB1zsAgAJNFwCAAO0agIAAQMGA
Date:   Thu, 11 Jul 2019 11:52:42 +0000
Message-ID: <20190711115235.GA25821@mellanox.com>
References: <20190710175212.GM2887@mellanox.com>
 <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
In-Reply-To: <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:208:160::16) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 227fc414-6726-497b-2d4c-08d705f647a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5965;
x-ms-traffictypediagnostic: VI1PR05MB5965:
x-microsoft-antispam-prvs: <VI1PR05MB5965593772E62C372F6A9B6ACFF30@VI1PR05MB5965.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(189003)(199004)(14454004)(26005)(6486002)(229853002)(81156014)(486006)(8676002)(81166006)(558084003)(386003)(76176011)(2906002)(186003)(52116002)(478600001)(11346002)(6506007)(476003)(7736002)(2616005)(316002)(66446008)(66476007)(66556008)(64756008)(305945005)(446003)(4326008)(25786009)(99286004)(5660300002)(66946007)(66066001)(36756003)(6246003)(71200400001)(71190400001)(33656002)(6116002)(3846002)(53936002)(6436002)(1076003)(54906003)(6916009)(68736007)(86362001)(256004)(102836004)(8936002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5965;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TFN8juN7yh+3BWV48h4dA8V2zI4SmHEpBTest1oInspj+F+dbq4opGjVfDQ644qQTsHmJ8vDCK4dTp5N8YF8WMwuHKxP91TA3cDSwaHRH8dhGmtUvF+cHobeHY59v5NmUs6QknnU1wZgcHKWgKkBfBo27/DH9z/w45AI5SkPhmBipilfqLetLaQnnOcgAktxl5PcbYzAm6xID4xanDzcyWArZNKRvtZbTHZkIemzZz43X3vZVwlXSPegpUbNKP9klqzh7sLiYRP2lZL/GgTv00FUMgKqargTqhZWaPgKLX+Vkkn8BjVxYmOJ9zDsOHl3Ingh7p4BwejytioKclAa1dDKZHXi/H/G4PJA1io6pqA5SQ0ML/sU0DraEDTw61zfAFnRrAd//Bx+rqb54UxKr6G8FAJ8etF4kjeNbiKfKow=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41E70F810226F94886FF11857E428ADB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 227fc414-6726-497b-2d4c-08d705f647a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 11:52:42.2691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5965
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 08:00:49AM +0000, Bernard Metzler wrote:

> That listen will not sleep. The socket is just marked
> listening.=20

Eh? siw_listen_address() calls siw_cep_alloc() which does:

	struct siw_cep *cep =3D kzalloc(sizeof(*cep), GFP_KERNEL);

Which is sleeping. Many other cases too.

Jason
