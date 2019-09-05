Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4FAAE0B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389544AbfIEVvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:08 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:1505
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728769AbfIEVvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1jekcGvmeLSSTqyWvnnjY5+df3ERdFS7hFmwn3DnfwoIBFTokXbGCS/tibp3drT5fNZyul9Cg7HjouYzZIIBD+Fr1BN6QQl/rn7Ik+su2KPIyKjLNhmPXAwFrAi3efj8KAXj/dkLZtB7v6M4XGkZdw4i/Oqc9uYu8ct8OGgqcq/D8t6AoFnQHLua/h0uV+FZHljmjtZr11hFjmQtZJPYGXNvjr4v2uErkAJFffZqAg0HHMPomcA9HoZ/7vCRfiUULnT3fk0WWzyz6rOICso6KOrlcG7dPi/cgcvkob++6gl0J3mfmYMNZr8bdhwKySk5jRMhbLLxzbaaDRrTpg5Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jontaeld47CCL9L3Ah95kd0xnVRlNkdvbgeb6XWvJTU=;
 b=D494SN7KxG7Vs99Hg3lYR2wNDKi5NrJgEvhwfTvmdRPAXG5RO6EU8XyRAVegZq54r715ggdkaLnrghXPc0C/muj0UqT4LP6urJX1sDyJZwpyUthxdpCPjJSa+2W69inZZN7NLiAYqzk7ZhbxSREXIHVn3DwEZtIuIGAJCAIttGuCaaxewiAVJnmcGIzqllf0Id1Ddk/XVASvuix2gePV1XJarOBPqWXq0+2nmK7Mvz4PG9XmmEDJ6Enak8Z85CB9pEhoYKx7SOp2svUwJ0FUAVApDI8tkCryahlDMEqh+2gxmKpaPhXqGEW4YceMDX59j65XQlgB7BrHBMmj/6CP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jontaeld47CCL9L3Ah95kd0xnVRlNkdvbgeb6XWvJTU=;
 b=D7Gz3N9ef6dsrF+79Jf2/D2wa4cLSrBT7qZoBCw88cjZy/iMlhaUfqBB5isZNp8O02cj68nZp2iyTvLB76pdP6eiPndmL5zBL5jXngr3XSFeVT1CwONQSXPT3aYkwrL9t1n8ccSVVGQYIK392Uq9DJSYwjPcCdddJk0jCGQJZms=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:02 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/14] net/mlx5: fix spelling mistake "offlaods" ->
 "offloads"
Thread-Topic: [net-next 05/14] net/mlx5: fix spelling mistake "offlaods" ->
 "offloads"
Thread-Index: AQHVZDQC2RtNE34F9kC+s8urhc10TA==
Date:   Thu, 5 Sep 2019 21:51:01 +0000
Message-ID: <20190905215034.22713-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f6fb7eef-429e-4539-8a5d-08d7324b24a4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB276886C26378A7F94DF8A526BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(4744005)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VyCbiIPIRijXqzqBdKQfZuzcFEj6HEAeIreOFW1Wq+qDtd2AQXoeKKOpdhufNHMSxV+s7WQvKvUsl1DxLiXBsTbCNZVTPJMqL/3GMfeeQn5tqTcjqQY62tnLKu4JHUlnMt0H8pn9Ssg5k2dhmAD5Svuox22ELIIMM+wf9nH2NY5t/dfrY6NZQY2TFMdwvAGUdlJ8LnktyjQkyypOgNQZh6lNhbvJpf7TcW+7IURrimDIwrqPozV1hhdMI/GqqVDcFwe+JJ4IGFqdnL+glGnmkl119JWnxp6mYowyOYeaOJoiItkkm8pyqRWjfLtAkgR0n+gqn3aZyo/MKIfEZ3bNyvoDzDGtCOMt+qDaORcem4BJbrllWsqbcN0DUCPVwr0xfG/45ZrfxDsgj5eafCu5F4e00y+PGWUZCWKr9JRaqv8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fb7eef-429e-4539-8a5d-08d7324b24a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:01.9991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +hUrFNU+BnRe4+FZVNDOKqGJ573xoQZC0Ra6yg9TdS6glI2yL4QvQi7WMQ9rtSXJy8KasKLMr9hF2cYbdsQqEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a NL_SET_ERR_MSG_MOD error message.
Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 7bf7b6fbc776..381925c90d94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -133,7 +133,7 @@ static int mlx5_devlink_fs_mode_validate(struct devlink=
 *devlink, u32 id,
=20
 		else if (eswitch_mode =3D=3D MLX5_ESWITCH_OFFLOADS) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Software managed steering is not supported when eswitch offlaods =
enabled.");
+					   "Software managed steering is not supported when eswitch offloads =
enabled.");
 			err =3D -EOPNOTSUPP;
 		}
 	} else {
--=20
2.21.0

