Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9D1865B1
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgCPH30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:29:26 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:39881 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729582AbgCPH30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 03:29:26 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B2170891AD;
        Mon, 16 Mar 2020 20:29:21 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584343761;
        bh=6/Yhqp19M+yds+hz4CupW64wOVNXV7hqNXWPcJyyrTo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=JF3JUlcfUyANbpc159tRbJKrhEwJgdXOzDRsWU76ejS0U2yWgjsUER/PkFNjbM+Xy
         i3bMOxW8UbUJxLYBnGNKhbDeb18YMmH70A4uZ98O5dlF+9ykGP3lRul/1B14WUwH3P
         RxKLMxod1qP/i5CF6YMRDf/irDX45pX8DAfbrhOMBTCbOwQgKL3G/rn8OBDxtibFtF
         XQ8i04fvPMT4AegTociH5+CF4X9p8T64o7pzjo58OmoJpATTKNQPR+NJIUqaAW/CQe
         0xcxgSShJlWpWFclfjmO2Hzjz7Apsp6VBC72K5GLDYEjvSxIu0wTC8GkfCB8jqsF2S
         2lf0cUQKGy9Vg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e6f2ad10001>; Mon, 16 Mar 2020 20:29:21 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 16 Mar 2020 20:29:20 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 16 Mar 2020 20:29:20 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "josua@solid-run.com" <josua@solid-run.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: mvmdio: avoid error message for optional IRQ
Thread-Topic: [PATCH v2] net: mvmdio: avoid error message for optional IRQ
Thread-Index: AQHV9+B2ZGst8pFaOk2XUMzXhPXGHqhJ/4cA
Date:   Mon, 16 Mar 2020 07:29:20 +0000
Message-ID: <63905ad2134b4d19cb274c9e082a9326a07991ac.camel@alliedtelesis.co.nz>
References: <20200311200546.9936-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20200311200546.9936-1-chris.packham@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.14.96]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFB33A6EA81CA1409524B0401684FEF1@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTEyIGF0IDA5OjA1ICsxMzAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0K
PiBQZXIgdGhlIGR0LWJpbmRpbmcgdGhlIGludGVycnVwdCBpcyBvcHRpb25hbCBzbyB1c2UNCj4g
cGxhdGZvcm1fZ2V0X2lycV9vcHRpb25hbCgpIGluc3RlYWQgb2YgcGxhdGZvcm1fZ2V0X2lycSgp
LiBTaW5jZQ0KPiBjb21taXQgNzcyM2Y0YzVlY2RiICgiZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBB
ZGQgYW4gZXJyb3IgbWVzc2FnZSB0bw0KPiBwbGF0Zm9ybV9nZXRfaXJxKigpIikgcGxhdGZvcm1f
Z2V0X2lycSgpIHByb2R1Y2VzIGFuIGVycm9yIG1lc3NhZ2UNCj4gDQo+ICAgb3Jpb24tbWRpbyBm
MTA3MjAwNC5tZGlvOiBJUlEgaW5kZXggMCBub3QgZm91bmQNCj4gDQo+IHdoaWNoIGlzIHBlcmZl
Y3RseSBub3JtYWwgaWYgb25lIGhhc24ndCBzcGVjaWZpZWQgdGhlIG9wdGlvbmFsDQo+IHByb3Bl
cnR5DQo+IGluIHRoZSBkZXZpY2UgdHJlZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzIFBh
Y2toYW0gPGNocmlzLnBhY2toYW1AYWxsaWVkdGVsZXNpcy5jby5uej4NCj4gUmV2aWV3ZWQtYnk6
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gLS0tDQo+IA0KPiBOb3RlczoNCj4gICAg
IENoYW5nZXMgaW4gdjI6DQo+ICAgICAtIEFkZCByZXZpZXcgZnJvbSBBbmRyZXcNCj4gICAgIC0g
Q2xlYW4gdXAgZXJyb3IgaGFuZGxpbmcgY2FzZQ0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21hcnZlbGwvbXZtZGlvLmMgfCA2ICsrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tYXJ2ZWxsL212bWRpby5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9tdm1kaW8uYw0KPiBpbmRleCAwYjllODUxZjNkYTQuLmQyZTJkYzUzODQyOCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdm1kaW8uYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bWRpby5jDQo+IEBAIC0zNDcsNyArMzQ3LDcgQEAg
c3RhdGljIGludCBvcmlvbl9tZGlvX3Byb2JlKHN0cnVjdA0KPiBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQo+ICAJfQ0KPiAgDQo+ICANCj4gLQlkZXYtPmVycl9pbnRlcnJ1cHQgPSBwbGF0Zm9ybV9n
ZXRfaXJxKHBkZXYsIDApOw0KPiArCWRldi0+ZXJyX2ludGVycnVwdCA9IHBsYXRmb3JtX2dldF9p
cnFfb3B0aW9uYWwocGRldiwgMCk7DQo+ICAJaWYgKGRldi0+ZXJyX2ludGVycnVwdCA+IDAgJiYN
Cj4gIAkgICAgcmVzb3VyY2Vfc2l6ZShyKSA8IE1WTURJT19FUlJfSU5UX01BU0sgKyA0KSB7DQo+
ICAJCWRldl9lcnIoJnBkZXYtPmRldiwNCj4gQEAgLTM2NCw4ICszNjQsOCBAQCBzdGF0aWMgaW50
IG9yaW9uX21kaW9fcHJvYmUoc3RydWN0DQo+IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAkJ
d3JpdGVsKE1WTURJT19FUlJfSU5UX1NNSV9ET05FLA0KPiAgCQkJZGV2LT5yZWdzICsgTVZNRElP
X0VSUl9JTlRfTUFTSyk7DQo+ICANCj4gLQl9IGVsc2UgaWYgKGRldi0+ZXJyX2ludGVycnVwdCA9
PSAtRVBST0JFX0RFRkVSKSB7DQo+IC0JCXJldCA9IC1FUFJPQkVfREVGRVI7DQo+ICsJfSBlbHNl
IGlmIChkZXYtPmVycl9pbnRlcnJ1cHQgPCAwKSB7DQo+ICsJCXJldCA9IGRldi0+ZXJyX2ludGVy
cnVwdDsNCj4gIAkJZ290byBvdXRfbWRpbzsNCj4gIAl9DQoNCkFjdHVhbGx5IG9uIGNsb3NlciBp
bnNwZWN0aW9uIEkgdGhpbmsgdGhpcyBpcyB3cm9uZy4NCnBsYXRmb3JtX2dldF9pcnFfb3B0aW9u
YWwoKSB3aWxsIHJldHVybiAtRU5YSU8gaWYgdGhlIGlycSBpcyBub3QNCnNwZWNpZmllZC4NCg0K
U28gSSB0aGluayB2MSB3YXMgdGhlIGNvcnJlY3QgcGF0Y2ggYW5kIHRoZSBleHRyYSBjbGVhbnVw
IGluIHYyIGlzDQp3cm9uZy4NCg0KRGF2ZSwNCg0KRG8geW91IHdhbnQgbWUgdG8gc2VuZCBhIHJl
dmVydCBhbmQgcmUtc2VuZCB2MT8NCg==
