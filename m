Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84ECA758F5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfGYUhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:37:01 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbfGYUg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwUxDM4y2o8Qtt9Jk+ypv7H13rPF0ZEMYvRVoSKaxeq9f7ihJOvBTUzXrVTIrmF0tw1A1r54A9sk6ZFBsQKoiMO6yhK7RaUIsIqSSn4HVFYfADdBidA+Qe7XymwnTNTvUKAjucT9mO0YIwSiNZFcBNu+Fpm2ykcyhHOL13Ny3NWu+Jdy1D/8ZdvjVPSJnADcEVbEck1Remd3Z1VrzvLtnNhtBjeTiBFmhmTs1gxr5h8KidkJDPf9ZhVTU19mn4dBVHruWGCRSpsP6CRGTnWPrgAzTjV4E6eZHgv9TyiIO6cohuU5hRNYvfJlAF5LA3CYXZEpdexTlzcrYIdcYE2BhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sP3QB1bGhzGJJM4z34+9JEyD2dA2kGNVXCf78J/xphI=;
 b=CkOxsG6RFlaX9me4R7WvlidseHW7fHkB8LOclYq0x2JxwZyRs+SHGmO2b9s+/bTDfheO/N+oNdRir2kUIvMs1Z4bFn1SUMbM392+a1UIsHbnkrDRO23saXTFqCv7S0vkeCHmYRfYe0v0sSpeOeC6H8X162ivZ20cnZZXE8a2y8iKlaa+cbFL6I2BtREDG1efkOzMe882M9NGE8a6hluLILdByQIFfl1flbAbDh7LwKgLQx7WCD3aUK0BBg3t3azei0waccGlEqH2vHkevhoqVwk9kKWIe+AjTiGwVuOpsLJfSG5MNBcPBty45156FL+O4UnkhQmyt5IfruNKsGfs1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sP3QB1bGhzGJJM4z34+9JEyD2dA2kGNVXCf78J/xphI=;
 b=IBEq0H61d/4CcKe/E/jq3tMi44uUu9MoQc2TfwRufIdTh+RMjfoNQ1yr+GR3eFzThTqq8X14cm0N2f51m5UkurnO5OldInZV+4uwm5Y4AWBe8ZhtzX5AuA/jJRrIKI0V3b39N6w5LmdLIOM5RWujgejeKRakFu4WDOdvfs1Ksxk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 8/9] nfp: tls: rename tls packet counters
Thread-Topic: [net 8/9] nfp: tls: rename tls packet counters
Thread-Index: AQHVQyivLjRHuiZY+keAJ0wjSUp4bw==
Date:   Thu, 25 Jul 2019 20:36:50 +0000
Message-ID: <20190725203618.11011-9-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2edfb6f7-0a80-4159-a076-08d7113fd20d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB2504ACCB2CF34421E2628E1FBEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5zrO5jMK94hnOh5p1YM2EcaVfmk0FuDz/KLXcC+xk3Lv/ZH7bQ2JFidB0yvsligk9jxa/CFoP1A18u5aIDeQQgtbvsiTRmVqy0uvjt1+O/AZSZgx70b8yjlLyhAreQ5M6/r6KuEW/XVVbdq0i5kTyvzywxAqd9ePHnzQxlWSz5uAfT7JTdCkZKavseI9OjCGWTGglOfzDluz05nwZFr1xuYnI1RX66/KS6OmCVHb9rus/F0TsuCsTdeUAdRdptqi1F7S05H+T21GtgfdD7pEMb6uLrQCVKYP1HY5s8f1+CYHuc9mcBVFVqlVF7ONbQxDiHEVEFUvNc9LRj+k6jeGHX8xw1qBCHLQ+3Z29yfirFF5h2Q80vsqsvnz1Tc9hvm7aqBu0uaJL11sLA7QPLBWnQpRaz0t22Qs7j+ax955n1g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edfb6f7-0a80-4159-a076-08d7113fd20d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:50.2044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Align to the naming convention in TLS documentation.

Fixes: 51a5e563298d ("nfp: tls: add basic statistics")
Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers=
/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index d9cbe84ac6ad..1b840ee47339 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -444,12 +444,12 @@ static u8 *nfp_vnic_get_sw_stats_strings(struct net_d=
evice *netdev, u8 *data)
 	data =3D nfp_pr_et(data, "hw_rx_csum_complete");
 	data =3D nfp_pr_et(data, "hw_rx_csum_err");
 	data =3D nfp_pr_et(data, "rx_replace_buf_alloc_fail");
-	data =3D nfp_pr_et(data, "rx_tls_decrypted");
+	data =3D nfp_pr_et(data, "rx_tls_decrypted_packets");
 	data =3D nfp_pr_et(data, "hw_tx_csum");
 	data =3D nfp_pr_et(data, "hw_tx_inner_csum");
 	data =3D nfp_pr_et(data, "tx_gather");
 	data =3D nfp_pr_et(data, "tx_lso");
-	data =3D nfp_pr_et(data, "tx_tls_encrypted");
+	data =3D nfp_pr_et(data, "tx_tls_encrypted_packets");
 	data =3D nfp_pr_et(data, "tx_tls_ooo");
 	data =3D nfp_pr_et(data, "tx_tls_drop_no_sync_data");
=20
--=20
2.21.0

