Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C6A18A4F1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgCRU5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:57:12 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:44744 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgCRU5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:57:10 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 84AAD891AD;
        Thu, 19 Mar 2020 09:57:06 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584565026;
        bh=E7sNL3L2Rpq0d2IIqOPuqXtBvkN0Vw7/6CgrbMg5BXg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=KOQv1bzFI8HNuA5GUrr0v0cwgGqw0ZKMHDtwVDthiOs66xGxzZD765xZ4gvbURiGE
         T8fN0vJsC006q8OHtlrE4wOi9EVTFUekbZdGLwSl9jAaGyuKrp3WbZNUsFYYKETaoL
         0Lw5/v3NjI3rNiEJW5L86THG1D3WFQohXO2CS1W3b/ANfmwzHvK2I6HIJ200OFrudX
         Cyb6vP3Ym7SeaUaUjEchr9hMBVrJUM12rAW9FeIqj0xu/WJ/mJgifSO34q091NCzm5
         x4IULTH76EnfgxFeoF+G3/tx4tJ1ahDw+PQoWBYewjowBklD1L9/nnoqLwPdBzwDeL
         0PLab3HxFQyRw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e728b200003>; Thu, 19 Mar 2020 09:57:04 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 19 Mar 2020 09:57:06 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 19 Mar 2020 09:57:06 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH AUTOSEL 5.4 64/73] net: mvmdio: avoid error message for
 optional IRQ
Thread-Topic: [PATCH AUTOSEL 5.4 64/73] net: mvmdio: avoid error message for
 optional IRQ
Thread-Index: AQHV/Wd8NY6V9SWU00qgq4fAlqRGrahN+tKA
Date:   Wed, 18 Mar 2020 20:57:05 +0000
Message-ID: <c5894605427bfd8a6e649894ef3874d90707a9bc.camel@alliedtelesis.co.nz>
References: <20200318205337.16279-1-sashal@kernel.org>
         <20200318205337.16279-64-sashal@kernel.org>
In-Reply-To: <20200318205337.16279-64-sashal@kernel.org>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:c08d:12b2:f65d:675b]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E770614109D42547B951A03DC3043519@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTE4IGF0IDE2OjUzIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
RnJvbTogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxlc2lzLmNvLm56Pg0K
PiANCj4gWyBVcHN0cmVhbSBjb21taXQgZTFmNTUwZGM0NGE0ZDUzNWRhNGUyNWFkYTFiMGVhZjhm
MzQxNzkyOSBdDQo+IA0KPiBQZXIgdGhlIGR0LWJpbmRpbmcgdGhlIGludGVycnVwdCBpcyBvcHRp
b25hbCBzbyB1c2UNCj4gcGxhdGZvcm1fZ2V0X2lycV9vcHRpb25hbCgpIGluc3RlYWQgb2YgcGxh
dGZvcm1fZ2V0X2lycSgpLiBTaW5jZQ0KPiBjb21taXQgNzcyM2Y0YzVlY2RiICgiZHJpdmVyIGNv
cmU6IHBsYXRmb3JtOiBBZGQgYW4gZXJyb3IgbWVzc2FnZSB0bw0KPiBwbGF0Zm9ybV9nZXRfaXJx
KigpIikgcGxhdGZvcm1fZ2V0X2lycSgpIHByb2R1Y2VzIGFuIGVycm9yIG1lc3NhZ2UNCj4gDQo+
ICAgb3Jpb24tbWRpbyBmMTA3MjAwNC5tZGlvOiBJUlEgaW5kZXggMCBub3QgZm91bmQNCj4gDQo+
IHdoaWNoIGlzIHBlcmZlY3RseSBub3JtYWwgaWYgb25lIGhhc24ndCBzcGVjaWZpZWQgdGhlIG9w
dGlvbmFsIHByb3BlcnR5DQo+IGluIHRoZSBkZXZpY2UgdHJlZS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzIFBhY2toYW0gPGNocmlzLnBhY2toYW1AYWxsaWVkdGVsZXNpcy5jby5uej4NCj4g
UmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gU2lnbmVkLW9mZi1i
eTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBTaWduZWQtb2ZmLWJ5
OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9tdm1kaW8uYyB8IDYgKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZtZGlvLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL212bWRpby5jDQo+IGluZGV4IDBiOWU4NTFmM2RhNGYuLmQyZTJkYzUzODQyODcgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZtZGlvLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdm1kaW8uYw0KPiBAQCAtMzQ3LDcgKzM0
Nyw3IEBAIHN0YXRpYyBpbnQgb3Jpb25fbWRpb19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpwZGV2KQ0KPiAgCX0NCj4gIA0KPiAgDQo+IC0JZGV2LT5lcnJfaW50ZXJydXB0ID0gcGxhdGZv
cm1fZ2V0X2lycShwZGV2LCAwKTsNCj4gKwlkZXYtPmVycl9pbnRlcnJ1cHQgPSBwbGF0Zm9ybV9n
ZXRfaXJxX29wdGlvbmFsKHBkZXYsIDApOw0KPiAgCWlmIChkZXYtPmVycl9pbnRlcnJ1cHQgPiAw
ICYmDQo+ICAJICAgIHJlc291cmNlX3NpemUocikgPCBNVk1ESU9fRVJSX0lOVF9NQVNLICsgNCkg
ew0KPiAgCQlkZXZfZXJyKCZwZGV2LT5kZXYsDQo+IEBAIC0zNjQsOCArMzY0LDggQEAgc3RhdGlj
IGludCBvcmlvbl9tZGlvX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJ
CXdyaXRlbChNVk1ESU9fRVJSX0lOVF9TTUlfRE9ORSwNCj4gIAkJCWRldi0+cmVncyArIE1WTURJ
T19FUlJfSU5UX01BU0spOw0KPiAgDQo+IC0JfSBlbHNlIGlmIChkZXYtPmVycl9pbnRlcnJ1cHQg
PT0gLUVQUk9CRV9ERUZFUikgew0KPiAtCQlyZXQgPSAtRVBST0JFX0RFRkVSOw0KPiArCX0gZWxz
ZSBpZiAoZGV2LT5lcnJfaW50ZXJydXB0IDwgMCkgew0KPiArCQlyZXQgPSBkZXYtPmVycl9pbnRl
cnJ1cHQ7DQo+ICAJCWdvdG8gb3V0X21kaW87DQo+ICAJfQ0KPiAgDQoNCk5BSy4NCg0KUGxlYXNl
IGRvbid0IGFwcGx5IHRoaXMgb25lLiBJdCBjYXVzZWQgYSBkaWZmZXJlbnQgYnVnIGFuZCB3YXMN
CnJldmVydGVkLg0KDQpEYXZlIGhhcyBqdXN0IGFwcGxpZWQgdGhlIGNvcnJlY3Qgb25lIHRvIG5l
dC9tYXN0ZXIgY29tbWl0IGlkIGlzDQpmYTI2MzJmNzRlNTdiYmM4NjljOGFkMzc3NTFhMTFiNjE0
N2EzYWNjDQoNCg==
