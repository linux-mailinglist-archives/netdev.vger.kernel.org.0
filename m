Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4975CD56
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGBKJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:09:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:34090 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbfGBKJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:09:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 02:27:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,442,1557212400"; 
   d="scan'208";a="247208758"
Received: from irsmsx152.ger.corp.intel.com ([163.33.192.66])
  by orsmga001.jf.intel.com with ESMTP; 02 Jul 2019 02:27:39 -0700
Received: from irsmsx103.ger.corp.intel.com ([169.254.3.140]) by
 IRSMSX152.ger.corp.intel.com ([169.254.6.79]) with mapi id 14.03.0439.000;
 Tue, 2 Jul 2019 10:27:38 +0100
From:   "Richardson, Bruce" <bruce.richardson@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Laatz, Kevin" <kevin.laatz@intel.com>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: RE: [PATCH 00/11] XDP unaligned chunk placement support
Thread-Topic: [PATCH 00/11] XDP unaligned chunk placement support
Thread-Index: AQHVJ4i5lf51JKLIg0itC+9xR96zh6asrBSAgAKnKQCAAKqjAIABPLiAgABF0QCABFa7gIAAboQAgADCFaA=
Date:   Tue, 2 Jul 2019 09:27:38 +0000
Message-ID: <59AF69C657FD0841A61C55336867B5B07ED8B210@IRSMSX103.ger.corp.intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
        <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
        <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
        <20190627142534.4f4b8995@cakuba.netronome.com>
        <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
        <BAE24CBF-416D-4665-B2C9-CE1F5EAE28FF@gmail.com>
        <07e404eb-f712-b15a-4884-315aff3f7c7d@intel.com>
 <20190701142002.1b17cc0b@cakuba.netronome.com>
In-Reply-To: <20190701142002.1b17cc0b@cakuba.netronome.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWI5MmI0MTAtOWQxYS00NTljLTgyMTctODU4NDg3ODU3NWRlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQzhtQ09KNStDWFRZMGtnc0VYN0dJVmdYRmljTUhPdHNRXC8wS2J1d2k4OFdDQmpVQzlkV3ptU3htVVdcLzhtNW9WIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
W21haWx0bzpqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUuY29tXQ0KPiBTZW50OiBNb25kYXksIEp1
bHkgMSwgMjAxOSAxMDoyMCBQTQ0KPiBUbzogTGFhdHosIEtldmluIDxrZXZpbi5sYWF0ekBpbnRl
bC5jb20+DQo+IENjOiBKb25hdGhhbiBMZW1vbiA8am9uYXRoYW4ubGVtb25AZ21haWwuY29tPjsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gYXN0QGtlcm5lbC5vcmc7IGRhbmllbEBpb2dlYXJi
b3gubmV0OyBUb3BlbCwgQmpvcm4NCj4gPGJqb3JuLnRvcGVsQGludGVsLmNvbT47IEthcmxzc29u
LCBNYWdudXMgPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+Ow0KPiBicGZAdmdlci5rZXJuZWwu
b3JnOyBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgUmljaGFyZHNvbiwgQnJ1Y2UN
Cj4gPGJydWNlLnJpY2hhcmRzb25AaW50ZWwuY29tPjsgTG9mdHVzLCBDaWFyYSA8Y2lhcmEubG9m
dHVzQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwMC8xMV0gWERQIHVuYWxpZ25l
ZCBjaHVuayBwbGFjZW1lbnQgc3VwcG9ydA0KPiANCj4gT24gTW9uLCAxIEp1bCAyMDE5IDE1OjQ0
OjI5ICswMTAwLCBMYWF0eiwgS2V2aW4gd3JvdGU6DQo+ID4gT24gMjgvMDYvMjAxOSAyMToyOSwg
Sm9uYXRoYW4gTGVtb24gd3JvdGU6DQo+ID4gPiBPbiAyOCBKdW4gMjAxOSwgYXQgOToxOSwgTGFh
dHosIEtldmluIHdyb3RlOg0KPiA+ID4+IE9uIDI3LzA2LzIwMTkgMjI6MjUsIEpha3ViIEtpY2lu
c2tpIHdyb3RlOg0KPiA+ID4+PiBJIHRoaW5rIHRoYXQncyB2ZXJ5IGxpbWl0aW5nLsKgIFdoYXQg
aXMgdGhlIGNoYWxsZW5nZSBpbiBwcm92aWRpbmcNCj4gPiA+Pj4gYWxpZ25lZCBhZGRyZXNzZXMs
IGV4YWN0bHk/DQo+ID4gPj4gVGhlIGNoYWxsZW5nZXMgYXJlIHR3by1mb2xkOg0KPiA+ID4+IDEp
IGl0IHByZXZlbnRzIHVzaW5nIGFyYml0cmFyeSBidWZmZXIgc2l6ZXMsIHdoaWNoIHdpbGwgYmUg
YW4gaXNzdWUNCj4gPiA+PiBzdXBwb3J0aW5nIGUuZy4ganVtYm8gZnJhbWVzIGluIGZ1dHVyZS4N
Cj4gPiA+PiAyKSBoaWdoZXIgbGV2ZWwgdXNlci1zcGFjZSBmcmFtZXdvcmtzIHdoaWNoIG1heSB3
YW50IHRvIHVzZSBBRl9YRFAsDQo+ID4gPj4gc3VjaCBhcyBEUERLLCBkbyBub3QgY3VycmVudGx5
IHN1cHBvcnQgaGF2aW5nIGJ1ZmZlcnMgd2l0aCAnZml4ZWQnDQo+ID4gPj4gYWxpZ25tZW50Lg0K
PiA+ID4+IMKgwqDCoCBUaGUgcmVhc29uIHRoYXQgRFBESyB1c2VzIGFyYml0cmFyeSBwbGFjZW1l
bnQgaXMgdGhhdDoNCj4gPiA+PiDCoMKgwqAgwqDCoMKgIC0gaXQgd291bGQgc3RvcCB0aGluZ3Mg
d29ya2luZyBvbiBjZXJ0YWluIE5JQ3Mgd2hpY2ggbmVlZA0KPiA+ID4+IHRoZSBhY3R1YWwgd3Jp
dGFibGUgc3BhY2Ugc3BlY2lmaWVkIGluIHVuaXRzIG9mIDFrIC0gdGhlcmVmb3JlIHdlDQo+ID4g
Pj4gbmVlZCAyaw0KPiA+ID4+ICsgbWV0YWRhdGEgc3BhY2UuDQo+ID4gPj4gwqDCoMKgIMKgwqDC
oCAtIHdlIHBsYWNlIHBhZGRpbmcgYmV0d2VlbiBidWZmZXJzIHRvIGF2b2lkIGNvbnN0YW50bHkN
Cj4gPiA+PiBoaXR0aW5nIHRoZSBzYW1lIG1lbW9yeSBjaGFubmVscyB3aGVuIGFjY2Vzc2luZyBt
ZW1vcnkuDQo+ID4gPj4gwqDCoMKgIMKgwqDCoCAtIGl0IGFsbG93cyB0aGUgYXBwbGljYXRpb24g
dG8gY2hvb3NlIHRoZSBhY3R1YWwgYnVmZmVyDQo+ID4gPj4gc2l6ZSBpdCB3YW50cyB0byB1c2Uu
DQo+ID4gPj4gwqDCoMKgIFdlIG1ha2UgdXNlIG9mIHRoZSBhYm92ZSB0byBhbGxvdyB1cyB0byBz
cGVlZCB1cCBwcm9jZXNzaW5nDQo+ID4gPj4gc2lnbmlmaWNhbnRseSBhbmQgYWxzbyByZWR1Y2Ug
dGhlIHBhY2tldCBidWZmZXIgbWVtb3J5IHNpemUuDQo+ID4gPj4NCj4gPiA+PiDCoMKgwqAgTm90
IGhhdmluZyBhcmJpdHJhcnkgYnVmZmVyIGFsaWdubWVudCBhbHNvIG1lYW5zIGFuIEFGX1hEUA0K
PiA+ID4+IGRyaXZlciBmb3IgRFBESyBjYW5ub3QgYmUgYSBkcm9wLWluIHJlcGxhY2VtZW50IGZv
ciBleGlzdGluZw0KPiA+ID4+IGRyaXZlcnMgaW4gdGhvc2UgZnJhbWV3b3Jrcy4gRXZlbiB3aXRo
IGEgbmV3IGNhcGFiaWxpdHkgdG8gYWxsb3cgYW4NCj4gPiA+PiBhcmJpdHJhcnkgYnVmZmVyIGFs
aWdubWVudCwgZXhpc3RpbmcgYXBwcyB3aWxsIG5lZWQgdG8gYmUgbW9kaWZpZWQNCj4gPiA+PiB0
byB1c2UgdGhhdCBuZXcgY2FwYWJpbGl0eS4NCj4gPiA+DQo+ID4gPiBTaW5jZSBhbGwgYnVmZmVy
cyBpbiB0aGUgdW1lbSBhcmUgdGhlIHNhbWUgY2h1bmsgc2l6ZSwgdGhlIG9yaWdpbmFsDQo+ID4g
PiBidWZmZXIgYWRkcmVzcyBjYW4gYmUgcmVjYWxjdWxhdGVkIHdpdGggc29tZSBtdWx0aXBseS9z
aGlmdCBtYXRoLg0KPiA+ID4gSG93ZXZlciwgdGhpcyBpcyBtb3JlIGV4cGVuc2l2ZSB0aGFuIGp1
c3QgYSBtYXNrIG9wZXJhdGlvbi4NCj4gPg0KPiA+IFllcywgd2UgY2FuIGRvIHRoaXMuDQo+IA0K
PiBUaGF0J2QgYmUgYmVzdCwgY2FuIERQREsgcmVhc29uYWJseSBndWFyYW50ZWUgdGhlIHNsaWNp
bmcgaXMgdW5pZm9ybT8NCj4gRS5nLiBpdCdzIG5vdCBkZXNwZXJhdGUgYnVmZmVyIHBvb2xzIHdp
dGggZGlmZmVyZW50IGJhc2VzPw0KDQpJdCdzIGdlbmVyYWxseSB1bmlmb3JtLCBidXQgaGFuZGxp
bmcgdGhlIGNyb3NzaW5nIG9mIChodWdlKXBhZ2UgYm91bmRhcmllcw0KY29tcGxpY2F0ZXMgdGhp
bmdzIGEgYml0LiBUaGVyZWZvcmUgSSB0aGluayB0aGUgZmluYWwgb3B0aW9uIGJlbG93DQppcyBi
ZXN0IGFzIGl0IGF2b2lkcyBhbnkgc3VjaCBwcm9ibGVtcy4NCg0KPiANCj4gPiBBbm90aGVyIG9w
dGlvbiB3ZSBoYXZlIGlzIHRvIGFkZCBhIHNvY2tldCBvcHRpb24gZm9yIHF1ZXJ5aW5nIHRoZQ0K
PiA+IG1ldGFkYXRhIGxlbmd0aCBmcm9tIHRoZSBkcml2ZXIgKGFzc3VtaW5nIGl0IGRvZXNuJ3Qg
dmFyeSBwZXIgcGFja2V0KS4NCj4gPiBXZSBjYW4gdXNlIHRoYXQgaW5mb3JtYXRpb24gdG8gZ2V0
IGJhY2sgdG8gdGhlIG9yaWdpbmFsIGFkZHJlc3MgdXNpbmcNCj4gPiBzdWJ0cmFjdGlvbi4NCj4g
DQo+IFVuZm9ydHVuYXRlbHkgdGhlIG1ldGFkYXRhIGRlcGVuZHMgb24gdGhlIHBhY2tldCBhbmQg
aG93IG11Y2ggaW5mbyB0aGUNCj4gZGV2aWNlIHdhcyBhYmxlIHRvIGV4dHJhY3QuICBTbyBpdCdz
IHZhcmlhYmxlIGxlbmd0aC4NCj4gDQo+ID4gQWx0ZXJuYXRpdmVseSwgd2UgY2FuIGNoYW5nZSB0
aGUgUnggZGVzY3JpcHRvciBmb3JtYXQgdG8gaW5jbHVkZSB0aGUNCj4gPiBtZXRhZGF0YSBsZW5n
dGguIFdlIGNvdWxkIGRvIHRoaXMgaW4gYSBjb3VwbGUgb2Ygd2F5cywgZm9yIGV4YW1wbGUsDQo+
ID4gcmF0aGVyIHRoYW4gcmV0dXJuaW5nIHRoZSBhZGRyZXNzIGFzIHRoZSBzdGFydCBvZiB0aGUg
cGFja2V0LCBpbnN0ZWFkDQo+ID4gcmV0dXJuIHRoZSBidWZmZXIgYWRkcmVzcyB0aGF0IHdhcyBw
YXNzZWQgaW4sIGFuZCBhZGRpbmcgYW5vdGhlcg0KPiA+IDE2LWJpdCBmaWVsZCB0byBzcGVjaWZ5
IHRoZSBzdGFydCBvZiBwYWNrZXQgb2Zmc2V0IHdpdGggdGhhdCBidWZmZXIuDQo+ID4gSWYgdXNp
bmcgYW5vdGhlciAxNi1iaXRzIG9mIHRoZSBkZXNjcmlwdG9yIHNwYWNlIGlzIG5vdCBkZXNpcmFi
bGUsIGFuDQo+ID4gYWx0ZXJuYXRpdmUgY291bGQgYmUgdG8gbGltaXQgdW1lbSBzaXplcyB0byBl
LmcuIDJeNDggYml0cyAoMjU2DQo+ID4gdGVyYWJ5dGVzIHNob3VsZCBiZSBlbm91Z2gsIHJpZ2h0
IDotKSApIGFuZCB1c2UgdGhlIHJlbWFpbmluZyAxNiBiaXRzDQo+ID4gb2YgdGhlIGFkZHJlc3Mg
YXMgYSBwYWNrZXQgb2Zmc2V0LiBPdGhlciB2YXJpYXRpb25zIG9uIHRoZXNlIGFwcHJvYWNoDQo+
ID4gYXJlIG9idmlvdXNseSBwb3NzaWJsZSB0b28uDQo+IA0KPiBTZWVtcyByZWFzb25hYmxlIHRv
IG1lLi4NCg0KSSB0aGluayB0aGlzIGlzIHByb2JhYmx5IHRoZSBiZXN0IHNvbHV0aW9uLCBhbmQg
YWxzbyBoYXMgdGhlIGFkdmFudGFnZSB0aGF0DQphIGJ1ZmZlciByZXRhaW5zIGl0cyBiYXNlIGFk
ZHJlc3MgdGhlIGZ1bGwgd2F5IHRocm91Z2ggdGhlIGN5Y2xlIG9mIFJ4IGFuZCBUeC4NCg==
