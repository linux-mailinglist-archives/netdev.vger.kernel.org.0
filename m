Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0465D50FF1
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfFXPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:10:52 -0400
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:31471
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730364AbfFXPKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 11:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlW3rIXMPl4qNlQ7Gr9dnIkLMOlu/C4M6i65EuDnz88=;
 b=SAf3OCKzCTSpRY1zFQhymgjugy6IWoZ91YemYkIUD8cUcUlv0N0WTzkrTXbhCCzWCmTzOOF7ICxsSeDjYmQIaBg+l3fwGPN3Ka05nmg2UQxp1E4T05RuqhNM6KZ27DDPzSVICielK1HXZc+XitRO1Rm1Khkep+dlHPcorOLCWts=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1614.namprd11.prod.outlook.com (10.172.56.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 15:10:49 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 15:10:49 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v2 3/8] maintainers: declare aquantia atlantic driver
 maintenance
Thread-Topic: [PATCH net-next v2 3/8] maintainers: declare aquantia atlantic
 driver maintenance
Thread-Index: AQHVKp8BPssYYOo04UmFkEuoj99wog==
Date:   Mon, 24 Jun 2019 15:10:49 +0000
Message-ID: <2b413d26ebc04cfca7f7dfa5422f1ea28d9cd76d.1561388549.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: a41be2d4-e5a0-4219-d2af-08d6f8b623b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1614;
x-ms-traffictypediagnostic: MWHPR11MB1614:
x-microsoft-antispam-prvs: <MWHPR11MB1614FD969CDE40F5EDEE378698E00@MWHPR11MB1614.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(366004)(376002)(39840400004)(189003)(199004)(186003)(8676002)(99286004)(4744005)(26005)(72206003)(102836004)(6916009)(316002)(81156014)(478600001)(2616005)(476003)(66066001)(76176011)(81166006)(52116002)(66446008)(64756008)(73956011)(66946007)(6506007)(386003)(44832011)(50226002)(446003)(11346002)(486006)(8936002)(54906003)(6436002)(5660300002)(71200400001)(68736007)(107886003)(53936002)(6512007)(6306002)(71190400001)(2906002)(66476007)(66556008)(86362001)(305945005)(36756003)(25786009)(256004)(118296001)(4326008)(14454004)(6116002)(3846002)(6486002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1614;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F2q88yWfMil8zQZARLTvk6i8NnK6CoL6RYtBD+4lzHlEydD+A63isKuNsWP8o+N0QJubqinGXSNH314To+iF0TLjLPnMq/5dVobsoawVtZYmHKRj6o5PKTwlvqq3eO+TzwHWc+VZd8elbyjEgXN7lF9i0v6DTRaECOoqZiKzD16AZDVY9+SQGW1LGojHu63B8gzoEON5TCdWM+rqrQYLzhXQBqWnQZIcaji31Lnrl3LERKnr2iaO5E49RdAX6VNk4Nxay+e+UHhCwtrRDTZy8FCjOoCN/wx+sNgIee6uRPjF3Bipo2NO8q5gsGSH/G+yLtsWIFrRiOme1WaaF5Wun0LiYRHpbIoihhjf3WfFWpf+0Nh3/v8IEoqd6Jt2h+RvjrK0ONK/QwPTPQSNmuQgs5fyNysQbgHBxHO3ZD6Hu6c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a41be2d4-e5a0-4219-d2af-08d6f8b623b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:10:49.1713
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

QXF1YW50aWEgaXMgcmVzcG9zaWJsZSBub3cgZm9yIGFsbCBuZXcgZmVhdHVyZXMgYW5kIGJ1Z2Zp
eGVzLg0KUmVmbGVjdCB0aGF0IGluIE1BSU5UQUlORVJTLg0KDQpTaWduZWQtb2ZmLWJ5OiBJZ29y
IFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCi0tLQ0KIE1BSU5UQUlORVJT
IHwgOSArKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQppbmRleCA2MDZkMWY4MGJjNDkuLjgy
Zjc2MmRkYmU3YSAxMDA2NDQNCi0tLSBhL01BSU5UQUlORVJTDQorKysgYi9NQUlOVEFJTkVSUw0K
QEAgLTExNDAsNiArMTE0MCwxNSBAQCBMOglsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcNCiBT
OglNYWludGFpbmVkDQogRjoJZHJpdmVycy9tZWRpYS9pMmMvYXB0aW5hLXBsbC4qDQogDQorQVFV
QU5USUEgRVRIRVJORVQgRFJJVkVSIChhdGxhbnRpYykNCitNOglJZ29yIFJ1c3NraWtoIDxpZ29y
LnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCitMOgluZXRkZXZAdmdlci5rZXJuZWwub3JnDQorUzoJ
U3VwcG9ydGVkDQorVzoJaHR0cDovL3d3dy5hcXVhbnRpYS5jb20NCitROglodHRwOi8vcGF0Y2h3
b3JrLm96bGFicy5vcmcvcHJvamVjdC9uZXRkZXYvbGlzdC8NCitGOglkcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy8NCitGOglEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2
aWNlX2RyaXZlcnMvYXF1YW50aWEvYXRsYW50aWMudHh0DQorDQogQVJDIEZSQU1FQlVGRkVSIERS
SVZFUg0KIE06CUpheWEgS3VtYXIgPGpheWFsa0BpbnR3b3Jrcy5iaXo+DQogUzoJTWFpbnRhaW5l
ZA0KLS0gDQoyLjE3LjENCg0K
