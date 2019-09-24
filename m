Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D58BC50B
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504335AbfIXJlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:41:23 -0400
Received: from mail-eopbgr50049.outbound.protection.outlook.com ([40.107.5.49]:13184
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504288AbfIXJlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:41:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8uOYyG+yRuAx31LMm+KNeS8P3EDHBV/GqhfiabfVfwQtCNKXd5JKKAqzCD4+qvBkh2AXcthjZwri/VBBpFTIcN3Oq7BO5cteDb999jQ1auPwPgDYd5PqhSg5f0KF5u5JMbzVBCsR1kaqU1h9EBzq91L6+wyuwlyb1mG699rVqGSfzW0SSA0ITWbgulauwCvil7oSmmm9hO5Vgd7pofRjx+AI/dX/S7anBC5qQumrnwAguF2KTQ2QLAQBnHzbzGofOtvx/Ja+Zj4vjOr85TPbAznKo+i8KwaDlqFQ7KtlsBAh9ZFsSdktM30/zv51A2c3MfnXE38dZGSGxtZN1XMwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQB1aZQ8TzPY4dI6d8vEtkOwY90c8dWSbLVAD+jHQ+g=;
 b=L+GcLQov4UyjZ5iQ8eG6J2JHb4Jzjsn6wEpMPqP5ak22Q/9Mzf0nTrJV0olDmxc0LUTy/U7jB34lD2x+GHNHy2Xvkhko/xJlC2cIyI7D41KtQhZ3C+PY2PoZXBF+jPa2FwT82Zf4Q0sRO5f09pGSbw4MM4n2BeCUSUtxj9W3A6ae4kVYMDE6DU3S9ZPikiILxUaUmFBVwztB9fYAYJQoEIkRRaDxEF7c7j3VeIAUsWggW6maPxKr04qw5fSfisVW1Pby9/sS5mOHJ/Vfdp2iKiI5wdQ5GfsWUnFrDIMGCzUQjPAo6F/7AOmEORkz8qm+Jkqlpnty2HPEr5QMT5BASA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQB1aZQ8TzPY4dI6d8vEtkOwY90c8dWSbLVAD+jHQ+g=;
 b=I7ZroJaR4CcpO42JqT0EKKAUHrceszNzrEBVxo5vyxPYXWV+uUR7hP0QrOz/8ulY4vMYxvWxBiGBBzlkI1EXKTKhDrRDbjVwD+HLegcPzvTDKLYML2EX9D+knvOm6Qu8sC7x6JPCNpLkOs0O+3ttgr5+eqXoesAY64N2wqiBtjU=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:19 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-09-24
Thread-Topic: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-09-24
Thread-Index: AQHVcrw3LhU11gL9q0K904XWKmy+0Q==
Date:   Tue, 24 Sep 2019 09:41:18 +0000
Message-ID: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66bf501d-63fa-4a53-d0e8-08d740d359a4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB26716B4EA21057DCA2F98591BE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H1D4H25YxUNraXDTPBU/+vR/YQu+gt02yhGDBcqOX8E5T0+rlJft4JFKdSm9GMkO1XHnTyshxWNVi/2uxs8NTLmr2kVutisBBVoiq9obsd8mLf0XOBaEAL61NecYZvTLngpvR/1/pq6Vg6bHhL1kkBS/2kPtUWNtIEIyEN/u9RgiDoG2Uq7Y3v4ZUVg93gxnzM1mX396eXtOQVj5wOaWTZroCc06S7gbjmpw0MufHugVvxUzBI5x2fEScxJpVewtLHUjc2iGQHK4w4k7fzXnjwVpJr9aE1hQtSQIrb8UmVVhm2ZCCcxNAs+L4/o9s2W2qgTvgnJo5XaQaoLKoPauJxOsk/8UzQHGgJW/sizhtqdnZ9UgQMnkaS/DlnfkPUWeGjN3fskpqdQpsbXmlP724ZnxbIGT1lQojabxQgv/GTU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bf501d-63fa-4a53-d0e8-08d740d359a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:19.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eLBD4qQKIwzqmW6sXAur/fdnrszQwSduF3l9OqSrSz/ETIyWSlV89bFflJfdbAX4sgClcdH/HdbEnceoLwJaMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

For -stable v4.10:
 ('net/mlx5e: Fix traffic duplication in ethtool steering')

For -stable v4.19:
 ('net/mlx5: Add device ID of upcoming BlueField-2')

For -stable v5.3:
 ('net/mlx5e: Fix matching on tunnel addresses type')

Thanks,
Saeed.

---
The following changes since commit 34b4688425d9841a19a15fa6ae2bfc12a372650f=
:

  net: dsa: Use the correct style for SPDX License Identifier (2019-09-22 1=
5:25:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-09-24

for you to fetch changes up to fe1587a7de94912ed75ba5ddbfabf0741f9f8239:

  net/mlx5e: Fix matching on tunnel addresses type (2019-09-24 12:38:08 +03=
00)

----------------------------------------------------------------
mlx5-fixes-2019-09-24

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5: DR, Allow matching on vport based on vhca_id

Alex Vesker (2):
      net/mlx5: DR, Remove redundant vport number from action
      net/mlx5: DR, Fix getting incorrect prev node in ste_free

Bodong Wang (1):
      net/mlx5: Add device ID of upcoming BlueField-2

Dmytro Linkin (1):
      net/mlx5e: Fix matching on tunnel addresses type

Saeed Mahameed (1):
      net/mlx5e: Fix traffic duplication in ethtool steering

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix SW steering HW bits and definitions

 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 89 +++++++++++++-----=
----
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  1 +
 .../mellanox/mlx5/core/steering/dr_action.c        |  4 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 13 ++--
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 50 ++++++++----
 .../mellanox/mlx5/core/steering/dr_types.h         |  7 +-
 include/linux/mlx5/mlx5_ifc.h                      | 28 +++----
 9 files changed, 119 insertions(+), 79 deletions(-)
