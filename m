Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A72E10452D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfKTUft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:35:49 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbfKTUft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:35:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsaoTB3VbYzeIwiNcCO20/fufBnq5oCFBl+mesHfAIiMy/VZn4NDUl1LHTaQv3j2S5lChe1oSnP0wGJQjXyKliRiKniXYB3oyTSznxenpPp3R6KMySXj4qRQMZo9gIQqpZuh7q76Zte6jXuGnngPf0XkqcvFtkgHLKArS70iXNaeLtonro1MaBzIHdwfm0kTZngRXbhHiHx6XtbEqmIwMVhDBDGmSOHeVshMxV9iGVVWeK3dMs/nPQlETlgMO3UxelVLsTY9REREYg8sPqO0sfyCTORc5p1PwYdQuyys7ShLvEsIN3vLhAxjoq6jDr680Lm+xsq4PKKUd0a7Avc0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZI9qV8fIaGS/IxIVobuvnMeD8euz8zwyGGU65+r3iI=;
 b=JIuA7M1b7oOpWlV17Yb3t7ASev1ih5Zv+Zk/M2WYFuahR0TDwzA5ENkvbfjtShgMWe92UlnVCHeF3npBWLVHwT30d+kFv7PeTDDd29UU3WRYSHte/fNSJQRJ/5MN3bzGOpzkEG8/oAYu3xDUvkiFo1XB84jKk1bJSs8vej3BjDPiooTgTc4jToFCsV0lbBnnGiTiDU0z5CvQXmv3j/gIAhgq3MrJOHyGXLmHfxoWRBCOcT7L7IcBdE0f4+y7gAvGc/lvGJTC6tIYIWJhIiOA4FSdyFkq1eSHWqVyTIOJseclpgRisfxS8ArXrzo1X+gZqMgu8LDyKUlJxlldmtPBwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZI9qV8fIaGS/IxIVobuvnMeD8euz8zwyGGU65+r3iI=;
 b=GrQzqd+TA8AkpA3MI4buw6unND/dIeLQ9z/T4FnNZ5ZVdcVrOIXkKWfH2H29N0LbwnUAXIdstUZ0tDQh5HgiVdpRKEgc/I61OdRU0LP/HEkya3YjSXw1X7art6HQorYPp8l0o/+1MPaxM++vKXIutzoXqhK7tmJEDKs1mNxosVQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/12] Mellanox, mlx5 fixes 2019-11-20
Thread-Topic: [pull request][net 00/12] Mellanox, mlx5 fixes 2019-11-20
Thread-Index: AQHVn+ITUS41soUKSUSiNw/s4tH9gg==
Date:   Wed, 20 Nov 2019 20:35:41 +0000
Message-ID: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 935407e7-217a-4d89-fbe7-08d76df935b4
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110919DF8CBAC714764B3B5BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(4001150100001)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L7ygbw07RShUss6/iZRGAlx1Ndc3NTkggZJkGL3p36CjoIm6GLbnPjlrcMXqB/uuG4rxBlziUcJRtB5d7nd3mLOyPCYqW89DdO5i2yGzqzQHDmU5ROXp6st/BzNUkArdk1SeSN6typtfqK11pC3f4FNZvWL2+WhktZT6PIreZT9mwokETWlo02kuxUbzhSQKllMSr0fb7+dE/TENlDXDVkz6O+3DcIfJrw698AHiGi8uLoRAlX9gEzHLdExQrCIUIFKMDBv3euUdGVe/VOP/kVaB6MbDVudcGsgHrSNcXKnyReRm/CyRg3hUYZo0YBJCXrfkqKeJg+7uF9LCQbjx+VgR5UmT7DbtD+B2BW91DQs+ZyyUHX+U+Te0psGCIny58PeR5tLzZuDJF8DrspeUPOpaSa5RE0erAMpsUm7MuQz8tfzPtLLl+arvM33utl45
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935407e7-217a-4d89-fbe7-08d76df935b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:41.4150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbJ4OJWjLeITCWo2uACBfXiQ7yirPMyF9oTbFwC/432NNXBxL7S45wCOsVXkBroDOVPNrK0LOPMn7WrSsBfnvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.9:
 ('net/mlx5e: Fix set vf link state error flow')

For -stable v4.14
 ('net/mlxfw: Verify FSM error code translation doesn't exceed array size')

For -stable v4.19
 ('net/mlx5: Fix auto group size calculation')

For -stable v5.3
 ('net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/6')
 ('net/mlx5e: Do not use non-EXT link modes in EXT mode')
 ('net/mlx5: Update the list of the PCI supported devices')

Thanks,
Saeed.

---
The following changes since commit 6e4ff1c94a0477598ddbe4da47530aecdb4f7dff=
:

  mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=3Dn (2019-11-19 19:17:20 -0=
800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-11-20

for you to fetch changes up to 30e9e0550bf693c94bc15827781fe42dd60be634:

  net/mlxfw: Verify FSM error code translation doesn't exceed array size (2=
019-11-20 12:33:06 -0800)

----------------------------------------------------------------
mlx5-fixes-2019-11-20

----------------------------------------------------------------
Alex Vesker (3):
      net/mlx5: DR, Fix invalid EQ vector number on CQ creation
      net/mlx5: DR, Skip rehash for tables with byte mask zero
      net/mlx5: DR, Limit STE hash table enlarge based on bytemask

Eli Cohen (2):
      net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/=
6
      net/mlx5e: Fix ingress rate configuration for representors

Eran Ben Elisha (2):
      net/mlx5e: Do not use non-EXT link modes in EXT mode
      net/mlxfw: Verify FSM error code translation doesn't exceed array siz=
e

Maor Gottlieb (1):
      net/mlx5: Fix auto group size calculation

Marina Varshaver (1):
      net/mlx5e: Add missing capability bit check for IP-in-IP

Roi Dayan (1):
      net/mlx5e: Fix set vf link state error flow

Shani Shapp (1):
      net/mlx5: Update the list of the PCI supported devices

Vlad Buslov (1):
      net/mlx5e: Reorder mirrer action parsing to check for encap first

 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 18 ++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 12 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  5 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 31 +++++++++++-------=
----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 10 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c | 15 +++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  4 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 22 +--------------
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |  2 ++
 12 files changed, 67 insertions(+), 56 deletions(-)
