Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B18DA4D4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392365AbfJQEoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:44:54 -0400
Received: from cvk-fw2.cvk.de ([194.39.189.12]:17924 "EHLO cvk-fw2.cvk.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730385AbfJQEox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 00:44:53 -0400
Received: from localhost (cvk-fw2 [127.0.0.1])
        by cvk-fw2.cvk.de (Postfix) with ESMTP id 46txR63vjPz4wNn;
        Thu, 17 Oct 2019 06:44:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cvk.de; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:message-id:date:date:subject
        :subject:from:from; s=mailcvk20190509; t=1571287490; x=
        1573101891; bh=lUcO772hhFBnlwKsqZinTpFD8Zyq0geB6kredK0/XWI=; b=Q
        HTlZor4vX9JYMb6KO8kIq1Nu14ZCOd5xkWiekCifUKmu4YU2YvdY1hrwg/Hcr51w
        FE3vPbkxp/OMWcIWIfspO2soFKS3I2/Gueeei4pVHTzDeZkN4fBJgs7euTxKg6f5
        wPNfjjvWiRzpqFo14P84wJQ1TUCQE76Ao7T1SX3TwQ2PrYV+X9xvEvSRhD8QZOVc
        vQOQpcMgV/+Z01YJDA+LQiM3dJkZpaHuWXlOjDwkYHCqK/hMrQ6/1h0TOsQzibMh
        GerYCg1HaQYx/1pBp2NQj+/cQ9Uo4c2d9hg6+UekZ4/6Grji1/7nogVKrBxsjJCJ
        keueXa8SaX4U6vxr/WkZA==
X-Virus-Scanned: by amavisd-new at cvk.de
Received: from cvk-fw2.cvk.de ([127.0.0.1])
        by localhost (cvk-fw2.cvk.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J7FbsVaoyh1m; Thu, 17 Oct 2019 06:44:50 +0200 (CEST)
Received: from cvk027.cvk.de (cvk027.cvk.de [10.1.0.22])
        by cvk-fw2.cvk.de (Postfix) with ESMTP;
        Thu, 17 Oct 2019 06:44:50 +0200 (CEST)
Received: from cvk038.intra.cvk.de (cvk038.intra.cvk.de [10.1.0.38])
        by cvk027.cvk.de (Postfix) with ESMTP id 77169843C0D;
        Thu, 17 Oct 2019 06:44:50 +0200 (CEST)
Received: from CVK038.intra.cvk.de ([::1]) by cvk038.intra.cvk.de ([::1]) with
 mapi id 14.03.0468.000; Thu, 17 Oct 2019 06:44:50 +0200
From:   "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Re: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Topic: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Index: AdWEpYsT6mrGD+8XSi6Ttc8//KcZ8g==
Date:   Thu, 17 Oct 2019 04:44:49 +0000
Message-ID: <EB8510AA7A943D43916A72C9B8F4181F62A09A2F@cvk038.intra.cvk.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.10.4]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-GBS-PROC: mBCtcOCtwCOp5vL6i/FxNRAYIcp0L4FaGGrBrvTT/no=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tm8gcHJvYmxlbS4gVGhpcyBpcyBleGFjdGx5IHRoZSB3YXkgSSd2ZSBhZGFwdGVkIGl0IG15c2Vs
Zi4gU28gbXkgdGVzdHMgc2VlbSB0byBiZSB2YWxpZC4NCg0KUmVnYXJkcywNCi0tDQpUaG9tYXMg
QmFydHNjaGllcw0KQ1ZLIElUIFN5c3RlbWUNCg0KLS0tLS1VcnNwcsO8bmdsaWNoZSBOYWNocmlj
aHQtLS0tLQ0KVm9uOiBFcmljIER1bWF6ZXQgW21haWx0bzplcmljLmR1bWF6ZXRAZ21haWwuY29t
XSANCkdlc2VuZGV0OiBNaXR0d29jaCwgMTYuIE9rdG9iZXIgMjAxOSAyMTo1NA0KQW46IEJhcnRz
Y2hpZXMsIFRob21hcyA8VGhvbWFzLkJhcnRzY2hpZXNAY3ZrLmRlPjsgJ0RhdmlkIEFoZXJuJyA8
ZHNhaGVybkBnbWFpbC5jb20+OyAnbmV0ZGV2QHZnZXIua2VybmVsLm9yZycgPG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc+DQpCZXRyZWZmOiBSZTogQVc6IGJpZyBJQ01QIHJlcXVlc3RzIGdldCBkaXNy
dXB0ZWQgb24gSVBTZWMgdHVubmVsIGFjdGl2YXRpb24NCg0KDQoNCk9uIDEwLzE2LzE5IDExOjU0
IEFNLCBCYXJ0c2NoaWVzLCBUaG9tYXMgd3JvdGU6DQo+IEhlbGxvLA0KPiANCj4gSSBoYWQgdG8g
YWRhcHQgdGhlIHNlY29uZCBoYWxmIHRvIG15IHRlc3Qga2VybmVsLiBKdXN0IGhhZCB0byBtYWtl
IHNvbWUgZ3Vlc3NlcywgdGVzdGVkLiBhbmQgaXQgd29ya3MuDQo+IFlvdXIgY29uY2x1c2lvbnMg
YXJlIGNvcnJlY3QuIEkgYWxzbyBzdXNwZWN0ZWQgc29tZXRoaW5nIGxpa2UgdGhhdCwgYnV0IHdp
dGggbm8ga25vd2xlZGdlIG9mIHRoZSBpbm5lcg0KPiB3b3JraW5ncyBvZiB0aGUgaXAgc3RhY2sg
SSBoYWQgdmVyeSBsaXR0bGUgY2hhbmNlcyB0byBmaW5kIHRoZSByaWdodCBmaXggYnkgbXlzZWxm
Lg0KPiANCj4gVGhhbmsgeW91IHZlcnkgbXVjaC4gV2lsbCByZXRlc3Qga25vdyBmb3IgYSBzZWNv
bmRhcnkgZm9yd2FyZGluZyBwcm9ibGVtIHRoYXQncyBtdWNoIGhhcmRlciB0byByZXByb2R1Y2Uu
DQo+IA0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5Lg0KDQpUaGUgcGF0Y2ggYmFja3BvcnRlZCB0byA1
LjIuMTggd291bGQgYmUgc29tZXRoaW5nIGxpa2UgOg0KDQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQv
aXBfb3V0cHV0LmMgYi9uZXQvaXB2NC9pcF9vdXRwdXQuYw0KaW5kZXggOGMyZWMzNWI2NTEyZjE0
ODZjZjJlYTAxZjRhMTk0NDRjNzQyMjY0Mi4uOTZjMDIxNDZiZTBhZjFlNjYyMzA2MjdiNDAxYzM1
NzU3ZjlkYzcwMiAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L2lwX291dHB1dC5jDQorKysgYi9uZXQv
aXB2NC9pcF9vdXRwdXQuYw0KQEAgLTYyNiw2ICs2MjYsNyBAQCBpbnQgaXBfZG9fZnJhZ21lbnQo
c3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsDQog
ICAgICAgIGlmIChza2JfaGFzX2ZyYWdfbGlzdChza2IpKSB7DQogICAgICAgICAgICAgICAgc3Ry
dWN0IHNrX2J1ZmYgKmZyYWcsICpmcmFnMjsNCiAgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQg
Zmlyc3RfbGVuID0gc2tiX3BhZ2VsZW4oc2tiKTsNCisgICAgICAgICAgICAgICBrdGltZV90IHRz
dGFtcCA9IHNrYi0+dHN0YW1wOw0KIA0KICAgICAgICAgICAgICAgIGlmIChmaXJzdF9sZW4gLSBo
bGVuID4gbXR1IHx8DQogICAgICAgICAgICAgICAgICAgICgoZmlyc3RfbGVuIC0gaGxlbikgJiA3
KSB8fA0KQEAgLTY4Nyw2ICs2ODgsNyBAQCBpbnQgaXBfZG9fZnJhZ21lbnQoc3RydWN0IG5ldCAq
bmV0LCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsDQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGlwX3NlbmRfY2hlY2soaXBoKTsNCiAgICAgICAgICAgICAgICAg
ICAgICAgIH0NCiANCisgICAgICAgICAgICAgICAgICAgICAgIHNrYi0+dHN0YW1wID0gdHN0YW1w
Ow0KICAgICAgICAgICAgICAgICAgICAgICAgZXJyID0gb3V0cHV0KG5ldCwgc2ssIHNrYik7DQog
DQogICAgICAgICAgICAgICAgICAgICAgICBpZiAoIWVycikNCg0KDQoNCj4gUmVnYXJkcywNCj4g
LS0NCj4gVGhvbWFzIEJhcnRzY2hpZXMNCj4gQ1ZLIElULVN5c3RlbWUNCj4gDQo+IC0tLS0tVXJz
cHLDvG5nbGljaGUgTmFjaHJpY2h0LS0tLS0NCj4gVm9uOiBFcmljIER1bWF6ZXQgW21haWx0bzpl
cmljLmR1bWF6ZXRAZ21haWwuY29tXSANCj4gR2VzZW5kZXQ6IE1pdHR3b2NoLCAxNi4gT2t0b2Jl
ciAyMDE5IDE3OjQxDQo+IEFuOiBCYXJ0c2NoaWVzLCBUaG9tYXMgPFRob21hcy5CYXJ0c2NoaWVz
QGN2ay5kZT47ICdEYXZpZCBBaGVybicgPGRzYWhlcm5AZ21haWwuY29tPjsgJ25ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcnIDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPg0KPiBCZXRyZWZmOiBSZTogYmln
IElDTVAgcmVxdWVzdHMgZ2V0IGRpc3J1cHRlZCBvbiBJUFNlYyB0dW5uZWwgYWN0aXZhdGlvbg0K
PiANCj4gT24gMTAvMTYvMTkgODozMSBBTSwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPj4NCj4+DQo+
PiBPbiAxMC8xNi8xOSA1OjU3IEFNLCBCYXJ0c2NoaWVzLCBUaG9tYXMgd3JvdGU6DQo+Pj4gSGVs
bG8sDQo+Pj4NCj4+PiBkaWQgYW5vdGhlciB0ZXN0LiBUaGlzIHRpbWUgSSd2ZSBjaGFuZ2VkIHRo
ZSBvcmRlci4gRmlyc3QgdHJpZ2dlcmVkIHRoZSBJUFNlYyBwb2xpY3kgYW5kIHRoZW4gdHJpZWQg
dG8gcGluZyBpbiBwYXJhbGxlbCB3aXRoIGEgYmlnIHBhY2tldCBzaXplLg0KPj4+IENvdWxkIGFs
c28gcmVwcm9kdWNlIHRoZSBpc3N1ZSwgYnV0IHRoZSB0cmFjZSB3YXMgY29tcGxldGVseSBkaWZm
ZXJlbnQuIE1heSBiZSB0aGlzIHRpbWUgSSd2ZSBnb3QgdGhlIHRyYWNlIGZvciB0aGUgcHJvYmxl
bWF0aWMgY29ubmVjdGlvbj8NCj4+Pg0KPj4NCj4+IFRoaXMgb25lIHdhcyBwcm9iYWJseSBhIGZh
bHNlIHBvc2l0aXZlLg0KPj4NCj4+IFRoZSBvdGhlciBvbmUsIEkgZmluYWxseSB1bmRlcnN0b29k
IHdoYXQgd2FzIGdvaW5nIG9uLg0KPj4NCj4+IFlvdSB0b2xkIHVzIHlvdSByZW1vdmVkIG5ldGZp
bHRlciwgYnV0IGl0IHNlZW1zIHlvdSBzdGlsbCBoYXZlIHRoZSBpcCBkZWZyYWcgbW9kdWxlcyB0
aGVyZS4NCj4+DQo+PiAoRm9yIGEgcHVyZSBmb3dhcmRpbmcgbm9kZSwgbm8gcmVhc3NlbWJseS1k
ZWZyYWcgc2hvdWxkIGJlIG5lZWRlZCkNCj4+DQo+PiBXaGVuIGlwX2ZvcndhcmQoKSBpcyB1c2Vk
LCBpdCBjb3JyZWN0bHkgY2xlYXJzIHNrYi0+dHN0YW1wDQo+Pg0KPj4gQnV0IGxhdGVyLCBpcF9k
b19mcmFnbWVudCgpIG1pZ2h0IHJlLXVzZSB0aGUgc2ticyBmb3VuZCBhdHRhY2hlZCB0byANCj4+
IHRoZSBtYXN0ZXIgc2tiIGFuZCB3ZSBkbyBub3QgaW5pdCBwcm9wZXJseSB0aGVpciBza2ItPnRz
dGFtcA0KPj4NCj4+IFRoZSBtYXN0ZXIgc2tiLT50c3RhbXAgc2hvdWxkIGJlIGNvcGllZCB0byB0
aGUgY2hpbGRyZW4uDQo+Pg0KPj4gSSB3aWxsIHNlbmQgYSBwYXRjaCBhc2FwLg0KPj4NCj4+IFRo
YW5rcy4NCj4+DQo+IA0KPiBDYW4geW91IHRyeSA6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2lw
djQvaXBfb3V0cHV0LmMgYi9uZXQvaXB2NC9pcF9vdXRwdXQuYyBpbmRleCAyOGZjYTQwODgxMmM1
NTc2ZmM0ZWE5NTdjMWM0ZGVjOTdlYzhmYWYzLi5jODgwMjI5YTAxNzEyYmE1YTllZDQxM2Y4YWFi
MmI1NmRmZTkzYzgyIDEwMDY0NA0KPiAtLS0gYS9uZXQvaXB2NC9pcF9vdXRwdXQuYw0KPiArKysg
Yi9uZXQvaXB2NC9pcF9vdXRwdXQuYw0KPiBAQCAtODA4LDYgKzgwOCw3IEBAIGludCBpcF9kb19m
cmFnbWVudChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYg
KnNrYiwNCj4gICAgICAgICBpZiAoc2tiX2hhc19mcmFnX2xpc3Qoc2tiKSkgew0KPiAgICAgICAg
ICAgICAgICAgc3RydWN0IHNrX2J1ZmYgKmZyYWcsICpmcmFnMjsNCj4gICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGludCBmaXJzdF9sZW4gPSBza2JfcGFnZWxlbihza2IpOw0KPiArICAgICAgICAg
ICAgICAga3RpbWVfdCB0c3RhbXAgPSBza2ItPnRzdGFtcDsNCj4gIA0KPiAgICAgICAgICAgICAg
ICAgaWYgKGZpcnN0X2xlbiAtIGhsZW4gPiBtdHUgfHwNCj4gICAgICAgICAgICAgICAgICAgICAo
KGZpcnN0X2xlbiAtIGhsZW4pICYgNykgfHwgQEAgLTg0Niw2ICs4NDcsNyBAQCBpbnQgaXBfZG9f
ZnJhZ21lbnQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZm
ICpza2IsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaXBfZnJhZ2xpc3RfcHJl
cGFyZShza2IsICZpdGVyKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiAgDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHNrYi0+dHN0YW1wID0gdHN0YW1wOw0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICBlcnIgPSBvdXRwdXQobmV0LCBzaywgc2tiKTsNCj4gIA0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICBpZiAoIWVycikNCj4gDQo=
