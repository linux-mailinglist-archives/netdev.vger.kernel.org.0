Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9301733275
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfFCOmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:19 -0400
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:11233
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727650AbfFCOmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGK5V79uVY6ivmZu7SZ5vD3+lpGxkb2rGvR55HCjek4=;
 b=N73+jNRhP/TQbW8d8Ptjpx1Jc73wWmtN5HsAJlGGSAHFUFr/9js1PikABUdokjc2iKRMXGKOm6nmxbBLt3Au6PE9Nyq98ogDZkviFJwEDZ+Uhh48TmNh5HDVXPgElOfopbiRbzOoLW1W18RcUc/qFHq/Q9N5D6OuSbxHc+8T87M=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:11 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:11 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [PATCH net-next v3 00/10] net: dsa: mv88e6xxx: support for mv88e6250
Thread-Topic: [PATCH net-next v3 00/10] net: dsa: mv88e6xxx: support for
 mv88e6250
Thread-Index: AQHVGhqGjje/xsefAEaPf0JYGqjm9g==
Date:   Mon, 3 Jun 2019 14:42:11 +0000
Message-ID: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: 7e4d5941-37d7-4963-5b80-08d6e831a924
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB25740D9E4DB6AC1AFC7012408A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(256004)(14444005)(8976002)(53936002)(72206003)(66946007)(316002)(2201001)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(107886003)(2501003)(102836004)(2616005)(4326008)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 94L/TACrio555Zl6Uw1ooOtBpWHaeWVkVjKj7mqymHDEDxD1yvA5YVdqGzvo4o7q3+59h129zzKC9PMF4ClZhwYeLY2ltrheUWUZJq0LuEG7lkVtVVMCcccRLiOpZrFY6P95sBSO/T9mQqh9SVMAL3g7oIg6DTZ9yMgEC82ko7fcmscsp/4LN7/RaFz8I/rvApdf80XJXPLWOul8aa3RN5hYWBDljDxtFgxD2ySggdjatah2eoqaVxdXOp674KIRYLQb2g3ixanZw6rZ/x0+1ueRCemTqXHcrBebhFaVJtjBXNpnnOAY1BM42S8+N5V4WLgv684mXuu57CLzNRiOlIbkh6Cm7DAeO1JVsQFXtXyXwoUbkWJpghII2m1Y/M4gJtgVqtN1NuInVVjvi5J1NAeAK6rQZSDDNqLzDikWh1Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4d5941-37d7-4963-5b80-08d6e831a924
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:11.1165
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

VGhpcyBhZGRzIHN1cHBvcnQgZm9yIHRoZSBtdjg4ZTYyNTAgY2hpcC4gSW5pdGlhbGx5IGJhc2Vk
IG9uIHRoZQ0KbXY4OGU2MjQwLCB0aGlzIHRpbWUgYXJvdW5kLCBJJ3ZlIGJlZW4gdGhyb3VnaCBl
YWNoIC0+b3BzIGNhbGxiYWNrIGFuZA0KY2hlY2tlZCB0aGF0IGl0IG1ha2VzIHNlbnNlLCBlaXRo
ZXIgcmVwbGFjaW5nIHdpdGggYSA2MjUwIHNwZWNpZmljDQp2YXJpYW50IG9yIGRyb3BwaW5nIGl0
IGlmIG5vIGVxdWl2YWxlbnQgZnVuY3Rpb25hbGl0eSBzZWVtcyB0byBleGlzdA0KZm9yIHRoZSA2
MjUwLiBBbG9uZyB0aGUgd2F5LCBJIGZvdW5kIGEgZmV3IG9kZGl0aWVzIGluIHRoZSBleGlzdGlu
Zw0KY29kZSwgbW9zdGx5IHNlbnQgYXMgc2VwYXJhdGUgcGF0Y2hlcy9xdWVzdGlvbnMuDQoNClRo
ZSBvbmUgcmVsZXZhbnQgdG8gdGhlIDYyNTAgaXMgdGhlIGllZWVfcHJpX21hcCBjYWxsYmFjaywg
d2hlcmUgdGhlDQpleGlzdGluZyBtdjg4ZTYwODVfZzFfaWVlZV9wcmlfbWFwKCkgaXMgYWN0dWFs
bHkgd3JvbmcgZm9yIG1hbnkgb2YgdGhlDQpleGlzdGluZyB1c2Vycy4gSSd2ZSBwdXQgdGhlIG12
ODhlNjI1MF9nMV9pZWVlX3ByaV9tYXAoKSBwYXRjaCBmaXJzdA0KaW4gY2FzZSBzb21lIG9mIHRo
ZSBleGlzdGluZyBjaGlwcyBnZXQgc3dpdGNoZWQgb3ZlciB0byB1c2UgdGhhdCBhbmQNCml0IGlz
IGRlZW1lZCBpbXBvcnRhbnQgZW5vdWdoIGZvciAtc3RhYmxlLg0KDQp2MzoNCi0gcmViYXNlIG9u
IHRvcCBvZiBuZXQtbmV4dC9tYXN0ZXINCi0gYWRkIHJldmlld2VkLWJ5cyB0byBwYXRjaGVzIHVu
Y2hhbmdlZCBmcm9tIHYyICgyLDMsNCw1KQ0KLSBhZGQgNjI1MC1zcGVjaWZpYyAtPmllZWVfcHJp
X21hcCwgLT5wb3J0X3NldF9zcGVlZCwgLT5wb3J0X2xpbmtfc3RhdGUgKDEsNiw3KQ0KLSBpbiBh
ZGRpdGlvbiwgdXNlIG12ODhlNjA2NV9waHlsaW5rX3ZhbGlkYXRlIGZvciAtPnBoeWxpbmtfdmFs
aWRhdGUsDQogIGFuZCBkb24ndCBpbXBsZW1lbnQgLT5wb3J0X2dldF9jbW9kZSwgLT5wb3J0X3Nl
dF9qdW1ib19zaXplLA0KICAtPnBvcnRfZGlzYWJsZV9sZWFybl9saW1pdCwgLT5ybXVfZGlzYWJs
ZQ0KLSBkcm9wIHB0cCBzdXBwb3J0DQotIGFkZCBwYXRjaCBhZGRpbmcgdGhlIGNvbXBhdGlibGUg
c3RyaW5nIHRvIHRoZSBEVCBiaW5kaW5nICg5KQ0KLSBhZGQgc21hbGwgcmVmYWN0b3JpbmcgcGF0
Y2ggKDEwKQ0KDQp2MjoNCi0gcmViYXNlIG9uIHRvcCBvZiBuZXQtbmV4dC9tYXN0ZXINCi0gYWRk
IHJldmlld2VkLWJ5IHRvIHR3byBwYXRjaGVzIHVuY2hhbmdlZCBmcm9tIHYxICgyLDMpDQotIGFk
ZCBzZXBhcmF0ZSB3YXRjaGRvZ19vcHMNCg0KUmFzbXVzIFZpbGxlbW9lcyAoMTApOg0KICBuZXQ6
IGRzYTogbXY4OGU2eHh4OiBhZGQgbXY4OGU2MjUwX2cxX2llZWVfcHJpX21hcA0KICBuZXQ6IGRz
YTogbXY4OGU2eHh4OiBpbnRyb2R1Y2Ugc3VwcG9ydCBmb3IgdHdvIGNoaXBzIHVzaW5nIGRpcmVj
dCBzbWkNCiAgICBhZGRyZXNzaW5nDQogIG5ldDogZHNhOiBtdjg4ZTZ4eHg6IHByZXBhcmUgbXY4
OGU2eHh4X2cxX2F0dV9vcCgpIGZvciB0aGUgbXY4OGU2MjUwDQogIG5ldDogZHNhOiBtdjg4ZTZ4
eHg6IGltcGxlbWVudCB2dHVfZ2V0bmV4dCBhbmQgdnR1X2xvYWRwdXJnZSBmb3INCiAgICBtdjg4
ZTYyNTANCiAgbmV0OiBkc2E6IG12ODhlNnh4eDogaW1wbGVtZW50IHdhdGNoZG9nX29wcyBmb3Ig
bXY4OGU2MjUwDQogIG5ldDogZHNhOiBtdjg4ZTZ4eHg6IGltcGxlbWVudCBwb3J0X3NldF9zcGVl
ZCBmb3IgbXY4OGU2MjUwDQogIG5ldDogZHNhOiBtdjg4ZTZ4eHg6IGltcGxlbWVudCBwb3J0X2xp
bmtfc3RhdGUgZm9yIG12ODhlNjI1MA0KICBuZXQ6IGRzYTogbXY4OGU2eHh4OiBhZGQgc3VwcG9y
dCBmb3IgbXY4OGU2MjUwDQogIGR0LWJpbmRpbmdzOiBuZXQ6IGRzYTogbWFydmVsbDogYWRkICJt
YXJ2ZWxsLG12ODhlNjI1MCIgY29tcGF0aWJsZQ0KICAgIHN0cmluZw0KICBuZXQ6IGRzYTogbXY4
OGU2eHh4OiByZWZhY3RvciBtdjg4ZTYzNTJfZzFfcmVzZXQNCg0KIC4uLi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL25ldC9kc2EvbWFydmVsbC50eHQgICB8ICA3ICstDQogZHJpdmVycy9uZXQvZHNhL212
ODhlNnh4eC9jaGlwLmMgICAgICAgICAgICAgIHwgODEgKysrKysrKysrKysrKysrKysrKw0KIGRy
aXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5oICAgICAgICAgICAgICB8ICA4ICsrDQogZHJp
dmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMgICAgICAgICAgIHwgMTcgKysrLQ0KIGRy
aXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oICAgICAgICAgICB8ICA3ICsrDQogZHJp
dmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX2F0dS5jICAgICAgIHwgIDUgKy0NCiBkcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMgICAgICAgfCA1OCArKysrKysrKysr
KysrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmMgICAgICAgICAgIHwgMjYg
KysrKysrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmggICAgICAgICAgIHwg
MTQgKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5jICAgICAgICAgICAgICB8
IDc3ICsrKysrKysrKysrKysrKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5o
ICAgICAgICAgICAgICB8IDE0ICsrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3NtaS5j
ICAgICAgICAgICAgICAgfCAyNSArKysrKy0NCiAxMiBmaWxlcyBjaGFuZ2VkLCAzMzMgaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjIwLjENCg0K
