Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4C758EC
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfGYUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:37 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:36366
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbfGYUgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cbm/rzBC/02z6gVBtoPAN2p9f/kEHZ188p44RLhvkqPzLqHQuoYiQB8lBpAA7/WWjY30IbFhGEhhF4H8M0VRZWZcV4uwGXr/vcxR0rmn4lTbAsi6eU50umnmvhKB639oTqSLhx6jLr2en0szCCrWednX/HWCvFkkXV4g4f6ZB0qYC18BpK4JDS9fiOzjxg/3UMnCisZgLSVOzX7G2akRYFk8AV1GcyvnsTYAweN6oAfjdpLeP4tGBoHfUTvmdLTlvCwzSlMmSc4ttnbw/towq0W28PjW3U5AFDYjGGsV178GGs+RcMxAEUOhVjzvcWEzCQLrCfXkPdEg2hSTnvG3Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uz+0KiTFXXRuKEibSkiAzRjrjqNkeIZ1ovB3JpfgE7U=;
 b=BXZjeDm2wtvqadiWHjHJOJHUmEzvNst5XOgOO1cevuwlcBEsjKTNVz/qhYqlXxcTrFT48hNpRnOezqY/CMIzf9ozsTIc9F/tfghwSxI3KN9amTNQ6OJ5i8ztg+6sT5g6LQ/0JhBgxeVYvwLk8TnYikMymiYV3+2mShvaz1bou9ZSkPsF7AHKFgbcWBqwEleggQHxElLYRa7PgX5/oOHDu8q1gPFQdW+yV7My/3hMN8x1fZDkxuPL5YbFvZjfcr4DwWVIYktheWlbB2Nr/ZI3gZSJvcv02kW3QRclB4bRv7sZOWiv/0S7Eji5fVHGXmJ0eyAFCOFc8uvXRXG2z6b+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uz+0KiTFXXRuKEibSkiAzRjrjqNkeIZ1ovB3JpfgE7U=;
 b=ZfUYbcOATFbmeRAg5am9IfGMxNVNZrS/jXuaqzH1wt+OcWja4/tF+vQAZQty0N91r8nuV+/1U/jnIRtFA+ExKDMDUg35SGNVtqS2pw6U5L417fI5jiorEUzGHtK6XOhWaJBl+LHhnHJWzS+bTrAk+/PJoUZGVttMOXby/alrxRA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/9] Mellanox, mlx5 fixes 2019-07-25
Thread-Topic: [pull request][net 0/9] Mellanox, mlx5 fixes 2019-07-25
Thread-Index: AQHVQyikw7OsDHmtw0CuOlQznTvVrQ==
Date:   Thu, 25 Jul 2019 20:36:32 +0000
Message-ID: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2844721-0962-4728-c92c-08d7113fc733
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB25047B52022CB913653FA7D2BEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C2/5MaSrDP8Zmoxm1qCpvIjCF1rEYF1vpg0M2NI9OQIiDzuTW16nLFRyrT/UexZauZiliybS/1s/98/dKfQpZD0/ZbTDDuezg3D2NgQt+GvOkUCwmy5H/2UVQ9Mwh4L+744nma163VVmX7qaF+U3HpOYJ0QBNoTS0ZFdS/eQDYsnjG96Hai16BK1lxQgzTs4L2XQ5QjDI4nro7WyCsh8AnsI5srmBQLPweQtORaJ1SMTFbIQB9CtHA+UAM8vAgpau+9JoM0jZaIQgbc4+9ea20t1VqynjOG4RyL73KUM4OF2J/eDiy0e0qcMEBYlqEFFZq9gM2d7/lWB0ASfFH+i44rZD25DKJVG2/QDj/JdajWEX7tRUc4bhVY8QX3ycWe+4qLyZGQ4hPwALqjUitTHpmWWp6oAJGEhH3mIBH/PVb0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2844721-0962-4728-c92c-08d7113fc733
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:32.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

1) Ariel is addressing an issue with enacp flow counter race condition
2) Aya fixes ethtool speed handling
3) Edward fixes modify_cq hw bits alignment=20
4) Maor fixes RDMA_RX capabilities handling
5) Mark reverses unregister devices order to address an issue with LAG
6) From Tariq,
  - wrong max num channels indication regression
  - TLS counters naming and documentation as suggested by Jakub
  - kTLS, Call WARN_ONCE on netdev mismatch

There is one patch in this series that touches nfp driver to align
TLS statistics names with latest documentation, Jakub is CC'ed.

Please pull and let me know if there is any problem.

For -stable v4.9:
  ('net/mlx5: Use reversed order when unregister devices')

For -stable v4.20
  ('net/mlx5e: Prevent encap flow counter update async to user query')
  ('net/mlx5: Fix modify_cq_in alignment')

For -stable v5.1
  ('net/mlx5e: Fix matching of speed to PRM link modes')

For -stable v5.2
  ('net/mlx5: Add missing RDMA_RX capabilities')

Thanks,
Saeed.

---
The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b=
:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-07-25

for you to fetch changes up to 280c089916228a005af7f95c1716ea1fea1027b5:

  Documentation: TLS: fix stat counters description (2019-07-25 13:31:01 -0=
700)

----------------------------------------------------------------
mlx5-fixes-2019-07-25

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5e: Prevent encap flow counter update async to user query

Aya Levin (1):
      net/mlx5e: Fix matching of speed to PRM link modes

Edward Srouji (1):
      net/mlx5: Fix modify_cq_in alignment

Maor Gottlieb (1):
      net/mlx5: Add missing RDMA_RX capabilities

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Tariq Toukan (4):
      net/mlx5e: Fix wrong max num channels indication
      net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
      nfp: tls: rename tls packet counters
      Documentation: TLS: fix stat counters description

 Documentation/networking/tls-offload.rst           | 23 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 12 +---
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 27 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |  6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 69 +++++++++++++++---=
----
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 36 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  8 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  5 ++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  7 +--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  1 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  4 +-
 include/linux/mlx5/fs.h                            |  1 +
 include/linux/mlx5/mlx5_ifc.h                      |  6 +-
 20 files changed, 139 insertions(+), 89 deletions(-)
