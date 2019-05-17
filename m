Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5641821EFC
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfEQUTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:19:38 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:15235
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727035AbfEQUTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybwQxpTCbihp+pEF1sHpwcaNgPO4DkfBa0oZUDGIjW8=;
 b=YeoR7FG6gQVOkhmNRXfDXD97eVFBdxTxxFQrl6118i6agpLlIo4IW8w6s9r19Qh0TkyDYupH/F8B3Ssh1QAIazstaWmxLQvzjpehBzXH798SG5BwmX2ZbRI9z9aDpTDwgvXVNS4Rn/TSwE6QucjEN8aknqjRxUZq6Tp6MsF6KPs=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5929.eurprd05.prod.outlook.com (20.179.9.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 20:19:33 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/11] net/mlx5: Imply MLXFW in mlx5_core
Thread-Topic: [net 01/11] net/mlx5: Imply MLXFW in mlx5_core
Thread-Index: AQHVDO3XS2B8ajygUE2ePDpXMQ34JA==
Date:   Fri, 17 May 2019 20:19:33 +0000
Message-ID: <20190517201910.32216-2-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7977fd36-f7d6-48a9-00ae-08d6db04f7dd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5929;
x-ms-traffictypediagnostic: DB8PR05MB5929:
x-microsoft-antispam-prvs: <DB8PR05MB5929559B13D778ADE01A791DBE0B0@DB8PR05MB5929.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(39860400002)(376002)(346002)(189003)(199004)(99286004)(66066001)(25786009)(2906002)(4326008)(386003)(81166006)(81156014)(71200400001)(71190400001)(316002)(14454004)(6506007)(8676002)(64756008)(186003)(256004)(73956011)(66446008)(66946007)(66476007)(66556008)(76176011)(305945005)(52116002)(14444005)(26005)(102836004)(7736002)(5660300002)(1076003)(4744005)(6436002)(476003)(2616005)(6512007)(36756003)(6916009)(8936002)(486006)(54906003)(68736007)(3846002)(50226002)(86362001)(11346002)(6116002)(446003)(6486002)(478600001)(53936002)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5929;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +ACEAW4BlXoUHcNNW7JPMwQhqZB9n2IYNh7K56znwY+/u8NauZwgnUYNp7GEe1akZG6o0C0f1TFolokS4nfioWEPD+7fuZ4i5EL97lulManTXDuMA5TeW9ewpb3HXgCmF5xKXY98+0hQo7lVWnMU/xcSjJLKIEOAgNu1xMs5UNuMZ/jJc0eDyVlf0XLL3YSE4vNVlGmBBjYxNzeLfocgO0UoLcnY2RUAEhx8SVt90ppeXm/O86YYsUhuubUAbaPez9Y4//O3dbDtLiPLIyDLo8REBxldz9ti01zIWWU1XgpRR5h3tsdv44d1r/kqbTaDrClPmNUVfSpvR/LN82iYJH+lz1hXp7+KiL+Z7KwPrN1c5SUkGCL4S9U+xIr6gWl9cjOrwg6DmLStNoKVGVX+NGnxbFNbrfUN/Pv5ky+qb4g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7977fd36-f7d6-48a9-00ae-08d6db04f7dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:33.8341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5929
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bWx4ZncgY2FuIGJlIGNvbXBpbGVkIGFzIGV4dGVybmFsIG1vZHVsZSB3aGlsZSBtbHg1X2NvcmUg
Y2FuIGJlDQpidWlsdGluLCBpbiBzdWNoIGNhc2UgbWx4NSB3aWxsIGFjdCBsaWtlIG1seGZ3IGlz
IGRpc2FibGVkLg0KDQpTaW5jZSBtbHhmdyBpcyBqdXN0IGEgc2VydmljZSBsaWJyYXJ5IGZvciBt
bHgqIGRyaXZlcnMsDQppbXBseSBpdCBpbiBtbHg1X2NvcmUgdG8gbWFrZSBpdCBhbHdheXMgcmVh
Y2hhYmxlIGlmIGl0IHdhcyBlbmFibGVkLg0KDQpGaXhlczogM2ZmYWFiZWNkMWExICgibmV0L21s
eDVlOiBTdXBwb3J0IHRoZSBmbGFzaCBkZXZpY2UgZXRodG9vbCBjYWxsYmFjayIpDQpTaWduZWQt
b2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9LY29uZmlnIHwgMSArDQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvS2NvbmZpZyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9LY29uZmlnDQppbmRleCA5YWNhODA4NmVlMDEuLjg4Y2NmY2ZjZDEy
OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9L
Y29uZmlnDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvS2Nv
bmZpZw0KQEAgLTgsNiArOCw3IEBAIGNvbmZpZyBNTFg1X0NPUkUNCiAJc2VsZWN0IE5FVF9ERVZM
SU5LDQogCWltcGx5IFBUUF8xNTg4X0NMT0NLDQogCWltcGx5IFZYTEFODQorCWltcGx5IE1MWEZX
DQogCWRlZmF1bHQgbg0KIAktLS1oZWxwLS0tDQogCSAgQ29yZSBkcml2ZXIgZm9yIGxvdyBsZXZl
bCBmdW5jdGlvbmFsaXR5IG9mIHRoZSBDb25uZWN0WC00IGFuZA0KLS0gDQoyLjIxLjANCg0K
