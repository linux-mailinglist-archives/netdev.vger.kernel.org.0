Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43978AAE08
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388541AbfIEVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:03 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:28743
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728769AbfIEVvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+Blvr5Rd1LGIkwW21nA007OZIp3tcK4/yiPbEYCIpGMldweWFvb1c19scv8IH3nCR4hXd/Tm6soYi2EX7tN9nLRASu/OY/d8udGZihR1skD+oKx6Akyri2zNQIMBJAVNs4AXQOL1tzjYz/1wvxBYLl3z54PbhmPZnUY2v3x7+p1KqaLnCxRtLuB5z7t7obxWBVic91874kVwucsItE/9P34oFL7bwuwLntSdlRMZhUqqL5X5JciM1M8OW2ZOT++miJkH4CsihlkHKUkcljz7WNzHhG05LwHRl/CwEuVrTmsVdym8oZKaeN2jsh58fufqsJM5O71FMrQbqNDS6aO4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOiXpEByUVyZIcvOjrggLIadtIlzRsLpYyqHZJxVoNQ=;
 b=S2JpF7JdyZJ67QFofK7hyd3bHgtHHzzj9Akjo+gE0s8HDRhbM6i8MnV7IaTTaMgpdemmHkXSAv2vCd3SyKsox5d7vEd7XDoyki0TFXJ5mx2lbsSOAWZUL7g3h6AP0g6IU9FANHOOFh1YbykJ8rWNpJ5QcUEWtdPuf/DHheBD3R8xIQpDOnAktMFzC8Uud97glIjcrIMoAfmojpX8e2SWlp228zuPA4aQvcE5sxUdn5tAHZ6Sccu36mTdNed5SFKO3f4Z6Ehj9YC3sRLi/rHuuUjiZk6DG1Oo9jUNuqoeI4p9Paim+WplHjbFbMfu/2dAnl3DG/4b9yb2e4Ah+PPIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOiXpEByUVyZIcvOjrggLIadtIlzRsLpYyqHZJxVoNQ=;
 b=nnDkDrJgpWyDznhKFUZWXphr3hguPLwx91Freq6qiTqokPAdM4qR3pD4HYXqouhkbcCWjzAW8KrGBtXWYzUBy15P3jGBzy4I3+0NNuQrbNhxhI7CzsN+OoEVGZJ9fPVwdexDUD+ZrnQd1Mlurp1i0GQKn/fCWKAGb49k7TlgyYU=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2191.eurprd05.prod.outlook.com (10.169.134.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Thu, 5 Sep 2019 21:50:56 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:50:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/14] net/mlx5: Kconfig: Fix MLX5_CORE dependency with
 PCI_HYPERV_INTERFACE
Thread-Topic: [net-next 02/14] net/mlx5: Kconfig: Fix MLX5_CORE dependency
 with PCI_HYPERV_INTERFACE
Thread-Index: AQHVZDP+Q0VM7fzVG0+blIHjQTjoPQ==
Date:   Thu, 5 Sep 2019 21:50:56 +0000
Message-ID: <20190905215034.22713-3-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0e030b7-0932-48cf-ac7b-08d7324b213b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2191;
x-ms-traffictypediagnostic: VI1PR0501MB2191:|VI1PR0501MB2191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2191C7D0BE622EB2D01D6CD1BEBB0@VI1PR0501MB2191.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(54906003)(316002)(2906002)(256004)(8936002)(8676002)(6486002)(305945005)(99286004)(7736002)(5660300002)(81156014)(81166006)(50226002)(1076003)(478600001)(6512007)(11346002)(26005)(25786009)(36756003)(86362001)(4326008)(14454004)(6436002)(53936002)(102836004)(486006)(6506007)(386003)(66066001)(2616005)(476003)(446003)(186003)(107886003)(71190400001)(6916009)(71200400001)(52116002)(6116002)(66446008)(64756008)(66556008)(66476007)(66946007)(3846002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2191;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O9ixVujhOeK/eY0sb1F7BTDOx4leMhDV48JmjaXIscTbAl3Mz+jGeqOhEshphNkEEy5IlawC0WdmJ/aCtvxdtwB7/RY+PpVmEyY638YbvUqr5MK8dj+Ftvl+FF+oCQCrZfyR1OCyMrMAvPZzNCJdJkFCwwgTU+OMMvVsb3tKPzd3vTU6Umz0+bOxO9DKsAYcUOPskqXO+/MWizMHVTYKufVLU8yJYutUiPAdvpFWp5HrXOgDP70Sq43Nk91fctOC7zekSxAp3sMUYJLjej8AFOmK4UKxt0SORrtincrHVzwJLe6kh0Wk6FIUtzTzMN0me0YLXo1z3k9XxRfr/hf/fSqjA5fSb+IK6AQKyJUp1GnroRQYkSFOUKeL1H5HK1tqnkP0XWQhbGMSKZuNSjExkZ6Zfr+pl++df7/TSHdeJMg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e030b7-0932-48cf-ac7b-08d7324b213b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:50:56.3107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdDRzqXaFfq+e60bUhnpkleLGVFubDXf1N0jaS8HbQ7Eb2RI7Tn77mwsrDW0SSwWZ2r/V+9ep0lp7fEzY7JS/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

When MLX5_CORE=3Dy and PCI_HYPERV_INTERFACE=3Dm, below errors are found:
drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_e=
nable':
en_main.c:(.text+0xb649): undefined reference to `mlx5e_hv_vhca_stats_creat=
e'
drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_d=
isable':
en_main.c:(.text+0xb8c4): undefined reference to `mlx5e_hv_vhca_stats_destr=
oy'

Fix this by making MLX5_CORE imply PCI_HYPERV_INTERFACE.

Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index 0d8dd885b7d6..a496f2ac20b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -10,6 +10,7 @@ config MLX5_CORE
 	imply PTP_1588_CLOCK
 	imply VXLAN
 	imply MLXFW
+	imply PCI_HYPERV_INTERFACE
 	default n
 	---help---
 	  Core driver for low level functionality of the ConnectX-4 and
--=20
2.21.0

