Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAA9121144
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfLPRKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:10:03 -0500
Received: from mail-eopbgr690046.outbound.protection.outlook.com ([40.107.69.46]:24384
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726733AbfLPRGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrC6wNWM3Y5wAYhE+0HRwM+ICfyt9RrQjidRycSKsZijy7vDq5j4pdVNbTa90bC7OQymhSrhv5K0BlMPPznZ0u0SaxHSorJECm+B1r0gpgJzGhaF12C8gPQo3aHYZ1vrAO3RaWnXpMRDxLDxU+o15vPcdwytBwiN9cz7LhzwsMd3HM4zihZvE3yuXNpXNDy3DmZ23RHR2d3ee7PD//OW7O/QVBk0Dcv9+Eg7xT4Xym1Ff7xfl49lKXhNpjraGHtHWDZSs00mEjOAOkzGaqR4wji59RZGlsycPoCexwYxF54lyEyLk7nvD3nJbfmwblEsQOg9fEAGtmBjdm9m7zwGeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmAOJ0agPheGgx1VjfCjzc7s8gA525XeVy4Yz4IE/dE=;
 b=W8h4qW8+Lz0QzlHv7f9WnFJDxn7wZHs54I6oidNDObo5hhCFKx6m0ySpxB+hUVocBIzX+GkE2kgHp2LwCvGcI/86Ln5RCRizyXsb0jOCeFxOePbMk+8fZcbFELkJuFjxgDMdK55Yhl2m1ZteFLY/B3m2SVkG7nb7zJ32PSkibcVh44WMQUDsnl80p4Wa4j6P/+4Rs0IIPZyxOCeIwFdqmzVvQ7rls+Ws3WkmuqB3IjFkYOJkfvrkY1d3Kk51lesuPXefIaHzWVQIcxDjvnysSva9ogxttXuU5g2jMVXiIatgzKG73xl0HE8VLChm2POK7p1oMAvVDBSLGmsC5zuofw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmAOJ0agPheGgx1VjfCjzc7s8gA525XeVy4Yz4IE/dE=;
 b=Dg/Pm5ScnO+EH8xSEK8kJLnTjdLe7yfIKi4pxKxOWIrq+kThT4kIkuAdVCf218XfjERSc0dSLj0mayjBrED9VmskOmbbUXDmEvq3lpB9Q74BCknTHNJN5maQzhw7HvVGrDi4A9d8F8LVNTpTU4UdOeGPt2HDAj7cFtBeNFZykEk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:40 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 37/55] staging: wfx: simplify wfx_conf_tx()
Thread-Topic: [PATCH 37/55] staging: wfx: simplify wfx_conf_tx()
Thread-Index: AQHVtDLLEVDpQgdhxE+clC6qJBCJIw==
Date:   Mon, 16 Dec 2019 17:03:52 +0000
Message-ID: <20191216170302.29543-38-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b85700c8-631d-4685-da60-08d7824a51d4
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4142369EDF6F300D8B1351BE93510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yoOnKkYEuHbfD9vMdje85NvDq4os7KmgZjgSriRYjUTCzgxTr39w9YcrtS9U7TBCSAYoWTA/kBHpWWqK00Zm0nhsbm7VXB6D5ge/PNgDRuTfeCrZ3e/Cs+YR2F8Z5P11k3Tl2UF7X0ypDLr/djseEcfCNQrpeXajsED8yLJkKG4zlb5YMgcXAIhzGxsWsC7OEaQdhffHbUphg5IKOYi63LnkVB9l61FoVJWOw3ILdScHcx/T5ExXCfVyXJIYjWKODyk/1Rsy1Mz1q2hRB5a/vI8Bn01XFEGmteGdv9OCEVATSrpw/D5jCnCbIyxH8zn9OBq6h8QXMnDuDWrgU9u+ZDegrLk7hVwvNCim0f3N8PetQqjbeE+lfXcPulZWao/rlTDO+C/FLp75nE5xdgUvwFRGCtNxBJtueiz8V8eSggmZ52svstvwFbTyTQCJquJn
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D3EE71444088243A2F99A90DF3B60E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85700c8-631d-4685-da60-08d7824a51d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:52.5272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rSVaa6BJJNG3OTClZDveCNJKB7DfCaDndjz1tuBl3H7SDLdz37/vRCCFoiF4GhwE4A7Rga7gyHPpMbrcJ7zBVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpF
cnJvciBtYW5hZ2VtZW50IG9mIHdmeF9jb25mX3R4KCkgY2FuIGJlIHNpbXBsaWZpZWQuDQoNCklu
IGFkZCwgdGhlIGhhcmR3YXJlIGNvbW1hbmQgImhpZl9zZXRfZWRjYV9xdWV1ZV9wYXJhbXMiIG5l
dmVyIHJldHVybnMNCmFueSBlcnJvci4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyB8IDQyICsrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAyNyBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jDQppbmRleCA0MmIwZDAxZDg1Y2MuLjA0NWQzOTE2YWRhOCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCkBA
IC0zNzAsMzkgKzM3MCwyNyBAQCBpbnQgd2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIxMV9odyAq
aHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsDQogew0KIAlzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
diA9IGh3LT5wcml2Ow0KIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAq
KSB2aWYtPmRydl9wcml2Ow0KLQlpbnQgcmV0ID0gMDsNCiAJc3RydWN0IGhpZl9yZXFfZWRjYV9x
dWV1ZV9wYXJhbXMgKmVkY2E7DQogDQorCVdBUk5fT04ocXVldWUgPj0gaHctPnF1ZXVlcyk7DQor
DQogCW11dGV4X2xvY2soJndkZXYtPmNvbmZfbXV0ZXgpOw0KKwl3dmlmLT5lZGNhLnVhcHNkX2Vu
YWJsZVtxdWV1ZV0gPSBwYXJhbXMtPnVhcHNkOw0KKwllZGNhID0gJnd2aWYtPmVkY2EucGFyYW1z
W3F1ZXVlXTsNCisJZWRjYS0+YWlmc24gPSBwYXJhbXMtPmFpZnM7DQorCWVkY2EtPmN3X21pbiA9
IHBhcmFtcy0+Y3dfbWluOw0KKwllZGNhLT5jd19tYXggPSBwYXJhbXMtPmN3X21heDsNCisJZWRj
YS0+dHhfb3BfbGltaXQgPSBwYXJhbXMtPnR4b3AgKiBUWE9QX1VOSVQ7DQorCWVkY2EtPmFsbG93
ZWRfbWVkaXVtX3RpbWUgPSAwOw0KKwloaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHd2aWYsIGVk
Y2EpOw0KIA0KLQlpZiAocXVldWUgPCBody0+cXVldWVzKSB7DQotCQllZGNhID0gJnd2aWYtPmVk
Y2EucGFyYW1zW3F1ZXVlXTsNCi0NCi0JCXd2aWYtPmVkY2EudWFwc2RfZW5hYmxlW3F1ZXVlXSA9
IHBhcmFtcy0+dWFwc2Q7DQotCQllZGNhLT5haWZzbiA9IHBhcmFtcy0+YWlmczsNCi0JCWVkY2Et
PmN3X21pbiA9IHBhcmFtcy0+Y3dfbWluOw0KLQkJZWRjYS0+Y3dfbWF4ID0gcGFyYW1zLT5jd19t
YXg7DQotCQllZGNhLT50eF9vcF9saW1pdCA9IHBhcmFtcy0+dHhvcCAqIFRYT1BfVU5JVDsNCi0J
CWVkY2EtPmFsbG93ZWRfbWVkaXVtX3RpbWUgPSAwOw0KLQkJcmV0ID0gaGlmX3NldF9lZGNhX3F1
ZXVlX3BhcmFtcyh3dmlmLCBlZGNhKTsNCi0JCWlmIChyZXQpIHsNCi0JCQlyZXQgPSAtRUlOVkFM
Ow0KLQkJCWdvdG8gb3V0Ow0KLQkJfQ0KLQ0KLQkJaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgw
MjExX0lGVFlQRV9TVEFUSU9OKSB7DQotCQkJcmV0ID0gd2Z4X3NldF91YXBzZF9wYXJhbSh3dmlm
LCAmd3ZpZi0+ZWRjYSk7DQotCQkJaWYgKCFyZXQgJiYgd3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUg
JiYNCi0JCQkgICAgd3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX1NUQSkNCi0JCQkJcmV0ID0gd2Z4
X3VwZGF0ZV9wbSh3dmlmKTsNCi0JCX0NCi0JfSBlbHNlIHsNCi0JCXJldCA9IC1FSU5WQUw7DQor
CWlmICh3dmlmLT52aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTikgew0KKwkJd2Z4
X3NldF91YXBzZF9wYXJhbSh3dmlmLCAmd3ZpZi0+ZWRjYSk7DQorCQlpZiAod3ZpZi0+c2V0YnNz
cGFyYW1zX2RvbmUgJiYgd3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX1NUQSkNCisJCQl3ZnhfdXBk
YXRlX3BtKHd2aWYpOw0KIAl9DQotDQotb3V0Og0KIAltdXRleF91bmxvY2soJndkZXYtPmNvbmZf
bXV0ZXgpOw0KLQlyZXR1cm4gcmV0Ow0KKwlyZXR1cm4gMDsNCiB9DQogDQogaW50IHdmeF9zZXRf
cnRzX3RocmVzaG9sZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTMyIHZhbHVlKQ0KLS0gDQoy
LjIwLjENCg==
