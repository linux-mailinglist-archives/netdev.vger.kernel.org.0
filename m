Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044E686B58
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404588AbfHHUWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:03 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404281AbfHHUWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1iEe/JJmY6zrWPERPdezjdfLfd7I80dYxJPRH4efz7l/ycNpfOS1TFRnGGqvg6gkBEAocqZ+q4Q0U90Tc/eh0atRPAEzdjHHWVBtG9PLoRFOgoK9HLXXa1A3kBOdfp3geAdNAw6W/G4cGPUOBnqG6DdHSJAUtoNy57w7fcrbgjVEcEhuET/WRkOsOcFDFw5Ew0Flinv/YtswqhgqPfPnZAPelkwLOWo6fsjYzNLoObNxTvpL3FS1Oq+d3tEEH/yUICdtAjL7QdnN5DnzJQZ8wVWwcGzk3EHAb+pX08m1xjZT4Q5fVdRFCQNzYnblqWlhN292yGfBnXW6ot84Fbo/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydXBMVbpB07CG5sQmBqmk9aWecjEwZ7DMCGUMFQeUfY=;
 b=JYAzCsA0as1wA6p1FIfPE7ijvDHuYdTeEpZA6Mo1aY1gPgGTdap128yPMJNCfHBlYpG8PXdIzyWJTWMehSeqkXs3ieFL6qYGHlnjAzWBQ0jneqVxZT7aPeot+8bOkKMddxhIjYZoYBemH/ECfN1weAECfxcmN9nyDJBUqnUkEOB1tmgAnLAUxWyqv3xlS3TT2yJXQ1nLajy1CTYDafNoY8ACmhxOB1WYfM4b44scWe1ddn+8qfW2y6V4Bk6QAl5GVNRR3K65YpSwcpVwQpUHW7x+25WXYhgMNh4ZNiSqEB0GNErkIEbTKtV8sbCgE3Oz8nTUCZWUqND7prmYHiUkzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydXBMVbpB07CG5sQmBqmk9aWecjEwZ7DMCGUMFQeUfY=;
 b=fzBfvFAHQm4y/qhbkCGykrrGbMX36OXDXV4vMJKPFMlioP03uh+R3XGMuSnzIe82M+NA4p1LR+mDFy6M39pxFenzk+EgjbyUNTx9lS2xz3piX8/AEld6dpoEsjmN6aSBWq6OB4c3c4paJmHJ3pBsjDr76b2HRjxyRg3vgd5zOQA=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:21:58 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:21:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/12] Mellanox, mlx5 fixes 2019-08-08
Thread-Topic: [pull request][net 00/12] Mellanox, mlx5 fixes 2019-08-08
Thread-Index: AQHVTibtdhkUYKv5NEyHzrrba6zcFA==
Date:   Thu, 8 Aug 2019 20:21:58 +0000
Message-ID: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 207b8fae-3d17-45f0-e701-08d71c3e101f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22570542D72B0F61215EB663BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(1076003)(256004)(476003)(486006)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WFapVOsAkESczl3XLHxjfe/CpD43qhk+IgXp0G+3nLhBvQGH1aaw+fO6+QzDOr+1qkWM1UpPdHcd34iQAvqrit+q1H2/c36R5wmgLaSFuF1ZnmhXFL2iZcx1/3gTZulPWN7PsLooVh+weR816kykk8Rfzig9D4iQEPyDCDocElDK4OqSyNT7EnVpjOTFcee8mMZ7+H3+wnfIcfKI+CaUSANMHNZCJAnOH5/M/PpJ3DwMxCxfrevS5vD6fEvG50xys2+ZtMxM9b7Z08iqkq8i3bmkY9rQUAggHqnzXEJJzVWFL6YCz1BejXjuS7PYAEpD+za9GjT0xG1DEOfmkopoyBDSV7vyGer+Z6Fjcbpxo0T0y2WgLzDF8yrZ7v3nF6/xtRHIfs6cpJ6GXDvKF9PjLGLUrU4aChNwjlk5OW6jZjM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207b8fae-3d17-45f0-e701-08d71c3e101f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:21:58.5558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uR1TYM6tHl8CXP8NbVtppMJuIdurcrsXXoSYQnyZOiqGwNBHZlZEnZA2BFPxhTeOMCHIo5q+SIFj9Fzm8w0J0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Highlights:
1) From Tariq, Critical mlx5 kTLS fixes to better align with hw specs.
2) From Aya, Fixes to mlx5 tx devlink health reporter.
3) From Maxim, aRFs parsing to use flow dissector to avoid relying on
invalid skb fields.

Please pull and let me know if there is any problem.

For -stable v4.3
 ('net/mlx5e: Only support tx/rx pause setting for port owner')
For -stable v4.9
 ('net/mlx5e: Use flow keys dissector to parse packets for ARFS')
For -stable v5.1
 ('net/mlx5e: Fix false negative indication on tx reporter CQE recovery')
 ('net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter')
 ('net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off')

Note: when merged with net-next this minor conflict will pop up:
++<<<<<<< (net-next)
 +      if (is_eswitch_flow) {
 +              flow->esw_attr->match_level =3D match_level;
 +              flow->esw_attr->tunnel_match_level =3D tunnel_match_level;
++=3D=3D=3D=3D=3D=3D=3D
+       if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
+               flow->esw_attr->inner_match_level =3D inner_match_level;
+               flow->esw_attr->outer_match_level =3D outer_match_level;
++>>>>>>> (net)

To resolve, use hunks from net (2nd) and replace:
if (flow->flags & MLX5E_TC_FLOW_ESWITCH)=20
with
if (is_eswitch_flow)

Thanks,
Saeed.

---
The following changes since commit f6649feb264ed10ce425455df48242c0e704cba2=
:

  Merge tag 'batadv-net-for-davem-20190808' of git://git.open-mesh.org/linu=
x-merge (2019-08-08 11:25:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-08-08

for you to fetch changes up to a4e508cab623951dc4754f346e5673714f3bbade:

  net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter (20=
19-08-08 13:01:20 -0700)

----------------------------------------------------------------
mlx5-fixes-2019-08-08

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix false negative indication on tx reporter CQE recovery
      net/mlx5e: Fix error flow of CQE recovery on tx reporter
      net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter

Huy Nguyen (2):
      net/mlx5: Support inner header match criteria for non decap flow acti=
on
      net/mlx5e: Only support tx/rx pause setting for port owner

Maxim Mikityanskiy (1):
      net/mlx5e: Use flow keys dissector to parse packets for ARFS

Mohamad Heib (1):
      net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off

Tariq Toukan (5):
      net/mlx5: crypto, Fix wrong offset in encryption key command
      net/mlx5: kTLS, Fix wrong TIS opmod constants
      net/mlx5e: kTLS, Fix progress params context WQE layout
      net/mlx5e: kTLS, Fix tisn field name
      net/mlx5e: kTLS, Fix tisn field placement

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  9 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 19 ++---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  | 97 ++++++++----------=
----
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 11 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 31 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 12 +--
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |  1 +
 include/linux/mlx5/device.h                        |  4 +-
 include/linux/mlx5/mlx5_ifc.h                      |  5 +-
 13 files changed, 101 insertions(+), 109 deletions(-)
