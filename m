Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6284D86B67
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404847AbfHHUWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:25 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404169AbfHHUWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4vHB+Mu5KvP6I07i3rGHNTima1B0GxuOTeYQCj4pIhDSz55IWHKVRhJlzXchRPB8v41Z/1BeW+8uocaS8qI8aSeVeC8vIVLXb9/8NiHwTUuJxtiY77RUf9tWpj/7Q0Pd5yt/YFJl7yUqpYEyDy7yWVwMAji+tkSOlYdkuU6IzVP4+Zykc8Pd/a2P+jmkT6y30vNBnnOAZJgKhUSsmVq3nv1siAiOI19jN5NJxrTuECKhZ0XXM+ovruxpzd30RYAxQsfT/OW9lzN0bPFi+Op+9PnNqi7x0Qv+5vXNbPuCxr71cGlNnuPUF0Cn/WVQlNr2RZNlQjKQ85IgulOQP+7qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVE0G1XcPFeGU8PuMvxMZ8B7HSR2vQR2ir/Jms0/GIk=;
 b=TtwOcTsvjA4ifNihCvRjvDPavzEzW9BV60+aF8w89OW3NxiFsl7S5HURR+ZChWhHDcAmWKhm4zg6AFV+gmaEd2Z3TolY/QKQbHq3R1LXR0yqpGfi9KJtkv0jZnCy0TUqJGKf1DFU0qOhC2NfZnmN+bpLAEmDLGRIwjZAXBqjWJA2K8q3NcNCDJH/E+lmXy0wMlatcv6V25U9+ljDO6JMUZCEXmACpoSzJTetfCpJiChxfCxF8wYfQxp7d745Dao8RCobiubyB+CNmQUHbnsznvaevTa8KiIVd99GgXMDwrndkpvlWmyUqpijbLehXNnfwltUEmEa6wAvOAH7cIl3rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVE0G1XcPFeGU8PuMvxMZ8B7HSR2vQR2ir/Jms0/GIk=;
 b=DvW7nU2s9wrcbDhi+yyGSyJ3V7GvgeSXr9H+oOS4MazZI8CPPEBqzUisbGTMjMYlNA5YZ9fYvNFMqXawzSx1ZWrYDymrpPvC0JozOgMuzOk8OAHjRzGH7NjBVTpyJWupQITEeKfxv+JCQ5SF5HJ3sJpQqvOvlG2H7OrZA1iwexo=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:13 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/12] net/mlx5e: kTLS, Fix tisn field name
Thread-Topic: [net 08/12] net/mlx5e: kTLS, Fix tisn field name
Thread-Index: AQHVTib2KJAYegC3u0uwGfuO3lp5kQ==
Date:   Thu, 8 Aug 2019 20:22:13 +0000
Message-ID: <20190808202025.11303-9-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3a541b7-41e6-4db8-2fab-08d71c3e190e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB225784568B8F336B66055DBDBED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sATWWsICreKRNyfstok8agzIytWMTVB4KjTaJpXVjSl5/R1jsovsOyjRz2ZtH14oDQxBBXdPCP5uVZQiLZgAV3YXjHkQ4vMb/TChAnlsPacTzrQzn9CBKj1G68N6AUg78J+IymIAalOJCHAdaPGHu7x7xmVo/3O8cBAZOm1M/aYFBpXfi5GiO1IL5NzoauLhqiF7GJOLfDj9auXdRtQ57wJwhXoR3+fD8303gXXtSX2xEPFO8XXZc1YpbS7qcin1yEqFriIFpRwlIllzCma0sXU1ri0TxHxfAkLY7ge/7howrs1T4HniA919kzHMLnx3IjL+3c+5eJTtsAdgURA5smt+9vv13nsJQAFCF05dRcmNWDNJZ8rsDD+eCbRKkMQSq1d0F9GylC73cbUERFTbXDXpIMjyRr/6lJHBQmbXleA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a541b7-41e6-4db8-2fab-08d71c3e190e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:13.2372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MWtArvSWBB5bOy9517wq/V7ljjXkeNBpXQLU5AIIInvgQc/jW9FSgp48Nza0D7wOapL2F+W7ZrXo2BiDBXwMxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Use the proper tisn field name from the union in struct mlx5_wqe_ctrl_seg.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 9f67bfb559f1..cfc9e7d457e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -69,7 +69,7 @@ build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u3=
2 sqn,
 	cseg->qpn_ds           =3D cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 					     STATIC_PARAMS_DS_CNT);
 	cseg->fm_ce_se         =3D fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
-	cseg->imm              =3D cpu_to_be32(priv_tx->tisn);
+	cseg->tisn             =3D cpu_to_be32(priv_tx->tisn);
=20
 	ucseg->flags =3D MLX5_UMR_INLINE;
 	ucseg->bsf_octowords =3D cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) =
/ 16);
@@ -278,7 +278,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,
=20
 	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP)=
;
 	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | ds_cnt);
-	cseg->imm              =3D cpu_to_be32(tisn);
+	cseg->tisn             =3D cpu_to_be32(tisn);
 	cseg->fm_ce_se         =3D first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
=20
 	eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
@@ -434,7 +434,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_dev=
ice *netdev,
 	priv_tx->expected_seq =3D seq + datalen;
=20
 	cseg =3D &(*wqe)->ctrl;
-	cseg->imm =3D cpu_to_be32(priv_tx->tisn);
+	cseg->tisn =3D cpu_to_be32(priv_tx->tisn);
=20
 	stats->tls_encrypted_packets +=3D skb_is_gso(skb) ? skb_shinfo(skb)->gso_=
segs : 1;
 	stats->tls_encrypted_bytes   +=3D datalen;
--=20
2.21.0

