Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF010ED3
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfEAVzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:55:13 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:32576
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbfEAVzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8AE2CPV4eROfRadXz6cVJv/jhtARSJVX5n5nwdvwLI=;
 b=BPtGCNRCppE5/C5Zq7YdtpTxR3JoqdGyuBkSslGqUMf3ewY/8w/vexQcljsmyk9pyUxppDxydVKwTFGezg01eYyR1wzMK2iXqVmfvViujMFAe38V+oYERc/1eFf8jZ9aERZNWFQsHzBGuweldT74LYGizTRRuCEBilF72wWOIz4=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5868.eurprd05.prod.outlook.com (20.179.8.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 1 May 2019 21:55:01 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:55:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 09/15] net/mlx5e: remove meaningless CFLAGS_tracepoint.o
Thread-Topic: [net-next V2 09/15] net/mlx5e: remove meaningless
 CFLAGS_tracepoint.o
Thread-Index: AQHVAGiGQJpCTyIUFkunkd+1vLy5qg==
Date:   Wed, 1 May 2019 21:55:01 +0000
Message-ID: <20190501215433.24047-10-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccd2c597-2c26-414c-c398-08d6ce7fa8c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5868;
x-ms-traffictypediagnostic: DB8PR05MB5868:
x-microsoft-antispam-prvs: <DB8PR05MB586862F75AFF6058C8CC7DD2BE3B0@DB8PR05MB5868.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(5660300002)(256004)(86362001)(6512007)(66066001)(71190400001)(71200400001)(316002)(478600001)(446003)(11346002)(476003)(2616005)(186003)(4744005)(1076003)(6486002)(26005)(486006)(6436002)(2906002)(102836004)(52116002)(6506007)(36756003)(6916009)(4326008)(76176011)(50226002)(107886003)(66446008)(68736007)(7736002)(66946007)(66476007)(66556008)(64756008)(53936002)(54906003)(305945005)(8676002)(81156014)(3846002)(81166006)(386003)(25786009)(73956011)(8936002)(99286004)(6116002)(14454004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5868;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X2jqQqdi1LUxJ1NEN7zJRxyqbMhmXSqWmKGFm1xhBHmCZUvnjM1svy5Irw2UTzcL3ZV7LmAp5eEu30ckFJOw1G1b9wF5BGmEhv7sUWceOLmtaDqjVDKKRf8OpZJHAuARfqbqX4LoTya695Sp2ZQVRuYKAyGIDMR6s6SSRpLz4ckSpEAOdhsTNB7RIv9kv7prTR3bO8txKUF0iqrCD3oMOpzFP4mORofQ9Rolg/xLj69MzGHyqHrPpDLWJsOUbkRSg0PvKMAhwrxaum7NbvFsPTCbqHQOO64QP9/TdnBwJKb51bFA8TbxSyOkbZCgCn/gG1C8Z5Hvi2ut9RTlamkWfR2CiEZMAhTYpPSisVkWmhTgpBZNw/s/z4bfQ/h3geFOy+UDLMYzaGDqXiHgezD3n1ryoDeEXR14gaB2kual+ug=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd2c597-2c26-414c-c398-08d6ce7fa8c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:55:01.1491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5868
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
