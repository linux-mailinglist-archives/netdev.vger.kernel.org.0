Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF88F423
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732384AbfHOTJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:09:55 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731697AbfHOTJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:09:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJmt+bsPN3UvHJyMaG8VLZ4u9Ae2uJ62erillibXOKKb0+2zW7kWnS1CYHnEiD8fzzOPB0m2PBuv2GEEJIp6aL+Xfda+Sskq9VTa0kNdawwk2xN1pNtq3iWfWJv7rNkH7WXPmEopGLh6d6p++U0KcaTPAkF9YzpkYdsy430DkArnwy9MADt+N1XMZwlvJNY/4lzUAtwaLtH2BGxK260AjhX4tRJCdKiW3MZGTDn2dEYyO+XOU7VtBqTdWPX3hgSkCTv1F4gSfhb0eTBvYznDv2GjFp52SjUdLY+KrYQHmyOeITGsVEatzsbFR/6eyfs3T5C9VHMyAOMesvxe3qRVeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAuHc1TpXxZxl2iPiPVAF9KpatNmAp7wlOwVYJgRWok=;
 b=IcKFmvSiTorJLHKdrtK79wS6zYKMiMBgMWf3bfjMJeadruWLTehOCePcX0jZ85yf66jyzRSdz7CWkmxYS2CSGv9tAlsl4tGlWfhHX97o0S/om+XxY0ndMQJ7yTqFkwxFUymv/zh28L3BGzWXVRtqAHXp9slMcjsvfMYpubDqK1uyGxdygv56jXMfb5TLypYejRBbOuJiAzRuCVNqfuy8NeepYUQZLdDpthxHVh2wpvlYr1IRCX7RV02XqLtdc+p/y7TC0DJVlMGpj3GpqKUIcmpNSWEMXhjlwh1zo0KAMJnIVGMF0GZwDMbX5IbIUoiHKLc7oRNcywoNsA6Imm08hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAuHc1TpXxZxl2iPiPVAF9KpatNmAp7wlOwVYJgRWok=;
 b=IG83myMO7n7UqSbVU/R7ef482dKEv3oRVPrryuA/VqTNJGShVPLyhDXuST4VfVimzTuddCCSRgH/Yv9RDGfkWrk9JIOkIe6nJIsGOIWn+Fd8/sacEOLo2JIA9pI7ae41Cf4bAKpWn9WDDeuc6gNJ5PoMPKoHNO1C1alQKM6c/Yg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:09:47 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:09:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/16] Mellanox, mlx5 devlink RX health
 reporters
Thread-Topic: [pull request][net-next 00/16] Mellanox, mlx5 devlink RX health
 reporters
Thread-Index: AQHVU50BFvxJx6QQAU2X8z66GToGBg==
Date:   Thu, 15 Aug 2019 19:09:46 +0000
Message-ID: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5064b82e-3b27-4d84-cffd-08d721b42360
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB24402F8DB4C6D1F9782D9A2ABEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(186003)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u9pa7MXzqxBUlva5WKDHWGbyfucABnp77J43eHGBahd1Jfrh1cb6u1/QXbKCWRIy2N8v+l2eMRTMOZaN7pS/c3qnGk31DhYUQ+9FsegEAyzxhmEFJPKhfMATa77sIHDh3chQjsJdPxB3DhvQ5D/THt2LSzL5mEwpMYZ79/jZifa5mwbNcfgUptaNR6mTST/SEcghCckHEtw1iVSrlgKATvPQvix/DkvfxiUArloTSpdT9nKDGSNpGUNS9Qx0yeFyZuCi2qgp33VkcJgOGMMRxtGER5wMSh9SE/rQPFMd3OfOAg4uTpPJylCo5oao0sz0Jj//mDGsWqblETeh41LLzYI7RVUVV0dCfB+3Xq87tuKpqcmclU8i3C1OTU03c9Zc0LEeAJvXM6agILoMW01Tqi+PMM/7iSV8097DfdWwztk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5064b82e-3b27-4d84-cffd-08d721b42360
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:09:46.9660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hTqi8iUc2ADw+imTgNpcnotAV7n+rhnFNV3sozsLApJnq9MWNBQTdd9aWVPIu7+Lae6p/ehKUhhrF3rfm4qa+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series is adding a new devlink health reporter for RX related
errors from Aya.

Last two patches from Vlad and Gavi, are trivial fixes for previously
submitted patches on this release cycle.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 873343e7d4964fa70cac22e2f7653f510bfaaa11=
:

  page_pool: remove unnecessary variable init (2019-08-15 11:50:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-15

for you to fetch changes up to 7ba590ca7d0c634f6706ba02c8bff0a5f41305e9:

  net/mlx5: Fix the order of fc_stats cleanup (2019-08-15 12:02:13 -0700)

----------------------------------------------------------------
mlx5-updates-2019-08-15

This patchset introduces changes in mlx5 devlink health reporters.
The highlight of these changes is adding a new reporter: RX reporter

mlx5 RX reporter: reports and recovers from timeouts and RX completion
error.

1) Perform TX reporter cleanup. In order to maintain the
code flow as similar as possible between RX and TX reporters, start the
set with cleanup.

2) Prepare for code sharing, generalize and move shared
functionality.

3) Refactor and extend TX reporter diagnostics information
to align the TX reporter diagnostics output with the RX reporter's
diagnostics output.

4) Add helper functions Patch 11: Add RX reporter, initially
supports only the diagnostics call back.

5) Change ICOSQ (Internal Operations Send Queue) open/close flow to
avoid race between interface down and completion error recovery.

6) Introduce recovery flows for RX ring population timeout on ICOSQ,
and for completion errors on ICOSQ and on RQ (Regular receive queues).

8) Include RX reporters in mlx5 documentation.

Last two patches of this series, are trivial fixes for previously
submitted patches on this release cycle.

----------------------------------------------------------------
Aya Levin (13):
      net/mlx5e: Rename reporter header file
      net/mlx5e: Change naming convention for reporter's functions
      net/mlx5e: Generalize tx reporter's functionality
      net/mlx5e: Extend tx diagnose function
      net/mlx5e: Extend tx reporter diagnostics output
      net/mlx5e: Add cq info to tx reporter diagnose
      net/mlx5e: Add helper functions for reporter's basics
      net/mlx5e: Add support to rx reporter diagnose
      net/mlx5e: Split open/close ICOSQ into stages
      net/mlx5e: Report and recover from CQE error on ICOSQ
      net/mlx5e: Report and recover from rx timeout
      net/mlx5e: Report and recover from CQE with error on RQ
      Documentation: net: mlx5: Devlink health documentation updates

Gavi Teitz (1):
      net/mlx5: Fix the order of fc_stats cleanup

Saeed Mahameed (1):
      net/mlx5e: RX, Handle CQE with error at the earliest stage

Vlad Buslov (1):
      net/mlx5e: Fix deallocation of non-fully init encap entries

 .../networking/device_drivers/mellanox/mlx5.rst    |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  32 ++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 205 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  53 +++
 .../net/ethernet/mellanox/mlx5/core/en/reporter.h  |  14 -
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 393 +++++++++++++++++=
++++
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 225 ++++++------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  82 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  62 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |   1 +
 18 files changed, 941 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.=
c
