Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35F065FC6
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfGKSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:13 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:8419
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKSyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwAb8ATDJPHMsE/eXvem1nwGCypT8E5zbekIW9OfF86Pa3ElrzAak8+lr00yqBGswt5I06iqn+CWqet/ps14+nCjFA55j+FR1AV/M5XtXwxZxQC1cqRIW7vL57e8T5TYyESb/VUhNZDJpbLN1uUXDclc5TUHpq4edjgbYubjfnPsQXONBVYQ3RTcoHqIshod/xieB8QuP7rMe8Fj10dWapkVIuvGReds6+RZjs1lyKuwsOYfg6+uowklXryV6YtWbvIzafFpyRbEDuYiDMI4J00uYHxdsE3bxb8S6O4njGGgJM2kxXDIYXdXxAr/ONxLFrcYBP67qHs2K8ATfU8OiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMowyONnRuIrNqxZY4Too7mSpVihYvgXHbCkNuA+X5Y=;
 b=LZYQIs9PWDlg0j+GmHofjFVi3cn0rvWR5LyMyL0JJeD1ZiYkerY22phCEqU5RAZoF5+eV/BMiUsp0+Juc+j894Qjld3+juJ+cpdXQ3119E/iD0G9nyCjXE0lBuNn5Dzh4D0h1MeTKydqmJSayD/h22HotCtnrtO31Fv6owJCEvULXi8swuMFxLdScNi6soHdfDjfwt/mcIKWJ1zpc985F8fv3/oVXtMcZbMXEIRjQl4/OFxp+PWm1LJJ0wB3mgDlzQjzQHoAUr7hwYpmC57J0a4haRqJbdAcglXswfL+s2kbNYYw2LPKQsZa1Uw3r4JRUz0e1WVFtiuBJEGiBbrX3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMowyONnRuIrNqxZY4Too7mSpVihYvgXHbCkNuA+X5Y=;
 b=jONRktsZKaK3iL7mUc+Wpa4XmF/9s5TsU0wyLgssnvketLPHO5cGtztLT7rHpcAcPpspdr2gH/Rcc0tm6BmIOSQC7jaikfQHebhyi+fTwjbuwuvZFnbWKz/s0AYfT29VehUOHMwfQ2poK9z3NiKS63ZkK8sab62rr3+14npaCCw=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:08 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/6] Mellanox, mlx5 fixes 2019-07-11
Thread-Topic: [pull request][net 0/6] Mellanox, mlx5 fixes 2019-07-11
Thread-Index: AQHVOBoFhMRBKT2DRki1gD3MIiF5EA==
Date:   Thu, 11 Jul 2019 18:54:08 +0000
Message-ID: <20190711185353.5715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 971c42da-ba52-4bea-3121-08d7063127b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB277073E008F0A2866FE2361EBEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(14444005)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kOYg97JF6ElP86hYCyPm3vmjdQ2jWNQFpoF7YJbP2Tx4w3vhoFEbRDJ/BPDsNxbCwMWdnB9x/jv7YK65xeQuATessxKqcr0TZql65Amtvd71FxP/iB2ml/QHL9fuOCzWj0UY2jiQ/o/Hjv6OhpER72Vo77sEtgAkOde8+yuiOV1KogIwSk+wcP/scU4OfJKhlF1wi4qnko979vk40rogxY61KqQvVQsbLGQv6lVRwEQMpH0H0bOpyLUf+C2gl3Ha+v/XujcE30i3yRasJ7wUxzfSGyzO8LRNe2R3BRI4v1WbEMDO7l9xaKS8j29KKUKziwLjDJCzV8CL4USzo1zCK51GLuQzwjSLudrHGUMAh9Ru0DKnkvw88KVYUvoqkBTPxWwz2tSSVaBCQh/0t6Tmik2iFzEq5h85UAdueK2j2Tk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 971c42da-ba52-4bea-3121-08d7063127b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:08.8614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.15
('net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn')

For -stable v5.1
('net/mlx5e: Fix port tunnel GRE entropy control')
('net/mlx5e: Rx, Fix checksum calculation for new hardware')
('net/mlx5e: Fix return value from timeout recover function')
('net/mlx5e: Fix error flow in tx reporter diagnose')

For -stable v5.2
('net/mlx5: E-Switch, Fix default encap mode')

Conflict note: This pull request will produce a small conflict when
merged with net-next.
In drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
Take the hunk from net and replace:
esw_offloads_steering_init(esw, vf_nvports, total_nvports);
with:
esw_offloads_steering_init(esw);

Thanks,
Saeed.

---
The following changes since commit e858faf556d4e14c750ba1e8852783c6f9520a0e=
:

  tcp: Reset bytes_acked and bytes_received when disconnecting (2019-07-08 =
19:29:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-07-11

for you to fetch changes up to ef1ce7d7b67b46661091c7ccc0396186b7a247ef:

  net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn (2019-07-11 11:45:=
04 -0700)

----------------------------------------------------------------
mlx5-fixes-2019-07-11

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix return value from timeout recover function
      net/mlx5e: Fix error flow in tx reporter diagnose
      net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn

Eli Britstein (1):
      net/mlx5e: Fix port tunnel GRE entropy control

Maor Gottlieb (1):
      net/mlx5: E-Switch, Fix default encap mode

Saeed Mahameed (1):
      net/mlx5e: Rx, Fix checksum calculation for new hardware

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 ++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  5 -----
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  7 +++++++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  9 ++++++++-
 .../net/ethernet/mellanox/mlx5/core/lib/port_tun.c | 23 ++++--------------=
----
 include/linux/mlx5/mlx5_ifc.h                      |  3 ++-
 9 files changed, 35 insertions(+), 33 deletions(-)
