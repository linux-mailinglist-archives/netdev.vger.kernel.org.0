Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CAE11D29B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfLLQpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:45:22 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:16361 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729101AbfLLQpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:45:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576169120; x=1607705120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q4fvjeu1aqmfd6VU/cDsiWvNL14gKjO/yRAp6rTkPnE=;
  b=TY4LnbelNm2CmIOfzADKFFiFLMbGe4YDoP/4VgLx97yhj4Me2lcN6+Sh
   OfKnjdPSwbRWVDc12BRT1bBwYzxCJDPNh31aKMkiaEiCAud/hNr1lupdI
   JSwKA1BS6TpRUqE2Ur+yIITRjgcs6NIdMmHHHvSBh49i1qDsxTtZ/Ae5o
   o=;
IronPort-SDR: M18wUbes8M29HhxSgi97zPXZ2WQ+GRf5VcpyaH/f7P28ymXVVZGAaMstDVmh2k+BERxIyYlyuC
 iTvnRxgbVxXg==
X-IronPort-AV: E=Sophos;i="5.69,306,1571702400"; 
   d="scan'208";a="8297589"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 12 Dec 2019 16:45:19 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id A7D2BA267B;
        Thu, 12 Dec 2019 16:45:17 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Dec 2019 16:45:16 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Dec 2019 16:45:15 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Thu, 12 Dec 2019 16:45:15 +0000
From:   "Durrant, Paul" <pdurrant@amazon.com>
To:     "jandryuk@gmail.com" <jandryuk@gmail.com>
CC:     xen-devel <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
 related code
Thread-Topic: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
 related code
Thread-Index: AQHVsPOiKWT/MKpGekOkpRko3pMZ46e2sWUAgAAApYA=
Date:   Thu, 12 Dec 2019 16:45:15 +0000
Message-ID: <34de94e87020467fac84434194809894@EX13D32EUC003.ant.amazon.com>
References: <20191212135406.26229-1-pdurrant@amazon.com>
 <CAKf6xptNRAuvjqzqFwbPmetYsTdPOMgTT0AWEouwjsHq1iCV6w@mail.gmail.com>
In-Reply-To: <CAKf6xptNRAuvjqzqFwbPmetYsTdPOMgTT0AWEouwjsHq1iCV6w@mail.gmail.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBqYW5kcnl1a0BnbWFpbC5jb20g
PGphbmRyeXVrQGdtYWlsLmNvbT4NCj4gU2VudDogMTIgRGVjZW1iZXIgMjAxOSAxNjozMg0KPiBU
bzogRHVycmFudCwgUGF1bCA8cGR1cnJhbnRAYW1hem9uLmNvbT4NCj4gQ2M6IHhlbi1kZXZlbCA8
eGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsN
Cj4gb3BlbiBsaXN0IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgV2VpIExpdSA8d2Vp
LmxpdUBrZXJuZWwub3JnPjsNCj4gRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0
Pg0KPiBTdWJqZWN0OiBSZTogW1hlbi1kZXZlbF0gW1BBVENIIG5ldC1uZXh0XSB4ZW4tbmV0YmFj
azogZ2V0IHJpZCBvZiBvbGQgdWRldg0KPiByZWxhdGVkIGNvZGUNCj4gDQo+IE9uIFRodSwgRGVj
IDEyLCAyMDE5IGF0IDg6NTYgQU0gUGF1bCBEdXJyYW50IDxwZHVycmFudEBhbWF6b24uY29tPiB3
cm90ZToNCj4gPg0KPiA+IEluIHRoZSBwYXN0IGl0IHVzZWQgdG8gYmUgdGhlIGNhc2UgdGhhdCB0
aGUgWGVuIHRvb2xzdGFjayByZWxpZWQgdXBvbg0KPiA+IHVkZXYgdG8gZXhlY3V0ZSBiYWNrZW5k
IGhvdHBsdWcgc2NyaXB0cy4gSG93ZXZlciB0aGlzIGhhcyBub3QgYmVlbiB0aGUNCj4gPiBjYXNl
IGZvciBtYW55IHJlbGVhc2VzIG5vdyBhbmQgcmVtb3ZhbCBvZiB0aGUgYXNzb2NpYXRlZCBjb2Rl
IGluDQo+ID4geGVuLW5ldGJhY2sgc2hvcnRlbnMgdGhlIHNvdXJjZSBieSBtb3JlIHRoYW4gMTAw
IGxpbmVzLCBhbmQgcmVtb3ZlcyBtdWNoDQo+ID4gY29tcGxleGl0eSBpbiB0aGUgaW50ZXJhY3Rp
b24gd2l0aCB0aGUgeGVuc3RvcmUgYmFja2VuZCBzdGF0ZS4NCj4gPg0KPiA+IE5PVEU6IHhlbi1u
ZXRiYWNrIGlzIHRoZSBvbmx5IHhlbmJ1cyBkcml2ZXIgdG8gaGF2ZSBhIGZ1bmN0aW9uYWwNCj4g
dWV2ZW50KCkNCj4gPiAgICAgICBtZXRob2QuIFRoZSBvbmx5IG90aGVyIGRyaXZlciB0byBoYXZl
IGEgbWV0aG9kIGF0IGFsbCBpcw0KPiA+ICAgICAgIHB2Y2FsbHMtYmFjaywgYW5kIGN1cnJlbnRs
eSBwdmNhbGxzX2JhY2tfdWV2ZW50KCkgc2ltcGx5IHJldHVybnMNCj4gMC4NCj4gPiAgICAgICBI
ZW5jZSB0aGlzIHBhdGNoIGFsc28gZmFjaWxpdGF0ZXMgZnVydGhlciBjbGVhbnVwLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogUGF1bCBEdXJyYW50IDxwZHVycmFudEBhbWF6b24uY29tPg0KPiA+
IC0tLQ0KPiA+IENjOiBXZWkgTGl1IDx3ZWkubGl1QGtlcm5lbC5vcmc+DQo+ID4gQ2M6ICJEYXZp
ZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L25ldC94ZW4tbmV0YmFjay9jb21tb24uaCB8ICAxMSAtLS0NCj4gPiAgZHJpdmVycy9uZXQveGVu
LW5ldGJhY2sveGVuYnVzLmMgfCAxMjUgKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDEyMiBkZWxldGlvbnMoLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9jb21tb24uaCBi
L2RyaXZlcnMvbmV0L3hlbi0NCj4gbmV0YmFjay9jb21tb24uaA0KPiA+IGluZGV4IDA1ODQ3ZWI5
MWExYi4uZTQ4ZGEwMDRjMWEzIDEwMDY0NA0KPiANCj4gPHNuaXA+DQo+IA0KPiA+IC1zdGF0aWMg
aW5saW5lIHZvaWQgYmFja2VuZF9zd2l0Y2hfc3RhdGUoc3RydWN0IGJhY2tlbmRfaW5mbyAqYmUs
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0geGVuYnVz
X3N0YXRlIHN0YXRlKQ0KPiA+IC17DQo+ID4gLSAgICAgICBzdHJ1Y3QgeGVuYnVzX2RldmljZSAq
ZGV2ID0gYmUtPmRldjsNCj4gPiAtDQo+ID4gLSAgICAgICBwcl9kZWJ1ZygiJXMgLT4gJXNcbiIs
IGRldi0+bm9kZW5hbWUsIHhlbmJ1c19zdHJzdGF0ZShzdGF0ZSkpOw0KPiA+IC0gICAgICAgYmUt
PnN0YXRlID0gc3RhdGU7DQo+ID4gLQ0KPiA+IC0gICAgICAgLyogSWYgd2UgYXJlIHdhaXRpbmcg
Zm9yIGEgaG90cGx1ZyBzY3JpcHQgdGhlbiBkZWZlciB0aGUNCj4gPiAtICAgICAgICAqIGFjdHVh
bCB4ZW5idXMgc3RhdGUgY2hhbmdlLg0KPiA+IC0gICAgICAgICovDQo+ID4gLSAgICAgICBpZiAo
IWJlLT5oYXZlX2hvdHBsdWdfc3RhdHVzX3dhdGNoKQ0KPiA+IC0gICAgICAgICAgICAgICB4ZW5i
dXNfc3dpdGNoX3N0YXRlKGRldiwgc3RhdGUpOw0KPiANCj4gaGF2ZV9ob3RwbHVnX3N0YXR1c193
YXRjaCBwcmV2ZW50cyB4ZW4tbmV0YmFjayBmcm9tIHN3aXRjaGluZyB0bw0KPiBjb25uZWN0ZWQg
c3RhdGUgdW5sZXNzIHRoZSB0aGUgYmFja2VuZCBzY3JpcHRzIGhhdmUgd3JpdHRlbg0KPiAiaG90
cGx1Zy1zdGF0dXMiICJzdWNjZXNzIi4gIEkgaGFkIGFsd2F5cyB0aG91Z2h0IHRoYXQgd2FzIGlu
dGVudGlvbmFsDQo+IHNvIHRoZSBmcm9udGVuZCBkb2Vzbid0IGNvbm5lY3Qgd2hlbiB0aGUgYmFj
a2VuZCBpcyB1bmNvbm5lY3RlZC4gIGkuZS4NCj4gaWYgdGhlIGJhY2tlbmQgc2NyaXB0cyBmYWls
cywgaXQgd3JpdGVzICJob3RwbHVnLXN0YXR1cyIgImVycm9yIiBhbmQNCj4gdGhlIGZyb250ZW5k
IGRvZXNuJ3QgY29ubmVjdC4NCj4gDQo+IFRoYXQgYmVoYXZpb3IgaXMgaW5kZXBlbmRlbnQgb2Yg
dXNpbmcgdWRldiB0byBydW4gdGhlIHNjcmlwdHMuICBJJ20NCj4gbm90IG9wcG9zZWQgdG8gcmVt
b3ZpbmcgaXQsIGJ1dCBJIHRoaW5rIGl0IGF0IGxlYXN0IHdhcnJhbnRzDQo+IG1lbnRpb25pbmcg
aW4gdGhlIGNvbW1pdCBtZXNzYWdlLg0KDQpUcnVlLCBidXQgaXQncyBwcm9iYWJseSByZWxhdGVk
LiBUaGUgbmV0YmFjayBwcm9iZSB3b3VsZCBwcmV2aW91c2x5IGtpY2sgdWRldiwgdGhlIGhvdHBs
dWcgc2NyaXB0IHdvdWxkIHRoZW4gcnVuLCBhbmQgdGhlbiB0aGUgc3RhdGUgd291bGQgZ28gY29u
bmVjdGVkLiBJIHRoaW5rLCBiZWNhdXNlIHRoZSBob3RwbHVnIGlzIGludm9rZWQgZGlyZWN0bHkg
YnkgdGhlIHRvb2xzdGFjayBub3csIHRoZXNlIHRoaW5ncyByZWFsbHkgb3VnaHQgbm90IHRvIGJl
IHRpZWQgdG9nZXRoZXIuIFRCSCBJIGNhbid0IHNlZSBhbnkgaGFybSBpbiB0aGUgZnJvbnRlbmQg
c2VlaW5nIHRoZSBuZXR3b3JrIGNvbm5lY3Rpb24gYmVmb3JlIHRoZSBiYWNrZW5kIHBsdW1iaW5n
IGlzIGRvbmUuLi4gSWYgdGhlIGZyb250ZW5kIHNob3VsZCBoYXZlIGFueSBzb3J0IG9mIGluZGlj
YXRpb24gb2Ygd2hldGhlciB0aGUgYmFja2VuZCBpcyBwbHVtYmVkIG9yIG5vdCB0aGVuIElNTyBp
dCBvdWdodCB0byBiZSBhcyBhIHZpcnR1YWwgY2Fycmllci9saW5rIHN0YXR1cywgYmVjYXVzZSB1
bnBsdW1iaW5nIGFuZCByZS1wbHVtYmluZyBjb3VsZCBiZSBkb25lIGF0IGFueSB0aW1lIHJlYWxs
eSB3aXRob3V0IGFueSBuZWVkIGZvciB0aGUgc2hhcmVkIHJpbmcgdG8gZ28gYXdheSAoYW5kIGlu
IGZhY3QgSSB3aWxsIGJlIGZvbGxvd2luZyB1cCBhdCBzb21lIHBvaW50IHdpdGggYSBwYXRjaCB0
byBhbGxvdyB1bmJpbmQgYW5kIHJlLWJpbmQgb2YgbmV0YmFjaykuDQoNCkknbGwgZWxhYm9yYXRl
IGluIHRoZSBjb21taXQgbWVzc2FnZSBhcyB5b3Ugc3VnZ2VzdCA6LSkNCg0KQ2hlZXJzLA0KDQog
IFBhdWwNCg0KPiANCj4gUmVnYXJkcywNCj4gSmFzb24NCg==
