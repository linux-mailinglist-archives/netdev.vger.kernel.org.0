Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBB5146203
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgAWGjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:39 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:52999
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgAWGji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fg5b5JMcMNAPZ8quruZhTxxzKFmfFkYUWHK4Xzb2ESh3J3umzsytfNmPx0L0uUR9Om5hnyzekhQj+Q/BCZSLdrEGUc5uqzF5uVdKxdZHz/FIWacrss81q0to2cwsqjr7juYa7Lf3DODytDym7fywp8LMCiVuqT+VFGQdMvF32g1zeiaKeRWNbytyGOeLtrVuO/fBBqBq0FhNCt1kknR6U1s8r/leb2EE+AEtqr985LgMXJCgI5Hp+bpk7rA0LgLWx6g4WbTsGzpXd2BJ/dGdF4p3KsTGf2aUTtVpzLrsmKbIKuUKv6Mwds/3HY/YjUZjG9mdYnSGgTABwRY2829mDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygTc1E5m2FF+xc4T6tDMXzC1TsytDGuos4zNUVPk4Ho=;
 b=oYLTsafx5pA0UurZ716Q6pewI4VEzwZ5MjRa4KHjfzAfIcLlO/nqGW2MVrQt0mUgUr2PvhAWN89yC6YP1vvzIuNLscwa/8YNxfohHtyy8sKIxmLR5UKp/f98D/hSF0iLkfDVC9T1ARWANOq6CjPNvihcBxiCr7lHqjgslrRtv1GfzFYRJiMXvIpZTnPTsK/6uw1CRjGVWyvbQ8bE2XblXyULZNUBo5NpISCNdsbNjscX+8L9h2sV4EgbDTNjDnIOTuqoZfLjefiz1iciPWXR85Dix3RD/q/ndp5Ses2ruo2pL9reIy08j9EUYtfu3XQYDWO7izVcZgpU9geE5ksUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygTc1E5m2FF+xc4T6tDMXzC1TsytDGuos4zNUVPk4Ho=;
 b=MukWXff+hvzKZNYvRglLBezSOIQAFJXzoWSuefS9TFKJzudroS7AWEGRN7K42yhbsdZzX83kcj3Imr0kXX7gyd3Hj1/Ui1t+vEjDKFcWOh9MpxLUYfEXzdhtxbe5le3qgg7AK84FZK2BOE9SZ1I3rIUFuhyuiLVtNCvzK61Px10=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:35 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] Mellanox, mlx5 mlx5-updates-2020-01-22
Thread-Topic: [pull request][net-next 00/15] Mellanox, mlx5
 mlx5-updates-2020-01-22
Thread-Index: AQHV0bfgitHZhgAMNkCq8s3k7xundw==
Date:   Thu, 23 Jan 2020 06:39:35 +0000
Message-ID: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f588991e-dd5a-4596-fc9a-08d79fcf02e9
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941BD5295219253E64E7C36BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(15650500001)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lf4YlsU46EQFp+/rbP+iey2lHZhcDXXsAInmOwG82ZmVS+BuoKlIPOUQ6lDE7eZ+YmdeQp/rLztf7Y91V03Gd8x57NTOt6iEAoTZUooOHwzLmTDzucj3JpdX3swVrqpjcfpvkBznFx/rUP+PKB60pOsCo5ML77GUccAWBz+rxrvyGCAjvBAdiIW3TGPgfpLUgH+T9PdxEhDQwEInJyL53M1UUm6lzA9DdZGI6zzkMTeFsghjuZeNvZ+gmB5NnxcLoVQkzAb2ye7yld9rmGnWbmatwgXhQj/O8mu+4XZtBOdWMeCAH5XBPR8A3O8cg6hveW5ynSCGmlsavoQf4RLiLPP6WcUaRU+WOYDKh0ldEMviuhRYxLrsXPfFfSj7xxWt5ayv/BVIeaNpBjN4G4iz+MaMHOLfUnl7Tu/I1yqaxZoMWp2rAGqDv3B1ip9v7CQZ6QgbJblxMzpTLpu+n8132D3/j9TN29zVaotyBO8rYLHcVVNSo9IZinamA0m9qNg71IgzUwUAoWOMOyjhz2J9+G+0w5pGzuEo1jb6qjogZAM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f588991e-dd5a-4596-fc9a-08d79fcf02e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:35.3759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mIvL37awmk12p0mNJnXNMxNjKBkssFux+3kAeqsDc3KF7Slf8bN5H+in1dXR12cm7StWXdq/3aoDWX97QLCbmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 driver, and the support for full
ethtool statistics for the uplink representor netdev.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit c5d19a6ecfce72d0352191d75f03eea4748a8c45=
:

  net: convert additional drivers to use phy_do_ioctl (2020-01-22 21:16:32 =
+0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-01-22

for you to fetch changes up to 7c453526dc50460c63ff28df7673570dd057c5d0:

  net/mlx5e: Enable all available stats for uplink reps (2020-01-22 22:30:1=
2 -0800)

----------------------------------------------------------------
mlx5-updates-2020-01-22

This series provides updates to mlx5 driver.
1) Misc small cleanups
2) Some SW steering updates including header copy support
3) Full ethtool statistics support for E-Switch uplink representor
Some refactoring was required to share the bare-metal NIC ethtool
stats with the Uplink representor. On Top of this Vlad converts the
ethtool stats support in E-Swtich vports representors to use the mlx5e
"stats groups" infrastructure and then applied all applicable stats
to the uplink representor netdev.

----------------------------------------------------------------
Chen Wandun (1):
      net/mlx5: make the symbol 'ESW_POOLS' static

Davide Caratti (1):
      net/mlx5e: allow TSO on VXLAN over VLAN topologies

Hamdan Igbaria (2):
      net/mlx5: DR, Modify set action limitation extension
      net/mlx5: DR, Modify header copy support

Olof Johansson (1):
      net/mlx5e: Fix printk format warning

Roi Dayan (1):
      net/mlx5e: Move uplink rep init/cleanup code into own functions

Saeed Mahameed (4):
      net/mlx5e: Profile specific stats groups
      net/mlx5e: Declare stats groups via macro
      net/mlx5e: Convert stats groups array to array of group pointers
      net/mlx5e: IPoIB, use separate stats groups

Vlad Buslov (3):
      net/mlx5e: Convert rep stats to mlx5e_stats_grp-based infra
      net/mlx5e: Create q counters on uplink representors
      net/mlx5e: Enable all available stats for uplink reps

Yevgeny Kliteynik (1):
      net/mlx5: DR, Allow connecting flow table to a lower/same level table

wenxu (1):
      net/mlx5e: Add mlx5e_flower_parse_meta support

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 277 +++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 342 +++++++++--------=
--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  83 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  39 +++
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  24 ++
 .../mellanox/mlx5/core/steering/dr_action.c        | 367 +++++++++++++++++=
----
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |  16 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |   2 +-
 12 files changed, 805 insertions(+), 398 deletions(-)
