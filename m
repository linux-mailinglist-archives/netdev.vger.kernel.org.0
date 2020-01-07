Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B606132F17
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAGTOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:10 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728307AbgAGTOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brXrL67nvXWbbmC5AI67Q6Bc43cwyc00n/V/NdMnMYQJ4C2h2kH0Bz6BLDb+aq1C4q+xU1+QWe8JazbUAff3phn+5yFeeX65CMqzDsVSxgqmHjjf1EPsf9lsVDh9dpFfvYYwPeAR9Gr8/cqDH//0IE7Ws534Zwp6vZ42oRjQY0wFVoKRGkPp/2wDAveqmfWiXWmbtDFP6yv6T3ro1cKwPQmrGM7j1ducc8MkJYWLnGCaYuBeMZdrVl1BbE23WQxwWsYPbY8DojOlv4L+a27KLqEiCqlfjKMUIOlZ200ZAyLzdJSeebxWqaDl+tUM2/AIofJA6Slq7A1AABFxglOdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOyBbFOrcp3jcNOKTeSexWZIwwmSuQ2InbZy3TakD/Y=;
 b=WuHNOZmSrIbse3OhTtQJ2qtTtmLocfe/5dompUa/ZtpqxmuFAITUp+jEMoj+bx3rT0sQMn+UoEDAgP95FVyVR1b4q++6w56WL2he851dHCA3jd3wheXJ4SlkBVRrPsBBdowNxHarpvVoD4DiMcdniOIAIZBJOmzFj5ITD9vOubiEs3zJBVKEc3EGlYODRY9srL4u7xv8u4u+oFjI8cg+gB32hMe45Ba9ELX1zqffb2E0F4KhJVSEZLLaWnro9sFB3iJHuBKstg30D5ZMjbKN+PyiGqBZ48eOkrPXjVWroeZtLgT1e2WBuHKvpdUn6g9IfC2QRPxZqxczmCsxYEnaWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOyBbFOrcp3jcNOKTeSexWZIwwmSuQ2InbZy3TakD/Y=;
 b=BtACKW8BRpI9SJebKPKQOwPCcVFGgCnYAIBlk6NH+8y60SXix5FVQ9c4XHJHBTURHFTP0czcp9iynhj9Qx9AHnTixpbsgyqxDC6i4qh4LP8IoT0+Qqfa2R2zEAu/UGFk4mPfzcdm0RqdKuBYRS8M2ooOZnLOFPLmnNLVBfWuSIE=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:05 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:05 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/13] Mellanox, mlx5 updates 2020-01-07
Thread-Topic: [pull request][net-next 00/13] Mellanox, mlx5 updates 2020-01-07
Thread-Index: AQHVxY6geN0DaT1sFE2xuus0eC1P/w==
Date:   Tue, 7 Jan 2020 19:14:05 +0000
Message-ID: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 12f663fc-177a-420e-db77-08d793a5c325
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB54110048CA5C435E1CE76BDDBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(15650500001)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LnlhwOfYuEqqSU9hnmIHkyMujqt1lnA/WgQWB1j/zVbN0qlHaacRn9nIGqWxErNKHl7Kj64Y5gCkhbDKdTirGl3SeBWIDjSjDJtHU0t6Gp9cVuam3lR+dcbnT3XAUy5+vEJCfvI95SCgxnBJxAuqHPW32H29M19pw/bUzrUCPFOpJLYCmXREwcAVTfGSIl/ETZWSQ1IrzUoEK1JjVT7XhxA65QIWi1Yd1FbANZquMF6t04YBb7Qq01DyIdV/i3ctD53DiHLyNL36VXtaGPeatEaLrp4QU93GwPu7txqlVtiCllwh94ttonjJ7g3LDtblhukqC11l/wEH/YMARi5M1x0MHgDHPZ4EKQ7A+R2/IXAzGy4V+6LGw1U7OHTU2Q41HWX1unzIh4jHDV4HZtZy1GLU/mL3fWA/g1Ix+Zj7AThX2N9+Q4DeT9vLGLVm7pyZerxRm/0qQr4OqexJLPUeDa0phu7C0vp/m69wm4KRSStBjRTFITelJnjxJXXoKGJMMUgUufKL9fnp6eIaXu5VNuAEpT6hoTC2i9YPdX4mf/k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f663fc-177a-420e-db77-08d793a5c325
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:05.2887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QRxnkMT1M+EPtxtKZyISapcoPzUTJ+SzKTQ/GT/2vF0utBxFTgbuTeZMcQqKcCnkE8gwUYRmhC1LvnfV26Hrrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds some misc updates and multi-destination support in SW
steering for mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 1b935183aeff11256b20a490b5ed37116b054fe2=
:

  Merge branch 'Unique-mv88e6xxx-IRQ-names' (2020-01-06 18:30:15 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-01-07

for you to fetch changes up to 7ee3f6d2486e25d96d2309da4d53fe10a58e2b63:

  net/mlx5: DR, Create multiple destination action from dr_create_fte (2020=
-01-07 10:43:02 -0800)

----------------------------------------------------------------
mlx5-updates-2020-01-07

This series adds 2 sets of changes to mlx5 driver
1) Misc updates and cleanups:

1.1) Stack usages warning cleanups and log level reduction
1.2) Increase the max number of supported rings
1.3) Support accept TC action on native NIC netdev.

2) Software steering support for multi destination steering rules:
First three patches from Erez are adding the low level FW command support
and SW steering infrastructure to create the mult-destination FW tables.

Last four patches from Alex are introducing the needed changes and APIs in
SW steering to create and manage multi-destination actions and rules.

----------------------------------------------------------------
Alex Vesker (4):
      net/mlx5: DR, Use attributes struct for FW flow table creation
      net/mlx5: DR, Align dest FT action creation to API
      net/mlx5: DR, Add support for multiple destination table action
      net/mlx5: DR, Create multiple destination action from dr_create_fte

Arnd Bergmann (1):
      mlx5: work around high stack usage with gcc

Erez Shitrit (3):
      net/mlx5: DR, Create FTE entry in the FW from SW-steering
      net/mlx5: DR, Create multi-destination table for SW-steering use
      net/mlx5: DR, Pass table flags at creation to lower layer

Fan Li (1):
      net/mlx5: Increase the max number of channels to 128

Parav Pandit (2):
      net/mlx5: Reduce No CQ found log level from warn to debug
      net/mlx5: Use async EQ setup cleanup helpers for multiple EQs

Tonghao Zhang (1):
      net/mlx5e: Support accept action on nic table

Zhu Yanjun (1):
      net/mlx5: limit the function in local scope

 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 117 +++++-----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +-
 .../mellanox/mlx5/core/steering/dr_action.c        | 135 +++++++++++-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  | 244 +++++++++++++++++=
++--
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |  79 ++++++-
 .../mellanox/mlx5/core/steering/dr_table.c         |  23 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  72 +++++-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  96 ++++++--
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  27 ++-
 include/linux/mlx5/driver.h                        |   2 -
 15 files changed, 676 insertions(+), 152 deletions(-)
