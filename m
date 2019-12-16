Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3941210D7
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfLPRGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:15 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:11937
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbfLPRGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4t4ShBxdnQiS16eK1zbSjpJLIi3mGvBWg9vr5NVKrd+NsTXIStFMXKEfwJ0fT188+j2rzL4XAnk3Q/Zgpy6aQaFRs+YY6QCLIq/qvo8da2l4EKDOmAzN7cOOMMvVDPH4z6iSWvChmj8YU/RUxSOMRSt60+U43JTYAX+v/SW8Y7h3jljudeGY3jIdpsoq1sI+c113VedpwsMF9x+mvsFRZovRhEqYLpnyExPmYm1h8jjsFqmPX34g/9QzH+YwAr2ljUF9Q8vm63/HbfU7l0XMx7VUwj04Dfga5BvhEGhpekFVGRFY1WXGXGPgL7NOdEQEBZo907aqisJnF0oJ9gIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUbJBUyUvp+lFkAS8wytBhyV2RlHjfiyOP3PT9YgncQ=;
 b=Y6vmXmr65Ji6JweutIFJQyzhqEIuDbMueRhgYcfcYMfRTEocyNfuBY30xGXpQ9aII/83rTHvKdQEhRuIYvt0hEDN1nyT4naPMM6FPLJdD0g44Du810V1MmUh0DNVjl1FwPz/gWlD2Lou61iSlG0O8BOzjcfqOmV8DWNOvxrNlVAcdxqAt0+DFsIgM2jZsH+kjdq3ChDAPlKr2+SI9Y+5x1mLpMzRFqlfyIwgK+b0FOxB0HP76ke4wMYx+HL+7vwnLMy3pJjiYODaisVsMmhmSHf7QhX1wWgKHo/YcJRyCJxNQhiW4Usaicj4oiOs7IQC+Ba3HnRmjnvuXCIBAYgpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUbJBUyUvp+lFkAS8wytBhyV2RlHjfiyOP3PT9YgncQ=;
 b=jeKRsebYyO2PfGVt5GAFYkE5zvOuulR8V6u4ORqEFzq8VeQko4585qsEbz5JdLkDtb1xe0y/WJJKP2pscFQn4QCHk1pGgWYZpn2zUoBdAqAsnFnqnleFWpa10PcxaGOEfmJ4ci/RWSk2djuqDYD4jyRi/KoSvE292nvnK7DzryI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:05:56 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:05:56 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 28/55] staging: wfx: better naming for
 hif_mib_set_association_mode->greenfield
Thread-Topic: [PATCH 28/55] staging: wfx: better naming for
 hif_mib_set_association_mode->greenfield
Thread-Index: AQHVtDLIOw1QOYejUEi/Lj89DBceTQ==
Date:   Mon, 16 Dec 2019 17:03:48 +0000
Message-ID: <20191216170302.29543-29-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 85ef0514-7f84-46c3-5291-08d7824a374b
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB44454C05E8345BB31591627993510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3/jz9FqtouGXtXKZQRguu8JwvJ7INP06dc9H7hy82biy8TZ3oX019GKL7jte9UnN29hZUNSbIua3oEmuw2wopzDYkntP7rRNCvKxvjkNiFPdaBvgpthImfGaQx0UIblZfDbf4XdNoGJ+IfD5pk1gGqWloOiGlYvYEiWITJ2hZLiTW2/2+xKQYwRNXdCyRdQE8q3CFjfZbTtZUDfbZLLpj/eEadfHUZ/s5VVss7IMMbPyvkISI6b/K+cF6KTLfIGfE6+0KtbIICBKkzTLLfO92tpEaoprAeEViX9uM7e6dYGUQlVlm/9RohjczKYZxo9J610uKpV+mfBPTY5WrwjZ7uITj2Epc7ANSuEq21/HVnogO1INSosEwUeRuoCdQbrNio8UvmY8pdDSzFbj+VQB5eDS/0iYP2NtUhkHWmoXnHDAjYNce/oR2f7bHyxoI/xV
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1B9F729CFA45041BDBAB3324EC739C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ef0514-7f84-46c3-5291-08d7824a374b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:48.2936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uzdvo1Amcxm3gNkfFE6IOisymglCFZUaZn2yQfdgZeGB+NwpWcowwfY941xfiQNGKYEJR+k5pduVemQ2PqwDNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpD
dXJyZW50IG5hbWUgIm1peGVkX29yX2dyZWVuZmllbGRfdHlwZSIgZG9lcyBub3QgYWxsb3cgdG8g
a25vdyBpZg0KInRydWUiIG1lYW5zICJtaXhlZCIgb2YgImdyZWVuZmllbGQiLiBJdCBpcyBwb3Nz
aWJsZSB0byB1c2UgYSBiZXR0ZXINCm5hbWUgYW5kIGRyb3AgImVudW0gaGlmX3R4X21vZGUiLg0K
DQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmggfCA4ICsrLS0t
LS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAgIHwgMiArLQ0KIDIgZmlsZXMg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfYXBpX21pYi5oDQppbmRleCAzNGU0MzEwYWQ3MWYuLjE2MDNiMzA3NGJmNyAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaA0KKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX21pYi5oDQpAQCAtMzk1LDExICszOTUsNiBAQCBzdHJ1Y3QgaGlmX21p
Yl9ub25fZXJwX3Byb3RlY3Rpb24gew0KIAl1OCAgIHJlc2VydmVkMlszXTsNCiB9IF9fcGFja2Vk
Ow0KIA0KLWVudW0gaGlmX3R4X21vZGUgew0KLQlISUZfVFhfTU9ERV9NSVhFRCAgICAgICAgICAg
ICAgICAgICAgICAgID0gMHgwLA0KLQlISUZfVFhfTU9ERV9HUkVFTkZJRUxEICAgICAgICAgICAg
ICAgICAgID0gMHgxDQotfTsNCi0NCiBlbnVtIGhpZl90bXBsdCB7DQogCUhJRl9UTVBMVF9QUkJS
RVEgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDB4MCwNCiAJSElGX1RNUExUX0JDTiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgID0gMHgxLA0KQEAgLTQ3NCw3ICs0NjksOCBAQCBzdHJ1
Y3QgaGlmX21pYl9zZXRfYXNzb2NpYXRpb25fbW9kZSB7DQogCXU4ICAgIHJlc2VydmVkMTo0Ow0K
IAl1OCAgICBzaG9ydF9wcmVhbWJsZToxOw0KIAl1OCAgICByZXNlcnZlZDI6NzsNCi0JdTggICAg
bWl4ZWRfb3JfZ3JlZW5maWVsZF90eXBlOw0KKwl1OCAgICBncmVlbmZpZWxkOjE7DQorCXU4ICAg
IHJlc2VydmVkMzo3Ow0KIAl1OCAgICBtcGR1X3N0YXJ0X3NwYWNpbmc7DQogCXUzMiAgIGJhc2lj
X3JhdGVfc2V0Ow0KIH0gX19wYWNrZWQ7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCmluZGV4IGU1YzkzMzY3OGM0Ny4u
OTM5YzY0ZjEwOGVkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KQEAgLTk5Niw3ICs5OTYsNyBAQCBzdGF0aWMg
dm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwNCiAJYXNzb2NpYXRp
b25fbW9kZS5zcGFjaW5nID0gMTsNCiAJYXNzb2NpYXRpb25fbW9kZS5zaG9ydF9wcmVhbWJsZSA9
IGluZm8tPnVzZV9zaG9ydF9wcmVhbWJsZTsNCiAJYXNzb2NpYXRpb25fbW9kZS5iYXNpY19yYXRl
X3NldCA9IGNwdV90b19sZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwgaW5mby0+
YmFzaWNfcmF0ZXMpKTsNCi0JYXNzb2NpYXRpb25fbW9kZS5taXhlZF9vcl9ncmVlbmZpZWxkX3R5
cGUgPSB3ZnhfaHRfZ3JlZW5maWVsZCgmd3ZpZi0+aHRfaW5mbyk7DQorCWFzc29jaWF0aW9uX21v
ZGUuZ3JlZW5maWVsZCA9IHdmeF9odF9ncmVlbmZpZWxkKCZ3dmlmLT5odF9pbmZvKTsNCiAJYXNz
b2NpYXRpb25fbW9kZS5tcGR1X3N0YXJ0X3NwYWNpbmcgPSB3ZnhfaHRfYW1wZHVfZGVuc2l0eSgm
d3ZpZi0+aHRfaW5mbyk7DQogDQogCXdmeF9jcW1fYnNzbG9zc19zbSh3dmlmLCAwLCAwLCAwKTsN
Ci0tIA0KMi4yMC4xDQo=
