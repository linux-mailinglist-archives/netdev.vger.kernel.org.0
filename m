Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044F24AA33
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbfFRSrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:47:32 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:15489
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730162AbfFRSrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWSE8lJExkF6WTMy1f/heNuJbBFen2JAZ+j/WTKVxTE=;
 b=QTCsI1mjpqj1qQLi2xuUSQKm3b6hYzGqE7pbRuFChbW58cQQai/SoffGwXgBBHYmfKKfBVUzus8wL+ANlx7gSaDTHQHeQSa+dtGQ128UYxc2VcdWpjmRLOMkrmyshHQu8iTDRkbnqafvn9kgCGTBr5byNWfNfLwE4sdMdk3KzcM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2472.eurprd05.prod.outlook.com (10.168.77.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 18:47:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:47:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     Mark Zhang <markz@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v4 01/17] net/mlx5: Add
 rts2rts_qp_counters_set_id field in hca cap
Thread-Topic: [PATCH mlx5-next v4 01/17] net/mlx5: Add
 rts2rts_qp_counters_set_id field in hca cap
Thread-Index: AQHVJfr9uGqIkfgg7UWzIj7bjfNbLKahwJaA
Date:   Tue, 18 Jun 2019 18:47:28 +0000
Message-ID: <183c4bbd4b9f78dec18c3cf41bdc6ee71512ed52.camel@mellanox.com>
References: <20190618172625.13432-1-leon@kernel.org>
         <20190618172625.13432-2-leon@kernel.org>
In-Reply-To: <20190618172625.13432-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86cb0389-d2ba-415e-89d9-08d6f41d6a2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2472;
x-ms-traffictypediagnostic: DB6PR0501MB2472:
x-microsoft-antispam-prvs: <DB6PR0501MB2472121A69661E0632D50742BEEA0@DB6PR0501MB2472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(6436002)(4744005)(2501003)(76116006)(2201001)(99286004)(14454004)(86362001)(2906002)(3846002)(81166006)(8936002)(6486002)(91956017)(5660300002)(36756003)(81156014)(8676002)(53936002)(71190400001)(118296001)(68736007)(478600001)(71200400001)(6116002)(66556008)(14444005)(66476007)(66446008)(64756008)(256004)(73956011)(76176011)(305945005)(66066001)(7736002)(2616005)(102836004)(54906003)(58126008)(110136005)(476003)(486006)(316002)(229853002)(6506007)(6512007)(6246003)(26005)(186003)(4326008)(11346002)(446003)(66946007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2472;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AkNXuI/SPNpydGOewjM7XuHw+K7Dfd57frauT0fq/O9ovCEWoslV9GVA0ZP672UhRtuJ8acn3KXry0uP1RZnN+DMpFP3ZsNcijWDn6N0YqIF2N7tdYs/8rl0pQO+AtQlj4/TEqsxCieqEnkeSlqpeiH+CZ3ep405XwRiEx9NJmxrbW3SkvfngO1Uk4RO1yF8cWvSjDnPuLHkjvnbWhteSItiIkQ6KWL99Kd585JO5NkPNnuFRtcvixFDTLLdB/IZDKAbvNz4sy+LrcEIIhDm1IQ7wel4Tgg+s75lkBoroPe9qJfc/aZVQ4URM5hQrzoactE8aKeYi1JkfXBFQTCGPPy6anfjpmf5lbTu0F7VZkuBbNOy0iTsKryBankOzKKsvJTgGCo0zYfaA1mDlyBOaKRqK+I6kN41tqDD8vY3ou4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C17827FB5DF7BE419ACCFFE8FB0D86F0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cb0389-d2ba-415e-89d9-08d6f41d6a2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:47:28.9933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDIwOjI2ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IEZyb206IE1hcmsgWmhhbmcgPG1hcmt6QG1lbGxhbm94LmNvbT4NCj4gDQo+IEFkZCBydHMy
cnRzX3FwX2NvdW50ZXJzX3NldF9pZCBmaWVsZCBpbiBoY2EgY2FwIHNvIHRoYXQgUlRTMlJUUw0K
PiBxcCBtb2RpZmljYXRpb24gY2FuIGJlIHVzZWQgdG8gY2hhbmdlIHRoZSBjb3VudGVyIG9mIGEg
UVAuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJrIFpoYW5nIDxtYXJrekBtZWxsYW5veC5jb20+
DQo+IFJldmlld2VkLWJ5OiBNYWpkIERpYmJpbnkgPG1hamRAbWVsbGFub3guY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+IC0tLQ0K
PiAgaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggfCA0ICsrKy0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KPiBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1
X2lmYy5oDQo+IGluZGV4IGUzYzE1NGI1NzNhMi4uMTYzNDg1MjhmZWY2IDEwMDY0NA0KPiAtLS0g
YS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L21s
eDUvbWx4NV9pZmMuaA0KPiBAQCAtMTAyOCw3ICsxMDI4LDkgQEAgc3RydWN0IG1seDVfaWZjX2Nt
ZF9oY2FfY2FwX2JpdHMgew0KPiAgCXU4ICAgICAgICAgY2NfbW9kaWZ5X2FsbG93ZWRbMHgxXTsN
Cj4gIAl1OCAgICAgICAgIHN0YXJ0X3BhZFsweDFdOw0KPiAgCXU4ICAgICAgICAgY2FjaGVfbGlu
ZV8xMjhieXRlWzB4MV07DQo+IC0JdTggICAgICAgICByZXNlcnZlZF9hdF8xNjVbMHhhXTsNCj4g
Kwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzE2NVsweDRdOw0KPiArCXU4ICAgICAgICAgcnRzMnJ0
c19xcF9jb3VudGVyc19zZXRfaWRbMHgxXTsNCj4gKwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzE2
YVsweDVdOw0KPiAgCXU4ICAgICAgICAgcWNhbV9yZWdbMHgxXTsNCj4gIAl1OCAgICAgICAgIGdp
ZF90YWJsZV9zaXplWzB4MTBdOw0KPiANCj4gLS0NCj4gMi4yMC4xDQo+IA0KDQpBY2tlZC1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo=
