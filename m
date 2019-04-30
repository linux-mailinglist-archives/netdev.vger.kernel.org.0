Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2B10107
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfD3UkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:40:11 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:9176
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfD3UkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8AE2CPV4eROfRadXz6cVJv/jhtARSJVX5n5nwdvwLI=;
 b=tj2KpzBQdHhmUJZv7zmDFShwUa/NN51Ttu3aZN4FaZTjMqptxsrODt0NernNpPwtM7ZmI6GqjVlBtdtTmUCtJQCruuWgdQcUUsSXy7eYg4NF80SnaaLADXVYcdg/nMsC6ReqN6IfcPhMDA1urcPEmLCDQaiyrY3HatP1WWLb1rA=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:40:01 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:40:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] net/mlx5e: remove meaningless CFLAGS_tracepoint.o
Thread-Topic: [net-next 09/15] net/mlx5e: remove meaningless
 CFLAGS_tracepoint.o
Thread-Index: AQHU/5TiwAc9G6x5AkacgwIOwNCLqQ==
Date:   Tue, 30 Apr 2019 20:40:01 +0000
Message-ID: <20190430203926.19284-10-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1dfb74d-ed60-4948-0dbb-08d6cdac0474
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB6542156986CE2BC1500AE422BE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(4744005)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(6116002)(71190400001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xqsZDKA5E3d/th/SNkjX7DFn3Zc/RFpzcNu9i5rM7xJLPpLE4ouP2kZ/BPeXnfaESLeg+gL+SHtunp3q7ftNyYG7OGNgYQl2EBVH0tIDts/f7PzdgVhkDn01UaQndi4aUJmLr0nrpnRds3mJ1899+YwAF3YepGSpyyZ6gr9pvybe4y4gGYKQds0t3cbTFojteJj5NKNGzZ/aTRjp1mjruymwypVolyJgx0fgCtGpqogfqQtRDlNENsItokAXGfgVjouxFMXoHXRjsnZER91h1bhQA58fWk+rslUI8bnslWgGIB2X3f5mi0LDaGa9Jelc0pYivJ4YPSRMNkIbzEvVaUGLSWh4zAD1k+bJJqYBU42O7WPiA3glJGkeJLluXx/UypVHHTEyTLoa5jZoeKyYpGtQgVax8JqzcB7JvaYyCKI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1dfb74d-ed60-4948-0dbb-08d6cdac0474
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:40:01.7441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWFzYWhpcm8gWWFtYWRhIDx5YW1hZGEubWFzYWhpcm9Ac29jaW9uZXh0LmNvbT4NCg0K
Q0ZMQUdTX3RyYWNlcG9pbnQubyBzcGVjaWZpZXMgQ0ZMQUdTIGZvciBjb21waWxpbmcgdHJhY2Vw
b2ludC5jIGJ1dA0KaXQgZG9lcyBub3QgZXhpc3QgdW5kZXIgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlLy4NCg0KQ0ZMQUdTX3RyYWNlcG9pbnQubyBpcyB1bnVzZWQuDQoN
ClNpZ25lZC1vZmYtYnk6IE1hc2FoaXJvIFlhbWFkYSA8eWFtYWRhLm1hc2FoaXJvQHNvY2lvbmV4
dC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNv
bT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmls
ZSB8IDIgLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZSBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZQ0KaW5kZXggMTIyNzhm
MDI0ZmZjLi4yNDMzNjhkYzIzZGIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9NYWtlZmlsZQ0KQEAgLTU4LDUgKzU4LDMgQEAgbWx4NV9jb3JlLSQo
Q09ORklHX01MWDVfRU5fSVBTRUMpICs9IGVuX2FjY2VsL2lwc2VjLm8gZW5fYWNjZWwvaXBzZWNf
cnh0eC5vIFwNCiAJCQkJICAgICBlbl9hY2NlbC9pcHNlY19zdGF0cy5vDQogDQogbWx4NV9jb3Jl
LSQoQ09ORklHX01MWDVfRU5fVExTKSArPSBlbl9hY2NlbC90bHMubyBlbl9hY2NlbC90bHNfcnh0
eC5vIGVuX2FjY2VsL3Rsc19zdGF0cy5vDQotDQotQ0ZMQUdTX3RyYWNlcG9pbnQubyA6PSAtSSQo
c3JjKQ0KLS0gDQoyLjIwLjENCg0K
