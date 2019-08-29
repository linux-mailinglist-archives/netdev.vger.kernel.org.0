Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A23A2B14
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfH2Xmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:42:33 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7907
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbfH2Xmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:42:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBYLpIVxBHPzyg7WjrfeH4n1xXtd4kOARjayxOeh7y81mT8qZ2xQvQd3WLZGLo71jw12a9Jr0SedHxwy4VmgLHYksY7LDbRhCvHWlIuavC8q0C2U5jEmPFMyRfWsKJRqmjgNQLEM+rITQBBP1aAlEyd9ZsE8k9IinoJ5VAduvnKPSTHocxX1OD8ujpAm4cqIqhTer0bSKL6VmognyuuVmmsgHgz7hUrQ4T4jy8i2rL4sPk83rwwYqhBTqqQIsaf3W15C6G86tue0iaW8MBaWKdmEHUF1zrrfetUtx+rALxgt7h1ZBnNR23rpjEGyxbzksWqHWoem5QogBns+yZjvmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLSH0Bw29VnSwNOr7/K66wJuGRDxjr3joqnFbamSS/0=;
 b=VNWwPUtdFJLH6tdRQQXYUuxZz46QvK34xZ2pYRyKJN3vW6J/ba4acK7h3eks/1/2dSnivbZEad16onsvfZUF7+ivnXuS4a0BeYOJRtfNnbrABUnuuVFLELIgSnqoZGDJPamPaPVFP7E9hZROSAxcpFO7tRuR7rnoOAUpyxbf4FaUSZLE13Cdl5XTGzomoF9rcjO2ZuM30xM/v6RDI0UubEtrLoY6P6vaZzHBbWJMvevKCx2DlGzwtuPIg+/oGD+3vCVxyL3G9SB3TBkcMg8Tvr1/vk+8JEmhZkPC8iFdKN4qIWSrqLfz1IG2UGdA/KipvVyvBgCVU2NfGfsYsDKOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLSH0Bw29VnSwNOr7/K66wJuGRDxjr3joqnFbamSS/0=;
 b=QnYlafVCbMzYcJbMFRe7kqZEwHXGH+NYmabp79msIlybkmz+nybAnMLZhUfnLni+ZelI7uWEe1xTWXpyLvhz1cpW+dfhZkVeoRAmtP4o6ABnLJXVB5qq97FIe3zn+U1HSPqz/tHjrW5sHuQAbLroWYPz9DCr92EYfpSgYkblnlI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2333.eurprd05.prod.outlook.com (10.169.135.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 23:42:28 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:42:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 0/5] Mellanox, mlx5 next updates 2019-09-29
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 next updates 2019-09-29
Thread-Index: AQHVXsNqTpgpI39FF0GNuR1TlVUVtA==
Date:   Thu, 29 Aug 2019 23:42:27 +0000
Message-ID: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7d06c3a-e5d3-4e70-9335-08d72cda8cf1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2333;
x-ms-traffictypediagnostic: VI1PR0501MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2333C910469EC41E9BB33AD4BEA20@VI1PR0501MB2333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(53754006)(476003)(486006)(450100002)(4326008)(478600001)(2906002)(81156014)(6636002)(110136005)(71200400001)(36756003)(54906003)(71190400001)(305945005)(8676002)(81166006)(7736002)(14444005)(8936002)(5660300002)(50226002)(256004)(2616005)(64756008)(66446008)(186003)(15650500001)(66946007)(14454004)(6116002)(3846002)(316002)(1076003)(6512007)(6486002)(53936002)(6506007)(102836004)(6436002)(386003)(25786009)(99286004)(52116002)(86362001)(26005)(66066001)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2333;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mN+/Si0zkf2XvL38Fd+Qg1nmN6qqXUffLb038m9gZviO3fiCKFswzoaWyYZevI7Dd2+GEKUKyAtn4SvnosJa+x69so5FheGWdWgu/VI2D+JHPoIKdio2Is7B3EVAlQ+d/mdW97PbznekzfAXvKI2CjkBXQ6UK1Odvbbit0uJOv5whvKT4dkjPgNM5lAaXa4K49mp7oiwCgLC6ChXOUnc9e/jrR0iZdjuFH16Mu50xK1KV9Z7ojtgYSVcOzoRmL6I+QGCjaNV68bBj9wpjvY9i93umlblLZJnCGCVK6khzo5W+dsJyOCQkObKsQz2klnxdrnTP9+fIHox1NNjX9HTJyapYxyCLfr5suu/8COG+M0JWpN2NB9DiBEz7CFU6eDOMskWM3E/EMaTvFrVQQqNmkw5agPa/50Nw4/4JKGLYKk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7d06c3a-e5d3-4e70-9335-08d72cda8cf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:42:28.0666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 15mkhmViNeZTAXndXq2I7XsNP7qARBId6AdQ5wJ84QZ2P4B9wROSsYcwQx52MJ4ol/gIqGzeBdVeD0nlbxyb8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series includes misc updates for mlx5-next shared branch required
for upcoming software steering feature.

1) Alex adds HW bits and definitions required for SW steering
2) Ariel moves device memory management to mlx5_core (From mlx5_ib)
3) Maor, Cleanups and fixups for eswitch mode and RoCE
4) Mar, Set only stag for match untagged packets

In case of no objection this series will be applied to mlx5-next branch
and sent later as pull request to both rdma-next and net-next branches.

Thanks,
Saeed.

---

Alex Vesker (1):
  net/mlx5: Add HW bits and definitions required for SW steering

Ariel Levkovich (1):
  net/mlx5: Move device memory management to mlx5_core

Maor Gottlieb (2):
  net/mlx5: Avoid disabling RoCE when uninitialized
  net/mlx5: Add stub for mlx5_eswitch_mode

Mark Bloch (1):
  net/mlx5: Set only stag for match untagged packets

 drivers/infiniband/hw/mlx5/cmd.c              | 130 ----------
 drivers/infiniband/hw/mlx5/cmd.h              |   4 -
 drivers/infiniband/hw/mlx5/main.c             | 102 +++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   2 -
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  | 223 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |   5 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 +
 .../net/ethernet/mellanox/mlx5/core/rdma.c    |   8 +-
 include/linux/mlx5/device.h                   |   7 +
 include/linux/mlx5/driver.h                   |  14 ++
 include/linux/mlx5/eswitch.h                  |   8 +-
 include/linux/mlx5/mlx5_ifc.h                 | 235 +++++++++++++++---
 14 files changed, 497 insertions(+), 251 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c

--=20
2.21.0

