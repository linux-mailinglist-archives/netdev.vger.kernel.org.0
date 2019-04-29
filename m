Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B6EE02F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfD2KFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:17 -0400
Received: from mail-eopbgr780072.outbound.protection.outlook.com ([40.107.78.72]:52896
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727581AbfD2KFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4lSFGd/j1a+JqZHBop5X8VB+NQICi3ixnWghu6H/K4=;
 b=WI+AH2mWYABantH1w4dtK8LCs2e0PNceUj+2s+19dieEQXM6fD0F8KJ5sdoHECbykNvqQBMJ1GOqCHXOjnOOZiVgNX2wv18bIG+JWRnkpoxWvz1Zfdo76AyKTq3tdUc58y6PTWShV/wOzHv91iEXDEkGbeFtLwpJn3iBOFggiMw=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3321.namprd11.prod.outlook.com (20.176.122.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 10:05:09 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:05:09 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 15/15] net: aquantia: remove outdated device ids
Thread-Topic: [PATCH v4 net-next 15/15] net: aquantia: remove outdated device
 ids
Thread-Index: AQHU/nMHloXbycE1xEGfA6QMpgGnZw==
Date:   Mon, 29 Apr 2019 10:05:09 +0000
Message-ID: <1ba5a4e160024307e3e6a1845ade81f3e6b245e6.1556531634.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: fc7831a5-d91f-46cf-c78a-08d6cc8a2996
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3321;
x-ms-traffictypediagnostic: DM6PR11MB3321:
x-microsoft-antispam-prvs: <DM6PR11MB33213123A2D8DDD10B5C7C9C98390@DM6PR11MB3321.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:110;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(366004)(396003)(376002)(346002)(189003)(199004)(6116002)(3846002)(6916009)(73956011)(81156014)(66446008)(68736007)(64756008)(256004)(7736002)(26005)(81166006)(66946007)(66556008)(66476007)(102836004)(305945005)(486006)(6436002)(446003)(8676002)(476003)(2616005)(11346002)(478600001)(2906002)(107886003)(97736004)(4326008)(316002)(6512007)(86362001)(186003)(72206003)(6486002)(386003)(71190400001)(76176011)(6506007)(99286004)(71200400001)(52116002)(5660300002)(66066001)(36756003)(14454004)(44832011)(54906003)(50226002)(118296001)(25786009)(53936002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3321;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yLU3xMlknI5nH0Tmv3gbMyvarcRDb0+GMnDwBHyjazAhNP9kCyoL+5hich0/9rvlFvf4WfRY8SvGYfjh6JHOo2LkW6gpHINIeCVTLtbFbJkJyQ0347YoKXww68igwOSRNAoGm/7MwBFj9qGWDCVPkzcKbXEmkYgr9aSJj/ZsTuBajxme4dByvBGSaTAfI9q/w9eDhkOpGYUBvHHLvzSM/IeOHs2O/A8uyqv/509ebBIu5LLsXNGDBpBF7045Ydv1VEIIXcZO19VjPTG7EQbzMCrdeEg0VY29IRrVfyg9marlNRPJ+mLIDtV+Mjnggy5lE9gc0qx4ocwI01Ed0TR0hWpqP4aYGY9VlYZVOqiVdMAeaR35yxOpnxB39A5yku0QUH+1j1ucckqkzF9/DanRJqmZRJerNOJHGdEpBaAvKnQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7831a5-d91f-46cf-c78a-08d6cc8a2996
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:05:09.7446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3321
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmlraXRhIERhbmlsb3YgPG5kYW5pbG92QGFxdWFudGlhLmNvbT4NCg0KU29tZSBkZXZp
Y2UgaWRzIHdlcmUgbmV2ZXIgcmVsZWFzZWQgYW5kIGRvZXMgbm90IGV4aXN0Lg0KQ2xlYW51cCB0
aGVzZS4NCg0KU2lnbmVkLW9mZi1ieTogTmlraXRhIERhbmlsb3YgPG5kYW5pbG92QGFxdWFudGlh
LmNvbT4NClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2ggPGlnb3IucnVzc2tpa2hAYXF1YW50
aWEuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
Y29tbW9uLmggICAgICAgIHwgMyAtLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9wY2lfZnVuYy5jICAgICAgfCA2IC0tLS0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjAuaCB8IDMgLS0tDQogMyBmaWxl
cyBjaGFuZ2VkLCAxMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2NvbW1vbi5oIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfY29tbW9uLmgNCmluZGV4IDZiNmQxNzI0Njc2ZS4uMjM1
YmIzYTcyZDY2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRs
YW50aWMvYXFfY29tbW9uLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0
bGFudGljL2FxX2NvbW1vbi5oDQpAQCAtNDEsOSArNDEsNiBAQA0KICNkZWZpbmUgQVFfREVWSUNF
X0lEX0FRQzExMVMJMHg5MUIxDQogI2RlZmluZSBBUV9ERVZJQ0VfSURfQVFDMTEyUwkweDkyQjEN
CiANCi0jZGVmaW5lIEFRX0RFVklDRV9JRF9BUUMxMTFFCTB4NTFCMQ0KLSNkZWZpbmUgQVFfREVW
SUNFX0lEX0FRQzExMkUJMHg1MkIxDQotDQogI2RlZmluZSBIV19BVExfTklDX05BTUUgImFRdWFu
dGlhIEFRdGlvbiAxMEdiaXQgTmV0d29yayBBZGFwdGVyIg0KIA0KICNkZWZpbmUgQVFfSFdSRVZf
QU5ZCTANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRp
Yy9hcV9wY2lfZnVuYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMv
YXFfcGNpX2Z1bmMuYw0KaW5kZXggZjVjNDM1ODYzNDE3Li45Y2IwODY0ZDZkOGQgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5j
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVu
Yy5jDQpAQCAtNDMsOSArNDMsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQg
YXFfcGNpX3RibFtdID0gew0KIAl7IFBDSV9WREVWSUNFKEFRVUFOVElBLCBBUV9ERVZJQ0VfSURf
QVFDMTExUyksIH0sDQogCXsgUENJX1ZERVZJQ0UoQVFVQU5USUEsIEFRX0RFVklDRV9JRF9BUUMx
MTJTKSwgfSwNCiANCi0JeyBQQ0lfVkRFVklDRShBUVVBTlRJQSwgQVFfREVWSUNFX0lEX0FRQzEx
MUUpLCB9LA0KLQl7IFBDSV9WREVWSUNFKEFRVUFOVElBLCBBUV9ERVZJQ0VfSURfQVFDMTEyRSks
IH0sDQotDQogCXt9DQogfTsNCiANCkBAIC03NSw5ICs3Miw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgYXFfYm9hcmRfcmV2aXNpb25fcyBod19hdGxfYm9hcmRzW10gPSB7DQogCXsgQVFfREVWSUNF
X0lEX0FRQzEwOVMsCUFRX0hXUkVWX0FOWSwJJmh3X2F0bF9vcHNfYjEsICZod19hdGxfYjBfY2Fw
c19hcWMxMDlzLCB9LA0KIAl7IEFRX0RFVklDRV9JRF9BUUMxMTFTLAlBUV9IV1JFVl9BTlksCSZo
d19hdGxfb3BzX2IxLCAmaHdfYXRsX2IwX2NhcHNfYXFjMTExcywgfSwNCiAJeyBBUV9ERVZJQ0Vf
SURfQVFDMTEyUywJQVFfSFdSRVZfQU5ZLAkmaHdfYXRsX29wc19iMSwgJmh3X2F0bF9iMF9jYXBz
X2FxYzExMnMsIH0sDQotDQotCXsgQVFfREVWSUNFX0lEX0FRQzExMUUsCUFRX0hXUkVWX0FOWSwJ
Jmh3X2F0bF9vcHNfYjEsICZod19hdGxfYjBfY2Fwc19hcWMxMTFlLCB9LA0KLQl7IEFRX0RFVklD
RV9JRF9BUUMxMTJFLAlBUV9IV1JFVl9BTlksCSZod19hdGxfb3BzX2IxLCAmaHdfYXRsX2IwX2Nh
cHNfYXFjMTEyZSwgfSwNCiB9Ow0KIA0KIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBhcV9wY2lf
dGJsKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRp
Yy9od19hdGwvaHdfYXRsX2IwLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxh
bnRpYy9od19hdGwvaHdfYXRsX2IwLmgNCmluZGV4IDJjYzhkYWNmZGMyNy4uYjFjMGI2ODUwZTYw
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdf
YXRsL2h3X2F0bF9iMC5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxh
bnRpYy9od19hdGwvaHdfYXRsX2IwLmgNCkBAIC0zMiw5ICszMiw2IEBAIGV4dGVybiBjb25zdCBz
dHJ1Y3QgYXFfaHdfY2Fwc19zIGh3X2F0bF9iMF9jYXBzX2FxYzEwOTsNCiAjZGVmaW5lIGh3X2F0
bF9iMF9jYXBzX2FxYzExMXMgaHdfYXRsX2IwX2NhcHNfYXFjMTA4DQogI2RlZmluZSBod19hdGxf
YjBfY2Fwc19hcWMxMTJzIGh3X2F0bF9iMF9jYXBzX2FxYzEwOQ0KIA0KLSNkZWZpbmUgaHdfYXRs
X2IwX2NhcHNfYXFjMTExZSBod19hdGxfYjBfY2Fwc19hcWMxMDgNCi0jZGVmaW5lIGh3X2F0bF9i
MF9jYXBzX2FxYzExMmUgaHdfYXRsX2IwX2NhcHNfYXFjMTA5DQotDQogZXh0ZXJuIGNvbnN0IHN0
cnVjdCBhcV9od19vcHMgaHdfYXRsX29wc19iMDsNCiANCiAjZGVmaW5lIGh3X2F0bF9vcHNfYjEg
aHdfYXRsX29wc19iMA0KLS0gDQoyLjE3LjENCg0K
