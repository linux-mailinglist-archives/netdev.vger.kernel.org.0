Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBA0EB81C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfJaTra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:47:30 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:11479
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfJaTra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 15:47:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDP4TU6KSXmr/y9Hee5dTYXMVQqGSuoAm2QJyjlPqQYzS7kA3cQkO1DHJa6kmEOpGtGyvoRGvMcf3Yyi0Rp0X1nEI6jBVWGmEJYNvtm63jNLAG9HEcbc4fW2f7Ml+gM5tQf+k3p3T+BRUR2j4MwJJQh01aEBQgbXO8dhDH69GMsdW1jFqbUCcP3+byw1LnHRQZZVAa5snXDC3Y+JWrWCTsQv3A5MwSk33xqz2YhpZGN1KEcBjJYCkkLGlimsGqinBmiLznzu8vL1C+tXEfPeBAg3yjsnYDIfnmNTEDNCWb+/cfvBkvNBQMInjSO2cBJuDaLr/GI/3M6f6rK3QghAkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHIjYuuBexgDVyvISJdcwr14xKzM/MsaA3GTqjGTqUs=;
 b=Oj8rcLTKVoIF+5wYwUwP0lQueR2LCHYjwDubvXUiRvihBWi76mpB6pw2ym4FjxM0LYloXLDL1V0BWrygi5T6+OQLzcE0PC++euxDeI6TzI/RXeJAPWi+qlsQIH722tMwEjtbGxCB1UaqhmIyls+e1QEgcPfIJR7diod2Vs2aJm6kigIGVujd+cp8yTc4NdBQXBbv+J+pnV6Ct3hV3cTtc5UwUka5A30zLI3L0jemfgtXMd6qz3gUysOiK1apvuWneisOXEoxssvDSUYvWEe+KqV4IqXJPVw36DSAFkebl+icslLY21vENb2znzzYThTNMlhioxQqjNxuD7hIqC4YpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHIjYuuBexgDVyvISJdcwr14xKzM/MsaA3GTqjGTqUs=;
 b=cifrKvfrTN4noMwOZdgN3evjeH7/t3ugI532xrg+pMDuIq3b4ztVGAFlaBaSQq6ytr4ct4xsS3P51euuh9DpcUPF3Mvk9TQen3V4bgOxaNToiMCljtsXxnx6f2Epp9xV0zTjMkzxA9qqf0pF4IH4431w6A/4l5WNXF5xzpeHoNU=
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) by
 HE1PR05MB3324.eurprd05.prod.outlook.com (10.170.242.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 19:47:26 +0000
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385]) by HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 19:47:26 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtA==
Date:   Thu, 31 Oct 2019 19:47:25 +0000
Message-ID: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To HE1PR05MB3323.eurprd05.prod.outlook.com (2603:10a6:7:31::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e3a8e308-d217-475f-7902-08d75e3b2764
x-ms-traffictypediagnostic: HE1PR05MB3324:|HE1PR05MB3324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB3324AE23951652C68FFA9372BA630@HE1PR05MB3324.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(189003)(199004)(486006)(107886003)(8936002)(5660300002)(6506007)(86362001)(99286004)(2501003)(386003)(6916009)(25786009)(102836004)(50226002)(4326008)(478600001)(1730700003)(36756003)(2351001)(81166006)(81156014)(476003)(8676002)(2616005)(3846002)(14454004)(52116002)(66946007)(6116002)(6486002)(186003)(305945005)(71190400001)(66446008)(66556008)(66476007)(7736002)(6512007)(256004)(6436002)(14444005)(66066001)(64756008)(4720700003)(316002)(26005)(2906002)(54906003)(71200400001)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3324;H:HE1PR05MB3323.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RK2aV/L3XvwDCzTWpugGg2FxmpZh/mJ6IEmcTVwT6qz5PAk9Nro2VMBFHxssm9BT0PBfhY/WmAogT/0Gm5agePTWE6Or55RmiqsPt4+amQFUg/QANtoXWKJFE5LNJleeey+mnRA7A3VqdZJ1gfbZlcTZ0MPC33nnJdsscxR4kzPhszmWBkAc8fUEWqUA+9tDdmaYtq/SQqbBsRDNM6BiWx39BDUCMmP4rZYhffUxO+EW+Zs2IxZiLdShYvmMix3ZsQxXfLZmTfpcS0zZ3fNIFP+r3hBf9rv0cwCF2Sl8jTowge3dd8uiI20w0JZDOqmtC7o3CvsDVpPt6kVYAPcq6O+OwULb+xsFYTTKrJnd1O2Mf6nmL2JFZemtqdlnc04m3Se37vbi4sNrlbxzS7Nir5bsr9R/YjdMbcLOKvgdr0/DuqMazmUJE38nJECX6DCm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a8e308-d217-475f-7902-08d75e3b2764
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 19:47:25.8988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jjXGJ4rD9speS18zVcvATVz5md6WM1ITeeTc5yEeb/Wb5t7CdhfwjmK2rMwvYXOgftCScQY7buwRcI3ArHwCwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series introduces VGT+ support for SRIOV vf
devices.

VGT+ is an extention of the VGT (Virtual Guest Tagging)
where the guest is in charge of vlan tagging the packets
only with VGT+ the admin can limit the allowed vlan ids
the guest can use to a specific vlan trunk list.

The patches introduce the API for admin users to set and
query these vlan trunk lists on the vfs using netlink
commands.

changes from v1 to v2:
- Fixed indentation of RTEXT_FILTER_SKIP_STATS.
- Changed vf_ext param to bool.
- Check if VF num exceeds the opened VFs range and return without
adding the vfinfo.

Ariel Levkovich (3):
  net: Support querying specific VF properties
  net: Add SRIOV VGT+ support
  net/mlx5: Add SRIOV VGT+ support

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  30 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 600 ++++++++++++++++-=
----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   8 +-
 include/linux/if_link.h                            |   3 +
 include/linux/netdevice.h                          |  12 +
 include/uapi/linux/if_link.h                       |  35 ++
 include/uapi/linux/rtnetlink.h                     |   3 +-
 net/core/rtnetlink.c                               | 173 ++++--
 9 files changed, 717 insertions(+), 174 deletions(-)

--=20
1.8.3.1

