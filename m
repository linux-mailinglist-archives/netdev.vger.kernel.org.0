Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3524FB291F
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 02:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390843AbfINAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 20:38:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:62330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388932AbfINAi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 20:38:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 17:38:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,501,1559545200"; 
   d="scan'208";a="186613925"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga007.fm.intel.com with ESMTP; 13 Sep 2019 17:38:27 -0700
Received: from orsmsx163.amr.corp.intel.com (10.22.240.88) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Sep 2019 17:38:26 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.221]) by
 ORSMSX163.amr.corp.intel.com ([169.254.9.47]) with mapi id 14.03.0439.000;
 Fri, 13 Sep 2019 17:38:26 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Robert Beckett <bob.beckett@collabora.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] igb: add rx drop enable attribute
Thread-Topic: [PATCH v2] igb: add rx drop enable attribute
Thread-Index: AQHVapS4oMvB58LTRE65obxp5h0E+Q==
Date:   Sat, 14 Sep 2019 00:38:26 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971184AF@ORSMSX103.amr.corp.intel.com>
References: <20190909142117.20186-1-bob.beckett@collabora.com>
In-Reply-To: <20190909142117.20186-1-bob.beckett@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTA5IGF0IDE1OjIxICswMTAwLCBSb2JlcnQgQmVja2V0dCB3cm90ZToK
PiBUbyBhbGxvdyB1c2VybGFuZCB0byBlbmFibGUgb3IgZGlzYWJsZSBkcm9wcGluZyBwYWNrZXRz
IHdoZW4gZGVzY3JpcHRvcgo+IHJpbmcgaXMgZXhoYXVzdGVkLCBhZGQgUlhfRFJPUF9FTiBwcml2
YXRlIGZsYWcuCj4gCj4gVGhpcyBjYW4gYmUgdXNlZCBpbiBjb25qdW5jdGlvbiB3aXRoIGZsb3cg
Y29udHJvbCB0byBtaXRpZ2F0ZSBwYWNrZXQgc3Rvcm1zCj4gKGUuZy4gZHVlIHRvIG5ldHdvcmsg
bG9vcCBvciBEb1MpIGJ5IGZvcmNpbmcgdGhlIG5ldHdvcmsgYWRhcHRlciB0byBzZW5kCj4gcGF1
c2UgZnJhbWVzIHdoZW5ldmVyIHRoZSByaW5nIGlzIGNsb3NlIHRvIGV4aGF1c3Rpb24uCj4gCj4g
QnkgZGVmYXVsdCB0aGlzIHdpbGwgbWFpbnRhaW4gcHJldmlvdXMgYmVoYXZpb3VyIG9mIGVuYWJs
aW5nIGRyb3BwaW5nIG9mCj4gcGFja2V0cyBkdXJpbmcgcmluZyBidWZmZXIgZXhoYXVzdGlvbi4K
PiBTb21lIHVzZSBjYXNlcyBwcmVmZXIgdG8gbm90IGRyb3AgcGFja2V0cyB1cG9uIGV4aGF1c3Rp
b24sIGJ1dCBpbnN0ZWFkCj4gdXNlIGZsb3cgY29udHJvbCB0byBsaW1pdCBpbmdyZXNzIHJhdGVz
IGFuZCBlbnN1cmUgbm8gZHJvcHBlZCBwYWNrZXRzLgo+IFRoaXMgaXMgdXNlZnVsIHdoZW4gdGhl
IGhvc3QgQ1BVIGNhbm5vdCBrZWVwIHVwIHdpdGggcGFja2V0IGRlbGl2ZXJ5LAo+IGJ1dCBkYXRh
IGRlbGl2ZXJ5IGlzIG1vcmUgaW1wb3J0YW50IHRoYW4gdGhyb3VnaHB1dCB2aWEgbXVsdGlwbGUg
cXVldWVzLgo+IAo+IFVzZXJsYW5kIGNhbiBzZXQgdGhpcyBmbGFnIHRvIDAgdmlhIGV0aHRvb2wg
dG8gZGlzYWJsZSBwYWNrZXQgZHJvcHBpbmcuCj4gCj4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0IEJl
Y2tldHQgPGJvYi5iZWNrZXR0QGNvbGxhYm9yYS5jb20+Cj4gLS0tCj4gCj4gTm90ZXM6Cj4gICAg
IENoYW5nZXMgc2luY2UgdjE6IHJlLXdyaXR0ZW4gdG8gdXNlIGV0aHRvb2wgcHJpdiBmbGFncyBp
bnN0ZWFkIG9mIHN5c2ZzIGF0dHJpYnV0ZQo+IAo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pZ2IvaWdiLmggICAgICAgICB8ICAxICsKPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWdiL2lnYl9ldGh0b29sLmMgfCAgOCArKysrKysrKwo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pZ2IvaWdiX21haW4uYyAgICB8IDExICsrKysrKysrKy0tCj4gIDMgZmlsZXMgY2hhbmdl
ZCwgMTggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKClRlc3RlZC1ieTogQWFyb24gQnJv
d24gPGFhcm9uLmYuYnJvd25AaW50ZWwuY29tPgo=
