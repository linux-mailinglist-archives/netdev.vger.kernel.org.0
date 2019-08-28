Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B09A0A17
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfH1S56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:57:58 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:52486
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726711AbfH1S55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:57:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcptbRu6sZQtfCLMGtyZgNQjFDe3Sb8tgFO80ty1fobm+XJyl5RyZGayLxuZnNFZx3I3I/6ShlhlCTmlfNM2IyinaknmkSETHUi620ER2WCEcvMYssJKeBin7vZRS8XIKxwkoE7PRnhCw2DpCcVromg2M+zkcl0IV5pV6O7m82xeSrJyu0WkEdAtM/+53tBskL00jEshx5mswNdkspTAi4I8Mk0dUvtAxQ2I61CLtQhhN3NpmoVV0IngPOEjyC9ju3Nez7avZNXtUuKXPInINQCw3xxv1kf+TAdBbM1ZvQsLixYNhFTXtg37SOZID+eUJ5gymKRObjicYgwHTiSDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgCHRUdyAy8aZ460pWRbU+tfKzaq+GatisRwtjZcSZE=;
 b=NewYZcLSUkmD+uVUCYPi5sy+M3+IkhwPsrlnZvhYO+nCIf7lI4/lJRd/EI7BN0Tpg14WoCql/VD0F987aF1G1ssfNkBC11BSkKJO0Z74KM1X95eN2Xhf9NcKyeljbMxYXmCkgsDy8lQdfory8qRmK6JWlLg1wBfDYBY1M+14mlP1Vk1pof+RFFBXMnYghCG48Lxl0VeQw/IWMgL6L/GpkhvYiWHzm3G171utw11R5akZkDuaS0uzZNcE1HqBH6XEWdodSPl4dd3XSkB4FsWiCwRcSIw2UYLd1pOz3h6Xx+1Stbn9Xn81lAKJQo3wtaMvmR0dnPswGygjVQDjA6HSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgCHRUdyAy8aZ460pWRbU+tfKzaq+GatisRwtjZcSZE=;
 b=mDNPfDlEGTUazanX4tvBdsasMzT3KMLZKAwAnpBnB5mcsIWp4qqxq+nATuH6dB91IidsPNch3UYUEYzX5BDF0ikWG8W/pisziJk4ouSkD+INBxLPtlErCOKteZXc6GAqzMTmwfA8bPGKv5dtoH4v8+5H0j4bBpBbXFzbPnMklVA=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:40 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next v2 0/8] Mellanox, mlx5 updates 2019-08-22
Thread-Topic: [pull request][net-next v2 0/8] Mellanox, mlx5 updates
 2019-08-22
Thread-Index: AQHVXdJ3koqh50FMUUynLrlN3c3Ikg==
Date:   Wed, 28 Aug 2019 18:57:39 +0000
Message-ID: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e79e392e-1f3e-4c6f-cfcf-08d72be99964
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2638E442D3051761C4CCCFF8BEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(256004)(66946007)(486006)(476003)(2616005)(66066001)(66556008)(66476007)(15650500001)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(71190400001)(64756008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vDGhcgNAGhwK2yTdBg7sUVBb6VzOK0wLfsPUF20O5sf09Tt56k7qHob7UXv4HNCZb1robvLfIXp8mLb1c3tE+0MocSADuR7QXwM9E1B5Ah8N0JEoi1Vtl7BZMEqqa275N38WygxXMTLXNs3m/2PzGd0rKJyzSSzimW7Jp1fNkPGeOddlfT5LS4RKMEVJxt7q76Ca5MiHEjmD484sJVZyWNQpDKzv9tQ6dVfV0TKnxmGVZwMvKeEG0bDwXGzF2v7Lr2REPEB8ZIJ04X9b28Vfkc2nhl3H41BUUEIlLh3gQjzYNw1UYSdjMoEDiPa18TfXsSRMyIK41ef80vridrtbj0rTQA9B8LNpthpVXNz668soKheCi86UpWXZLxCuVpzNmjQHTd5azRcD9BMrjPmmmjUxPdNsauQU9yAfmXPJGmM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79e392e-1f3e-4c6f-cfcf-08d72be99964
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:39.9498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ml2rim5h74VyxubkVaQlVpqoBd9E42xf4ZcApM9l+Y0IP1x+Xe63Hi9PJ3TE4c2gyrtnVycC6yXKs0kZuiRwjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides some misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

v2:=20
 - Change statistics counter name to dev_internal_queue_oob as
   suggested by Jakub.
 - Fixed an issue with IP-in-IP TSO patch, found by regression testing.

Thanks,
Saeed.

---
The following changes since commit 537f321097d03c21f46c56741cda0dfa6eeffcdd=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-08-28 11:48:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-22

for you to fetch changes up to 25948b87dda284664edeb3b3dab689df0a7dc889:

  net/mlx5e: Support TSO and TX checksum offloads for IP-in-IP tunnels (201=
9-08-28 11:49:05 -0700)

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

 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 18 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  9 +++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 50 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 76 ++++++++++++++++--=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  9 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 38 +++++++----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  4 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  6 +-
 9 files changed, 164 insertions(+), 54 deletions(-)
