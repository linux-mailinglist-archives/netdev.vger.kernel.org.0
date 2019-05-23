Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691BE27424
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfEWBz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:55:28 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:64301
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BoOIJl2mErbfS2dqa5tJDRJctyMsylwCGEaUF1UR+U=;
 b=oRuX6x/zpcwFLD4YbC32G9ow33fzw1rfYnZKZuHXM/iT3ii9PAF6GtkETGBEzcqjMzMX5h8+dQcLSnpuX9pvjBp5ZebCgrC0j19Mpz9Cuab3DiEc7vGRRQjYADKqowz/PBCfowoFEFThVEgt3dO/hCwe/MyJjEMDkjjVl0tf/x0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3408.eurprd04.prod.outlook.com (52.134.3.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:55:23 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 01:55:23 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net,stable 1/1] net: fec: add defer probe for
 of_get_mac_address
Thread-Topic: [PATCH net,stable 1/1] net: fec: add defer probe for
 of_get_mac_address
Thread-Index: AQHVEQqVg7EbGrOZ7EyghRTbLf7Z5Q==
Date:   Thu, 23 May 2019 01:55:23 +0000
Message-ID: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK0PR03CA0046.apcprd03.prod.outlook.com
 (2603:1096:203:2f::34) To VI1PR0402MB3600.eurprd04.prod.outlook.com
 (2603:10a6:803:a::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddbc7395-c738-4635-5f1a-08d6df21b7cb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3408;
x-ms-traffictypediagnostic: VI1PR0402MB3408:
x-microsoft-antispam-prvs: <VI1PR0402MB340875AB4D5305668A02DDD0FF010@VI1PR0402MB3408.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(39860400002)(346002)(136003)(366004)(189003)(199004)(6436002)(316002)(66066001)(2501003)(53936002)(86362001)(68736007)(14454004)(5660300002)(478600001)(6486002)(36756003)(6512007)(5640700003)(256004)(71190400001)(71200400001)(2906002)(73956011)(66946007)(66446008)(476003)(2616005)(486006)(64756008)(66556008)(4326008)(66476007)(8676002)(8936002)(186003)(99286004)(50226002)(54906003)(26005)(52116002)(3846002)(305945005)(6116002)(81166006)(81156014)(25786009)(1730700003)(102836004)(6506007)(386003)(6916009)(2351001)(7736002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3408;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c3Kq6+a7HaTBgj0Ie6Lh13GRLAhcNXqVdT6xPvSrfXHH+gQr4Rn69WG3LH9BeI0JTPEeNKdjdgu1vexxTBt+BNanWd5ldPjcYa6prawipEcW/9tBupue+6W/N8t6Pg7eMzKCDgnn5orP4kB+73nCC9n3Cfn1oYwtgkFN/Dv4Uw/vzwHxCSiqGYT+XkZoFuQwGanOXmWrBSlzt9jb3g3aP+W1fj9lZCGEdp06aozbUI+dh3FBL3n2XmJ+lN3JKYD042vAKwNjHpxFpOShXbhEifMtnuzTmf0QkPJ5eRQKYIrB3pAiZZepE67qQfeM3OlHKT3uLznEHh9cp0b25OEnj5pWKWl5hcg0aid0nu5vvFtOmnZ+eViFyMB/jOfQDQVpEMfqQn3ODR7OHRpCAqzTXjbBroxBkRITHmK5Xnsz/LU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddbc7395-c738-4635-5f1a-08d6df21b7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:55:23.2945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SWYgTUFDIGFkZHJlc3MgcmVhZCBmcm9tIG52bWVtIGVmdXNlIGJ5IGNhbGxpbmcgLm9mX2dldF9t
YWNfYWRkcmVzcygpLA0KYnV0IG52bWVtIGVmdXNlIGlzIHJlZ2lzdGVycmVkIGxhdGVyIHRoYW4g
dGhlIGRyaXZlciwgdGhlbiBpdA0KcmV0dXJuIC1FUFJPQkVfREVGRVIgdmFsdWUuIFNvIG1vZGlm
eSB0aGUgZHJpdmVyIHRvIHN1cHBvcnQNCmRlZmVyIHByb2JlIHdoZW4gcmVhZCBNQUMgYWRkcmVz
cyBmcm9tIG52bWVtIGVmdXNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBGdWdhbmcgRHVhbiA8ZnVnYW5n
LmR1YW5AbnhwLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNf
bWFpbi5jIHwgMTMgKysrKysrKysrKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2ZlY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVj
X21haW4uYw0KaW5kZXggODQ4ZGVmYS4uYTc2YjYwOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZmVjX21haW4uYw0KQEAgLTE2MzQsNyArMTYzNCw3IEBAIHN0YXRpYyBpbnQg
ZmVjX2VuZXRfcnhfbmFwaShzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGludCBidWRnZXQpDQog
fQ0KIA0KIC8qIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8NCi1zdGF0aWMgdm9pZCBmZWNfZ2V0X21hYyhz
dHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCitzdGF0aWMgaW50IGZlY19nZXRfbWFjKHN0cnVjdCBu
ZXRfZGV2aWNlICpuZGV2KQ0KIHsNCiAJc3RydWN0IGZlY19lbmV0X3ByaXZhdGUgKmZlcCA9IG5l
dGRldl9wcml2KG5kZXYpOw0KIAlzdHJ1Y3QgZmVjX3BsYXRmb3JtX2RhdGEgKnBkYXRhID0gZGV2
X2dldF9wbGF0ZGF0YSgmZmVwLT5wZGV2LT5kZXYpOw0KQEAgLTE2NTcsNiArMTY1Nyw4IEBAIHN0
YXRpYyB2b2lkIGZlY19nZXRfbWFjKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KIAkJCWNvbnN0
IGNoYXIgKm1hYyA9IG9mX2dldF9tYWNfYWRkcmVzcyhucCk7DQogCQkJaWYgKCFJU19FUlIobWFj
KSkNCiAJCQkJaWFwID0gKHVuc2lnbmVkIGNoYXIgKikgbWFjOw0KKwkJCWVsc2UgaWYgKFBUUl9F
UlIobWFjKSA9PSAtRVBST0JFX0RFRkVSKQ0KKwkJCQlyZXR1cm4gLUVQUk9CRV9ERUZFUjsNCiAJ
CX0NCiAJfQ0KIA0KQEAgLTE2OTMsNyArMTY5NSw3IEBAIHN0YXRpYyB2b2lkIGZlY19nZXRfbWFj
KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KIAkJZXRoX2h3X2FkZHJfcmFuZG9tKG5kZXYpOw0K
IAkJbmV0ZGV2X2luZm8obmRldiwgIlVzaW5nIHJhbmRvbSBNQUMgYWRkcmVzczogJXBNXG4iLA0K
IAkJCSAgICBuZGV2LT5kZXZfYWRkcik7DQotCQlyZXR1cm47DQorCQlyZXR1cm4gMDsNCiAJfQ0K
IA0KIAltZW1jcHkobmRldi0+ZGV2X2FkZHIsIGlhcCwgRVRIX0FMRU4pOw0KQEAgLTE3MDEsNiAr
MTcwMyw4IEBAIHN0YXRpYyB2b2lkIGZlY19nZXRfbWFjKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2
KQ0KIAkvKiBBZGp1c3QgTUFDIGlmIHVzaW5nIG1hY2FkZHIgKi8NCiAJaWYgKGlhcCA9PSBtYWNh
ZGRyKQ0KIAkJIG5kZXYtPmRldl9hZGRyW0VUSF9BTEVOLTFdID0gbWFjYWRkcltFVEhfQUxFTi0x
XSArIGZlcC0+ZGV2X2lkOw0KKw0KKwlyZXR1cm4gMDsNCiB9DQogDQogLyogLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLSAqLw0KQEAgLTMxNDYsNyArMzE1MCwxMCBAQCBzdGF0aWMgaW50IGZlY19lbmV0X2luaXQo
c3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQogCW1lbXNldChjYmRfYmFzZSwgMCwgYmRfc2l6ZSk7
DQogDQogCS8qIEdldCB0aGUgRXRoZXJuZXQgYWRkcmVzcyAqLw0KLQlmZWNfZ2V0X21hYyhuZGV2
KTsNCisJcmV0ID0gZmVjX2dldF9tYWMobmRldik7DQorCWlmIChyZXQpDQorCQlyZXR1cm4gcmV0
Ow0KKw0KIAkvKiBtYWtlIHN1cmUgTUFDIHdlIGp1c3QgYWNxdWlyZWQgaXMgcHJvZ3JhbW1lZCBp
bnRvIHRoZSBodyAqLw0KIAlmZWNfc2V0X21hY19hZGRyZXNzKG5kZXYsIE5VTEwpOw0KIA0KLS0g
DQoyLjcuNA0KDQo=
