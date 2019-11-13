Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45233FBBED
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKMWzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:55:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:25412 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfKMWzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:55:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 14:55:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,302,1569308400"; 
   d="scan'208";a="194834550"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga007.jf.intel.com with ESMTP; 13 Nov 2019 14:55:17 -0800
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 Nov 2019 14:55:17 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.67]) with mapi id 14.03.0439.000;
 Wed, 13 Nov 2019 14:55:17 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "lariel@mellanox.com" <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AIAApZkAgATdTQCAAAKgAIAADVYAgAEmswCAAB1/AIAAD9cAgAAFF4CAAAqLgIAAHtuAgAxk/YA=
Date:   Wed, 13 Nov 2019 22:55:16 +0000
Message-ID: <fa3c4cfe6ed4db31bcdaff739ccad70fa1ec4a5e.camel@intel.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
         <20191031172330.58c8631a@cakuba.netronome.com>
         <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
         <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
         <20191101172102.2fc29010@cakuba.netronome.com>
         <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
         <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
         <20191104183516.64ba481b@cakuba.netronome.com>
         <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
         <20191105135536.5da90316@cakuba.netronome.com>
         <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
         <20191105151031.1e7c6bbc@cakuba.netronome.com>
         <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
         <20191105173841.43836ad7@cakuba.netronome.com>
In-Reply-To: <20191105173841.43836ad7@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
x-originating-ip: [10.166.244.172]
Content-Type: text/plain; charset="utf-8"
Content-ID: <22024DFA8A8B5B4681EF511E74BCB932@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCk9uIFR1ZSwgMjAxOS0xMS0wNSBhdCAxNzozOCAtMDgwMCwgSmFrdWIgS2lj
aW5za2kgd3JvdGU6DQo+IEluIHRoZSB1cHN0cmVhbSBjb21tdW5pdHksIGhvd2V2ZXIsIHdlIGNh
cmUgYWJvdXQgdGhlIHRlY2huaWNhbA0KPiBhc3BlY3RzLg0KPiANCj4gPiBhbmQgd2UgYWxsIGtu
b3cgdGhhdCBpdCBjb3VsZCB0YWtlIHllYXJzIGJlZm9yZSB3ZSBjYW4gc2l0IGJhY2sgYW5kDQo+
ID4gcmVsYXggdGhhdCB3ZSBnb3Qgb3VyIEwyIHN3aXRjaGluZyAuLiANCj4gDQo+IExldCdzIG5v
dCBiZSBkcmFtYXRpYy4gSXQgc2hvdWxkbid0IHRha2UgeWVhcnMgdG8gaW1wbGVtZW50IGJhc2lj
IEwyDQo+IHN3aXRjaGluZyBvZmZsb2FkLg0KDQpJIGhhZCBtZWFudCB0byBzZW5kIHNvbWV0aGlu
ZyBlYXJsaWVyIGluIHRoaXMgdGhyZWFkLCBidXQgbmV2ZXIgZ290DQphcm91bmQgdG8gaXQuIEkg
d2FudGVkIHRvIGFzayB5b3VyIG9waW5pb24gYW5kIGdldCBzb21lIGZlZWRiYWNrLg0KDQpXZSAo
SW50ZWwpIGhhdmUgcmVjZW50bHkgYmVlbiBpbnZlc3RpZ2F0aW5nIHVzZSBvZiBwb3J0IHJlcHJl
c2VudG9ycw0KZm9yIGVuYWJsaW5nIGludHJvc3BlY3Rpb24gYW5kIGNvbnRyb2wgb2YgVkZzIGlu
IHRoZSBob3N0IHN5c3RlbSBhZnRlcg0KdGhleSd2ZSBiZWVuIGFzc2lnbmVkIHRvIGEgdmlydHVh
bCBtYWNoaW5lLg0KDQpJIGhhZCBvcmlnaW5hbGx5IGJlZW4gdGhpbmtpbmcgb2YgYWRkaW5nIHRo
ZXNlIHBvcnQgcmVwcmVzZW50b3IgbmV0ZGV2cw0KYmVmb3JlIHdlIGZ1bGx5IGltcGxlbWVudCBz
d2l0Y2hkZXYgd2l0aCB0aGUgZS1zd2l0Y2ggb2ZmbG9hZHMuIFRoZQ0KaWRlYSB3YXMgdG8gbWln
cmF0ZSB0byB1c2luZyBwb3J0IHJlcHJlc2VudG9ycyBpbiBlaXRoZXIgY2FzZS4NCg0KSG93ZXZl
ciwgZnJvbSB3aGF0IGl0IGxvb2tzIGxpa2Ugb24gdGhpcyB0aHJlYWQsIHlvdSdkIHJhdGhlciBw
cm9wb3NlDQp0aGF0IHdlIGltcGxlbWVudCBzd2l0Y2hkZXYgd2l0aCBiYXNpYyBMMiBvZmZsb2Fk
Pw0KDQpJJ20gbm90IHRvbyBmYW1pbGlhciB3aXRoIHN3aXRjaGRldiwgKHRyeWluZyB0byByZWFk
IGFuZCBsZWFybiBhYm91dCBzbw0KdGhhdCB3ZSBjYW4gYmVnaW4gYWN0dWFsbHkgaW1wbGVtZW50
aW5nIGl0IGluIG91ciBuZXR3b3JrIGRyaXZlcnMpLg0KDQpCYXNlZCBvbiB5b3VyIGNvbW1lbnRz
IGFuZCBmZWVkYmFjayBpbiB0aGlzIHRocmVhZCwgaXQgc291bmRzIGxpa2Ugb3VyDQpvcmlnaW5h
bCBpZGVhIHRvIGhhdmUgYSAibGVnYWN5IHdpdGggcG9ydCByZXByZXNlbnRvcnMiIG1vZGUgaXMg
bm90DQpyZWFsbHkgc29tZXRoaW5nIHlvdSdkIGxpa2UsIGJlY2F1c2UgaXQgd291bGQgY29udGlu
dWUgdG8gZW5jb3VyYWdlDQphdm9pZGluZyBtaWdyYXRpbmcgZnJvbSBsZWdhY3kgc3RhY2sgdG8g
c3dpdGNoZGV2IG1vZGVsLg0KDQpCdXQsIGluc3RlYWQgb2YgdHJ5aW5nIHRvIGdvIGZ1bGx5IHRv
d2FyZHMgaW1wbGVtZW50aW5nIHN3aXRjaGRldiB3aXRoDQpjb21wbGljYXRlZCBPdlMgb2ZmbG9h
ZHMsIHdlIGNvdWxkIGRvIGEgc2ltcGxlciBhcHByb2FjaCB0aGF0IG9ubHkNCnN1cHBvcnRzIEwy
IG9mZmxvYWRzIGluaXRpYWxseSwgYW5kIGZyb20gdGhlc2UgY29tbWVudHMgaXQgc2VlbXMgdGhp
cw0KaXMgdGhlIGRpcmVjdGlvbiB5b3UnZCByYXRoZXIgdXBzdHJlYW0gcGVyc3VlPw0KDQo+IEkg
aGFkIGdpdmVuIHN3aXRjaGRldiBMMiBzb21lIHRob3VnaHQuIElESyB3aGF0IHlvdSdkIGNhbGwg
c2VyaW91cywgDQo+IEkgZG9uJ3QgaGF2ZSBjb2RlLiBXZSBhcmUgZG9pbmcgc29tZSByaWRpY3Vs
b3VzbHkgY29tcGxleCBPdlMNCj4gb2ZmbG9hZHMNCj4gd2hpbGUgbW9zdCBjdXN0b21lcnMganVz
dCBuZWVkIEwyIHBsdXMgbWF5YmUgVlhMQU4gZW5jYXAgYW5kIGJhc2ljDQo+IEFDTHMuIFdoaWNo
IHN3aXRjaGRldiBjYW4gZG8gdmVyeSBuaWNlbHkgdGhhbmtzIHRvIEN1bXVsdXMgZm9sa3MuDQoN
CkJhc2VkIG9uIHRoaXMsIGl0IHNvdW5kcyBsaWtlIHRoZSBzd2l0Y2hkZXYgQVBJIGNhbiBkbyB0
aGlzIEwyDQpvZmZsb2FkaW5nIGFuZCBkcml2ZXJzIHNpbXBseSBuZWVkIHRvIGVuYWJsZSBpdC4g
SWYgSSB1bmRlcnN0YW5kDQpjb3JyZWN0bHksIGl0ICByZXF1aXJlcyB0aGUgc3lzdGVtIGFkbWlu
aXN0cmF0b3IgdG8gcGxhY2UgdGhlIFZGIGRldmllcw0KaW50byBhIGJyaWRnZSwgcmF0aGVyIHRo
YW4gc2ltcGx5IGhhdmluZyB0aGUgYnJpZGdpbmcgaGlkZGVuIGluc2lkZSB0aGUNCmRldmljZS4N
Cg0KVGhhbmtzLA0KSmFrZQ0K
