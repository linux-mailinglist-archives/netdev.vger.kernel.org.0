Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78CD367E3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfFEXYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:24:50 -0400
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:39078
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726502AbfFEXYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwP8kka38PxEGJJ6FcsgYbg1157HOpmFsbx6RT1P0PA=;
 b=kyGU35BnnNJd/mgmmCNyRRCAR+o4zZrs2oDvh6ztMddM8RO9Sof0kjudbMZT4Zvz6IP9NsQyb/2JoikN2T16tlyS9lu1p1R5HADS6wUw6+QkX/mDh2cbgM5wvrSzam+w3/gbgTW2thC9+ZMH4XWjo1/hcKoXwhxNKqOedmbV+ys=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6105.eurprd05.prod.outlook.com (20.179.10.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 23:24:40 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 23:24:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>
CC:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 4/9] linux/dim: Rename net_dim_sample() to
 net_dim_update_sample()
Thread-Topic: [for-next 4/9] linux/dim: Rename net_dim_sample() to
 net_dim_update_sample()
Thread-Index: AQHVG/XZu09Wf/uNkUKX38zHprBOdg==
Date:   Wed, 5 Jun 2019 23:24:40 +0000
Message-ID: <20190605232348.6452-5-saeedm@mellanox.com>
References: <20190605232348.6452-1-saeedm@mellanox.com>
In-Reply-To: <20190605232348.6452-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93e608ef-c9d3-4336-7467-08d6ea0cfbba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6105;
x-ms-traffictypediagnostic: DB8PR05MB6105:
x-microsoft-antispam-prvs: <DB8PR05MB6105EA52C5337C5C833BDE87BE160@DB8PR05MB6105.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:230;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39850400004)(136003)(366004)(376002)(199004)(189003)(4326008)(316002)(5660300002)(2906002)(66946007)(53936002)(186003)(8936002)(66476007)(8676002)(81166006)(66446008)(1076003)(478600001)(86362001)(50226002)(81156014)(66556008)(14454004)(107886003)(6116002)(73956011)(7736002)(305945005)(446003)(11346002)(64756008)(3846002)(14444005)(71190400001)(99286004)(26005)(25786009)(110136005)(71200400001)(486006)(2616005)(68736007)(6512007)(66066001)(6436002)(76176011)(6486002)(54906003)(36756003)(6506007)(386003)(102836004)(256004)(476003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6105;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: to9b4vnXH7LwLAURxvprFPPn9m3+cPbxKgHkGwyHZ1pC5KiclWj8t6n8fVoSC5feCSpAgEO5E4g5Eie6A3gjZGPftRUy87vi++oM6vWjuzyTmwN4TV/GvJOFLh1DKY0AjXkaVtnWh3RINK4O6kKSo9KQ8rBxzz+5iSJAAhWym0+w77E4var7cAcsr1yD1rJrvSwfI92H+gkZjBq33r7IiuPGLKYVj4Fta9lTUtn846KPpRk4lrCiK+uYOQWp7IQIjsRc2stkUve7OJK9NvL9AoCc9p4q/I0vwyG/FsILER17nSm0OtNl1/aeqZQwSu4cDpN1cZMljHmoB/VTZRAb+QZIGmw71nZbg3rkXCbwrLDiA/slX+7Uf1Jjz/fBYIFFChJiCZwniUpjpeeEgvYmBdygcF7qqPtY1Nex/vU/lVs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e608ef-c9d3-4336-7467-08d6ea0cfbba
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 23:24:40.6230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFsIEdpbGJvYSA8dGFsZ2lAbWVsbGFub3guY29tPg0KDQpJbiBvcmRlciB0byBhdm9p
ZCBjb25mdXNpb24gYmV0d2VlbiB0aGUgZnVuY3Rpb24gYW5kIHRoZSBzaW1pbGFybHkNCm5hbWVk
IHN0cnVjdC4NCkluIHByZXBhcmF0aW9uIGZvciByZW1vdmluZyB0aGUgJ25ldCcgcHJlZml4IGZy
b20gZGltIG1lbWJlcnMuDQoNClNpZ25lZC1vZmYtYnk6IFRhbCBHaWxib2EgPHRhbGdpQG1lbGxh
bm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3gu
Y29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jICAg
ICAgICB8IDQgKystLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5j
ICAgICAgICAgfCA4ICsrKystLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2Vu
ZXQvYmNtZ2VuZXQuYyAgICB8IDQgKystLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl90eHJ4LmMgfCA2ICsrLS0tLQ0KIGluY2x1ZGUvbGludXgvZGltLmggICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAzICsrLQ0KIGluY2x1ZGUvbGludXgvbmV0X2Rp
bS5oICAgICAgICAgICAgICAgICAgICAgICAgICAgfCA0ICsrLS0NCiA2IGZpbGVzIGNoYW5nZWQs
IDE0IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jDQppbmRleCBiNWUyZjlkMmNiNzEuLmZhYWY4YWRlMTVl
NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JjbXN5c3BvcnQu
Yw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jDQpAQCAt
MTAxOSw4ICsxMDE5LDggQEAgc3RhdGljIGludCBiY21fc3lzcG9ydF9wb2xsKHN0cnVjdCBuYXBp
X3N0cnVjdCAqbmFwaSwgaW50IGJ1ZGdldCkNCiAJfQ0KIA0KIAlpZiAocHJpdi0+ZGltLnVzZV9k
aW0pIHsNCi0JCW5ldF9kaW1fc2FtcGxlKHByaXYtPmRpbS5ldmVudF9jdHIsIHByaXYtPmRpbS5w
YWNrZXRzLA0KLQkJCSAgICAgICBwcml2LT5kaW0uYnl0ZXMsICZkaW1fc2FtcGxlKTsNCisJCW5l
dF9kaW1fdXBkYXRlX3NhbXBsZShwcml2LT5kaW0uZXZlbnRfY3RyLCBwcml2LT5kaW0ucGFja2V0
cywNCisJCQkJICAgICAgcHJpdi0+ZGltLmJ5dGVzLCAmZGltX3NhbXBsZSk7DQogCQluZXRfZGlt
KCZwcml2LT5kaW0uZGltLCBkaW1fc2FtcGxlKTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vYm54dC9ibnh0LmMNCmluZGV4IDQ5ZGU4NzMwNDNjMC4uZWFlYzk0OWMzNjdh
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54dC9ibnh0LmMN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jDQpAQCAtMjEz
MCwxMCArMjEzMCwxMCBAQCBzdGF0aWMgaW50IGJueHRfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3Qg
Km5hcGksIGludCBidWRnZXQpDQogCWlmIChicC0+ZmxhZ3MgJiBCTlhUX0ZMQUdfRElNKSB7DQog
CQlzdHJ1Y3QgbmV0X2RpbV9zYW1wbGUgZGltX3NhbXBsZTsNCiANCi0JCW5ldF9kaW1fc2FtcGxl
KGNwci0+ZXZlbnRfY3RyLA0KLQkJCSAgICAgICBjcHItPnJ4X3BhY2tldHMsDQotCQkJICAgICAg
IGNwci0+cnhfYnl0ZXMsDQotCQkJICAgICAgICZkaW1fc2FtcGxlKTsNCisJCW5ldF9kaW1fdXBk
YXRlX3NhbXBsZShjcHItPmV2ZW50X2N0ciwNCisJCQkJICAgICAgY3ByLT5yeF9wYWNrZXRzLA0K
KwkJCQkgICAgICBjcHItPnJ4X2J5dGVzLA0KKwkJCQkgICAgICAmZGltX3NhbXBsZSk7DQogCQlu
ZXRfZGltKCZjcHItPmRpbSwgZGltX3NhbXBsZSk7DQogCX0NCiAJcmV0dXJuIHdvcmtfZG9uZTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5l
dC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYw0KaW5k
ZXggNTI4NmE0NmVjZmIwLi4yOTdhZTc4NmZmZWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5jDQpAQCAtMTkwOSw4ICsxOTA5LDggQEAgc3Rh
dGljIGludCBiY21nZW5ldF9yeF9wb2xsKHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFwaSwgaW50IGJ1
ZGdldCkNCiAJfQ0KIA0KIAlpZiAocmluZy0+ZGltLnVzZV9kaW0pIHsNCi0JCW5ldF9kaW1fc2Ft
cGxlKHJpbmctPmRpbS5ldmVudF9jdHIsIHJpbmctPmRpbS5wYWNrZXRzLA0KLQkJCSAgICAgICBy
aW5nLT5kaW0uYnl0ZXMsICZkaW1fc2FtcGxlKTsNCisJCW5ldF9kaW1fdXBkYXRlX3NhbXBsZShy
aW5nLT5kaW0uZXZlbnRfY3RyLCByaW5nLT5kaW0ucGFja2V0cywNCisJCQkJICAgICAgcmluZy0+
ZGltLmJ5dGVzLCAmZGltX3NhbXBsZSk7DQogCQluZXRfZGltKCZyaW5nLT5kaW0uZGltLCBkaW1f
c2FtcGxlKTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl90eHJ4LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fdHhyeC5jDQppbmRleCBmOTg2MmJmNzU0OTEuLjA3NDMyZTY0MjhjZiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4
LmMNCkBAIC01Myw4ICs1Myw3IEBAIHN0YXRpYyB2b2lkIG1seDVlX2hhbmRsZV90eF9kaW0oc3Ry
dWN0IG1seDVlX3R4cXNxICpzcSkNCiAJaWYgKHVubGlrZWx5KCF0ZXN0X2JpdChNTFg1RV9TUV9T
VEFURV9BTSwgJnNxLT5zdGF0ZSkpKQ0KIAkJcmV0dXJuOw0KIA0KLQluZXRfZGltX3NhbXBsZShz
cS0+Y3EuZXZlbnRfY3RyLCBzdGF0cy0+cGFja2V0cywgc3RhdHMtPmJ5dGVzLA0KLQkJICAgICAg
ICZkaW1fc2FtcGxlKTsNCisJbmV0X2RpbV91cGRhdGVfc2FtcGxlKHNxLT5jcS5ldmVudF9jdHIs
IHN0YXRzLT5wYWNrZXRzLCBzdGF0cy0+Ynl0ZXMsICZkaW1fc2FtcGxlKTsNCiAJbmV0X2RpbSgm
c3EtPmRpbSwgZGltX3NhbXBsZSk7DQogfQ0KIA0KQEAgLTY2LDggKzY1LDcgQEAgc3RhdGljIHZv
aWQgbWx4NWVfaGFuZGxlX3J4X2RpbShzdHJ1Y3QgbWx4NWVfcnEgKnJxKQ0KIAlpZiAodW5saWtl
bHkoIXRlc3RfYml0KE1MWDVFX1JRX1NUQVRFX0FNLCAmcnEtPnN0YXRlKSkpDQogCQlyZXR1cm47
DQogDQotCW5ldF9kaW1fc2FtcGxlKHJxLT5jcS5ldmVudF9jdHIsIHN0YXRzLT5wYWNrZXRzLCBz
dGF0cy0+Ynl0ZXMsDQotCQkgICAgICAgJmRpbV9zYW1wbGUpOw0KKwluZXRfZGltX3VwZGF0ZV9z
YW1wbGUocnEtPmNxLmV2ZW50X2N0ciwgc3RhdHMtPnBhY2tldHMsIHN0YXRzLT5ieXRlcywgJmRp
bV9zYW1wbGUpOw0KIAluZXRfZGltKCZycS0+ZGltLCBkaW1fc2FtcGxlKTsNCiB9DQogDQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kaW0uaCBiL2luY2x1ZGUvbGludXgvZGltLmgNCmluZGV4
IDk4OWRiYmRmOWQ0NS4uZjBmMjBlZDI1NDk3IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9k
aW0uaA0KKysrIGIvaW5jbHVkZS9saW51eC9kaW0uaA0KQEAgLTEyMyw3ICsxMjMsOCBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgZGltX3BhcmtfdGlyZWQoc3RydWN0IG5ldF9kaW0gKmRpbSkNCiB9DQog
DQogc3RhdGljIGlubGluZSB2b2lkDQotbmV0X2RpbV9zYW1wbGUodTE2IGV2ZW50X2N0ciwgdTY0
IHBhY2tldHMsIHU2NCBieXRlcywgc3RydWN0IG5ldF9kaW1fc2FtcGxlICpzKQ0KK25ldF9kaW1f
dXBkYXRlX3NhbXBsZSh1MTYgZXZlbnRfY3RyLCB1NjQgcGFja2V0cywgdTY0IGJ5dGVzLA0KKwkJ
ICAgICAgc3RydWN0IG5ldF9kaW1fc2FtcGxlICpzKQ0KIHsNCiAJcy0+dGltZQkgICAgID0ga3Rp
bWVfZ2V0KCk7DQogCXMtPnBrdF9jdHIgICA9IHBhY2tldHM7DQpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9uZXRfZGltLmggYi9pbmNsdWRlL2xpbnV4L25ldF9kaW0uaA0KaW5kZXggZTBjOTdm
ODI0ZGQwLi5kNGI0MGFkYzdmYTEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L25ldF9kaW0u
aA0KKysrIGIvaW5jbHVkZS9saW51eC9uZXRfZGltLmgNCkBAIC0yNjEsOCArMjYxLDggQEAgc3Rh
dGljIGlubGluZSB2b2lkIG5ldF9kaW0oc3RydWN0IG5ldF9kaW0gKmRpbSwNCiAJCX0NCiAJCS8q
IGZhbGwgdGhyb3VnaCAqLw0KIAljYXNlIERJTV9TVEFSVF9NRUFTVVJFOg0KLQkJbmV0X2RpbV9z
YW1wbGUoZW5kX3NhbXBsZS5ldmVudF9jdHIsIGVuZF9zYW1wbGUucGt0X2N0ciwgZW5kX3NhbXBs
ZS5ieXRlX2N0ciwNCi0JCQkgICAgICAgJmRpbS0+c3RhcnRfc2FtcGxlKTsNCisJCW5ldF9kaW1f
dXBkYXRlX3NhbXBsZShlbmRfc2FtcGxlLmV2ZW50X2N0ciwgZW5kX3NhbXBsZS5wa3RfY3RyLA0K
KwkJCQkgICAgICBlbmRfc2FtcGxlLmJ5dGVfY3RyLCAmZGltLT5zdGFydF9zYW1wbGUpOw0KIAkJ
ZGltLT5zdGF0ZSA9IERJTV9NRUFTVVJFX0lOX1BST0dSRVNTOw0KIAkJYnJlYWs7DQogCWNhc2Ug
RElNX0FQUExZX05FV19QUk9GSUxFOg0KLS0gDQoyLjIxLjANCg0K
