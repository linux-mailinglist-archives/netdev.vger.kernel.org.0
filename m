Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C51A5FCC0
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfGDSPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:15:47 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:28482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbfGDSPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iqs94YWyG1pbOyc5eMLsHZmxLjEj/G52G4yyiRU85lI=;
 b=WdAUND9mwP4qnLJcsOpVzLR14wf0EBG+2rRWppqBQgZyfVq4+DwtLUdVF7ygF2KyIa8ZH7NBbzmgf1KBawepfB6Ejp6yMgfh8neoodL3q6Cy+y5QZK684rRySTa8MaI5CvFKFGt0CKfWK/pD7Omf481gX9tKmJpi/+wDRauMgPQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:15:41 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:15:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/14] Mellanox, mlx5 updates 2019-07-04
Thread-Topic: [pull request][net-next 00/14] Mellanox, mlx5 updates 2019-07-04
Thread-Index: AQHVMpR9yuIfapSUmUmpcYLIh8J6yA==
Date:   Thu, 4 Jul 2019 18:15:41 +0000
Message-ID: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea988502-c7a3-442b-4a65-08d700ab9f7f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB25844B13C6228C4FF0614FD2BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(15650500001)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6x1TLVQeF3QP4Y7mrgBlMkl21BqAHUIkpES3K9WfwpZ5i8jgKrsBWUuR/Uhb4124RG7vOI6LMDUGva7nPIBIyuEgpgB1tq5Guq6Y39pmOGVpmFqj9iHxXHBggggtlBKVzF4NDqq4ip3m5xNeW+G448yMf/J27EHu5B9jvbJwU1jZpKBbIj+cSM1E/R8CDVf+EAS9/LdlTwHbTY18n+8c62Eb8GV25ibKQpSzAS0HHSiVCB6buB3AgqTwdTfR2mv8hh6QT/s6xK66EMcDCTQBLS8ScWbklFB+G4pNHOuBDhE3xA+gCCenxrtDLyebC1O3OdU3/hzxVhpX+Kr6o5G5kae6KoMS/QWuIFoxcnb0PL5LNVXQhX/XJpUKr0a1AqIsnFtLxc6fVbpdDynb2WE3fh6FhqAhF/LwZgghTlkhx+8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea988502-c7a3-442b-4a65-08d700ab9f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:15:41.6685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds two features to mlx5 driver.
1) From Shay, add the support for devlink fw query
2) From Tariq and Eran, KTLS tx support.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.
This what was actually missing from my previous submission of the 2
devlink patches.

Thanks,
Saeed.

---
The following changes since commit c5975b7bc0c9b63660d3330f32351aa68d3c97ea=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-07-04 14:04:16 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-07-04

for you to fetch changes up to 29c8935fd5803285c4e11f2bbff9defac96fd6c4:

  net/mlx5e: Add kTLS TX HW offload support (2019-07-04 14:04:31 -0400)

----------------------------------------------------------------
mlx5-update-2019-07-04

This series provides the following mlx5 updates

1) Add the support for devlink fw versions query.

2) Driver support for kernel-TLS transmit HW offload
This offloads the kTLS encryption process from kernel to the
Mellanox NIC, saving CPU cycles and improving utilization.
Upon a new TLS conneciton request, driver is responsible to create
a dedicated HW context and configure it according to the crypto info,
so HW can do the encryption itself.

When the HW context gets out-of-sync (i.e. due to packets retransmission),
driver is responsible for the re-sync process.
This is done by posting special resync descriptors to the HW.
Feature is supported on Mellanox Connect-X 6DX, and newer.

----------------------------------------------------------------
Eran Ben Elisha (1):
      net/mlx5e: Tx, Don't implicitly assume SKB-less wqe has one WQEBB

Shay Agroskin (2):
      net/mlx5: Added fw version query command
      net/mlx5: Added devlink info callback

Tariq Toukan (11):
      net/mlx5: Accel, Expose accel wrapper for IPsec FPGA function
      net/mlx5: Kconfig, Better organize compilation flags
      net/mlx5: Add crypto library to support create/destroy encryption key
      net/mlx5: Accel, Add core TLS support for the Connect-X family
      net/mlx5e: Move helper functions to a new txrx datapath header
      net/mlx5e: Tx, Enforce L4 inline copy when needed
      net/mlx5e: Tx, Make SQ WQE fetch function type generic
      net/mlx5e: Tx, Unconstify SQ stop room
      net/mlx5e: Re-work TIS creation functions
      net/mlx5e: Introduce a fenced NOP WQE posting function
      net/mlx5e: Add kTLS TX HW offload support

 .../networking/device_drivers/mellanox/mlx5.rst    |  19 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  52 ++-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  |   9 +
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |  45 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  51 ++-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  60 +++
 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 114 +-----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 208 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  93 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  97 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 455 +++++++++++++++++=
++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  11 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   7 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  29 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  18 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  98 ++---
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |  75 ----
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       | 225 +++++++++-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  14 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |  72 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +
 include/linux/mlx5/accel.h                         |   2 +-
 34 files changed, 1514 insertions(+), 305 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_t=
x.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
