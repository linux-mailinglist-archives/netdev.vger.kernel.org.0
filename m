Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455CEAAE0E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390934AbfIEVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:16 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:1505
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388932AbfIEVvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqihvT7yC13WJHhZ/95ESJgt+NTZFsQADTUVUFdJimZL7n3W8x+5snSNtOig08QTvAPCWvxTUYXcerPTKSLr4Anx8dXt0RbdGifM41XOtX+FhnRaiII2KVoKRV6wfOBDa7XueFeSy4r2l/ymu/BwtXD35HMvk/lOfAaz5iuiTqhJjCsqo0wM69bsIKrv0EwTDPI/xlaj1xY/O5DaLQevlYP53zZs/oadAHIi3PQh2nL4fjdbKYFH6/pXpQWdhsEHO+i6M8HeJQPQRDmV83E/Uz6Y+JPQLe/H47sKbgcZLjKe++a6goMQiwnvHI2HaLwQV70H84P1T09PuNWNaU7ylg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDjnPhq9//tfvdpiAoUvihH81Y94TjNGTpfOeH4Oz84=;
 b=KaqXMmCEYuJ8sSBDNq4cAzy9xsVMwPyt2cgaI5weJCXzK91WigyMZhEypxCfaYP1oENZXhxCr/zNs9iRd/hlza0/I+zpMzMPpanz2YLfomoOhoYbpuPOf1Y3Hav78mejRslJnJicjtVYfM77N5d66RcB3xxUPBLWtUW5NhM8PO5xPaB2jBg3JuhEZGnkKRPNi/No03fm3EXqYr68lG3WEJuO1K8iQCE5zveht0nH1dIOLB36Zyhs5ZQEZ39J2bvbijmWm9CJc/wPS+Tq70lCDS9gjDQ0Ned+azgUVYpit6bPiOYwKEFPPlPodJP8UJETmoE59afDfCOjejYMO3E4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDjnPhq9//tfvdpiAoUvihH81Y94TjNGTpfOeH4Oz84=;
 b=rm4t7Gw+vLzNN6ZtCsdmh52wGhQTVsZx1PM2f0WBCIfFOT/XuoMiq4jtUmzawRX9rizmvPwTCFVTznCe7RT9qM4HwuT0kHlJXggw5zMZUie4gdzh4hcT95SiTatwT0vwBPJXFjYlQqEcpQ4eiJmtCMqbRFHb5EiERnVsX5yxiJE=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:08 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/14] net/mlx5e: kTLS, Remove unused function parameter
Thread-Topic: [net-next 08/14] net/mlx5e: kTLS, Remove unused function
 parameter
Thread-Index: AQHVZDQFSjVQ5Fup1UC8ZZWQgHvQ/A==
Date:   Thu, 5 Sep 2019 21:51:07 +0000
Message-ID: <20190905215034.22713-9-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 324f5711-4cef-439b-f8ad-08d7324b2824
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27684FE0C4C1F6CACD5121C6BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QA5K/ENHVUylF53sadM920HiPnMzW64zVwGj2uKaWQZqrr/QIHSCMaJZb3PWkAambh12QgS0eipYO+BCUskvcmP4ftdNUpAdyf/ym3jeFi3QSKlHOaJWK7TkdY2dMUkIsFFE/iAFE9G7s+g2aKYYCPUX+1zmczmIlRKfGYU/TVPYwfC+XhuO1L7/Cb7KDiRvU3D83XMCeuKQ48qrYkdt6ityNPppAHivugn/SU/Fp8++OwebPdSc5kMTP7Q9kZjtm/1HpuT5Mb1EzRNV3DMslj+8ltfs5gc481JUGFuDTFM4hmnsNjPPmcMrTd6XvY7v5q4/iyeJJLrMLrlxP9nA23BAj/dP+K1DEIKOd1+yi16/tbdFs1sv81I/xJoKFRAFinNf5JT1x776N3w/K73KcW1Q1lHh0XKs4bHRFJ0TBKQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324f5711-4cef-439b-f8ad-08d7324b2824
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:07.6091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hvpgIzqrlwTZ1gx6GniqiKsCtMQsLS66/66q/Ie9fhSz34X2YM1q7mO+sgxX/tYq0xAWYF5YLdHhDizD9OZ28Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

SKB parameter is no longer used in tx_post_resync_dump(),
remove it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index e5222d17df35..d195366461c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -256,8 +256,7 @@ struct mlx5e_dump_wqe {
 };
=20
 static int
-tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		    skb_frag_t *frag, u32 tisn, bool first)
+tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bo=
ol first)
 {
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5_wqe_data_seg *dseg;
@@ -371,8 +370,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
=20
 	for (i =3D 0; i < info.nr_frags; i++)
-		if (tx_post_resync_dump(sq, skb, info.frags[i],
-					priv_tx->tisn, !i))
+		if (tx_post_resync_dump(sq, info.frags[i], priv_tx->tisn, !i))
 			goto err_out;
=20
 	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
--=20
2.21.0

