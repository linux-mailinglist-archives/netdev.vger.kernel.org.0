Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAA312114C
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLPRKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:10:15 -0500
Received: from mail-eopbgr680072.outbound.protection.outlook.com ([40.107.68.72]:26598
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfLPRDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvVVUumhQhHlyJtuHZ1zP+uLnLvX7wGsbCSzjo8Sz8HVA2Vh0ymIFzSIFfziWU2u+kRolxb5C0SMg+sbWPVGQ6nJfh0gLc4Ocmo/VMwpwGdCrxoXGeZeEw3YcNcYPJZU27M6A+utfQVqq9NhvvWEUGP/AHN6Keu5sz9qPmhM04phn4mDMWR6C4h+dfQsMl4/D8Phi8ugmad8seETbNoFcr5BpkSEDwsfxmf7nGtCjZC4ZgxfOyD9cutC8timT3eRppp/tYKQCyaKPGx0BqIHtPqEZ6PxanKGprxqHxn+YhcyhFVeYKK/2uxrXI2SODy8kRK+nwJuQyl+Q+tZY2H9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGpwC4B/qukjDfJvOvG8IITJxrt7lNwckM2EJ4ZzMpg=;
 b=XwQRfNxpaGs36dHwjrYMbGcU8GROjJPXG7P+/IMYYo37mwDWGXVRGQxiy8IEn7aCZfG6/VLwH3ppzsa/BHG9W6hYZm4OoEvSFtmip5UvdcGAQLrzolRBklQ8IFjLsf3Opn2vhwx44yhdmuVAETnjrEHJ+qn/XYufqlLKD24FDLwoQPxTMZsRqBkM2ZuTodOweHrm2WCAhoTdGH5o3m4b3HcbQwVcAVXu28H8ONPQJH9rpkN/m6K5dtaYmhYriu8yB7ISDz4+4sEoVyL/djeznqN1mHlGHsDYReTFH/FCAiUl7DApGUruALY0I26rNru5L5hiJZPvUkXV775nECUchw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGpwC4B/qukjDfJvOvG8IITJxrt7lNwckM2EJ4ZzMpg=;
 b=dxeD2W3gQwzdgZD/U3YgEikZTRjezKxdG7HmXFrzfUK97reXbnWe56qLjCh+meZJmn62ylTBDx4tuytrJ9QDj3H3FgXmwpvGdZy7hbvd2KyqpND1gF33st1dO35Ekvmj/oQq8FLeYMWOCAV3T1alSU+r51BjeleZfkLKrVVjpRQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:40 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 05/55] staging: wfx: firmware does not support more than 32
 total retries
Thread-Topic: [PATCH 05/55] staging: wfx: firmware does not support more than
 32 total retries
Thread-Index: AQHVtDLA9JnpeuW4OEuF0InFPeSw1g==
Date:   Mon, 16 Dec 2019 17:03:35 +0000
Message-ID: <20191216170302.29543-6-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ab8d6d9c-89b3-4f6f-f9e5-08d78249e63a
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB38386FF085715C7470C3274D93510@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(85202003)(8936002)(4744005)(81166006)(8676002)(54906003)(110136005)(316002)(85182001)(6506007)(186003)(2906002)(5660300002)(6512007)(26005)(107886003)(81156014)(36756003)(4326008)(6666004)(2616005)(76116006)(91956017)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(66446008)(6486002)(478600001)(1076003)(66574012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zg713MWNo8c2zEnxPpte+UXBHmreeOxVefnwsbTQgbJKio5D7fM7d8Aac88xsW88w8dxRFvT9SI39vhUis87BMZ6VOBaD0TK9ja0UwM417DQpmvwqNpZgyGtFYs7NyIA55qMAgMIljYU2Zy2QPVO4enXNFPyV+1ZJlqLrKIs9XLKyF/HCp6QwQ7Z6skTZ/Lp3wlNcPUoAm4UEWe4wCjRe1kMbCewInO8blR2+C+HAPNfJPSnYqHU+FxcuBlEQDRYwf/QGfuDXAKDWbxBg3ip/Pl4yeRzpfzNm70kBt7ezax5XcY6MbjQxhNwjlIkiwuIu8qrcfj0KICK4N/fsKOxteazeWKlk5qRlL1hFPuAgnz1aYW/UXSA+0c3iunyDvVo7SJ7Xt9t0z+mpA//n6VQ9j+jYhkNSg8OAuqRi7mk6UhAs6kAcYQN5wLWzc/pZNtY
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD4F86BE31856446AF9FB0878CC92D8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8d6d9c-89b3-4f6f-f9e5-08d78249e63a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:35.5500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8cVoWD7uxEVvcjA4J4ATNvHVt96fUgWYQEvdcpHKIIPOH8dPB7EPHSm3jFhQSWe6z4lTv8ZPgrj+GIC4Wzcow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgc3VtIG9mIGFsbCByZXRyaWVzIGZvciBhIFR4IGZyYW1lIGNhbm5vdCBiZSBzdXBlcmlvciB0
byAzMi4NCg0KVGhlcmUgYXJlIDQgcmF0ZXMgYXQgbW9zdC4gU28gdGhpcyBwYXRjaCBsaW1pdHMg
bnVtYmVyIG9mIHJldHJpZXMgcGVyDQpyYXRlIHRvIDguDQoNClNpZ25lZC1vZmYtYnk6IErDqXLD
tG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvbWFpbi5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWlu
LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYw0KaW5kZXggOTg2YTJlZjY3OGI5Li4zYjQ3
YjZjMjFlYTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYw0KKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMNCkBAIC0yODksNyArMjg5LDcgQEAgc3RydWN0IHdm
eF9kZXYgKndmeF9pbml0X2NvbW1vbihzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCWh3LT5zdGFfZGF0
YV9zaXplID0gc2l6ZW9mKHN0cnVjdCB3Znhfc3RhX3ByaXYpOw0KIAlody0+cXVldWVzID0gNDsN
CiAJaHctPm1heF9yYXRlcyA9IDg7DQotCWh3LT5tYXhfcmF0ZV90cmllcyA9IDE1Ow0KKwlody0+
bWF4X3JhdGVfdHJpZXMgPSA4Ow0KIAlody0+ZXh0cmFfdHhfaGVhZHJvb20gPSBzaXplb2Yoc3Ry
dWN0IGhpZl9zbF9tc2dfaGRyKSArDQogCQkJCXNpemVvZihzdHJ1Y3QgaGlmX21zZykNCiAJCQkJ
KyBzaXplb2Yoc3RydWN0IGhpZl9yZXFfdHgpDQotLSANCjIuMjAuMQ0K
