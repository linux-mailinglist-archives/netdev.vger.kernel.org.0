Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E19155696
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbfFYSA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:00:29 -0400
Received: from mail-eopbgr10069.outbound.protection.outlook.com ([40.107.1.69]:41406
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731714AbfFYSA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 14:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNk+J7+p0UxJ56pkfeIosVulr1BG+0lxdX9DANdbI4g=;
 b=JXX+uVQcZ7UtIv2lHr9gm6iMXLGlLajBTE07Ur0C0TiesOJ1M9v9EHkaxg1G1/sgaIbvGumsk+42oqKiVsPd9HQ3ond6Dim5iQfST/gRuFNauXX/sZrGdmjyYwp3fK3S3btgl+2u5OncDfNQXnbOXvjZ8kmTAPmYKGIhJy/fgFA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2567.eurprd05.prod.outlook.com (10.168.71.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 18:00:23 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 18:00:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is disabled
Thread-Topic: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is
 disabled
Thread-Index: AQHVK2p9akCcAZ4D0Eim+TyKOGELBqasqN8A
Date:   Tue, 25 Jun 2019 18:00:23 +0000
Message-ID: <ff76fcde486792ad01be1476a66a726d6e1ab933.camel@mellanox.com>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
         <20190625152708.23729-2-Jes.Sorensen@gmail.com>
In-Reply-To: <20190625152708.23729-2-Jes.Sorensen@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5a3e2e7-173d-4be8-f1ec-08d6f996feb9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2567;
x-ms-traffictypediagnostic: DB6PR0501MB2567:
x-microsoft-antispam-prvs: <DB6PR0501MB2567C78687DD6C2A2A168D3FBEE30@DB6PR0501MB2567.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(396003)(136003)(366004)(199004)(189003)(5640700003)(14444005)(6486002)(58126008)(54906003)(476003)(3846002)(6436002)(86362001)(478600001)(2351001)(99286004)(53936002)(256004)(446003)(6246003)(2501003)(316002)(6506007)(26005)(2616005)(229853002)(36756003)(102836004)(486006)(76176011)(6512007)(118296001)(6116002)(186003)(66066001)(11346002)(2906002)(7736002)(73956011)(4326008)(68736007)(1361003)(81156014)(8676002)(81166006)(25786009)(64756008)(71200400001)(5660300002)(66556008)(66476007)(8936002)(71190400001)(76116006)(66446008)(66946007)(6916009)(305945005)(14454004)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2567;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YGTWo/9HqV3XLvHNQ9JOH0HGkVKdVw8+FbFkvR6VQHoijBvD6NGky5sBZXq5Eldp2erpGGG1jYO/cLu5jt/6j6AILbUjkG1HRCxPGKFXuRglfmTjqkirAIitoul0y4qAw35buYXvZj5MFU0guQT3Nn8ze6izWdkVT2Tl7RY+P2e4uybO9RyT4UCKq9UXDL3V6EH2dWzlb3xgoQ2xok9RcHOUrhPpraRHycG4i0kQuCavvBhRFtusA7WiLL6WVvk6ZdAzMDdZcduZAyqMu7VfrrFJquQJwBN+/tOxVwtUWHzyoWKj9xDZ2tufmzVBtDtVj1a2/M9PBUyWNU+tf1BUZoEduCnR1c8zWI7qvOVmlev+NYcYAhLoNKUO9iWx/hhpn/z/zNP0CNF+igXq0bk6QQaIzwKdOkk7vAWcSp5tfpU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <695640B2A40BD54AA7D2AE07C9FF7BB9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a3e2e7-173d-4be8-f1ec-08d6f996feb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 18:00:23.2362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2567
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDExOjI3IC0wNDAwLCBKZXMgU29yZW5zZW4gd3JvdGU6DQo+
IEZyb206IEplcyBTb3JlbnNlbiA8anNvcmVuc2VuQGZiLmNvbT4NCj4gDQo+IFRoZSBwcmV2aW91
cyBwYXRjaCBicm9rZSB0aGUgYnVpbGQgd2l0aCBhIHN0YXRpYyBkZWNsYXJhdGlvbiBmb3INCj4g
YSBwdWJsaWMgZnVuY3Rpb24uDQo+IA0KPiBGaXhlczogOGYwOTE2YzZkYzVjIChuZXQvbWx4NWU6
IEZpeCBldGh0b29sIHJ4ZmggY29tbWFuZHMgd2hlbg0KPiBDT05GSUdfTUxYNV9FTl9SWE5GQyBp
cyBkaXNhYmxlZCkNCj4gU2lnbmVkLW9mZi1ieTogSmVzIFNvcmVuc2VuIDxqc29yZW5zZW5AZmIu
Y29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9ldGh0b29sLmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9ldGh0b29sLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jDQo+IGluZGV4IGRkNzY0ZTA0NzFmMi4uNzc2
MDQwZDkxYmQ0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9ldGh0b29sLmMNCj4gQEAgLTE5MDUsNyArMTkwNSw4IEBAIHN0YXRp
YyBpbnQgbWx4NWVfZmxhc2hfZGV2aWNlKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsDQo+ICAv
KiBXaGVuIENPTkZJR19NTFg1X0VOX1JYTkZDPW4gd2Ugb25seSBzdXBwb3J0IEVUSFRPT0xfR1JY
UklOR1MNCj4gICAqIG90aGVyd2lzZSB0aGlzIGZ1bmN0aW9uIHdpbGwgYmUgZGVmaW5lZCBmcm9t
IGVuX2ZzX2V0aHRvb2wuYw0KPiAgICovDQoNCkFzIHRoZSBhYm92ZSBjb21tZW50IHN0YXRlcywg
d2hlbiBDT05GSUdfTUxYNV9FTl9SWE5GQyBpcyBkaXNhYmxlZCwNCm1seDVlX2dldF9yeG5mYyBp
cyBvbmx5IGRlZmluZWQsIGRlY2xhcmVkIGFuZCB1c2VkIGluIHRoaXMgZmlsZSwgc28gaXQNCm11
c3QgYmUgc3RhdGljLiBPdGhlcndpc2UgaXQgd2lsbCBiZSBkZWZpbmVkIGluIGFub3RoZXIgZmls
ZSB3aGljaA0KcHJvdmlkZXMgbXVjaCBtdWNoIG1vcmUgZnVuY3Rpb25hbGl0eSBmb3IgZXRodG9v
bCBmbG93IHN0ZWVyaW5nLg0KDQpjYW4geW91IHBsZWFzZSBwcm92aWRlIG1vcmUgaW5mb3JtYXRp
b24gb2Ygd2hhdCB3ZW50IHdyb25nIG9uIHlvdXINCmJ1aWxkIG1hY2hpbmUgPw0KDQo+IC1zdGF0
aWMgaW50IG1seDVlX2dldF9yeG5mYyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QNCj4g
ZXRodG9vbF9yeG5mYyAqaW5mbywgdTMyICpydWxlX2xvY3MpDQo+ICtpbnQgbWx4NWVfZ2V0X3J4
bmZjKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBldGh0b29sX3J4bmZjDQo+ICppbmZv
LA0KPiArCQkgICAgdTMyICpydWxlX2xvY3MpDQo+ICB7DQo+ICAJc3RydWN0IG1seDVlX3ByaXYg
KnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KPiAgDQoNCg==
