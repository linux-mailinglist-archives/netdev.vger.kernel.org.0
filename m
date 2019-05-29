Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655FC2D395
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfE2CIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:01 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbfE2CIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mK9WUH9SZCgi+6HzMjWktBmHe3sSOWDnIVfKLzDczE=;
 b=C+mFOhUCdNE59ekkGGb8ByTXYn8WhUYXJok060+hgQ1P8vaIcdyf9sdyriLhaFF4Ytr7YK0hdrlDIi/kzL8uzKCHA31emxhBhWYinH+hVGZqBK1xavd2eOqsUAGa3kqmmT4hmmS6NaCtUZrh4iTbAXi77w03G15ISlfm1fhfdCE=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:07:57 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:07:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/6] Mellanox, mlx5 fixes 2019-05-28
Thread-Topic: [pull request][net 0/6] Mellanox, mlx5 fixes 2019-05-28
Thread-Index: AQHVFcNVgSQJLdYEgUawUP9Qj9S1rQ==
Date:   Wed, 29 May 2019 02:07:57 +0000
Message-ID: <20190529020737.4172-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48251080-6c5b-4f72-71b3-08d6e3da77b8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB5947CD3CECB18A29AE77F373BE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(186003)(4326008)(476003)(68736007)(486006)(6512007)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(107886003)(66066001)(64756008)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: onaq3J5WZAIG19w6ItEXlyQyyXL0c0e68yJRQW595uyePLcB0mqEA2mIsgg49s7orozBD8dJr3nEO08ZDCPoq8WhcbsofBBnKNpTaKmKia3jq9Pvqu5MmbPYGKLpwsc3YL7W2OAdZbWIGbR2oYPScSb8H0pW5WSRFbXUoLWqHgexyGQ5DMnEnEXUd5RIZBqewaTYOyuK/5tiWxc5Ilwl2Y3n0mohmAP9S7rwotIBwHu+lzo71kleV/dQx0M4PbR3JWO3OLuadkVMwM6Qq0/lPOuWlfVXngXuh9F/LGTDbO/Sfo+LeIFe0EFKysIfjpttqoshDyt2IJzI3szRZTk6MrwAjkWQ840nbtyHRjz8r6/j7a194o30vZU4qwsWrmskKuxw1idcG24RsZU5uZqOrhlQ7Pqli4TZ6HxBrJvFD8g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48251080-6c5b-4f72-71b3-08d6e3da77b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:07:57.4083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwNCg0KVGhpcyBzZXJpZXMgaW50cm9kdWNlcyBzb21lIGZpeGVzIHRvIG1seDUgZHJp
dmVyLg0KDQpQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IHByb2Js
ZW0uDQoNCkZvciAtc3RhYmxlIHY0LjEzOg0KKCduZXQvbWx4NTogQWxsb2NhdGUgcm9vdCBucyBt
ZW1vcnkgdXNpbmcga3phbGxvYyB0byBtYXRjaCBrZnJlZScpDQoNCkZvciAtc3RhYmxlIHY0LjE2
Og0KKCduZXQvbWx4NTogQXZvaWQgZG91YmxlIGZyZWUgaW4gZnMgaW5pdCBlcnJvciB1bndpbmRp
bmcgcGF0aCcpDQoNCkZvciAtc3RhYmxlIHY0LjE4Og0KKCduZXQvbWx4NWU6IERpc2FibGUgcnho
YXNoIHdoZW4gQ1FFIGNvbXByZXNzIGlzIGVuYWJsZWQnKQ0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
LS0tDQpUaGUgZm9sbG93aW5nIGNoYW5nZXMgc2luY2UgY29tbWl0IGE2Y2QwZDJkNDkzYWI3ODA2
YjQ5ZjczOGI0ZjY2MzYyNDM3Y2MwOWU6DQoNCiAgRG9jdW1lbnRhdGlvbjogbmV0LXN5c2ZzOiBS
ZW1vdmUgZHVwbGljYXRlIFBIWSBkZXZpY2UgZG9jdW1lbnRhdGlvbiAoMjAxOS0wNS0yOCAxNzoy
Njo0NCAtMDcwMCkNCg0KYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQoN
CiAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZWVkL2xp
bnV4LmdpdCB0YWdzL21seDUtZml4ZXMtMjAxOS0wNS0yOA0KDQpmb3IgeW91IHRvIGZldGNoIGNo
YW5nZXMgdXAgdG8gYzAxOTRlMmQwZWYwZTVjZTVlMjFhMzU2NDBkMjNhNzA2ODI3YWUyODoNCg0K
ICBuZXQvbWx4NWU6IERpc2FibGUgcnhoYXNoIHdoZW4gQ1FFIGNvbXByZXNzIGlzIGVuYWJsZWQg
KDIwMTktMDUtMjggMTg6MjU6NDIgLTA3MDApDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCm1seDUtZml4ZXMtMjAxOS0w
NS0yOA0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQpQYXJhdiBQYW5kaXQgKDMpOg0KICAgICAgbmV0L21seDU6IEF2b2lk
IGRvdWJsZSBmcmVlIG9mIHJvb3QgbnMgaW4gdGhlIGVycm9yIGZsb3cgcGF0aA0KICAgICAgbmV0
L21seDU6IEF2b2lkIGRvdWJsZSBmcmVlIGluIGZzIGluaXQgZXJyb3IgdW53aW5kaW5nIHBhdGgN
CiAgICAgIG5ldC9tbHg1OiBBbGxvY2F0ZSByb290IG5zIG1lbW9yeSB1c2luZyBremFsbG9jIHRv
IG1hdGNoIGtmcmVlDQoNClNhZWVkIE1haGFtZWVkICgyKToNCiAgICAgIG5ldC9tbHg1OiBGaXgg
ZXJyb3IgaGFuZGxpbmcgaW4gbWx4NV9sb2FkKCkNCiAgICAgIG5ldC9tbHg1ZTogRGlzYWJsZSBy
eGhhc2ggd2hlbiBDUUUgY29tcHJlc3MgaXMgZW5hYmxlZA0KDQp3ZW54dSAoMSk6DQogICAgICBu
ZXQvbWx4NWU6IHJlc3RyaWN0IHRoZSByZWFsX2RldiBvZiB2bGFuIGRldmljZSBpcyB0aGUgc2Ft
ZSBhcyB1cGxpbmsgZGV2aWNlDQoNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fbWFpbi5jIHwgMTMgKysrKysrKysrKysrDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jICB8ICAyICstDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYyB8IDI0ICsrKysrKysrLS0tLS0tLS0tLS0t
LS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYyAgICB8
ICAyICstDQogNCBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMo
LSkNCg==
