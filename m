Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108B669C5D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbfGOUKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:10:01 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:60879
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729793AbfGOUJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 16:09:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORoNcndOg2Md2wRFcUcLDFS9FQKxkUN4arladXezOOHJulPZUMtJXJXcmQM5VXdl8aj2ndtZdXTjTb0CgkhpiydS0S15krRwNzdxbDIvXDEqlBpu+XJB5inS98HzJcoz5GhSqQBC7rJj7d8KFPHaO6wwdJal0uv7N0bQfzjDO8lKJaUeCi08N4LaCaJ5ATXiFiBWH+goiInUpvRUERtq5A8EjFNIeCihHtL6U5ClB+8ukZoQB5DRCYx6i3xl2eoX3WZNwaYBIFrGTmtmdLi1PT5eY2Yfh457TYO7g7RnAsbva9w0cKgAghVY3iw8WU4RR+A200rrKnaUijBg2EmrXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT6kDpnUJ8QRsB2uraqJCsHeB+pxHWUa3/lHfE9xJ4I=;
 b=RHFuvYPi1YiubYT2VvIlHARtbHJkhl5SGhFs6TTwFEX87BTqajdSQlY9hHIzi4ZJcVXXLdE2Xb5K06/8HfiBLpds9ez+KruGyZYm1g4JWSSbukWS7IVYTQrd3J4pHzyxuwLLry2nwMdSFFZkdon2rVrvIDvLcX4w3j+aFHn0b7dyQMOlgm+4iVHvC1vm7xfYszdGiZMHh9DwLGoJYxvq+pgIeA99IrZt0QIMZGb4qqG6fkfwvq4NhLkQzuiGWZIUx1xeiiggZvgXlwEugv+IR1Jsw/YztgeUiLbix37mvE1dUXsXmi4He7YqnkkeYlRRBuref4Umt9/pRvzIr1WG3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT6kDpnUJ8QRsB2uraqJCsHeB+pxHWUa3/lHfE9xJ4I=;
 b=VvsGODIO2CjnrHKNI2qXDzmST2+R2HeWh7rgcoOs1JlHtlB0Fvd8W570TPzcvUOqW9tEexly6wXpgBzej85b08S5kQhayLzko0UO/mRUzqhpQzu0lsEKMprDcVoldHoZ4NkUs2Wk8zNcha2hyYeqx5gdkRv2rLUcj5GVW5gC4I8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2485.eurprd05.prod.outlook.com (10.168.74.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 20:09:53 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 20:09:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/3] Mellanox, mlx5 fixes 2019-07-15
Thread-Topic: [pull request][net 0/3] Mellanox, mlx5 fixes 2019-07-15
Thread-Index: AQHVO0lD3CHS3yvqR0WHy3GcaRSgFw==
Date:   Mon, 15 Jul 2019 20:09:53 +0000
Message-ID: <20190715200940.31799-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbc5b8ec-ca65-479c-1234-08d709606610
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2485;
x-ms-traffictypediagnostic: DB6PR0501MB2485:
x-microsoft-antispam-prvs: <DB6PR0501MB24855F158C1032ACB95408C0BECF0@DB6PR0501MB2485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(6436002)(305945005)(25786009)(7736002)(102836004)(6116002)(26005)(6506007)(81166006)(3846002)(81156014)(53936002)(107886003)(36756003)(14444005)(478600001)(486006)(6512007)(186003)(256004)(8676002)(68736007)(386003)(8936002)(2906002)(66556008)(86362001)(99286004)(66476007)(476003)(66946007)(64756008)(2616005)(66066001)(5660300002)(71200400001)(66446008)(14454004)(71190400001)(4326008)(6916009)(52116002)(1076003)(50226002)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2485;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y2dUmibU1o/UI95uOtSv1n30OYO9/ytvZmFV9y1Q1L63ctVcOmLf16D17BMLuzDv+fHzEmOhNxoSj+IK6uxNrFT5UlVkdNZ51G1hIUp5vE446SjTeb01NJH6fUr1q9j1lYLQkahoxxi52gGVEL+Pt99IzZSyBy1u1IqPVJTXFzB/DPcSSm9mA4yTc5dVngSbD/rESpKrCpKAjF/fEWWpjYurWQgnrvyyQvYAKlEj6zebW072K9BIMcp7KaPrsFddDJeb+M2eXtzWgeF/u3CT/DZSiY9soeN6JWLdVWHaPRXYJEaI6dOd3pIKfi7kJzOgDQbNV1LuvcNzOA1MSwZJvPpU2+XDQX7wJ9LOqyvE4Q3w7U06aG/0p3MpUmHn2Wx49z2Ygyr6vGRPRl4P7gQHLWblfaH0NEY0jJn4kRfEobw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc5b8ec-ca65-479c-1234-08d709606610
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 20:09:53.4352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This pull request provides mlx5 TC flower and tunnel fixes for kernel 5.2
from Eli and Vlad.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit f384e62a82ba5d85408405fdd6aeff89354deaa9=
:

  ISDN: hfcsusb: checking idx of ep configuration (2019-07-15 11:10:31 -070=
0)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-07-15

for you to fetch changes up to 3d144578c91a2db417923ba905ce7a84ce0c274b:

  net/mlx5e: Allow dissector meta key in tc flower (2019-07-15 13:04:04 -07=
00)

----------------------------------------------------------------
mlx5-fixes-2019-07-15

----------------------------------------------------------------
Eli Cohen (1):
      net/mlx5e: Verify encapsulation is supported

Vlad Buslov (2):
      net/mlx5e: Rely on filter_dev instead of dissector keys for tunnels
      net/mlx5e: Allow dissector meta key in tc flower

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)
