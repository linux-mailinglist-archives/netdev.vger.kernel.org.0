Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF2E033
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfD2KFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:25 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727946AbfD2KFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTEC+Ekwl2lShbkEmGYv39q8+iIz603+r/P/Ey9DV8E=;
 b=DQ2Tt8sOzBI3JWvEMZICrF4z2fUsS4brPUbOl/sFOiQJRiUH23DO4c2rnXxlXIW68qq9zxyWAFP8DfYS29lZDUBX9b9zDp5ks1nopMF4w3Er60ChZICZnl1LEHN/65unj5OowG4O41tokObsndHyXLU39qPng8Oocl/MwbzJNIs=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:53 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:53 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 08/15] net: aquantia: use macros for better
 visibility
Thread-Topic: [PATCH v4 net-next 08/15] net: aquantia: use macros for better
 visibility
Thread-Index: AQHU/nL9LHyAAmhhAkGb+LUo1/O1mA==
Date:   Mon, 29 Apr 2019 10:04:52 +0000
Message-ID: <6ee59f31c13b6cdc9b1a3b8fc1b258ad3b8e7848.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b565a1ba-ee43-434e-5d75-08d6cc8a1f84
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB3644FE5E3BD53647A1BCED0398390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:164;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(256004)(11346002)(52116002)(446003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8RuEIJCJ4MQToj7X9DLohmNmdV92AkD/38YPSO5QLK1fdbMZrsBFxgdMDSy88HMdYZFXVOqQxvPpvLhBjkSo+CnBvxBbnVtdeBjHKvynlEBfosFBeOR6gu3S/lwXre/Anb7+dx5thqizFg/aNS3eBbyEkAtsllsWQZSx7eGhKy2zg8ZUefZrwPRXppt/+uE6cE7jhQaAXLSj8xPzUqAT3eNcWZgEFLlGLZu4hd6s88TUFhLq9ZxDvShonRpp0W2HKFayDCxoJ6EMQHatpepCqbDZwQwVgz+RRulwtQE/uN7z2vpcq6PjUt7ftVnb3KJqnzaecdju4WzCfPQB9O62qU8cZbmQS/NY1XZmhP0/0SGpRiwCekwiumtSEX0xLahKBvUXBmxNDrWblexjBkSb2gG7JXoNGt9H49W1DA4nKJ4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b565a1ba-ee43-434e-5d75-08d6cc8a1f84
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:52.8537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW1wcm92ZSBmb3IgYmV0dGVyIHJlYWRhYmlsaXR5DQoNClNpZ25lZC1vZmYtYnk6IE5pa2l0YSBE
YW5pbG92IDxuZGFuaWxvdkBhcXVhbnRpYS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3Nr
aWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYTAuYyB8IDggKysrKy0tLS0NCiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMg
fCA4ICsrKystLS0tDQogMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxh
bnRpYy9od19hdGwvaHdfYXRsX2EwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9od19hdGwvaHdfYXRsX2EwLmMNCmluZGV4IDY1ZmZhYTdhZDY5ZS4uOWZlNTA3ZmUy
ZDdmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMv
aHdfYXRsL2h3X2F0bF9hMC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9od19hdGwvaHdfYXRsX2EwLmMNCkBAIC0zNTAsMTAgKzM1MCwxMCBAQCBzdGF0aWMg
aW50IGh3X2F0bF9hMF9od19tYWNfYWRkcl9zZXQoc3RydWN0IGFxX2h3X3MgKnNlbGYsIHU4ICpt
YWNfYWRkcikNCiBzdGF0aWMgaW50IGh3X2F0bF9hMF9od19pbml0KHN0cnVjdCBhcV9od19zICpz
ZWxmLCB1OCAqbWFjX2FkZHIpDQogew0KIAlzdGF0aWMgdTMyIGFxX2h3X2F0bF9pZ2NyX3RhYmxl
X1s0XVsyXSA9IHsNCi0JCXsgMHgyMDAwMDAwMFUsIDB4MjAwMDAwMDBVIH0sIC8qIEFRX0lSUV9J
TlZBTElEICovDQotCQl7IDB4MjAwMDAwODBVLCAweDIwMDAwMDgwVSB9LCAvKiBBUV9JUlFfTEVH
QUNZICovDQotCQl7IDB4MjAwMDAwMjFVLCAweDIwMDAwMDI1VSB9LCAvKiBBUV9JUlFfTVNJICov
DQotCQl7IDB4MjAwMDAwMjJVLCAweDIwMDAwMDI2VSB9ICAvKiBBUV9JUlFfTVNJWCAqLw0KKwkJ
W0FRX0hXX0lSUV9JTlZBTElEXSA9IHsgMHgyMDAwMDAwMFUsIDB4MjAwMDAwMDBVIH0sDQorCQlb
QVFfSFdfSVJRX0xFR0FDWV0gID0geyAweDIwMDAwMDgwVSwgMHgyMDAwMDA4MFUgfSwNCisJCVtB
UV9IV19JUlFfTVNJXSAgICAgPSB7IDB4MjAwMDAwMjFVLCAweDIwMDAwMDI1VSB9LA0KKwkJW0FR
X0hXX0lSUV9NU0lYXSAgICA9IHsgMHgyMDAwMDAyMlUsIDB4MjAwMDAwMjZVIH0sDQogCX07DQog
DQogCWludCBlcnIgPSAwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFu
dGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjAuYw0KaW5kZXggZDU0NTY2YmFiMGU5Li5i
ZmNkYTEyZDczZGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjAuYw0KQEAgLTM4OCwxMCArMzg4LDEwIEBA
IHN0YXRpYyBpbnQgaHdfYXRsX2IwX2h3X21hY19hZGRyX3NldChzdHJ1Y3QgYXFfaHdfcyAqc2Vs
ZiwgdTggKm1hY19hZGRyKQ0KIHN0YXRpYyBpbnQgaHdfYXRsX2IwX2h3X2luaXQoc3RydWN0IGFx
X2h3X3MgKnNlbGYsIHU4ICptYWNfYWRkcikNCiB7DQogCXN0YXRpYyB1MzIgYXFfaHdfYXRsX2ln
Y3JfdGFibGVfWzRdWzJdID0gew0KLQkJeyAweDIwMDAwMDAwVSwgMHgyMDAwMDAwMFUgfSwgLyog
QVFfSVJRX0lOVkFMSUQgKi8NCi0JCXsgMHgyMDAwMDA4MFUsIDB4MjAwMDAwODBVIH0sIC8qIEFR
X0lSUV9MRUdBQ1kgKi8NCi0JCXsgMHgyMDAwMDAyMVUsIDB4MjAwMDAwMjVVIH0sIC8qIEFRX0lS
UV9NU0kgKi8NCi0JCXsgMHgyMDAwMDAyMlUsIDB4MjAwMDAwMjZVIH0gIC8qIEFRX0lSUV9NU0lY
ICovDQorCQlbQVFfSFdfSVJRX0lOVkFMSURdID0geyAweDIwMDAwMDAwVSwgMHgyMDAwMDAwMFUg
fSwNCisJCVtBUV9IV19JUlFfTEVHQUNZXSAgPSB7IDB4MjAwMDAwODBVLCAweDIwMDAwMDgwVSB9
LA0KKwkJW0FRX0hXX0lSUV9NU0ldICAgICA9IHsgMHgyMDAwMDAyMVUsIDB4MjAwMDAwMjVVIH0s
DQorCQlbQVFfSFdfSVJRX01TSVhdICAgID0geyAweDIwMDAwMDIyVSwgMHgyMDAwMDAyNlUgfSwN
CiAJfTsNCiANCiAJaW50IGVyciA9IDA7DQotLSANCjIuMTcuMQ0KDQo=
