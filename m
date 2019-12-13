Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26ED311E1C0
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 11:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLMKM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 05:12:56 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:44570 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLMKMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 05:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576231974; x=1607767974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7aPLpI4GaDwMm9i7Eo4lxJkaEJSJJONDgOobB5cWLic=;
  b=vJL7c1FTvY01dS/Vi6SJJUh93BsLdspumdxFX9HU/dbmitruIrN5xPVf
   ZKk/DGuq+WG4ht2CHIMdyhX22LGkOHfZZhuyle542DR0u9wTknw/XRM7V
   11Qew3JP4AY9WmwqrhyQHeR3sRKjIFBrokFZRBgJ7EOiPVweQJItpbHr8
   0=;
IronPort-SDR: s4yyinIa+9Dv3afYp/COqGQNBaFz0Yu8UlQAg/XS39zD0LV9JXmJAh4PIsW7h5NEB3NUE59t44
 kd19m5GRudfw==
X-IronPort-AV: E=Sophos;i="5.69,309,1571702400"; 
   d="scan'208";a="7478979"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 13 Dec 2019 10:12:53 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id CB24FA2692;
        Fri, 13 Dec 2019 10:12:51 +0000 (UTC)
Received: from EX13D32EUC004.ant.amazon.com (10.43.164.121) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Dec 2019 10:12:51 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC004.ant.amazon.com (10.43.164.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Dec 2019 10:12:50 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Fri, 13 Dec 2019 10:12:50 +0000
From:   "Durrant, Paul" <pdurrant@amazon.com>
To:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        David Miller <davem@davemloft.net>
CC:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
 related code
Thread-Topic: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
 related code
Thread-Index: AQHVsPOiKWT/MKpGekOkpRko3pMZ46e23EKAgACxiQCAADwwIIAADN0AgAABjCA=
Date:   Fri, 13 Dec 2019 10:12:49 +0000
Message-ID: <9c943511cb6b483f8f0da6ce05a614cb@EX13D32EUC003.ant.amazon.com>
References: <20191212135406.26229-1-pdurrant@amazon.com>
 <20191212.110513.1770889236741616001.davem@davemloft.net>
 <cefcf3a4-fc10-d62a-cac9-81f0e47710a8@suse.com>
 <9f6d296e94744ce48d3f72fe4d3fd136@EX13D32EUC003.ant.amazon.com>
 <39762aba-7c47-6b79-b931-771bc16195a2@suse.com>
In-Reply-To: <39762aba-7c47-6b79-b931-771bc16195a2@suse.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.122]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKw7xyZ2VuIEdyb8OfIDxqZ3Jv
c3NAc3VzZS5jb20+DQo+IFNlbnQ6IDEzIERlY2VtYmVyIDIwMTkgMTA6MDINCj4gVG86IER1cnJh
bnQsIFBhdWwgPHBkdXJyYW50QGFtYXpvbi5jb20+OyBEYXZpZCBNaWxsZXINCj4gPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+DQo+IENjOiB4ZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmc7IHdlaS5s
aXVAa2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtYZW4tZGV2ZWxdIFtQQVRDSCBuZXQtbmV4
dF0geGVuLW5ldGJhY2s6IGdldCByaWQgb2Ygb2xkIHVkZXYNCj4gcmVsYXRlZCBjb2RlDQo+IA0K
PiBPbiAxMy4xMi4xOSAxMDoyNCwgRHVycmFudCwgUGF1bCB3cm90ZToNCj4gPj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogSsO8cmdlbiBHcm/DnyA8amdyb3NzQHN1c2Uu
Y29tPg0KPiA+PiBTZW50OiAxMyBEZWNlbWJlciAyMDE5IDA1OjQxDQo+ID4+IFRvOiBEYXZpZCBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBEdXJyYW50LCBQYXVsDQo+ID4+IDxwZHVycmFu
dEBhbWF6b24uY29tPg0KPiA+PiBDYzogeGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnOyB3
ZWkubGl1QGtlcm5lbC5vcmc7IGxpbnV4LQ0KPiA+PiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFJlOiBbWGVuLWRldmVsXSBbUEFU
Q0ggbmV0LW5leHRdIHhlbi1uZXRiYWNrOiBnZXQgcmlkIG9mIG9sZA0KPiB1ZGV2DQo+ID4+IHJl
bGF0ZWQgY29kZQ0KPiA+Pg0KPiA+PiBPbiAxMi4xMi4xOSAyMDowNSwgRGF2aWQgTWlsbGVyIHdy
b3RlOg0KPiA+Pj4gRnJvbTogUGF1bCBEdXJyYW50IDxwZHVycmFudEBhbWF6b24uY29tPg0KPiA+
Pj4gRGF0ZTogVGh1LCAxMiBEZWMgMjAxOSAxMzo1NDowNiArMDAwMA0KPiA+Pj4NCj4gPj4+PiBJ
biB0aGUgcGFzdCBpdCB1c2VkIHRvIGJlIHRoZSBjYXNlIHRoYXQgdGhlIFhlbiB0b29sc3RhY2sg
cmVsaWVkIHVwb24NCj4gPj4+PiB1ZGV2IHRvIGV4ZWN1dGUgYmFja2VuZCBob3RwbHVnIHNjcmlw
dHMuIEhvd2V2ZXIgdGhpcyBoYXMgbm90IGJlZW4NCj4gdGhlDQo+ID4+Pj4gY2FzZSBmb3IgbWFu
eSByZWxlYXNlcyBub3cgYW5kIHJlbW92YWwgb2YgdGhlIGFzc29jaWF0ZWQgY29kZSBpbg0KPiA+
Pj4+IHhlbi1uZXRiYWNrIHNob3J0ZW5zIHRoZSBzb3VyY2UgYnkgbW9yZSB0aGFuIDEwMCBsaW5l
cywgYW5kIHJlbW92ZXMNCj4gPj4gbXVjaA0KPiA+Pj4+IGNvbXBsZXhpdHkgaW4gdGhlIGludGVy
YWN0aW9uIHdpdGggdGhlIHhlbnN0b3JlIGJhY2tlbmQgc3RhdGUuDQo+ID4+Pj4NCj4gPj4+PiBO
T1RFOiB4ZW4tbmV0YmFjayBpcyB0aGUgb25seSB4ZW5idXMgZHJpdmVyIHRvIGhhdmUgYSBmdW5j
dGlvbmFsDQo+ID4+IHVldmVudCgpDQo+ID4+Pj4gICAgICAgICBtZXRob2QuIFRoZSBvbmx5IG90
aGVyIGRyaXZlciB0byBoYXZlIGEgbWV0aG9kIGF0IGFsbCBpcw0KPiA+Pj4+ICAgICAgICAgcHZj
YWxscy1iYWNrLCBhbmQgY3VycmVudGx5IHB2Y2FsbHNfYmFja191ZXZlbnQoKSBzaW1wbHkNCj4g
cmV0dXJucw0KPiA+PiAwLg0KPiA+Pj4+ICAgICAgICAgSGVuY2UgdGhpcyBwYXRjaCBhbHNvIGZh
Y2lsaXRhdGVzIGZ1cnRoZXIgY2xlYW51cC4NCj4gPj4+Pg0KPiA+Pj4+IFNpZ25lZC1vZmYtYnk6
IFBhdWwgRHVycmFudCA8cGR1cnJhbnRAYW1hem9uLmNvbT4NCj4gPj4+DQo+ID4+PiBJZiB1c2Vy
c3BhY2UgZXZlciB1c2VkIHRoaXMgc3R1ZmYsIEkgc2VyaW91c2x5IGRvdWJ0IHlvdSBjYW4gcmVt
b3ZlDQo+IHRoaXMNCj4gPj4+IGV2ZW4gaWYgaXQgaGFzbid0IGJlZW4gdXNlZCBpbiA1KyB5ZWFy
cy4NCj4gPj4NCj4gPj4gSG1tLCBkZXBlbmRzLg0KPiA+Pg0KPiA+PiBUaGlzIGhhcyBiZWVuIHVz
ZWQgYnkgWGVuIHRvb2xzIGluIGRvbTAgb25seS4gSWYgdGhlIGxhc3QgdXNhZ2UgaGFzDQo+IGJl
ZW4NCj4gPj4gaW4gYSBYZW4gdmVyc2lvbiB3aGljaCBpcyBubyBsb25nZXIgYWJsZSB0byBydW4g
d2l0aCBjdXJyZW50IExpbnV4IGluDQo+ID4+IGRvbTAgaXQgY291bGQgYmUgcmVtb3ZlZC4gQnV0
IEkgZ3Vlc3MgdGhpcyB3b3VsZCBoYXZlIHRvIGJlIGEgcmF0aGVyDQo+IG9sZA0KPiA+PiB2ZXJz
aW9uIG9mIFhlbiAobGlrZSAzLng/KS4NCj4gPj4NCj4gPj4gUGF1bCwgY2FuIHlvdSBnaXZlIGEg
aGludCBzaW5jZSB3aGljaCBYZW4gdmVyc2lvbiB0aGUgdG9vbHN0YWNrIG5vDQo+ID4+IGxvbmdl
ciByZWxpZXMgb24gdWRldiB0byBzdGFydCB0aGUgaG90cGx1ZyBzY3JpcHRzPw0KPiA+Pg0KPiA+
DQo+ID4gVGhlIHVkZXYgcnVsZXMgd2VyZSBpbiBhIGZpbGUgY2FsbGVkIHRvb2xzL2hvdHBsdWcv
TGludXgveGVuLQ0KPiBiYWNrZW5kLnJ1bGVzIChpbiB4ZW4uZ2l0KSwgYW5kIGEgY29tbWl0IGZy
b20gUm9nZXIgcmVtb3ZlZCB0aGUgTklDIHJ1bGVzDQo+IGluIDIwMTI6DQo+ID4NCj4gPiBjb21t
aXQgNTdhZDZhZmUyYTA4YTAzYzQwYmNkMzM2YmZiMjdlMDA4ZTFkM2U1Mw0KPiANCj4gWGVuIDQu
Mg0KPiANCj4gPiBUaGUgbGFzdCBjb21taXQgSSBjb3VsZCBmaW5kIHRvIHRoYXQgZmlsZSBtb2Rp
ZmllZCBpdHMgbmFtZSB0byB4ZW4tDQo+IGJhY2tlbmQucnVsZXMuaW4sIGFuZCB0aGlzIHdhcyBm
aW5hbGx5IHJlbW92ZWQgYnkgR2VvcmdlIGluIDIwMTU6DQo+ID4NCj4gPiBjb21taXQgMmJhMzY4
ZDEzODkzNDAyYjJmMWZiM2MyODNkZGNjNzE0NjU5ZGQ5Yg0KPiANCj4gWGVuIDQuNg0KPiANCj4g
PiBTbywgSSB0aGluayB0aGlzIG1lYW5zIGFueW9uZSB1c2luZyBhIHZlcnNpb24gb2YgdGhlIFhl
biB0b29scyB3aXRoaW4NCj4gcmVjZW50IG1lbW9yeSB3aWxsIGJlIGhhdmluZyB0aGVpciBob3Rw
bHVnIHNjcmlwdHMgY2FsbGVkIGRpcmVjdGx5IGJ5DQo+IGxpYnhsIChhbmQgaGF2aW5nIHVkZXYg
cnVsZXMgcHJlc2VudCB3b3VsZCBhY3R1YWxseSBiZSBjb3VudGVyLXByb2R1Y3RpdmUsDQo+IGFz
IEdlb3JnZSdzIGNvbW1pdCBzdGF0ZXMgYW5kIGFzIEkgZGlzY292ZXJlZCB0aGUgaGFyZCB3YXkg
d2hlbiB0aGUgY2hhbmdlDQo+IHdhcyBvcmlnaW5hbGx5IG1hZGUpLg0KPiANCj4gVGhlIHByb2Js
ZW0gYXJlIHN5c3RlbXMgd2l0aCBlaXRoZXIgb2xkIFhlbiB2ZXJzaW9ucyAoYmVmb3JlIFhlbiA0
LjIpIG9yDQo+IHdpdGggb3RoZXIgdG9vbHN0YWNrcyAoZS5nLiBYZW4gNC40IHdpdGggeGVuZCkg
d2hpY2ggd2FudCB0byB1c2UgYSBuZXcNCj4gZG9tMCBrZXJuZWwuDQo+IA0KPiBBbmQgSSdtIG5v
dCBzdXJlIHRoZXJlIGFyZW4ndCBzdWNoIHN5c3RlbXMgKGVzcGVjaWFsbHkgaW4gY2FzZSBzb21l
b25lDQo+IHdhbnRzIHRvIHN0aWNrIHdpdGggeGVuZCkuDQo+IA0KDQpCdXQgd291bGQgc29tZW9u
ZSBzdGlja2luZyB3aXRoIHN1Y2ggYW4gb2xkIHRvb2xzdGFjayBleHBlY3QgdG8gcnVuIG9uIGFu
IHVubW9kaWZpZWQgdXBzdHJlYW0gZG9tMD8gVGhlcmUgaGFzIHRvIGJlIHNvbWUgd2F5IGluIHdo
aWNoIHdlIGNhbiByZXRpcmUgb2xkIGNvZGUuDQoNCkFzaWRlIGZyb20gdGhlIHVkZXYga2lja3Mg
dGhvdWdoLCBJIHN0aWxsIHRoaW5rIHRoZSBob3RwbHVnLXN0YXR1cy9yaW5nIHN0YXRlIGludGVy
YWN0aW9uIGlzIGp1c3QgYm9ndXMgYW55d2F5LiBBcyBJIHNhaWQgaW4gYSBwcmV2aW91cyB0aHJl
YWQsIHRoZSBob3RwbHVnLXN0YXR1cyBvdWdodCB0byBiZSBpbmRpY2F0ZWQgYXMgY2FycmllciBz
dGF0dXMsIGlmIGF0IGFsbCwgc28gSSBzdGlsbCB0aGluayBhbGwgdGhhdCBjb2RlIG91Z2h0IHRv
IGdvLg0KDQogIFBhdWwNCg0KPiANCj4gSnVlcmdlbg0K
