Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56D05DF03
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfGCHj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:28 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:30325
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727008AbfGCHj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSVsRO57URHCioHYKVJSkGBiWHy5PYnBCzwEtcpDL2U=;
 b=PBMWs93XKoa2yzE+G3UOXuX8IuKDfL584qsog7TQetAQ7B1kbtHfkbWQ7bP5UtOJd4m1uQLO+NS/pQrs02w/k70xLntQtt/I1Qefj26GxvWVKepCdIAiVmFZUNoSitqZmjvNua2mezx8lWD50F3JeH9sQaFEOZraF0cB3ZrNNPo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2309.eurprd05.prod.outlook.com (10.168.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 07:39:24 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 07:39:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates 2019-07-02
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates
 2019-07-02
Thread-Index: AQHVMXJveOPdXjGEB0qnqkH/hqttvA==
Date:   Wed, 3 Jul 2019 07:39:24 +0000
Message-ID: <20190703073909.14965-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 766e3f5a-173a-4864-fc7d-08d6ff89919e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2309;
x-ms-traffictypediagnostic: DB6PR0501MB2309:
x-microsoft-antispam-prvs: <DB6PR0501MB23093CF5D86497B9AAC21ACFBEFB0@DB6PR0501MB2309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(53754006)(66556008)(66946007)(66446008)(6512007)(64756008)(73956011)(66476007)(5660300002)(1076003)(52116002)(54906003)(71200400001)(2906002)(15650500001)(66066001)(256004)(99286004)(14444005)(3846002)(7736002)(6116002)(53936002)(6436002)(71190400001)(4326008)(6486002)(68736007)(81156014)(110136005)(305945005)(26005)(36756003)(316002)(2616005)(50226002)(8676002)(478600001)(476003)(8936002)(25786009)(86362001)(486006)(450100002)(386003)(6506007)(81166006)(186003)(14454004)(6636002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2309;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fRy8cJ5eQoFpmoXlzqph0aYs5bBcEEHhcBy6XptMV3DUWlEaXpDrpyYuHppRUoxNTNGRm2wCUCW6mhfDo0ih1BKiNFPK7BPbqxtrfhp/e88LoT+WVNIfVuHXqDXTywyr+fV/WVav2mItAagzj45w0gfJwl+DKA0EYla+K0u1yS2ccAiOkvEP01E2IwZ5gILHy2SmIue6i1sCRGGYjdHcSTKWX0CtDjqzDoDEhPy0EbRcqgNjeKy83JYMS2iZ7u5SN0yXx8Ag8e/I7yG4dI4uB/kq3TvsgG9mDu+lnZRq6KVdefl8NlJaAjX+2PiRX6AdOtIs1ISgqX4ZY3RbIK1jVguhA279H//2UUmJJWmN9T3pu+3LOkkqz7+7aExaQTQ0U71at02oYJqWIOJb/0V6wOy9+OOdl5xmqhtsp4SwWPM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766e3f5a-173a-4864-fc7d-08d6ff89919e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 07:39:24.2795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series includes some low level updates to mlx5 driver, required for
shared mlx5-next branch.

Tariq extends the WQE control fields names.
Eran adds the required HW definitions and structures for upcoming TLS
support.
Parav improves and refactors the E-Switch "function changed" handler.

In case of no objections these patches will be applied to mlx5-next and
will be sent later as pull request to both rdma-next and net-next trees.

Thanks,
Saeed.

---

Eran Ben Elisha (1):
  net/mlx5: Introduce TLS TX offload hardware bits and structures

Parav Pandit (3):
  net/mlx5: Introduce and use mlx5_eswitch_get_total_vports()
  net/mlx5: E-Switch prepare functions change handler to be modular
  net/mlx5: Refactor mlx5_esw_query_functions for modularity

Tariq Toukan (1):
  net/mlx5: Properly name the generic WQE control field

 drivers/infiniband/hw/mlx5/ib_rep.c           |   2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  42 +++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   7 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  46 +++++---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  26 +++--
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  15 ++-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  15 +++
 include/linux/mlx5/device.h                   |  14 +++
 include/linux/mlx5/driver.h                   |   9 +-
 include/linux/mlx5/eswitch.h                  |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 104 +++++++++++++++++-
 include/linux/mlx5/qp.h                       |   7 +-
 include/linux/mlx5/vport.h                    |   3 -
 13 files changed, 232 insertions(+), 61 deletions(-)

--=20
2.21.0

