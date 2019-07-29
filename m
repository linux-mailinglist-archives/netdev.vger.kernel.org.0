Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DF379AB7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbfG2VMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:12:55 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387510AbfG2VMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:12:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UG4CLZ6jOKNWtD/sILx78DjzZJelPunU14GPoCtMRgSn3reyZYIPWPS/WaJ7b4n3kXtkXXStV2kSdY/+F4Jp2m3LvDPgx915SARSWIKqlpsCX4v2Cz3JH55os4vhGdRQFs91y137sbDNeyU5gAGwj3a4AX4L0n50FKzzDlg/QviUm1oNMj++VuMZkdY0p7YUlSjpJMMPA9ZlgQ3VCJIV8iEGTrVmMKsG2vZkvBtYTipHugIOvn8p2UlAyvxDoK3P5zHVfNx1QzhzKquTUGeWQqPE0rwZto8E/BdEixDLeR9edxbrxZF+5bByogVc+V308UJ56Sl/WdqJftBxQNAf5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk72rq8xYVZqxsWPZ+bNgj8iO/0Cuwppiea65QB/iNA=;
 b=myXVU4pIjS1ecWHaD1A0H4FEjrbjgYJh2LuwHwxppDi4HaibpP4T/YZPOq3PllMuOaaSTuLZRa51rTj4gr3Jm6B7PlnsHeRjnU7seRSIOrFb9Gx/adi+RHkSYkZFAJhALANc470abxwqGCIgbqxpn7YilT/4ukxDMb3lb8BrK88KLe6lqrh3o7WiFJOtRn85M6FB5O4nq6ujbA+CGEZeQdDdLfF0YfRLq4rFmSH3BeFMygkmF6+0JS6D1m5RqHaJNCZ/yMVW8fQ8WWy0PjB88inJV1oI/aKG0F9k221+8YrrL7TqVzjti/3lMKQsVqqnjicroubhZyEgR7gNgT7iPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk72rq8xYVZqxsWPZ+bNgj8iO/0Cuwppiea65QB/iNA=;
 b=QUmlmucHJNclCq9PY3DykgqRecuix5A9U+SHHHvdxuSgIlT1ufbZDgFy5DNV7R5rTfelYNwi02iS1PVPwrNtbcSiGDA+7AcISb8ObLnvXGfXDWPof6kXqZBK2Bila1Ns0iOe9LWs0ND8/U3jtwgvYcJvbmfclbCx31RC58yDD0c=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:12:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:12:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 00/11] Mellanox, mlx5-next updates 2019-07-29
Thread-Topic: [PATCH mlx5-next 00/11] Mellanox, mlx5-next updates 2019-07-29
Thread-Index: AQHVRlJgGi9Ja1YAgk2f66wYwhD1Eg==
Date:   Mon, 29 Jul 2019 21:12:50 +0000
Message-ID: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0056a950-0e64-4c5d-ad83-08d714698364
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB237579C0165B7D7DFBB32592BEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(53754006)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(15650500001)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FlvOTtfz/lZbvUCb5nbXCHEJQ8vMHy/9LCz5w361DRl5svkVpxIngeGBztNtLSe2A03fs+8Oydfl4ownCaEE3yatP/n8Ew+It00NgMGpY5gmceg3+Bo//RbYMJeNIEMgGsshYdhyoHTp7skhmbk1qgPzKjt0SC/De0HEzP6DKXa/eMgVfh0qZYegCusWsPpI6SLq2I6Al2YIqes3qe46tNYCnrX3XdAmMrEs+JN/oC1R7IEaWiEvBYsBZRUAyZ64x+4eg9oc6i9ERVOm5DINMjWejzPw6T9ia2FWRz0nVIkU+DcRPCBEz27J6RdCcZKPyXu9aRQRleGO/LC07KBzF3BX4C+Vs7z1frEno2HyjX+ws5dlQsYIUE1ltJLu1cfUwACryPTD+vFuzVV4qGiV6bAtlEAZge6ehRIkgxPqOGM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0056a950-0e64-4c5d-ad83-08d714698364
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:12:50.6828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series include misc updates form mlx5 core driver.

1) Eli improves the handling of the support for QoS element type
2) Gavi refactors and prepares mlx5 flow counters for bluk allocation
support
3) Parav, refactors and improves eswitch load/unload flows
4) Saeed, two misc cleanups

In case of no objection this series will be applied to mlx5-next branch
and sent later as pull request to both rdma-next and net-next branches.

Thanks,
Saeed.

---

Eli Cohen (1):
  net/mlx5: E-Switch, Verify support QoS element type

Gavi Teitz (2):
  net/mlx5: Refactor and optimize flow counter bulk query
  net/mlx5: Add flow counter bulk allocation hardware bits and command

Parav Pandit (6):
  net/mlx5: Make load_one() and unload_one() symmetric
  net/mlx5: E-switch, Combine metadata enable/disable functionality
  net/mlx5: E-switch, Initialize TSAR Qos hardware block before its user
    vports
  net/mlx5: E-switch, Introduce helper function to enable/disable vports
  net/mlx5: E-Switch, Remove redundant mc_promisc NULL check
  net/mlx5: E-switch, Tide up eswitch config sequence

Saeed Mahameed (2):
  net/mlx5: Fix offset of tisc bits reserved field
  net/mlx5: E-Switch, remove redundant error handling

 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 184 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  27 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  56 ++----
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  71 ++-----
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |  16 +-
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 125 ++++++------
 .../net/ethernet/mellanox/mlx5/core/main.c    |   5 +-
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |  30 ++-
 9 files changed, 282 insertions(+), 233 deletions(-)

--=20
2.21.0

