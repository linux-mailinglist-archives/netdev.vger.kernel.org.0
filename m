Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E868C1079EE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVV0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:26:51 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVV0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:26:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F03IBkSUDoIS8iGlTIGAYGuuf+Q6Kcfkn1734RUO1ejAY5dnEW+iT8u54s4+XJHyloeOzgqFPBbkGa5bBw9daTAhtc0KQsakerdhBQjkLuSrmJ6ofi4r732uMbJ5shQ+my1gP2WIPXhhWecsSocUhXqv4aD+HsFV9/hs9oRH22ef9kWe19nwOIGkkQJ3QjnkosC+DEk7yqylaIo2b4G2lpaoj17uhfiONlG80eli1GhCqUfui02OrztB94i+TqNKTIbZ/p4vaBfJ/qAitz/f+AIZuT0fxJKonugogFzNA4NmIHseggTpMTbKTiq2P0H4wOXeG5Bgl8ecE1+ahT7+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVELtszVGOOn1+CDdWHbrIKPiIVps7dwO6QR9eo2aaY=;
 b=X8laTOmT8d4K1TFil49M9wiX324uQU+cpGrWsu8HXLxD8m8MRu9nVIY+VG+CZiCDT5RvIgMOSmcERsLzhp01f7EUE69aNAQRF1Rg6nxY00EehOEsVgR4VLMqlj+eSpX5Dij8rAEv9uQBrzEqXjNxgZC47QZc4KuvFzkheFKUt2o1MjhKbV9XwdSnG4kQ32OjleD5vyzhIarHWqmlrKhckPKc9LMhHCfLvBVf/Bujy9JLIFhI8GTrxO15X1GEfNo27NwAONQ7NrX7MyVohIKKroya0FQdwg+4/LzZRV9hVTaKpV/RvSf5+OPc1+MW2L/a+/Gs4Aw7/i3xjCuOmR2uaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVELtszVGOOn1+CDdWHbrIKPiIVps7dwO6QR9eo2aaY=;
 b=oJroZudPgWfp1/EtpoDvYXpMwP+lOgCINMXb1ARHhUuw4TA+Z3FaSZLKpYi0/XunlW+ayGj5x3AUwAEuklDL5iPOOWXpUTtwaJObB4O82COg2HTE99vF8SEJFCqQtJlGy2ohnvwaPKeaTAClUqBQwqhpYoQu3vcgHiqb5mt8nSo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/6] Mellanox, mlx5 updates 2019-11-22
Thread-Topic: [pull request][net-next 0/6] Mellanox, mlx5 updates 2019-11-22
Thread-Index: AQHVoXuLvL2ZiBz6tE210r+QTVrTOA==
Date:   Fri, 22 Nov 2019 21:26:47 +0000
Message-ID: <20191122212541.17715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ecdb2c34-0053-4a59-4f0a-08d76f92addf
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4350D9614AA9AEAF34B365C4BE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(6512007)(1076003)(107886003)(15650500001)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(4001150100001)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kOUZG2gHi6lNyqdZnLbzOfVCODDZwMuX3j/oC0wk0jb7D4sHPhD1aY6riuR67h7xcHTASaTCjjmBAGgDUUdFlLGkYkC+N5LygI9xCb3viAowLyfMufldblsZYGym0EZ7gS19BLo7atoushogzBmrxciP+a7VJgiilxKcIgkmp9akkufib93rxRWZEfnVP8sELWjaQSHIHQE0f0XpQgLAdXXJM07uft8i+YifRFFlj53uIQx8dfcUB3DajEnwdFmKWwnIPBw3sf6SH/P9H6WuyxKg9Ax6n0QQ05AXa76Hg2OB23G4B3dh0BDZzY8u4xyRJvxxk/SG8Ku201PRqGjeuTAJW0/nxfaWX8tRCK4LsEplsZbn3/2ZI/Ypu3X1zTUUWTMRZQcsP10Oj36Ob36F73WJfv454j23pymKU0BvYszEbQRlm7WPguuZ6NNzdODg
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecdb2c34-0053-4a59-4f0a-08d76f92addf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:47.0705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PfWEcWdFZbmUCeJeyBv+sLetVrUacfHyYsq9BRss6+ezumpzJ1ouqziQCYM5Ps1/kN2bDcI65XZFXiewr8daPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This small series adds misc updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 3243e04ab1c06e7cb1402aff609c83de97956489=
:

  net: dsa: ocelot: fix "should it be static?" warnings (2019-11-22 10:09:1=
0 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-11-22

for you to fetch changes up to 90ac245814abc30d2423474310654d31e3908b2f:

  net/mlx5e: Remove redundant pointer check (2019-11-22 13:18:20 -0800)

----------------------------------------------------------------
mlx5-updates-2019-11-22

1) Misc Cleanups
2) Software steering support for Geneve

----------------------------------------------------------------
Eli Cohen (1):
      net/mlx5e: Remove redundant pointer check

Leon Romanovsky (1):
      net/mlx5: Don't write read-only fields in MODIFY_HCA_VPORT_CONTEXT co=
mmand

Saeed Mahameed (1):
      net/mlx5e: TC, Stub out ipv6 tun create header function

Yevgeny Kliteynik (3):
      net/mlx5: DR, Refactor VXLAN GPE flex parser tunnel code for SW steer=
ing
      net/mlx5: DR, Add HW bits and definitions for Geneve flex parser
      net/mlx5: DR, Add support for Geneve packets SW steering

 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  26 ++---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   7 ++
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  60 ++++++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 126 ++++++++++++++---=
----
 .../mellanox/mlx5/core/steering/dr_types.h         |   9 +-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |  24 ++++
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  27 ++---
 include/linux/mlx5/mlx5_ifc.h                      |   1 +
 8 files changed, 187 insertions(+), 93 deletions(-)
