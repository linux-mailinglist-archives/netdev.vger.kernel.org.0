Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD3C10D35
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEATcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:32:19 -0400
Received: from mail-eopbgr30097.outbound.protection.outlook.com ([40.107.3.97]:30801
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbfEATcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 15:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnxtyj++f02Wi2AVk8CMMce9pi5kjZu/IIfuRB/SUxk=;
 b=rAvwQbmDbmX0+YD2BldpAdKRQf85qZmxIKjAzkqpOvLv9IYJHq0TgLWUMtIJiq3a86/3XENdTKhpON2VbQjbTiUTS1zK1wDKRJdPWzM+1AKafYO1tKaTGMlJH+W3ry7/1IIojGwK/a3oXLnHLEjQS4NPcWYBbvWU/ry76m8doIE=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM (20.177.62.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Wed, 1 May 2019 19:32:11 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 19:32:11 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [RFC PATCH 2/5] net: dsa: mv88e6xxx: rename smi read/write functions
Thread-Topic: [RFC PATCH 2/5] net: dsa: mv88e6xxx: rename smi read/write
 functions
Thread-Index: AQHVAFSSX8ZksdA+AkirAMJMhwKcSg==
Date:   Wed, 1 May 2019 19:32:11 +0000
Message-ID: <20190501193126.19196-3-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0005.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::15) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [5.186.118.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 897211a6-4900-47dc-08a9-08d6ce6bb4d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2382;
x-ms-traffictypediagnostic: VI1PR10MB2382:
x-microsoft-antispam-prvs: <VI1PR10MB23827E84A7A67DA641C322338A3B0@VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(396003)(136003)(346002)(376002)(189003)(199004)(81166006)(6512007)(14454004)(186003)(50226002)(8676002)(107886003)(66066001)(3846002)(71190400001)(4326008)(6116002)(8976002)(478600001)(54906003)(81156014)(1076003)(8936002)(25786009)(71446004)(72206003)(316002)(73956011)(71200400001)(305945005)(74482002)(68736007)(66476007)(76176011)(44832011)(486006)(64756008)(53936002)(66446008)(66556008)(14444005)(256004)(99286004)(110136005)(6436002)(446003)(386003)(476003)(11346002)(6486002)(7736002)(26005)(6506007)(42882007)(2906002)(66946007)(2616005)(36756003)(52116002)(102836004)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2382;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WNaEWga0lwxROfnHLrbo5ScqK3CNx/mhdqPpxqedpCEhjbBl28h8nbXcshIscTCOQrg2OcEcBVY2L4iP0nSoM8PbiepNmfmJQXp145GulAEfmkknpOmfHfWEPF+ypzwfIqzBFIH4vIr9spy+fiXiez4v2pOPm9lpt63ZE72mzSmR0zLyCoaQ2BtYJOvAWsVlLPMWFnJQ0KRKPJPHEExc3+MXotFPwZgoIYommAtcHVOLHaf4Cnjvlerq0p5nDJ+XLsS1praSJ00PWk0pzsIP8k0UQfNrZZtILznkCDBBWtND4JlBQwKjk1hn/tT/7W1nicfhFPDV7qpaUd/W3ZtfgwdaJQ5yvYKJdoQXoTeIrs0T/7SVYKfHO6j7xWI4PiMT3qfLmO2hdYzi6fayoNyOUuGvNWSBRYewCA43D8GFDP8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 897211a6-4900-47dc-08a9-08d6ce6bb4d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 19:32:11.4098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2l0aCB0aGUgcHJldmlvdXMgcGF0Y2ggYWRkaW5nIHN1cHBvcnQgZm9yIHR3byBjaGlwcyB1c2lu
ZyBkaXJlY3QgU01JDQphZGRyZXNzaW5nLCB0aGUgc21pX3NpbmdsZV9jaGlwX3tyZWFkLHdyaXRl
fSBmdW5jdGlvbnMgYXJlIHNsaWdodGx5DQptaXNuYW1lZC4gQ2hhbmdpbmcgdG8gc21pX2R1YWxf
Y2hpcF97cmVhZCx3cml0ZX0gd291bGQgbm90IGJlIGFjY3VyYXRlDQplaXRoZXIuDQoNCkNoYW5n
ZSB0aGUgbmFtZXMgdG8gcmVmbGVjdCBob3cgdGhlIGFjY2VzcyB0byB0aGUgU01JIHJlZ2lzdGVy
cyBpcw0KZG9uZSAoZGlyZWN0L2luZGlyZWN0KSByYXRoZXIgdGhhbiB0aGUgbnVtYmVyIG9mIGNo
aXBzIHRoYXQgY2FuIGJlDQpjb25uZWN0ZWQgdG8gdGhlIHNhbWUgU01JIG1hc3Rlci4gTm8gZnVu
Y3Rpb25hbCBjaGFuZ2UuDQoNClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211
cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9j
aGlwLmMgfCA0MiArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAyMSBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4
eC9jaGlwLmMNCmluZGV4IGY2NmRhYTc3Nzc0Yi4uZDhkODIzMGE2YmY1IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9t
djg4ZTZ4eHgvY2hpcC5jDQpAQCAtODYsOCArODYsOCBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9z
bWlfd3JpdGUoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAlyZXR1cm4gY2hpcC0+c21p
X29wcy0+d3JpdGUoY2hpcCwgYWRkciwgcmVnLCB2YWwpOw0KIH0NCiANCi1zdGF0aWMgaW50IG12
ODhlNnh4eF9zbWlfc2luZ2xlX2NoaXBfcmVhZChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAs
DQotCQkJCQkgIGludCBhZGRyLCBpbnQgcmVnLCB1MTYgKnZhbCkNCitzdGF0aWMgaW50IG12ODhl
Nnh4eF9zbWlfZGlyZWN0X3JlYWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KKwkJCQkg
ICAgIGludCBhZGRyLCBpbnQgcmVnLCB1MTYgKnZhbCkNCiB7DQogCWludCByZXQ7DQogDQpAQCAt
MTAwLDggKzEwMCw4IEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4X3NtaV9zaW5nbGVfY2hpcF9yZWFk
KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLXN0YXRp
YyBpbnQgbXY4OGU2eHh4X3NtaV9zaW5nbGVfY2hpcF93cml0ZShzdHJ1Y3QgbXY4OGU2eHh4X2No
aXAgKmNoaXAsDQotCQkJCQkgICBpbnQgYWRkciwgaW50IHJlZywgdTE2IHZhbCkNCitzdGF0aWMg
aW50IG12ODhlNnh4eF9zbWlfZGlyZWN0X3dyaXRlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hp
cCwNCisJCQkJICAgICAgaW50IGFkZHIsIGludCByZWcsIHUxNiB2YWwpDQogew0KIAlpbnQgcmV0
Ow0KIA0KQEAgLTExMiwxMiArMTEyLDEyIEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4X3NtaV9zaW5n
bGVfY2hpcF93cml0ZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCXJldHVybiAwOw0K
IH0NCiANCi1zdGF0aWMgY29uc3Qgc3RydWN0IG12ODhlNnh4eF9idXNfb3BzIG12ODhlNnh4eF9z
bWlfc2luZ2xlX2NoaXBfb3BzID0gew0KLQkucmVhZCA9IG12ODhlNnh4eF9zbWlfc2luZ2xlX2No
aXBfcmVhZCwNCi0JLndyaXRlID0gbXY4OGU2eHh4X3NtaV9zaW5nbGVfY2hpcF93cml0ZSwNCitz
dGF0aWMgY29uc3Qgc3RydWN0IG12ODhlNnh4eF9idXNfb3BzIG12ODhlNnh4eF9zbWlfZGlyZWN0
X29wcyA9IHsNCisJLnJlYWQgPSBtdjg4ZTZ4eHhfc21pX2RpcmVjdF9yZWFkLA0KKwkud3JpdGUg
PSBtdjg4ZTZ4eHhfc21pX2RpcmVjdF93cml0ZSwNCiB9Ow0KIA0KLXN0YXRpYyBpbnQgbXY4OGU2
eHh4X3NtaV9tdWx0aV9jaGlwX3dhaXQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKQ0KK3N0
YXRpYyBpbnQgbXY4OGU2eHh4X3NtaV9pbmRpcmVjdF93YWl0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hp
cCAqY2hpcCkNCiB7DQogCWludCByZXQ7DQogCWludCBpOw0KQEAgLTEzNCwxMyArMTM0LDEzIEBA
IHN0YXRpYyBpbnQgbXY4OGU2eHh4X3NtaV9tdWx0aV9jaGlwX3dhaXQoc3RydWN0IG12ODhlNnh4
eF9jaGlwICpjaGlwKQ0KIAlyZXR1cm4gLUVUSU1FRE9VVDsNCiB9DQogDQotc3RhdGljIGludCBt
djg4ZTZ4eHhfc21pX211bHRpX2NoaXBfcmVhZChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAs
DQotCQkJCQkgaW50IGFkZHIsIGludCByZWcsIHUxNiAqdmFsKQ0KK3N0YXRpYyBpbnQgbXY4OGU2
eHh4X3NtaV9pbmRpcmVjdF9yZWFkKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkJ
ICAgICAgIGludCBhZGRyLCBpbnQgcmVnLCB1MTYgKnZhbCkNCiB7DQogCWludCByZXQ7DQogDQog
CS8qIFdhaXQgZm9yIHRoZSBidXMgdG8gYmVjb21lIGZyZWUuICovDQotCXJldCA9IG12ODhlNnh4
eF9zbWlfbXVsdGlfY2hpcF93YWl0KGNoaXApOw0KKwlyZXQgPSBtdjg4ZTZ4eHhfc21pX2luZGly
ZWN0X3dhaXQoY2hpcCk7DQogCWlmIChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCkBAIC0x
NTEsNyArMTUxLDcgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfc21pX211bHRpX2NoaXBfcmVhZChz
dHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCQlyZXR1cm4gcmV0Ow0KIA0KIAkvKiBXYWl0
IGZvciB0aGUgcmVhZCBjb21tYW5kIHRvIGNvbXBsZXRlLiAqLw0KLQlyZXQgPSBtdjg4ZTZ4eHhf
c21pX211bHRpX2NoaXBfd2FpdChjaGlwKTsNCisJcmV0ID0gbXY4OGU2eHh4X3NtaV9pbmRpcmVj
dF93YWl0KGNoaXApOw0KIAlpZiAocmV0IDwgMCkNCiAJCXJldHVybiByZXQ7DQogDQpAQCAtMTY1
LDEzICsxNjUsMTMgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfc21pX211bHRpX2NoaXBfcmVhZChz
dHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCXJldHVybiAwOw0KIH0NCiANCi1zdGF0aWMg
aW50IG12ODhlNnh4eF9zbWlfbXVsdGlfY2hpcF93cml0ZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAg
KmNoaXAsDQotCQkJCQkgIGludCBhZGRyLCBpbnQgcmVnLCB1MTYgdmFsKQ0KK3N0YXRpYyBpbnQg
bXY4OGU2eHh4X3NtaV9pbmRpcmVjdF93cml0ZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAs
DQorCQkJCQlpbnQgYWRkciwgaW50IHJlZywgdTE2IHZhbCkNCiB7DQogCWludCByZXQ7DQogDQog
CS8qIFdhaXQgZm9yIHRoZSBidXMgdG8gYmVjb21lIGZyZWUuICovDQotCXJldCA9IG12ODhlNnh4
eF9zbWlfbXVsdGlfY2hpcF93YWl0KGNoaXApOw0KKwlyZXQgPSBtdjg4ZTZ4eHhfc21pX2luZGly
ZWN0X3dhaXQoY2hpcCk7DQogCWlmIChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCkBAIC0x
ODcsMTYgKzE4NywxNiBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9zbWlfbXVsdGlfY2hpcF93cml0
ZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCQlyZXR1cm4gcmV0Ow0KIA0KIAkvKiBX
YWl0IGZvciB0aGUgd3JpdGUgY29tbWFuZCB0byBjb21wbGV0ZS4gKi8NCi0JcmV0ID0gbXY4OGU2
eHh4X3NtaV9tdWx0aV9jaGlwX3dhaXQoY2hpcCk7DQorCXJldCA9IG12ODhlNnh4eF9zbWlfaW5k
aXJlY3Rfd2FpdChjaGlwKTsNCiAJaWYgKHJldCA8IDApDQogCQlyZXR1cm4gcmV0Ow0KIA0KIAly
ZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIGNvbnN0IHN0cnVjdCBtdjg4ZTZ4eHhfYnVzX29wcyBt
djg4ZTZ4eHhfc21pX211bHRpX2NoaXBfb3BzID0gew0KLQkucmVhZCA9IG12ODhlNnh4eF9zbWlf
bXVsdGlfY2hpcF9yZWFkLA0KLQkud3JpdGUgPSBtdjg4ZTZ4eHhfc21pX211bHRpX2NoaXBfd3Jp
dGUsDQorc3RhdGljIGNvbnN0IHN0cnVjdCBtdjg4ZTZ4eHhfYnVzX29wcyBtdjg4ZTZ4eHhfc21p
X2luZGlyZWN0X29wcyA9IHsNCisJLnJlYWQgPSBtdjg4ZTZ4eHhfc21pX2luZGlyZWN0X3JlYWQs
DQorCS53cml0ZSA9IG12ODhlNnh4eF9zbWlfaW5kaXJlY3Rfd3JpdGUsDQogfTsNCiANCiBpbnQg
bXY4OGU2eHh4X3JlYWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgYWRkciwgaW50
IHJlZywgdTE2ICp2YWwpDQpAQCAtNDU1Myw5ICs0NTUzLDkgQEAgc3RhdGljIGludCBtdjg4ZTZ4
eHhfc21pX2luaXQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAkJCSAgICAgIHN0cnVj
dCBtaWlfYnVzICpidXMsIGludCBzd19hZGRyKQ0KIHsNCiAJaWYgKHN3X2FkZHIgPT0gMCB8fCBj
aGlwLT5pbmZvLT5kdWFsX2NoaXApDQotCQljaGlwLT5zbWlfb3BzID0gJm12ODhlNnh4eF9zbWlf
c2luZ2xlX2NoaXBfb3BzOw0KKwkJY2hpcC0+c21pX29wcyA9ICZtdjg4ZTZ4eHhfc21pX2RpcmVj
dF9vcHM7DQogCWVsc2UgaWYgKGNoaXAtPmluZm8tPm11bHRpX2NoaXApDQotCQljaGlwLT5zbWlf
b3BzID0gJm12ODhlNnh4eF9zbWlfbXVsdGlfY2hpcF9vcHM7DQorCQljaGlwLT5zbWlfb3BzID0g
Jm12ODhlNnh4eF9zbWlfaW5kaXJlY3Rfb3BzOw0KIAllbHNlDQogCQlyZXR1cm4gLUVJTlZBTDsN
CiANCi0tIA0KMi4yMC4xDQoNCg==
