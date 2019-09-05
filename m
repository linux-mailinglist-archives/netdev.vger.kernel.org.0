Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C37AAE06
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbfIEVu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:50:57 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:28743
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728769AbfIEVu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:50:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fb4JFLLmsazpgB94M+nAgRxwa2kfd+enixs6X5tcGVmBfP5hrQzxCtjNFt3S9x0+w4sfElROlJWLI0up9WCYuJjIHoh4emiH1YEekkbVE6h+RkTKgBmmV3jD57wkk5PUWAFB0Y0yuG2VE6m0ljEQ6ZPW39mAG+GqtKYj8vOyAE96c84A0eSZRv/VR1Q6ue8sbeWEJbIiDoEvZId8o4cGxB+EF0Td+SegDpi33cPAPw4J9/9I4nRAAWb1EZ/unaQv6fBzFXS9c1Ya3bLz0TBCyLY3mNBIqkbzDI6q5uyzdaRGtVNTqR0ew46T1hS2GmtZfUIgetpCIzwOoPrOXOAhEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1lopIy63iQqgh+yeBJ42jvNuywW7vFc/UuoaoWODVU=;
 b=lQM7vZCooNcRLraYslONdpW74J7sVxoIdMYCD+GXGdKh5GYuby13K86+QUq19uxIqqDGOSV/yDaS202asQJDFVM1d6HXKDfOizFLYEdPpTg/0JjrTOcuislgBa32WTpDnGSBkWiaOKpzIuAXxPoGk6wIwJ2pZ2Cx6AZtc6DbB05RnrycL86w9Lb99mqSPMHB1ER410j4Vy8aAFR+/rLSrpErVW+/m9NyeNAqLsqMsfNJWHw6B126nIiP4j1hfsuOEXNmWxB1l7EhkJsidHZ5DCQWNMqZateZpQVDkBr9b/iDCGxeLQfkUp8/N4ICfyN7T6PmYj0sf6tGtyle7fjJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1lopIy63iQqgh+yeBJ42jvNuywW7vFc/UuoaoWODVU=;
 b=RYo6tQ0mgnWt4Vw2FR0b6b1jVTVna2XYFtoYWSXG01HsHvH8WJwSviWQe9xs2K5RoECJDNVLazh7EiZkyaKQRln4pYOPG32XDbP69JhG5gfqQdIgoV2nDQ+2giNGp4a8Dx1t9RfkWQPIAAyDFLXENkRHHEFNTdd08npeEbOYiyU=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2191.eurprd05.prod.outlook.com (10.169.134.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Thu, 5 Sep 2019 21:50:52 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:50:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/14] Mellanox, mlx5 cleanups & port
 congestion stats
Thread-Topic: [pull request][net-next 00/14] Mellanox, mlx5 cleanups & port
 congestion stats
Thread-Index: AQHVZDP8kFh0NdzpVEigyri4/hfonQ==
Date:   Thu, 5 Sep 2019 21:50:52 +0000
Message-ID: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d787ce20-6334-47be-6e10-08d7324b1f3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2191;
x-ms-traffictypediagnostic: VI1PR0501MB2191:|VI1PR0501MB2191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB21911C73DF4A83ABE88E6017BEBB0@VI1PR0501MB2191.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(54906003)(316002)(2906002)(256004)(8936002)(14444005)(8676002)(6486002)(305945005)(99286004)(7736002)(5660300002)(81156014)(81166006)(50226002)(1076003)(478600001)(6512007)(26005)(25786009)(36756003)(86362001)(4326008)(14454004)(6436002)(53936002)(102836004)(486006)(6506007)(386003)(66066001)(2616005)(476003)(186003)(107886003)(71190400001)(6916009)(71200400001)(52116002)(6116002)(66446008)(64756008)(66556008)(66476007)(66946007)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2191;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WY+cqQMfyTT/VB+ErcelNegQVDpi1aHhYY5KfG7f8GTB5Pb7/LbEhX4quXNtZTq89A1n3cPBgdeHPq+Jg3r/bAjgO3qVk8wHU1PrLfgzvYCpInw03aZm1CHErkjFSkGP6wzNqJbkfKHSjm1BoZIOtuet0We2LjgPx6BrBHANYUt7zKt7K2n3fXoIH5gUfYrNFLdi0RdxcNKOA5LhxMxMytKvv0PnlbxcNNk/JpkJtQNJ8TbNYtUiNQvrt3DxVUCZd9fELniGeriDB8hkPcejqNRmob2HQewlJ08QcD2Aut6cWTvzkbYmQxhLxk7vaY8qEBiuFXMTcv4f5krshaQi71VaBD1K0YcZFyCF7vTzSVbrMeWmgj1ycSulPvhJdgNZovofyDi2pOxelYWbohvCQ+HefIh/SI5ZSSJaR1CCbCU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d787ce20-6334-47be-6e10-08d7324b1f3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:50:52.8117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VuQ9X3k22WEUSdVWbKXRD3COB17lUcqCSFRcreKiICpVAUD+h3lHpKfSB2JPS1OEfCuQTH2E6a/BLZBjQE2TOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series provides 12 mlx5 cleanup patches and last 2 patches provide
port congestion stats to ethtool.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 0e5b36bc4c1fccfc18dd851d960781589c16dae8=
:

  r8152: adjust the settings of ups flags (2019-09-05 12:41:11 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-09-05

for you to fetch changes up to 1297d97f4862ad690d882ae5b0487e3d1ff15953:

  net/mlx5e: Add port buffer's congestion counters (2019-09-05 14:44:43 -07=
00)

----------------------------------------------------------------
mlx5-updates-2019-09-05

1) Allover mlx5 cleanups

2) Added port congestion counters to ethtool stats:

Add 3 counters per priority to ethtool using PPCNT:
  2.1) rx_prio[p]_buf_discard - the number of packets discarded by device
       due to lack of per host receive buffers
  2.2) rx_prio[p]_cong_discard - the number of packets discarded by device
       due to per host congestion
  2.3) rx_prio[p]_marked - the number of packets ECN marked by device due
       to per host congestion

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Expose HW capability bits for port buffer per priority cong=
estion counters
      net/mlx5e: Add port buffer's congestion counters

Colin Ian King (2):
      net/mlx5: fix spelling mistake "offlaods" -> "offloads"
      net/mlx5: fix missing assignment of variable err

Eran Ben Elisha (1):
      net/mlx5e: Fix static checker warning of potential pointer math issue

Mao Wenan (1):
      net/mlx5: Kconfig: Fix MLX5_CORE dependency with PCI_HYPERV_INTERFACE

Maxim Mikityanskiy (1):
      net/mlx5e: Remove unnecessary clear_bit()s

Roi Dayan (1):
      net/mlx5e: Remove leftover declaration

Saeed Mahameed (2):
      net/mlx5e: Use ipv6_stub to avoid dependency with ipv6 being a module
      net/mlx5: DR, Remove redundant dev_name print from err log

Tariq Toukan (1):
      net/mlx5e: kTLS, Remove unused function parameter

Wei Yongjun (2):
      net/mlx5: DR, Remove useless set memory to zero use memset()
      net/mlx5: DR, Fix error return code in dr_domain_init_resources()

zhong jiang (1):
      net/mlx5: Use PTR_ERR_OR_ZERO rather than its implementation

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   9 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  23 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 149 +++++++++++++++++=
+++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  18 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   1 -
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |  29 +++-
 15 files changed, 207 insertions(+), 47 deletions(-)
