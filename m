Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F369C5FDEF
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfGDUv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:51:26 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:64342
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbfGDUvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 16:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcwMoGAEnGz25ngaMEvxx2BKj8eA9n+zuiHZBWQ0g0c=;
 b=VwZP6csSFo3rDDRAbhvQIs1iErye9RC/S0W+gsAP0MeHpotUBpGq4rXffudO/KNo43sRGhOlzfGxvjfjyqEKyfOT0azvurdz5F8BeT3J2Lqok5it3swidAKWZQm/y/Pq4vUfg5Y1Mn0eNTabE+15unKch4BFe9GacRY0BYO5Pv0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2821.eurprd05.prod.outlook.com (10.172.227.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 20:51:22 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 20:51:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 0/2] Mellanox, mlx5 updates 2019-07-04
Thread-Topic: [pull request][net-next V2 0/2] Mellanox, mlx5 updates
 2019-07-04
Thread-Index: AQHVMqo8TpZ7iqfLcUaC4IJMLGwCJQ==
Date:   Thu, 4 Jul 2019 20:51:22 +0000
Message-ID: <20190704205050.3354-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: MN2PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::35) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ba35483-a0f8-48b3-4080-08d700c15ee8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2821;
x-ms-traffictypediagnostic: DB6PR0501MB2821:
x-microsoft-antispam-prvs: <DB6PR0501MB282120E648B179B4CF7F53D4BEFA0@DB6PR0501MB2821.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(478600001)(316002)(25786009)(6512007)(99286004)(64756008)(102836004)(6486002)(73956011)(68736007)(6506007)(386003)(6916009)(5660300002)(66556008)(52116002)(66446008)(50226002)(6436002)(54906003)(26005)(66946007)(3846002)(486006)(2616005)(8676002)(86362001)(36756003)(2906002)(15650500001)(14454004)(81156014)(66066001)(8936002)(305945005)(71200400001)(14444005)(1076003)(186003)(476003)(107886003)(53936002)(66476007)(7736002)(71190400001)(4326008)(81166006)(256004)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2821;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: alhu+4vAVaH9rhzL5qJOVnwUttQzL8wMjQaVa+5gJ0mIhcupOM3eh/DBg8wcgo/ThYAuDAZy7XXg+4hgdAmjOBxU0yyVIu/EV/PPKv56TyxJ6R0awrYbBEyYFJZcisoYp6ugoo5QveYWCdb5sHVl8z/II1d8qxIjhySGWs7Tf+jFF5pvi5uMzhuw2rpu/qqGjG+cRypQHIvbsXGwqGN767qz1zyKBvBDrTS2gnB3dPmwVH1TrEj4wppCagwflL+DFUxKXapA0ZY+Jo9+3IQsmxA3s6lt7pRcqTkdkBjGibTlR4uat0HbSIf/RBDv/B/sHZXCvUrJNathskqpUoghfRZxt7maCeI2wF8GRQ548ck7ioXa07iP1+BW2JaH8ZXlMG521VlzDGbSrXykqB7txqa9IE1i1wnItJEGyJ7ha+0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba35483-a0f8-48b3-4080-08d700c15ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 20:51:22.3096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2821
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds the support for devlink fw query in mlx5

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.
This what was actually missing from my previous submission of the 2
devlink patches.

v1->v2:
  - Removed the TLS patches from the pull request and will post them as a
    standalone series for Jakub to review.

Thanks,
Saeed.

---
The following changes since commit e08a976a16cafc20931db1d17aed9183202bfa8d=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-07-04 16:42:59 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-07-04-v2

for you to fetch changes up to 8338d93788950e63d12bd1d5eb09e239550e80e9:

  net/mlx5: Added devlink info callback (2019-07-04 16:43:16 -0400)

----------------------------------------------------------------
mlx5-update-2019-07-04

This series adds mlx5 support for devlink fw versions query.

1) Implement the required low level firmware commands
2) Implement the devlink knobs and callbacks for fw versions query.

----------------------------------------------------------------
Shay Agroskin (2):
      net/mlx5: Added fw version query command
      net/mlx5: Added devlink info callback

 .../networking/device_drivers/mellanox/mlx5.rst    |  19 ++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  60 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       | 219 +++++++++++++++++=
++--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +
 4 files changed, 280 insertions(+), 20 deletions(-)
