Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFB38E42B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 12:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhEXKiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 06:38:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:8297 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232614AbhEXKiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 06:38:18 -0400
IronPort-SDR: wkdAg3R0ot410fYwQSnJYtWfQNsL7YEryv2lRFgJw+OefHDQx7uOuMV5ccTaif4f/6AOF8C6VF
 33NGMIDPlBdA==
X-IronPort-AV: E=McAfee;i="6200,9189,9993"; a="223057946"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="223057946"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 03:36:50 -0700
IronPort-SDR: WMFRFjMM3N9zZ3Fk40UzZ2Lrqhj0UcZqjFYtjQTZQCOOPNScMVLNm6waDJBC0QMI0qmtmPxP0D
 Xe2hFT4FB0LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="435218100"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 24 May 2021 03:36:49 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 24 May 2021 03:36:48 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX606.gar.corp.intel.com (10.67.234.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 24 May 2021 16:06:46 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Mon, 24 May 2021 16:06:46 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>, Dan Williams <dcbw@redhat.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: RE: [PATCH V3 15/16] net: iosm: net driver
Thread-Topic: [PATCH V3 15/16] net: iosm: net driver
Thread-Index: AQHXTYDf3ngkxUF6iU2l0Qo14kud4art/2mAgAGScNA=
Date:   Mon, 24 May 2021 10:36:46 +0000
Message-ID: <90f93c17164a4d8299d17a02b1f15bfa@intel.com>
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
 <20210520140158.10132-16-m.chetan.kumar@intel.com>
 <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
In-Reply-To: <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.223.10.1]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTG9pYywNCg0KPiA+ICtzdGF0aWMgdm9pZCBpcGNfbmV0ZGV2X3NldHVwKHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYpIHt9DQo+ID4gKw0KPiA+ICtzdHJ1Y3QgaW9zbV93d2FuICppcGNfd3dhbl9p
bml0KHN0cnVjdCBpb3NtX2ltZW0gKmlwY19pbWVtLCBzdHJ1Y3QNCj4gPiArZGV2aWNlICpkZXYp
IHsNCj4gPiArICAgICAgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZV9vcHMgaW9zbV93
d2FuZGV2X29wcyA9IHt9Ow0KPiA+ICsgICAgICAgc3RydWN0IGlvc21fd3dhbiAqaXBjX3d3YW47
DQo+ID4gKyAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2Ow0KPiA+ICsNCj4gPiArICAg
ICAgIG5ldGRldiA9IGFsbG9jX25ldGRldihzaXplb2YoKmlwY193d2FuKSwgInd3YW4lZCIsDQo+
IE5FVF9OQU1FX0VOVU0sDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaXBjX25l
dGRldl9zZXR1cCk7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCFuZXRkZXYpDQo+ID4gKyAgICAg
ICAgICAgICAgIHJldHVybiBOVUxMOw0KPiA+ICsNCj4gPiArICAgICAgIGlwY193d2FuID0gbmV0
ZGV2X3ByaXYobmV0ZGV2KTsNCj4gPiArDQo+ID4gKyAgICAgICBpcGNfd3dhbi0+ZGV2ID0gZGV2
Ow0KPiA+ICsgICAgICAgaXBjX3d3YW4tPm5ldGRldiA9IG5ldGRldjsNCj4gPiArICAgICAgIGlw
Y193d2FuLT5pc19yZWdpc3RlcmVkID0gZmFsc2U7DQo+ID4gKw0KPiA+ICsgICAgICAgaXBjX3d3
YW4tPmlwY19pbWVtID0gaXBjX2ltZW07DQo+ID4gKw0KPiA+ICsgICAgICAgbXV0ZXhfaW5pdCgm
aXBjX3d3YW4tPmlmX211dGV4KTsNCj4gPiArDQo+ID4gKyAgICAgICAvKiBhbGxvY2F0ZSByYW5k
b20gZXRoZXJuZXQgYWRkcmVzcyAqLw0KPiA+ICsgICAgICAgZXRoX3JhbmRvbV9hZGRyKG5ldGRl
di0+ZGV2X2FkZHIpOw0KPiA+ICsgICAgICAgbmV0ZGV2LT5hZGRyX2Fzc2lnbl90eXBlID0gTkVU
X0FERFJfUkFORE9NOw0KPiA+ICsNCj4gPiArICAgICAgIG5ldGRldi0+bmV0ZGV2X29wcyA9ICZp
b3NtX3d3YW5kZXZfb3BzOw0KPiA+ICsgICAgICAgbmV0ZGV2LT5mbGFncyB8PSBJRkZfTk9BUlA7
DQo+ID4gKw0KPiA+ICsgICAgICAgU0VUX05FVERFVl9ERVZUWVBFKG5ldGRldiwgJnd3YW5fdHlw
ZSk7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKHJlZ2lzdGVyX25ldGRldihuZXRkZXYpKSB7DQo+
ID4gKyAgICAgICAgICAgICAgIGRldl9lcnIoaXBjX3d3YW4tPmRldiwgInJlZ2lzdGVyX25ldGRl
diBmYWlsZWQiKTsNCj4gPiArICAgICAgICAgICAgICAgZ290byByZWdfZmFpbDsNCj4gPiArICAg
ICAgIH0NCj4gDQo+IFNvIHlvdSByZWdpc3RlciBhIG5vLW9wIG5ldGRldiB3aGljaCBpcyBvbmx5
IHVzZWQgdG8gcmVwcmVzZW50IHRoZSBtb2RlbQ0KPiBpbnN0YW5jZSwgYW5kIHRvIGJlIHJlZmVy
ZW5jZWQgZm9yIGxpbmsgY3JlYXRpb24gb3ZlciBJT1NNIHJ0bmV0bGlua3M/DQoNClRoYXTigJlz
IGNvcnJlY3QgZHJpdmVyIGNyZWF0ZXMgd3dhbjAgKG5vLW9wIG5ldGRldikgdG8gcmVwcmVzZW50
IHRoZQ0KbW9kZW0gaW5zdGFuY2UgYW5kIGlzIHJlZmVyZW5jZWQgZm9yIGxpbmsgY3JlYXRpb24g
b3ZlciBJT1NNIHJ0bmV0bGlua3MuDQoNCj4gVGhlIG5ldyBXV0FOIGZyYW1ld29yayBjcmVhdGVz
IGEgbG9naWNhbCBXV0FOIGRldmljZSBpbnN0YW5jZSAoZS5nOw0KPiAvc3lzL2NsYXNzL3d3YW4w
KSwgSSB0aGluayBpdCB3b3VsZCBtYWtlIHNlbnNlIHRvIHVzZSBpdHMgaW5kZXggYXMgcGFyYW1l
dGVyDQo+IHdoZW4gY3JlYXRpbmcgdGhlIG5ldyBsaW5rcywgaW5zdGVhZCBvZiByZWx5aW5nIG9u
IHRoaXMgZHVtbXkgbmV0ZGV2LiBOb3RlDQo+IHRoYXQgZm9yIG5vdyB0aGUgd3dhbl9kZXZpY2Ug
aXMgcHJpdmF0ZSB0byB3d2FuX2NvcmUgYW5kIGNyZWF0ZWQgaW1wbGljaXRseQ0KPiBvbiB0aGUg
V1dBTiBjb250cm9sIHBvcnQgcmVnaXN0cmF0aW9uLg0KDQpJbiBvcmRlciB0byB1c2UgV1dBTiBk
ZXZpY2UgaW5zdGFuY2UgYW55IGFkZGl0aW9uYWwgY2hhbmdlcyByZXF1aXJlZCBpbnNpZGUNCnd3
YW5fY29yZSA/ICBPciBzaW1wbHkgcGFzc2luZyAvc3lzL2NsYXNzL3d3YW4wIGRldmljZSB0byBp
cCBsaW5rIGFkZCBpcyBlbm91Z2guDQoNCkNhbiB5b3UgcGxlYXNlIHNoYXJlIHVzIG1vcmUgZGV0
YWlscyBvbiB3d2FuX2NvcmUgY2hhbmdlcyhpZiBhbnkpL2hvdyB3ZSBzaG91bGQNCnVzZSAvc3lz
L2NsYXNzL3d3YW4wIGZvciBsaW5rIGNyZWF0aW9uID8NCg0KPiBNb3Jlb3ZlciBJIHdvbmRlciBp
ZiBpdCBjb3VsZCBhbHNvIGJlIHBvc3NpYmxlIHRvIGNyZWF0ZSBhIGdlbmVyaWMgV1dBTiBsaW5r
DQo+IHR5cGUgaW5zdGVhZCBvZiBjcmVhdGluZyB5ZXQtYW5vdGhlciBodyBzcGVjaWZpYyBvbmUs
IHRoYXQgY291bGQgYmVuZWZpdA0KPiBmdXR1cmUgV1dBTiBkcml2ZXJzLCBhbmQgc2ltcGxpZnkg
dXNlciBzaWRlIGludGVncmF0aW9uLCB3aXRoIGEgY29tbW9uDQo+IGludGVyZmFjZSB0byBjcmVh
dGUgbGlua3MgYW5kIG11bHRpcGxleCBQRE4gKGEgYml0IGxpa2Ugd2xhbiB2aWYpLg0KDQpDb21t
b24gaW50ZXJmYWNlIGNvdWxkIGJlbmVmaXQgYm90aCB3d2FuIGRyaXZlcnMgYW5kIHVzZXIgc2lk
ZSBpbnRlZ3JhdGlvbi4gDQpXV0FOIGZyYW1ld29yayBnZW5lcmFsaXplcyBXV0FOIGRldmljZSBj
b250cm9sIHBvcnQsIHdvdWxkIGl0IGFsc28gY29uc2lkZXINCldXQU4gbmV0ZGV2IHBhcnQgPyBJ
cyB0aGVyZSBhIHBsYW4gdG8gc3VwcG9ydCBzdWNoIGltcGxlbWVudGF0aW9uIGluc2lkZQ0Kd3dh
bl9jb3JlLg0KDQpSZWdhcmRzLA0KQ2hldGFuDQo=
