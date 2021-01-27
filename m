Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59080305DFB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhA0ONE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:13:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:3924 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhA0OLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 09:11:07 -0500
IronPort-SDR: B3/ACi06YIaAtn0EODL14OIUVHNogDMHjAfPDk3f8KGms3C/MSNpcAQZt0KxNmd+2EVeXYlRWT
 qmBnwokU84QA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159846951"
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="159846951"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:10:26 -0800
IronPort-SDR: zYU26Iw75cM1BFqOJ7ClRIQx8NijzkNAfJ4/gVAVz25SAyAT9fI/RDqQgjVYTinJDTeYonWK8O
 pTtUukFrBMBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="351012405"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jan 2021 06:10:25 -0800
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Jan 2021 14:10:24 +0000
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.1713.004;
 Wed, 27 Jan 2021 14:10:24 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Janjua, Weqaar A" <weqaar.a.janjua@intel.com>
Subject: RE: [PATCH bpf-next v2 1/6] xsk: add tracepoints for packet drops
Thread-Topic: [PATCH bpf-next v2 1/6] xsk: add tracepoints for packet drops
Thread-Index: AQHW87xsHkD4hpZ27EqaJ6lgGWVOJKo6hDSAgAD+PnA=
Date:   Wed, 27 Jan 2021 14:10:24 +0000
Message-ID: <c40e361d0ef2475db93cfb5d007599f2@intel.com>
References: <20210126075239.25378-1-ciara.loftus@intel.com>
 <20210126075239.25378-2-ciara.loftus@intel.com>
 <7100d6c0-8556-4f7e-93e7-5ba6fa549104@iogearbox.net>
In-Reply-To: <7100d6c0-8556-4f7e-93e7-5ba6fa549104@iogearbox.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAxLzI2LzIxIDg6NTIgQU0sIENpYXJhIExvZnR1cyB3cm90ZToNCj4gPiBUaGlzIGNvbW1p
dCBpbnRyb2R1Y2VzIHN0YXRpYyBwZXJmIHRyYWNlcG9pbnRzIGZvciBBRl9YRFAgd2hpY2gNCj4g
PiByZXBvcnQgaW5mb3JtYXRpb24gYWJvdXQgcGFja2V0IGRyb3BzLCBzdWNoIGFzIHRoZSBuZXRk
ZXYsIHFpZCBhbmQNCj4gPiBoaWdoIGxldmVsIHJlYXNvbiBmb3IgdGhlIGRyb3AuIFRoZSB0cmFj
ZXBvaW50IGNhbiBiZQ0KPiA+IGVuYWJsZWQvZGlzYWJsZWQgYnkgdG9nZ2xpbmcNCj4gPiAvc3lz
L2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2V2ZW50cy94c2sveHNrX3BhY2tldF9kcm9wL2VuYWJsZQ0K
PiANCj4gQ291bGQgeW91IGFkZCBhIHJhdGlvbmFsZSB0byB0aGUgY29tbWl0IGxvZyBvbiB3aHkg
eHNrIGRpYWcgc3RhdHMgZHVtcA0KPiBpcyBpbnN1ZmZpY2llbnQgaGVyZSBnaXZlbiB5b3UgYWRk
IHRyYWNlcG9pbnRzIHRvIG1vc3QgbG9jYXRpb25zIHdoZXJlDQo+IHdlIGFsc28gYnVtcCB0aGUg
Y291bnRlcnMgYWxyZWFkeT8gQW5kIGdpdmVuIGRpYWcgaW5mcmEgYWxzbyBleHBvc2VzIHRoZQ0K
PiBpZmluZGV4LCBxdWV1ZSBpZCwgZXRjLCB3aHkgdHJvdWJsZXNob290aW5nIHRoZSB4c2sgc29j
a2V0IHZpYSBzcyB0b29sDQo+IGlzIG5vdCBzdWZmaWNpZW50Pw0KDQpUaGFua3MgZm9yIHlvdXIg
ZmVlZGJhY2sgRGFuaWVsLg0KDQpUaGUgc3RhdHMgdGVsbCB1cyB0aGF0IHRoZXJlIGlzICphKiBw
cm9ibGVtIHdoZXJlYXMgdGhlIHRyYWNlcyB3aWxsIHNoZWQNCmxpZ2h0IG9uIHdoYXQgdGhhdCBw
cm9ibGVtIGlzLiBlZy4gVGhlIFhTS19UUkFDRV9EUk9QX1BLVF9UT09fQklHDQp0cmFjZSB0ZWxs
cyB1cyB3ZSBkcm9wcGVkIGEgcGFja2V0IG9uIFJYIGR1ZSB0byBpdCBiZWluZyB0b28gYmlnIHZz
LiBzcw0Kd291bGQganVzdCB0ZWxsIHVzIHRoZSBwYWNrZXQgd2FzIGRyb3BwZWQuDQpJIHdpbGwg
YWRkIHRoaXMgcmF0aW9uYWxlIGluIHRoZSB2My4NCg0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0t
Z2l0IGEvbmV0L3hkcC94c2suYyBiL25ldC94ZHAveHNrLmMNCj4gPiBpbmRleCA0ZmFhYmQxZWNm
ZDEuLjliODUwNzE2NjMwYiAxMDA2NDQNCj4gPiAtLS0gYS9uZXQveGRwL3hzay5jDQo+ID4gKysr
IGIvbmV0L3hkcC94c2suYw0KPiA+IEBAIC0xMSw2ICsxMSw3IEBADQo+ID4NCj4gPiAgICNkZWZp
bmUgcHJfZm10KGZtdCkgIkFGX1hEUDogJXM6ICIgZm10LCBfX2Z1bmNfXw0KPiA+DQo+ID4gKyNp
bmNsdWRlIDxsaW51eC9icGZfdHJhY2UuaD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9pZl94ZHAu
aD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQo+ID4gICAjaW5jbHVkZSA8bGludXgv
c2NoZWQvbW0uaD4NCj4gPiBAQCAtMTU4LDYgKzE1OSw3IEBAIHN0YXRpYyBpbnQgX194c2tfcmN2
X3pjKHN0cnVjdCB4ZHBfc29jayAqeHMsIHN0cnVjdA0KPiB4ZHBfYnVmZiAqeGRwLCB1MzIgbGVu
KQ0KPiA+ICAgCWFkZHIgPSB4cF9nZXRfaGFuZGxlKHhza2IpOw0KPiA+ICAgCWVyciA9IHhza3Ff
cHJvZF9yZXNlcnZlX2Rlc2MoeHMtPnJ4LCBhZGRyLCBsZW4pOw0KPiA+ICAgCWlmIChlcnIpIHsN
Cj4gPiArCQl0cmFjZV94c2tfcGFja2V0X2Ryb3AoeHMtPmRldi0+bmFtZSwgeHMtPnF1ZXVlX2lk
LA0KPiBYU0tfVFJBQ0VfRFJPUF9SWFFfRlVMTCk7DQo+ID4gICAJCXhzLT5yeF9xdWV1ZV9mdWxs
Kys7DQo+ID4gICAJCXJldHVybiBlcnI7DQo+IA0KPiBJIHByZXN1bWUgaWYgdGhpcyB3aWxsIGJl
IHRyaWdnZXJlZCB1bmRlciBzdHJlc3MgeW91J2xsIGxpa2VseSBhbHNvIHNwYW0NCj4geW91ciB0
cmFjZSBldmVudCBsb2cgdy8gcG90ZW50aWFsbHkgbWlvIG9mIG1zZ3MgcGVyIHNlYz8NCg0KWW91
IGFyZSBjb3JyZWN0LiBBZnRlciBzb21lIGNvbnNpZGVyYXRpb24gSSdtIGdvaW5nIHRvIGRyb3Ag
dGhpcw0KdHJhY2UgYW5kIHNvbWUgb3RoZXJzIGluIHRoZSBuZXh0IHJldiB3aGljaCBhcmUgbm90
IHRlY2huaWNhbGx5DQpndWFyYW50ZWVkIGRyb3BzIGFuZCBjb3VsZCBlbmQgdXAgc3BhbW1pbmcg
dGhlIGxvZyB1bmRlcg0Kc3RyZXNzIGFzIHlvdSBtZW50aW9uZWQuDQoNCj4gDQo+ID4gICAJfQ0K
PiA+IEBAIC0xOTIsNiArMTk0LDcgQEAgc3RhdGljIGludCBfX3hza19yY3Yoc3RydWN0IHhkcF9z
b2NrICp4cywgc3RydWN0DQo+IHhkcF9idWZmICp4ZHApDQo+ID4NCj4gPiAgIAlsZW4gPSB4ZHAt
PmRhdGFfZW5kIC0geGRwLT5kYXRhOw0KPiA+ICAgCWlmIChsZW4gPiB4c2tfcG9vbF9nZXRfcnhf
ZnJhbWVfc2l6ZSh4cy0+cG9vbCkpIHsNCj4gPiArCQl0cmFjZV94c2tfcGFja2V0X2Ryb3AoeHMt
PmRldi0+bmFtZSwgeHMtPnF1ZXVlX2lkLA0KPiBYU0tfVFJBQ0VfRFJPUF9QS1RfVE9PX0JJRyk7
DQo+ID4gICAJCXhzLT5yeF9kcm9wcGVkKys7DQo+ID4gICAJCXJldHVybiAtRU5PU1BDOw0KPiA+
ICAgCX0NCj4gPiBAQCAtNTE2LDYgKzUxOSw4IEBAIHN0YXRpYyBpbnQgeHNrX2dlbmVyaWNfeG1p
dChzdHJ1Y3Qgc29jayAqc2spDQo+ID4gICAJCWlmIChlcnIgPT0gTkVUX1hNSVRfRFJPUCkgew0K
PiA+ICAgCQkJLyogU0tCIGNvbXBsZXRlZCBidXQgbm90IHNlbnQgKi8NCj4gPiAgIAkJCWVyciA9
IC1FQlVTWTsNCj4gPiArCQkJdHJhY2VfeHNrX3BhY2tldF9kcm9wKHhzLT5kZXYtPm5hbWUsIHhz
LQ0KPiA+cXVldWVfaWQsDQo+ID4gKwkJCQkJICAgICAgWFNLX1RSQUNFX0RST1BfRFJWX0VSUl9U
WCk7DQo+IA0KPiBJcyB0aGVyZSBhIHJlYXNvbiB0byBub3QgYnVtcCBlcnJvciBjb3VudGVyIGhl
cmU/DQoNClRoaXMgdG9vIGZhbGxzIGludG8gdGhlIG5vdC10ZWNobmljYWxseS1hLWRyb3AgY2F0
ZWdvcnkgYW5kIHdpbGwgYmUNCnJlbW92ZWQgaW4gdGhlIG5leHQgcmV2LiBJIHRoaW5rIGEgc3Rh
dCB3b3VsZCBiZSB1c2VmdWwgdGhvdWdoLg0KSSdsbCBkcmF3IHVwIGEgc2VwYXJhdGUgcGF0Y2gu
IFRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24uDQoNCj4gDQo+ID4gICAJCQlnb3RvIG91dDsNCj4g
PiAgIAkJfQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC94ZHAveHNrX2J1ZmZfcG9vbC5jIGIv
bmV0L3hkcC94c2tfYnVmZl9wb29sLmMNCj4gPiBpbmRleCA4ZGUwMWFhYWM0YTAuLmQzYzFjYTgz
Yzc1ZCAxMDA2NDQNCj4gPiAtLS0gYS9uZXQveGRwL3hza19idWZmX3Bvb2wuYw0KPiA+ICsrKyBi
L25ldC94ZHAveHNrX2J1ZmZfcG9vbC5jDQo+ID4gQEAgLTEsNSArMSw2IEBADQo+ID4gICAvLyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiA+DQo=
