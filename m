Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B357A131C71
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgAFXg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:27 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726599AbgAFXg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtyLctKWx2fB1Tb5gZ1jefM4BI5sXP5vWcLGp42R9X7G3V+CWX4NpIREMmaJdjzJVIF84N2gxOpL/tYYeyuwbSdkDX+0oHVzvi7kxcXeOaYL7f6FJO70VM3rgOIiDuUluc9Mhlg1PnFpPaaII/1jmPRuugqMijZzyqkRNtjAG+h3K4Ss9HzmWD5TZz6XbtK0b0v53gDvOKf7qoo/PWtpiitJEym3J2NFiCiAT8xE83WlcQafQFIPCX+b/7fBujyK32NBZtTyvJjyq6e+YcLuaho+QfzwKd2e/QM+YSladcgXBkFGvHh0Pdb0qitJsqC5oEl+xLrCb5uQGU7QsLGQVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsyZkbL5ncfKZvptAGRpdx3Ir243nNzb0ysomf31RY0=;
 b=cBzGbCOhS83XElmvJuJon2kfFyKBuS9c20XS+C2PoRaDC1l8qBGDrgJhUuyBf9lXLQcOo3PjCLS2qOrsdzh7o6fHyjAQ7l2/d6owJg7adsQ7isNI7F7Ku9ymEFcQ/jKkBygPJkhJZ5NQ2DlrNMdwge8mQhAVRq1cNrVKwBztNkL3JDpeVIS2Cn7JfGJ0Q+1WltYNnbsFRF5FxxCXR5AJXuNMDlQJvj8z4BNfB8MiVH6+j7eo6ZyIZTlNARkoJ5sTge8KmvxIHVrJLvwqxb0AZZZoFumPeNK973EnPShE0WdaPq8h68u9uouLkR49fs/R0adyn37nRdeBDGni4UaHDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsyZkbL5ncfKZvptAGRpdx3Ir243nNzb0ysomf31RY0=;
 b=lROmfOq6jTs3ov4YBkpPqPxc4nL60fKQe3iIUaoIBYYeACJ0wL8DTHsmG9sHaPir/759fcTyAANi1ia1Je4dIol9X/TbVjhWKdFm1DBxQOSnLe5Yo3JDjuIaEIrlFALd4RodEyA9y6m3CEMECvdYJtBk1bXuLohp5AY6WJS/lSI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:22 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/7] Mellanox, mlx5 fixes 2020-01-06
Thread-Topic: [pull request][net 0/7] Mellanox, mlx5 fixes 2020-01-06
Thread-Index: AQHVxOoaE5zSv1d2Mk2eRpdSALoadw==
Date:   Mon, 6 Jan 2020 23:36:21 +0000
Message-ID: <20200106233248.58700-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa0ee740-89cc-4148-ff78-08d793013c8f
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6397E5AD15493ECBF6187818BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(478600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(316002)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fr/Ck/sQz76iWFC38Tc+ECZpD/t/eeQOnUXmA0I2DT64fYEByP19kvyaoBvqhJaDmEjRNN41/xjFdYPpRxSYl/nQSkTjOovD4s+rX68aNtrbDVWzPB1t7psKiLzbAuqZbCnkUZebtgmwx70Gdtjkl2vvZnEsDzyGpFSsVCGy8DF+SEwogkHq9jxlKn4BdK/7s/QiKWinpJ4+03yhvaI77PaYwEqRvhhsJgtneUWvJuhqizxjhNx0V9NRS+pmgcA+wxpQkjYwz4ATfmnCPhiyGF4zET46TW4ovvhJi21RkoceLd8+IrTSBpSuva8gTLDbIiQ9dAja9WmBzHs6Cer6iphEmbJDEW4n1+drco8GF+DCxGNTjGYELYCvMW6X4xmfKusFYb9kKmLuODrjl52dOLF/KTSzrxfoFce4IVOC/njninwQATQLNe/abrjVOe7qbv28SSo4UZtqYNqgZFVxywViyxGHfhLCMUfmjPwRYsZPy3Pq9Nc8ECxz3KtF2A9H4L3OChJES2m5EbOehnCKEQ58FtfQ4LQ/rJ4HaWpE8uc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0ee740-89cc-4148-ff78-08d793013c8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:21.8893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SRFlqWCeze3ZJiWskVnDOnsrW5CYDx9W76WNKVZyzOWNTxprg5+WZPlO9U9TcclmO8EkSVHjYlNKDBA8TZKSGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.


For -stable v5.3
 ('net/mlx5: Move devlink registration before interfaces load')

For -stable v5.4
 ('net/mlx5e: Fix hairpin RSS table size')
 ('net/mlx5: DR, Init lists that are used in rule's member')
 ('net/mlx5e: Always print health reporter message to dmesg')
 ('net/mlx5: DR, No need for atomic refcount for internal SW steering resou=
rces')

Thanks,
Saeed.

---
The following changes since commit d76063c506da79247e626018c9ed0b916d78f358=
:

  Merge branch 'atlantic-bugfixes' (2020-01-06 14:06:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2020-01-06

for you to fetch changes up to df55c5586e5185f890192a6802dc5b46fddd3606:

  net/mlx5: DR, Init lists that are used in rule's member (2020-01-06 15:30=
:05 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-01-06

----------------------------------------------------------------
Dmytro Linkin (1):
      net/mlx5e: Avoid duplicating rule destinations

Eli Cohen (1):
      net/mlx5e: Fix hairpin RSS table size

Eran Ben Elisha (1):
      net/mlx5e: Always print health reporter message to dmesg

Erez Shitrit (1):
      net/mlx5: DR, Init lists that are used in rule's member

Michael Guralnik (1):
      net/mlx5: Move devlink registration before interfaces load

Parav Pandit (1):
      Revert "net/mlx5: Support lockless FTE read lookups"

Yevgeny Kliteynik (1):
      net/mlx5: DR, No need for atomic refcount for internal SW steering re=
sources

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    | 16 +++++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  7 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 16 -----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 60 ++++++++++++++++++=
-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 70 +++++-------------=
----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 16 ++---
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  5 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 10 ++--
 .../mellanox/mlx5/core/steering/dr_types.h         | 14 +++--
 10 files changed, 119 insertions(+), 96 deletions(-)
