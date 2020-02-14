Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6703715D741
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgBNMU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 07:20:27 -0500
Received: from mga05.intel.com ([192.55.52.43]:30457 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgBNMU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 07:20:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 04:20:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,440,1574150400"; 
   d="scan'208";a="381429286"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2020 04:20:26 -0800
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 14 Feb 2020 04:20:26 -0800
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.100]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.95]) with mapi id 14.03.0439.000;
 Fri, 14 Feb 2020 04:20:26 -0800
From:   "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
To:     "sgarzare@redhat.com" <sgarzare@redhat.com>
CC:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
Thread-Topic: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
Thread-Index: AQHV4yyrh/V/2txMb02EtEAkK2wIxKgbIV6AgAAAqAA=
Date:   Fri, 14 Feb 2020 12:20:25 +0000
Message-ID: <cdad5dee6207d8fdb667cbdc4b67d8f9b61ad23c.camel@intel.com>
References: <20200214114802.23638-1-sebastien.boeuf@intel.com>
         <20200214121803.kpblkpywkvwkoc7h@steredhat>
In-Reply-To: <20200214121803.kpblkpywkvwkoc7h@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.24.179]
Content-Type: text/plain; charset="utf-8"
Content-ID: <84D16CF6DECC4045BF893CADAABE2A74@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAyLTE0IGF0IDEzOjE4ICswMTAwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3Jv
dGU6DQo+IE9uIEZyaSwgRmViIDE0LCAyMDIwIGF0IDEyOjQ4OjAwUE0gKzAxMDAsIFNlYmFzdGll
biBCb2V1ZiB3cm90ZToNCj4gPiBUaGlzIHNlcmllcyBpbXByb3ZlcyB0aGUgc2VtYW50aWNzIGJl
aGluZCB0aGUgd2F5IHZpcnRpby12c29jaw0KPiA+IHNlcnZlcg0KPiA+IGFjY2VwdHMgY29ubmVj
dGlvbnMgY29taW5nIGZyb20gdGhlIGNsaWVudC4gV2hlbmV2ZXIgdGhlIHNlcnZlcg0KPiA+IHJl
Y2VpdmVzIGEgY29ubmVjdGlvbiByZXF1ZXN0IGZyb20gdGhlIGNsaWVudCwgaWYgaXQgaXMgYm91
bmQgdG8NCj4gPiB0aGUNCj4gPiBzb2NrZXQgYnV0IG5vdCB5ZXQgbGlzdGVuaW5nLCBpdCB3aWxs
IGFuc3dlciB3aXRoIGEgUlNUIHBhY2tldC4gVGhlDQo+ID4gcG9pbnQgaXMgdG8gZW5zdXJlIGVh
Y2ggcmVxdWVzdCBmcm9tIHRoZSBjbGllbnQgaXMgcXVpY2tseQ0KPiA+IHByb2Nlc3NlZA0KPiA+
IHNvIHRoYXQgdGhlIGNsaWVudCBjYW4gZGVjaWRlIGFib3V0IHRoZSBzdHJhdGVneSBvZiByZXRy
eWluZyBvcg0KPiA+IG5vdC4NCj4gPiANCj4gPiBUaGUgc2VyaWVzIGluY2x1ZGVzIGFsb25nIHdp
dGggdGhlIGltcHJvdmVtZW50IHBhdGNoIGEgbmV3IHRlc3QgdG8NCj4gPiBlbnN1cmUgdGhlIGJl
aGF2aW9yIGlzIGNvbnNpc3RlbnQgYWNyb3NzIGFsbCBoeXBlcnZpc29ycyBkcml2ZXJzLg0KPiA+
IA0KPiA+IFNlYmFzdGllbiBCb2V1ZiAoMik6DQo+ID4gICBuZXQ6IHZpcnRpb192c29jazogRW5o
YW5jZSBjb25uZWN0aW9uIHNlbWFudGljcw0KPiA+ICAgdG9vbHM6IHRlc3Rpbmc6IHZzb2NrOiBU
ZXN0IHdoZW4gc2VydmVyIGlzIGJvdW5kIGJ1dCBub3QNCj4gPiBsaXN0ZW5pbmcNCj4gPiANCj4g
PiAgbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jIHwgIDEgKw0KPiA+ICB0
b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyAgICAgICAgfCA3Nw0KPiA+ICsrKysrKysr
KysrKysrKysrKysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA3OCBpbnNlcnRpb25zKCsp
DQo+ID4gDQo+IA0KPiBUaGFua3MsDQo+IG5vdyB0aGV5IGFwcGx5IGNsZWFubHkhDQoNCkdyZWF0
IQ0KDQo+IA0KPiBUZXN0ZWQtYnk6IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0
LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0
LmNvbT4NCj4gDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KSW50ZWwgQ29ycG9yYXRpb24gU0FTIChGcmVuY2ggc2lt
cGxpZmllZCBqb2ludCBzdG9jayBjb21wYW55KQpSZWdpc3RlcmVkIGhlYWRxdWFydGVyczogIkxl
cyBNb250YWxldHMiLSAyLCBydWUgZGUgUGFyaXMsIAo5MjE5NiBNZXVkb24gQ2VkZXgsIEZyYW5j
ZQpSZWdpc3RyYXRpb24gTnVtYmVyOiAgMzAyIDQ1NiAxOTkgUi5DLlMuIE5BTlRFUlJFCkNhcGl0
YWw6IDQsNTcyLDAwMCBFdXJvcwoKVGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBtYXkg
Y29udGFpbiBjb25maWRlbnRpYWwgbWF0ZXJpYWwgZm9yCnRoZSBzb2xlIHVzZSBvZiB0aGUgaW50
ZW5kZWQgcmVjaXBpZW50KHMpLiBBbnkgcmV2aWV3IG9yIGRpc3RyaWJ1dGlvbgpieSBvdGhlcnMg
aXMgc3RyaWN0bHkgcHJvaGliaXRlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkCnJlY2lw
aWVudCwgcGxlYXNlIGNvbnRhY3QgdGhlIHNlbmRlciBhbmQgZGVsZXRlIGFsbCBjb3BpZXMuCg==

