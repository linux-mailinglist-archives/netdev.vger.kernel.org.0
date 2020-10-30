Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29B29FB97
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgJ3Cqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:46:33 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33845 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJ3CqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:46:08 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09U2jb7lB019635, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09U2jb7lB019635
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Oct 2020 10:45:37 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 30 Oct 2020 10:45:36 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Fri, 30 Oct 2020 10:45:36 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: phy: realtek: Add phy ids for RTL8226-CG/RTL8226B-CG
Thread-Topic: [PATCH net-next 1/2] net: phy: realtek: Add phy ids for
 RTL8226-CG/RTL8226B-CG
Thread-Index: AQHWrew33+tlrfM0Wk2blDLfQG+RIamuD3mAgAAC/wCAAV3roA==
Date:   Fri, 30 Oct 2020 02:45:36 +0000
Message-ID: <e00771ccacb648b6a00b914e0421b080@realtek.com>
References: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
 <20201029133759.GQ933237@lunn.ch>
 <2cca91c7-99eb-3109-9958-c3db43a43a9b@gmail.com>
In-Reply-To: <2cca91c7-99eb-3109-9958-c3db43a43a9b@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.179.131]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBPY3QgMjksIDIwMjAgMjE6NDksIEhlaW5lciBIYWxsd2VpdCB3cm90ZToNCj4gT24g
MjkuMTAuMjAyMCAxNDozNywgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4gT24gVGh1LCBPY3QgMjks
IDIwMjAgYXQgMDg6MDc6NTdQTSArMDgwMCwgV2lsbHkgTGl1IHdyb3RlOg0KPiA+PiBSZWFsdGVr
IHNpbmdsZS1wb3J0IDIuNUdicHMgRXRoZXJuZXQgUEhZIGlkcyBhcyBiZWxvdzoNCj4gPj4gUlRM
ODIyNi1DRzogMHgwMDFjYzgwMChFUykvMHgwMDFjYzgzOChNUCkNCj4gPj4gUlRMODIyNkItQ0cv
UlRMODIyMUItQ0c6IDB4MDAxY2M4NDAoRVMpLzB4MDAxY2M4NDgoTVApDQo+ID4+IEVTOiBlbmdp
bmVlciBzYW1wbGUNCj4gPj4gTVA6IG1hc3MgcHJvZHVjdGlvbg0KPiA+Pg0KPiA+PiBTaW5jZSBh
Ym92ZSBQSFlzIGFyZSBhbHJlYWR5IGluIG1hc3MgcHJvZHVjdGlvbiBzdGFnZSwgbWFzcw0KPiA+
PiBwcm9kdWN0aW9uIGlkIHNob3VsZCBiZSBhZGRlZC4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1i
eTogV2lsbHkgTGl1IDx3aWxseS5saXVAcmVhbHRlay5jb20+DQo+ID4+IC0tLQ0KPiA+PiAgZHJp
dmVycy9uZXQvcGh5L3JlYWx0ZWsuYyB8IDE4ICsrKysrKysrKysrKysrLS0tLQ0KPiA+PiAgMSBm
aWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pICBtb2RlIGNoYW5n
ZSAxMDA2NDQNCj4gPj4gPT4gMTAwNzU1IGRyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMNCj4gPj4N
Cj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMgYi9kcml2ZXJzL25l
dC9waHkvcmVhbHRlay5jDQo+ID4+IG9sZCBtb2RlIDEwMDY0NCBuZXcgbW9kZSAxMDA3NTUgaW5k
ZXggZmIxZGI3MS4uOTg4ZjA3NQ0KPiA+PiAtLS0gYS9kcml2ZXJzL25ldC9waHkvcmVhbHRlay5j
DQo+ID4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMNCj4gPj4gQEAgLTU3LDYgKzU3
LDkgQEANCj4gPj4gICNkZWZpbmUgUlRMR0VOX1NQRUVEX01BU0sJCQkweDA2MzANCj4gPj4NCj4g
Pj4gICNkZWZpbmUgUlRMX0dFTkVSSUNfUEhZSUQJCQkweDAwMWNjODAwDQo+ID4+ICsjZGVmaW5l
IFJUTF84MjI2X01QX1BIWUlECQkJMHgwMDFjYzgzOA0KPiA+PiArI2RlZmluZSBSVExfODIyMUJf
RVNfUEhZSUQJCQkweDAwMWNjODQwDQo+ID4+ICsjZGVmaW5lIFJUTF84MjIxQl9NUF9QSFlJRAkJ
CTB4MDAxY2M4NDgNCj4gPj4NCj4gPj4gIE1PRFVMRV9ERVNDUklQVElPTigiUmVhbHRlayBQSFkg
ZHJpdmVyIik7DQo+IE1PRFVMRV9BVVRIT1IoIkpvaG5zb24NCj4gPj4gTGV1bmciKTsgQEAgLTUz
MywxMCArNTM2LDE3IEBAIHN0YXRpYyBpbnQNCj4gPj4gcnRsZ2VuX21hdGNoX3BoeV9kZXZpY2Uo
c3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPj4NCj4gPj4gIHN0YXRpYyBpbnQgcnRsODIy
Nl9tYXRjaF9waHlfZGV2aWNlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpICB7DQo+ID4+IC0J
cmV0dXJuIHBoeWRldi0+cGh5X2lkID09IFJUTF9HRU5FUklDX1BIWUlEICYmDQo+ID4+ICsJcmV0
dXJuIChwaHlkZXYtPnBoeV9pZCA9PSBSVExfR0VORVJJQ19QSFlJRCkgfHwNCj4gPj4gKwkgICAg
ICAgKHBoeWRldi0+cGh5X2lkID09IFJUTF84MjI2X01QX1BIWUlEKSAmJg0KPiA+PiAgCSAgICAg
ICBydGxnZW5fc3VwcG9ydHNfMl81Z2JwcyhwaHlkZXYpOw0KPiA+DQo+ID4gSGkgV2lsbHkNCj4g
Pg0KPiA+IElmIGkgdW5kZXJzdGFuZCB0aGUgY29kZSBjb3JyZWN0bHksIHRoaXMgbWF0Y2ggZnVu
Y3Rpb24gaXMgdXNlZA0KPiA+IGJlY2F1c2UgdGhlIGVuZ2luZWVyaW5nIHNhbXBsZSBkaWQgbm90
IHVzZSBhIHByb3BlciBJRD8gVGhlIG1hc3MNCj4gPiBwcm9kdWN0aW9uIHBhcnQgZG9lcywgc28g
dGhlcmUgaXMgbm8gbmVlZCB0byBtYWtlIHVzZSBvZiB0aGlzIGhhY2suDQo+ID4gUGxlYXNlIGp1
c3QgbGlzdCBpdCBhcyBhIG5vcm1hbCBQSFkgdXNpbmcgUEhZX0lEX01BVENIX0VYQUNUKCkuDQo+
ID4NCj4gUmlnaHQuIE15IHVuZGVyc3RhbmRpbmc6DQo+IFRoZXNlIFBIWSdzIGV4aXN0IGFzIHN0
YW5kYWxvbmUgY2hpcHMgYW5kIGludGVncmF0ZWQgd2l0aCBSVEw4MTI1IE1BQy4NCj4gSUlSQyBm
b3IgUlRMODEyNUEgdGhlIGludGVncmF0ZWQgUEhZIHJlcG9ydHMgUlRMX0dFTkVSSUNfUEhZSUQs
IHNpbmNlDQo+IFJUTDgxMjVCIGl0IHJlcG9ydHMgdGhlIHNhbWUgUEhZSUQgYXMgdGhlIHN0YW5k
YWxvbmUgbW9kZWwuDQpIaSBBbmRyZXcgJiYgSGVpbmVyLA0KVGhhbmtzIGZvciB5b3VyIGluZm9y
bWF0aW9uLCBJIHdpbGwgY3JlYXRlIGRyaXZlcnMgZm9yIFJUTDgyMjYtQ0cgJiBSVEw4MjIxQi1D
Rw0KYXMgc3RhbmRhbG9uZSBtb2RlbHMuDQogDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUg
ZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
