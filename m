Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85F50FF2
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbfFXPKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:10:54 -0400
Received: from mail-eopbgr810057.outbound.protection.outlook.com ([40.107.81.57]:43046
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730503AbfFXPKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 11:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDfoNd8tEjCO0wpMj2qI1lEDVaw+6BCO0VXpeRHnrXo=;
 b=tK7yP0USZtBwiU5R5Qa3S4/Nk7Ei3Eki0Ayjm9JcmRxz7FvbPa1g3hbEwuoW0t/Zcetxd0vG3QQ6q9K10IGFfgmpO2UX2kJQJi+pGEk6GIfP0FfSOgntw14EwG6nlXMV4OVBOP+f0qGTFyZ3RAHEM+RY+UyXorN31oL6ULp9UtE=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1614.namprd11.prod.outlook.com (10.172.56.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 15:10:51 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 15:10:51 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v2 4/8] net: aquantia: make all files GPL-2.0-only
Thread-Topic: [PATCH net-next v2 4/8] net: aquantia: make all files
 GPL-2.0-only
Thread-Index: AQHVKp8C67nTe80OdES6M3LJwv02KA==
Date:   Mon, 24 Jun 2019 15:10:51 +0000
Message-ID: <795f0f66ddf604a91de0f4a7734d0e9b282c7a3d.1561388549.git.igor.russkikh@aquantia.com>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561388549.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b99a71cd-d8f0-462a-bd81-08d6f8b624f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1614;
x-ms-traffictypediagnostic: MWHPR11MB1614:
x-microsoft-antispam-prvs: <MWHPR11MB16142A8DA3F10EEC39E43B5798E00@MWHPR11MB1614.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(366004)(376002)(39840400004)(189003)(199004)(186003)(8676002)(99286004)(26005)(72206003)(102836004)(6916009)(316002)(81156014)(478600001)(2616005)(476003)(66066001)(76176011)(81166006)(52116002)(66446008)(64756008)(73956011)(66946007)(6506007)(386003)(44832011)(50226002)(446003)(11346002)(486006)(8936002)(54906003)(6436002)(5660300002)(71200400001)(68736007)(107886003)(53936002)(6512007)(71190400001)(2906002)(66476007)(66556008)(86362001)(305945005)(36756003)(25786009)(256004)(118296001)(4326008)(14454004)(6116002)(3846002)(6486002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1614;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2+kh/LIQ2CkTxiyeRVwowletNAgJg/4XiLt/GTfSa16IL8tjoIf5xX0uZojnlGAGUWv27nxmGj2VHiAUEV390TA34UupqyHmUO6wirMKhZH1JuLigU2JXcX14oGwYjRyjArf3XGKIBvHTcVVsh9UTasnPVU3i7SDi8L8sRa/D38MFZ1DgVYB9ro90gGHj+7GD7vuT79zHHiB7qTqKBcNx5xjRnAR8klR2eFq7px6y6guU5/s9ju1ekXCGLm7gV9Xch0yCr7EHjME9Uitzfj1YXMKosrYhBHdxXInt/GKQ7XwGVr+whU56tITJmGUz3AQsDcUrdjNszjGv0vHWh4Ia4HWwjkmikQLWsxpQhDQ8UHuBQGx5B+8L7XHCHVc2C4qDa0AjJ/M8jCZE4jr/nMzwq8Sj/6zNjuhqaOkMGCdhEw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99a71cd-d8f0-462a-bd81-08d6f8b624f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:10:51.1649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1614
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SXQgd2FzIG5vdGljZWQgc29tZSBmaWxlcyBoYWQgLW9yLWxhdGVyLCBob3dldmVyIG92ZXJhbGwg
ZHJpdmVyIGhhcw0KLW9ubHkgbGljZW5zZS4gQ2xlYW4gdGhpcyB1cC4NCg0KU2lnbmVkLW9mZi1i
eTogSWdvciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVhbnRpYS5jb20+DQotLS0NCiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmMgfCAyICstDQog
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5oIHwgMiAr
LQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2ZpbHRlcnMuYyB8
IDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJz
LmggfCAyICstDQogNCBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRp
Yy9hcV9kcnZpbmZvLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9h
cV9kcnZpbmZvLmMNCmluZGV4IGFkYWQ2YTdhY2FiZS4uNmRhNjUwOTkwNDdkIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5jDQor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmMN
CkBAIC0xLDQgKzEsNCBAQA0KLS8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9y
LWxhdGVyDQorLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KIC8qIENv
cHlyaWdodCAoQykgMjAxNC0yMDE5IGFRdWFudGlhIENvcnBvcmF0aW9uLiAqLw0KIA0KIC8qIEZp
bGUgYXFfZHJ2aW5mby5jOiBEZWZpbml0aW9uIG9mIGNvbW1vbiBjb2RlIGZvciBmaXJtd2FyZSBp
bmZvIGluIHN5cy4qLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlh
L2F0bGFudGljL2FxX2RydmluZm8uaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0
bGFudGljL2FxX2RydmluZm8uaA0KaW5kZXggNDFmYmIxMzU4MDY4Li4yM2EwNDg3ODkzYTcgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZp
bmZvLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2Ry
dmluZm8uaA0KQEAgLTEsNCArMSw0IEBADQotLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQ
TC0yLjAtb3ItbGF0ZXIgKi8NCisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1v
bmx5ICovDQogLyogQ29weXJpZ2h0IChDKSAyMDE0LTIwMTcgYVF1YW50aWEgQ29ycG9yYXRpb24u
ICovDQogDQogLyogRmlsZSBhcV9kcnZpbmZvLmg6IERlY2xhcmF0aW9uIG9mIGNvbW1vbiBjb2Rl
IGZvciBmaXJtd2FyZSBpbmZvIGluIHN5cy4qLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2ZpbHRlcnMuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2ZpbHRlcnMuYw0KaW5kZXggMThiYzAzNWRhODUwLi4w
NGE0Y2I3Y2ZjYzUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9maWx0ZXJzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlh
L2F0bGFudGljL2FxX2ZpbHRlcnMuYw0KQEAgLTEsNCArMSw0IEBADQotLy8gU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAtb3ItbGF0ZXINCisvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMC1vbmx5DQogLyogQ29weXJpZ2h0IChDKSAyMDE0LTIwMTcgYVF1YW50aWEgQ29y
cG9yYXRpb24uICovDQogDQogLyogRmlsZSBhcV9maWx0ZXJzLmM6IFJYIGZpbHRlcnMgcmVsYXRl
ZCBmdW5jdGlvbnMuICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50
aWEvYXRsYW50aWMvYXFfZmlsdGVycy5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvYXFfZmlsdGVycy5oDQppbmRleCBjNmEwOGM2NTg1ZDUuLjEyMmUwNmM4OGEzMyAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2Zp
bHRlcnMuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
ZmlsdGVycy5oDQpAQCAtMSw0ICsxLDQgQEANCi0vKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMC1vci1sYXRlciAqLw0KKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4w
LW9ubHkgKi8NCiAvKiBDb3B5cmlnaHQgKEMpIDIwMTQtMjAxNyBhUXVhbnRpYSBDb3Jwb3JhdGlv
bi4gKi8NCiANCiAvKiBGaWxlIGFxX2ZpbHRlcnMuaDogUlggZmlsdGVycyByZWxhdGVkIGZ1bmN0
aW9ucy4gKi8NCi0tIA0KMi4xNy4xDQoNCg==
