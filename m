Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F14F148F3C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392088AbgAXUUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:20:55 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387421AbgAXUUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:20:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+uMpDOr9jiiyi6B7v/cSUpw1PLJb8MWSTrY4/94j+WOdJ/C6k2JU83Yo9ztKJNQnxQ8E3Z9ArovcGaLxVcrJNtcJbwLpSYOQM7vlMulBLP0yEq0U1WnGfpsrpuw3zLLpjAXK2k6Ef1Ny/BOzjPTEE+crJfXQtcVwCAGhoOiQc60hN8oogTyHqT4xUTXBIvbR6Gzy43UUOyfmpkq3NqcdlJl7kl4DPNjEbQqdNvU68PEtbgpKNPO8sWMa97JG7qTZLHSwGsP7KWkBkhU1AsaOxdUy6fWpjSy77umkcQDTsnpubaSsiDxChACcVTmWtzfCKsvMNCP6rWOIl1x63nqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6XT/CFZg76GERYBZj6PeQwsF7Kga82DuyzDtUzWsgE=;
 b=bUU227pVzPk8a2pLsuI+juIjMXrpb+Q6Pt1JmawOgQnRB12Jt9t3Hg9rEjiDiCKAaELb2q4IKygCURhDLwrN/O2h6xLdXiIHiBh0pYARdrYUuuDh/Ddw2HL9YzEWWNdG/OyNIBZvJ8BEbBZG26sAL+yQtrUoSpL6lUGh9tnD9U4OdYCBmqNGdBI6LB7x4juSBxAnvwHKPmtWnftXe7BjZYEQFeNVE6U0J/FhQsaWlAd1VJDksRVhcw19wjSryaXskUAVrFqqW7MhzDX0qarnTDtbYkv/OmYaLxnjdpIEH7C+ombSHGVaukSJA1ULkY1GP9qYyM0MtXHJK+5VHaaUTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6XT/CFZg76GERYBZj6PeQwsF7Kga82DuyzDtUzWsgE=;
 b=riUjrAfjVgBTJD6r/GkEFTtNTIDQvzrbSCFWOztq2IQ82puFI0TtWqadEhLjfOC38546/euuakKLstixZqXyX4VRqkQ3yeSjWSMTARG7qVtbVmHQpOiqvG4F00UvgMCTbpIn91nxyp1MJ4ufUkQtkj/M5RCQIVfzNpxtIeDEGGo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:20:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:20:50 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/9] Mellanox, mlx5 fixes 2020-01-24
Thread-Topic: [pull request][net 0/9] Mellanox, mlx5 fixes 2020-01-24
Thread-Index: AQHV0vPF7STBTI5yqUeCsW47hiWdXA==
Date:   Fri, 24 Jan 2020 20:20:50 +0000
Message-ID: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 300a4ab6-9f38-4742-3377-08d7a10ae78f
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB555248C4A0B7BE2C343A2AFBBE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QzhReeW7JYtAIrQNWPg3DMm+Uv399izXrc5CyAyKUneaTSe3vL6UYld9ST+ySuJlvzp9ktwXWokMmb57IZB3JDCfPjM66kA1OolkGHuAc+C9mJy2u1HGjuX6m66B7TKcTBfaflJ7k8SoU4nCSWCxSr6jsKMZrvIWYZ7xz7KOxz0w0DGeGooUYq6vyD4NbUOY/+y9dSF4qSGoi+BP+VuGRIs9pPzPzM4DghXQuPqSkGsKLbuUSe4LSLC1OeC6c5sbuw6f85ToF2q9+3t8VXoVD2nijOPeG7wrXtnIK7mwvSr59VTtiQ/jpkz0UUIeEvX9x5cQR/LGFMoAzgArp1RyrhropVsuwGs4xA5MZh93f3xQL/Ko0W8s+R/a9Xbbwgohqb0s7FrrOVm0CNTk5OYhYF0HEg/e3t8BFaQyfGCZdyAv4fAvlo2ES7W7Rv3R8hqihFukBNPEk9aqMwmENOdEp03tfdj2q1Ky91b7QdJ+Od62BVzShPvUqTcLc1+/RJBNlQh/hrcE410k5h2JuXe0EaPRFLhFbLrhU5/NkGrJN40=
x-ms-exchange-antispam-messagedata: mHhPh199kj8pGesAxVpFc4LxFZsp76tTNMBfWiSeGgNoTRjFSMVd4/FGP9QvF6nvbA8THgslRRyDAzemkuLpbfpCgQ4cLg5K4P5JgmsfoPsN19WQPaXMVg1kWPFcLHGBNKaoAZcyFeZ+BDjQaAVURA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300a4ab6-9f38-4742-3377-08d7a10ae78f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:20:50.4979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4gDxz17Ccg/eS7hYPq7NUZbVD2M+UZjSaukv1G3ACxdfkUrA+PdEJQMPDOylvO6eF8d1S7yhDtEhGOJPXHa3Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

Merge conflict: once merge with net-next, a contextual conflict will
appear in drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
since the code moved in net-next.
To resolve, just delete ALL of the conflicting hunk from net.
So sorry for the small mess ..=20

For -stable v5.4:
 ('net/mlx5: Update the list of the PCI supported devices')
 ('net/mlx5: Fix lowest FDB pool size')
 ('net/mlx5e: kTLS, Fix corner-case checks in TX resync flow')
 ('net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path')
 ('net/mlx5: Eswitch, Prevent ingress rate configuration of uplink rep')
 ('net/mlx5e: kTLS, Remove redundant posts in TX resync flow')
 ('net/mlx5: DR, Enable counter on non-fwd-dest objects')
 ('net/mlx5: DR, use non preemptible call to get the current cpu number')

Thanks,
Saeed.

---
The following changes since commit 623c8d5c74c69a41573da5a38bb59e8652113f56=
:

  Merge branch 'netdev-seq_file-next-functions-should-increase-position-ind=
ex' (2020-01-24 11:42:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2020-01-24

for you to fetch changes up to 342508c1c7540e281fd36151c175ba5ff954a99f:

  net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path (20=
20-01-24 12:04:40 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-01-24

----------------------------------------------------------------
Dmytro Linkin (1):
      net/mlx5e: Clear VF config when switching modes

Eli Cohen (1):
      net/mlx5: E-Switch, Prevent ingress rate configuration of uplink rep

Erez Shitrit (2):
      net/mlx5: DR, Enable counter on non-fwd-dest objects
      net/mlx5: DR, use non preemptible call to get the current cpu number

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix corner-case checks in TX resync flow
      net/mlx5e: kTLS, Remove redundant posts in TX resync flow
      net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path

 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 49 +++++++++++++-----=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  9 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 13 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  3 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   | 42 +++++++++++++-----=
-
 7 files changed, 80 insertions(+), 41 deletions(-)
