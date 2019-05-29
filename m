Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CA32E88F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfE2Wuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:50:46 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40056
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbfE2Wup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 18:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G04EXZkjHCo20NN/knB0LUOWmRo9eVgSz0by4kya8q8=;
 b=BGM6UIoKfhC3aXE9zSKs2WHE1l0emIxXwv/VcxoHEpu8/ODxmVd3/e6FHxDfU0Lq7z1I7OIRhkLs+mF7a0Rr59361vhBd455sSICj2E8Z6+CwTBz5hr2YwrXtK7CKJpwd4MZRR9iemH7ZDkUrPHodTwC85sktO3pKBBATyV/PoY=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB4351.eurprd05.prod.outlook.com (52.133.12.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 22:50:39 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 22:50:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 5/6] {IB,net}/mlx5: No need to typecast from void*
 to mlx5_ib_dev*
Thread-Topic: [PATCH mlx5-next 5/6] {IB,net}/mlx5: No need to typecast from
 void* to mlx5_ib_dev*
Thread-Index: AQHVFnDvTQUzpc7HYkOtVoAS0PDoeQ==
Date:   Wed, 29 May 2019 22:50:39 +0000
Message-ID: <20190529224949.18194-6-saeedm@mellanox.com>
References: <20190529224949.18194-1-saeedm@mellanox.com>
In-Reply-To: <20190529224949.18194-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5b0ed70-6221-4937-2d16-08d6e48811bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4351;
x-ms-traffictypediagnostic: VI1PR05MB4351:
x-microsoft-antispam-prvs: <VI1PR05MB435190B836A345CCF3D6EA30BE1F0@VI1PR05MB4351.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(66446008)(73956011)(66946007)(64756008)(186003)(305945005)(76176011)(68736007)(66476007)(52116002)(107886003)(86362001)(1076003)(50226002)(4326008)(450100002)(66556008)(85306007)(6636002)(99286004)(54906003)(53936002)(102836004)(478600001)(6506007)(36756003)(8936002)(6512007)(8676002)(81156014)(110136005)(476003)(3846002)(6486002)(2616005)(256004)(26005)(5660300002)(6436002)(446003)(486006)(25786009)(2906002)(71200400001)(71190400001)(386003)(316002)(6116002)(66066001)(11346002)(14454004)(7736002)(81166006)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4351;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Az5plj4f04wdFtGYVnicd0kX9T2fOT043tq9qE5AX1/w9bHCKJVmQeVEsbnWEXEQ62nN0B3BlXCvnNk5xALl2awL9n4TNwuvU/9F1NAtWOsDLQ/BGWscY/LA8ShjgEC1Y2CoFqjJ2MENDCO+qSTYgeqDX/afDTthSHMFaNDlsMJIthLZs9k0xIwvg4unZaO+s5NRbj1JukyrEASfkpnX1E3C2B50d7w0mwED6LdGKw5hywaROPA+SJ9FUfaHyqVgn9bOstTcIph8fjvd5NvPG/quE+Bu3SJHYRap26wVb3KU3aGm+9k2O8fMpiekE+qeDw/whAF0bTqcp0QlB0cdrJaaHCeg78kdvS6OXsdhRcH+K4EMTZrovJHZU7AmkZU7VFdgRbq3qaUK8S5FKBdcIrTf1XtYyIWTAIO1e7gFTjY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b0ed70-6221-4937-2d16-08d6e48811bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 22:50:39.1104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCkF2b2lkIHR5cGVjYXN0
aW5nIGZyb20gdm9pZCogdG8gbWx4NV9pYl9kZXYqIG9yIG1seDVlX3JlcF9wcml2Kg0KYXMgaXQg
aXMgbm90IG5lZWRlZC4NCg0KU2lnbmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxs
YW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5oICAgICAgICAg
ICAgICB8IDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
cmVwLmggfCAyICstDQogMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAu
aCBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5oDQppbmRleCAxZDk3NzhkYThh
NTAuLmM5OTUxMDJiMDI3NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1
L2liX3JlcC5oDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuaA0KQEAg
LTcyLDYgKzcyLDYgQEAgc3RydWN0IG5ldF9kZXZpY2UgKm1seDVfaWJfZ2V0X3JlcF9uZXRkZXYo
c3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LA0KIHN0YXRpYyBpbmxpbmUNCiBzdHJ1Y3QgbWx4NV9p
Yl9kZXYgKm1seDVfaWJfcmVwX3RvX2RldihzdHJ1Y3QgbWx4NV9lc3dpdGNoX3JlcCAqcmVwKQ0K
IHsNCi0JcmV0dXJuIChzdHJ1Y3QgbWx4NV9pYl9kZXYgKilyZXAtPnJlcF9pZltSRVBfSUJdLnBy
aXY7DQorCXJldHVybiByZXAtPnJlcF9pZltSRVBfSUJdLnByaXY7DQogfQ0KICNlbmRpZiAvKiBf
X01MWDVfSUJfUkVQX0hfXyAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9yZXAuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuaA0KaW5kZXggODNiNTczYjFhYmFjLi5jNDBjMDI1YWZkOTkgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVw
LmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAu
aA0KQEAgLTkxLDcgKzkxLDcgQEAgc3RydWN0IG1seDVlX3JlcF9wcml2IHsNCiBzdGF0aWMgaW5s
aW5lDQogc3RydWN0IG1seDVlX3JlcF9wcml2ICptbHg1ZV9yZXBfdG9fcmVwX3ByaXYoc3RydWN0
IG1seDVfZXN3aXRjaF9yZXAgKnJlcCkNCiB7DQotCXJldHVybiAoc3RydWN0IG1seDVlX3JlcF9w
cml2ICopcmVwLT5yZXBfaWZbUkVQX0VUSF0ucHJpdjsNCisJcmV0dXJuIHJlcC0+cmVwX2lmW1JF
UF9FVEhdLnByaXY7DQogfQ0KIA0KIHN0cnVjdCBtbHg1ZV9uZWlnaCB7DQotLSANCjIuMjEuMA0K
DQo=
