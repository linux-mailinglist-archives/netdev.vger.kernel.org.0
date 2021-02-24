Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65EF3239ED
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 10:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhBXJwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 04:52:36 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:57999 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234665AbhBXJwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 04:52:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id EEC10380754
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 10:51:25 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eTp9mrLrk6EM for <netdev@vger.kernel.org>;
        Wed, 24 Feb 2021 10:51:24 +0100 (CET)
Received: from gateway.a-eberle.de (unknown [178.15.155.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "sg310.eberle.local", Issuer "A. Eberle GmbH & Co. KG WebAdmin CA" (not verified))
        (Authenticated sender: postmaster@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 10:51:20 +0100 (CET)
Received: from exch-svr2013.eberle.local ([192.168.1.9]:13001 helo=webmail.a-eberle.de)
        by gateway.a-eberle.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Marco.Wenzel@a-eberle.de>)
        id 1lEqpC-00039C-0Z; Wed, 24 Feb 2021 10:51:18 +0100
Received: from EXCH-SVR2013.eberle.local (192.168.1.9) by
 EXCH-SVR2013.eberle.local (192.168.1.9) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 24 Feb 2021 10:51:18 +0100
Received: from EXCH-SVR2013.eberle.local ([::1]) by EXCH-SVR2013.eberle.local
 ([::1]) with mapi id 15.00.1497.006; Wed, 24 Feb 2021 10:51:18 +0100
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
Thread-Index: AdcJH/L4Q6FEZBm4TV2s8U5pq4hbzQAElkYAAFf1INA=
Date:   Wed, 24 Feb 2021 09:51:18 +0000
Message-ID: <1373fd943aa346dabe33508e18e43ed9@EXCH-SVR2013.eberle.local>
References: <d79b32d366ca49aca7821cb0b0edf52b@EXCH-SVR2013.eberle.local>
 <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
In-Reply-To: <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.242.2.55]
x-kse-serverinfo: EXCH-SVR2013.eberle.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 24.02.2021 07:03:00
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBGZWIgMjIsIDIwMjEgYXQgNTo0OSBQTSA6IEdlb3JnZSBNY0NvbGxpc3RlciA8Z2Vv
cmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIEZlYiAyMiwg
MjAyMSBhdCA3OjM4IEFNIFdlbnplbCwgTWFyY28gPE1hcmNvLldlbnplbEBhLQ0KPiBlYmVybGUu
ZGU+IHdyb3RlOg0KPiA+DQo+ID4gT24gRnJpLCBGZWIgMTksIDIwMjEgYXQgMjoxNCBQTSA6IEdl
b3JnZSBNY0NvbGxpc3Rlcg0KPiA8Z2VvcmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbT4gd3JvdGU6
DQo+ID4gPg0KPiA+ID4gT24gRnJpLCBGZWIgMTksIDIwMjEgYXQgMjoyNyBBTSBXZW56ZWwsIE1h
cmNvIDxNYXJjby5XZW56ZWxAYS0NCj4gPiA+IGViZXJsZS5kZT4gd3JvdGU6DQo+ID4gPiA+DQo+
ID4gPiA+IE9uIFRodSwgRmViIDE4LCAyMDIxIGF0IDY6MDYgUE0gOiBHZW9yZ2UgTWNDb2xsaXN0
ZXINCj4gPiA+IDxnZW9yZ2UubWNjb2xsaXN0ZXJAZ21haWwuY29tPiB3cm90ZToNCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+IE9uIFRodSwgRmViIDE4LCAyMDIxIGF0IDk6MDEgQU0gTWFyY28gV2VuemVs
IDxtYXJjby53ZW56ZWxAYS0NCj4gPiA+ID4gPiBlYmVybGUuZGU+IHdyb3RlOg0KPiA+ID4gPiA+
ID4NCj4gPiA+ID4gPiA+IEluIElFQyA2MjQzOS0zIEVudHJ5Rm9yZ2V0VGltZSBpcyBkZWZpbmVk
IHdpdGggYSB2YWx1ZSBvZiA0MDAgbXMuDQo+ID4gPiA+ID4gPiBXaGVuIGEgbm9kZSBkb2VzIG5v
dCBzZW5kIGFueSBmcmFtZSB3aXRoaW4gdGhpcyB0aW1lLCB0aGUNCj4gPiA+ID4gPiA+IHNlcXVl
bmNlIG51bWJlciBjaGVjayBmb3IgY2FuIGJlIGlnbm9yZWQuIFRoaXMgc29sdmVzDQo+ID4gPiA+
ID4gPiBjb21tdW5pY2F0aW9uIGlzc3VlcyB3aXRoIENpc2NvIElFIDIwMDAgaW4gUmVkYm94IG1v
ZGUuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gRml4ZXM6IGY0MjE0MzZhNTkxZCAoIm5ldC9o
c3I6IEFkZCBzdXBwb3J0IGZvciB0aGUNCj4gPiA+ID4gPiA+IEhpZ2gtYXZhaWxhYmlsaXR5IFNl
YW1sZXNzIFJlZHVuZGFuY3kgcHJvdG9jb2wgKEhTUnYwKSIpDQo+ID4gPiA+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBNYXJjbyBXZW56ZWwgPG1hcmNvLndlbnplbEBhLWViZXJsZS5kZT4NCj4gPiA+ID4g
PiA+IC0tLQ0KPiA+ID4gPiA+ID4gIG5ldC9oc3IvaHNyX2ZyYW1lcmVnLmMgfCA5ICsrKysrKyst
LSAgbmV0L2hzci9oc3JfZnJhbWVyZWcuaA0KPiA+ID4gPiA+ID4gfCAxDQo+ID4gPiA+ID4gPiAr
DQo+ID4gPiA+ID4gPiAgbmV0L2hzci9oc3JfbWFpbi5oICAgICB8IDEgKw0KPiA+ID4gPiA+ID4g
IDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+ID4g
PiA+ID4NCj4gPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9uZXQvaHNyL2hzcl9mcmFtZXJlZy5jIGIv
bmV0L2hzci9oc3JfZnJhbWVyZWcuYw0KPiA+ID4gPiA+ID4gaW5kZXgNCj4gPiA+ID4gPiA+IDVj
OTdkZTQ1OTkwNS4uODA1Zjk3NDkyM2I5IDEwMDY0NA0KPiA+ID4gPiA+ID4gLS0tIGEvbmV0L2hz
ci9oc3JfZnJhbWVyZWcuYw0KPiA+ID4gPiA+ID4gKysrIGIvbmV0L2hzci9oc3JfZnJhbWVyZWcu
Yw0KPiA+ID4gPiA+ID4gQEAgLTE2NCw4ICsxNjQsMTAgQEAgc3RhdGljIHN0cnVjdCBoc3Jfbm9k
ZQ0KPiA+ID4gPiA+ID4gKmhzcl9hZGRfbm9kZShzdHJ1Y3QNCj4gPiA+ID4gPiBoc3JfcHJpdiAq
aHNyLA0KPiA+ID4gPiA+ID4gICAgICAgICAgKiBhcyBpbml0aWFsaXphdGlvbi4gKDAgY291bGQg
dHJpZ2dlciBhbiBzcHVyaW91cyByaW5nIGVycm9yDQo+IHdhcm5pbmcpLg0KPiA+ID4gPiA+ID4g
ICAgICAgICAgKi8NCj4gPiA+ID4gPiA+ICAgICAgICAgbm93ID0gamlmZmllczsNCj4gPiA+ID4g
PiA+IC0gICAgICAgZm9yIChpID0gMDsgaSA8IEhTUl9QVF9QT1JUUzsgaSsrKQ0KPiA+ID4gPiA+
ID4gKyAgICAgICBmb3IgKGkgPSAwOyBpIDwgSFNSX1BUX1BPUlRTOyBpKyspIHsNCj4gPiA+ID4g
PiA+ICAgICAgICAgICAgICAgICBuZXdfbm9kZS0+dGltZV9pbltpXSA9IG5vdzsNCj4gPiA+ID4g
PiA+ICsgICAgICAgICAgICAgICBuZXdfbm9kZS0+dGltZV9vdXRbaV0gPSBub3c7DQo+ID4gPiA+
ID4gPiArICAgICAgIH0NCj4gPiA+ID4gPiA+ICAgICAgICAgZm9yIChpID0gMDsgaSA8IEhTUl9Q
VF9QT1JUUzsgaSsrKQ0KPiA+ID4gPiA+ID4gICAgICAgICAgICAgICAgIG5ld19ub2RlLT5zZXFf
b3V0W2ldID0gc2VxX291dDsNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBAQCAtNDExLDkgKzQx
MywxMiBAQCB2b2lkIGhzcl9yZWdpc3Rlcl9mcmFtZV9pbihzdHJ1Y3QNCj4gPiA+ID4gPiA+IGhz
cl9ub2RlDQo+ID4gPiA+ID4gKm5vZGUsDQo+ID4gPiA+ID4gPiBzdHJ1Y3QgaHNyX3BvcnQgKnBv
cnQsICBpbnQgaHNyX3JlZ2lzdGVyX2ZyYW1lX291dChzdHJ1Y3QNCj4gPiA+ID4gPiA+IGhzcl9w
b3J0ICpwb3J0LA0KPiA+ID4gPiA+IHN0cnVjdCBoc3Jfbm9kZSAqbm9kZSwNCj4gPiA+ID4gPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUxNiBzZXF1ZW5jZV9ucikgIHsNCj4gPiA+ID4g
PiA+IC0gICAgICAgaWYgKHNlcV9ucl9iZWZvcmVfb3JfZXEoc2VxdWVuY2VfbnIsIG5vZGUtPnNl
cV9vdXRbcG9ydC0NCj4gPiA+ID50eXBlXSkpDQo+ID4gPiA+ID4gPiArICAgICAgIGlmIChzZXFf
bnJfYmVmb3JlX29yX2VxKHNlcXVlbmNlX25yLA0KPiA+ID4gPiA+ID4gKyBub2RlLT5zZXFfb3V0
W3BvcnQtPnR5cGVdKQ0KPiA+ID4gPiA+ICYmDQo+ID4gPiA+ID4gPiArICAgICAgICAgICB0aW1l
X2lzX2FmdGVyX2ppZmZpZXMobm9kZS0+dGltZV9vdXRbcG9ydC0+dHlwZV0gKw0KPiA+ID4gPiA+
ID4gKyAgICAgICAgICAgbXNlY3NfdG9famlmZmllcyhIU1JfRU5UUllfRk9SR0VUX1RJTUUpKSkN
Cj4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiArICAgICAgIG5vZGUtPnRpbWVfb3V0W3BvcnQtPnR5cGVdID0gamlmZmllczsNCj4g
PiA+ID4gPiA+ICAgICAgICAgbm9kZS0+c2VxX291dFtwb3J0LT50eXBlXSA9IHNlcXVlbmNlX25y
Ow0KPiA+ID4gPiA+ID4gICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gPiA+ICB9DQo+ID4gPiA+
ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L2hzci9oc3JfZnJhbWVyZWcuaCBiL25ldC9oc3IvaHNyX2Zy
YW1lcmVnLmgNCj4gPiA+ID4gPiA+IGluZGV4DQo+ID4gPiA+ID4gPiA4NmI0M2Y1MzlmMmMuLmQ5
NjI4ZTdhNWYwNSAxMDA2NDQNCj4gPiA+ID4gPiA+IC0tLSBhL25ldC9oc3IvaHNyX2ZyYW1lcmVn
LmgNCj4gPiA+ID4gPiA+ICsrKyBiL25ldC9oc3IvaHNyX2ZyYW1lcmVnLmgNCj4gPiA+ID4gPiA+
IEBAIC03NSw2ICs3NSw3IEBAIHN0cnVjdCBoc3Jfbm9kZSB7DQo+ID4gPiA+ID4gPiAgICAgICAg
IGVudW0gaHNyX3BvcnRfdHlwZSAgICAgIGFkZHJfQl9wb3J0Ow0KPiA+ID4gPiA+ID4gICAgICAg
ICB1bnNpZ25lZCBsb25nICAgICAgICAgICB0aW1lX2luW0hTUl9QVF9QT1JUU107DQo+ID4gPiA+
ID4gPiAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgIHRpbWVfaW5fc3RhbGVbSFNSX1BU
X1BPUlRTXTsNCj4gPiA+ID4gPiA+ICsgICAgICAgdW5zaWduZWQgbG9uZyAgICAgICAgICAgdGlt
ZV9vdXRbSFNSX1BUX1BPUlRTXTsNCj4gPiA+ID4gPiA+ICAgICAgICAgLyogaWYgdGhlIG5vZGUg
aXMgYSBTQU4gKi8NCj4gPiA+ID4gPiA+ICAgICAgICAgYm9vbCAgICAgICAgICAgICAgICAgICAg
c2FuX2E7DQo+ID4gPiA+ID4gPiAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgIHNhbl9i
Ow0KPiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9oc3IvaHNyX21haW4uaCBiL25ldC9oc3Iv
aHNyX21haW4uaCBpbmRleA0KPiA+ID4gPiA+ID4gN2RjOTJjZTVhMTM0Li5mNzljYTU1ZDY5ODYg
MTAwNjQ0DQo+ID4gPiA+ID4gPiAtLS0gYS9uZXQvaHNyL2hzcl9tYWluLmgNCj4gPiA+ID4gPiA+
ICsrKyBiL25ldC9oc3IvaHNyX21haW4uaA0KPiA+ID4gPiA+ID4gQEAgLTIxLDYgKzIxLDcgQEAN
Cj4gPiA+ID4gPiA+ICAjZGVmaW5lIEhTUl9MSUZFX0NIRUNLX0lOVEVSVkFMICAgICAgICAgICAg
ICAgICAyMDAwIC8qIG1zICovDQo+ID4gPiA+ID4gPiAgI2RlZmluZSBIU1JfTk9ERV9GT1JHRVRf
VElNRSAgICAgICAgICAgNjAwMDAgLyogbXMgKi8NCj4gPiA+ID4gPiA+ICAjZGVmaW5lIEhTUl9B
Tk5PVU5DRV9JTlRFUlZBTCAgICAgICAgICAgIDEwMCAvKiBtcyAqLw0KPiA+ID4gPiA+ID4gKyNk
ZWZpbmUgSFNSX0VOVFJZX0ZPUkdFVF9USU1FICAgICAgICAgICAgNDAwIC8qIG1zICovDQo+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gIC8qIEJ5IGhvdyBtdWNoIG1heSBzbGF2ZTEgYW5kIHNsYXZl
MiB0aW1lc3RhbXBzIG9mIGxhdGVzdA0KPiA+ID4gPiA+ID4gcmVjZWl2ZWQNCj4gPiA+ID4gPiBm
cmFtZSBmcm9tDQo+ID4gPiA+ID4gPiAgICogZWFjaCBub2RlIGRpZmZlciBiZWZvcmUgd2Ugbm90
aWZ5IG9mIGNvbW11bmljYXRpb24gcHJvYmxlbT8NCj4gPiA+ID4gPiA+IC0tDQo+ID4gPiA+ID4g
PiAyLjMwLjANCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBzY3JpcHRzL2NoZWNr
cGF0Y2gucGwgZ2l2ZXMgZXJyb3JzIGFib3V0IERPUyBsaW5lIGVuZGluZ3MgYnV0DQo+ID4gPiA+
ID4gb25jZSB0aGF0IGlzIHJlc29sdmVkIHRoaXMgbG9va3MgZ29vZC4gSSB0ZXN0ZWQgaXQgb24g
YW4gSFNSDQo+ID4gPiA+ID4gbmV0d29yayB3aXRoIHRoZSBzb2Z0d2FyZSBpbXBsZW1lbnRhdGlv
biBhbmQgdGhlIHhyczcwMHggd2hpY2gNCj4gPiA+ID4gPiB1c2VzIG9mZmxvYWRpbmcgYW5kIGV2
ZXJ5dGhpbmcgc3RpbGwgd29ya3MuIEkgZG9uJ3QgaGF2ZSBhIHdheQ0KPiA+ID4gPiA+IHRvIGZv
cmNlIGFueXRoaW5nIG9uIHRoZSBIU1IgbmV0d29yayB0byByZXVzZSBzZXF1ZW5jZSBudW1iZXJz
DQo+IGFmdGVyIDQwMG1zLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gUmV2aWV3ZWQtYnk6IEdlb3Jn
ZSBNY0NvbGxpc3RlciA8Z2VvcmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbQ0KPiA+ID4gPiA+IFRl
c3RlZC1ieTogR2VvcmdlIE1jQ29sbGlzdGVyIDxnZW9yZ2UubWNjb2xsaXN0ZXJAZ21haWwuY29t
DQo+ID4gPiA+DQo+ID4gPiA+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHJldmlld2luZywgdGVz
dGluZyBhbmQgc3VwcG9ydGluZyENCj4gPiA+ID4NCj4gPiA+ID4gV2hlcmUgZG8geW91IHNlZSB0
aGUgaW5jb3JyZWN0IGxpbmUgZW5kaW5ncz8gSSBqdXN0IHJhbg0KPiA+ID4gPiBzY3JpcHRzL2No
ZWNrcGF0aC5wbA0KPiA+ID4gYXMgZ2l0IGNvbW1pdCBob29rIGFuZCBpdCBkaWQgbm90IHJlcG9y
dCBhbnkgZXJyb3JzLiBXaGVuIEkgcnVuIGl0DQo+ID4gPiBhZ2FpbiBtYW51YWxseSwgaXQgYWxz
byBkb2VzIG5vdCByZXBvcnQgYW55IGVycm9yczoNCj4gPiA+ID4NCj4gPiA+ID4gIyAuL3Njcmlw
dHMvY2hlY2twYXRjaC5wbCAtLXN0cmljdA0KPiA+ID4gPiAvdG1wLzAwMDEtbmV0LWhzci1hZGQt
c3VwcG9ydC1mb3ItRW50cnlGb3JnZXRUaW1lLnBhdGNoDQo+ID4gPiA+IHRvdGFsOiAwIGVycm9y
cywgMCB3YXJuaW5ncywgMCBjaGVja3MsIDM4IGxpbmVzIGNoZWNrZWQNCj4gPiA+ID4NCj4gPiA+
ID4gL3RtcC8wMDAxLW5ldC1oc3ItYWRkLXN1cHBvcnQtZm9yLUVudHJ5Rm9yZ2V0VGltZS5wYXRj
aCBoYXMgbm8NCj4gPiA+ID4gb2J2aW91cw0KPiA+ID4gc3R5bGUgcHJvYmxlbXMgYW5kIGlzIHJl
YWR5IGZvciBzdWJtaXNzaW9uLg0KPiA+ID4NCj4gPiA+IFNvcnJ5IGFib3V0IHRoaXMuIEl0IHNl
ZW1zIHdoZW4gSSBkb3dubG9hZGVkIHRoZSBwYXRjaCB3aXRoIENocm9taXVtDQo+ID4gPiBmcm9t
IGdtYWlsIGluIExpbnV4IGl0IGFkZGVkIERPUyBuZXcgbGluZXMgKHRoaXMgaXMgdW5leHBlY3Rl
ZCkuDQo+ID4gPiBXaGVuIEkgZG93bmxvYWRlZCBpdCBmcm9tIGxvcmUua2VybmVsLm9yZyBpdCdz
IGZpbmUuDQo+ID4gPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IEdlb3JnZSBNY0NvbGxpc3RlciA8Z2Vv
cmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbT4NCj4gPiA+IFRlc3RlZC1ieTogR2VvcmdlIE1jQ29s
bGlzdGVyIDxnZW9yZ2UubWNjb2xsaXN0ZXJAZ21haWwuY29tPg0KPiA+ID4NCj4gPg0KPiA+IFRo
YW5rIHlvdSBmb3IgcmV2aWV3aW5nIGFnYWluISBJcyB0aGVyZSBhbnkgb3BlcmF0aW9uIG5lZWRl
ZCBmcm9tIG15IHNpZGUNCj4gaW4gb3JkZXIgdG8gb2ZmaWNpYWxseSBhcHBseSB0aGlzIHBhdGNo
Pw0KPiANCj4gTG9va3MgbGlrZSB0aGUgcGF0Y2ggaXMgc2hvd2luZyBhcyBkZWZlcnJlZCBpbiBw
YXRjaHdvcmsgYmVjYXVzZSBpdCdzIG5vdA0KPiB0YXJnZXRpbmcgZWl0aGVyIG5ldCBvciBuZXQt
bmV4dC4NCj4gDQo+IEZyb20gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvRG9jdW1lbnRhdGlv
bi9uZXR3b3JraW5nL25ldGRldi0NCj4gRkFRLnR4dA0KPiAgIFRoZXJlIGFyZSBhbHdheXMgdHdv
IHRyZWVzIChnaXQgcmVwb3NpdG9yaWVzKSBpbiBwbGF5LiBCb3RoIGFyZSBkcml2ZW4NCj4gICAg
YnkgRGF2aWQgTWlsbGVyLCB0aGUgbWFpbiBuZXR3b3JrIG1haW50YWluZXIuICBUaGVyZSBpcyB0
aGUgIm5ldCIgdHJlZSwNCj4gICAgYW5kIHRoZSAibmV0LW5leHQiIHRyZWUuICBBcyB5b3UgY2Fu
IHByb2JhYmx5IGd1ZXNzIGZyb20gdGhlIG5hbWVzLCB0aGUNCj4gICAgbmV0IHRyZWUgaXMgZm9y
IGZpeGVzIHRvIGV4aXN0aW5nIGNvZGUgYWxyZWFkeSBpbiB0aGUgbWFpbmxpbmUgdHJlZSBmcm9t
DQo+ICAgIExpbnVzLCBhbmQgbmV0LW5leHQgaXMgd2hlcmUgdGhlIG5ldyBjb2RlIGdvZXMgZm9y
IHRoZSBmdXR1cmUgcmVsZWFzZS4NCj4gICAgWW91IGNhbiBmaW5kIHRoZSB0cmVlcyBoZXJlOg0K
PiANCj4gICAgICAgICBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9kYXZlbS9uZXQuZ2l0DQo+ICAgICAgICAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0LW5leHQuZ2l0DQo+IA0KPiBZb3UgbXVzdCBk
ZWNpZGUgaWYgeW91IHdhbnQgdG8gc2VuZCBpdCBmb3IgbmV0IG9yIG5ldC1uZXh0LiBJZiB5b3Ug
d2FudCB0bw0KPiBzZW5kIGl0IGZvciBuZXQtbmV4dCB5b3UgbXVzdCB3YWl0IExpbnVzIGhhcyBj
bG9zZWQgdGhlIG1lcmdlIHdpbmRvdyBhbmQNCj4gdGhpcyBzaG93cyBvcGVuOg0KPiBodHRwOi8v
dmdlci5rZXJuZWwub3JnL35kYXZlbS9uZXQtbmV4dC5odG1sDQo+IA0KPiBUbyBzZW5kIGZvciBu
ZXQgdXNlIHRoZSBzdWJqZWN0IHByZWZpeCAiW1BBVENIIG5ldF0iLg0KPiBUbyBzZW5kIGZvciBu
ZXQtbmV4dCB1c2UgdGhlIHN1YmplY3QgcHJlZml4ICJbUEFUQ0ggbmV0LW5leHRdIi4NCj4gDQo+
IElmIHlvdSdyZSB1c2luZyBnaXQgZm9ybWF0LXBhdGNoIHlvdSBjYW4gdXNlIHRoZSBmb2xsb3dp
bmc6DQo+IGdpdCBmb3JtYXQtcGF0Y2ggLS1zdWJqZWN0LXByZWZpeD0nUEFUQ0ggbmV0LW5leHQn
DQo+IA0KPiBJZiB5b3UncmUganVzdCB1c2luZyBnaXQgc2VuZC1lbWFpbCB5b3UgY2FuIHVzZSB0
aGUgLS1hbm5vdGF0ZSBvcHRpb24gdG8gZWRpdA0KPiB0aGUgcGF0Y2ggc3ViamVjdCBtYW51YWxs
eS4NCj4gDQo+IFRoYW5rcyBhbmQgc29ycnkgZm9yIG5vdCBtZW50aW9uaW5nIHRoaXMgYmVmb3Jl
LCBHZW9yZ2UgTWNDb2xsaXN0ZXINCg0KVGhhbmtzIGFnYWluIGZvciB0aGUgdmVyeSBoZWxwZnVs
IGhpbnRzLiBJIGhvcGUgdGhlIHBhdGNoIHdpbGwgYmUgY29ycmVjdCBub3cuDQoNCj4gPg0KPiA+
ID4gPg0KPiA+ID4gPiBSZWdhcmRzLA0KPiA+ID4gPiBNYXJjbyBXZW56ZWwNCg==
