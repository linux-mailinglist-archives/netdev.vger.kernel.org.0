Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1EF5D8CE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGCA3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:29:45 -0400
Received: from mail-eopbgr130044.outbound.protection.outlook.com ([40.107.13.44]:61870
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727072AbfGCA3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyNi6uRb4qnSuaPCrOYFylRJUSBSGet8lzFevdC2Vko=;
 b=W4PSX+9nkHKEL2HClLGYOySPP49+uPTyUlhgRCVwI6Gf6IvlEhiUyzOJVxuAwCe1ipFQADa4tEstFNXqUHfAkqTRO7oN+ZyyhoxjruNDFRIL1od7Qqsvkuc7DSr4a7vdxFtM0IxYk0LKQFfx6MptvfQs3GdK98UkK92miOysRe0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2565.eurprd05.prod.outlook.com (10.168.74.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 23:55:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 23:55:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
Thread-Topic: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
Thread-Index: AQHVMTGTjEFCcBORvUCw+WfJHjxy9g==
Date:   Tue, 2 Jul 2019 23:55:07 +0000
Message-ID: <20190702235442.1925-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:74::40) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9ef2530-0642-4fef-dd8a-08d6ff48b5ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2565;
x-ms-traffictypediagnostic: DB6PR0501MB2565:
x-microsoft-antispam-prvs: <DB6PR0501MB2565E44E0A56CC77C8DAA699BEF80@DB6PR0501MB2565.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(199004)(189003)(386003)(99286004)(66066001)(52116002)(6916009)(6506007)(1076003)(81166006)(8676002)(478600001)(50226002)(3846002)(81156014)(71190400001)(71200400001)(305945005)(6116002)(68736007)(36756003)(14444005)(14454004)(6486002)(66476007)(107886003)(6512007)(4744005)(6436002)(86362001)(53936002)(7736002)(66556008)(66446008)(64756008)(73956011)(5660300002)(4326008)(2906002)(25786009)(66946007)(2616005)(54906003)(486006)(26005)(102836004)(186003)(476003)(256004)(316002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2565;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R5q0wYb9Q5pDGEF/zVCuX6jcogcfADrztxeP914y0rPLkJfk+zh2oNoJJ3ya85D6Ty0jMLyZyMl27JJgZWb9NyD8YXzoBnLBpp6ksTmxDiPwLjJ404J1vafFgy1w4IiPfZVoxMuKaUSG5e3zrGHTE3EzHi90NV/WY6C3WTGuB9K9+4B/VEGIS2NrFJTUXVJL5Fkuxh0yNtKV7/TUUXYEz74fEArckzZs+Tzq3a33TngfiDVa2gKnlwihEJ+w20bIKO+uIwBzZObOniDU9GoahKwCC4Z5zKiyfKlnOVEwylZjUG4GENlCLPmFiFwGMAMz6aTovSsA+Zxbi/Ed3aLhCC+NBtjw9/N1j/HB5beAciEkP305Duc+PL/xkP/ely8jKid8vUGAmoV10yMjh00yDWaeEz/EmnPGdBp1Wyou6rE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ef2530-0642-4fef-dd8a-08d6ff48b5ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 23:55:07.9992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This humble 2 patch series from Shay adds the support for devlink fw
versions query to mlx5 driver.

In the first patch we implement the needed fw commands to support this
feature.
In the 2nd patch we implement the devlink callbacks themselves.

I am not sending this as a pull request since i am not sure when my next
pull request is going to be ready, and these two patches are straight
forward net-next patches.

Thanks,
Saeed.

---

Shay Agroskin (2):
  net/mlx5: Added fw version query command
  net/mlx5: Added devlink info callback

 .../device_drivers/mellanox/mlx5.rst          |  19 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  60 +++++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  | 219 ++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 4 files changed, 280 insertions(+), 20 deletions(-)

--=20
2.21.0

