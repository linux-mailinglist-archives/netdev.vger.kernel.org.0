Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC72967E38
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 09:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfGNHzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 03:55:53 -0400
Received: from mail-eopbgr10072.outbound.protection.outlook.com ([40.107.1.72]:25782
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726728AbfGNHzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jul 2019 03:55:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+xgLxJvF3Q29XQo3ke2X/scoe4qyCeHupcmuwd96tRztP4vbx/kJzx/aeyIGSs5wqUtFz83OGwf+h9cOWrm2R8Ct5dv8/2dF8UBA7tgz5++77ldj0+bBuCquOGtSmR0mQUfgsObod0rEbhJolzWTDPHU490NnTkLNAYQzMn8UExp9/YYTjJ8WHl3exT+wAmFdPzIO/vef5pM0DUDfL2dyC+2WM4shTGWp9C2q+4aIsUEEfuI11+xt5DxxGNXVydUsHBasPy0hYbS1UVioUUn3EDYjClUM951w8cJxFigtdDrEB/zN/ymOlX49dKNH+7PNgBx7rs6vZCoteBERjoMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWnWYUwFSuqVZ8qiveFXjlD/RDXCjkAAm4iDegL/TLc=;
 b=CadcV97ZRuWZ08aprRsaSPdj/Waw+P8VBJEG7xSIT2FJFx1Dvc30kMDIXsoZUQwEfdl2DPW2B6khEYrHe9acr+kznH2g/QJWG7+H7m0Msu2IhuOj4Fggr1niUb9kcQiYqV08tcw3mAXN39PnliEK5il27WKuGxtgj1aw7MuM96tj0G3mFXS2+uL94QU8FlkPYiHi4lba4fLARKLyzg9ebvnfrswjxpRHmE64L/3rMgmCcTxQSTV5K7W9TBJffBAr1AquUGLr2uHw+jSKiCUhiVB5Yxm8X8D4Nq3UMX+Q4dAnU9HiKsaLjyHvV/c1Xq5o5zTbCN5OVHZHixYAb3T4BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWnWYUwFSuqVZ8qiveFXjlD/RDXCjkAAm4iDegL/TLc=;
 b=M/q5WH94mNb3hDIM7kZf5U/wcIJOJ0ipNgbSVkt8CvZ5BxHMH92p17f0aRFhJDHTnKoNA/tPjfmwLQM152APhSuCRrWNe6ZeY8OicvJhf5aa6zMcqULdIG0xr4lioifQ4lurgEqcP9J2ZWOcakPABVGslJbdWbK0nuFNMUTre3A=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6476.eurprd05.prod.outlook.com (20.179.43.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Sun, 14 Jul 2019 07:55:49 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2073.012; Sun, 14 Jul 2019
 07:55:48 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Thread-Topic: linux-next: Fixes tag needs some work in the net tree
Thread-Index: AQHVOH4jqpLwEYqGE0Kxlz4/p/63C6bJwhiA
Date:   Sun, 14 Jul 2019 07:55:48 +0000
Message-ID: <4f524361-9ea3-7c04-736d-d14fcb498178@mellanox.com>
References: <20190712165042.01745c65@canb.auug.org.au>
In-Reply-To: <20190712165042.01745c65@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::19) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ea53efe-57fa-48b7-0fb9-08d70830af2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6476;
x-ms-traffictypediagnostic: DBBPR05MB6476:
x-microsoft-antispam-prvs: <DBBPR05MB6476AA658DD6EB85F66D2544AECC0@DBBPR05MB6476.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:200;
x-forefront-prvs: 0098BA6C6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39850400004)(346002)(396003)(199004)(189003)(53754006)(5660300002)(66066001)(256004)(6116002)(3846002)(4326008)(53936002)(386003)(6436002)(76176011)(52116002)(229853002)(102836004)(186003)(26005)(53546011)(6506007)(6486002)(107886003)(6246003)(31686004)(11346002)(2616005)(446003)(476003)(6512007)(99286004)(71190400001)(2906002)(486006)(305945005)(71200400001)(86362001)(7736002)(36756003)(25786009)(81156014)(81166006)(8936002)(478600001)(54906003)(31696002)(8676002)(110136005)(4744005)(316002)(66446008)(64756008)(66556008)(66476007)(66946007)(68736007)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6476;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R5Yk5ieqM5o+z9LRbGpGvwknJWQzTctVNf2MuHLhi04WahhaxkYtBubIsuv3jc33x5cXeYed7AjrFnV5GWmI2oo6i7HMYL3jWIxAaVOMnaIUvb1cX5VG3DhoLVQ0f97zT3LtsZT6wyWgScCyMrwCIUOSur/zloeujT+fmbBUuG7Liw5r1DWYxQpYTTREKS/kYZ2Jgu9siSxp15v2b2Ng7KjS32C+UfQvIVwdWFnj9rM+IOeaX2XmqlyJ3YDgnu7K2C1+u7t0SxTqCkmW0+J2Ay58dr5p5AZULi93ZHAGVga547Wl63+0EXOWd0lxl3oeQEw3hxJz8tw6K1ffA0CDE8c5j9o0MP//aMvjN7a0iuTU+jBNWREcN2oBFsrvuw98nXq81lRz6heRnF6Vbk4+TIZ7mgoL3lq6HryU5AN/0Rc=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9E9A24DB4B1AE044A927E004EA66E52F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea53efe-57fa-48b7-0fb9-08d70830af2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2019 07:55:48.8425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6476
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2019 9:50 AM, Stephen Rothwell wrote:
> Hi all,
>=20
> In commit
>=20
>    c93dfec10f1d ("net/mlx5e: Fix compilation error in TLS code")
>=20
> Fixes tag
>=20
>    Fixes: 90687e1a9a50 ("net/mlx5: Kconfig, Better organize compilation f=
lags")
>=20
> has these problem(s):
>=20
>    - Target SHA1 does not exist
>=20
> Did you mean
>=20
> Fixes: e2869fb2068b ("net/mlx5: Kconfig, Better organize compilation flag=
s")
>=20

Right.
Thank you Stephen!
How do you think we should handle this?

Tariq
