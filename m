Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824332A4176
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgKCKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:16:51 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:43362 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgKCKQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:16:51 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-Ux3BzJ5ENca1vfachE3loQ-1; Tue, 03 Nov 2020 10:16:47 +0000
X-MC-Unique: Ux3BzJ5ENca1vfachE3loQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 3 Nov 2020 10:16:46 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 3 Nov 2020 10:16:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>
Subject: RE: [PATCH net-next 6/7] drivers: net: smc911x: Fix cast from pointer
 to integer of different size
Thread-Topic: [PATCH net-next 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
Thread-Index: AQHWsXKUEvmurHYoQUeHf4PDn2uGsam2MToQ
Date:   Tue, 3 Nov 2020 10:16:46 +0000
Message-ID: <b470cb64c0354fec8d7db1ca70ba791a@AcuMS.aculab.com>
References: <20201031004958.1059797-1-andrew@lunn.ch>
        <20201031004958.1059797-7-andrew@lunn.ch>
 <20201102154745.39cd54ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102154745.39cd54ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFrdWIgS2ljaW5za2kNCj4gU2VudDogMDIgTm92ZW1iZXIgMjAyMCAyMzo0OA0KPiAN
Cj4gT24gU2F0LCAzMSBPY3QgMjAyMCAwMTo0OTo1NyArMDEwMCBBbmRyZXcgTHVubiB3cm90ZToN
Cj4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zbXNjL3NtYzkxMXguYzogSW4gZnVuY3Rpb24g4oCY
c21jOTExeF9oYXJkd2FyZV9zZW5kX3BrdOKAmToNCj4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9z
bXNjL3NtYzkxMXguYzo0NzE6MTE6IHdhcm5pbmc6IGNhc3QgZnJvbSBwb2ludGVyIHRvIGludGVn
ZXIgb2YgZGlmZmVyZW50IHNpemUNCj4gWy1XcG9pbnRlci10by1pbnQtY2FzdF0NCj4gPiAgIDQ3
MSB8ICBjbWRBID0gKCgodTMyKXNrYi0+ZGF0YSAmIDB4MykgPDwgMTYpIHwNCj4gPg0KPiA+IFdo
ZW4gYnVpbHQgb24gNjRiaXQgdGFyZ2V0cywgdGhlIHNrYi0+ZGF0YSBwb2ludGVyIGNhbm5vdCBi
ZSBjYXN0IHRvIGENCj4gPiB1MzIgaW4gYSBtZWFuaW5nZnVsIHdheS4gVXNlIGxvbmcgaW5zdGVh
ZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbWM5MTF4LmMgfCA2ICsr
Ky0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Ntc2Mvc21jOTEx
eC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbWM5MTF4LmMNCj4gPiBpbmRleCA0ZWMy
OTI1NjNmMzguLmYzNzgzMjU0MDM2NCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9zbXNjL3NtYzkxMXguYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Ntc2Mv
c21jOTExeC5jDQo+ID4gQEAgLTQ2Niw5ICs0NjYsOSBAQCBzdGF0aWMgdm9pZCBzbWM5MTF4X2hh
cmR3YXJlX3NlbmRfcGt0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ID4gIAkJCVRYX0NNRF9B
X0lOVF9GSVJTVF9TRUdfIHwgVFhfQ01EX0FfSU5UX0xBU1RfU0VHXyB8DQo+ID4gIAkJCXNrYi0+
bGVuOw0KPiA+ICAjZWxzZQ0KPiA+IC0JYnVmID0gKGNoYXIqKSgodTMyKXNrYi0+ZGF0YSAmIH4w
eDMpOw0KPiA+IC0JbGVuID0gKHNrYi0+bGVuICsgMyArICgodTMyKXNrYi0+ZGF0YSAmIDMpKSAm
IH4weDM7DQo+ID4gLQljbWRBID0gKCgodTMyKXNrYi0+ZGF0YSAmIDB4MykgPDwgMTYpIHwNCj4g
PiArCWJ1ZiA9IChjaGFyICopKChsb25nKXNrYi0+ZGF0YSAmIH4weDMpOw0KPiA+ICsJbGVuID0g
KHNrYi0+bGVuICsgMyArICgobG9uZylza2ItPmRhdGEgJiAzKSkgJiB+MHgzOw0KPiA+ICsJY21k
QSA9ICgoKGxvbmcpc2tiLT5kYXRhICYgMHgzKSA8PCAxNikgfA0KPiANCj4gUHJvYmFibHkgYmVz
dCBpZiB5b3Ugc3dhcCB0aGUgKGxvbmcpIGZvciBzb21ldGhpbmcgdW5zaWduZWQgaGVyZSBhcw0K
PiB3ZWxsLg0KDQpJdCB3b3VsZCBiZSBtdWNoIGNsZWFyZXIgd2l0aCBhIHRlbXBvcmFyeSB2YXJp
YWJsZToNCglvZmZzZXQgPSAodW5zaWduZWQgbG9uZylza2ItPmRhdGEgJiAzOw0KCWJ1ZiA9IHNr
Yi0+ZGF0YSAtIG9mZnNldDsNCglsZW4gPSBza2ItPmxlbiArIG9mZnNldDsNCgljbWRBID0gb2Zm
c2V0IDw8IDE2IHwgLi4uDQoNCiAgIERhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

