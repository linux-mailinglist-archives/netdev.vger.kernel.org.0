Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888CF56949
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfFZMfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:35:44 -0400
Received: from mail-eopbgr720076.outbound.protection.outlook.com ([40.107.72.76]:26288
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727533AbfFZMfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ViYZ8Ne/SpqpYS0NiHrrbXx4BH8QCsPIauvwRUOi1M=;
 b=PXIe5SuulmtAWG2M5zNOvw/i6pl7gIGSOVQ9RgQfhEn7kbOpO8nLyODZykJ44Bb407x+ok0H5UABSgw/9zTMTzWvkpNGUgq+ZKx8vWBanh2dJUw0t1htKKjstqilK+1t6PG8WUZcgao4CcS0+5TrmFnDvc9u6Jg7otPwR9n7RIM=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1535.namprd11.prod.outlook.com (10.172.54.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 12:35:40 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 12:35:40 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v3 4/8] net: aquantia: make all files GPL-2.0-only
Thread-Topic: [PATCH net-next v3 4/8] net: aquantia: make all files
 GPL-2.0-only
Thread-Index: AQHVLBupnsXR3f5uBEKWHZVdrkSCTg==
Date:   Wed, 26 Jun 2019 12:35:40 +0000
Message-ID: <bb4c7a67e830e3eabad3bd1f3c45fdee3796c76f.1561552290.git.igor.russkikh@aquantia.com>
References: <cover.1561552290.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561552290.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:7:16::14) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10bb667a-980d-491e-c5ee-08d6fa32cbd5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1535;
x-ms-traffictypediagnostic: MWHPR11MB1535:
x-microsoft-antispam-prvs: <MWHPR11MB15350FD700249F21D42AC54C98E20@MWHPR11MB1535.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(39850400004)(366004)(199004)(189003)(86362001)(25786009)(6486002)(102836004)(6436002)(72206003)(6116002)(66066001)(3846002)(386003)(5660300002)(36756003)(53936002)(478600001)(2906002)(305945005)(7736002)(6512007)(66446008)(73956011)(66556008)(66476007)(64756008)(66946007)(26005)(118296001)(186003)(71190400001)(256004)(71200400001)(99286004)(446003)(4326008)(11346002)(54906003)(2616005)(50226002)(476003)(14454004)(316002)(486006)(6506007)(6916009)(68736007)(8936002)(81166006)(81156014)(52116002)(107886003)(44832011)(8676002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1535;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: to9znwIHq0cHj5FPNZRJNfsKYVs6i7CdPa2cYMSWwWcK482B1qGP30I4eN8jlXKdYJfX17+SMZwBFc6ArImtikzSFqa6I+Kc46FDwKQA8I8WnxTNV1Xoe6NiwIT1nMTuV6ERPS/1UTubq4vFQ9N4lEmZyAgLHEMd8wS4p6n1bLdPtd5+pxf8n762wtY5QdlLXr9naVJTHzj0fidbXGowY4rF5RRP7BwoflWphDsmvFuJPpSPJYGqyzLhSIiwGK+kxjNtZUuBtCWncwMiqDeR+5f6VgauBsc2eeR3MFAImlPt+KINNCqSuB6yz6VyWyAxTniOkRddkceHtEfsieNqEPIlFeQWkerdgegfvf3VivUC6AcT07+Q/DqE3I7pijC9DUYJIVCOif0quaqdZfQE1R9dvYzRSA0aicBlZALiIGc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bb667a-980d-491e-c5ee-08d6fa32cbd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:35:40.1543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1535
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SXQgd2FzIG5vdGljZWQgc29tZSBmaWxlcyBoYWQgLW9yLWxhdGVyLCBob3dldmVyIG92ZXJhbGwg
ZHJpdmVyIGhhcw0KLW9ubHkgbGljZW5zZS4gQ2xlYW4gdGhpcyB1cC4NCg0KU2lnbmVkLW9mZi1i
eTogSWdvciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVhbnRpYS5jb20+DQpSZXZpZXdlZC1i
eTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5jIHwgMiArLQ0KIGRyaXZlcnMvbmV0L2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2RydmluZm8uaCB8IDIgKy0NCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJzLmMgfCAyICstDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZmlsdGVycy5oIHwgMiArLQ0KIDQg
ZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5jDQpp
bmRleCBhZGFkNmE3YWNhYmUuLjZkYTY1MDk5MDQ3ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2RydmluZm8uYw0KKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5jDQpAQCAtMSw0ICsxLDQg
QEANCi0vLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KKy8vIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCiAvKiBDb3B5cmlnaHQgKEMpIDIw
MTQtMjAxOSBhUXVhbnRpYSBDb3Jwb3JhdGlvbi4gKi8NCiANCiAvKiBGaWxlIGFxX2RydmluZm8u
YzogRGVmaW5pdGlvbiBvZiBjb21tb24gY29kZSBmb3IgZmlybXdhcmUgaW5mbyBpbiBzeXMuKi8N
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9k
cnZpbmZvLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZp
bmZvLmgNCmluZGV4IDQxZmJiMTM1ODA2OC4uMjNhMDQ4Nzg5M2E3IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5oDQorKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmgNCkBAIC0x
LDQgKzEsNCBAQA0KLS8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9yLWxhdGVy
ICovDQorLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSAqLw0KIC8qIENv
cHlyaWdodCAoQykgMjAxNC0yMDE3IGFRdWFudGlhIENvcnBvcmF0aW9uLiAqLw0KIA0KIC8qIEZp
bGUgYXFfZHJ2aW5mby5oOiBEZWNsYXJhdGlvbiBvZiBjb21tb24gY29kZSBmb3IgZmlybXdhcmUg
aW5mbyBpbiBzeXMuKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRp
YS9hdGxhbnRpYy9hcV9maWx0ZXJzLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9maWx0ZXJzLmMNCmluZGV4IDE4YmMwMzVkYTg1MC4uMDRhNGNiN2NmY2M1IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZmls
dGVycy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9m
aWx0ZXJzLmMNCkBAIC0xLDQgKzEsNCBAQA0KLS8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBH
UEwtMi4wLW9yLWxhdGVyDQorLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25s
eQ0KIC8qIENvcHlyaWdodCAoQykgMjAxNC0yMDE3IGFRdWFudGlhIENvcnBvcmF0aW9uLiAqLw0K
IA0KIC8qIEZpbGUgYXFfZmlsdGVycy5jOiBSWCBmaWx0ZXJzIHJlbGF0ZWQgZnVuY3Rpb25zLiAq
Lw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2Fx
X2ZpbHRlcnMuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2Zp
bHRlcnMuaA0KaW5kZXggYzZhMDhjNjU4NWQ1Li4xMjJlMDZjODhhMzMgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJzLmgNCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2ZpbHRlcnMuaA0KQEAg
LTEsNCArMSw0IEBADQotLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb3ItbGF0
ZXIgKi8NCisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovDQogLyog
Q29weXJpZ2h0IChDKSAyMDE0LTIwMTcgYVF1YW50aWEgQ29ycG9yYXRpb24uICovDQogDQogLyog
RmlsZSBhcV9maWx0ZXJzLmg6IFJYIGZpbHRlcnMgcmVsYXRlZCBmdW5jdGlvbnMuICovDQotLSAN
CjIuMTcuMQ0KDQo=
