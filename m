Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4E1A2B1C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfH2Xmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:42:44 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7907
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbfH2Xmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:42:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/xdx4MUPRHP8tS5EjzSFxEoATlU9I6X4yZjSM8U5ulHjJZ61kLLd1xWZ2rkI1zMvvQmm2n9SA9eXPgVJ5yMsbDEik7WAUZwbxzpmaEWzjjjWxauhyC38r8IbL7BQL99Q5hgwkXKVNqmN7gDxiHm6WR5wOi/oK7Ox6J42exga/GFe7JVXMLDtMdS3VbfXDwfv1nxe1l4+Ds5Czug3v22IrkjzQRNvi0oa0LeUgwyhxG6qmj0m4gLipRMjHCsN+Wmyff2mDEoBHXnmsOaL43ia+bfTss111RGDPM7Y1o0jfgYkwjKu7Lowm2/pnd1UD3wPmp5TNlUDAx/E6eRl85aYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNhrk/JdoQwIGsBEbgwKjBmmA02FeHmQyDqEfJlPWs8=;
 b=KlvoRPpF6eKHMY4+d9gfuJtTaV/cfJGrQASjcUpSV/iqW4whdRGvq2QJ2C0NRzwv8q7Xcx0NH92c+en+BELWIqzvmL37BjQfg0jJQYjMkkOBYNJ1ahMY4JInQB0S2YWg2/SbDrNl+gqUn1p+3qiG3PJE7ukv6GVv2L2zexaWoaDaXYz9yAPuFBEBcoqMpsTZp+0SzQi1gwwJoARXq21HQJgL3zCRqY83s4KttVx9S7b0qjmCUoaLoauIH4lWcWV0udUuGKBsUsrDAalK+DLqpMN4uoWnGnvfjP5n20CcUhzR2UK4QCmHIRiWBgYbBGHJruzAHnr14EGrj7RjDm45Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNhrk/JdoQwIGsBEbgwKjBmmA02FeHmQyDqEfJlPWs8=;
 b=p6glwCMQyUvGmQ3nPnrj9DQU7qBKJlkRFDyvH+NYiNb0fzizgvRPIwbNBLJyF8Sjhbyitjky5MJVSspAKLHExUs0o+l2mDDFq/Ct+ilMtINUN+H+CnoNodRpHCmymXk6/b2DK5njMnbxX1UHgrVpCoLbLxJcm05DaAX01zg+rvg=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2333.eurprd05.prod.outlook.com (10.169.135.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 23:42:37 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:42:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 4/5] net/mlx5: Add stub for mlx5_eswitch_mode
Thread-Topic: [PATCH mlx5-next 4/5] net/mlx5: Add stub for mlx5_eswitch_mode
Thread-Index: AQHVXsNwDSmwR2krMU+zGnnBkP++Bw==
Date:   Thu, 29 Aug 2019 23:42:36 +0000
Message-ID: <20190829234151.9958-5-saeedm@mellanox.com>
References: <20190829234151.9958-1-saeedm@mellanox.com>
In-Reply-To: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c23d0de-a43d-4dc3-dfe3-08d72cda9267
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2333;
x-ms-traffictypediagnostic: VI1PR0501MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2333EB5B133B70B0F3D70DE2BEA20@VI1PR0501MB2333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(476003)(486006)(450100002)(4326008)(478600001)(2906002)(81156014)(6636002)(110136005)(71200400001)(36756003)(54906003)(71190400001)(305945005)(11346002)(446003)(8676002)(81166006)(7736002)(14444005)(8936002)(5660300002)(50226002)(256004)(2616005)(64756008)(66446008)(186003)(66946007)(14454004)(6116002)(3846002)(316002)(1076003)(6512007)(6486002)(53936002)(6506007)(76176011)(107886003)(102836004)(6436002)(386003)(25786009)(99286004)(52116002)(86362001)(26005)(66066001)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2333;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rFjz5XTDVj9Y/6C6nenBhfHOHY7cGuL8d8fdeYsGCJPCJcQkCFYBcwOVtKGILz9cTrwCIbMCJof4CRoW6d3Z8RCoiyyl6/ZQBMpUa0b2h9MVaa29oQULK/VgPfuqZYmlFTIxpLJLWXSCPp2QI1pXJ7P0e/cXdUKvo+G2q5lfwjQ2Erx+MWdpu1UJShrvoJJHSfYKEWRqIiB7PHl8GYrtLQfaPktXebtNrrBOR2D8ySFD+2E3N4VZDESo8mmBGs/VD0xSuWgPa9hGdrj+5ufOKg35aNED6akV8rgXolU/wF90yUwDwlyKjIILavcviSI43GFeSCG8RU9/qwA0rHhC7B7cywNpFD2xi8us0SznpDi/65wgXTrgtb4nDjiFTIhiB1fnMDvwcNgh+e1fLgYboI4ZhkwRWIHCv7qC7zKxQvQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c23d0de-a43d-4dc3-dfe3-08d72cda9267
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:42:36.8997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +kxSxEeeVNyag3krIra+AuGqQZwlJpouXfqZ0rHxozG4RBiqGldKOmMrplXpVK1dFh63g7SHr6bgLZMkdGk6rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Return MLX5_ESWITCH_NONE when CONFIG_MLX5_ESWITCH
is not selected.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/eswitch.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 46b5ba029802..825920d3ca40 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -61,7 +61,6 @@ void *mlx5_eswitch_get_proto_dev(struct mlx5_eswitch *esw=
,
 struct mlx5_eswitch_rep *mlx5_eswitch_vport_rep(struct mlx5_eswitch *esw,
 						u16 vport_num);
 void *mlx5_eswitch_uplink_get_proto_dev(struct mlx5_eswitch *esw, u8 rep_t=
ype);
-u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw,
 				    u16 vport_num, u32 sqn);
@@ -75,7 +74,14 @@ mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *=
dev);
 bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *=
esw);
 u32 mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *e=
sw,
 					      u16 vport_num);
+u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
 #else  /* CONFIG_MLX5_ESWITCH */
+
+static inline u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
+{
+	return MLX5_ESWITCH_NONE;
+}
+
 static inline enum devlink_eswitch_encap_mode
 mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
 {
--=20
2.21.0

