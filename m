Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CDAAE09
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388655AbfIEVvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:05 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:1505
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730537AbfIEVvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7+UPEOigjWdBLTRxD8kbdgNgogiZTdCpeM7dsxQiJjFr1NprmyWyGFd7Cr6sYMcQqFNqw0imT9xgaHmelkMYYmsGIc5NLVwCCztdZQymJjbQ/fhelPul0ip3c/4rYnwyaRXHavUzHzc+fC5mK0ia+Jn4tCo8jLQRyJTNKBXtvUlHWIhoRlpY0C/EdXjFPm9h896I4bhPlC+O+L/wJ5bQT2JVKQRjJnTwqF9KzreaHZ9TXLMsg5m/vyVGfD54cVxdDIQSeyAsdDE6fPvS1Mzdfn5HReEsLhwo/22mVDVXPRo8bNcwoLJRFOHNqy8bikV4g4nD4vjBs4oTjMVrSe85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzDRMWxPvjwz7g1H8TD4SQ2xXDFhdrpDpRM06cL7CY4=;
 b=OvHqB1+hFK/GI3zX+2CMSqlpnNqCc/YZ6bKRXUmjmUVK258tTGUFIMq9wjtkcGE3hOU8r+EEVAloiR3aHWsnVzZwFlCoj4Ov1dkDXFj3q95WTb8tyIOYTbn61IR3vCJOriPZI+vya3t1n2NbfgasJZ4VyLZarhz0iEJs+GtcAtbexLBW5PTq0yxk9d6pLYytOwLmM+cGBWVFvVr+SHt4Gq4PNZC/YV2BJNMi4E46VmVRbB1dY1rOV/5vl50Gvdof/i62F2/mackDGzjIAoS5rG2mSHkYgYudTOaalyifmfD6ixKO0MTC0yhCqmLk+LV0XKpCr4wA8asY0L/QPo6E3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzDRMWxPvjwz7g1H8TD4SQ2xXDFhdrpDpRM06cL7CY4=;
 b=MR4IUQNGKblR1iPP1bahcoPI7ZkOz1UiUAXHFlhRh5pGVCxi9U7Z5bzowEAhZRQgv9kCHdRd/fp669llsdwn+0wqcwLLG92OjzOPZ3mE08SVhz21Jfqy9zqP1r3Y5RyKQLddSV5sOqJPI+bjG7zF4gTmzXG3T5qydTGLuX4ncWo=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:00 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/14] net/mlx5e: Remove leftover declaration
Thread-Topic: [net-next 04/14] net/mlx5e: Remove leftover declaration
Thread-Index: AQHVZDQBAUyk70RpvkulQ9IM+Hop9Q==
Date:   Thu, 5 Sep 2019 21:51:00 +0000
Message-ID: <20190905215034.22713-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0b8be197-790b-48cb-f3a0-08d7324b23a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB276832A6B6D9CC9184AFF484BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:206;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(4744005)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6MhROw6QHEX68bJZa67G3DW9XFY9kh9FlM/zvbfdpvDT6SAzZ7c9QWjSPATq4SqWworkrrPmiQL6Hrp415apMlJuWQ7Ovy4ZHOSkxW1pEtgnbX/k27XpuIAlQsa/4GhUe5/PB1WhdwKj+EaPJWLlm4ww4s7/D+i/Q9igZtsroiFDlkSbUPYy6CtxNb6BO1flo9uIEPUa/5e1rYcvWtcoaadd8qLAZi/b2rsAI9nlj6ilHvRT5s4G13etnQVXjYxOrxBOQLlwkOTZB36hXwchms44vj3t+I1U6W6s+bkV3gzZaRr7ZBc4QbRcFbTU4kin5xz0hCCfxT8O8Jif7ERBNbEE4dXaOED1ipNQ+fkpco5ff4wzq/1vfj27h/luRk8o961b1sFypFv/aqWhJV+jIJVw4uFifOafvwXi1x26ejc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8be197-790b-48cb-f3a0-08d7324b23a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:00.2449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YcN54FwwEh1ZNtnNRGC5RN9bC3wMYpPIgotUHvUZ5vf4mX6ct7BvsRdeG77e9x2hAfji5QxX3Li6YDBlrZf4og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

This function was removed in the cited commit below.

Fixes: 13e509a4c194 ("net/mlx5e: Remove leftover code from the PF netdev be=
ing uplink rep")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 8e512216deb8..31f83c8adcc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -183,7 +183,6 @@ struct mlx5e_rep_sq {
 	struct list_head	 list;
 };
=20
-void *mlx5e_alloc_nic_rep_priv(struct mlx5_core_dev *mdev);
 void mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev);
 void mlx5e_rep_unregister_vport_reps(struct mlx5_core_dev *mdev);
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
--=20
2.21.0

