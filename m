Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38B7B4842
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392628AbfIQH2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:28:11 -0400
Received: from cvk-fw2.cvk.de ([194.39.189.12]:44446 "EHLO cvk-fw2.cvk.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731582AbfIQH2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 03:28:10 -0400
Received: from localhost (cvk-fw2 [127.0.0.1])
        by cvk-fw2.cvk.de (Postfix) with ESMTP id 46XZTM6k0Fz4wMk;
        Tue, 17 Sep 2019 09:28:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cvk.de; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from; s=
        mailcvk20190509; t=1568705287; x=1570519688; bh=tTYXIaPtSdopDafi
        tyEV0BQnACXM5EtBHrM/bzxGIYo=; b=bU/amVoNGtFR6SbID5c9NlYwfBLUtOXZ
        JCot7lxYZApgwdB3fiX8n5xDdmGIMVj6l39ak2q5CmbsBs/3wvAerYdAuH2i+nyN
        USwKhN82EcGhsjRSJwm6jwnORlrULlPIkWkj1pq5zq5vJYO2MSIDEvlraqvvdBLy
        dk3Vmwqp9ZSqEIh1hSy0/5ASZR53nBQnLzHYE9EhG4JjKkwIiWoUZojMZ7bDYp3Z
        vPwmZfEIUqWpmOYY1liG3acjL0Kt1q2LYJvXXzpsUrvPNJlHYNb+HzjiFkCCx/RG
        IOjRQah17GNsNUgOk1JPtXdEeN3ksjeWdFZae/9TFCnIzd30ENkBeg==
X-Virus-Scanned: by amavisd-new at cvk.de
Received: from cvk-fw2.cvk.de ([127.0.0.1])
        by localhost (cvk-fw2.cvk.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id H4sOSSSjgDwg; Tue, 17 Sep 2019 09:28:07 +0200 (CEST)
Received: from cvk017.cvk.de (cvk017 [10.1.0.17])
        by cvk-fw2.cvk.de (Postfix) with ESMTP;
        Tue, 17 Sep 2019 09:28:07 +0200 (CEST)
Received: from cvk038.intra.cvk.de (cvk038.intra.cvk.de [10.1.0.38])
        by cvk017.cvk.de (Postfix) with ESMTP id 3B53686048E;
        Tue, 17 Sep 2019 09:28:08 +0200 (CEST)
Received: from CVK038.intra.cvk.de ([::1]) by cvk038.intra.cvk.de ([::1]) with
 mapi id 14.03.0468.000; Tue, 17 Sep 2019 09:28:07 +0200
From:   "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>
To:     'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: AW: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Topic: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Index: AdVqDuxpNdDfEB5ERA+Q1nyhyK5bhAANt6yAALhjMUA=
Date:   Tue, 17 Sep 2019 07:28:07 +0000
Message-ID: <EB8510AA7A943D43916A72C9B8F4181F629DD75A@cvk038.intra.cvk.de>
References: <EB8510AA7A943D43916A72C9B8F4181F629D9741@cvk038.intra.cvk.de>
 <d0c8ebbb-3ed3-296f-d84a-6f88e641b404@gmail.com>
In-Reply-To: <d0c8ebbb-3ed3-296f-d84a-6f88e641b404@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.10.4]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-GBS-PROC: 5zoD1qfZ1bhzGU/FjtQuf6Tc4TGHlnbic/TgZ+nbSzA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCnRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24uIFJ1bm5pbmcgcG10dS5zaCB3aXRo
IGtlcm5lbCB2ZXJzaW9ucyA0LjE5LCA0LjIwIGFuZCBldmVuIDUuMi4xMyBtYWRlIG5vIGRpZmZl
cmVuY2UuIEFsbCB0ZXN0cyB3ZXJlIHN1Y2Nlc3NmdWwgZXZlcnkgdGltZS4NCg0KQWx0aG91Z2gg
bXkgZXh0ZXJuYWwgcGluZyB0ZXN0cyBzdGlsbCBmYWlsaW5nIHdpdGggdGhlIG5ld2VyIGtlcm5l
bHMuIEkndmUgcmFuIHRoZSBzY3JpcHQgYWZ0ZXIgdHJpZ2dlcmluZyBteSBwcm9ibGVtLCB0byBt
YWtlIHN1cmUgYWxsIHBvc3NpYmxlIHNpZGUgZWZmZWN0cw0KaGFwcGVuaW5nLiANCg0KUGxlYXNl
IGtlZXAgaW4gbWluZCwgdGhhdCBldmVuIHdoZW4gdGhlIElDTVAgcmVxdWVzdHMgc3RhbGxpbmcs
IG90aGVyIGNvbm5lY3Rpb25zIHN0aWxsIGdvaW5nIHRocm91Z2guIExpa2UgZS5nLiBzc2ggb3Ig
dHJhY2VwYXRoLiBJIHdvdWxkIGV4cGVjdCB0aGF0DQphbGwgY29ubmVjdGlvbiB0eXBlcyB3b3Vs
ZCBiZSBhZmZlY3RlZCBpZiB0aGlzIGlzIGEgTVRVIHByb2JsZW0uIEFtIEkgd3Jvbmc/DQoNCkFu
eSBzdWdnZXN0aW9ucyBmb3IgbW9yZSB0ZXN0cyB0byBpc29sYXRlIHRoZSBjYXVzZT8gDQoNCkJl
c3QgcmVnYXJkcywNCi0tDQpUaG9tYXMgQmFydHNjaGllcw0KQ1ZLIElUIFN5c3RlbWUNCg0KLS0t
LS1VcnNwcsO8bmdsaWNoZSBOYWNocmljaHQtLS0tLQ0KVm9uOiBEYXZpZCBBaGVybiBbbWFpbHRv
OmRzYWhlcm5AZ21haWwuY29tXSANCkdlc2VuZGV0OiBGcmVpdGFnLCAxMy4gU2VwdGVtYmVyIDIw
MTkgMTk6MTMNCkFuOiBCYXJ0c2NoaWVzLCBUaG9tYXMgPFRob21hcy5CYXJ0c2NoaWVzQGN2ay5k
ZT47ICduZXRkZXZAdmdlci5rZXJuZWwub3JnJyA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCkJl
dHJlZmY6IFJlOiBiaWcgSUNNUCByZXF1ZXN0cyBnZXQgZGlzcnVwdGVkIG9uIElQU2VjIHR1bm5l
bCBhY3RpdmF0aW9uDQoNCk9uIDkvMTMvMTkgOTo1OSBBTSwgQmFydHNjaGllcywgVGhvbWFzIHdy
b3RlOg0KPiBIZWxsbyB0b2dldGhlciwNCj4gDQo+IHNpbmNlIGtlbmVsIDQuMjAgd2UncmUgb2Jz
ZXJ2aW5nIGEgc3RyYW5nZSBiZWhhdmlvdXIgd2hlbiBzZW5kaW5nIGJpZyBJQ01QIHBhY2tldHMu
IEFuIGV4YW1wbGUgaXMgYSBwYWNrZXQgc2l6ZSBvZiAzMDAwIGJ5dGVzLg0KPiBUaGUgcGFja2V0
cyBzaG91bGQgYmUgZm9yd2FyZGVkIGJ5IGEgbGludXggZ2F0ZXdheSAoZmlyZXdhbGwpIGhhdmlu
ZyBtdWx0aXBsZSBpbnRlcmZhY2VzIGFsc28gYWN0aW5nIGFzIGEgdnBuIGdhdGV3YXkuDQo+IA0K
PiBUZXN0IHN0ZXBzOg0KPiAxLiBEaXNhYmxlZCBhbGwgaXB0YWJsZXMgcnVsZXMNCj4gMi4gRW5h
YmxlZCB0aGUgVlBOIElQU2VjIFBvbGljaWVzLg0KPiAzLiBTdGFydCBhIHBpbmcgd2l0aCBwYWNr
ZXQgc2l6ZSAoZS5nLiAzMDAwIGJ5dGVzKSBmcm9tIGEgY2xpZW50IGluIA0KPiB0aGUgRE1aIHBh
c3NpbmcgdGhlIG1hY2hpbmUgdGFyZ2V0aW5nIGFub3RoZXIgTEFOIG1hY2hpbmUgNC4gUGluZyAN
Cj4gd29ya3MgNS4gRW5hYmxlIGEgVlBOIHBvbGljeSBieSBzZW5kaW5nIHBpbmdzIGZyb20gdGhl
IGdhdGV3YXkgdG8gYSANCj4gdHVubmVsIHRhcmdldC4gU3lzdGVtIHRyaWVzIHRvIGNyZWF0ZSB0
aGUgdHVubmVsIDYuIFBpbmcgZnJvbSAzLiBpbW1lZGlhdGVseSBzdGFsbHMuIE5vIGVycm9yIG1l
c3NhZ2VzLiBKdXN0IHN0b3BzLg0KPiA3LiBTdG9wIFBpbmcgZnJvbSAzLiBTdGFydCBhbm90aGVy
IHdpdGhvdXQgcGFja2V0IHNpemUgcGFyYW1ldGVyLiBTdGFsbHMgYWxzby4NCj4gDQo+IFJlc3Vs
dDoNCj4gQ29ubmVjdGlvbnMgZnJvbSB0aGUgY2xpZW50IHRvIG90aGVyIHNlcnZpY2VzIG9uIHRo
ZSBMQU4gbWFjaGluZSBzdGlsbCANCj4gd29yay4gVHJhY2VwYXRoIHdvcmtzLiBPbmx5IElDTVAg
cmVxdWVzdHMgZG8gbm90IHBhc3MgdGhlIGdhdGV3YXkgDQo+IGFueW1vcmUuIHRjcGR1bXAgc2Vl
cyB0aGVtIG9uIGluY29taW5nIGludGVyZmFjZSwgYnV0IG5vdCBvbiB0aGUgb3V0Z29pbmcgTEFO
IGludGVyZmFjZS4gSU1DUCByZXF1ZXN0cyB0byBhbnkgb3RoZXIgdGFyZ2V0IElQIGFkZHJlc3Mg
aW4gTEFOIHN0aWxsIHdvcmsuIFVudGlsIG9uZSB1c2VzIGEgYmlnZ2VyIHBhY2tldCBzaXplLiBU
aGVuIHRoZXNlIGFsdGVybmF0aXZlIGNvbm5lY3Rpb25zIHN0YWxsIGFsc28uDQo+IA0KPiBGbHVz
aGluZyB0aGUgcG9saWN5IHRhYmxlIGhhcyBubyBlZmZlY3QuIEZsdXNoaW5nIHRoZSBjb25udHJh
Y2sgdGFibGUgaGFzIG5vIGVmZmVjdC4gU2V0dGluZyBycF9maWx0ZXIgdG8gbG9vc2UgKDIpIGhh
cyBubyBlZmZlY3QuDQo+IEZsdXNoIHRoZSByb3V0ZSBjYWNoZSBoYXMgbm8gZWZmZWN0Lg0KPiAN
Cj4gT25seSBhIHJlYm9vdCBvZiB0aGUgZ2F0ZXdheSByZXN0b3JlcyBub3JtYWwgYmVoYXZpb3Iu
DQo+IA0KPiBXaGF0IGNhbiBiZSB0aGUgY2F1c2U/IElzIHRoaXMgYSBuZXR3b3JraW5nIGJ1Zz8N
Cj4gDQoNCnNvbWUgb2YgdGhlc2UgbW9zdCBsaWtlbHkgd2lsbCBmYWlsIGR1ZSB0byBvdGhlciBy
ZWFzb25zLCBidXQgY2FuIHlvdSBydW4gJ3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL25ldC9wbXR1
LnNoJ1sxXSBvbiA0LjE5IGFuZCB0aGVuIDQuMjAgYW5kIGNvbXBhcmUgcmVzdWx0cy4gSG9wZWZ1
bGx5IGl0IHdpbGwgc2hlZCBzb21lIGxpZ2h0IG9uIHRoZSBwcm9ibGVtIGFuZCBjYW4gYmUgdXNl
ZCB0byBiaXNlY3QgdG8gYSBjb21taXQgdGhhdCBjYXVzZWQgdGhlIHJlZ3Jlc3Npb24uDQoNCg0K
WzFdDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2
YWxkcy9saW51eC5naXQvdHJlZS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9uZXQvcG10dS5zaA0K
DQo=
