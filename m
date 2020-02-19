Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1B2163B0B
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgBSDXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:05 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbgBSDXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpIBob2yhei2Z0/ch6LaItcPw85gJFvd77+53LpAaXTyPZQaziU7ddiWPMShG3KZC6LdbSYazAy38g5+5eovYjjbHGFj3paVwq+kj9oH0T4WV1kEA8KR/KGXHGwYGtRTjzrKaKPlZAS6WGw924jYAJ+agxq/5P9uVD6NodrYbFCMjiCjduJZ62gFIyk8O9SWnokauEZD0c77JL8xX5gYFVI6sSHoqkGeSKJN5ti5vq/N5Yn7oDFcqyxEvwfdh07xYPtso+mPjVjYaqU2NNYOpvJQQzGOZHUFArmkmpgRUIPgJZHrrX66htgKstYT1mUYQV6Zt9tQ1AI/8JXWm7yxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+n+vegCczTXhUpmqRAeLTDksBR1wMdz/erUgRgtO1z8=;
 b=MI2+RTK5cRbYEI+wkYTTqwsLvIrWse3opOdfYE1cEISU3BC5thBpuR06QcqnZy7w0V8jog2qZdmfSMjRwTcAwmZO2P+yaVdzO45f0LB+258LAXWBYaQTqURz/CoiWC0Cs00LmYHt4Rnfnu4Js5/jzKxUoo/pyoqQrlm7nY77OPvAQy3nFLrbSA1oVeYqv6npWwNnm1PUvAf0q58YIw4vEHDOIsvCBYs8MS5+8Y3FEFXdpOf5s30xGH97m8ldmnd7w8Y7QMSBVshqEfGyUmtuf9I1C3qVOqIzjkIFFXicM80mKCxvcfmQwLpo77acEIox0FXf5Yu4P+2WAy3E6Q8SnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+n+vegCczTXhUpmqRAeLTDksBR1wMdz/erUgRgtO1z8=;
 b=cKQrI+Y1xtP9HNtVkQzXPje3XX6a7o4GnN6DfO4sqnajddDesrXs3fUT/67+QQHYtd47rFVe3F5z9zMofPm06juFe908sveMdi31Q1ZHAhWMnkgPmnGjsFSaj9B68qXhHyQff5sFYYKKWs8Fp++hLzqoQVFNEavhNXXl3laa/+A=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:22:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:22:59 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:22:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V4 00/13] Mellanox, mlx5 updates 2020-01-24
Thread-Topic: [pull request][net-next V4 00/13] Mellanox, mlx5 updates
 2020-01-24
Thread-Index: AQHV5tPigaz1mYnFGEqOYz519LvY1A==
Date:   Wed, 19 Feb 2020 03:22:58 +0000
Message-ID: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94ce0c72-ef06-44a4-2c4e-08d7b4eb04e7
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4590DF034D266AE4715B703DBE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(2616005)(956004)(16526019)(498600001)(15650500001)(186003)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(54906003)(8936002)(52116002)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KLy4MkgMB2qtrxC5lE0k3Ar6IYLeRINFkFGDkLuO7ef0PfxX+QK0T5SyZt9jCSO36CIgL6BqfTYuMby4Dq4qLsL60jye6Kv5pI4dVywwJeQ5X1wiUlxstWn4Tu8rQZ3Hs7LXeNMnKbvqlQftyw5apohLhDM0untVLBu8eVuRKMGFfqSFmLrMfo3ZJJsVy44popsH7Kf0gcxNxNyfaOi1jIgd9ejcEZAr003KrC7A4jNZVYrMyed3ZZE18Vqq/UpmuADejFeE6hTCTzrBkfWhk5DtYE2k8gz+BPGRD4Q4gxFnyODM2r6WZ1a4Ziyvx8mI0XZHAtqju4CTmYsES6yyVxDQqajPmWfSAkaz6WP9pklEwcLVV5GpCGmXyO/HoZxxXD81VltQeBT++QUtxg2j24NOTZ+xlAh6EdbXGiNJD+iuMrVS2031SAOtznAB/SJeYSv5QvEtZRhWX4hkEqwUxeW3r3ywNKB5sIzbjPvUNcnOpYh3tNBGVDV4o/8hnVjh0xc4ubD04tzMkXRMlyUePkuHHpooxC5EiMsKDbnU5EU=
x-ms-exchange-antispam-messagedata: MqLEA2lR1+HEwTshXjAnOXUCzbJM5qvkPjL0gGVVP5mT26vRM5Zdx6DCyLpaA8hbpgPK+6QKsrkUKCpW1+peYk/p2ipv/AZvRNgCWlZBGrWC7vuIB3oeU582ZD4TvnfM0AHwq4xuYdjEevqdgx+J1w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ce0c72-ef06-44a4-2c4e-08d7b4eb04e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:22:59.0226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HNPo9MTDDrivIaFuQoz5nDM3UPvPKOURGhonry9pnL6OMd5rXBfZB/4w8RZwpAWJHwas+D+zqMMkPlOCJ949aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds some updates to mlx5 driver
1) Devlink health dump support for both rx and tx health reporters.
2) FEC modes supports.
3) two misc small patches.

V4:
 - Resend after net-next is open and rebased
 - Added Reviewed-by: Andrew Lunn, to the ethtool patch

V3:=20
 - Improve ethtool patch "FEC LLRS" commit message as requested by
   Andrew Lunn.
 - Since we've missed the last cycle, dropped two small fixes patches,
   as they should go to net now.

V2:
 - Remove "\n" from snprintf, happened due to rebase with a conflicting
   feature, Thanks Joe for spotting this.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Note about non-mlx5 change:
For the FEC link modes support, Aya added the define for
low latency Reed Solomon FEC as LLRS, in: include/uapi/linux/ethtool.h

Thanks,
Saeed.

---
The following changes since commit 00796b929ce8c9e7567fe7e395763418eb579100=
:

  sfc: elide assignment of skb (2020-02-18 12:40:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-01-24

for you to fetch changes up to 0120936a9fc7493fed63588204af427dcf00feea:

  net/mlx5: Remove a useless 'drain_workqueue()' call in 'mlx5e_ipsec_clean=
up()' (2020-02-18 19:17:31 -0800)

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

3) From Joe, Use proper logging and tracing line terminations

4) From Christophe, Remove a useless 'drain_workqueue()'

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

Christophe JAILLET (1):
      net/mlx5: Remove a useless 'drain_workqueue()' call in 'mlx5e_ipsec_c=
leanup()'

Joe Perches (1):
      mlx5: Use proper logging and tracing line terminations

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
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  71 ++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +
 drivers/net/phy/phy-core.c                         |   2 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/net/devlink.h                              |   5 +
 include/uapi/linux/ethtool.h                       |   4 +-
 net/core/devlink.c                                 |  94 ++++++-
 net/ethtool/common.c                               |   1 +
 net/ethtool/linkmodes.c                            |   1 +
 19 files changed, 1136 insertions(+), 225 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
