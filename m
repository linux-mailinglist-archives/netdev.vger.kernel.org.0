Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF081822AF
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgCKTmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:42:02 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33063 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCKTmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:42:00 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A3FA0891AF;
        Thu, 12 Mar 2020 08:41:57 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1583955717;
        bh=g98wG8WC2CahiRzoVUwtQdsdYBgfJpe+m0ZeRfNV880=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=DaPQKPvIYiwp6jZS6MdbCk1WeermGpFB1l62YuDeoJO9VtHnCR3xzFt2QqjScmxbc
         MmXw/09XjhNzkzwdZhARirBh1KEujbKxxJ09z+fNM9pI7a5iumyAUtbAjQ2+9PQO52
         6WngUURNSOfevKYlyTlFw/cqmaZHG4ZsVDPAHEy58YRKHq/pwlejeBYRvJCUzdve5E
         ZTeWZWPP4wumFeMc5FFnyZYQ0IWH+17LFcZsiwHn6EvtHxgCAA+bTmPkrdNtzsWjI9
         /dj/wv3bgRFyHa3j+T6TnLB57j3KDwOGCOn/kyY2srqYmxwRYbWN+gq1W/KMKhB77o
         +2afZ6G/Z5bFA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e693f030001>; Thu, 12 Mar 2020 08:41:55 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 12 Mar 2020 08:41:57 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 12 Mar 2020 08:41:57 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josua@solid-run.com" <josua@solid-run.com>
Subject: Re: [PATCH] net: mvmdio: avoid error message for optional IRQ
Thread-Topic: [PATCH] net: mvmdio: avoid error message for optional IRQ
Thread-Index: AQHV906TQEy52yaMuUeP8DHX6vlJ/qhCc4WAgAB+LgA=
Date:   Wed, 11 Mar 2020 19:41:56 +0000
Message-ID: <c99160a5fea2ac3c9e5be5093a3635bfd94710ca.camel@alliedtelesis.co.nz>
References: <20200311024131.1289-1-chris.packham@alliedtelesis.co.nz>
         <20200311121019.GH5932@lunn.ch>
In-Reply-To: <20200311121019.GH5932@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:d0d:cc28:ebac:1152]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CD552B9960E0241B58E9FF096CDE41A@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTExIGF0IDEzOjEwICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gV2VkLCBNYXIgMTEsIDIwMjAgYXQgMDM6NDE6MzBQTSArMTMwMCwgQ2hyaXMgUGFja2hhbSB3
cm90ZToNCj4gPiBQZXIgdGhlIGR0LWJpbmRpbmcgdGhlIGludGVycnVwdCBpcyBvcHRpb25hbCBz
byB1c2UNCj4gPiBwbGF0Zm9ybV9nZXRfaXJxX29wdGlvbmFsKCkgaW5zdGVhZCBvZiBwbGF0Zm9y
bV9nZXRfaXJxKCkuIFNpbmNlDQo+ID4gY29tbWl0IDc3MjNmNGM1ZWNkYiAoImRyaXZlciBjb3Jl
OiBwbGF0Zm9ybTogQWRkIGFuIGVycm9yIG1lc3NhZ2UgdG8NCj4gPiBwbGF0Zm9ybV9nZXRfaXJx
KigpIikgcGxhdGZvcm1fZ2V0X2lycSgpIHByb2R1Y2VzIGFuIGVycm9yIG1lc3NhZ2UNCj4gPiAN
Cj4gPiAgIG9yaW9uLW1kaW8gZjEwNzIwMDQubWRpbzogSVJRIGluZGV4IDAgbm90IGZvdW5kDQo+
ID4gDQo+ID4gd2hpY2ggaXMgcGVyZmVjdGx5IG5vcm1hbCBpZiBvbmUgaGFzbid0IHNwZWNpZmll
ZCB0aGUgb3B0aW9uYWwgcHJvcGVydHkNCj4gPiBpbiB0aGUgZGV2aWNlIHRyZWUuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxl
c2lzLmNvLm56Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212
bWRpby5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFy
dmVsbC9tdm1kaW8uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZtZGlvLmMNCj4g
PiBpbmRleCAwYjllODUxZjNkYTQuLmQxNDc2MmQ5MzY0MCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bWRpby5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9tdm1kaW8uYw0KPiA+IEBAIC0zNDcsNyArMzQ3LDcgQEAgc3RhdGlj
IGludCBvcmlvbl9tZGlvX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4g
IAl9DQo+ID4gIA0KPiA+ICANCj4gPiAtCWRldi0+ZXJyX2ludGVycnVwdCA9IHBsYXRmb3JtX2dl
dF9pcnEocGRldiwgMCk7DQo+ID4gKwlkZXYtPmVycl9pbnRlcnJ1cHQgPSBwbGF0Zm9ybV9nZXRf
aXJxX29wdGlvbmFsKHBkZXYsIDApOw0KPiA+ICAJaWYgKGRldi0+ZXJyX2ludGVycnVwdCA+IDAg
JiYNCj4gPiAgCSAgICByZXNvdXJjZV9zaXplKHIpIDwgTVZNRElPX0VSUl9JTlRfTUFTSyArIDQp
IHsNCj4gPiAgCQlkZXZfZXJyKCZwZGV2LT5kZXYsDQo+IA0KPiBIaSBDaHJpcw0KPiANCj4gVGhp
cyBpcyB0aGUgbWluaW11bSBmaXguIFNvOg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5u
IDxhbmRyZXdAbHVubi5jaD4NCj4gDQo+IEhvd2V2ZXIsIHlvdSBjb3VsZCBhbHNvIHNpbXBsaWZ5
DQo+IA0KPiAgICAgICAgIH0gZWxzZSBpZiAoZGV2LT5lcnJfaW50ZXJydXB0ID09IC1FUFJPQkVf
REVGRVIpIHsNCj4gICAgICAgICAgICAgICAgIHJldCA9IC1FUFJPQkVfREVGRVI7DQo+ICAgICAg
ICAgICAgICAgICBnb3RvIG91dF9tZGlvOw0KPiAgICAgICAgIH0NCj4gDQo+IA0KPiB0byBqdXN0
DQo+IA0KPiAgICAgICAgIH0gZWxzZSB7DQo+ICAgICAgICAgICAgICAgICByZXQgPSBkZXYtPmVy
cl9pbnRlcnJ1cHQ7DQo+ICAgICAgICAgICAgICAgICBnb3RvIG91dF9tZGlvOw0KPiAgICAgICAg
IH0NCg0KTWFrZXMgc2Vuc2UuIE1heSBhcyB3ZWxsIGluY2x1ZGUgdGhhdCB3aGlsZSBJJ20gaGVy
ZS4NCg0KPiANCj4gICAgIEFuZHJldw0K
