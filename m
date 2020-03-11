Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3741B1822BB
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgCKTsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:48:40 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33070 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbgCKTsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:48:40 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id CE81A891AF;
        Thu, 12 Mar 2020 08:48:37 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1583956117;
        bh=m1xJPSmempHGz3Lu+lC3i1E6ZFpg/65OK7kZOFZo+Uk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=hNUtg/SmsUzEYWFe1a6ysaNRnZqwO9T9pZZ5BH7+JuJS+9RfhlB8tNbs7HTaHoj7p
         VsyCEdFXEH7kKSW9MPji5I3ucrBK6zY8Cn5eQNr3ZMTHydaXePmtAP3439NJ9DBeyd
         OXMkXUTs0RBXm9lsqggA3cBFNHec3gXYlD85rlwhqQ7A8X7CO8y8Di4489BezyaEGb
         MwW+MoBV7lWneM2blN9gYdNjS9DZDRk0zi+XOBqBaK+F4ZtV2iOOW+A2WtRMdk0ll1
         BG83cnRBmZpHEdwKt94UhsAylP6QtAUOhnMAyOYDnpHqeocB5ytY/fhf/N7Mai9Coo
         sCF6BLEHoyr5A==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e6940930001>; Thu, 12 Mar 2020 08:48:35 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 12 Mar 2020 08:48:37 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 12 Mar 2020 08:48:37 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josua@solid-run.com" <josua@solid-run.com>
Subject: Re: [PATCH] net: mvmdio: avoid error message for optional IRQ
Thread-Topic: [PATCH] net: mvmdio: avoid error message for optional IRQ
Thread-Index: AQHV906TQEy52yaMuUeP8DHX6vlJ/qhCc4WAgAB+LgCAAAHegA==
Date:   Wed, 11 Mar 2020 19:48:37 +0000
Message-ID: <e03346a415bc6dafd6f9aab5b5e8bbe2a0c6d2aa.camel@alliedtelesis.co.nz>
References: <20200311024131.1289-1-chris.packham@alliedtelesis.co.nz>
         <20200311121019.GH5932@lunn.ch>
         <c99160a5fea2ac3c9e5be5093a3635bfd94710ca.camel@alliedtelesis.co.nz>
In-Reply-To: <c99160a5fea2ac3c9e5be5093a3635bfd94710ca.camel@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:d0d:cc28:ebac:1152]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9284A709B26424098BD99AF793670BD@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTEyIGF0IDA4OjQxICsxMzAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0K
PiBPbiBXZWQsIDIwMjAtMDMtMTEgYXQgMTM6MTAgKzAxMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0K
PiA+IE9uIFdlZCwgTWFyIDExLCAyMDIwIGF0IDAzOjQxOjMwUE0gKzEzMDAsIENocmlzIFBhY2to
YW0gd3JvdGU6DQo+ID4gPiBQZXIgdGhlIGR0LWJpbmRpbmcgdGhlIGludGVycnVwdCBpcyBvcHRp
b25hbCBzbyB1c2UNCj4gPiA+IHBsYXRmb3JtX2dldF9pcnFfb3B0aW9uYWwoKSBpbnN0ZWFkIG9m
IHBsYXRmb3JtX2dldF9pcnEoKS4gU2luY2UNCj4gPiA+IGNvbW1pdCA3NzIzZjRjNWVjZGIgKCJk
cml2ZXIgY29yZTogcGxhdGZvcm06IEFkZCBhbiBlcnJvciBtZXNzYWdlIHRvDQo+ID4gPiBwbGF0
Zm9ybV9nZXRfaXJxKigpIikgcGxhdGZvcm1fZ2V0X2lycSgpIHByb2R1Y2VzIGFuIGVycm9yIG1l
c3NhZ2UNCj4gPiA+IA0KPiA+ID4gICBvcmlvbi1tZGlvIGYxMDcyMDA0Lm1kaW86IElSUSBpbmRl
eCAwIG5vdCBmb3VuZA0KPiA+ID4gDQo+ID4gPiB3aGljaCBpcyBwZXJmZWN0bHkgbm9ybWFsIGlm
IG9uZSBoYXNuJ3Qgc3BlY2lmaWVkIHRoZSBvcHRpb25hbCBwcm9wZXJ0eQ0KPiA+ID4gaW4gdGhl
IGRldmljZSB0cmVlLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBQYWNraGFt
IDxjaHJpcy5wYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+DQo+ID4gPiAtLS0NCj4gPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bWRpby5jIHwgMiArLQ0KPiA+ID4gIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdm1kaW8uYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZtZGlvLmMNCj4gPiA+IGluZGV4IDBiOWU4NTFmM2Rh
NC4uZDE0NzYyZDkzNjQwIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWFydmVsbC9tdm1kaW8uYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9tdm1kaW8uYw0KPiA+ID4gQEAgLTM0Nyw3ICszNDcsNyBAQCBzdGF0aWMgaW50IG9yaW9uX21k
aW9fcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPiA+ICAJfQ0KPiA+ID4g
IA0KPiA+ID4gIA0KPiA+ID4gLQlkZXYtPmVycl9pbnRlcnJ1cHQgPSBwbGF0Zm9ybV9nZXRfaXJx
KHBkZXYsIDApOw0KPiA+ID4gKwlkZXYtPmVycl9pbnRlcnJ1cHQgPSBwbGF0Zm9ybV9nZXRfaXJx
X29wdGlvbmFsKHBkZXYsIDApOw0KPiA+ID4gIAlpZiAoZGV2LT5lcnJfaW50ZXJydXB0ID4gMCAm
Jg0KPiA+ID4gIAkgICAgcmVzb3VyY2Vfc2l6ZShyKSA8IE1WTURJT19FUlJfSU5UX01BU0sgKyA0
KSB7DQo+ID4gPiAgCQlkZXZfZXJyKCZwZGV2LT5kZXYsDQo+ID4gDQo+ID4gSGkgQ2hyaXMNCj4g
PiANCj4gPiBUaGlzIGlzIHRoZSBtaW5pbXVtIGZpeC4gU286DQo+ID4gDQo+ID4gUmV2aWV3ZWQt
Ynk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPiANCj4gPiBIb3dldmVyLCB5b3Ug
Y291bGQgYWxzbyBzaW1wbGlmeQ0KPiA+IA0KPiA+ICAgICAgICAgfSBlbHNlIGlmIChkZXYtPmVy
cl9pbnRlcnJ1cHQgPT0gLUVQUk9CRV9ERUZFUikgew0KPiA+ICAgICAgICAgICAgICAgICByZXQg
PSAtRVBST0JFX0RFRkVSOw0KPiA+ICAgICAgICAgICAgICAgICBnb3RvIG91dF9tZGlvOw0KPiA+
ICAgICAgICAgfQ0KPiA+IA0KPiA+IA0KPiA+IHRvIGp1c3QNCj4gPiANCj4gPiAgICAgICAgIH0g
ZWxzZSB7DQo+ID4gICAgICAgICAgICAgICAgIHJldCA9IGRldi0+ZXJyX2ludGVycnVwdDsNCj4g
PiAgICAgICAgICAgICAgICAgZ290byBvdXRfbWRpbzsNCj4gPiAgICAgICAgIH0NCj4gDQo+IE1h
a2VzIHNlbnNlLiBNYXkgYXMgd2VsbCBpbmNsdWRlIHRoYXQgd2hpbGUgSSdtIGhlcmUuDQo+IA0K
DQpBY3R1YWxseSBhZnRlciBsb29raW5nIGNsb3NlciB0aGF0IHdvbid0IHF1aXRlIHdvcmsuIFdl
IHN0aWxsIG5lZWQgdG8NCmhhbmRsZSB0aGUgY2FzZSB3aGVyZSBkZXYtPmVycl9pbnRlcnJ1cHQg
PT0gMCBlaXRoZXIgYmVjYXVzZSBpdCdzIG5vdA0KaW4gdGhlIGR0IG9yIGJlY2F1c2UgdGhlIGV4
dHJhIHJlc291cmNlIGlzIG5vdCBwcmVzZW50ICh0aGF0IHByb2JhYmx5DQpzaG91bGQgYmUgYW4g
ZXJyb3IgYnV0IHRoZSBleGlzdGluZyBjb2RlIHNlZW1zIHRvIHdhbnQgdG8gYWxsb3cgaXQpLg0K
DQpJJ2xsIHBvc3QgYSB2MiB3aXRoIH0gZWxzZSBpZiAoZGV2LT5lcnJfaW50ZXJydXB0IDwgMCkg
eyBhbmQgd2UgY2FuIGdvDQpmcm9tIHRoZXJlLg0KDQo+ID4gDQo+ID4gICAgIEFuZHJldw0K
