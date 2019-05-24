Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A452940F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389965AbfEXJA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:00:29 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:58510
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389873AbfEXJA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sextj0JqhRpMLVjEXE170W84A6lTgmLjg20T9hTWANA=;
 b=cKWLDVjT5rBGiKXxc6gtcmyIp20aR9l0FjTZa8bg5WYUAEXpFq/Sds2L3IXbOKUcWFa+vwWQqslSShwj9epa8Gaoe69fLEIVeqZNiTyFJUjSOv4gTo9vSZRopYX9+WRatKAQYaEskMzdkc+fid8CRuF7CJkbFcCCvel8LhXxH+A=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM (10.166.146.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 24 May 2019 09:00:23 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5%3]) with mapi id 15.20.1922.016; Fri, 24 May 2019
 09:00:23 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [PATCH v2 0/5] net: dsa: support for mv88e6250
Thread-Topic: [PATCH v2 0/5] net: dsa: support for mv88e6250
Thread-Index: AQHVEg8f/PG5rUj9A0aqgKVD+F9Ebw==
Date:   Fri, 24 May 2019 09:00:23 +0000
Message-ID: <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0802CA0015.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::25) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a1469de-5d47-4d75-9172-08d6e0264132
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB1535;
x-ms-traffictypediagnostic: VI1PR10MB1535:
x-microsoft-antispam-prvs: <VI1PR10MB15351CA405056636D156AC368A020@VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(42882007)(66946007)(73956011)(81166006)(102836004)(66066001)(6116002)(76176011)(1076003)(25786009)(52116002)(478600001)(386003)(6512007)(6506007)(2501003)(2201001)(107886003)(186003)(3846002)(74482002)(72206003)(4326008)(66556008)(64756008)(66446008)(66476007)(316002)(26005)(36756003)(68736007)(50226002)(305945005)(5660300002)(7736002)(6436002)(44832011)(256004)(486006)(53936002)(8676002)(81156014)(8976002)(110136005)(476003)(6486002)(8936002)(446003)(2906002)(11346002)(2616005)(99286004)(71190400001)(71200400001)(14454004)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1535;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HJN3DRYqOLbXW93wyAsdtWjAFsk9TGdkmHlYYALDJWXEHe8gv6R/Sls/qCQMzWXCUbtXIicio0VWT+lfyvDJx84ZuUngIzyBW/i/NnPDgfuQc5MW2if9zdpK1FqlpNWPOHA0rxAy+6o8sMpTVIv+beykFYVbHgpbufLo/LPnTu8/6Rsq/x2uUqlVs3gmTFt0CtZucZ55u/GocKA3vx+IJCF184idj3MTbUD8qVBx0qem7gzhuVQXYKMF6iAW77AyUZ/05sMU+aFoK3QdJtdYtw59vN0cF5o3suW8g8t/zUX9S7z5jWVnvYRyglLRp+bdmNvNjfqrMtwvZQp447Te8/MJCsphSxww4MbmSudWREuwQ2r83ZMqt6kBPPLp7FPRmQgTM9ZKIQtnqyQtEgNKBRbFQSU8AYl54yJD/PBX+zc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1469de-5d47-4d75-9172-08d6e0264132
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:00:23.3552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1535
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBzb21lIG1vc3RseS13b3JraW5nIGNvZGUgYWRkaW5nIHN1cHBvcnQgZm9yIHRoZSBt
djg4ZTYyNTANCmNoaXAuIEknbSBub3QgcXVpdGUgZG9uZSBjaGVja2luZyB3aGV0aGVyIGFsbCB0
aGUgbWV0aG9kcyBpbiB0aGUgX29wcw0Kc3RydWN0dXJlIGFyZSBhcHByb3ByaWF0ZSwgYnV0IGJh
c2ljIHN3aXRjaGRldiBmdW5jdGlvbmFsaXR5IHNlZW1zIHRvDQp3b3JrLg0KDQp2MjoNCi0gcmVi
YXNlIG9uIHRvcCBvZiBuZXQtbmV4dC9tYXN0ZXINCi0gYWRkIHJldmlld2VkLWJ5IHRvIHR3byBw
YXRjaGVzIHVuY2hhbmdlZCBmcm9tIHYxICgyLDMpDQotIGFkZCBzZXBhcmF0ZSB3YXRjaGRvZ19v
cHMNCg0KUmFzbXVzIFZpbGxlbW9lcyAoNSk6DQogIG5ldDogZHNhOiBtdjg4ZTZ4eHg6IGludHJv
ZHVjZSBzdXBwb3J0IGZvciB0d28gY2hpcHMgdXNpbmcgZGlyZWN0IHNtaQ0KICAgIGFkZHJlc3Np
bmcNCiAgbmV0OiBkc2E6IHByZXBhcmUgbXY4OGU2eHh4X2cxX2F0dV9vcCgpIGZvciB0aGUgbXY4
OGU2MjUwDQogIG5ldDogZHNhOiBpbXBsZW1lbnQgdnR1X2dldG5leHQgYW5kIHZ0dV9sb2FkcHVy
Z2UgZm9yIG12ODhlNjI1MA0KICBuZXQ6IGRzYTogbXY4OGU2eHh4OiBpbXBsZW1lbnQgd2F0Y2hk
b2dfb3BzIGZvciBtdjg4ZTYyNTANCiAgbmV0OiBkc2E6IGFkZCBzdXBwb3J0IGZvciBtdjg4ZTYy
NTANCg0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jICAgICAgICB8IDczICsrKysr
KysrKysrKysrKysrKysrKysrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuaCAg
ICAgICAgfCAgOCArKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuYyAgICAg
fCAxOSArKysrKysrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmggICAgIHwg
IDUgKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfYXR1LmMgfCAgNSArLQ0K
IGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYyB8IDU4ICsrKysrKysrKysr
KysrKysrKysrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmMgICAgIHwgMjYg
KysrKysrKysrDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwyLmggICAgIHwgMTQg
KysrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3BvcnQuaCAgICAgICAgfCAgMSArDQog
ZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9zbWkuYyAgICAgICAgIHwgMjUgKysrKysrKystDQog
MTAgZmlsZXMgY2hhbmdlZCwgMjMyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCi0t
IA0KMi4yMC4xDQoNCg==
