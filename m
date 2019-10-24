Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F755E3C15
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392918AbfJXTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:46 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387655AbfJXTip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hux8vy4+ubzr2gmoKUoA2FUA1gAFS3ATKHT1q86ExYcOpR2X5nTihSeT12GhcNmseVAocqlJxeJcPCRFHX+ChhqzlX3mqK1KO2QCd/guhhXNzUUS/XFIA9nTe5FjhQnWbDiM19KoM75d5WzabSaudikrAmRS0BajEa8nCW+wATAxZYtvhZbwtZu8Llc5cDsZSLDdoK/EcGCDMJPkgUv4QtzlV2UbME/C2X0apFq5BA3j6pUSoM4GgQIbAEEuSV8XYNQqzTZLB7Spt+xLoCniEj/QBVN3/+ixTyuog5GWFt6uw23rXeCasYHlsUzBGzXl36V0CFStTCJPuoF+qeQUCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ivwl2kom/edrDKuBeSUkYy0zUa6968SalahAunPGbxM=;
 b=l/9f72rV4aj6Q+qPkO3lAaIxeHhp4spZla1k8RJELeu6L+EuEt08CRbideweNrEifMcevtdeiYdUSwQuADWzUc/ngF4QL2DK0oKGbBMsh1VdiPzQc46TA+/+DC2ANdc7nndagL7wXCTHs3h+xQJQbys1giMT1W+rpnqMFtwHST++aZDYGpEhtwyqVd0Wi0zC6XZrTjAYTtR6lWvENLSZTwc92ppjtfOXlj6HQj/dBXiAjTajfix3Yag7ynrh+dsrhzKjAt6aFoQfSers01HwXZ0KduAuocQB9Znw83ZTyYsaEkDcFtzTGFXjSoZ3+rPJNoYziqPK2xr+kXYJ05b7wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ivwl2kom/edrDKuBeSUkYy0zUa6968SalahAunPGbxM=;
 b=ff1gREr/RgmhYPhhYHgVV0/eK8HRRj71QxnDBw6h0YP6I3sAzdFQ3bcyZikV1LtP+aWGVOiEGQ5kGLb84X5Yq9wQarojwUTqDIxKOu/QWu6YQpCG2wrhkn/MUD/v6dz4s+ulmbb2vlET3JcJxDS410CGv9medOOBsw1emtb4LQs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/11] Mellanox, mlx5 fixes 2019-10-24
Thread-Topic: [pull request][net 00/11] Mellanox, mlx5 fixes 2019-10-24
Thread-Index: AQHViqKjPbBYefj/pUKzhKJ6P431ww==
Date:   Thu, 24 Oct 2019 19:38:40 +0000
Message-ID: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3696972e-3503-4e3e-c1f3-08d758b9c588
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB462315295873506402DEB3D5BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(4001150100001)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(6916009)(26005)(107886003)(6116002)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ue4cSsFK/2z9+ilUCs2Is7cGAS/fEW3lEwcqrhIThBwKerlnJaoT2/52uxLsTZjYYgkFe8xxRX1A2V6InK7DR7nU0n599YNozhdUT2j8lNLyBk2wWwo3Uuu2nCWC6w2meEWo52RYmgXYTFT/G2CRY69t9Is/Uui36cpIZIodKdu512KrPb6k0lyoUiCoCj3aRkZ+B/5qckl04zRM5VA6RyGwgIjNOGrGoqh6LUtTDKT0CcmkZ14ME/tg5+IYew+0opwPmv03BcA+VNI5WdLwfD/tHJl/2SPas+1L6hDX8AYc/r2QCbYvCVNrycC18GM3rWql+UoB7b2ILacnygxeqOQ9jcPOnBl9eiygbIgUb40bws88ne0marj++hn1ehjFqoaKi5ZrF5KgmOahIwQpOvsJ5B/ckcbnyokgj16nX+NsLIWGqhwQvUNhR8+WLvjp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3696972e-3503-4e3e-c1f3-08d758b9c588
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:40.5171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kg+P9Mn2i9J9pErJy3FHxYfH2z8ZNqHq90qYGm2gX65Oh3JBMlAXMCFB1cLZJRrz2PWyyO9jQUDhRZP1c4UvpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces misc fixes to mlx5 driver and a Documentation
patch that adds a missing kTLS counter documentation as requested by
Jakub.

Please pull and let me know if there is any problem.

For -stable v4.14
  ('net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget')

For -stable v4.19
  ('net/mlx5e: Fix ethtool self test: link speed')
=20
For -stable v5.2
  ('net/mlx5: Fix flow counter list auto bits struct')
  ('net/mlx5: Fix rtable reference leak')

For -stable v5.3
  ('net/mlx5e: Remove incorrect match criteria assignment line')
  ('net/mlx5e: Determine source port properly for vlan push action')

Thanks,
Saeed.

---
The following changes since commit 76db2d466f6a929a04775f0f87d837e3bcba44e8=
:

  net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag (2019-10-23 21:44:=
44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-10-24

for you to fetch changes up to 9ad36363c018eb60f39d20b5508d3dfae9ce07a4:

  Documentation: TLS: Add missing counter description (2019-10-24 12:35:47 =
-0700)

----------------------------------------------------------------
mlx5-fixes-2019-10-24

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix ethtool self test: link speed

Dmytro Linkin (2):
      net/mlx5e: Determine source port properly for vlan push action
      net/mlx5e: Remove incorrect match criteria assignment line

Eli Britstein (1):
      net/mlx5: Fix NULL pointer dereference in extended destination

Maor Gottlieb (1):
      net/mlx5e: Replace kfree with kvfree when free vhca stats

Maxim Mikityanskiy (1):
      net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Parav Pandit (1):
      net/mlx5: Fix rtable reference leak

Roi Dayan (1):
      net/mlx5: Fix flow counter list auto bits struct

Tariq Toukan (1):
      Documentation: TLS: Add missing counter description

Vlad Buslov (2):
      net/mlx5e: Only skip encap flows update when encap init failed
      net/mlx5e: Don't store direct pointer to action's tunnel info

 Documentation/networking/tls-offload.rst           |  3 ++
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 12 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  5 +++-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  | 15 ++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 34 +++++++++++++++++-=
----
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  1 -
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 22 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  3 +-
 include/linux/mlx5/mlx5_ifc.h                      |  3 +-
 11 files changed, 69 insertions(+), 37 deletions(-)
