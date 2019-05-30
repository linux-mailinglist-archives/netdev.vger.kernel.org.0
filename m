Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109042E9AF
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 02:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfE3AVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 20:21:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:20007 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfE3AVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 20:21:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 17:21:44 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga003.jf.intel.com with ESMTP; 29 May 2019 17:21:44 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.95]) by
 ORSMSX104.amr.corp.intel.com ([169.254.4.200]) with mapi id 14.03.0415.000;
 Wed, 29 May 2019 17:21:44 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>
Subject: Re: [PATCH net-next v1 3/7] taprio: Add the skeleton to enable
 hardware offloading
Thread-Topic: [PATCH net-next v1 3/7] taprio: Add the skeleton to enable
 hardware offloading
Thread-Index: AQHVFX1jRoxwIAipQEiZCaa8URTGlqaBmGAAgAEzxgCAACO+AIAADiQAgAARDwCAADaFAA==
Date:   Thu, 30 May 2019 00:21:39 +0000
Message-ID: <861F87D1-6A0B-438D-BBD5-6A15BDA398F7@intel.com>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
 <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
 <20190528154510.41b50723@cakuba.netronome.com>
 <62E2DD49-AC21-46DE-8E5B-EBC67230FA7D@intel.com>
 <20190529121440.46c40967@cakuba.netronome.com>
 <A9D05E0B-FC24-4904-B3E5-1E069C92A3DA@intel.com>
 <20190529140620.68fa8e64@cakuba.netronome.com>
In-Reply-To: <20190529140620.68fa8e64@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.201]
Content-Type: text/plain; charset="utf-8"
Content-ID: <38194F9CAA7C83408918AA30CA691D40@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWF5IDI5LCAyMDE5LCBhdCAyOjA2IFBNLCBKYWt1YiBLaWNpbnNraSA8amFrdWIu
a2ljaW5za2lAbmV0cm9ub21lLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDI5IE1heSAyMDE5
IDIwOjA1OjE2ICswMDAwLCBQYXRlbCwgVmVkYW5nIHdyb3RlOg0KPj4gW1NlbmRpbmcgdGhlIGVt
YWlsIGFnYWluIHNpbmNlIHRoZSBsYXN0IG9uZSB3YXMgcmVqZWN0ZWQgYnkgbmV0ZGV2IGJlY2F1
c2UgaXQgd2FzIGh0bWwuXQ0KPj4gDQo+Pj4gT24gTWF5IDI5LCAyMDE5LCBhdCAxMjoxNCBQTSwg
SmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+IHdyb3RlOg0KPj4+
IA0KPj4+IE9uIFdlZCwgMjkgTWF5IDIwMTkgMTc6MDY6NDkgKzAwMDAsIFBhdGVsLCBWZWRhbmcg
d3JvdGU6ICANCj4+Pj4+IE9uIE1heSAyOCwgMjAxOSwgYXQgMzo0NSBQTSwgSmFrdWIgS2ljaW5z
a2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+IHdyb3RlOg0KPj4+Pj4gT24gVHVlLCAy
OCBNYXkgMjAxOSAxMDo0Njo0NCAtMDcwMCwgVmVkYW5nIFBhdGVsIHdyb3RlOiAgICANCj4+Pj4+
PiBGcm9tOiBWaW5pY2l1cyBDb3N0YSBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPg0K
Pj4+Pj4+IA0KPj4+Pj4+IFRoaXMgYWRkcyB0aGUgVUFQSSBhbmQgdGhlIGNvcmUgYml0cyBuZWNl
c3NhcnkgZm9yIHVzZXJzcGFjZSB0bw0KPj4+Pj4+IHJlcXVlc3QgaGFyZHdhcmUgb2ZmbG9hZGlu
ZyB0byBiZSBlbmFibGVkLg0KPj4+Pj4+IA0KPj4+Pj4+IFRoZSBmdXR1cmUgY29tbWl0cyB3aWxs
IGVuYWJsZSBoeWJyaWQgb3IgZnVsbCBvZmZsb2FkaW5nIGZvciB0YXByaW8uIFRoaXMNCj4+Pj4+
PiBjb21taXQgc2V0cyB1cCB0aGUgaW5mcmFzdHJ1Y3R1cmUgdG8gZW5hYmxlIGl0IHZpYSB0aGUg
bmV0bGluayBpbnRlcmZhY2UuDQo+Pj4+Pj4gDQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogVmluaWNp
dXMgQ29zdGEgR29tZXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT4NCj4+Pj4+PiBTaWduZWQt
b2ZmLWJ5OiBWZWRhbmcgUGF0ZWwgPHZlZGFuZy5wYXRlbEBpbnRlbC5jb20+ICAgIA0KPj4+Pj4g
DQo+Pj4+PiBPdGhlciBxZGlzY3Mgb2ZmbG9hZCBieSBkZWZhdWx0LCB0aGlzIG9mZmxvYWQtbGV2
ZWwgc2VsZWN0aW9uIGhlcmUgaXMgYQ0KPj4+Pj4gbGl0dGxlIGJpdCBpbmNvbnNpc3RlbnQgd2l0
aCB0aGF0IDooDQo+Pj4+PiANCj4+Pj4gVGhlcmUgYXJlIDIgZGlmZmVyZW50IG9mZmxvYWQgbW9k
ZXMgaW50cm9kdWNlZCBpbiB0aGlzIHBhdGNoLg0KPj4+PiANCj4+Pj4gMS4gVHh0aW1lIG9mZmxv
YWQgbW9kZTogVGhpcyBtb2RlIGRlcGVuZHMgb24gc2tpcF9zb2NrX2NoZWNrIGZsYWcgYmVpbmcg
c2V0IGluIHRoZSBldGYgcWRpc2MuIEFsc28sIGl0IHJlcXVpcmVzIHNvbWUgbWFudWFsIGNvbmZp
Z3VyYXRpb24gd2hpY2ggbWlnaHQgYmUgc3BlY2lmaWMgdG8gdGhlIG5ldHdvcmsgYWRhcHRlciBj
YXJkLiBGb3IgZXhhbXBsZSwgZm9yIHRoZSBpMjEwIGNhcmQsIHRoZSB1c2VyIHdpbGwgaGF2ZSB0
byByb3V0ZSBhbGwgdGhlIHRyYWZmaWMgdG8gdGhlIGhpZ2hlc3QgcHJpb3JpdHkgcXVldWUgYW5k
IGluc3RhbGwgZXRmIHFkaXNjIHdpdGggb2ZmbG9hZCBlbmFibGVkIG9uIHRoYXQgcXVldWUuIFNv
LCBJIGRvbuKAmXQgdGhpbmsgdGhpcyBtb2RlIHNob3VsZCBiZSBlbmFibGVkIGJ5IGRlZmF1bHQu
ICANCj4+PiANCj4+PiBFeGNlbGxlbnQsIGl0IGxvb2tzIGxpa2UgdGhlcmUgd2lsbCBiZSBkcml2
ZXIgcGF0Y2hlcyBuZWNlc3NhcnkgZm9yDQo+Pj4gdGhpcyBvZmZsb2FkIHRvIGZ1bmN0aW9uLCBh
bHNvIGl0IHNlZW1zIHlvdXIgb2ZmbG9hZCBlbmFibGUgZnVuY3Rpb24NCj4+PiBzdGlsbCBjb250
YWlucyB0aGlzIGFmdGVyIHRoZSBzZXJpZXM6DQo+Pj4gDQo+Pj4gCS8qIEZJWE1FOiBlbmFibGUg
b2ZmbG9hZGluZyAqLw0KPj4+IA0KPj4+IFBsZWFzZSBvbmx5IHBvc3Qgb2ZmbG9hZCBpbmZyYXN0
cnVjdHVyZSB3aGVuIGZ1bGx5IGZsZXNoZWQgb3V0IGFuZCB3aXRoDQo+Pj4gZHJpdmVyIHBhdGNo
ZXMgbWFraW5nIHVzZSBvZiBpdC4NCj4+IA0KPj4gVGhlIGFib3ZlIGNvbW1lbnQgcmVmZXJzIHRv
IHRoZSBmdWxsIG9mZmxvYWQgbW9kZSBkZXNjcmliZWQgYmVsb3cuIEl0DQo+PiBpcyBub3QgbmVl
ZGVkIGZvciB0eHRpbWUgb2ZmbG9hZCBtb2RlLiBUeHRpbWUgb2ZmbG9hZCBtb2RlIGlzDQo+PiBl
c3NlbnRpYWxseSBzZXR0aW5nIHRoZSB0cmFuc21pdCB0aW1lIGZvciBlYWNoIHBhY2tldCAgZGVw
ZW5kaW5nIG9uDQo+PiB3aGF0IGludGVydmFsIGl0IGlzIGdvaW5nIHRvIGJlIHRyYW5zbWl0dGVk
IGluc3RlYWQgb2YgcmVseWluZyBvbiB0aGUNCj4+IGhydGltZXJzIHRvIG9wZW4gZ2F0ZXMgYW5k
IHNlbmQgcGFja2V0cy4gTW9yZSBkZXRhaWxzIGFib3V0IHdoeQ0KPj4gZXhhY3RseSB0aGlzIGlz
IGRvbmUgaXMgbWVudGlvbmVkIGluIHBhdGNoICM1WzFdIG9mIHRoaXMgc2VyaWVzLg0KPiANCj4g
RnJvbSBsb29raW5nIGF0IHRoaXMgc2V0IGl0IGxvb2tzIGxpa2UgSSBjYW4gYWRkIHRoYXQgcWRp
c2MgdG8gYW55DQo+IG5ldGRldiBub3cgKndpdGgqIG9mZmxvYWQsIGFuZCBhcyBsb25nIGFzIHRo
ZSBkcml2ZXIgaGFzIF9hbnlfDQo+IG5kb19zZXR1cF90YyBpbXBsZW1lbnRhdGlvbiB0YXByaW8g
d2lsbCBub3QgcmV0dXJuIGFuIGVycm9yLiANCj4gDQo+IFBlcmhhcHMgdGhpcyBtb2RlIG9mIG9w
ZXJhdGlvbiBzaG91bGQgbm90IGJlIGNhbGxlZCBvZmZsb2FkPyAgQ2FuJ3QgDQo+IHRoZSBFVEYg
cWRpc2MgdW5kZXJuZWF0aCBydW4gaW4gc29mdHdhcmUgbW9kZT8NCj4gDQpZZWFoLCBpdCBkb2Vz
buKAmXQgbWFrZSBtdWNoIHNlbnNlIHRvIHJ1biBFVEYgaW4gc29mdHdhcmUgbW9kZSBidXQgaXQg
Y2FuIGJlIGRvbmUuIFdoYXQgYWJvdXQgbmFtaW5nIGl0IHR4dGltZS1hc3Npc3QgaW5zdGVhZD8N
Cj4+IFdoYXQgd2UgY2FuIGRvIGlzIGp1c3QgYWRkIHRoZSB0eHRpbWUgb2ZmbG9hZCByZWxhdGVk
IGZsYWcgYW5kIGFkZA0KPj4gdGhlIGZ1bGwgb2ZmbG9hZCBmbGFnIHdoZW5ldmVyIHRoZSBkcml2
ZXIgYml0cyBhcmUgcmVhZHkuIERvZXMgdGhhdA0KPj4gYWRkcmVzcyB5b3VyIGNvbmNlcm4/DQo+
IA0KPiBUaGF0IHdvdWxkIGJlIGEgc3RlcCBpbiB0aGUgcmlnaHQgZGlyZWN0aW9uLiAgQW5kIHBs
ZWFzZSByZW1vdmUgYWxsIHRoZQ0KPiBvdGhlciB1bnVzZWQgY29kZSBmcm9tIHRoZSBzZXJpZXMu
ICBBRkFJQ1QgdGhpcyBpcyB3aGF0IHRoZSBlbmFibGUNCj4gb2ZmbG9hZCBmdW5jdGlvbiBsb29r
cyBsaWtlIGFmdGVyIHlvdXIgc2V0IC0gd2hhdCdzIHRoZSBwb2ludCBvZiB0aGUNCj4gJ2Vycicg
dmFyaWFibGU/DQo+IA0KWWVzLiBUaGlzIHBhdGNoIHNlZW1zIHRvIGhhdmUgYSBmZXcgcmVhbGx5
IHNpbGx5IG1pc3Rha2VzLiBJIGFwb2xvZ2l6ZSBmb3IgdGhhdC4gSSB3aWxsbCBjbGVhbiBpdCB1
cCBhbmQgc2VuZCBhbm90aGVyIHZlcnNpb24gb2YgdGhlIHNlcmllcy4gVGhlcmUgaXMgbm8gdW51
c2VkIGNvZGUgYW55d2hlcmUgZWxzZSBpbiB0aGUgc2VyaWVzLg0KPiArc3RhdGljIGludCB0YXBy
aW9fZW5hYmxlX29mZmxvYWQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gKwkJCQkgc3RydWN0
IHRjX21xcHJpb19xb3B0ICptcXByaW8sDQo+ICsJCQkJIHN0cnVjdCB0YXByaW9fc2NoZWQgKnEs
DQo+ICsJCQkJIHN0cnVjdCBzY2hlZF9nYXRlX2xpc3QgKnNjaGVkLA0KPiArCQkJCSBzdHJ1Y3Qg
bmV0bGlua19leHRfYWNrICpleHRhY2ssDQo+ICsJCQkJIHUzMiBvZmZsb2FkX2ZsYWdzKQ0KPiAr
ew0KPiArCWNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlX29wcyAqb3BzID0gZGV2LT5uZXRkZXZfb3Bz
Ow0KPiArCWludCBlcnIgPSAwOw0KPiArDQo+ICsJaWYgKFRYVElNRV9PRkZMT0FEX0lTX09OKG9m
ZmxvYWRfZmxhZ3MpKQ0KPiArCQlnb3RvIGRvbmU7DQo+ICsNCj4gKwlpZiAoIUZVTExfT0ZGTE9B
RF9JU19PTihvZmZsb2FkX2ZsYWdzKSkgew0KPiArCQlOTF9TRVRfRVJSX01TRyhleHRhY2ssICJP
ZmZsb2FkIG1vZGUgaXMgbm90IHN1cHBvcnRlZCIpOw0KPiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7
DQo+ICsJfQ0KPiArDQo+ICsJaWYgKCFvcHMtPm5kb19zZXR1cF90Yykgew0KPiArCQlOTF9TRVRf
RVJSX01TRyhleHRhY2ssICJTcGVjaWZpZWQgZGV2aWNlIGRvZXMgbm90IHN1cHBvcnQgdGFwcmlv
IG9mZmxvYWQiKTsNCj4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArCX0NCj4gKw0KPiArCS8q
IEZJWE1FOiBlbmFibGUgb2ZmbG9hZGluZyAqLw0KPiArDQo+ICtkb25lOg0KPiArCWlmIChlcnIg
PT0gMCkgew0KPiArCQlxLT5kZXF1ZXVlID0gdGFwcmlvX2RlcXVldWVfb2ZmbG9hZDsNCj4gKwkJ
cS0+cGVlayA9IHRhcHJpb19wZWVrX29mZmxvYWQ7DQo+ICsgCQlxLT5vZmZsb2FkX2ZsYWdzID0g
b2ZmbG9hZF9mbGFnczsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gZXJyOw0KPiArfQ0KDQo=
