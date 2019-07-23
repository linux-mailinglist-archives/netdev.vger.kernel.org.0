Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4449F7219A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392139AbfGWVeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:34:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:1738 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfGWVes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 17:34:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 14:34:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="160345835"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2019 14:34:47 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.6]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.65]) with mapi id 14.03.0439.000;
 Tue, 23 Jul 2019 14:34:46 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>
Subject: Re: [PATCH iproute2] etf: make printing of variable JSON friendly
Thread-Topic: [PATCH iproute2] etf: make printing of variable JSON friendly
Thread-Index: AQHVPnqjzjEUTHyXSkOLocBekrLjQ6bXbP6AgAAexoCAAELvgIABZpMA
Date:   Tue, 23 Jul 2019 21:34:46 +0000
Message-ID: <8BC34CA3-C500-4188-BDBA-4B2B7E9F1EE2@intel.com>
References: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
 <a7c60706-562a-429d-400f-af2ad1606ba3@gmail.com>
 <98A741A5-EAC0-408F-84C2-34E4714A2097@intel.com>
 <0e5fc2fe-dc83-b876-40ac-3b6f3f47bb29@gmail.com>
In-Reply-To: <0e5fc2fe-dc83-b876-40ac-3b6f3f47bb29@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.171]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB5685E615122A4DA9CEE635BDB58091@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVsIDIyLCAyMDE5LCBhdCA1OjExIFBNLCBEYXZpZCBBaGVybiA8ZHNhaGVybkBn
bWFpbC5jb20+IHdyb3RlOg0KPiANCj4gT24gNy8yMi8xOSAxOjExIFBNLCBQYXRlbCwgVmVkYW5n
IHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBKdWwgMjIsIDIwMTksIGF0IDExOjIxIEFNLCBEYXZp
ZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIDcvMTkvMTkg
Mzo0MCBQTSwgVmVkYW5nIFBhdGVsIHdyb3RlOg0KPj4+PiBJbiBpcHJvdXRlMiB0eHRpbWUtYXNz
aXN0IHNlcmllcywgaXQgd2FzIHBvaW50ZWQgb3V0IHRoYXQgcHJpbnRfYm9vbCgpDQo+Pj4+IHNo
b3VsZCBiZSB1c2VkIHRvIHByaW50IGJpbmFyeSB2YWx1ZXMuIFRoaXMgaXMgdG8gbWFrZSBpdCBK
U09OIGZyaWVuZGx5Lg0KPj4+PiANCj4+Pj4gU28sIG1ha2UgdGhlIGNvcnJlc3BvbmRpbmcgY2hh
bmdlcyBpbiBFVEYuDQo+Pj4+IA0KPj4+PiBGaXhlczogOGNjZDQ5MzgzY2RjICgiZXRmOiBBZGQg
c2tpcF9zb2NrX2NoZWNrIikNCj4+Pj4gUmVwb3J0ZWQtYnk6IFN0ZXBoZW4gSGVtbWluZ2VyIDxz
dGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZz4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogVmVkYW5nIFBh
dGVsIDx2ZWRhbmcucGF0ZWxAaW50ZWwuY29tPg0KPj4+PiAtLS0NCj4+Pj4gdGMvcV9ldGYuYyB8
IDEyICsrKysrKy0tLS0tLQ0KPj4+PiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2
IGRlbGV0aW9ucygtKQ0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBhL3RjL3FfZXRmLmMgYi90Yy9x
X2V0Zi5jDQo+Pj4+IGluZGV4IGMyMDkwNTg5YmM2NC4uMzA3YzUwZWVkNDhiIDEwMDY0NA0KPj4+
PiAtLS0gYS90Yy9xX2V0Zi5jDQo+Pj4+ICsrKyBiL3RjL3FfZXRmLmMNCj4+Pj4gQEAgLTE3Niwx
MiArMTc2LDEyIEBAIHN0YXRpYyBpbnQgZXRmX3ByaW50X29wdChzdHJ1Y3QgcWRpc2NfdXRpbCAq
cXUsIEZJTEUgKmYsIHN0cnVjdCBydGF0dHIgKm9wdCkNCj4+Pj4gCQkgICAgIGdldF9jbG9ja19u
YW1lKHFvcHQtPmNsb2NraWQpKTsNCj4+Pj4gDQo+Pj4+IAlwcmludF91aW50KFBSSU5UX0FOWSwg
ImRlbHRhIiwgImRlbHRhICVkICIsIHFvcHQtPmRlbHRhKTsNCj4+Pj4gLQlwcmludF9zdHJpbmco
UFJJTlRfQU5ZLCAib2ZmbG9hZCIsICJvZmZsb2FkICVzICIsDQo+Pj4+IC0JCQkJKHFvcHQtPmZs
YWdzICYgVENfRVRGX09GRkxPQURfT04pID8gIm9uIiA6ICJvZmYiKTsNCj4+Pj4gLQlwcmludF9z
dHJpbmcoUFJJTlRfQU5ZLCAiZGVhZGxpbmVfbW9kZSIsICJkZWFkbGluZV9tb2RlICVzICIsDQo+
Pj4+IC0JCQkJKHFvcHQtPmZsYWdzICYgVENfRVRGX0RFQURMSU5FX01PREVfT04pID8gIm9uIiA6
ICJvZmYiKTsNCj4+Pj4gLQlwcmludF9zdHJpbmcoUFJJTlRfQU5ZLCAic2tpcF9zb2NrX2NoZWNr
IiwgInNraXBfc29ja19jaGVjayAlcyIsDQo+Pj4+IC0JCQkJKHFvcHQtPmZsYWdzICYgVENfRVRG
X1NLSVBfU09DS19DSEVDSykgPyAib24iIDogIm9mZiIpOw0KPj4+PiArCWlmIChxb3B0LT5mbGFn
cyAmIFRDX0VURl9PRkZMT0FEX09OKQ0KPj4+PiArCQlwcmludF9ib29sKFBSSU5UX0FOWSwgIm9m
ZmxvYWQiLCAib2ZmbG9hZCAiLCB0cnVlKTsNCj4+Pj4gKwlpZiAocW9wdC0+ZmxhZ3MgJiBUQ19F
VEZfREVBRExJTkVfTU9ERV9PTikNCj4+Pj4gKwkJcHJpbnRfYm9vbChQUklOVF9BTlksICJkZWFk
bGluZV9tb2RlIiwgImRlYWRsaW5lX21vZGUgIiwgdHJ1ZSk7DQo+Pj4+ICsJaWYgKHFvcHQtPmZs
YWdzICYgVENfRVRGX1NLSVBfU09DS19DSEVDSykNCj4+Pj4gKwkJcHJpbnRfYm9vbChQUklOVF9B
TlksICJza2lwX3NvY2tfY2hlY2siLCAic2tpcF9zb2NrX2NoZWNrIiwgdHJ1ZSk7DQo+Pj4+IA0K
Pj4+PiAJcmV0dXJuIDA7DQo+Pj4+IH0NCj4+Pj4gDQo+Pj4gDQo+Pj4gVGhpcyBjaGFuZ2VzIGV4
aXN0aW5nIG91dHB1dCBmb3IgVENfRVRGX09GRkxPQURfT04gYW5kDQo+Pj4gVENfRVRGX0RFQURM
SU5FX01PREVfT04gd2hpY2ggd2VyZSBhZGRlZCBhIHllYXIgYWdvLg0KPj4gWWVzLCB0aGlzIGlz
IGEgZ29vZCBwb2ludC4gSSBtaXNzZWQgdGhhdC4gDQo+PiANCj4+IEFub3RoZXIgaWRlYSBpcyB0
byB1c2UgaXNfanNvbl9jb250ZXh0KCkgYW5kIGNhbGwgcHJpbnRfYm9vbCgpIHRoZXJlLiBCdXQs
IHRoYXQgd2lsbCBzdGlsbCBjaGFuZ2UgdmFsdWVzIGNvcnJlc3BvbmRpbmcgdG8gdGhlIGpzb24g
b3V0cHV0IGZvciB0aGUgYWJvdmUgZmxhZ3MgZnJvbSDigJxvbuKAnS/igJxvZmbigJ0gdG8g4oCc
dHJ1ZeKAnS/igJxmYWxzZeKAnS4gSSBhbSBub3Qgc3VyZSBpZiB0aGlzIGlzIGEgYmlnIGlzc3Vl
LiANCj4+IA0KPj4gTXkgc3VnZ2VzdGlvbiBpcyB0byBrZWVwIHRoZSBjb2RlIGFzIGlzLiB3aGF0
IGRvIHlvdSB0aGluaz8NCj4+IA0KPiANCj4gSSB0aGluayB3ZSBuZWVkIGF1dG9tYXRlZCBjaGVj
a2VycyBmb3IgbmV3IGNvZGUuIDstKQ0KPiANCj4gVGhlIGZpcnN0IDIgc2hvdWxkIG5vdCBjaGFu
Z2UgZm9yIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgLSB1bmxlc3MgdGhlcmUNCj4gaXMgYWdyZWVt
ZW50IHRoYXQgdGhpcyBmZWF0dXJlIGlzIHRvbyBuZXcgYW5kIGxvbmcgdGVybSBpdCBpcyBiZXR0
ZXIgdG8NCj4gcHJpbnQgYXMgYWJvdmUuDQo+IA0KPiBUaGVuIHRoZSBuZXcgb25lIHNob3VsZCBm
b2xsb3cgY29udGV4dCBvZiB0aGUgb3RoZXIgMiAtIGNvbnNpc3RlbmN5IElNSE8NCj4gdGFrZXMg
cHJlY2VkZW5jZS4NClRoYW5rcyBmb3IgdGhlIGlucHV0cy4gDQoNCkxldOKAmXMga2VlcCB3aGF0
ZXZlciBpcyBjdXJyZW50bHkgcHJlc2VudCB1cHN0cmVhbSBhbmQgeW91IGNhbiBpZ25vcmUgdGhp
cyBwYXRjaC4NCg0KVGhhbmtzLA0KVmVkYW5n
