Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E242ADCF5D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443303AbfJRTiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:22 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394836AbfJRTiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4d2i8vk7ALmTg8FMMx0D2eXZox2eMQypoMnscYyzJmA/Nbl2KvACUCfRgRtuXrp1doyMJYFc30FyhBaabX8m5g4sYs4BAJlJOS4bmZWclDfITkPCsw3Ec49yY9za7eTJrMAUug+j4XLzWfXHwqeXnrOrJ7vqsUDqe7nRpi9RxkqZWgCnzAnU62tSTMRhMesBSttGKQs5DUkRZCBXsMRL5Itk+b2N4Sx0xLy6xy9Fkxc4fHUuxRbdDGYP8yqGjvgR1W4pEynrs1ic56k7rGhg/rbppfDyLBycc7JMaRtpWWfIZ/PBTf8dURDLw4segbk54l6RbabqxGlvE5P/ZZ26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6cmNhwCKx+4BthX1eVSo87Sj1mM1S6fMswkqb6HvKE=;
 b=ZDACowyhGs3SdM4EA7DtKNtMPPdOjfWrhPzmc6q13MyVQDb8UlG4ARh+0rXAYbR0D/Nfmc1mgwuKWIBX3yAZtwlg2ccAPvzTNqI1JI9AViiaQeOcmlCzsoY/VP+H/iumFhdCGSP6wG9dYze4biglNRKJC5StDet75SCXWk81d5LAhk4+fgG/Up7LgaxGJ6LOI88IHtSz+3cQqbUurHACRneCxK+mcLEiLiPLVeZEMzoJqXlmMCwYBSiqZxSuIsTB38UwF0XKzsymHhmTm3T9FrQL7MccNCC/Vf/HZ1cj5BJVSqHf6UU9EymRfvmcb8dzL6wzs+B/D3Ke4Khc7itmOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6cmNhwCKx+4BthX1eVSo87Sj1mM1S6fMswkqb6HvKE=;
 b=f5M3EujVcYv2Hj3lrQKhBGe0vCz5MsWloiGpt2CM253Bft0kVyIa4y1wv1JOqCqZQ0JVgG/K0tc5ZHQf+3Ze1x/S8GIwzqiVdYY8eA1ModiHjuSxG9skev0Y8S4I0lM7SGONv1NnChitOGSvjST7G5Tm0SIMHvXpH2l3IjJl8LQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/15] Mellanox, mlx5 kTLS fixes 18-10-2019
Thread-Topic: [pull request][net 00/15] Mellanox, mlx5 kTLS fixes 18-10-2019
Thread-Index: AQHVheuMgI20jegx6keOfU1dtxu20A==
Date:   Fri, 18 Oct 2019 19:37:59 +0000
Message-ID: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cff4a1b-fc99-4edc-3785-08d75402aecd
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03921202936208670E5A8AFFBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(52544003)(86362001)(5660300002)(186003)(6436002)(102836004)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(7736002)(4001150100001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZL5Gs3UltANSmku8bW98YjJt5m8gHmNgUa7gsz9aalD6hdTkkSJzGenYNxzph/tTrNRNi3vQTsajKiFSo90PrxjGkpXts5tDfeQ5L3YUcND5DzRY+T6jqflFPRmVuiVIIRCh9b2LR99LkK3Uvb/9PGogWx7nzin6BH4jrOMoGpSEfpM4tuMSMaTSXWMali0v1VZ0uPeFW/hruBp4dsIjyewjZGQ2GPy36KTN2btWLZToBYyUYRffmmUrc7VLmaYjfOWuwYJ7bvDQn/W3hyGz2A1zwKQCh94BkcIB/wldapS8RmrDoNWmUc+v0ux6jxJJ5a4bh7MfOckrziXmRRqExWVnsoZCW5IQn6IhtAFKaPGwzVf0+s3AIPje8tUWAY7dCp3B9VpxYifI6+RpyO1cEVGkfzTqMFkEg5d6ZlmHzn5xbH5JmyItJL/E7xVS1flR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cff4a1b-fc99-4edc-3785-08d75402aecd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:37:59.8285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EeG0yjEMcyFBkqw6aa0dFqsAUHH2dIMhif0kNkhmjJJ1aOe4a17SnnZPOaHkZw1zi7ErPdLMuuA3ajvKVgReXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces kTLS related fixes to mlx5 driver from Tariq,
and two misc memory leak fixes form Navid Emamdoost.

Please pull and let me know if there is any problem.

I would appreciate it if you queue up kTLS fixes from the list below to
stable kernel v5.3 !

For -stable v4.13:
  nett/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq=20

For -stable v5.3:
  net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
  net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow
  net/mlx5e: Tx, Zero-memset WQE info struct upon update
  net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown flow
  net/mlx5e: kTLS, Size of a Dump WQE is fixed
  net/mlx5e: kTLS, Save only the frag page to release at completion
  net/mlx5e: kTLS, Save by-value copy of the record frags
  net/mlx5e: kTLS, Fix page refcnt leak in TX resync error flow
  net/mlx5e: kTLS, Fix missing SQ edge fill
  net/mlx5e: kTLS, Limit DUMP wqe size
  net/mlx5e: kTLS, Remove unneeded cipher type checks
  net/mlx5e: kTLS, Save a copy of the crypto info
  net/mlx5e: kTLS, Enhance TX resync flow
  net/mlx5e: TX, Fix consumer index of error cqe dump

Thanks,
Saeed.

---
The following changes since commit 38b4fe320119859c11b1dc06f6b4987a16344fa1=
:

  net: usb: lan78xx: Connect PHY before registering MAC (2019-10-18 10:22:0=
4 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-10-18

for you to fetch changes up to c7ed6d0183d5ea9bc31bcaeeba4070bd62546471:

  net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump (2019-10-18 12:1=
1:55 -0700)

----------------------------------------------------------------
mlx5-fixes-2019-10-18

----------------------------------------------------------------
Navid Emamdoost (2):
      net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
      net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump

Tariq Toukan (13):
      net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow
      net/mlx5e: Tx, Zero-memset WQE info struct upon update
      net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown fl=
ow
      net/mlx5e: kTLS, Size of a Dump WQE is fixed
      net/mlx5e: kTLS, Save only the frag page to release at completion
      net/mlx5e: kTLS, Save by-value copy of the record frags
      net/mlx5e: kTLS, Fix page refcnt leak in TX resync error flow
      net/mlx5e: kTLS, Fix missing SQ edge fill
      net/mlx5e: kTLS, Limit DUMP wqe size
      net/mlx5e: kTLS, Remove unneeded cipher type checks
      net/mlx5e: kTLS, Save a copy of the crypto info
      net/mlx5e: kTLS, Enhance TX resync flow
      net/mlx5e: TX, Fix consumer index of error cqe dump

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  13 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  29 +++-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 190 ++++++++++++-----=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  35 ++--
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 11 files changed, 199 insertions(+), 118 deletions(-)
