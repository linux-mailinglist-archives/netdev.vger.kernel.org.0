Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EDC7E39E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbfHAT4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:56:55 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:25762
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388600AbfHAT4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:56:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5mkT8fvyxWXhemCKfym6XnOQtbaD69nok21ixdSkZtttvLvvtiE8VqajrebxBrrBfNpM60j0PRYFaorjRuo59dOwyXXuz9TQG9o43tDAh2ybi6BX4MCA+UWefceqGmf3Y88HKIIMSnSguR6A2WIknSEbUtVTN61wEV1ivPwNVM1S6Tx5hBU1YxURFVt0joE+93Nuo1dvcnD1E7c3nlywsAzhtUIWALX4Gb0fU/aTI4XezHoP5/a0v2b4Boki0Am7qu2/+2H8/KqSCVUfm9DBPJD0H16kp24DN4mH0AkTsr0skCVV9l9q3OTcvsIp5FwduPdCQ0y0DvPjfeID900IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QVTX9ZM0T40xZDwUF916MyJSLYiLiPblFzZ4a5iKX0=;
 b=KYtfPffflFW8c2DsN2CiLKr+DU4lwkigUONrpJKcMyYPmYmyFM+DYybh5TdZgNb837/rwwN6ilRuCQvVmIm2L0aTUPtrBDN96uXwImEb72+Pefgf+i9VxboxBoIbIhEZr51NQ+ueqL8eZe6Dwz5UHg1AdiHxKevgMUgSfexVgWXUISwVcKRFkQxOsRZWO18jFvuW2cHZPymCApYrKr0MoYOkvb8gcJf0EvHNWSbVaaTPC/Rvb9IkgR4D6J4L0Fx0JeuCamaWrS1wupvjfElsayPDbUcLtTBhG3bMxc7SwcyqclVXr0p6z3nAgqonTwl+BYP7GLMh4y7jJ22UjeNJKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QVTX9ZM0T40xZDwUF916MyJSLYiLiPblFzZ4a5iKX0=;
 b=DAQrFdS9WzK+VXO5lDt19gOBBzamGMnv+4unfdKEP7ATIbyNUpJAaarDwTdMQekxx91Tcax7K6tTbdrtlhGVVqSxCf3m6XsxEFPcuKY66vPjlt1x0HR2072ZSsjc8RaXw0fbyy2xje3eIr42QtA/Kat+zpYwSaHdQ2cBNoMN3I8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:56:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:56:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/12] Mellanox, mlx5 updates 2019-08-01
Thread-Topic: [pull request][net-next 00/12] Mellanox, mlx5 updates 2019-08-01
Thread-Index: AQHVSKNCbhFiPLqbN0WurYuEiWfqww==
Date:   Thu, 1 Aug 2019 19:56:50 +0000
Message-ID: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab11cb02-1119-4493-a5c1-08d716ba648c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB275901CC01294EA64D77E955BEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(15650500001)(14454004)(53936002)(316002)(7736002)(6486002)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pDx4zqlCS281HGFaafW8G/L8uTG0f84peGdA39S8LF3eoslYvbIOQc/t4HbaNhXlyo210XojpkuuTz2XLtTpjDZe8cFGxDzabfnYjbkof8C3RAifDNGIXB9z9RQn1QB7ht3e4yJGgs0dU0bCp+WlxqVDQNe5x+n/yPTEcgTYAINUuMIoHzmkcmPceLkWGaU3Vtnz/DbsujMExMpp1H9xVou9YiwkEPgbyJVU9U+ePCyhKSd31aLKgrjflW1H/JX7MUaQMVq2zg7u+QT5gaTl7l2c/Qy0pobWVasDxU6saVRZpwGxE6IY0Xav9lGb1hlzLc8B6IAsEf9udrnTKlxzjYdceSGUW5JJnCnenwYiC4VdXNeb8hIddG0SGPDmiFdtRMlOUAuLhOONBKZ6kJpUX1txQv+qN/ULKtjr17V18eo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab11cb02-1119-4493-a5c1-08d716ba648c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:56:50.4521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Thanks,
Saeed.

---
The following changes since commit 68e18626dfe971df3856872ee58f63c389dea2f5=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-08-01 12:33:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-01

for you to fetch changes up to 6830b468259b45e3b73070474b8cec9388aa8c11:

  net/mlx5e: Allow dropping specific tunnel packets (2019-08-01 12:33:33 -0=
700)

----------------------------------------------------------------
mlx5-updates-2019-08-01

Misc updates for mlx5 netdev driver:

1) Ingress rate support for E-Switch vports from Eli.
2) Gavi introduces flow counters bulk allocation and pool,
   To improve the performance of flow counter acquisition.
3) From Tariq, micro improvements for tx path
4) From Shay, small improvement for XDP TX MPWQE inline flow.
5) Aya provides some cleanups for tx devlink health reporters.
6) Saeed, refactor checksum handling into a single function.
7) Tonghao, allows dropping specific tunnel packets.

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix mlx5e_tx_reporter_create return value
      net/mlx5e: Set tx reporter only on successful creation
      net/mlx5e: TX reporter cleanup

Eli Cohen (1):
      net/mlx5: E-Switch, add ingress rate support

Gavi Teitz (2):
      net/mlx5: Add flow counter bulk infrastructure
      net/mlx5: Add flow counter pool

Saeed Mahameed (1):
      net/mlx5e: Rx, checksum handling refactoring

Shay Agroskin (1):
      net/mlx5e: XDP, Close TX MPWQE session when no room for inline packet=
 left

Tariq Toukan (3):
      net/mlx5e: Tx, Strict the room needed for SQ edge NOPs
      net/mlx5e: XDP, Slight enhancement for WQE fetch function
      net/mlx5e: Tx, Soften inline mode VLAN dependencies

Tonghao Zhang (1):
      net/mlx5e: Allow dropping specific tunnel packets

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/reporter.h  |   1 -
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  36 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  66 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  12 -
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  19 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 103 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  16 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  | 318 +++++++++++++++++=
++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   7 +-
 include/linux/mlx5/driver.h                        |  12 +
 22 files changed, 592 insertions(+), 103 deletions(-)
