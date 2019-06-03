Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EEB33271
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfFCOmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:22 -0400
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:22244
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728882AbfFCOmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQF0LMVnybJc2JHI+eIag4WhgdRpzXsokVYKDxt7Dqw=;
 b=CUu9+/LLvUk7ZbHNGyM3lK3OrtycTL+CuIYIroocrb3XCu494+gwHz31/M2dco++UlYKpDdzH9Nbwwg34ONwWzUhq2FoNh6GKuwYvr+OeC0IUygZuCZHMlRjxiANORwYCO2ddikAKew2ga4qNGuux7rPt0qxnbq2TD4iSw3Z9EM=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:12 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:12 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Thread-Topic: [PATCH net-next v3 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Thread-Index: AQHVGhqHnyHUOFwezk6WN9nCJNIDvw==
Date:   Mon, 3 Jun 2019 14:42:12 +0000
Message-ID: <20190603144112.27713-2-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:3:64::14) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10ab10ea-c725-4282-0fb5-08d6e831a9f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB257461DF0EA83F892DD019DD8A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(14444005)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: knOwTKaZXmhd7vRjQe4Z0E6WUsE6y3Y0wPL/yJ3hBrurE6u0kdzeRE+7llXb3mKPPf8aeneytjSriw+l5xPVRnwjjMHYsqRDSSIjpwOwIK7mBGPZ0HhAIG6oX/+FRIkN5vZxh/Et/allROKTGcIn5JLna0gWJmuYUJfezCGbRsCYAfYz2qE7sezaRGAq3ABuu0nUTt/69pIb/7UQ2Q3yZVUETA66giWRNyyGz8RhvUDp9chOjDhhUhGIBhLEPvkDHGkhb2NYau0WK7rGtt60MbAGlXn8k5kzYJKhRigidRUEuehkTzDKmKf8olKQJsnHl9GJiHVCzvIia+qwkIOCRWymWebCSZPvhSjijesHM7Oc2Zd+uHS6vxNtZ7q0Qg9KPPbgP+nZTmCweKlR+IndsgrQqUmOCgv0IvyZmWrlnB8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ab10ea-c725-4282-0fb5-08d6e831a9f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:12.4678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UXVpdGUgYSBmZXcgb2YgdGhlIGV4aXN0aW5nIHN1cHBvcnRlZCBjaGlwcyB0aGF0IHVzZQ0KbXY4
OGU2MDg1X2cxX2llZWVfcHJpX21hcCBhcyAtPmllZWVfcHJpX21hcCAoaW5jbHVkaW5nLCBpbmNp
ZGVudGFsbHksDQptdjg4ZTYwODUgaXRzZWxmKSBhY3R1YWxseSBoYXZlIGEgcmVzZXQgdmFsdWUg
b2YgMHhmYTUwIGluIHRoZQ0KRzFfSUVFRV9QUkkgcmVnaXN0ZXIuDQoNClRoZSBkYXRhIHNoZWV0
IGZvciB0aGUgbXY4OGU2MDk1LCBob3dldmVyLCBkb2VzIGRlc2NyaWJlIGEgcmVzZXQgdmFsdWUN
Cm9mIDB4ZmE0MS4NCg0KU28gcmF0aGVyIHRoYW4gY2hhbmdpbmcgdGhlIHZhbHVlIGluIHRoZSBl
eGlzdGluZyBjYWxsYmFjaywgaW50cm9kdWNlDQphIG5ldyB2YXJpYW50IHdpdGggdGhlIDB4ZmE1
MCB2YWx1ZS4gVGhhdCB3aWxsIGJlIHVzZWQgYnkgdGhlIHVwY29taW5nDQptdjg4ZTYyNTAsIGFu
ZCBleGlzdGluZyBjaGlwcyBjYW4gYmUgc3dpdGNoZWQgb3ZlciBvbmUgYnkgb25lLA0KcHJlZmVy
YWJseSBkb3VibGUtY2hlY2tpbmcgYm90aCB0aGUgZGF0YSBzaGVldCBhbmQgYWN0dWFsIGhhcmR3
YXJlIGluDQplYWNoIGNhc2UgLSBpZiBhbnlib2R5IGFjdHVhbGx5IGZlZWxzIHRoaXMgaXMgaW1w
b3J0YW50IGVub3VnaCB0bw0KY2FyZS4NCg0KU2lnbmVkLW9mZi1ieTogUmFzbXVzIFZpbGxlbW9l
cyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+DQotLS0NCiBkcml2ZXJzL25ldC9kc2EvbXY4
OGU2eHh4L2dsb2JhbDEuYyB8IDYgKysrKysrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9n
bG9iYWwxLmggfCAyICsrDQogMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5jIGIvZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMNCmluZGV4IDc3MGMwMzQwNjAzMy4uYzg1MWI3YjUz
MmE0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMNCisr
KyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5jDQpAQCAtMjk5LDYgKzI5OSwx
MiBAQCBpbnQgbXY4OGU2MDg1X2cxX2llZWVfcHJpX21hcChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAg
KmNoaXApDQogCXJldHVybiBtdjg4ZTZ4eHhfZzFfd3JpdGUoY2hpcCwgTVY4OEU2WFhYX0cxX0lF
RUVfUFJJLCAweGZhNDEpOw0KIH0NCiANCitpbnQgbXY4OGU2MjUwX2cxX2llZWVfcHJpX21hcChz
dHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApDQorew0KKwkvKiBSZXNldCB0aGUgSUVFRSBUYWcg
cHJpb3JpdGllcyB0byBkZWZhdWx0cyAqLw0KKwlyZXR1cm4gbXY4OGU2eHh4X2cxX3dyaXRlKGNo
aXAsIE1WODhFNlhYWF9HMV9JRUVFX1BSSSwgMHhmYTUwKTsNCit9DQorDQogLyogT2Zmc2V0IDB4
MWE6IE1vbml0b3IgQ29udHJvbCAqLw0KIC8qIE9mZnNldCAweDFhOiBNb25pdG9yICYgTUdNVCBD
b250cm9sIG9uIHNvbWUgZGV2aWNlcyAqLw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwx
LmgNCmluZGV4IGJiOTJhMTMwY2JlZi4uMmJjYmU3YzhiMjc5IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4
ZTZ4eHgvZ2xvYmFsMS5oDQpAQCAtMjc5LDYgKzI3OSw4IEBAIGludCBtdjg4ZTYzOTBfZzFfbWdt
dF9yc3ZkMmNwdShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApOw0KIGludCBtdjg4ZTYwODVf
ZzFfaXBfcHJpX21hcChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApOw0KIGludCBtdjg4ZTYw
ODVfZzFfaWVlZV9wcmlfbWFwKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCk7DQogDQoraW50
IG12ODhlNjI1MF9nMV9pZWVlX3ByaV9tYXAoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKTsN
CisNCiBpbnQgbXY4OGU2MTg1X2cxX3NldF9jYXNjYWRlX3BvcnQoc3RydWN0IG12ODhlNnh4eF9j
aGlwICpjaGlwLCBpbnQgcG9ydCk7DQogDQogaW50IG12ODhlNjA4NV9nMV9ybXVfZGlzYWJsZShz
dHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApOw0KLS0gDQoyLjIwLjENCg0K
