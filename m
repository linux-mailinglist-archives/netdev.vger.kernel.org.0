Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEE34040
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfFDHeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:34:50 -0400
Received: from mail-eopbgr00119.outbound.protection.outlook.com ([40.107.0.119]:36579
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727024AbfFDHeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4Z+l4KQnX0qg1vzHr92Hjv5p5J4qMMbeY6q6PXnmkQ=;
 b=PaWMj0lcF8dXqj2Z7igWls9Kfm63j68RVbeY0b3u1vd0/iLHjtYMwIZyC301wOKQQNo0dL6GFS69JziHrqYd2ybEp8OsVma5xFHQL8IIgpvVY0YbD/01/6GwnBtbM0PTSNhXkQPvdKDZqL+N21nbPlEg/5/1fT9zApV6UEo5y0o=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM (10.255.19.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:33 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:33 +0000
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
Subject: [PATCH net-next v4 09/10] dt-bindings: net: dsa: marvell: add
 "marvell,mv88e6250" compatible string
Thread-Topic: [PATCH net-next v4 09/10] dt-bindings: net: dsa: marvell: add
 "marvell,mv88e6250" compatible string
Thread-Index: AQHVGqf0tKxXmikMCEO7YIBp2HuHyg==
Date:   Tue, 4 Jun 2019 07:34:33 +0000
Message-ID: <20190604073412.21743-10-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: 4ae34b55-85eb-45c2-05b2-08d6e8bf1694
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3068;
x-ms-traffictypediagnostic: DB8PR10MB3068:
x-microsoft-antispam-prvs: <DB8PR10MB30688130253608E87AD7342F8A150@DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(136003)(376002)(396003)(346002)(189003)(199004)(4326008)(8976002)(8936002)(71200400001)(71190400001)(6436002)(6486002)(68736007)(446003)(486006)(2616005)(11346002)(81156014)(8676002)(66066001)(50226002)(36756003)(81166006)(42882007)(476003)(53936002)(186003)(52116002)(73956011)(76176011)(66946007)(66476007)(66556008)(64756008)(66446008)(99286004)(7736002)(44832011)(25786009)(72206003)(305945005)(478600001)(74482002)(1076003)(256004)(6512007)(102836004)(3846002)(26005)(6116002)(386003)(6506007)(316002)(14454004)(54906003)(5660300002)(2906002)(110136005)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3068;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zDnfMKS7R5ekM7Yy3HuOLbXjFs3KiN8SrqYH1f4xO5p3OIPI5BgWuLzYLxp4i1D9WfZoZ0GP/8SC6B0lF8gGCjNqDfMLevVueOdIxQrs4V7SMK6+X6EqsY7/ztCcT2uF0HYh8lzZ83tsvtD1ne39T9DqAsw8jjgEz6jcCeB5sUyh0sajfE6LuJ2dxGb533qVyGKtZdLs5mo8KARygPoRvVNHbk2yOv+aVqp9F4hYe2NpCpcY1zstwzaGNVS2TO8tCM1HWWtHP/C0Uf8plDGvJdXxw4KfwIQ3pNbZh8DBClsnywa3ZnJrx8JhtTrF4KHWfsCkbqockwip+t7p+m9heyI7nhjgipZ2aRD81uVbqdoL9DfhprxF3sPQHCDasxTZOYH6JugxTLrk+CM8PNA9lSeCKrNSnT8Z9Ao0eV2xNkU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae34b55-85eb-45c2-05b2-08d6e8bf1694
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:33.7939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIG12ODhlNjI1MCBoYXMgcG9ydF9iYXNlX2FkZHIgMHg4IG9yIDB4MTggKGRlcGVuZGluZyBv
bg0KY29uZmlndXJhdGlvbiBwaW5zKSwgc28gaXQgY29uc3RpdHV0ZXMgYSBuZXcgZmFtaWx5IGFu
ZCBoZW5jZSBuZWVkcw0KaXRzIG93biBjb21wYXRpYmxlIHN0cmluZy4NCg0KUmV2aWV3ZWQtYnk6
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxs
ZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbWFydmVsbC50eHQgfCA3ICsrKysrLS0NCiAxIGZp
bGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbWFydmVsbC50eHQg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tYXJ2ZWxsLnR4dA0K
aW5kZXggZmViMDA3YWYxM2NiLi42Zjk1Mzg5NzRiYjkgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tYXJ2ZWxsLnR4dA0KKysrIGIvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbWFydmVsbC50eHQNCkBAIC0yMSwx
MCArMjEsMTMgQEAgd2hpY2ggaXMgYXQgYSBkaWZmZXJlbnQgTURJTyBiYXNlIGFkZHJlc3MgaW4g
ZGlmZmVyZW50IHN3aXRjaCBmYW1pbGllcy4NCiAJCQkgIDYzNDEsIDYzNTAsIDYzNTEsIDYzNTIN
CiAtICJtYXJ2ZWxsLG12ODhlNjE5MCIJOiBTd2l0Y2ggaGFzIGJhc2UgYWRkcmVzcyAweDAwLiBV
c2Ugd2l0aCBtb2RlbHM6DQogCQkJICA2MTkwLCA2MTkwWCwgNjE5MSwgNjI5MCwgNjM5MCwgNjM5
MFgNCistICJtYXJ2ZWxsLG12ODhlNjI1MCIJOiBTd2l0Y2ggaGFzIGJhc2UgYWRkcmVzcyAweDA4
IG9yIDB4MTguIFVzZSB3aXRoIG1vZGVsOg0KKwkJCSAgNjI1MA0KIA0KIFJlcXVpcmVkIHByb3Bl
cnRpZXM6DQotLSBjb21wYXRpYmxlCQk6IFNob3VsZCBiZSBvbmUgb2YgIm1hcnZlbGwsbXY4OGU2
MDg1IiBvcg0KLQkJCSAgIm1hcnZlbGwsbXY4OGU2MTkwIiBhcyBpbmRpY2F0ZWQgYWJvdmUNCist
IGNvbXBhdGlibGUJCTogU2hvdWxkIGJlIG9uZSBvZiAibWFydmVsbCxtdjg4ZTYwODUiLA0KKwkJ
CSAgIm1hcnZlbGwsbXY4OGU2MTkwIiBvciAibWFydmVsbCxtdjg4ZTYyNTAiIGFzDQorCQkJICBp
bmRpY2F0ZWQgYWJvdmUNCiAtIHJlZwkJCTogQWRkcmVzcyBvbiB0aGUgTUlJIGJ1cyBmb3IgdGhl
IHN3aXRjaC4NCiANCiBPcHRpb25hbCBwcm9wZXJ0aWVzOg0KLS0gDQoyLjIwLjENCg0K
