Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85A24501
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfEUAUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:20:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:62410 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfEUAUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 20:20:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 17:20:14 -0700
X-ExtLoop1: 1
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2019 17:20:13 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.30]) with mapi id 14.03.0415.000;
 Mon, 20 May 2019 17:20:13 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "luto@kernel.org" <luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Subject: Re: [PATCH v2] vmalloc: Fix issues with flush flag
Thread-Topic: [PATCH v2] vmalloc: Fix issues with flush flag
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwCAAAiygIAAGYEA
Date:   Tue, 21 May 2019 00:20:13 +0000
Message-ID: <3e7e674c1fe094cd8dbe0c8933db18be1a37d76d.camel@intel.com>
References: <20190520200703.15997-1-rick.p.edgecombe@intel.com>
         <90f8a4e1-aa71-0c10-1a91-495ba0cb329b@linux.ee>
         <c6020a01e81d08342e1a2b3ae7e03d55858480ba.camel@intel.com>
         <20190520.154855.2207738976381931092.davem@davemloft.net>
In-Reply-To: <20190520.154855.2207738976381931092.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <52C20D2E84AF29499A3F743E3C4592D6@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTIwIGF0IDE1OjQ4IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
PiBEYXRlOiBNb24sIDIwIE1heSAyMDE5IDIyOjE3OjQ5ICswMDAwDQo+IA0KPiA+IFRoYW5rcyBm
b3IgdGVzdGluZy4gU28gSSBndWVzcyB0aGF0IHN1Z2dlc3RzIGl0J3MgdGhlIFRMQiBmbHVzaA0K
PiA+IGNhdXNpbmcNCj4gPiB0aGUgcHJvYmxlbSBvbiBzcGFyYyBhbmQgbm90IGFueSBsYXp5IHB1
cmdlIGRlYWRsb2NrLiBJIGhhZCBzZW50DQo+ID4gTWVlbGlzDQo+ID4gYW5vdGhlciB0ZXN0IHBh
dGNoIHRoYXQganVzdCBmbHVzaGVkIHRoZSBlbnRpcmUgMCB0byBVTE9OR19NQVgNCj4gPiByYW5n
ZSB0bw0KPiA+IHRyeSB0byBhbHdheXMgdGhlIGdldCB0aGUgImZsdXNoIGFsbCIgbG9naWMgYW5k
IGFwcHJlbnRseSBpdCBkaWRuJ3QNCj4gPiBib290IG1vc3RseSBlaXRoZXIuIEl0IGFsc28gc2hv
d2VkIHRoYXQgaXQncyBub3QgZ2V0dGluZyBzdHVjaw0KPiA+IGFueXdoZXJlDQo+ID4gaW4gdGhl
IHZtX3JlbW92ZV9hbGlhcygpIGZ1bmN0aW9uLiBTb21ldGhpbmcganVzdCBoYW5ncyBsYXRlci4N
Cj4gDQo+IEkgd29uZGVyIGlmIGFuIGFkZHJlc3MgaXMgbWFraW5nIGl0IHRvIHRoZSBUTEIgZmx1
c2ggcm91dGluZXMgd2hpY2gNCj4gaXMNCj4gbm90IHBhZ2UgYWxpZ25lZC4NCkkgdGhpbmsgdm1h
bGxvYyBzaG91bGQgZm9yY2UgUEFHRV9TSVpFIGFsaWdubWVudCwgYnV0IHdpbGwgZG91YmxlIGNo
ZWNrDQpub3RoaW5nIGdvdCBzY3Jld2VkIHVwLg0KDQo+IE9yIGEgVExCIGZsdXNoIGlzIGJlaW5n
IGRvbmUgYmVmb3JlIHRoZSBjYWxsc2l0ZXMNCj4gYXJlIHBhdGNoZWQgcHJvcGVybHkgZm9yIHRo
ZSBnaXZlbiBjcHUgdHlwZS4NCkFueSBpZGVhIGhvdyBJIGNvdWxkIGxvZyB3aGVuIHRoaXMgaXMg
ZG9uZT8gSXQgbG9va3MgbGlrZSBpdCdzIGRvbmUNCnJlYWxseSBlYXJseSBpbiBib290IGFzc2Vt
Ymx5LiBUaGlzIGJlaGF2aW9yIHNob3VsZG4ndCBoYXBwZW4gdW50aWwNCm1vZHVsZXMgb3IgQlBG
IGFyZSBiZWluZyBmcmVlZC4NCg==
