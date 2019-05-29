Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB3C2D500
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfE2FL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:11:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:52539 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfE2FL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 01:11:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 22:11:55 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga005.fm.intel.com with ESMTP; 28 May 2019 22:11:54 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.7]) with mapi id 14.03.0415.000;
 Tue, 28 May 2019 22:11:53 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "namit@vmware.com" <namit@vmware.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Subject: Re: [PATCH v5 0/2] Fix issues with vmalloc flush flag
Thread-Topic: [PATCH v5 0/2] Fix issues with vmalloc flush flag
Thread-Index: AQHVFNC+iT2yoslPq0S8A9En17xWb6aBtS+AgABQlQA=
Date:   Wed, 29 May 2019 05:11:52 +0000
Message-ID: <abb649f0f076777346cbe6a8a0e5d9f8b3c26b41.camel@intel.com>
References: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
         <20190528.172327.2113097810388476996.davem@davemloft.net>
In-Reply-To: <20190528.172327.2113097810388476996.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.252.134.167]
Content-Type: text/plain; charset="utf-8"
Content-ID: <63D338040718464F89739E472722ADD9@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA1LTI4IGF0IDE3OjIzIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gRGF0
ZTogTW9uLCAyNyBNYXkgMjAxOSAxNDoxMDo1NiAtMDcwMA0KPiANCj4gPiBUaGVzZSB0d28gcGF0
Y2hlcyBhZGRyZXNzIGlzc3VlcyB3aXRoIHRoZSByZWNlbnRseSBhZGRlZA0KPiA+IFZNX0ZMVVNI
X1JFU0VUX1BFUk1TIHZtYWxsb2MgZmxhZy4NCj4gPiANCj4gPiBQYXRjaCAxIGFkZHJlc3NlcyBh
biBpc3N1ZSB0aGF0IGNvdWxkIGNhdXNlIGEgY3Jhc2ggYWZ0ZXIgb3RoZXINCj4gPiBhcmNoaXRl
Y3R1cmVzIGJlc2lkZXMgeDg2IHJlbHkgb24gdGhpcyBwYXRoLg0KPiA+IA0KPiA+IFBhdGNoIDIg
YWRkcmVzc2VzIGFuIGlzc3VlIHdoZXJlIGluIGEgcmFyZSBjYXNlIHN0cmFuZ2UgYXJndW1lbnRz
DQo+ID4gY291bGQgYmUgcHJvdmlkZWQgdG8gZmx1c2hfdGxiX2tlcm5lbF9yYW5nZSgpLiANCj4g
DQo+IEl0IGp1c3Qgb2NjdXJyZWQgdG8gbWUgYW5vdGhlciBzaXR1YXRpb24gdGhhdCB3b3VsZCBj
YXVzZSB0cm91YmxlIG9uDQo+IHNwYXJjNjQsIGFuZCB0aGF0J3MgaWYgc29tZW9uZSB0aGUgYWRk
cmVzcyByYW5nZSBvZiB0aGUgbWFpbiBrZXJuZWwNCj4gaW1hZ2UgZW5kZWQgdXAgYmVpbmcgcGFz
c2VkIHRvIGZsdXNoX3RsYl9rZXJuZWxfcmFuZ2UoKS4NCj4gDQo+IFRoYXQgd291bGQgZmx1c2gg
dGhlIGxvY2tlZCBrZXJuZWwgbWFwcGluZyBhbmQgY3Jhc2ggdGhlIGtlcm5lbA0KPiBpbnN0YW50
bHkgaW4gYSBjb21wbGV0ZWx5IG5vbi1yZWNvdmVyYWJsZSB3YXkuDQoNCkhtbSwgSSBoYXZlbid0
IHJlY2VpdmVkIHRoZSBsb2dzIGZyb20gTWVlbGlzIHRoYXQgd2lsbCBzaG93IHRoZSByZWFsDQpy
YW5nZXMgYmVpbmcgcGFzc2VkIGludG8gZmx1c2hfdGxiX2tlcm5lbF9yYW5nZSgpIG9uIHNwYXJj
LCBidXQgaXQNCnNob3VsZCBiZSBmbHVzaGluZyBhIHJhbmdlIHNwYW5uaW5nIGZyb20gdGhlIG1v
ZHVsZXMgdG8gdGhlIGRpcmVjdCBtYXAuDQpJdCBsb29rcyBsaWtlIHRoZSBrZXJuZWwgaXMgYXQg
dGhlIHZlcnkgYm90dG9tIG9mIHRoZSBhZGRyZXNzIHNwYWNlLCBzbw0Kbm90IGluY2x1ZGVkLiBP
ciBkbyB5b3UgbWVhbiB0aGUgcGFnZXMgdGhhdCBob2xkIHRoZSBrZXJuZWwgdGV4dCBvbiB0aGUN
CmRpcmVjdCBtYXA/DQoNCkJ1dCByZWdhcmRsZXNzIG9mIHRoaXMgbmV3IGNvZGUsIERFQlVHX1BB
R0VBTExPQyBoYW5ncyB3aXRoIHRoZSBmaXJzdA0Kdm1hbGxvYyBmcmVlL3VubWFwLiBUaGF0IHNo
b3VsZCBiZSBqdXN0IGZsdXNoaW5nIGEgc2luZ2xlIGFsbG9jYXRpb24gaW4NCnRoZSB2bWFsbG9j
IHJhbmdlLg0KDQpJZiBpdCBpcyBzb21laG93IGNhdGNoaW5nIGEgbG9ja2VkIGVudHJ5IHRob3Vn
aC4uLiBBcmUgdGhlcmUgYW55IHNwYXJjDQpmbHVzaCBtZWNoYW5pc21zIHRoYXQgY291bGQgYmUg
dXNlZCBpbiB2bWFsbG9jIHRoYXQgd29uJ3QgdG91Y2ggbG9ja2VkDQplbnRyaWVzPyBQZXRlciBa
IHdhcyBwb2ludGluZyBvdXQgdGhhdCBmbHVzaF90bGJfYWxsKCkgbWlnaHQgYmUgbW9yZQ0KYXBw
cm9yaWF0ZSBmb3Igdm1hbGxvYyBhbnl3YXkuDQoNCg==
