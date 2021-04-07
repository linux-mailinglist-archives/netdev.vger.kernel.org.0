Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C288F357664
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhDGU6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:58:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:5631 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhDGU6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:58:37 -0400
IronPort-SDR: R4y73lQ41JavKaKjvahMMpAntWNP2/w9SE8oy6Uo5d/7cEWCXEOz7sOqGSk9neKxatr62E27yG
 QXqo7j3aZyXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="192935907"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="192935907"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:58:26 -0700
IronPort-SDR: baTJcOoiMDQgn93Hzs8a45jA9+5KDow6v+oRq9IYp2CDXLkqD/oJq6+psfZ5V7veYRWh4mlFXX
 wBp9LZe9GtHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="421867166"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 07 Apr 2021 13:58:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 13:58:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 13:58:25 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 13:58:25 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v4 05/23] ice: Add devlink params support
Thread-Index: AQHXKyglet/OMpr4HUC3+2oFUaS+kaqpm5SA///RCKA=
Date:   Wed, 7 Apr 2021 20:58:25 +0000
Message-ID: <e516fa3940984b0cb0134364b923fc8e@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
In-Reply-To: <20210407145705.GA499950@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDA1LzIzXSBpY2U6IEFkZCBkZXZsaW5rIHBhcmFtcyBz
dXBwb3J0DQo+IA0KPiBPbiBUdWUsIEFwciAwNiwgMjAyMSBhdCAwNDowMTowN1BNIC0wNTAwLCBT
aGlyYXogU2FsZWVtIHdyb3RlOg0KPiA+IEFkZCBhIG5ldyBnZW5lcmljIHJ1bnRpbWUgZGV2bGlu
ayBwYXJhbWV0ZXIgJ3JkbWFfcHJvdG9jb2wnDQo+ID4gYW5kIHVzZSBpdCBpbiBpY2UgUENJIGRy
aXZlci4gQ29uZmlndXJhdGlvbiBjaGFuZ2VzIHJlc3VsdCBpbg0KPiA+IHVucGx1Z2dpbmcgdGhl
IGF1eGlsaWFyeSBSRE1BIGRldmljZSBhbmQgcmUtcGx1Z2dpbmcgaXQgd2l0aCB1cGRhdGVkDQo+
ID4gdmFsdWVzIGZvciBpcmRtYSBhdXhpaWFyeSBkcml2ZXIgdG8gY29uc3VtZSBhdA0KPiA+IGRy
di5wcm9iZSgpDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTaGlyYXogU2FsZWVtIDxzaGlyYXou
c2FsZWVtQGludGVsLmNvbT4NCj4gPiAgLi4uL25ldHdvcmtpbmcvZGV2bGluay9kZXZsaW5rLXBh
cmFtcy5yc3QgICAgICAgICAgfCAgNiArKw0KPiA+ICBEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcv
ZGV2bGluay9pY2UucnN0ICAgICAgICAgICB8IDEzICsrKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX2RldmxpbmsuYyAgICAgICB8IDkyICsrKysrKysrKysrKysrKysr
KysrKy0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9kZXZsaW5rLmgg
ICAgICAgfCAgNSArKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21h
aW4uYyAgICAgICAgICB8ICAyICsNCj4gPiAgaW5jbHVkZS9uZXQvZGV2bGluay5oICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgNCArDQo+ID4gIG5ldC9jb3JlL2RldmxpbmsuYyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDUgKysNCj4gPiAgNyBmaWxlcyBjaGFuZ2Vk
LCAxMjUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2bGluay9kZXZsaW5rLXBhcmFtcy5yc3QNCj4g
PiBiL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9kZXZsaW5rL2RldmxpbmstcGFyYW1zLnJzdA0K
PiA+IGluZGV4IDU0YzlmMTAuLjBiNDU0YzMgMTAwNjQ0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlv
bi9uZXR3b3JraW5nL2RldmxpbmsvZGV2bGluay1wYXJhbXMucnN0DQo+ID4gQEAgLTExNCwzICsx
MTQsOSBAQCBvd24gbmFtZS4NCj4gPiAgICAgICAgIHdpbGwgTkFDSyBhbnkgYXR0ZW1wdCBvZiBv
dGhlciBob3N0IHRvIHJlc2V0IHRoZSBkZXZpY2UuIFRoaXMgcGFyYW1ldGVyDQo+ID4gICAgICAg
ICBpcyB1c2VmdWwgZm9yIHNldHVwcyB3aGVyZSBhIGRldmljZSBpcyBzaGFyZWQgYnkgZGlmZmVy
ZW50IGhvc3RzLCBzdWNoDQo+ID4gICAgICAgICBhcyBtdWx0aS1ob3N0IHNldHVwLg0KPiA+ICsg
ICAqIC0gYGByZG1hX3Byb3RvY29sYGANCj4gPiArICAgICAtIHN0cmluZw0KPiA+ICsgICAgIC0g
U2VsZWN0cyB0aGUgUkRNQSBwcm90b2NvbCBzZWxlY3RlZCBmb3IgbXVsdGktcHJvdG9jb2wgZGV2
aWNlcy4NCj4gPiArICAgICAgICAtIGBgaXdhcnBgYCBpV0FSUA0KPiA+ICsJLSBgYHJvY2VgYCBS
b0NFDQo+ID4gKwktIGBgaWJgYCBJbmZpbmliYW5kDQo+IA0KPiBJJ20gc3RpbGwgbm90IHN1cmUg
dGhpcyBiZWxvbmdzIGluIGRldmxpbmsuDQoNCkkgYmVsaWV2ZSB5b3Ugc3VnZ2VzdGVkIHdlIHVz
ZSBkZXZsaW5rIGZvciBwcm90b2NvbCBzd2l0Y2guDQoNCj4gDQo+IFdoYXQgYWJvdXQgZGV2aWNl
cyB0aGF0IHN1cHBvcnQgcm9jZSBhbmQgaXdhcnAgY29uY3VycmVudGx5Pw0KPiANCj4gVGhlcmUg
aXMgbm90aGluZyBhdCB0aGUgcHJvdG9jb2wgbGV2ZWwgdGhhdCBwcmVjbHVkZXMgdGhpcyAtIGRv
ZXNuJ3QgdGhpcyBkZXZpY2UgYWxsb3cNCj4gaXQ/DQoNCk5vcGUuIFRoaXMgZGV2aWNlIGRvZXNu
4oCZdCBzdXBwb3J0IGJvdGggcHJvdG9jb2xzIGNvbmN1cnJlbnRseSBvbiBzYW1lIFBDSSBmdW5j
dGlvbi4NCg0KTWF5YmUgdGhlbiBpdCBtYWtlcyBzZW5zZSB0byBtb3ZlIHRoaXMgcHJvdG9jb2wg
c3dpdGNoIGFzIGRyaXZlciBzcGVjaWZpYyBkZXZsaW5rPw0KDQo+IA0KPiBJIGtub3cgUGFyYXYg
aXMgbG9va2luZyBhdCB0aGUgZ2VuZXJhbCBwcm9ibGVtIG9mIGhvdyB0byBjdXN0b21pemUgd2hh
dCBhdXgNCj4gZGV2aWNlcyBhcmUgY3JlYXRlZCwgdGhhdCBtYXkgYmUgYSBiZXR0ZXIgZml0IGZv
ciB0aGlzLg0KPiANCj4gQ2FuIHlvdSByZW1vdmUgdGhlIGRldmxpbmsgcGFydHMgdG8gbWFrZSBw
cm9ncmVzcz8NCj4gDQoNCkl0IGlzIGltcG9ydGFudCBzaW5jZSBvdGhlcndpc2UgdGhlIGN1c3Rv
bWVyIHdpbGwgaGF2ZSBubyB3YXkgdG8gdXNlIFJvQ0V2MiBvbiB0aGlzIGRldmljZS4NCg0KU2hp
cmF6DQo=
