Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A3FECA95
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfKAV7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:01 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:1441
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbfKAV7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mwpie97FKNngvqfCv/dQZOfdekpno5ZIjEmfBDiLPXQe//QiXXkNRNhsD9tsuCXNhddeDrkXcrwiOJWcproUHV7IYtdBlOVaeLTTKuh6vYP85oQbMp8dLqy17/c1/4JJ43Uel56NaeACBDtSKc8FQaTmYmhtgbaaDCn+0XBhBPgiCJ1Y1C5zyFYtqydc4CMMD9gJnkz3gobWs5uzyHy3EZl1s19G6wswS7DutaNweLVpPbuQJnx1NX1pRq8Fezt/1MzUJeLqUOdYaUwM9afPg2iiRYkDKBCN1f8TShUOinX7+OMx/Uhi3NWbhwA+OTMbecfSv+YVTCZUKYRiWATnuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Z2JQUjx6EYfCK5tVtbzgHhvuG3pDLAErb443EPzlEI=;
 b=JKW7vI9IHHda9FTzUn0/ldtNkrRBXOGIPWiGvFj5OugwIbfyWXZZJP3PeTdEVQMEUw1rSFGDNIxelE/T4Oex0JozYv7HTJ+PwHJb4XUaa7Atp6WREUfyBH4HIWEfUJwblV0taoiF4AHnYcZFaGG+LCh4RYlTHQ72cWHDcfN6KBWJ9bgF2qtahpTEYxnevtJONtOiVngY46meEQS4WGu18+8DVpSYa/olvEqv8IAQym1uj1VdBHqkNCqGinbq3rUHPLnYH0ei4C0c934wtFd566LiqsfJ710pL7G6Xk6S+vfidLiPK7o6ZernGuqP0m04kc9CJepVs9gywNwRlFEWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Z2JQUjx6EYfCK5tVtbzgHhvuG3pDLAErb443EPzlEI=;
 b=BtLCvOZnuIXtA51tj5Nn8FjNKyTC+KNEaE/rw+5LPaoxMX35b+8bd3AN4NZqCQbP/O5qFfCmppqquq/hMAh2z8mGdxaCa3EHi7RIuULpG/1FrKq6aqTgrlPNy6uoCS0pcKj28M5nOfLi8WFHVKUgEIHNkylY3+KZCpmdni9QEb8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3293.eurprd05.prod.outlook.com (10.175.244.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Fri, 1 Nov 2019 21:58:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:58:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] Mellanox, mlx5 updates 2019-11-01
Thread-Topic: [pull request][net-next 00/15] Mellanox, mlx5 updates 2019-11-01
Thread-Index: AQHVkP+Olfjprjcte0SapLfaUlQxdQ==
Date:   Fri, 1 Nov 2019 21:58:55 +0000
Message-ID: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ace21f4-2054-4d95-34d1-08d75f16b090
x-ms-traffictypediagnostic: VI1PR05MB3293:|VI1PR05MB3293:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB329371235679D79EAA7F50E8BE620@VI1PR05MB3293.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(15650500001)(4326008)(66066001)(6116002)(3846002)(71190400001)(256004)(99286004)(107886003)(54906003)(14454004)(6512007)(478600001)(14444005)(316002)(71200400001)(4001150100001)(6506007)(1076003)(52116002)(36756003)(386003)(2906002)(66946007)(66556008)(6436002)(50226002)(7736002)(6486002)(66476007)(6916009)(305945005)(186003)(64756008)(81156014)(81166006)(486006)(8676002)(25786009)(476003)(2616005)(5660300002)(26005)(86362001)(102836004)(66446008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3293;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R6Genqx2/yuuM1ymwojJ41sQRsOzm2j1L6J2KKZP7jIrShGZ+HzuwvAP+MWm7cy2QSQdEik0Ols488mPDfiApCat5dz4kluMtu1dP0Q5MqJCEvitxxZhZ9KUvaanfudwAGWcDtc/0uNrNVNLNlJCPfY7OxsXa0gH45iIyFTp0g+4uCzyWeOphKh1r3VXmWbuNi7eaTtVtzGYz94w4FkRrshgU/4gZD+v8t4kWzDdi2nvPUW5Lb1JDEDtsO96sTL7T+Gi5oJi8eJrRh+LizqrcWt+U/c0nQThdZtggvcpz5TVpSBVht9r/Lhm2K5nXBVQBHanXX6x92GKn7k0XQj0ejdNF/rmGUQYC3TAtlM+kxwlYt1OXHwJlb+cXEkOiB+liOMQitdaXjL/bRmqpIuT4/bL9ovNRVJwdc7iZJQ88o5/UvsUH/ollm9sVwvNM7wJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ace21f4-2054-4d95-34d1-08d75f16b090
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:58:55.4643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dEUH6kMTugSZwIPfa/RLzZR3GfDxJvZp/SKkV48JV8n3UkhFZThiXHh4l2/Bn39+J3hDqBUGrXJsRRbF27G6gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 core and netdev driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 52340b82cf1a9c8d466b6e36a0881bc44174b969=
:

  hp100: Move 100BaseVG AnyLAN driver to staging (2019-10-31 14:49:52 -0700=
)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-11-01

for you to fetch changes up to 667f264676c7f83f57a7695010f889d6fd36dcbf:

  net/mlx5: DR, Support IPv4 and IPv6 mixed matcher (2019-11-01 14:55:18 -0=
700)

----------------------------------------------------------------
mlx5-updates-2019-11-01

Misc updates for mlx5 netdev and core driver

1) Steering Core: Replace CRC32 internal implementation with standard
   kernel lib.
2) Steering Core: Support IPv4 and IPv6 mixed matcher.
3) Steering Core: Lockless FTE read lookups
4) TC: Bit sized fields rewrite support.
5) FPGA: Standalone FPGA support.
6) SRIOV: Reset VF parameters configurations on SRIOV disable.
7) netdev: Dump WQs wqe descriptors on CQE with error events.
8) MISC Cleanups.

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Support IPv4 and IPv6 mixed matcher

Aya Levin (1):
      net/mlx5: Clear VF's configuration on disabling SRIOV

Dmytro Linkin (2):
      net/mlx5e: Bit sized fields rewrite support
      net/mlx5e: Add ToS (DSCP) header rewrite support

Erez Alfasi (2):
      net/mlx5: LAG, Use port enumerators
      net/mlx5: LAG, Use affinity type enumerators

Hamdan Igbaria (1):
      net/mlx5: DR, Replace CRC32 implementation to use kernel lib

Igor Leshenko (1):
      net/mlx5: FPGA, support network cards with standalone FPGA

Li RongQing (1):
      net/mlx5: rate limit alloc_ent error messages

Parav Pandit (2):
      net/mlx5: Do not hold group lock while allocating FTE in software
      net/mlx5: Support lockless FTE read lookups

Saeed Mahameed (1):
      net/mlx5e: TX, Dump WQs wqe descriptors on CQE with error events

Tariq Toukan (1):
      net/mlx5: WQ, Move short getters into header file

Vlad Buslov (1):
      net/mlx5e: Verify that rule has at least one fwd/drop action

zhong jiang (1):
      net/mlx5: Remove unneeded variable in mlx5_unload_one

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 129 +++++++++++------=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.h |  10 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/core.c    |  61 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  89 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  65 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  69 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  10 +-
 .../mellanox/mlx5/core/steering/dr_crc32.c         |  98 ----------------
 .../mellanox/mlx5/core/steering/dr_domain.c        |   3 -
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  65 ++++++-----
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  13 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  10 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  20 ++--
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |  38 +++---
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |  25 +++-
 25 files changed, 393 insertions(+), 359 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc=
32.c
