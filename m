Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE0A14907C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgAXVyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:54:53 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:49114
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgAXVyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:54:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dppLM/zKDb7Z/A7vilY8NO5S7ZFKydUp0fRzErLUPe2fWCkmJV7sJYbjCeWY1dFLAEAth9u97fUaLA6yf/pyYDj8tE+B+McZqKXZ2V9aNLwlVmiS/CH8RkM71Kcnl1C9mSRwm/U5ycaFncNYhDnt46zVustoNbxaYR9FuV64qt+XEElGeOsm6ky9emoQbqtyFIDOHVNvBL0pr8jaaKYRew9ygl9x2RbzDHw9Ude4Nlp363Cml5d959Cx1E4rz4ktMOLsnLLgD7s6wQNCc0YWMb2oFVKSfzoDhq+VYCH997/RrGKunkjh5c79CMylZ48Re3QMko6jVku3vYd0AviqEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdRj3rWrSG81qSU2NT0+6D6s9m8kcTQ2dROSAY1q/JU=;
 b=BKjVrkzgkmvXTR9FZ7U2DGQnWN20NV9quICSVp42CccE+6zoTTbTgljDXzb+UPylBDf0BJpP3s/8taVYa1H7AZBczrr/osNGgLyhSUH9LkGHdQc128EjcBtz60UISMnv4Yc7YMIb4X9/aCFuOGVsBBQmZMbhTVzVUc+uVEzB9zY6BhtFN+Rj4GkMuDkvSV2FzuF/mcv2JdXjbIJUMYjf+YGbKa/VC6rXl//ct9TIc/Kph6GYGCwcQoGak22e+MZRLU49TZVyLhgDt8ESMfc0ZdpNEkeai7y1Qt1AaTXcgnZ7edVkG0LjK/+N1GcA5YTRMbbuJWyb8sazSUCoFlQ+ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdRj3rWrSG81qSU2NT0+6D6s9m8kcTQ2dROSAY1q/JU=;
 b=jjGM1PXUlI/Na2CnLz6PG+SLkpu9M/nb1wPkfTiJR9GZrkCxqz0uoeHheq50X25MiwL+nQiSILlAZiGGDYkaPmwGoEAG5gnlB9Od8Sm4qBY0fqhQ0nZjzwcmaTJpqDElNvZ8A7Bcg6wviGNpug/hgNiZ+7xR8g1TdK7u6ufRoyo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:54:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:54:49 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:54:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/14] Mellanox, mlx5 updates 2020-01-24
Thread-Topic: [pull request][net-next 00/14] Mellanox, mlx5 updates 2020-01-24
Thread-Index: AQHV0wDlg/u/9A/ce0S/DBPeRuzQAA==
Date:   Fri, 24 Jan 2020 21:54:48 +0000
Message-ID: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f402e6e7-61ba-4e4f-0161-08d7a1180813
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5456ABD4D13D98E9ADCA842BBE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(15650500001)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +JvgWldqfskiU/CADI5MMFhYqZGSQych6U9mPYsGxzjFjjULjyuyp8zfDKP5NMy+QjghjciQd64XkY4QBZS17Y9noxTYbJ3AIhl8RbrTZdkwOuBycK7Af5FwaiUNG5FNkfzwwhQP7OBkxVvkGA11wIMAfmSTSBZr/UxWfayXhtkO4knT4Q/I3MAKu0/Zph+hHeC+gKtTpYC9E5BxlYVBm3RBK7eOtLCsWpvobJYY7cxhvBJWCqC7IcqfGGh/OBy4YJ/lwpT36/tFVU3FlgKWbA5xBR/QxEWHqlM0YyGU+qoJTV9/yZ6uj3HC6nuoY6hr7QiKnpQOBtKpLyMFUhq0UOvcqRBUCT7KTbsRqCstRF4aqptqHtFkBjRi8n2LpOoMlBcSaIay07eiv8+fZSPbJZgZ+BEmSglUHuHqwOzYdUAMp244l0YN3C0Hq1dgep74W5VnTdyF8PdlZLvQ5FZFVJu7idHMdeZkpl2M2qyfllwgzSabQtZLZvN2t6jjBLBe33NDcaJyF+R1qQ7kky4dyoTbXpOM8kUq/NX8fOwd9QU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f402e6e7-61ba-4e4f-0161-08d7a1180813
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:54:49.0890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+6QlrjdhL3arEx1eXFd57CGNxnfUnI4+UGAd730fBwozwvFWJff+/KRRNuKNIfIAkWOa5BNB8apAbBJ0JtKog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds some updates to mlx5 driver
1) Devlink health dump support for both rx and tx health reporters.
2) FEC modes supports.
3) misc small patches.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Note about non-mlx5 change:
For the FEC link modes support, Aya added the define for
low latency Reed Solomon FEC as LLRS, in: include/uapi/linux/ethtool.h

Thanks,
Saeed.

---
The following changes since commit e445332491ad62fc2da29f9e88bd1548295bab9c=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2020-01-24 13:41:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-01-24

for you to fetch changes up to c80672aa66ca56b860ae831b0e095222d6991e47:

  net/mlx5: Fix lowest FDB pool size (2020-01-24 13:41:36 -0800)

----------------------------------------------------------------
mlx5-updates-2020-01-24

This series adds two moderate updates and some misc small patches to
mlx5 driver.

1) From Aya, Add the missing devlink health dump callbacks support for
both rx and tx health reporters.

First patch of the series is extending devlink API to set binary fmsg
data.

All others patches in the series are adding the mlx5 devlink health
callbacks support and the needed FW commands.

2) Also from Aya, Support for FEC modes based on 50G per lane links.
Part of this series, Aya adds one missing link mode define "FEC_LLRS"
to include/uapi/linux/ethtool.h.

3) Erez handles the reformat capability in SW steerig

4) From Joe, Use proper logging and tracing line terminations

5) Paul, Fix lowest FDB pool size, which got lost due to code re-placement
in net-next.

----------------------------------------------------------------
Aya Levin (11):
      devlink: Force enclosing array on binary fmsg data
      net/mlx5: Add support for resource dump
      net/mlx5e: Gather reporters APIs together
      net/mlx5e: Support dump callback in TX reporter
      net/mlx5e: Support dump callback in RX reporter
      net/mlx5e: Set FEC to auto when configured mode is not supported
      net/mlx5e: Enforce setting of a single FEC mode
      net/mlx5e: Advertise globaly supported FEC modes
      net/mlxe5: Separate between FEC and current speed
      ethtool: Add support for low latency RS FEC
      net/mlx5e: Add support for FEC modes based on 50G per lane links

Erez Shitrit (1):
      net/mlx5: DR, Handle reformat capability over sw-steering tables

Joe Perches (1):
      mlx5: Use proper logging and tracing line terminations

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    | 286 +++++++++++++++++=
++++
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.h    |  58 +++++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 107 +++++++-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 253 ++++++++++-------=
-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   8 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 266 ++++++++++++++++-=
--
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 181 ++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  71 ++---
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   9 +-
 drivers/net/phy/phy-core.c                         |   2 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/net/devlink.h                              |   5 +
 include/uapi/linux/ethtool.h                       |   4 +-
 net/core/devlink.c                                 |  94 ++++++-
 net/ethtool/common.c                               |   1 +
 net/ethtool/linkmodes.c                            |   1 +
 20 files changed, 1144 insertions(+), 227 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
