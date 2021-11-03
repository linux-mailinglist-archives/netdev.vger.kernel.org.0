Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60DB44445E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhKCPOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:14:00 -0400
Received: from mswedge2.sunplus.com ([60.248.182.106]:52450 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230384AbhKCPN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 11:13:59 -0400
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(53149:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Wed, 03 Nov 2021 23:11:07 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Wed, 3 Nov 2021 23:11:02 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Wed, 3 Nov 2021
 23:11:02 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxMBgAgACng+A=
Date:   Wed, 3 Nov 2021 15:11:02 +0000
Message-ID: <084249630536437997a58d32ea61bd38@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
         <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <430b152167a1fdfb5ca66f1db702759f36d0ed56.camel@pengutronix.de>
In-Reply-To: <430b152167a1fdfb5ca66f1db702759f36d0ed56.camel@pengutronix.de>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGEgbG90IGZvciB5b3VyIHJldmlldy4NCg0KPiBGcm9tOiBQaGlsaXBwIFphYmVsIDxw
LnphYmVsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDMsIDIw
MjEgODoxMCBQTQ0KPiBUbzogV2VsbHMgTHUgPHdlbGxzbHV0d0BnbWFpbC5jb20+OyBkYXZlbUBk
YXZlbWxvZnQubmV0Ow0KPiBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IFdlbGxzIEx1IOWRguiKs+mosCA8d2VsbHMu
bHVAc3VucGx1cy5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSBuZXQ6IGV0aGVybmV0
OiBBZGQgZHJpdmVyIGZvciBTdW5wbHVzIFNQNzAyMQ0KPiANCj4gT24gV2VkLCAyMDIxLTExLTAz
IGF0IDE5OjAyICswODAwLCBXZWxscyBMdSB3cm90ZToNCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VucGx1cy9sMnN3X2RyaXZlci5jDQo+ID4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zdW5wbHVzL2wyc3dfZHJpdmVyLmMNCj4gPiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLjNkZmQwZGQNCj4gPiAtLS0gL2Rldi9udWxsDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VucGx1cy9sMnN3X2RyaXZlci5jDQo+ID4g
QEAgLTAsMCArMSw3NzkgQEANCj4gWy4uLl0NCj4gPiArc3RhdGljIGludCBsMnN3X3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpIHsNCj4gPiArCXN0cnVjdCBsMnN3X2NvbW1vbiAq
Y29tbTsNCj4gPiArCXN0cnVjdCByZXNvdXJjZSAqcl9tZW07DQo+ID4gKwlzdHJ1Y3QgbmV0X2Rl
dmljZSAqbmV0X2RldiwgKm5ldF9kZXYyOw0KPiA+ICsJc3RydWN0IGwyc3dfbWFjICptYWMsICpt
YWMyOw0KPiA+ICsJdTMyIG1vZGU7DQo+ID4gKwlpbnQgcmV0ID0gMDsNCj4gPiArCWludCByYzsN
Cj4gPiArDQo+ID4gKwlpZiAocGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldikpDQo+ID4gKwkJcmV0
dXJuIC1FTk9ERVY7DQo+ID4gKw0KPiA+ICsJLy8gQWxsb2NhdGUgbWVtb3J5IGZvciBsMnN3ICdj
b21tb24nIGFyZWEuDQo+ID4gKwljb21tID0ga21hbGxvYyhzaXplb2YoKmNvbW0pLCBHRlBfS0VS
TkVMKTsNCj4gDQo+IEknZCB1c2UgZGV2bV9remFsbG9jKCkgaGVyZSBmb3IgaW5pdGlhbGl6YXRp
b24gYW5kIHRvIHNpbXBsaWZ5IHRoZSBjbGVhbnVwDQo+IHBhdGguDQoNCkknbGwgcmVwbGFjZSBr
bWFsbG9jKCkgd2l0aCBkZXZtX2t6YWxsb2MoKSBhbmQgcmVtb3ZlIHRoZSBrZnJlZSguLi4pIGlu
DQpjbGVhbnVwIHBhdGggKHBsYXRmb3JtIHJlbW92ZSkgaW4gUEFUQ0ggdjIuDQoNCj4gPiArCWlm
ICghY29tbSkNCj4gPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gPiArCXByX2RlYnVnKCIgY29tbSA9
ICVwXG4iLCBjb21tKTsNCj4gDQo+IFdoYXQgaXMgdGhpcyB1c2VmdWwgZm9yPw0KDQoncHJfZGVi
dWcoIiBjb21tID0gJXBcbiIsIGNvbW0pOycgaXMgZm9yIGVhcmx5LXN0YWdlIGRlYnVnLg0KSSds
bCByZW1vdmUgdGhlIGxpbmUgaW4gUEFUQ0ggdjIuDQoNCj4gPiArCW1lbXNldChjb21tLCAnXDAn
LCBzaXplb2Yoc3RydWN0IGwyc3dfY29tbW9uKSk7DQo+IA0KPiBOb3QgbmVlZGVkIHdpdGgga3ph
bGxvYywgU2VlIGFib3ZlLg0KDQpZZXMsIEknbGwgcmVtb3ZlIHRoZSBsaW5lICdtZW1zZXQoLi4u
KTsnIGFzIGRldm1fa3phbGxvYygpIHdpbGwgYmUgdXNlZCBpbiBQQVRDSCB2Mi4NCg0KPiBbLi4u
XQ0KPiA+ICsJLy8gR2V0IG1lbW9yeSByZXNvcnVjZSAwIGZyb20gZHRzLg0KPiA+ICsJcl9tZW0g
PSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9NRU0sIDApOw0KPiA+ICsJ
aWYgKHJfbWVtKSB7DQo+ID4gKwkJcHJfZGVidWcoIiByZXMtPm5hbWUgPSBcIiVzXCIsIHJfbWVt
LT5zdGFydCA9ICVwYVxuIiwNCj4gcl9tZW0tPm5hbWUsICZyX21lbS0+c3RhcnQpOw0KPiA+ICsJ
CWlmIChsMnN3X3JlZ19iYXNlX3NldChkZXZtX2lvcmVtYXAoJnBkZXYtPmRldiwgcl9tZW0tPnN0
YXJ0LA0KPiA+ICsJCQkJCQkgICAocl9tZW0tPmVuZCAtIHJfbWVtLT5zdGFydCArIDEpKSkgIT0g
MCkgew0KPiA+ICsJCQlwcl9lcnIoIiBpb3JlbWFwIGZhaWxlZCFcbiIpOw0KPiA+ICsJCQlyZXQg
PSAtRU5PTUVNOw0KPiA+ICsJCQlnb3RvIG91dF9mcmVlX2NvbW07DQo+ID4gKwkJfQ0KPiA+ICsJ
fSBlbHNlIHsNCj4gPiArCQlwcl9lcnIoIiBObyBNRU0gcmVzb3VyY2UgMCBmb3VuZCFcbiIpOw0K
PiA+ICsJCXJldCA9IC1FTlhJTzsNCj4gPiArCQlnb3RvIG91dF9mcmVlX2NvbW07DQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJLy8gR2V0IG1lbW9yeSByZXNvcnVjZSAxIGZyb20gZHRzLg0KPiA+ICsJ
cl9tZW0gPSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9NRU0sIDEpOw0K
PiA+ICsJaWYgKHJfbWVtKSB7DQo+ID4gKwkJcHJfZGVidWcoIiByZXMtPm5hbWUgPSBcIiVzXCIs
IHJfbWVtLT5zdGFydCA9ICVwYVxuIiwNCj4gcl9tZW0tPm5hbWUsICZyX21lbS0+c3RhcnQpOw0K
PiA+ICsJCWlmIChtb29uNV9yZWdfYmFzZV9zZXQoZGV2bV9pb3JlbWFwKCZwZGV2LT5kZXYsDQo+
IHJfbWVtLT5zdGFydCwNCj4gPiArCQkJCQkJICAgIChyX21lbS0+ZW5kIC0gcl9tZW0tPnN0YXJ0
ICsgMSkpKSAhPSAwKSB7DQo+ID4gKwkJCXByX2VycigiIGlvcmVtYXAgZmFpbGVkIVxuIik7DQo+
ID4gKwkJCXJldCA9IC1FTk9NRU07DQo+ID4gKwkJCWdvdG8gb3V0X2ZyZWVfY29tbTsNCj4gPiAr
CQl9DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCXByX2VycigiIE5vIE1FTSByZXNvdXJjZSAxIGZv
dW5kIVxuIik7DQo+ID4gKwkJcmV0ID0gLUVOWElPOw0KPiA+ICsJCWdvdG8gb3V0X2ZyZWVfY29t
bTsNCj4gPiArCX0NCj4gDQo+IFVzaW5nIGRldm1faW9yZW1hcF9yZXNvdXJjZSgpIHdvdWxkIHNp
bXBsaWZ5IGJvdGggYSBsb3QuDQoNClllcywgSSdsbCByZXBsYWNlIGRldm1faW9yZW1hcCgpIHdp
dGggZGV2bV9pb3JlbWFwX3Jlc291cmNlKCkgaW4gUEFUQ0ggdjIuDQoNCj4gWy4uLl0NCj4gPiAr
CWNvbW0tPnJzdGMgPSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0KCZwZGV2LT5kZXYsIE5VTEwpOw0K
PiANCj4gUGxlYXNlIHVzZSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0X2V4Y2x1c2l2ZSgpLg0KDQpZ
ZXMsIEknbGwgcmVwbGFjZSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0KCkgd2l0aCBkZXZtX3Jlc2V0
X2NvbnRyb2xfZ2V0X2V4Y2x1c2l2ZSgpIGluIFBBVENIIHYyLg0KDQo+ID4gKwlpZiAoSVNfRVJS
KGNvbW0tPnJzdGMpKSB7DQo+ID4gKwkJZGV2X2VycigmcGRldi0+ZGV2LCAiRmFpbGVkIHRvIHJl
dHJpZXZlIHJlc2V0IGNvbnRyb2xsZXIhXG4iKTsNCj4gPiArCQlyZXQgPSBQVFJfRVJSKGNvbW0t
PnJzdGMpOw0KPiA+ICsJCWdvdG8gb3V0X2ZyZWVfY29tbTsNCj4gPiArCX0NCj4gPiArDQo+ID4g
KwkvLyBFbmFibGUgY2xvY2suDQo+ID4gKwljbGtfcHJlcGFyZV9lbmFibGUoY29tbS0+Y2xrKTsN
Cj4gPiArCXVkZWxheSgxKTsNCj4gPiArDQo+ID4gKwlyZXQgPSByZXNldF9jb250cm9sX2Fzc2Vy
dChjb21tLT5yc3RjKTsNCj4gDQo+IE5vIG5lZWQgdG8gYXNzaWduIHRvIHJldCBpZiB5b3UgaWdu
b3JlIGl0IGFueXdheS4NCg0KT2ssIEknbGwgcmVtb3ZlICdyZXQgPScgaW4gUEFUQ0ggdjINCg0K
PiA+ICsJdWRlbGF5KDEpOw0KPiA+ICsJcmV0ID0gcmVzZXRfY29udHJvbF9kZWFzc2VydChjb21t
LT5yc3RjKTsNCj4gPiArCWlmIChyZXQpIHsNCj4gPiArCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJG
YWlsZWQgdG8gZGVhc3NlcnQgcmVzZXQgbGluZSAoZXJyID0gJWQpIVxuIiwNCj4gcmV0KTsNCj4g
PiArCQlyZXQgPSAtRU5PREVWOw0KPiA+ICsJCWdvdG8gb3V0X2ZyZWVfY29tbTsNCj4gPiArCX0N
Cj4gPiArCXVkZWxheSgxKTsNCj4gDQo+IHJlZ2FyZHMNCj4gUGhpbGlwcA0KDQpCZXN0IHJlZ2Fy
ZHMsDQpXZWxscw0K
