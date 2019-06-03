Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384D233268
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfFCOmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:50 -0400
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:22244
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729193AbfFCOme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubYX5cnr/HfS+iuU3hOrYFyxPIk7BAwqUCfhM2LQveQ=;
 b=cr9F9v/hSD0+GUq/g1hsIs9eNs1iSbd+VP7gemmBuUIjOVE2tbE7JIkHZsS0t1mHm0YB2je639i2RJjx+MkzCiN2VPCP5UpBKJW1ar3tF2eDJPCjJ8FXX/YXzjGzVOQ9qCaIeoB7SYiJZW/9o3qqUFJjosnww5oRqpYY8TVymcc=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:23 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:23 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 09/10] dt-bindings: net: dsa: marvell: add
 "marvell,mv88e6250" compatible string
Thread-Topic: [PATCH net-next v3 09/10] dt-bindings: net: dsa: marvell: add
 "marvell,mv88e6250" compatible string
Thread-Index: AQHVGhqOZLX23H/SBUuAQcQCj0sPKw==
Date:   Mon, 3 Jun 2019 14:42:23 +0000
Message-ID: <20190603144112.27713-10-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: a987d43f-5f3a-4d41-735f-08d6e831b084
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB25747295F0759D18D90929138A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GSp1bWXYOe2R6dkwYILz0BtvsLTDBvnpUDjM64j3nz97eQ2P8AkJ4yh1RLsye/y+gcufz+wM0NonEc5v+qRNxHO22q7xkeJY1BVRaq1g1AMmdnddf3DJPPNpOI4m2GbDPhdOZyqvcjOpySb7XnRC7NXTGyhJb3EKwGiCkaj6Val/BU+JGG63uo1ot70nvnY5+BOv9ZhFPR0BF8fNk2HJqmW8BO8BH8ktOQI2AiLpXJJumwDbk2wM1hfWj6ElyOa6A+X4vy24neTD/Qb8Lb4OBQSd5DJ0CY6NT0oV8vbzOlj57SwA6uQ3OW1/FGXL6u+KUpi1RSzZl2RRwXzgvokmTDVL/xZ6RS0eBW1dtL+lPy6lI2NBbl52HVMENigbsqlzntNbSwc6t7EckOARK/haTVBpaHHS4xYIdeqYH1nBjqY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: a987d43f-5f3a-4d41-735f-08d6e831b084
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:23.5243
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

VGhlIG12ODhlNjI1MCBoYXMgcG9ydF9iYXNlX2FkZHIgMHg4IG9yIDB4MTggKGRlcGVuZGluZyBv
bg0KY29uZmlndXJhdGlvbiBwaW5zKSwgc28gaXQgY29uc3RpdHV0ZXMgYSBuZXcgZmFtaWx5IGFu
ZCBoZW5jZSBuZWVkcw0KaXRzIG93biBjb21wYXRpYmxlIHN0cmluZy4NCg0KU2lnbmVkLW9mZi1i
eTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+DQotLS0NCiBE
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tYXJ2ZWxsLnR4dCB8IDcg
KysrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Rz
YS9tYXJ2ZWxsLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNh
L21hcnZlbGwudHh0DQppbmRleCBmZWIwMDdhZjEzY2IuLjZmOTUzODk3NGJiOSAxMDA2NDQNCi0t
LSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL21hcnZlbGwudHh0
DQorKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tYXJ2ZWxs
LnR4dA0KQEAgLTIxLDEwICsyMSwxMyBAQCB3aGljaCBpcyBhdCBhIGRpZmZlcmVudCBNRElPIGJh
c2UgYWRkcmVzcyBpbiBkaWZmZXJlbnQgc3dpdGNoIGZhbWlsaWVzLg0KIAkJCSAgNjM0MSwgNjM1
MCwgNjM1MSwgNjM1Mg0KIC0gIm1hcnZlbGwsbXY4OGU2MTkwIgk6IFN3aXRjaCBoYXMgYmFzZSBh
ZGRyZXNzIDB4MDAuIFVzZSB3aXRoIG1vZGVsczoNCiAJCQkgIDYxOTAsIDYxOTBYLCA2MTkxLCA2
MjkwLCA2MzkwLCA2MzkwWA0KKy0gIm1hcnZlbGwsbXY4OGU2MjUwIgk6IFN3aXRjaCBoYXMgYmFz
ZSBhZGRyZXNzIDB4MDggb3IgMHgxOC4gVXNlIHdpdGggbW9kZWw6DQorCQkJICA2MjUwDQogDQog
UmVxdWlyZWQgcHJvcGVydGllczoNCi0tIGNvbXBhdGlibGUJCTogU2hvdWxkIGJlIG9uZSBvZiAi
bWFydmVsbCxtdjg4ZTYwODUiIG9yDQotCQkJICAibWFydmVsbCxtdjg4ZTYxOTAiIGFzIGluZGlj
YXRlZCBhYm92ZQ0KKy0gY29tcGF0aWJsZQkJOiBTaG91bGQgYmUgb25lIG9mICJtYXJ2ZWxsLG12
ODhlNjA4NSIsDQorCQkJICAibWFydmVsbCxtdjg4ZTYxOTAiIG9yICJtYXJ2ZWxsLG12ODhlNjI1
MCIgYXMNCisJCQkgIGluZGljYXRlZCBhYm92ZQ0KIC0gcmVnCQkJOiBBZGRyZXNzIG9uIHRoZSBN
SUkgYnVzIGZvciB0aGUgc3dpdGNoLg0KIA0KIE9wdGlvbmFsIHByb3BlcnRpZXM6DQotLSANCjIu
MjAuMQ0KDQo=
