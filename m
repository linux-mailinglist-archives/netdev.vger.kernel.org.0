Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4C5A6F0
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfF1WgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:00 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfF1Wf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=C6DLYYFORbQVYSjtqWG4vX0UPkrjqx6AIGN69/kPb9KBji4X/C2A+NCgEfey2hc/d/TL7+7aAvn3NN3fzHHfHkrSuP09p8ZvbGzfG1Qut8DabFXH9h+9MPX12HLIcdHvyRO7Yec/qMQE9qjT0Puzztv+W2qzo+MkOuTltJ8a0Qg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwCJYRD3T2L8zxlpSXWmA2ofIeueVPplIBXNzMPmfVs=;
 b=jnuTRho8huxbOSs+VJoRlcgoAafcmKTN8fnTuOm6EaLubcaG+IVPjPnow2YqY3cHzeO0aLvaCWO7Bu1Pxs1ood1Gn52LPnTHTWciRQN1H3Glw3bQwLVQznkv+U8+/QlxW1vjlLe/ewFZNRK+CH0BvyYVecSWai9xPe/4QLVNLtw=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwCJYRD3T2L8zxlpSXWmA2ofIeueVPplIBXNzMPmfVs=;
 b=bRjqvTTBCLRKExrDCLdTBoTS3VU8eIbPj6H8i7R6lBxyN8C78IRxdYfXGj2WLIdillB45NWXuHtaVzpK+Ui4kJkkllB+dbvKDEKFFqJ+6QPUhXY/G0pH3ZL2q/HN+R+AqRFlfFyfOQiLYKZY68l5xOfi9zX5SiKCeOTUhJD9FE8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shay Agroskin <shayag@mellanox.com>
Subject: [PATCH mlx5-next 02/18] net/mlx5: Added MCQI and MCQS registers'
 description to ifc
Thread-Topic: [PATCH mlx5-next 02/18] net/mlx5: Added MCQI and MCQS registers'
 description to ifc
Thread-Index: AQHVLgHW2wAkUBXsrkqw18oT801KgQ==
Date:   Fri, 28 Jun 2019 22:35:50 +0000
Message-ID: <20190628223516.9368-3-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1aa64d30-f332-4743-1f7c-08d6fc18f877
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB235752C559E96EC52E5F6E3DBEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f6SZtREHATLvq7qpcI5GE65fV/+C6sOnFDk7ZWKq5g/e2kNIoW1wVmih/8OuH4U7ybYvE5pkQGWIKgf1pDz4T7dZE9AheNMuAHmZEwVcjD1kjp+ddtuJStBOsImb92LtBWCiiH+cQPiYYjSRgPLBIIsty0Y+pXACoslIwzsFCz0re6Jo2VoVYstDgY6blxps9AYwkf1XIzy3VNo8O6qLPtNiZHGJKs6/bMyUuyV2Gkx778Sl+mU3Xad92OVooLsfu5N9+LQIN39x1lZGJfqBHHOxBpPLEKJLOvPmtFTII0lPbCddb2vLWwQ2652823pLa3vtJG2+N1kRsMtvxOzH7qyc7LruOpgs8787QiXS6+vhpHEGVBcQ+N6xCBK/0pFw2/ByIIpWVVfilSgpyjUu5STd/hTkgmn1s27m+BHqPfs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa64d30-f332-4743-1f7c-08d6fc18f877
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:50.1207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2hheSBBZ3Jvc2tpbiA8c2hheWFnQG1lbGxhbm94LmNvbT4NCg0KR2l2ZW4gYSBmdyBj
b21wb25lbnQgaW5kZXgsIHRoZSBNQ1FJIHJlZ2lzdGVyIGFsbG93cyB1cyB0byBxdWVyeQ0KdGhp
cyBjb21wb25lbnQncyBpbmZvcm1hdGlvbiAoZS5nLiBpdHMgdmVyc2lvbiBhbmQgY2FwYWJpbGl0
aWVzKS4NCg0KR2l2ZW4gYSBmdyBjb21wb25lbnQgaW5kZXgsIHRoZSBNQ1FTIHJlZ2lzdGVyIGFs
bG93cyB1cyB0byBxdWVyeSB0aGUNCnN0YXR1cyBvZiBhIGZ3IGNvbXBvbmVudCwgaW5jbHVkaW5n
IGl0cyB0eXBlIGFuZCBzdGF0ZQ0KKGUuZy4gUFJFU0VUL0lOX1VTRSkuDQpJdCBjYW4gYmUgdXNl
ZCB0byBmaW5kIHRoZSBpbmRleCBvZiBhIGNvbXBvbmVudCBvZiBhIHNwZWNpZmljIHR5cGUsIGJ5
DQpzZXF1ZW50aWFsbHkgaW5jcmVhc2luZyB0aGUgY29tcG9uZW50IGluZGV4LCBhbmQgcXVlcnlp
bmcgZWFjaCB0aW1lIHRoZQ0KdHlwZSBvZiB0aGUgcmV0dXJuZWQgY29tcG9uZW50Lg0KSWYgbWF4
IGNvbXBvbmVudCBpbmRleCBpcyByZWFjaGVkLCAnbGFzdF9pbmRleF9mbGFnJyBpcyBzZXQgYnkg
dGhlIEhDQS4NCg0KVGhlc2UgcmVnaXN0ZXJzJyBkZXNjcmlwdGlvbiB3YXMgYWRkZWQgdG8gcXVl
cnkgdGhlIHJ1bm5pbmcgYW5kIHBlbmRpbmcNCmZ3IHZlcnNpb24gb2YgdGhlIEhDQS4NCg0KU2ln
bmVkLW9mZi1ieTogU2hheSBBZ3Jvc2tpbiA8c2hheWFnQG1lbGxhbm94LmNvbT4NClNpZ25lZC1v
ZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogaW5jbHVk
ZS9saW51eC9tbHg1L2RyaXZlci5oICAgfCAgMSArDQogaW5jbHVkZS9saW51eC9tbHg1L21seDVf
aWZjLmggfCA1OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KIDIgZmlsZXMg
Y2hhbmdlZCwgNTggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIu
aA0KaW5kZXggODdmNzdkZWQ3OGQ0Li4yZmY2MjRhOTFlM2QgMTAwNjQ0DQotLS0gYS9pbmNsdWRl
L2xpbnV4L21seDUvZHJpdmVyLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0K
QEAgLTEzOCw2ICsxMzgsNyBAQCBlbnVtIHsNCiAJTUxYNV9SRUdfTVRQUFMJCSA9IDB4OTA1MywN
CiAJTUxYNV9SRUdfTVRQUFNFCQkgPSAweDkwNTQsDQogCU1MWDVfUkVHX01QRUdDCQkgPSAweDkw
NTYsDQorCU1MWDVfUkVHX01DUVMJCSA9IDB4OTA2MCwNCiAJTUxYNV9SRUdfTUNRSQkJID0gMHg5
MDYxLA0KIAlNTFg1X1JFR19NQ0MJCSA9IDB4OTA2MiwNCiAJTUxYNV9SRUdfTUNEQQkJID0gMHg5
MDYzLA0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oIGIvaW5jbHVk
ZS9saW51eC9tbHg1L21seDVfaWZjLmgNCmluZGV4IGRiMDBlZmZhYTgzYS4uZTJhNzdiNTE1MmE4
IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCisrKyBiL2luY2x1
ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oDQpAQCAtODU0Miw3ICs4NTQyLDcgQEAgc3RydWN0IG1s
eDVfaWZjX21jYW1fYWNjZXNzX3JlZ19iaXRzIHsNCiAJdTggICAgICAgICBtY2RhWzB4MV07DQog
CXU4ICAgICAgICAgbWNjWzB4MV07DQogCXU4ICAgICAgICAgbWNxaVsweDFdOw0KLQl1OCAgICAg
ICAgIHJlc2VydmVkX2F0XzFmWzB4MV07DQorCXU4ICAgICAgICAgbWNxc1sweDFdOw0KIA0KIAl1
OCAgICAgICAgIHJlZ3NfOTVfdG9fODdbMHg5XTsNCiAJdTggICAgICAgICBtcGVnY1sweDFdOw0K
QEAgLTkwMzQsNiArOTAzNCwyNCBAQCBzdHJ1Y3QgbWx4NV9pZmNfbXRwcHNlX3JlZ19iaXRzIHsN
CiAJdTggICAgICAgICByZXNlcnZlZF9hdF80MFsweDQwXTsNCiB9Ow0KIA0KK3N0cnVjdCBtbHg1
X2lmY19tY3FzX3JlZ19iaXRzIHsNCisJdTggICAgICAgICBsYXN0X2luZGV4X2ZsYWdbMHgxXTsN
CisJdTggICAgICAgICByZXNlcnZlZF9hdF8xWzB4N107DQorCXU4ICAgICAgICAgZndfZGV2aWNl
WzB4OF07DQorCXU4ICAgICAgICAgY29tcG9uZW50X2luZGV4WzB4MTBdOw0KKw0KKwl1OCAgICAg
ICAgIHJlc2VydmVkX2F0XzIwWzB4MTBdOw0KKwl1OCAgICAgICAgIGlkZW50aWZpZXJbMHgxMF07
DQorDQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfNDBbMHgxN107DQorCXU4ICAgICAgICAgY29t
cG9uZW50X3N0YXR1c1sweDVdOw0KKwl1OCAgICAgICAgIGNvbXBvbmVudF91cGRhdGVfc3RhdGVb
MHg0XTsNCisNCisJdTggICAgICAgICBsYXN0X3VwZGF0ZV9zdGF0ZV9jaGFuZ2VyX3R5cGVbMHg0
XTsNCisJdTggICAgICAgICBsYXN0X3VwZGF0ZV9zdGF0ZV9jaGFuZ2VyX2hvc3RfaWRbMHg0XTsN
CisJdTggICAgICAgICByZXNlcnZlZF9hdF82OFsweDE4XTsNCit9Ow0KKw0KIHN0cnVjdCBtbHg1
X2lmY19tY3FpX2NhcF9iaXRzIHsNCiAJdTggICAgICAgICBzdXBwb3J0ZWRfaW5mb19iaXRtYXNr
WzB4MjBdOw0KIA0KQEAgLTkwNTQsNiArOTA3Miw0MyBAQCBzdHJ1Y3QgbWx4NV9pZmNfbWNxaV9j
YXBfYml0cyB7DQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfODZbMHgxYV07DQogfTsNCiANCitz
dHJ1Y3QgbWx4NV9pZmNfbWNxaV92ZXJzaW9uX2JpdHMgew0KKwl1OCAgICAgICAgIHJlc2VydmVk
X2F0XzBbMHgyXTsNCisJdTggICAgICAgICBidWlsZF90aW1lX3ZhbGlkWzB4MV07DQorCXU4ICAg
ICAgICAgdXNlcl9kZWZpbmVkX3RpbWVfdmFsaWRbMHgxXTsNCisJdTggICAgICAgICByZXNlcnZl
ZF9hdF80WzB4MTRdOw0KKwl1OCAgICAgICAgIHZlcnNpb25fc3RyaW5nX2xlbmd0aFsweDhdOw0K
Kw0KKwl1OCAgICAgICAgIHZlcnNpb25bMHgyMF07DQorDQorCXU4ICAgICAgICAgYnVpbGRfdGlt
ZVsweDQwXTsNCisNCisJdTggICAgICAgICB1c2VyX2RlZmluZWRfdGltZVsweDQwXTsNCisNCisJ
dTggICAgICAgICBidWlsZF90b29sX3ZlcnNpb25bMHgyMF07DQorDQorCXU4ICAgICAgICAgcmVz
ZXJ2ZWRfYXRfZTBbMHgyMF07DQorDQorCXU4ICAgICAgICAgdmVyc2lvbl9zdHJpbmdbOTJdWzB4
OF07DQorfTsNCisNCitzdHJ1Y3QgbWx4NV9pZmNfbWNxaV9hY3RpdmF0aW9uX21ldGhvZF9iaXRz
IHsNCisJdTggICAgICAgICBwZW5kaW5nX3NlcnZlcl9hY19wb3dlcl9jeWNsZVsweDFdOw0KKwl1
OCAgICAgICAgIHBlbmRpbmdfc2VydmVyX2RjX3Bvd2VyX2N5Y2xlWzB4MV07DQorCXU4ICAgICAg
ICAgcGVuZGluZ19zZXJ2ZXJfcmVib290WzB4MV07DQorCXU4ICAgICAgICAgcGVuZGluZ19md19y
ZXNldFsweDFdOw0KKwl1OCAgICAgICAgIGF1dG9fYWN0aXZhdGVbMHgxXTsNCisJdTggICAgICAg
ICBhbGxfaG9zdHNfc3luY1sweDFdOw0KKwl1OCAgICAgICAgIGRldmljZV9od19yZXNldFsweDFd
Ow0KKwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzdbMHgxOV07DQorfTsNCisNCit1bmlvbiBtbHg1
X2lmY19tY3FpX3JlZ19kYXRhX2JpdHMgew0KKwlzdHJ1Y3QgbWx4NV9pZmNfbWNxaV9jYXBfYml0
cyAgICAgICAgICAgICAgIG1jcWlfY2FwczsNCisJc3RydWN0IG1seDVfaWZjX21jcWlfdmVyc2lv
bl9iaXRzICAgICAgICAgICBtY3FpX3ZlcnNpb247DQorCXN0cnVjdCBtbHg1X2lmY19tY3FpX2Fj
dGl2YXRpb25fbWV0aG9kX2JpdHMgbWNxaV9hY3RpdmF0aW9uX21hdGhvZDsNCit9Ow0KKw0KIHN0
cnVjdCBtbHg1X2lmY19tY3FpX3JlZ19iaXRzIHsNCiAJdTggICAgICAgICByZWFkX3BlbmRpbmdf
Y29tcG9uZW50WzB4MV07DQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMVsweGZdOw0KQEAgLTkw
NzEsNyArOTEyNiw3IEBAIHN0cnVjdCBtbHg1X2lmY19tY3FpX3JlZ19iaXRzIHsNCiAJdTggICAg
ICAgICByZXNlcnZlZF9hdF9hMFsweDEwXTsNCiAJdTggICAgICAgICBkYXRhX3NpemVbMHgxMF07
DQogDQotCXU4ICAgICAgICAgZGF0YVswXVsweDIwXTsNCisJdW5pb24gbWx4NV9pZmNfbWNxaV9y
ZWdfZGF0YV9iaXRzIGRhdGFbMF07DQogfTsNCiANCiBzdHJ1Y3QgbWx4NV9pZmNfbWNjX3JlZ19i
aXRzIHsNCi0tIA0KMi4yMS4wDQoNCg==
