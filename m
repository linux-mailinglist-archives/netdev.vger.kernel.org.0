Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54B034E70E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhC3MFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:05:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:44772 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhC3MEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:04:49 -0400
IronPort-SDR: b243ztWssr8b2b5y8pZMiDQMzaGoWpxu9unJq5PU6WU9cuyYZHyBMI7gRA01Fin6f2t2+cn/S5
 1BLs/kKLvxVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="189507720"
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="189507720"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 05:04:49 -0700
IronPort-SDR: CE5IQKwaDjMMBG9fov++PnD9mOD0TuooWyYL8al+7Q36ujFHEWUQt7dp6h5kC29XL3pREklrj+
 3mw5sAI/fAyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="595444556"
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2021 05:04:48 -0700
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 IRSMSX604.ger.corp.intel.com (163.33.146.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 30 Mar 2021 13:04:47 +0100
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.2106.013;
 Tue, 30 Mar 2021 13:04:47 +0100
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>
Subject: RE: [PATCH v2 bpf 3/3] libbpf: ignore return values of setsockopt for
 XDP rings.
Thread-Topic: [PATCH v2 bpf 3/3] libbpf: ignore return values of setsockopt
 for XDP rings.
Thread-Index: AQHXIlDjJrZQMtFJm0i7O3jDxgJtSaqXHNWAgAOK00CAAGNqgIABabwg
Date:   Tue, 30 Mar 2021 12:04:46 +0000
Message-ID: <04cce5576df34ec9b7ba1f145dd28422@intel.com>
References: <20210326142946.5263-1-ciara.loftus@intel.com>
 <20210326142946.5263-4-ciara.loftus@intel.com>
 <20210327022729.cgizt5xnhkerbrmy@ast-mbp>
 <bc1d9e861d27499da5f5a84bc6d22177@intel.com>
 <CAADnVQLt9Wa-Ue85HRzRe0HO_Cyqo9Cd4MyvXRgqSC_dmVe=DQ@mail.gmail.com>
In-Reply-To: <CAADnVQLt9Wa-Ue85HRzRe0HO_Cyqo9Cd4MyvXRgqSC_dmVe=DQ@mail.gmail.com>
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

PiA+DQo+ID4gPg0KPiA+ID4gT24gRnJpLCBNYXIgMjYsIDIwMjEgYXQgMDI6Mjk6NDZQTSArMDAw
MCwgQ2lhcmEgTG9mdHVzIHdyb3RlOg0KPiA+ID4gPiBEdXJpbmcgeHNrX3NvY2tldF9fY3JlYXRl
IHRoZSBYRFBfUlhfUklORyBhbmQgWERQX1RYX1JJTkcNCj4gPiA+IHNldHNvY2tvcHRzDQo+ID4g
PiA+IGFyZSBjYWxsZWQgdG8gY3JlYXRlIHRoZSByeCBhbmQgdHggcmluZ3MgZm9yIHRoZSBBRl9Y
RFAgc29ja2V0LiBJZiB0aGUgcmluZw0KPiA+ID4gPiBoYXMgYWxyZWFkeSBiZWVuIHNldCB1cCwg
dGhlIHNldHNvY2tvcHQgd2lsbCByZXR1cm4gYW4gZXJyb3IuIEhvd2V2ZXIsDQo+ID4gPiA+IGlu
IHRoZSBldmVudCBvZiBhIGZhaWx1cmUgZHVyaW5nIHhza19zb2NrZXRfX2NyZWF0ZShfc2hhcmVk
KSBhZnRlciB0aGUNCj4gPiA+ID4gcmluZ3MgaGF2ZSBiZWVuIHNldCB1cCwgdGhlIHVzZXIgbWF5
IHdpc2ggdG8gcmV0cnkgdGhlIHNvY2tldCBjcmVhdGlvbg0KPiA+ID4gPiB1c2luZyB0aGVzZSBw
cmUtZXhpc3RpbmcgcmluZ3MuIEluIHRoaXMgY2FzZSB3ZSBjYW4gaWdub3JlIHRoZSBlcnJvcg0K
PiA+ID4gPiByZXR1cm5lZCBieSB0aGUgc2V0c29ja29wdHMuIElmIHRoZXJlIGlzIGEgdHJ1ZSBl
cnJvciwgdGhlIHN1YnNlcXVlbnQNCj4gPiA+ID4gY2FsbCB0byBtbWFwKCkgd2lsbCBjYXRjaCBp
dC4NCj4gPiA+ID4NCj4gPiA+ID4gRml4ZXM6IDFjYWQwNzg4NDIzOSAoImxpYmJwZjogYWRkIHN1
cHBvcnQgZm9yIHVzaW5nIEFGX1hEUCBzb2NrZXRzIikNCj4gPiA+ID4NCj4gPiA+ID4gQWNrZWQt
Ynk6IE1hZ251cyBLYXJsc3NvbiA8bWFnbnVzLmthcmxzc29uQGludGVsLmNvbT4NCj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogQ2lhcmEgTG9mdHVzIDxjaWFyYS5sb2Z0dXNAaW50ZWwuY29tPg0KPiA+
ID4gPiAtLS0NCj4gPiA+ID4gIHRvb2xzL2xpYi9icGYveHNrLmMgfCAzNCArKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0
aW9ucygrKSwgMTggZGVsZXRpb25zKC0pDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS90
b29scy9saWIvYnBmL3hzay5jIGIvdG9vbHMvbGliL2JwZi94c2suYw0KPiA+ID4gPiBpbmRleCBk
NDk5MWRkZmYwNWEuLmNmYzRhYmY1MDVjMyAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvdG9vbHMvbGli
L2JwZi94c2suYw0KPiA+ID4gPiArKysgYi90b29scy9saWIvYnBmL3hzay5jDQo+ID4gPiA+IEBA
IC05MDAsMjQgKzkwMCwyMiBAQCBpbnQgeHNrX3NvY2tldF9fY3JlYXRlX3NoYXJlZChzdHJ1Y3QN
Cj4geHNrX3NvY2tldA0KPiA+ID4gKip4c2tfcHRyLA0KPiA+ID4gPiAgICAgfQ0KPiA+ID4gPiAg
ICAgeHNrLT5jdHggPSBjdHg7DQo+ID4gPiA+DQo+ID4gPiA+IC0gICBpZiAocngpIHsNCj4gPiA+
ID4gLSAgICAgICAgICAgZXJyID0gc2V0c29ja29wdCh4c2stPmZkLCBTT0xfWERQLCBYRFBfUlhf
UklORywNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAmeHNrLT5jb25maWcu
cnhfc2l6ZSwNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICBzaXplb2YoeHNr
LT5jb25maWcucnhfc2l6ZSkpOw0KPiA+ID4gPiAtICAgICAgICAgICBpZiAoZXJyKSB7DQo+ID4g
PiA+IC0gICAgICAgICAgICAgICAgICAgZXJyID0gLWVycm5vOw0KPiA+ID4gPiAtICAgICAgICAg
ICAgICAgICAgIGdvdG8gb3V0X3B1dF9jdHg7DQo+ID4gPiA+IC0gICAgICAgICAgIH0NCj4gPiA+
ID4gLSAgIH0NCj4gPiA+ID4gLSAgIGlmICh0eCkgew0KPiA+ID4gPiAtICAgICAgICAgICBlcnIg
PSBzZXRzb2Nrb3B0KHhzay0+ZmQsIFNPTF9YRFAsIFhEUF9UWF9SSU5HLA0KPiA+ID4gPiAtICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICZ4c2stPmNvbmZpZy50eF9zaXplLA0KPiA+ID4gPiAt
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZih4c2stPmNvbmZpZy50eF9zaXplKSk7
DQo+ID4gPiA+IC0gICAgICAgICAgIGlmIChlcnIpIHsNCj4gPiA+ID4gLSAgICAgICAgICAgICAg
ICAgICBlcnIgPSAtZXJybm87DQo+ID4gPiA+IC0gICAgICAgICAgICAgICAgICAgZ290byBvdXRf
cHV0X2N0eDsNCj4gPiA+ID4gLSAgICAgICAgICAgfQ0KPiA+ID4gPiAtICAgfQ0KPiA+ID4gPiAr
ICAgLyogVGhlIHJldHVybiB2YWx1ZXMgb2YgdGhlc2Ugc2V0c29ja29wdCBjYWxscyBhcmUgaW50
ZW50aW9uYWxseSBub3QNCj4gPiA+IGNoZWNrZWQuDQo+ID4gPiA+ICsgICAgKiBJZiB0aGUgcmlu
ZyBoYXMgYWxyZWFkeSBiZWVuIHNldCB1cCBzZXRzb2Nrb3B0IHdpbGwgcmV0dXJuIGFuIGVycm9y
Lg0KPiA+ID4gSG93ZXZlciwNCj4gPiA+ID4gKyAgICAqIHRoaXMgc2NlbmFyaW8gaXMgYWNjZXB0
YWJsZSBhcyB0aGUgdXNlciBtYXkgYmUgcmV0cnlpbmcgdGhlIHNvY2tldA0KPiA+ID4gY3JlYXRp
b24NCj4gPiA+ID4gKyAgICAqIHdpdGggcmluZ3Mgd2hpY2ggd2VyZSBzZXQgdXAgaW4gYSBwcmV2
aW91cyBidXQgdWx0aW1hdGVseQ0KPiA+ID4gdW5zdWNjZXNzZnVsIGNhbGwNCj4gPiA+ID4gKyAg
ICAqIHRvIHhza19zb2NrZXRfX2NyZWF0ZShfc2hhcmVkKS4gVGhlIGNhbGwgbGF0ZXIgdG8gbW1h
cCgpIHdpbGwgZmFpbCBpZg0KPiA+ID4gdGhlcmUNCj4gPiA+ID4gKyAgICAqIGlzIGEgcmVhbCBp
c3N1ZSBhbmQgd2UgaGFuZGxlIHRoYXQgcmV0dXJuIHZhbHVlIGFwcHJvcHJpYXRlbHkgdGhlcmUu
DQo+ID4gPiA+ICsgICAgKi8NCj4gPiA+ID4gKyAgIGlmIChyeCkNCj4gPiA+ID4gKyAgICAgICAg
ICAgc2V0c29ja29wdCh4c2stPmZkLCBTT0xfWERQLCBYRFBfUlhfUklORywNCj4gPiA+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAmeHNrLT5jb25maWcucnhfc2l6ZSwNCj4gPiA+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICBzaXplb2YoeHNrLT5jb25maWcucnhfc2l6ZSkpOw0KPiA+ID4gPiAr
DQo+ID4gPiA+ICsgICBpZiAodHgpDQo+ID4gPiA+ICsgICAgICAgICAgIHNldHNvY2tvcHQoeHNr
LT5mZCwgU09MX1hEUCwgWERQX1RYX1JJTkcsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgJnhzay0+Y29uZmlnLnR4X3NpemUsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
c2l6ZW9mKHhzay0+Y29uZmlnLnR4X3NpemUpKTsNCj4gPiA+DQo+ID4gPiBJbnN0ZWFkIG9mIGln
bm9yaW5nIHRoZSBlcnJvciBjYW4geW91IHJlbWVtYmVyIHRoYXQgc2V0c29ja29wdCB3YXMNCj4g
ZG9uZQ0KPiA+ID4gaW4gc3RydWN0IHhza19zb2NrZXQgYW5kIGRvbid0IGRvIGl0IHRoZSBzZWNv
bmQgdGltZT8NCj4gPg0KPiA+IElkZWFsbHkgd2UgZG9uJ3QgaGF2ZSB0byBpZ25vcmUgdGhlIGVy
cm9yLiBIb3dldmVyIGluIHRoZSBldmVudCBvZiBmYWlsdXJlDQo+IHN0cnVjdCB4c2tfc29ja2V0
IGlzIGZyZWVkIGF0IHRoZSBlbmQgb2YgeHNrX3NvY2tldF9fY3JlYXRlIHNvIHdlIGNhbid0IHVz
ZSBpdA0KPiB0byByZW1lbWJlciBzdGF0ZSBiZXR3ZWVuIHN1YnNlcXVlbnQgY2FsbHMgdG8gX19j
cmVhdGUoKS4NCj4gDQo+IGJ1dCB1bWVtIGlzIG5vdCwgcmlnaHQ/IGFuZCBmZCBpcyB0YWtlbiBm
cm9tIHRoZXJlLg0KDQpZZXMsIGdvdCBpdC4gV2UgY2FuIGFkZCBhIG5ldyBmaWVsZCB0byBzdHJ1
Y3QgeHNrX3VtZW0uIEl0J3MgbXVjaCBiZXR0ZXIgdGhhbiBpZ25vcmluZyB0aGUgcmV0dXJuIHZh
bHVlcy4NCkknbGwgYWRkIHRoaXMgaW4gdGhlIHYzLiBUaGFua3MgZm9yIHlvdXIgc3VnZ2VzdGlv
biENCg0KQ2lhcmENCg==
