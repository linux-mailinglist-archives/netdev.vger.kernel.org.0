Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCC134056
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfFDHe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:34:28 -0400
Received: from mail-eopbgr50125.outbound.protection.outlook.com ([40.107.5.125]:15586
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726653AbfFDHe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40QBH9RPW780DgExqPH7fIrNDQ3mJ+zxPIg/Aj+j69M=;
 b=aBDYU6Ws2sIRfbgM9b6rHywFZx5OnzYjxz/DcWBDD/cb8aoT6xTq8GZ8/unqZR3FvEfdJOBwR/HtR7k4FP0RIaSOgZMqsaAVzkPrqbWTJO6Pfr0FcYTka+3fmSo61aVdgdzo6rpjGeBXDDpXjHr4vfLqoGd1Beod0CRh+Sll8hk=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3435.EURPRD10.PROD.OUTLOOK.COM (10.255.17.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:23 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:23 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Thread-Topic: [PATCH net-next v4 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Thread-Index: AQHVGqfu1+HjwwLH8k+TsJvlBfVwrw==
Date:   Tue, 4 Jun 2019 07:34:23 +0000
Message-ID: <20190604073412.21743-2-rasmus.villemoes@prevas.dk>
References: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0030.eurprd03.prod.outlook.com (2603:10a6:20b::43)
 To DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82894fee-4644-46ee-e022-08d6e8bf108c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR10MB3435;
x-ms-traffictypediagnostic: DB8PR10MB3435:
x-microsoft-antispam-prvs: <DB8PR10MB34350ABB32696EF815AE95ED8A150@DB8PR10MB3435.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39850400004)(396003)(189003)(199004)(5660300002)(66446008)(73956011)(76176011)(66476007)(66556008)(66946007)(64756008)(99286004)(66066001)(386003)(6506007)(54906003)(8976002)(52116002)(110136005)(316002)(7736002)(305945005)(81166006)(81156014)(8676002)(8936002)(476003)(74482002)(486006)(446003)(11346002)(2616005)(256004)(44832011)(14444005)(186003)(42882007)(71190400001)(1076003)(102836004)(71200400001)(50226002)(6436002)(26005)(36756003)(478600001)(25786009)(6486002)(68736007)(6116002)(3846002)(53936002)(2906002)(6512007)(72206003)(14454004)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3435;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1JakXbGHZO68LbU5CTyDYbrP7n3tCHluvqVa29c95JD+cY5YpNtVMj3HL4GjZDjCgdYOf9B7yv8hqJDw7e1BhLgA/Q2d0oqJL7gtfmRCp3vq8vCYtalG86F4KL9h8SK0AEke1/qXp06QxRBkpVTFNaWmYpTjVp1rNEBiS8xzFKffg37vDMhna6NhspPGuTjven9a91MPY9EhW0ylvqQ8bYQSLtPhQwHqnjiwOv/ysgLjFNHXV1jMN41bguiGOk6z9oPwb9yCVImtwEFa1nVB1/bpQI2ydUUKoHfGOqMjHtsphHjvJRmZfa1Gs5xsOaLLpWpwdwTvopOEHSqqzlhJsSbExtwuQHX6b96JqW+d1MhzLNpz9L7+s8Dj01W6Ty8A/WCUHPzUAvNPtA2wQ9GFd6yD2Kl2TV+pFZqBCxP/uXc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 82894fee-4644-46ee-e022-08d6e8bf108c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:23.6627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3435
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
b3J0YW50IGVub3VnaCB0bw0KY2FyZS4NCg0KUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxs
ZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwx
LmMgfCA2ICsrKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oIHwgMiAr
Kw0KIDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvZ2xvYmFsMS5jDQppbmRleCA3NzBjMDM0MDYwMzMuLmM4NTFiN2I1MzJhNCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5jDQorKysgYi9kcml2ZXJzL25l
dC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuYw0KQEAgLTI5OSw2ICsyOTksMTIgQEAgaW50IG12ODhl
NjA4NV9nMV9pZWVlX3ByaV9tYXAoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKQ0KIAlyZXR1
cm4gbXY4OGU2eHh4X2cxX3dyaXRlKGNoaXAsIE1WODhFNlhYWF9HMV9JRUVFX1BSSSwgMHhmYTQx
KTsNCiB9DQogDQoraW50IG12ODhlNjI1MF9nMV9pZWVlX3ByaV9tYXAoc3RydWN0IG12ODhlNnh4
eF9jaGlwICpjaGlwKQ0KK3sNCisJLyogUmVzZXQgdGhlIElFRUUgVGFnIHByaW9yaXRpZXMgdG8g
ZGVmYXVsdHMgKi8NCisJcmV0dXJuIG12ODhlNnh4eF9nMV93cml0ZShjaGlwLCBNVjg4RTZYWFhf
RzFfSUVFRV9QUkksIDB4ZmE1MCk7DQorfQ0KKw0KIC8qIE9mZnNldCAweDFhOiBNb25pdG9yIENv
bnRyb2wgKi8NCiAvKiBPZmZzZXQgMHgxYTogTW9uaXRvciAmIE1HTVQgQ29udHJvbCBvbiBzb21l
IGRldmljZXMgKi8NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2ds
b2JhbDEuaCBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oDQppbmRleCBiYjky
YTEzMGNiZWYuLjZkMWQxMjYyZmU0MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4
ZTZ4eHgvZ2xvYmFsMS5oDQorKysgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEu
aA0KQEAgLTI3Nyw3ICsyNzcsOSBAQCBpbnQgbXY4OGU2MzkwX2cxX3NldF9jcHVfcG9ydChzdHJ1
Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsIGludCBwb3J0KTsNCiBpbnQgbXY4OGU2MzkwX2cxX21n
bXRfcnN2ZDJjcHUoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKTsNCiANCiBpbnQgbXY4OGU2
MDg1X2cxX2lwX3ByaV9tYXAoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKTsNCisNCiBpbnQg
bXY4OGU2MDg1X2cxX2llZWVfcHJpX21hcChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApOw0K
K2ludCBtdjg4ZTYyNTBfZzFfaWVlZV9wcmlfbWFwKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hp
cCk7DQogDQogaW50IG12ODhlNjE4NV9nMV9zZXRfY2FzY2FkZV9wb3J0KHN0cnVjdCBtdjg4ZTZ4
eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQpOw0KIA0KLS0gDQoyLjIwLjENCg0K
