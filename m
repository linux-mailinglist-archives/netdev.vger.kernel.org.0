Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE892C03C3
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgKWK7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:59:35 -0500
Received: from mx22.baidu.com ([220.181.50.185]:47344 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727918AbgKWK7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 05:59:34 -0500
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 05:59:30 EST
Received: from BC-Mail-Ex32.internal.baidu.com (unknown [172.31.51.26])
        by Forcepoint Email with ESMTPS id 0C44FF776B0F2FFAFFD2;
        Mon, 23 Nov 2020 18:43:09 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex32.internal.baidu.com (172.31.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2044.4; Mon, 23 Nov 2020 18:43:08 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.1979.006; Mon, 23 Nov 2020 18:43:08 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: RE: [PATCH] libbpf: add support for canceling cached_cons advance
Thread-Topic: [PATCH] libbpf: add support for canceling cached_cons advance
Thread-Index: AQHWwXynm8QoWfKpDkGCKHIPRpnFnqnVhyuQ
Date:   Mon, 23 Nov 2020 10:43:08 +0000
Message-ID: <e2431932144f4f298044e5a4aebd59c2@baidu.com>
References: <1606050623-22963-1-git-send-email-lirongqing@baidu.com>
 <CAJ8uoz3d4x9pWWNxmd9+ozt7ei7WUE=S=FnKE1sLZOqoKRwMJQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz3d4x9pWWNxmd9+ozt7ei7WUE=S=FnKE1sLZOqoKRwMJQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.23]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFnbnVzIEthcmxzc29u
IFttYWlsdG86bWFnbnVzLmthcmxzc29uQGdtYWlsLmNvbV0NCj4gU2VudDogTW9uZGF5LCBOb3Zl
bWJlciAyMywgMjAyMCA1OjQwIFBNDQo+IFRvOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlk
dS5jb20+DQo+IENjOiBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5rZXJuZWwub3Jn
PjsgYnBmDQo+IDxicGZAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBs
aWJicGY6IGFkZCBzdXBwb3J0IGZvciBjYW5jZWxpbmcgY2FjaGVkX2NvbnMgYWR2YW5jZQ0KPiAN
Cj4gT24gU3VuLCBOb3YgMjIsIDIwMjAgYXQgMjoyMSBQTSBMaSBSb25nUWluZyA8bGlyb25ncWlu
Z0BiYWlkdS5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSXQgaXMgcG9zc2libGUgdG8gZmFpbCByZWNl
aXZpbmcgcGFja2V0cyBhZnRlciBjYWxsaW5nDQo+ID4geHNrX3JpbmdfY29uc19fcGVlaywgYXQg
dGhpcyBjb25kaXRpb24sIGNhY2hlZF9jb25zIGhhcyBiZWVuIGFkdmFuY2VkLA0KPiA+IHNob3Vs
ZCBiZSBjYW5jZWxsZWQuDQo+IA0KPiBUaGFua3MgUm9uZ1FpbmcsDQo+IA0KPiBJIGhhdmUgbmVl
ZGVkIHRoaXMgbXlzZWxmIGluIHZhcmlvdXMgc2l0dWF0aW9ucywgc28gSSB0aGluayB3ZSBzaG91
bGQgYWRkIHRoaXMuDQo+IEJ1dCB5b3VyIG1vdGl2YXRpb24gaW4gdGhlIGNvbW1pdCBtZXNzYWdl
IGlzIHNvbWV3aGF0IGNvbmZ1c2luZy4gSG93IGFib3V0DQo+IHNvbWV0aGluZyBsaWtlIHRoaXM/
DQo+IA0KPiBBZGQgYSBuZXcgZnVuY3Rpb24gZm9yIHJldHVybmluZyBkZXNjcmlwdG9ycyB0aGUg
dXNlciByZWNlaXZlZCBhZnRlciBhbg0KPiB4c2tfcmluZ19jb25zX19wZWVrIGNhbGwuIEFmdGVy
IHRoZSBhcHBsaWNhdGlvbiBoYXMgZ290dGVuIGEgbnVtYmVyIG9mDQo+IGRlc2NyaXB0b3JzIGZy
b20gYSByaW5nLCBpdCBtaWdodCBub3QgYmUgYWJsZSB0byBvciB3YW50IHRvIHByb2Nlc3MgdGhl
bSBhbGwgZm9yDQo+IHZhcmlvdXMgcmVhc29ucy4gVGhlcmVmb3JlLCBpdCB3b3VsZCBiZSB1c2Vm
dWwgdG8gaGF2ZSBhbiBpbnRlcmZhY2UgZm9yIHJldHVybmluZw0KPiBvciBjYW5jZWxsaW5nIGEg
bnVtYmVyIG9mIHRoZW0gc28gdGhhdCB0aGV5IGFyZSByZXR1cm5lZCB0byB0aGUgcmluZy4gVGhp
cyBwYXRjaA0KPiBhZGRzIGEgbmV3IGZ1bmN0aW9uIGNhbGxlZCB4c2tfcmluZ19jb25zX19jYW5j
ZWwgdGhhdCBwZXJmb3JtcyB0aGlzIG9wZXJhdGlvbg0KPiBvbiBuYiBkZXNjcmlwdG9ycyBjb3Vu
dGVkIGZyb20gdGhlIGVuZCBvZiB0aGUgYmF0Y2ggb2YgZGVzY3JpcHRvcnMgdGhhdCB3YXMNCj4g
cmVjZWl2ZWQgdGhyb3VnaCB0aGUgcGVlayBjYWxsLg0KPiANCj4gUmVwbGFjZSB5b3VyIGNvbW1p
dCBtZXNzYWdlIHdpdGggdGhpcywgZml4IHRoZSBidWcgYmVsb3csIHNlbmQgYSB2MiBhbmQgdGhl
biBJDQo+IGFtIGhhcHB5IHRvIGFjayB0aGlzLg0KDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2gNCj4g
DQo+IC9NYWdudXMNCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3Fp
bmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+ICB0b29scy9saWIvYnBmL3hzay5oIHwgNiArKysr
KysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL3Rvb2xzL2xpYi9icGYveHNrLmggYi90b29scy9saWIvYnBmL3hzay5oIGluZGV4DQo+
ID4gMTA2OWM0NjM2NGZmLi40MTI4MjE1YzI0NmIgMTAwNjQ0DQo+ID4gLS0tIGEvdG9vbHMvbGli
L2JwZi94c2suaA0KPiA+ICsrKyBiL3Rvb2xzL2xpYi9icGYveHNrLmgNCj4gPiBAQCAtMTUzLDYg
KzE1MywxMiBAQCBzdGF0aWMgaW5saW5lIHNpemVfdCB4c2tfcmluZ19jb25zX19wZWVrKHN0cnVj
dA0KPiB4c2tfcmluZ19jb25zICpjb25zLA0KPiA+ICAgICAgICAgcmV0dXJuIGVudHJpZXM7DQo+
ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW5saW5lIHZvaWQgeHNrX3JpbmdfY29uc19fY2FuY2Vs
KHN0cnVjdCB4c2tfcmluZ19jb25zICpjb25zLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgc2l6ZV90IG5iKSB7DQo+ID4gKyAgICAgICByeC0+Y2FjaGVkX2Nv
bnMgLT0gbmI7DQo+IA0KPiBjb25zLT4gbm90IHJ4LT4uIFBsZWFzZSBtYWtlIHN1cmUgdGhlIHYy
IGNvbXBpbGVzIGFuZCBwYXNzZXMgY2hlY2twYXRjaC4NCj4gDQoNClNvcnJ5IGZvciBidWlsZGlu
ZyBlcnJvcg0KSSB3aWxsIHNlbmQgVjINCg0KVGhhbmtzIA0KDQotTGkNCg0KDQo+ID4gK30NCj4g
PiArDQo+ID4gIHN0YXRpYyBpbmxpbmUgdm9pZCB4c2tfcmluZ19jb25zX19yZWxlYXNlKHN0cnVj
dCB4c2tfcmluZ19jb25zICpjb25zLA0KPiA+IHNpemVfdCBuYikgIHsNCj4gPiAgICAgICAgIC8q
IE1ha2Ugc3VyZSBkYXRhIGhhcyBiZWVuIHJlYWQgYmVmb3JlIGluZGljYXRpbmcgd2UgYXJlIGRv
bmUNCj4gPiAtLQ0KPiA+IDIuMTcuMw0KPiA+DQo=
