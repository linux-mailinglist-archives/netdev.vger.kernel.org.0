Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CF5E3C18
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393073AbfJXTiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:52 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392853AbfJXTiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrcWus2xS4ygXdDV8nSDbaWi9x+DG2ihYYg2Q+nou7iLIc4kzqpH+eZokpNnPgBAMrP9ZzOs9rZu6EC90bztyeRfeBquZYhw6Z6I/PbvE3vuK+bOBnA/vbFtam5vOvxDy0yryrMKEUerpgYaYjYI+TDcQSi2Ef2A3SuMIcAz+rooETjtTfTbzdfocp8jSyLw5W/ql4LDiuiLrPzGcMbSuzoG6YEY/Frlr4EYLYTjNCIN8y1XXcBIygw36VxwCVC5ov2Rhe9HbYexbJcXRtJO1YpUlW0erTNYCmXLmhG3rM+4xgk4IDuPCLGBY+SKquVJolrkSWyeb9BmrqdHLweQhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjrJqMqvMaHbPk8qNMMcDsjRoLnSpEQN2DGSNtgKB5E=;
 b=jexwi4g3r5i0PB2W17yYegl2k42023ddH0poCbFTkgaBVRWWY3xbjyMlCBlNRGhlYCslYY+PZOwEyYdtEQBWaFoUnWlU3j80y/3Sav8SPJ3Uj6sZ1q/gCWMY+XiyvbP2jwo222ASCduKLU9s/g8D5vZu3saaQKeSd/LC0D0+pOqFuJh++NonRsVAIOAbvmyZRkWGo2oil0AHru5HjQS7hmtAg4ky1hg6ep2wkUsj8FU6ceFOX5If15y8PYZ3dV9SU6j0YWlQgaGDGQ+PM/M5QdUNuC4DfwqCcEWnojgn0ks4B1N/PAfuvIDYlV2w+k2T9EZWC7W5rGpROOanW9z0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjrJqMqvMaHbPk8qNMMcDsjRoLnSpEQN2DGSNtgKB5E=;
 b=PGdr8yqMvVle8qsSwAAoH3aDWgC5oXeWcyjgjEzTGs6yH8Zh19zPkNXtXnae1M1bUdct+j9iC/GVldrPaZdyR8SbPiJzXAqc7y+RDLU5CRWFMM/N5k//+r3qaSbU3Eom8Nq9k9u+DdrNzZIs+TD25WjJbXCzf6XGssMo1grnYJA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/11] net/mlx5e: Remove incorrect match criteria assignment
 line
Thread-Topic: [net 03/11] net/mlx5e: Remove incorrect match criteria
 assignment line
Thread-Index: AQHViqKnZKXWx1aMtEWPH0UyXZdblQ==
Date:   Thu, 24 Oct 2019 19:38:47 +0000
Message-ID: <20191024193819.10389-4-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e4bce77-ca7a-46d6-bbc9-08d758b9c975
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB46237D3E47126AA5EB7E85F0BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pmwcjXVwM8L+cwqhmwKTdDphuaI9+oRrzDoLRi/fI/EYOAExDJQ3EqVSMX29xa2ywOS0sPXMAerquv5BiPqfRbbBf0FpWjD3m6wvzW1cvEkXC4fVhi01y2jKbhaoiHECV5I/icOF5dC4MrHlmff5Lu2XpbGNQj6++/jK5IAJXEmgSPNDwJ640Jqy5FTer41DFvPIMZB2t3MW7d5jeJJ8dg5KgddSyj77iCfnm4Uxuvl7J4L/N5YN+gJV3tXMKrvwbTdFwHIg3zu7BnRvBYdFK518igeBBKB25pz25WFZKRQchrDUwxO1cB2D64XdyFIaIVdPll7MeZW12qSb6bsUdUzFVEUed8TcWp8chhzpXv9Vzuj4f52jwVsOWgoXlbEemIlGu0Dc/1xyPTyt1oM1SHnjmLxgA54ArBtrrI15blDA7DGU4MePr1kJMwFWJaZQ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4bce77-ca7a-46d6-bbc9-08d758b9c975
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:47.2082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iERPtV0Qxq5E4evdm05QewH/Kcux2WCXpsvUcoPya59bwecCMiqQ4ReCEokmZnIqw9EaVGse1p47tTIkzMoONQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Driver have function, which enable match criteria for misc parameters
in dependence of eswitch capabilities.

Fixes: 4f5d1beadc10 ("Merge branch 'mlx5-next' of git://git.kernel.org/pub/=
scm/linux/kernel/git/mellanox/linux")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 00d71db15f22..369499e88fe8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -285,7 +285,6 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
=20
 	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
=20
-	spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS;
 	if (attr->outer_match_level !=3D MLX5_MATCH_NONE)
 		spec->match_criteria_enable |=3D MLX5_MATCH_OUTER_HEADERS;
=20
--=20
2.21.0

