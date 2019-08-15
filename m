Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A1A8F3DC
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbfHOSrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:47:08 -0400
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:55213
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729121AbfHOSrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 14:47:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QX0Ky3irKula4OaeTigy97QKqR4yyH864KkamXJMV/xEsKgqIAMgoU/VudAZUUtgk7Rkh9619C4lA+dUzNITXY4LMXfQooNyI6fZmupIS8FM2nYNpjU8Og7ougBxxcfh9+d2CTQ9iwoBL6+E/ASdfR1e13ODGolBeIchl8CclQ90fqU+btvD9oOhqgDQtDqsKZhdUNW74qxj76wdp+oi71yyM6j4JsXAc853bnlGbpnGKlNSs3tUjrqBGBRBbsmHOgozAfNWvpCm4ccZBeKyVHnx8B9RntbiHgVSEKfA5tRtQBkZRCLlp31MxaMHZtcVL+d9BxDEM8r/bNw3h+sMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUxboLCDeH3dQduME/Q69VXddCz7CNB7vGiKtF182qg=;
 b=AA2uRYib4CWnu57Gs2kfbbHUWl+S6dJFRC0D4W+H+jWNWkYYJ1O+7YrsyDWP1LK9z5tMlq4b1XMEUIOqbCD4TLwCgNcth9u60uOVGZ9QTKioA7xv38XBFEItItc77smjSMW39uhvQUsVlKcE6xflHF5ee7PNFdv4uMA0ZEC6lQDTFMCDQpaejU51AlvDhT28CRYI5iYDVhkFnnkkEtY0h0HJfGO3IYytBytz8LEfdmUn9/cj7XMSaljGVCe+nWt/1g16GPqZIiOB5MxvDLoCVdjbJlx9idDpcxlwM1jwSAGuqXoWI6LV2MTc/Joqvf4dAATSMzUseoMCBovKXTJVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUxboLCDeH3dQduME/Q69VXddCz7CNB7vGiKtF182qg=;
 b=Ino4atOlkF6bWscaKSoFAGjpdk3sySeCxbdbA5yy5ZNWk0e/bw51EqjQOLiP4TRRS3Q/DcSGVIxnbZSeUKUDi2JWNqDuqgkZD3NIWhoXhFuKSaiemY8XuJNNXpVK8S3BFXQGNphPmPEjYj+d29aWnxWgXdKi/Df7zzYwIcF11A8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2663.eurprd05.prod.outlook.com (10.172.225.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 18:47:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 18:47:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/2] Mellanox, mlx5 fixes 2019-08-15
Thread-Topic: [pull request][net 0/2] Mellanox, mlx5 fixes 2019-08-15
Thread-Index: AQHVU5nUnRNL5auv00yrZCrEOzwd0A==
Date:   Thu, 15 Aug 2019 18:47:04 +0000
Message-ID: <20190815184639.8206-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdf186f1-499b-42a3-cbf9-08d721b0f72f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2663;
x-ms-traffictypediagnostic: DB6PR0501MB2663:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2663F52B4EDFFCB8AE15367CBEAC0@DB6PR0501MB2663.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(53936002)(52116002)(26005)(107886003)(6916009)(386003)(102836004)(476003)(36756003)(478600001)(8676002)(14454004)(66066001)(81156014)(2616005)(81166006)(6506007)(486006)(50226002)(4326008)(1076003)(6486002)(6436002)(5660300002)(71190400001)(64756008)(6116002)(66946007)(2906002)(3846002)(71200400001)(305945005)(54906003)(66556008)(316002)(186003)(256004)(25786009)(7736002)(66446008)(66476007)(86362001)(99286004)(8936002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2663;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kdgpAXfMTtoYRXUgtzeqXklocwrnLu1D8CYga3sTJHhKFgpXOfolEoHNjCsoBfArXULjS/AI0N8Weg/J9TYthnvdFLM1GWYkIXMU1Oot+os1ohRb64HWL0OWYi3aCvA503f9H9OjpotEiN1cuYPc1TvGABIkc+mcKrH4uuWfvLXdgs1sBGNmcZmoWiAp2K7C5+PHeu/JQJz3eLXSLQo1Rmsv8z797rFa/g5tBkFygZ5YeLZ1i5tjtUDar/aMTxaxcXzKSKX/mkRpZR5vU/ikUZWmx2RvYWqcxLe0rUyVq/s4YB2tSu5sRWPsnUnCBFZemvEdvmsGgMo3IrekmHpkrxlZSEx2GDl3eebIco2sMbsLAr8FWO997FL52NSY+nBKXF5g8o8gKjN+72y43d6G0ZUvzveSJb7A+Zw/gxzsd24=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf186f1-499b-42a3-cbf9-08d721b0f72f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 18:47:04.6187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+3DGVpYcO7wPbF23K/v5J1IfI4UbLwCXFDj0fF1NNJJJsX6nzU7f21cYs3FGXhVqjiIEr70lSFExGyrdXmSRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2663
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces two fixes to mlx5 driver.

1) Eran fixes a compatibility issue with ethtool flash.
2) Maxim fixes a race in XSK wakeup flow.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 2aafdf5a5786ebbd8ccfe132ed6267c6962c5c3c=
:

  selftests: net: tcp_fastopen_backup_key.sh: fix shellcheck issue (2019-08=
-15 11:34:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-08-15

for you to fetch changes up to f43d48d10a42787c1de1d3facd7db210c91db1da:

  net/mlx5e: Fix compatibility issue with ethtool flash device (2019-08-15 =
11:43:57 -0700)

----------------------------------------------------------------
mlx5-fixes-2019-08-15

----------------------------------------------------------------
Eran Ben Elisha (1):
      net/mlx5e: Fix compatibility issue with ethtool flash device

Maxim Mikityanskiy (1):
      net/mlx5e: Fix a race with XSKICOSQ in XSK wakeup flow

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 35 ++++++++++++++++++=
++++
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  9 ++++++
 4 files changed, 49 insertions(+)
