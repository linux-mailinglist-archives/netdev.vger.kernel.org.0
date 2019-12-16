Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6183F11FF9B
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfLPIVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:21:46 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2507 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfLPIVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 03:21:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576484503; x=1608020503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nU3lsK29ZgUoTlbhyj6jjItRr7BD2xPyS9qHp9tY2K0=;
  b=OAkMD3FOTghxh4ZIEiMaQHS3GHHuh5dNqynWy9jHO+X3hWoJ+4xWrPfT
   xMZpgpaa2/NMZmEpYkQTPBsIaL4ugGoxb9VIsn0XTCHaQYvCCwYbMj9rS
   WrBoeXbwktdaAh4F2pth16B+dX3jKgyYe8aVLYH9iWiK0UZcfkQEhxdAP
   Y=;
IronPort-SDR: JhN7tM7+A/kfXAb/h3zGms1jHOnhLt3GfRLOABDxUiEobWxjzxn7EKfi02+OuESzJmmxXS1gl8
 I8Gmhk6JrC2g==
X-IronPort-AV: E=Sophos;i="5.69,321,1571702400"; 
   d="scan'208";a="13696203"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Dec 2019 08:21:32 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id A31E2A1ECC;
        Mon, 16 Dec 2019 08:21:31 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Dec 2019 08:18:14 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Dec 2019 08:18:12 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Mon, 16 Dec 2019 08:18:12 +0000
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
Thread-Index: AQHVsPOiKWT/MKpGekOkpRko3pMZ46e23EKAgACxiQCAADwwIIAADN0AgAABjCCABJZBgIAAAHAQ
Date:   Mon, 16 Dec 2019 08:18:12 +0000
Message-ID: <09b986c4e89c428da3d9cdd05cd82c54@EX13D32EUC003.ant.amazon.com>
References: <20191212135406.26229-1-pdurrant@amazon.com>
 <20191212.110513.1770889236741616001.davem@davemloft.net>
 <cefcf3a4-fc10-d62a-cac9-81f0e47710a8@suse.com>
 <9f6d296e94744ce48d3f72fe4d3fd136@EX13D32EUC003.ant.amazon.com>
 <39762aba-7c47-6b79-b931-771bc16195a2@suse.com>
 <9c943511cb6b483f8f0da6ce05a614cb@EX13D32EUC003.ant.amazon.com>
 <169af9ff-9f2a-0fd5-82b5-05e75450445e@suse.com>
In-Reply-To: <169af9ff-9f2a-0fd5-82b5-05e75450445e@suse.com>
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
c3NAc3VzZS5jb20+DQo+IFNlbnQ6IDE2IERlY2VtYmVyIDIwMTkgMDg6MTANCj4gVG86IER1cnJh
bnQsIFBhdWwgPHBkdXJyYW50QGFtYXpvbi5jb20+OyBEYXZpZCBNaWxsZXINCj4gPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+DQo+IENjOiB4ZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmc7IHdlaS5s
aXVAa2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtYZW4tZGV2ZWxdIFtQQVRDSCBuZXQtbmV4
dF0geGVuLW5ldGJhY2s6IGdldCByaWQgb2Ygb2xkIHVkZXYNCj4gcmVsYXRlZCBjb2RlDQo+IA0K
PiBPbiAxMy4xMi4xOSAxMToxMiwgRHVycmFudCwgUGF1bCB3cm90ZToNCj4gPj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogSsO8cmdlbiBHcm/DnyA8amdyb3NzQHN1c2Uu
Y29tPg0KPiA+PiBTZW50OiAxMyBEZWNlbWJlciAyMDE5IDEwOjAyDQo+ID4+IFRvOiBEdXJyYW50
LCBQYXVsIDxwZHVycmFudEBhbWF6b24uY29tPjsgRGF2aWQgTWlsbGVyDQo+ID4+IDxkYXZlbUBk
YXZlbWxvZnQubmV0Pg0KPiA+PiBDYzogeGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnOyB3
ZWkubGl1QGtlcm5lbC5vcmc7IGxpbnV4LQ0KPiA+PiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFJlOiBbWGVuLWRldmVsXSBbUEFU
Q0ggbmV0LW5leHRdIHhlbi1uZXRiYWNrOiBnZXQgcmlkIG9mIG9sZA0KPiB1ZGV2DQo+ID4+IHJl
bGF0ZWQgY29kZQ0KPiA+Pg0KPiA+PiBPbiAxMy4xMi4xOSAxMDoyNCwgRHVycmFudCwgUGF1bCB3
cm90ZToNCj4gPj4+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+Pj4+IEZyb206IErD
vHJnZW4gR3Jvw58gPGpncm9zc0BzdXNlLmNvbT4NCj4gPj4+PiBTZW50OiAxMyBEZWNlbWJlciAy
MDE5IDA1OjQxDQo+ID4+Pj4gVG86IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47
IER1cnJhbnQsIFBhdWwNCj4gPj4+PiA8cGR1cnJhbnRAYW1hem9uLmNvbT4NCj4gPj4+PiBDYzog
eGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnOyB3ZWkubGl1QGtlcm5lbC5vcmc7IGxpbnV4
LQ0KPiA+Pj4+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPj4+PiBTdWJqZWN0OiBSZTogW1hlbi1kZXZlbF0gW1BBVENIIG5ldC1uZXh0XSB4ZW4tbmV0
YmFjazogZ2V0IHJpZCBvZiBvbGQNCj4gPj4gdWRldg0KPiA+Pj4+IHJlbGF0ZWQgY29kZQ0KPiA+
Pj4+DQo+ID4+Pj4gT24gMTIuMTIuMTkgMjA6MDUsIERhdmlkIE1pbGxlciB3cm90ZToNCj4gPj4+
Pj4gRnJvbTogUGF1bCBEdXJyYW50IDxwZHVycmFudEBhbWF6b24uY29tPg0KPiA+Pj4+PiBEYXRl
OiBUaHUsIDEyIERlYyAyMDE5IDEzOjU0OjA2ICswMDAwDQo+ID4+Pj4+DQo+ID4+Pj4+PiBJbiB0
aGUgcGFzdCBpdCB1c2VkIHRvIGJlIHRoZSBjYXNlIHRoYXQgdGhlIFhlbiB0b29sc3RhY2sgcmVs
aWVkDQo+IHVwb24NCj4gPj4+Pj4+IHVkZXYgdG8gZXhlY3V0ZSBiYWNrZW5kIGhvdHBsdWcgc2Ny
aXB0cy4gSG93ZXZlciB0aGlzIGhhcyBub3QgYmVlbg0KPiA+PiB0aGUNCj4gPj4+Pj4+IGNhc2Ug
Zm9yIG1hbnkgcmVsZWFzZXMgbm93IGFuZCByZW1vdmFsIG9mIHRoZSBhc3NvY2lhdGVkIGNvZGUg
aW4NCj4gPj4+Pj4+IHhlbi1uZXRiYWNrIHNob3J0ZW5zIHRoZSBzb3VyY2UgYnkgbW9yZSB0aGFu
IDEwMCBsaW5lcywgYW5kIHJlbW92ZXMNCj4gPj4+PiBtdWNoDQo+ID4+Pj4+PiBjb21wbGV4aXR5
IGluIHRoZSBpbnRlcmFjdGlvbiB3aXRoIHRoZSB4ZW5zdG9yZSBiYWNrZW5kIHN0YXRlLg0KPiA+
Pj4+Pj4NCj4gPj4+Pj4+IE5PVEU6IHhlbi1uZXRiYWNrIGlzIHRoZSBvbmx5IHhlbmJ1cyBkcml2
ZXIgdG8gaGF2ZSBhIGZ1bmN0aW9uYWwNCj4gPj4+PiB1ZXZlbnQoKQ0KPiA+Pj4+Pj4gICAgICAg
ICAgbWV0aG9kLiBUaGUgb25seSBvdGhlciBkcml2ZXIgdG8gaGF2ZSBhIG1ldGhvZCBhdCBhbGwg
aXMNCj4gPj4+Pj4+ICAgICAgICAgIHB2Y2FsbHMtYmFjaywgYW5kIGN1cnJlbnRseSBwdmNhbGxz
X2JhY2tfdWV2ZW50KCkgc2ltcGx5DQo+ID4+IHJldHVybnMNCj4gPj4+PiAwLg0KPiA+Pj4+Pj4g
ICAgICAgICAgSGVuY2UgdGhpcyBwYXRjaCBhbHNvIGZhY2lsaXRhdGVzIGZ1cnRoZXIgY2xlYW51
cC4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBQYXVsIER1cnJhbnQgPHBkdXJy
YW50QGFtYXpvbi5jb20+DQo+ID4+Pj4+DQo+ID4+Pj4+IElmIHVzZXJzcGFjZSBldmVyIHVzZWQg
dGhpcyBzdHVmZiwgSSBzZXJpb3VzbHkgZG91YnQgeW91IGNhbiByZW1vdmUNCj4gPj4gdGhpcw0K
PiA+Pj4+PiBldmVuIGlmIGl0IGhhc24ndCBiZWVuIHVzZWQgaW4gNSsgeWVhcnMuDQo+ID4+Pj4N
Cj4gPj4+PiBIbW0sIGRlcGVuZHMuDQo+ID4+Pj4NCj4gPj4+PiBUaGlzIGhhcyBiZWVuIHVzZWQg
YnkgWGVuIHRvb2xzIGluIGRvbTAgb25seS4gSWYgdGhlIGxhc3QgdXNhZ2UgaGFzDQo+ID4+IGJl
ZW4NCj4gPj4+PiBpbiBhIFhlbiB2ZXJzaW9uIHdoaWNoIGlzIG5vIGxvbmdlciBhYmxlIHRvIHJ1
biB3aXRoIGN1cnJlbnQgTGludXggaW4NCj4gPj4+PiBkb20wIGl0IGNvdWxkIGJlIHJlbW92ZWQu
IEJ1dCBJIGd1ZXNzIHRoaXMgd291bGQgaGF2ZSB0byBiZSBhIHJhdGhlcg0KPiA+PiBvbGQNCj4g
Pj4+PiB2ZXJzaW9uIG9mIFhlbiAobGlrZSAzLng/KS4NCj4gPj4+Pg0KPiA+Pj4+IFBhdWwsIGNh
biB5b3UgZ2l2ZSBhIGhpbnQgc2luY2Ugd2hpY2ggWGVuIHZlcnNpb24gdGhlIHRvb2xzdGFjayBu
bw0KPiA+Pj4+IGxvbmdlciByZWxpZXMgb24gdWRldiB0byBzdGFydCB0aGUgaG90cGx1ZyBzY3Jp
cHRzPw0KPiA+Pj4+DQo+ID4+Pg0KPiA+Pj4gVGhlIHVkZXYgcnVsZXMgd2VyZSBpbiBhIGZpbGUg
Y2FsbGVkIHRvb2xzL2hvdHBsdWcvTGludXgveGVuLQ0KPiA+PiBiYWNrZW5kLnJ1bGVzIChpbiB4
ZW4uZ2l0KSwgYW5kIGEgY29tbWl0IGZyb20gUm9nZXIgcmVtb3ZlZCB0aGUgTklDDQo+IHJ1bGVz
DQo+ID4+IGluIDIwMTI6DQo+ID4+Pg0KPiA+Pj4gY29tbWl0IDU3YWQ2YWZlMmEwOGEwM2M0MGJj
ZDMzNmJmYjI3ZTAwOGUxZDNlNTMNCj4gPj4NCj4gPj4gWGVuIDQuMg0KPiA+Pg0KPiA+Pj4gVGhl
IGxhc3QgY29tbWl0IEkgY291bGQgZmluZCB0byB0aGF0IGZpbGUgbW9kaWZpZWQgaXRzIG5hbWUg
dG8geGVuLQ0KPiA+PiBiYWNrZW5kLnJ1bGVzLmluLCBhbmQgdGhpcyB3YXMgZmluYWxseSByZW1v
dmVkIGJ5IEdlb3JnZSBpbiAyMDE1Og0KPiA+Pj4NCj4gPj4+IGNvbW1pdCAyYmEzNjhkMTM4OTM0
MDJiMmYxZmIzYzI4M2RkY2M3MTQ2NTlkZDliDQo+ID4+DQo+ID4+IFhlbiA0LjYNCj4gPj4NCj4g
Pj4+IFNvLCBJIHRoaW5rIHRoaXMgbWVhbnMgYW55b25lIHVzaW5nIGEgdmVyc2lvbiBvZiB0aGUg
WGVuIHRvb2xzIHdpdGhpbg0KPiA+PiByZWNlbnQgbWVtb3J5IHdpbGwgYmUgaGF2aW5nIHRoZWly
IGhvdHBsdWcgc2NyaXB0cyBjYWxsZWQgZGlyZWN0bHkgYnkNCj4gPj4gbGlieGwgKGFuZCBoYXZp
bmcgdWRldiBydWxlcyBwcmVzZW50IHdvdWxkIGFjdHVhbGx5IGJlIGNvdW50ZXItDQo+IHByb2R1
Y3RpdmUsDQo+ID4+IGFzIEdlb3JnZSdzIGNvbW1pdCBzdGF0ZXMgYW5kIGFzIEkgZGlzY292ZXJl
ZCB0aGUgaGFyZCB3YXkgd2hlbiB0aGUNCj4gY2hhbmdlDQo+ID4+IHdhcyBvcmlnaW5hbGx5IG1h
ZGUpLg0KPiA+Pg0KPiA+PiBUaGUgcHJvYmxlbSBhcmUgc3lzdGVtcyB3aXRoIGVpdGhlciBvbGQg
WGVuIHZlcnNpb25zIChiZWZvcmUgWGVuIDQuMikNCj4gb3INCj4gPj4gd2l0aCBvdGhlciB0b29s
c3RhY2tzIChlLmcuIFhlbiA0LjQgd2l0aCB4ZW5kKSB3aGljaCB3YW50IHRvIHVzZSBhIG5ldw0K
PiA+PiBkb20wIGtlcm5lbC4NCj4gPj4NCj4gPj4gQW5kIEknbSBub3Qgc3VyZSB0aGVyZSBhcmVu
J3Qgc3VjaCBzeXN0ZW1zIChlc3BlY2lhbGx5IGluIGNhc2Ugc29tZW9uZQ0KPiA+PiB3YW50cyB0
byBzdGljayB3aXRoIHhlbmQpLg0KPiA+Pg0KPiA+DQo+ID4gQnV0IHdvdWxkIHNvbWVvbmUgc3Rp
Y2tpbmcgd2l0aCBzdWNoIGFuIG9sZCB0b29sc3RhY2sgZXhwZWN0IHRvIHJ1biBvbg0KPiBhbiB1
bm1vZGlmaWVkIHVwc3RyZWFtIGRvbTA/IFRoZXJlIGhhcyB0byBiZSBzb21lIHdheSBpbiB3aGlj
aCB3ZSBjYW4NCj4gcmV0aXJlIG9sZCBjb2RlLg0KPiANCj4gQXMgbG9uZyBhcyB0aGVyZSBhcmUg
bm8gaHlwZXJ2aXNvciBpbnRlcmZhY2UgcmVsYXRlZCBpc3N1ZXMNCj4gcHJvaGliaXRpbmcgcnVu
bmluZyBkb20wIHVubW9kaWZpZWQgSSB0aGluayB0aGUgZXhwZWN0YXRpb24gdG8gYmUNCj4gYWJs
ZSB0byB1c2UgdGhlIGtlcm5lbCBpbiB0aGF0IGVudmlyb25tZW50IGlzIGZpbmUuDQo+IA0KDQpJ
IHRoaW5rIHdlIG5lZWQgYSBiZXR0ZXIgcG9saWN5IGluIGZ1dHVyZSB0aGVuIG90aGVyd2lzZSB3
ZSB3aWxsIG9ubHkgY29sbGVjdCBiYWdnYWdlLg0KDQo+IEFub3RoZXIgcXVlc3Rpb24gY29taW5n
IHVwIHdvdWxkIGJlOiBob3cgaXMgdGhpcyBoYW5kbGVkIGluIGEgZHJpdmVyDQo+IGRvbWFpbiBy
dW5uaW5nIG5ldGJhY2s/IFdoaWNoIGNvbXBvbmVudCBpcyBzdGFydGluZyB0aGUgaG90cGx1ZyBz
Y3JpcHQNCj4gdGhlcmU/IEkgZG9uJ3QgdGhpbmsgd2UgY2FuIGFzc3VtZSBhIHN0YW5kYXJkIFhl
biB0b29sc2V0IGluIHRoaXMgY2FzZS4NCj4gU28gSSdkIHJhdGhlciBsZWF2ZSB0aGlzIGNvZGUg
YXMgaXQgaXMgaW5zdGVhZCBvZiBicmVha2luZyBzb21lIHJhcmUNCj4gYnV0IHZhbGlkIHVzZSBj
YXNlcy4NCg0KSSBhbSBub3Qgc3VyZSB0aGVyZSBpcyBhIHN0YW5kYXJkLiBEbyB3ZSAnc3VwcG9y
dCcgZHJpdmVyIGRvbWFpbnMgd2l0aCBhbnkgc29ydCBvZiB0b29scyBBUEkgb3IgZG8gdGhleSBy
ZWFsbHkganVzdCBoYXZlIHRvIG5vdGljZSB0aGluZ3MgdmlhIHhlbnN0b3JlPyBJIGFncmVlIExp
bnV4IHJ1bm5pbmcgYXMgYSBkcml2ZXIgZG9tYWluIGNvdWxkIGluZGVlZCB1c2UgdWRldi4NCg0K
PiANCj4gPg0KPiA+IEFzaWRlIGZyb20gdGhlIHVkZXYga2lja3MgdGhvdWdoLCBJIHN0aWxsIHRo
aW5rIHRoZSBob3RwbHVnLXN0YXR1cy9yaW5nDQo+IHN0YXRlIGludGVyYWN0aW9uIGlzIGp1c3Qg
Ym9ndXMgYW55d2F5LiBBcyBJIHNhaWQgaW4gYSBwcmV2aW91cyB0aHJlYWQsDQo+IHRoZSBob3Rw
bHVnLXN0YXR1cyBvdWdodCB0byBiZSBpbmRpY2F0ZWQgYXMgY2FycmllciBzdGF0dXMsIGlmIGF0
IGFsbCwgc28NCj4gSSBzdGlsbCB0aGluayBhbGwgdGhhdCBjb2RlIG91Z2h0IHRvIGdvLg0KPiAN
Cj4gSSBhZ3JlZSByZWdhcmRpbmcgdGhlIGZ1dHVyZSBpbnRlcmZhY2UsIGJ1dCB3aXRoIHRoZSBj
YXJyaWVyIHN0YXRlIGp1c3QNCj4gYmVpbmcgaW4gdGhlIHBsYW5zIHRvIGJlIGFkZGVkIG5vdywg
aXQgaXMgY2xlYXJseSB0b28gZWFybHkgdG8gcmVtb3ZlDQo+IHRoZSBjb2RlIHdpdGggdGhhdCBy
ZWFzb25pbmcuDQoNCkkgZG9uJ3QgdGhpbmsgc28uIExpa2UgSSBzYWlkLCBJIHRoaW5rIHRoZSBo
b3RwbHVnIHN0YXR1cyBoYXMgbm90aGluZyB0byBkbyB3aXRoIHRoZSBzdGF0ZSBvZiB0aGUgc2hh
cmVkIHJpbmcuIEV2ZW4gd2l0aCB0aGUgY29kZSBhcy1pcywgbm90aGluZyBpbmZvcm1zIHRoZSBm
cm9udGVuZCBpZiB0aGUgbmV0aWYgaXMgc3Vic2VxdWVudGx5IGNsb3NlZCBvciByZS1wbHVtYmVk
LCBzbyB3aHkgbXVzdCB3ZSBjb250aW51ZSB0byBtYWludGFpbiB0aGlzIGNvZGU/IEFGQUlDVCBp
dCBpcyBqdXN0IG5vdCBmaXQgZm9yIHB1cnBvc2UuDQoNCiAgUGF1bA0K
