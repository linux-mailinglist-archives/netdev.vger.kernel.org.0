Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8B49A3DD
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfHVXfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:35:50 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726560AbfHVXfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:35:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrSvv/FjTKj2RTBXHXETXCti79BmFYo98xxOLU9e047HfdMhNMmvggap7z/XHTevPMx99Pobf15AswHJhUQN31JYEBrtsfA7Wn7eBvxkFsRo2DdWVezEG9hBzqxDOC9mGun+IA3cH0nvCWuXiNeYLLtotJ8b7is0xmZZV3O+bJb1I/0O/AmJECYFAaQG2LcJ8NlF1hPUCdsqB4h47BuhHwmHtJlu0A9sY0BSA77ElYWGPyBfxriF0SLRAOIJdKQZcce6P/2p929ZJPK6r+cY0mqMNdNsMHvOlvHkBFgdQMl58bbWpCKRZQSOTw29MWCzSHY7Q8KupywFF+XLBr64VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0Ze5KCp6Yn666PE26/GewKBr0NBV9qc0CXT9UaM7/o=;
 b=iLVnzBXnhonpIov8JUb9PidIx4vzT6yMJtL/ZeFFidnDqA0nAimT8ZL2Fpb7hydIIVnriUJ+Q01CHjGMM2aZfxpnMCnaqHq6+/f22MgX1+WaqLN/YrlKTR1gL7cLdrgfulbAO1e/FjrGU0d2SY+lBOt2J5syT16zEtj19TahTVrHnY/1ROaVPd+f2wjmnYubDMqGdb4vmaDSCZ9TXdtI/EeodG8MxyvwAIgOLFDCLoAQ4j7+v3JL3ILozaqU8+Vx7KzBIMlmMZa+HrAHiYb8qngVWsqT73ilJ5Tgb6W5fca5b1a/T2z3jNGLpM2Gt+8QtUdzgQBoXO9uarsxD4O+IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0Ze5KCp6Yn666PE26/GewKBr0NBV9qc0CXT9UaM7/o=;
 b=qjzsnw+L/K1dnuWiHknAoWkx/Vc8pL6pTSbUL2Dijv5zGfXeUuU2eUmf4tGdsNqgPhWTwR2Jl3Lddm/AwKjz9IEbGalayAUCRZwJDivnRTS7f8UiMlLOoqjSb0cq4oF+sGunhnnwswrZp/+nk0/7whioMIl1UpU9hKcKn3yIESc=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:45 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/8] Mellanox, mlx5 updates 2019-08-22
Thread-Topic: [pull request][net-next 0/8] Mellanox, mlx5 updates 2019-08-22
Thread-Index: AQHVWUJRFAvSXZhA2kqdMZVP10NO1A==
Date:   Thu, 22 Aug 2019 23:35:45 +0000
Message-ID: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3979b08-d9c7-4198-fd0b-08d72759741a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB28173350ACB6E0C1D010367BBEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(53936002)(14454004)(107886003)(6436002)(15650500001)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UQcXaVyca32mezhX7P0RTaOZZmycXx8i+9VjLkyevkvz4Q0auvz3qEX+hKOEntwSL5HEuOY4MtKohp4WG+sP3eC38L67skAfnjoEHi584nAoqpyu1xEoA1VfRCJPRStGyglKp54cqxCqj2AZLO3yk5V0W/ZLDrbiynBYp1g0CKikQiNPKlIex4oQ1/dyrYy0kFI7u+8KZl5MrXjthBSheZ7dsVIAjJFXeoYUhGqsi+bRcLKyC8G4PZB7Y+8seaUPUt1TkTy84smsurlCIuho8ulEKfbvHldHvlLhRH5uY1yA7ZPYxKypOzeli/l5b0Bh4yAg5LxhoHaQHJWP7SzDn+NicAqQ6JhQ4apw6y7y5p2C9HtVGCWbZiDszkPm46TeE6doopE12XOoH/2LsxvzqEyflG4iZN6+3pNiPMmn1+4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3979b08-d9c7-4198-fd0b-08d72759741a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:45.1612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uD4B0IdNop3emYNqmB0vAyPm7qWeS6W8WNEk9GmYHv16LkXYU7lEedbueKcMkMPzsvxNKVSOoeX0eCDeW48bAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series provides some misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Thanks,
Saeed.

---
The following changes since commit dc499cdf79f28a42cef0f1d62fe846090d14701a=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-08-22 16:32:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-22

for you to fetch changes up to 9f7df106da11f5863e12283700138722bdc46c83:

  net/mlx5e: Support TSO and TX checksum offloads for IP-in-IP tunnels (201=
9-08-22 16:32:15 -0700)

----------------------------------------------------------------
mlx5-updates-2019-08-22

Misc updates for mlx5e net device driver

1) Maxim and Tariq add the support for LAG TX port affinity distribution
When VF LAG is enabled, VFs netdevs will round-robin the TX affinity
of their tx queues among the different LAG ports.
2) Aya adds the support for ip-in-ip RSS.
3) Marina adds the support for ip-in-ip TX TSO and checksum offloads.
4) Moshe adds a device internal drop counter to mlx5 ethtool stats.

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5e: Change function's position to a more fitting file
      net/mlx5e: Support RSS for IP-in-IP and IPv6 tunneled packets

Erez Alfasi (1):
      net/mlx5e: ethtool, Fix a typo in WOL function names

Marina Varshaver (2):
      net/mlx5e: Improve stateless offload capability check
      net/mlx5e: Support TSO and TX checksum offloads for IP-in-IP tunnels

Maxim Mikityanskiy (1):
      net/mlx5e: Support LAG TX port affinity distribution

Moshe Shemesh (1):
      net/mlx5e: Add device out of buffer counter

Tariq Toukan (1):
      net/mlx5e: Expose new function for TIS destroy loop

 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 18 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  9 +++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 50 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 75 ++++++++++++++++--=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  9 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 38 +++++++----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  4 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  6 +-
 9 files changed, 163 insertions(+), 54 deletions(-)
