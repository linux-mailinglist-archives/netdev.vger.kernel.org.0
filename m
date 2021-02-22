Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1032192D
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhBVNlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 08:41:21 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:42649 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhBVNjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 08:39:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id 05A8A38021A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 14:38:14 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wk2WO9zlrreD for <netdev@vger.kernel.org>;
        Mon, 22 Feb 2021 14:38:12 +0100 (CET)
Received: from gateway.a-eberle.de (unknown [178.15.155.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "sg310.eberle.local", Issuer "A. Eberle GmbH & Co. KG WebAdmin CA" (not verified))
        (Authenticated sender: postmaster@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 14:38:10 +0100 (CET)
Received: from exch-svr2013.eberle.local ([192.168.1.9]:39960 helo=webmail.a-eberle.de)
        by gateway.a-eberle.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Marco.Wenzel@a-eberle.de>)
        id 1lEBPb-0006hh-0U; Mon, 22 Feb 2021 14:38:07 +0100
Received: from EXCH-SVR2013.eberle.local (192.168.1.9) by
 EXCH-SVR2013.eberle.local (192.168.1.9) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 22 Feb 2021 14:38:07 +0100
Received: from EXCH-SVR2013.eberle.local ([::1]) by EXCH-SVR2013.eberle.local
 ([::1]) with mapi id 15.00.1497.006; Mon, 22 Feb 2021 14:38:07 +0100
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
Subject: Re: [PATCH] net: hsr: add support for EntryForgetTime
Thread-Topic: [PATCH] net: hsr: add support for EntryForgetTime
Thread-Index: AdcJH/L4Q6FEZBm4TV2s8U5pq4hbzQ==
Date:   Mon, 22 Feb 2021 13:38:06 +0000
Message-ID: <d79b32d366ca49aca7821cb0b0edf52b@EXCH-SVR2013.eberle.local>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.242.2.55]
x-kse-serverinfo: EXCH-SVR2013.eberle.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 22.02.2021 08:57:00
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMTksIDIwMjEgYXQgMjoxNCBQTSA6IEdlb3JnZSBNY0NvbGxpc3RlciA8Z2Vv
cmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIEZlYiAxOSwg
MjAyMSBhdCAyOjI3IEFNIFdlbnplbCwgTWFyY28gPE1hcmNvLldlbnplbEBhLQ0KPiBlYmVybGUu
ZGU+IHdyb3RlOg0KPiA+DQo+ID4gT24gVGh1LCBGZWIgMTgsIDIwMjEgYXQgNjowNiBQTSA6IEdl
b3JnZSBNY0NvbGxpc3Rlcg0KPiA8Z2VvcmdlLm1jY29sbGlzdGVyQGdtYWlsLmNvbT4gd3JvdGU6
DQo+ID4gPg0KPiA+ID4gT24gVGh1LCBGZWIgMTgsIDIwMjEgYXQgOTowMSBBTSBNYXJjbyBXZW56
ZWwgPG1hcmNvLndlbnplbEBhLQ0KPiA+ID4gZWJlcmxlLmRlPiB3cm90ZToNCj4gPiA+ID4NCj4g
PiA+ID4gSW4gSUVDIDYyNDM5LTMgRW50cnlGb3JnZXRUaW1lIGlzIGRlZmluZWQgd2l0aCBhIHZh
bHVlIG9mIDQwMCBtcy4NCj4gPiA+ID4gV2hlbiBhIG5vZGUgZG9lcyBub3Qgc2VuZCBhbnkgZnJh
bWUgd2l0aGluIHRoaXMgdGltZSwgdGhlIHNlcXVlbmNlDQo+ID4gPiA+IG51bWJlciBjaGVjayBm
b3IgY2FuIGJlIGlnbm9yZWQuIFRoaXMgc29sdmVzIGNvbW11bmljYXRpb24gaXNzdWVzDQo+ID4g
PiA+IHdpdGggQ2lzY28gSUUgMjAwMCBpbiBSZWRib3ggbW9kZS4NCj4gPiA+ID4NCj4gPiA+ID4g
Rml4ZXM6IGY0MjE0MzZhNTkxZCAoIm5ldC9oc3I6IEFkZCBzdXBwb3J0IGZvciB0aGUNCj4gPiA+
ID4gSGlnaC1hdmFpbGFiaWxpdHkgU2VhbWxlc3MgUmVkdW5kYW5jeSBwcm90b2NvbCAoSFNSdjAp
IikNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFyY28gV2VuemVsIDxtYXJjby53ZW56ZWxAYS1l
YmVybGUuZGU+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgbmV0L2hzci9oc3JfZnJhbWVyZWcuYyB8
IDkgKysrKysrKy0tICBuZXQvaHNyL2hzcl9mcmFtZXJlZy5oIHwgMQ0KPiA+ID4gPiArDQo+ID4g
PiA+ICBuZXQvaHNyL2hzcl9tYWluLmggICAgIHwgMSArDQo+ID4gPiA+ICAzIGZpbGVzIGNoYW5n
ZWQsIDkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+ID4NCj4gPiA+ID4gZGlm
ZiAtLWdpdCBhL25ldC9oc3IvaHNyX2ZyYW1lcmVnLmMgYi9uZXQvaHNyL2hzcl9mcmFtZXJlZy5j
IGluZGV4DQo+ID4gPiA+IDVjOTdkZTQ1OTkwNS4uODA1Zjk3NDkyM2I5IDEwMDY0NA0KPiA+ID4g
PiAtLS0gYS9uZXQvaHNyL2hzcl9mcmFtZXJlZy5jDQo+ID4gPiA+ICsrKyBiL25ldC9oc3IvaHNy
X2ZyYW1lcmVnLmMNCj4gPiA+ID4gQEAgLTE2NCw4ICsxNjQsMTAgQEAgc3RhdGljIHN0cnVjdCBo
c3Jfbm9kZSAqaHNyX2FkZF9ub2RlKHN0cnVjdA0KPiA+ID4gaHNyX3ByaXYgKmhzciwNCj4gPiA+
ID4gICAgICAgICAgKiBhcyBpbml0aWFsaXphdGlvbi4gKDAgY291bGQgdHJpZ2dlciBhbiBzcHVy
aW91cyByaW5nIGVycm9yIHdhcm5pbmcpLg0KPiA+ID4gPiAgICAgICAgICAqLw0KPiA+ID4gPiAg
ICAgICAgIG5vdyA9IGppZmZpZXM7DQo+ID4gPiA+IC0gICAgICAgZm9yIChpID0gMDsgaSA8IEhT
Ul9QVF9QT1JUUzsgaSsrKQ0KPiA+ID4gPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBIU1JfUFRf
UE9SVFM7IGkrKykgew0KPiA+ID4gPiAgICAgICAgICAgICAgICAgbmV3X25vZGUtPnRpbWVfaW5b
aV0gPSBub3c7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICBuZXdfbm9kZS0+dGltZV9vdXRbaV0g
PSBub3c7DQo+ID4gPiA+ICsgICAgICAgfQ0KPiA+ID4gPiAgICAgICAgIGZvciAoaSA9IDA7IGkg
PCBIU1JfUFRfUE9SVFM7IGkrKykNCj4gPiA+ID4gICAgICAgICAgICAgICAgIG5ld19ub2RlLT5z
ZXFfb3V0W2ldID0gc2VxX291dDsNCj4gPiA+ID4NCj4gPiA+ID4gQEAgLTQxMSw5ICs0MTMsMTIg
QEAgdm9pZCBoc3JfcmVnaXN0ZXJfZnJhbWVfaW4oc3RydWN0IGhzcl9ub2RlDQo+ID4gPiAqbm9k
ZSwNCj4gPiA+ID4gc3RydWN0IGhzcl9wb3J0ICpwb3J0LCAgaW50IGhzcl9yZWdpc3Rlcl9mcmFt
ZV9vdXQoc3RydWN0IGhzcl9wb3J0DQo+ID4gPiA+ICpwb3J0LA0KPiA+ID4gc3RydWN0IGhzcl9u
b2RlICpub2RlLA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICB1MTYgc2VxdWVu
Y2VfbnIpICB7DQo+ID4gPiA+IC0gICAgICAgaWYgKHNlcV9ucl9iZWZvcmVfb3JfZXEoc2VxdWVu
Y2VfbnIsIG5vZGUtPnNlcV9vdXRbcG9ydC0NCj4gPnR5cGVdKSkNCj4gPiA+ID4gKyAgICAgICBp
ZiAoc2VxX25yX2JlZm9yZV9vcl9lcShzZXF1ZW5jZV9uciwNCj4gPiA+ID4gKyBub2RlLT5zZXFf
b3V0W3BvcnQtPnR5cGVdKQ0KPiA+ID4gJiYNCj4gPiA+ID4gKyAgICAgICAgICAgdGltZV9pc19h
ZnRlcl9qaWZmaWVzKG5vZGUtPnRpbWVfb3V0W3BvcnQtPnR5cGVdICsNCj4gPiA+ID4gKyAgICAg
ICAgICAgbXNlY3NfdG9famlmZmllcyhIU1JfRU5UUllfRk9SR0VUX1RJTUUpKSkNCj4gPiA+ID4g
ICAgICAgICAgICAgICAgIHJldHVybiAxOw0KPiA+ID4gPg0KPiA+ID4gPiArICAgICAgIG5vZGUt
PnRpbWVfb3V0W3BvcnQtPnR5cGVdID0gamlmZmllczsNCj4gPiA+ID4gICAgICAgICBub2RlLT5z
ZXFfb3V0W3BvcnQtPnR5cGVdID0gc2VxdWVuY2VfbnI7DQo+ID4gPiA+ICAgICAgICAgcmV0dXJu
IDA7DQo+ID4gPiA+ICB9DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9uZXQvaHNyL2hzcl9mcmFtZXJl
Zy5oIGIvbmV0L2hzci9oc3JfZnJhbWVyZWcuaCBpbmRleA0KPiA+ID4gPiA4NmI0M2Y1MzlmMmMu
LmQ5NjI4ZTdhNWYwNSAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvbmV0L2hzci9oc3JfZnJhbWVyZWcu
aA0KPiA+ID4gPiArKysgYi9uZXQvaHNyL2hzcl9mcmFtZXJlZy5oDQo+ID4gPiA+IEBAIC03NSw2
ICs3NSw3IEBAIHN0cnVjdCBoc3Jfbm9kZSB7DQo+ID4gPiA+ICAgICAgICAgZW51bSBoc3JfcG9y
dF90eXBlICAgICAgYWRkcl9CX3BvcnQ7DQo+ID4gPiA+ICAgICAgICAgdW5zaWduZWQgbG9uZyAg
ICAgICAgICAgdGltZV9pbltIU1JfUFRfUE9SVFNdOw0KPiA+ID4gPiAgICAgICAgIGJvb2wgICAg
ICAgICAgICAgICAgICAgIHRpbWVfaW5fc3RhbGVbSFNSX1BUX1BPUlRTXTsNCj4gPiA+ID4gKyAg
ICAgICB1bnNpZ25lZCBsb25nICAgICAgICAgICB0aW1lX291dFtIU1JfUFRfUE9SVFNdOw0KPiA+
ID4gPiAgICAgICAgIC8qIGlmIHRoZSBub2RlIGlzIGEgU0FOICovDQo+ID4gPiA+ICAgICAgICAg
Ym9vbCAgICAgICAgICAgICAgICAgICAgc2FuX2E7DQo+ID4gPiA+ICAgICAgICAgYm9vbCAgICAg
ICAgICAgICAgICAgICAgc2FuX2I7DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9uZXQvaHNyL2hzcl9t
YWluLmggYi9uZXQvaHNyL2hzcl9tYWluLmggaW5kZXgNCj4gPiA+ID4gN2RjOTJjZTVhMTM0Li5m
NzljYTU1ZDY5ODYgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL25ldC9oc3IvaHNyX21haW4uaA0KPiA+
ID4gPiArKysgYi9uZXQvaHNyL2hzcl9tYWluLmgNCj4gPiA+ID4gQEAgLTIxLDYgKzIxLDcgQEAN
Cj4gPiA+ID4gICNkZWZpbmUgSFNSX0xJRkVfQ0hFQ0tfSU5URVJWQUwgICAgICAgICAgICAgICAg
IDIwMDAgLyogbXMgKi8NCj4gPiA+ID4gICNkZWZpbmUgSFNSX05PREVfRk9SR0VUX1RJTUUgICAg
ICAgICAgIDYwMDAwIC8qIG1zICovDQo+ID4gPiA+ICAjZGVmaW5lIEhTUl9BTk5PVU5DRV9JTlRF
UlZBTCAgICAgICAgICAgIDEwMCAvKiBtcyAqLw0KPiA+ID4gPiArI2RlZmluZSBIU1JfRU5UUllf
Rk9SR0VUX1RJTUUgICAgICAgICAgICA0MDAgLyogbXMgKi8NCj4gPiA+ID4NCj4gPiA+ID4gIC8q
IEJ5IGhvdyBtdWNoIG1heSBzbGF2ZTEgYW5kIHNsYXZlMiB0aW1lc3RhbXBzIG9mIGxhdGVzdA0K
PiA+ID4gPiByZWNlaXZlZA0KPiA+ID4gZnJhbWUgZnJvbQ0KPiA+ID4gPiAgICogZWFjaCBub2Rl
IGRpZmZlciBiZWZvcmUgd2Ugbm90aWZ5IG9mIGNvbW11bmljYXRpb24gcHJvYmxlbT8NCj4gPiA+
ID4gLS0NCj4gPiA+ID4gMi4zMC4wDQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gc2NyaXB0cy9jaGVj
a3BhdGNoLnBsIGdpdmVzIGVycm9ycyBhYm91dCBET1MgbGluZSBlbmRpbmdzIGJ1dCBvbmNlDQo+
ID4gPiB0aGF0IGlzIHJlc29sdmVkIHRoaXMgbG9va3MgZ29vZC4gSSB0ZXN0ZWQgaXQgb24gYW4g
SFNSIG5ldHdvcmsgd2l0aA0KPiA+ID4gdGhlIHNvZnR3YXJlIGltcGxlbWVudGF0aW9uIGFuZCB0
aGUgeHJzNzAweCB3aGljaCB1c2VzIG9mZmxvYWRpbmcNCj4gPiA+IGFuZCBldmVyeXRoaW5nIHN0
aWxsIHdvcmtzLiBJIGRvbid0IGhhdmUgYSB3YXkgdG8gZm9yY2UgYW55dGhpbmcgb24NCj4gPiA+
IHRoZSBIU1IgbmV0d29yayB0byByZXVzZSBzZXF1ZW5jZSBudW1iZXJzIGFmdGVyIDQwMG1zLg0K
PiA+ID4NCj4gPiA+IFJldmlld2VkLWJ5OiBHZW9yZ2UgTWNDb2xsaXN0ZXIgPGdlb3JnZS5tY2Nv
bGxpc3RlckBnbWFpbC5jb20NCj4gPiA+IFRlc3RlZC1ieTogR2VvcmdlIE1jQ29sbGlzdGVyIDxn
ZW9yZ2UubWNjb2xsaXN0ZXJAZ21haWwuY29tDQo+ID4NCj4gPiBUaGFuayB5b3UgdmVyeSBtdWNo
IGZvciByZXZpZXdpbmcsIHRlc3RpbmcgYW5kIHN1cHBvcnRpbmchDQo+ID4NCj4gPiBXaGVyZSBk
byB5b3Ugc2VlIHRoZSBpbmNvcnJlY3QgbGluZSBlbmRpbmdzPyBJIGp1c3QgcmFuIHNjcmlwdHMv
Y2hlY2twYXRoLnBsDQo+IGFzIGdpdCBjb21taXQgaG9vayBhbmQgaXQgZGlkIG5vdCByZXBvcnQg
YW55IGVycm9ycy4gV2hlbiBJIHJ1biBpdCBhZ2Fpbg0KPiBtYW51YWxseSwgaXQgYWxzbyBkb2Vz
IG5vdCByZXBvcnQgYW55IGVycm9yczoNCj4gPg0KPiA+ICMgLi9zY3JpcHRzL2NoZWNrcGF0Y2gu
cGwgLS1zdHJpY3QNCj4gPiAvdG1wLzAwMDEtbmV0LWhzci1hZGQtc3VwcG9ydC1mb3ItRW50cnlG
b3JnZXRUaW1lLnBhdGNoDQo+ID4gdG90YWw6IDAgZXJyb3JzLCAwIHdhcm5pbmdzLCAwIGNoZWNr
cywgMzggbGluZXMgY2hlY2tlZA0KPiA+DQo+ID4gL3RtcC8wMDAxLW5ldC1oc3ItYWRkLXN1cHBv
cnQtZm9yLUVudHJ5Rm9yZ2V0VGltZS5wYXRjaCBoYXMgbm8gb2J2aW91cw0KPiBzdHlsZSBwcm9i
bGVtcyBhbmQgaXMgcmVhZHkgZm9yIHN1Ym1pc3Npb24uDQo+IA0KPiBTb3JyeSBhYm91dCB0aGlz
LiBJdCBzZWVtcyB3aGVuIEkgZG93bmxvYWRlZCB0aGUgcGF0Y2ggd2l0aCBDaHJvbWl1bQ0KPiBm
cm9tIGdtYWlsIGluIExpbnV4IGl0IGFkZGVkIERPUyBuZXcgbGluZXMgKHRoaXMgaXMgdW5leHBl
Y3RlZCkuIFdoZW4gSQ0KPiBkb3dubG9hZGVkIGl0IGZyb20gbG9yZS5rZXJuZWwub3JnIGl0J3Mg
ZmluZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBHZW9yZ2UgTWNDb2xsaXN0ZXIgPGdlb3JnZS5tY2Nv
bGxpc3RlckBnbWFpbC5jb20+DQo+IFRlc3RlZC1ieTogR2VvcmdlIE1jQ29sbGlzdGVyIDxnZW9y
Z2UubWNjb2xsaXN0ZXJAZ21haWwuY29tPg0KPiANCg0KVGhhbmsgeW91IGZvciByZXZpZXdpbmcg
YWdhaW4hIElzIHRoZXJlIGFueSBvcGVyYXRpb24gbmVlZGVkIGZyb20gbXkgc2lkZSBpbiBvcmRl
ciB0byBvZmZpY2lhbGx5IGFwcGx5IHRoaXMgcGF0Y2g/DQoNCj4gPg0KPiA+IFJlZ2FyZHMsDQo+
ID4gTWFyY28gV2VuemVsDQo=
