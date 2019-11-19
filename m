Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863E2102AF8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKSRuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:50:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:50044 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbfKSRuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 12:50:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 09:50:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,218,1571727600"; 
   d="scan'208";a="357177188"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga004.jf.intel.com with ESMTP; 19 Nov 2019 09:50:17 -0800
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 09:50:16 -0800
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.229]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.64]) with mapi id 14.03.0439.000;
 Tue, 19 Nov 2019 09:50:16 -0800
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATHptCZx1o750+cmj+dZwSi7aeRFzoAgAGW4ICAAB04EA==
Date:   Tue, 19 Nov 2019 17:50:15 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B301688@ORSMSX101.amr.corp.intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <20191118074834.GA130507@kroah.com>
 <d3ee845d-cc9f-a4f7-2f21-511fde61dd5e@redhat.com>
In-Reply-To: <d3ee845d-cc9f-a4f7-2f21-511fde61dd5e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2Fu
Z0ByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxOSwgMjAxOSAxMjowNSBB
TQ0KPiBUbzogS2lyc2hlciwgSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+
OyBFcnRtYW4sIERhdmlkIE0NCj4gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4NCj4gQ2M6IEdy
ZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsN
Cj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc7DQo+
IG5ob3JtYW5AcmVkaGF0LmNvbTsgc2Fzc21hbm5AcmVkaGF0LmNvbTsgamdnQHppZXBlLmNhOw0K
PiBwYXJhdkBtZWxsYW5veC5jb207IFBhdGlsLCBLaXJhbiA8a2lyYW4ucGF0aWxAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0IHYyIDEvMV0gdmlydHVhbC1idXM6IEltcGxlbWVu
dGF0aW9uIG9mIFZpcnR1YWwgQnVzDQo+IA0KPiANCj4gT24gMjAxOS8xMS8xOCDkuIvljYgzOjQ4
LCBHcmVnIEtIIHdyb3RlOg0KPiA+ICtWaXJ0YnVzIGRyaXZlcnMNCj4gPiArfn5+fn5+fn5+fn5+
fn5+DQo+ID4gK1ZpcnRidXMgZHJpdmVycyByZWdpc3RlciB3aXRoIHRoZSB2aXJ0dWFsIGJ1cyB0
byBiZSBtYXRjaGVkIHdpdGgNCj4gPiArdmlydGJ1cyBkZXZpY2VzLiAgVGhleSBleHBlY3QgdG8g
YmUgcmVnaXN0ZXJlZCB3aXRoIGEgcHJvYmUgYW5kDQo+ID4gK3JlbW92ZSBjYWxsYmFjaywgYW5k
IGFsc28gc3VwcG9ydCBzaHV0ZG93biwgc3VzcGVuZCwgYW5kIHJlc3VtZQ0KPiA+ICtjYWxsYmFj
a3MuICBUaGV5IG90aGVyd2lzZSBmb2xsb3cgdGhlIHN0YW5kYXJkIGRyaXZlciBiZWhhdmlvciBv
Zg0KPiA+ICtoYXZpbmcgZGlzY292ZXJ5IGFuZCBlbnVtZXJhdGlvbiBoYW5kbGVkIGluIHRoZSBi
dXMgaW5mcmFzdHJ1Y3R1cmUuDQo+ID4gKw0KPiA+ICtWaXJ0YnVzIGRyaXZlcnMgcmVnaXN0ZXIg
dGhlbXNlbHZlcyB3aXRoIHRoZSBBUEkgZW50cnkgcG9pbnQNCj4gPiArdmlydGJ1c19kcnZfcmVn
IGFuZCB1bnJlZ2lzdGVyIHdpdGggdmlydGJ1c19kcnZfdW5yZWcuDQo+ID4gKw0KPiA+ICtEZXZp
Y2UgRW51bWVyYXRpb24NCj4gPiArfn5+fn5+fn5+fn5+fn5+fn5+DQo+ID4gK0VudW1lcmF0aW9u
IGlzIGhhbmRsZWQgYXV0b21hdGljYWxseSBieSB0aGUgYnVzIGluZnJhc3RydWN0dXJlIHZpYQ0K
PiA+ICt0aGUgaWRhX3NpbXBsZSBtZXRob2RzLg0KPiA+ICsNCj4gPiArRGV2aWNlIG5hbWluZyBh
bmQgZHJpdmVyIGJpbmRpbmcNCj4gPiArfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4N
Cj4gPiArVGhlIHZpcnRidXNfZGV2aWNlLmRldi5uYW1lIGlzIHRoZSBjYW5vbmljYWwgbmFtZSBm
b3IgdGhlIGRldmljZS4gSXQNCj4gPiAraXMgYnVpbHQgZnJvbSB0d28gb3RoZXIgcGFydHM6DQo+
ID4gKw0KPiA+ICsgICAgICAgIC0gdmlydGJ1c19kZXZpY2UubmFtZSAoYWxzbyB1c2VkIGZvciBt
YXRjaGluZykuDQo+ID4gKyAgICAgICAgLSB2aXJ0YnVzX2RldmljZS5pZCAoZ2VuZXJhdGVkIGF1
dG9tYXRpY2FsbHkgZnJvbSBpZGFfc2ltcGxlDQo+ID4gKyBjYWxscykNCj4gPiArDQo+ID4gK1Ro
aXMgYWxsb3dzIGZvciBtdWx0aXBsZSB2aXJ0YnVzX2RldmljZXMgd2l0aCB0aGUgc2FtZSBuYW1l
LCB3aGljaA0KPiA+ICt3aWxsIGFsbCBiZSBtYXRjaGVkIHRvIHRoZSBzYW1lIHZpcnRidXNfZHJp
dmVyLiBEcml2ZXIgYmluZGluZyBpcw0KPiA+ICtwZXJmb3JtZWQgYnkgdGhlIGRyaXZlciBjb3Jl
LCBpbnZva2luZyBkcml2ZXIgcHJvYmUoKSBhZnRlciBmaW5kaW5nIGENCj4gbWF0Y2ggYmV0d2Vl
biBkZXZpY2UgYW5kIGRyaXZlci4NCj4gPiArDQo+ID4gK1ZpcnR1YWwgQnVzIEFQSSBlbnRyeSBw
b2ludHMNCj4gPiArfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiA+ICtzdHJ1Y3Qgdmly
dGJ1c19kZXZpY2UgKnZpcnRidXNfZGV2X2FsbG9jKGNvbnN0IGNoYXIgKm5hbWUsIHZvaWQNCj4g
PiArKmRhdGEpDQo+IA0KPiANCj4gSGk6DQo+IA0KPiBTZXZlcmFsIHF1ZXN0aW9ucyBhYm91dCB0
aGUgbmFtZSBwYXJhbWV0ZXIgaGVyZToNCj4gDQo+IC0gSWYgd2Ugd2FudCB0byBoYXZlIG11bHRp
cGxlIHR5cGVzIG9mIGRldmljZSB0byBiZSBhdHRhY2hlZCwgc29tZQ0KPiBjb252ZW50aW9uIGlz
IG5lZWRlZCB0byBhdm9pZCBjb25mdXNpb24gZHVyaW5nIHRoZSBtYXRjaC4gQnV0IGlmIHdlIGhh
ZA0KPiBzdWNoIG9uZSAoZS5nIHByZWZpeCBvciBzdWZmaXgpLCBpdCBiYXNpY2FsbHkgYW5vdGhl
ciBidXM/DQo+IC0gV2hvIGRlY2lkZXMgdGhlIG5hbWUgb2YgdGhpcyB2aXJ0YnVzIGRldiwgaXMg
aXQgdW5kZXIgdGhlIGNvbnRyb2wgb2YNCj4gdXNlcnNwYWNlPyBJZiB5ZXMsIGEgbWFuYWdlbWVu
dCBpbnRlcmZhY2UgaXMgcmVxdWlyZWQuDQo+IA0KPiBUaGFua3MNCj4gDQpUaGlzIGZ1bmN0aW9u
IGhhcyBiZWVuIHJlbW92ZWQgZnJvbSB0aGUgQVBJLiAgTmV3IHBhdGNoIHNldCBpbmJvdW5kDQpp
bXBsZW1lbnRpbmcgY2hhbmdlcyB0aGF0IFBhcmF2IHN1Z2dlc3RlZC4NCg0KPiANCj4gPiAraW50
IHZpcnRidXNfZGV2X3JlZ2lzdGVyKHN0cnVjdCB2aXJ0YnVzX2RldmljZSAqdmRldikgdm9pZA0K
PiA+ICt2aXJ0YnVzX2Rldl91bnJlZ2lzdGVyKHN0cnVjdCB2aXJ0YnVzX2RldmljZSAqdmRldikg
aW50DQo+ID4gK3ZpcnRidXNfZHJ2X3JlZ2lzdGVyKHN0cnVjdCB2aXJ0YnVzX2RyaXZlciAqdmRy
diwgc3RydWN0IG1vZHVsZQ0KPiA+ICsqb3duZXIpIHZvaWQgdmlydGJ1c19kcnZfdW5yZWdpc3Rl
cihzdHJ1Y3QgdmlydGJ1c19kcml2ZXIgKnZkcnYpDQoNCg==
