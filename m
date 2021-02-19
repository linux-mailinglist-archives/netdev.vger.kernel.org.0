Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C453B31F5E3
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 09:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBSI2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 03:28:52 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:57071 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhBSI2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 03:28:38 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id A1EFC3802F4
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 09:27:51 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VV06RYRwNeWS for <netdev@vger.kernel.org>;
        Fri, 19 Feb 2021 09:27:50 +0100 (CET)
Received: from gateway.a-eberle.de (unknown [178.15.155.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "sg310.eberle.local", Issuer "A. Eberle GmbH & Co. KG WebAdmin CA" (not verified))
        (Authenticated sender: postmaster@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 09:27:49 +0100 (CET)
Received: from exch-svr2013.eberle.local ([192.168.1.9]:63158 helo=webmail.a-eberle.de)
        by gateway.a-eberle.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Marco.Wenzel@a-eberle.de>)
        id 1lD18V-0005jK-0y; Fri, 19 Feb 2021 09:27:39 +0100
Received: from EXCH-SVR2013.eberle.local (192.168.1.9) by
 EXCH-SVR2013.eberle.local (192.168.1.9) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 19 Feb 2021 09:27:39 +0100
Received: from EXCH-SVR2013.eberle.local ([::1]) by EXCH-SVR2013.eberle.local
 ([::1]) with mapi id 15.00.1497.006; Fri, 19 Feb 2021 09:27:39 +0100
From:   "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
To:     George McCollister <george.mccollister@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Amol Grover" <frextrite@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Arvid Brodin" <Arvid.Brodin@xdin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH] net: hsr: add support for EntryForgetTime
Thread-Topic: [PATCH] net: hsr: add support for EntryForgetTime
Thread-Index: AQHXBgcCsUiAmOwGqUaHdB9KiIzt96peE+YAgAEPgRA=
Date:   Fri, 19 Feb 2021 08:27:38 +0000
Message-ID: <65ce3da11b8b4a3197835c5a85c40ce5@EXCH-SVR2013.eberle.local>
References: <CAFSKS=Ncr-9s1Oi0GTqQ74sUaDjoHR-1P-yM+rNqjF-Hb+cPCA@mail.gmail.com>
 <20210218150116.1521-1-marco.wenzel@a-eberle.de>
 <CAFSKS=OpnDK83F6MWCpGDg2pdY-enJyusB5Th1RGvq8UC1WCNQ@mail.gmail.com>
In-Reply-To: <CAFSKS=OpnDK83F6MWCpGDg2pdY-enJyusB5Th1RGvq8UC1WCNQ@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.242.2.55]
x-kse-serverinfo: EXCH-SVR2013.eberle.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 19.02.2021 06:40:00
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBGZWIgMTgsIDIwMjEgYXQgNjowNiBQTSA6IEdlb3JnZSBNY0NvbGxpc3RlciA8Z2Vv
cmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIEZlYiAxOCwg
MjAyMSBhdCA5OjAxIEFNIE1hcmNvIFdlbnplbCA8bWFyY28ud2VuemVsQGEtDQo+IGViZXJsZS5k
ZT4gd3JvdGU6DQo+ID4NCj4gPiBJbiBJRUMgNjI0MzktMyBFbnRyeUZvcmdldFRpbWUgaXMgZGVm
aW5lZCB3aXRoIGEgdmFsdWUgb2YgNDAwIG1zLiBXaGVuDQo+ID4gYSBub2RlIGRvZXMgbm90IHNl
bmQgYW55IGZyYW1lIHdpdGhpbiB0aGlzIHRpbWUsIHRoZSBzZXF1ZW5jZSBudW1iZXINCj4gPiBj
aGVjayBmb3IgY2FuIGJlIGlnbm9yZWQuIFRoaXMgc29sdmVzIGNvbW11bmljYXRpb24gaXNzdWVz
IHdpdGggQ2lzY28NCj4gPiBJRSAyMDAwIGluIFJlZGJveCBtb2RlLg0KPiA+DQo+ID4gRml4ZXM6
IGY0MjE0MzZhNTkxZCAoIm5ldC9oc3I6IEFkZCBzdXBwb3J0IGZvciB0aGUgSGlnaC1hdmFpbGFi
aWxpdHkNCj4gPiBTZWFtbGVzcyBSZWR1bmRhbmN5IHByb3RvY29sIChIU1J2MCkiKQ0KPiA+IFNp
Z25lZC1vZmYtYnk6IE1hcmNvIFdlbnplbCA8bWFyY28ud2VuemVsQGEtZWJlcmxlLmRlPg0KPiA+
IC0tLQ0KPiA+ICBuZXQvaHNyL2hzcl9mcmFtZXJlZy5jIHwgOSArKysrKysrLS0NCj4gPiAgbmV0
L2hzci9oc3JfZnJhbWVyZWcuaCB8IDEgKw0KPiA+ICBuZXQvaHNyL2hzcl9tYWluLmggICAgIHwg
MSArDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9oc3IvaHNyX2ZyYW1lcmVnLmMgYi9uZXQvaHNy
L2hzcl9mcmFtZXJlZy5jIGluZGV4DQo+ID4gNWM5N2RlNDU5OTA1Li44MDVmOTc0OTIzYjkgMTAw
NjQ0DQo+ID4gLS0tIGEvbmV0L2hzci9oc3JfZnJhbWVyZWcuYw0KPiA+ICsrKyBiL25ldC9oc3Iv
aHNyX2ZyYW1lcmVnLmMNCj4gPiBAQCAtMTY0LDggKzE2NCwxMCBAQCBzdGF0aWMgc3RydWN0IGhz
cl9ub2RlICpoc3JfYWRkX25vZGUoc3RydWN0DQo+IGhzcl9wcml2ICpoc3IsDQo+ID4gICAgICAg
ICAgKiBhcyBpbml0aWFsaXphdGlvbi4gKDAgY291bGQgdHJpZ2dlciBhbiBzcHVyaW91cyByaW5n
IGVycm9yIHdhcm5pbmcpLg0KPiA+ICAgICAgICAgICovDQo+ID4gICAgICAgICBub3cgPSBqaWZm
aWVzOw0KPiA+IC0gICAgICAgZm9yIChpID0gMDsgaSA8IEhTUl9QVF9QT1JUUzsgaSsrKQ0KPiA+
ICsgICAgICAgZm9yIChpID0gMDsgaSA8IEhTUl9QVF9QT1JUUzsgaSsrKSB7DQo+ID4gICAgICAg
ICAgICAgICAgIG5ld19ub2RlLT50aW1lX2luW2ldID0gbm93Ow0KPiA+ICsgICAgICAgICAgICAg
ICBuZXdfbm9kZS0+dGltZV9vdXRbaV0gPSBub3c7DQo+ID4gKyAgICAgICB9DQo+ID4gICAgICAg
ICBmb3IgKGkgPSAwOyBpIDwgSFNSX1BUX1BPUlRTOyBpKyspDQo+ID4gICAgICAgICAgICAgICAg
IG5ld19ub2RlLT5zZXFfb3V0W2ldID0gc2VxX291dDsNCj4gPg0KPiA+IEBAIC00MTEsOSArNDEz
LDEyIEBAIHZvaWQgaHNyX3JlZ2lzdGVyX2ZyYW1lX2luKHN0cnVjdCBoc3Jfbm9kZQ0KPiAqbm9k
ZSwNCj4gPiBzdHJ1Y3QgaHNyX3BvcnQgKnBvcnQsICBpbnQgaHNyX3JlZ2lzdGVyX2ZyYW1lX291
dChzdHJ1Y3QgaHNyX3BvcnQgKnBvcnQsDQo+IHN0cnVjdCBoc3Jfbm9kZSAqbm9kZSwNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB1MTYgc2VxdWVuY2VfbnIpICB7DQo+ID4gLSAgICAg
ICBpZiAoc2VxX25yX2JlZm9yZV9vcl9lcShzZXF1ZW5jZV9uciwgbm9kZS0+c2VxX291dFtwb3J0
LT50eXBlXSkpDQo+ID4gKyAgICAgICBpZiAoc2VxX25yX2JlZm9yZV9vcl9lcShzZXF1ZW5jZV9u
ciwgbm9kZS0+c2VxX291dFtwb3J0LT50eXBlXSkNCj4gJiYNCj4gPiArICAgICAgICAgICB0aW1l
X2lzX2FmdGVyX2ppZmZpZXMobm9kZS0+dGltZV9vdXRbcG9ydC0+dHlwZV0gKw0KPiA+ICsgICAg
ICAgICAgIG1zZWNzX3RvX2ppZmZpZXMoSFNSX0VOVFJZX0ZPUkdFVF9USU1FKSkpDQo+ID4gICAg
ICAgICAgICAgICAgIHJldHVybiAxOw0KPiA+DQo+ID4gKyAgICAgICBub2RlLT50aW1lX291dFtw
b3J0LT50eXBlXSA9IGppZmZpZXM7DQo+ID4gICAgICAgICBub2RlLT5zZXFfb3V0W3BvcnQtPnR5
cGVdID0gc2VxdWVuY2VfbnI7DQo+ID4gICAgICAgICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+IGRp
ZmYgLS1naXQgYS9uZXQvaHNyL2hzcl9mcmFtZXJlZy5oIGIvbmV0L2hzci9oc3JfZnJhbWVyZWcu
aCBpbmRleA0KPiA+IDg2YjQzZjUzOWYyYy4uZDk2MjhlN2E1ZjA1IDEwMDY0NA0KPiA+IC0tLSBh
L25ldC9oc3IvaHNyX2ZyYW1lcmVnLmgNCj4gPiArKysgYi9uZXQvaHNyL2hzcl9mcmFtZXJlZy5o
DQo+ID4gQEAgLTc1LDYgKzc1LDcgQEAgc3RydWN0IGhzcl9ub2RlIHsNCj4gPiAgICAgICAgIGVu
dW0gaHNyX3BvcnRfdHlwZSAgICAgIGFkZHJfQl9wb3J0Ow0KPiA+ICAgICAgICAgdW5zaWduZWQg
bG9uZyAgICAgICAgICAgdGltZV9pbltIU1JfUFRfUE9SVFNdOw0KPiA+ICAgICAgICAgYm9vbCAg
ICAgICAgICAgICAgICAgICAgdGltZV9pbl9zdGFsZVtIU1JfUFRfUE9SVFNdOw0KPiA+ICsgICAg
ICAgdW5zaWduZWQgbG9uZyAgICAgICAgICAgdGltZV9vdXRbSFNSX1BUX1BPUlRTXTsNCj4gPiAg
ICAgICAgIC8qIGlmIHRoZSBub2RlIGlzIGEgU0FOICovDQo+ID4gICAgICAgICBib29sICAgICAg
ICAgICAgICAgICAgICBzYW5fYTsNCj4gPiAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAg
IHNhbl9iOw0KPiA+IGRpZmYgLS1naXQgYS9uZXQvaHNyL2hzcl9tYWluLmggYi9uZXQvaHNyL2hz
cl9tYWluLmggaW5kZXgNCj4gPiA3ZGM5MmNlNWExMzQuLmY3OWNhNTVkNjk4NiAxMDA2NDQNCj4g
PiAtLS0gYS9uZXQvaHNyL2hzcl9tYWluLmgNCj4gPiArKysgYi9uZXQvaHNyL2hzcl9tYWluLmgN
Cj4gPiBAQCAtMjEsNiArMjEsNyBAQA0KPiA+ICAjZGVmaW5lIEhTUl9MSUZFX0NIRUNLX0lOVEVS
VkFMICAgICAgICAgICAgICAgICAyMDAwIC8qIG1zICovDQo+ID4gICNkZWZpbmUgSFNSX05PREVf
Rk9SR0VUX1RJTUUgICAgICAgICAgIDYwMDAwIC8qIG1zICovDQo+ID4gICNkZWZpbmUgSFNSX0FO
Tk9VTkNFX0lOVEVSVkFMICAgICAgICAgICAgMTAwIC8qIG1zICovDQo+ID4gKyNkZWZpbmUgSFNS
X0VOVFJZX0ZPUkdFVF9USU1FICAgICAgICAgICAgNDAwIC8qIG1zICovDQo+ID4NCj4gPiAgLyog
QnkgaG93IG11Y2ggbWF5IHNsYXZlMSBhbmQgc2xhdmUyIHRpbWVzdGFtcHMgb2YgbGF0ZXN0IHJl
Y2VpdmVkDQo+IGZyYW1lIGZyb20NCj4gPiAgICogZWFjaCBub2RlIGRpZmZlciBiZWZvcmUgd2Ug
bm90aWZ5IG9mIGNvbW11bmljYXRpb24gcHJvYmxlbT8NCj4gPiAtLQ0KPiA+IDIuMzAuMA0KPiA+
DQo+IA0KPiBzY3JpcHRzL2NoZWNrcGF0Y2gucGwgZ2l2ZXMgZXJyb3JzIGFib3V0IERPUyBsaW5l
IGVuZGluZ3MgYnV0IG9uY2UgdGhhdCBpcw0KPiByZXNvbHZlZCB0aGlzIGxvb2tzIGdvb2QuIEkg
dGVzdGVkIGl0IG9uIGFuIEhTUiBuZXR3b3JrIHdpdGggdGhlIHNvZnR3YXJlDQo+IGltcGxlbWVu
dGF0aW9uIGFuZCB0aGUgeHJzNzAweCB3aGljaCB1c2VzIG9mZmxvYWRpbmcgYW5kIGV2ZXJ5dGhp
bmcgc3RpbGwNCj4gd29ya3MuIEkgZG9uJ3QgaGF2ZSBhIHdheSB0byBmb3JjZSBhbnl0aGluZyBv
biB0aGUgSFNSIG5ldHdvcmsgdG8gcmV1c2UNCj4gc2VxdWVuY2UgbnVtYmVycyBhZnRlciA0MDBt
cy4NCj4gDQo+IFJldmlld2VkLWJ5OiBHZW9yZ2UgTWNDb2xsaXN0ZXIgPGdlb3JnZS5tY2NvbGxp
c3RlckBnbWFpbC5jb20NCj4gVGVzdGVkLWJ5OiBHZW9yZ2UgTWNDb2xsaXN0ZXIgPGdlb3JnZS5t
Y2NvbGxpc3RlckBnbWFpbC5jb20NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgcmV2aWV3aW5n
LCB0ZXN0aW5nIGFuZCBzdXBwb3J0aW5nIQ0KDQpXaGVyZSBkbyB5b3Ugc2VlIHRoZSBpbmNvcnJl
Y3QgbGluZSBlbmRpbmdzPyBJIGp1c3QgcmFuIHNjcmlwdHMvY2hlY2twYXRoLnBsIGFzIGdpdCBj
b21taXQgaG9vayBhbmQgaXQgZGlkIG5vdCByZXBvcnQgYW55IGVycm9ycy4gV2hlbiBJIHJ1biBp
dCBhZ2FpbiBtYW51YWxseSwgaXQgYWxzbyBkb2VzIG5vdCByZXBvcnQgYW55IGVycm9yczoNCg0K
IyAuL3NjcmlwdHMvY2hlY2twYXRjaC5wbCAtLXN0cmljdCAvdG1wLzAwMDEtbmV0LWhzci1hZGQt
c3VwcG9ydC1mb3ItRW50cnlGb3JnZXRUaW1lLnBhdGNoDQp0b3RhbDogMCBlcnJvcnMsIDAgd2Fy
bmluZ3MsIDAgY2hlY2tzLCAzOCBsaW5lcyBjaGVja2VkDQoNCi90bXAvMDAwMS1uZXQtaHNyLWFk
ZC1zdXBwb3J0LWZvci1FbnRyeUZvcmdldFRpbWUucGF0Y2ggaGFzIG5vIG9idmlvdXMgc3R5bGUg
cHJvYmxlbXMgYW5kIGlzIHJlYWR5IGZvciBzdWJtaXNzaW9uLg0KDQoNClJlZ2FyZHMsDQpNYXJj
byBXZW56ZWwNCg==
