Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1943D2320E8
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG2Otu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:49:50 -0400
Received: from tmail.tesat.de ([62.156.180.249]:17353 "EHLO tmail.tesat.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgG2Otu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 10:49:50 -0400
Received: from bk99pgp.bk.local (unknown [10.62.64.217]) by tmail.tesat.de with smtp
        (TLS: TLSv1/SSLv3,256bits,ECDHE-RSA-AES256-GCM-SHA384)
         id 0c57_0308_348f64e4_06b9_42e9_9efe_47f882817dc7;
        Wed, 29 Jul 2020 16:49:34 +0200
Received: from bk99pgp.bk.local (localhost [127.0.0.1])
        by bk99pgp.bk.local (Postfix) with ESMTP id C85BC18E082;
        Wed, 29 Jul 2020 16:49:34 +0200 (CEST)
Received: from BK99MAIL02.bk.local (bk99mail02.bk.local [10.62.64.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by bk99pgp.bk.local (Postfix) with ESMTPS id B302C18E059;
        Wed, 29 Jul 2020 16:49:34 +0200 (CEST)
Received: from BK99MAIL02.bk.local (10.62.64.169) by BK99MAIL02.bk.local
 (10.62.64.169) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 16:49:34 +0200
Received: from BK99MAIL02.bk.local ([fe80::8824:afc:c78e:5807]) by
 BK99MAIL02.bk.local ([fe80::8824:afc:c78e:5807%13]) with mapi id
 15.00.1497.006; Wed, 29 Jul 2020 16:49:34 +0200
From:   "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Thread-Topic: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Thread-Index: AdZlacdvzNLFV3z/TlWeuthNKZ0yRAANF1SAAASu9YA=
Date:   Wed, 29 Jul 2020 14:49:34 +0000
Message-ID: <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
In-Reply-To: <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.62.151.200]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-TBoneOriginalFrom: "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
X-TBoneOriginalTo: Florian Fainelli <f.fainelli@gmail.com>, Woojung Huh
        <woojung.huh@microchip.com>, Microchip Linux Driver Support
        <UNGLinuxDriver@microchip.com>
X-TBoneOriginalCC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-TBoneDomainSigned: false
X-TBoneMailStatus: PLAIN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQpJIGp1c3QgdHJpZWQgYSBWTEFOLWVuYWJsZWQgYnJpZGdlLg0KQWxsIGluZ3Jlc3Mg
cGFja2V0cyBkZWZpbml0ZWx5IGhhdmUgdGhlIDgwMi4xcS1UYWcgb24gQ1BVIGluZ3Jlc3MsIGRv
dWJsZS1jaGVja2VkIHRoYXQuIFRyaWVkIGFnYWluIHdpdGggVkxBTjIxLVRhZ2dlZCBmcmFtZXMg
Y29taW5nIGluIHRoZSBwaHlzaWNhbCBwb3J0Lg0KSXQgc2VlbXMgdGhhdCB0aGUgYnJpZGdlIGFs
c28gaGFuZGxlcyBhbGwgcGFja2V0cyBmcm9tIGxhbjEgYXMgdW50YWdnZWQuIFdoZW4gSSBhZGQg
bGFuMSB0byB0aGUgYnJpZGdlLCB0aGUgZm9sbG93aW5nIGhhcHBlbnM6DQoNCklmIGxhbjEgaGFz
IChvbmx5KSBWTEFOIDIxIHRhZ2dlZCBvbiB0aGUgYnJpZGdlLCBubyBwYWNrZXQgYXBwZWFycy4N
CkFzIHNvb24gYXMgSSBhZGQgYW4gdW50YWdnZWQvcHZpZCBWTEFOIHRvIGxhbjEgb24gdGhlIGJy
aWRnZSwgYWxsIHBhY2tldHMgYXBwZWFyIG9uIHRoZSBicmlkZ2Ugd2l0aCB3aGljaGV2ZXIgVkxB
TiBJIGFkZGVkLg0KSSBjaGVja2VkIHNpbXVsdGFuZW91c2x5IHdpdGggdGhlIENQVSBJbmdyZXNz
LVBvcnQgKGV0aDEpLCB0aGUgc2FtZSBwYWNrZXRzIGhhZCBFdGhlcnR5cGUgODEwMCB3aXRoIFZM
QU4gMjEgd2hlbiB0aGV5IGVudGVyZWQgQ1BVLg0KDQpXaXRoIFN3aXRjaHBvcnQgMSwgdGhlIHBo
eXNpY2FsIHN3aXRjaCBwb3J0IG9mIHRoZSBLU1ogaXMgbWVhbnQuDQoNCkFib3V0IHRoZSBsYXN0
IHRoaW5nOiBWTEFOIHRhZ2dlZCBmcmFtZXMgYXJlIGRlZmluaXRpdmVseSBwYXNzZWQgdG8gdGhl
IENQVS4NCklmIEkgInRjcGR1bXAgLXh4IiBvbnRvIGV0aDEsIEkgc2VlIGZvciBleGFtcGxlICIo
MTIgYnl0ZSBNQUMpIDgxMDAgMDAxNSA4NmRkIChJUHY2LVBheWxvYWQpIi4gVGhlIHRhaWwgdGFn
IGlzIGFsc28gdmlzaWJsZS4NCkV4YWN0bHkgdGhlIHNhbWUgZnJhbWUgYXBwZWFycyBvbiBsYW4x
IGFzICIoMTIgYnl0ZSBNQUMpIDg2ZGQgKElQdjYtUGF5bG9hZCkiLCBzbyB0aGUgODAyLjFxLUhl
YWRlciBpcyBwcmVzZW50IG9uIENQVSBpbmdyZXNzLg0KVGhlcmVmb3JlIHRoZSBWTEFOIHRhZyBw
cm9iYWJseSBpcyBsb3N0IGJldHdlZW4gZXRoMSAoSW5ncmVzcykgYW5kIHRoZSByZXNwZWN0aXZl
IERTQS1JbnRlcmZhY2UsIGFuZCBpcyBub3QgZmlsdGVyZWQgb24gdGhlIEtTWjk0NzcuDQoNCkJl
c3QgUmVnYXJkcw0KTWFydmluIEdhdWJlDQoNCi0tLS0tVXJzcHLDvG5nbGljaGUgTmFjaHJpY2h0
LS0tLS0NClZvbjogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQpHZXNl
bmRldDogTWl0dHdvY2gsIDI5LiBKdWxpIDIwMjAgMTU6NDgNCkFuOiBHYXViZSwgTWFydmluIChU
SFNFLVRMMSkgPE1hcnZpbi5HYXViZUB0ZXNhdC5kZT47IFdvb2p1bmcgSHVoIDx3b29qdW5nLmh1
aEBtaWNyb2NoaXAuY29tPjsgTWljcm9jaGlwIExpbnV4IERyaXZlciBTdXBwb3J0IDxVTkdMaW51
eERyaXZlckBtaWNyb2NoaXAuY29tPg0KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCkJldHJl
ZmY6IFJlOiBQUk9CTEVNOiAoRFNBL01pY3JvY2hpcCk6IDgwMi4xUS1IZWFkZXIgbG9zdCBvbiBL
U1o5NDc3LURTQSBpbmdyZXNzIHdpdGhvdXQgYnJpZGdlDQoNCg0KDQpPbiA3LzI4LzIwMjAgMTE6
MDUgUE0sIEdhdWJlLCBNYXJ2aW4gKFRIU0UtVEwxKSB3cm90ZToNCj4gU3VtbWFyeTogODAyLjFR
LUhlYWRlciBsb3N0IG9uIEtTWjk0NzctRFNBIGluZ3Jlc3Mgd2l0aG91dCBicmlkZ2UNCj4gS2V5
d29yZHM6IG5ldHdvcmtpbmcsIGRzYSwgbWljcm9jaGlwLCA4MDIuMXEsIHZsYW4gRnVsbCBkZXNj
cmlwdGlvbjoNCj4NCj4gSGVsbG8sDQo+IHdlJ3JlIHRyeWluZyB0byBnZXQgODAyLjFRLVRhZ2dl
ZCBFdGhlcm5ldCBGcmFtZXMgdGhyb3VnaCBhbiBLU1o5NDc3IERTQS1lbmFibGVkIHN3aXRjaCB3
aXRob3V0IGNyZWF0aW5nIGEgYnJpZGdlIG9uIHRoZSBrZXJuZWwgc2lkZS4NCg0KRG9lcyBpdCB3
b3JrIGlmIHlvdSBoYXZlIGEgYnJpZGdlIHRoYXQgaXMgVkxBTiBhd2FyZSB0aG91Z2g/IElmIGl0
IGRvZXMsIHRoaXMgd291bGQgc3VnZ2VzdCB0aGF0IHRoZSBkZWZhdWx0IFZMQU4gYmVoYXZpb3Ig
d2l0aG91dCBhIGJyaWRnZSBpcyB0b28gcmVzdHJpY3RpdmUgYW5kIG5lZWRzIGNoYW5naW5nLg0K
DQo+IEZvbGxvd2luZyBzZXR1cDoNCj4gU3dpdGNocG9ydCAxIDwtLSBLU1o5NDc3IC0tPiBldGgx
IChDUFUtUG9ydCkgPC0tLT4gbGFuMQ0KDQpUaGlzIHJlcHJlc2VudGF0aW9uIGlzIGNvbmZ1c2lu
ZywgaXMgc3dpdGNocG9ydCAxIGEgbmV0d29yayBkZXZpY2Ugb3IgaXMgdGhpcyBtZWFudCB0byBi
ZSBwaHlzaWNhbCBzd2l0Y2ggcG9ydCBudW1iZXIgb2YgMSBvZiB0aGUgS1NaOTQ3Nz8NCg0KPg0K
PiBObyBicmlkZ2UgaXMgY29uZmlndXJlZCwgb25seSB0aGUgaW50ZXJmYWNlIGRpcmVjdGx5LiBV
bnRhZ2dlZCBwYWNrZXRzIGFyZSB3b3JraW5nIHdpdGhvdXQgcHJvYmxlbXMuIFRoZSBTd2l0Y2gg
dXNlcyB0aGUga3N6OTQ3Ny1EU0EtRHJpdmVyIHdpdGggVGFpbC1UYWdnaW5nICgiRFNBX1RBR19Q
Uk9UT19LU1o5NDc3IikuDQo+IFdoZW4gc2VuZGluZyBwYWNrZXRzIHdpdGggODAyLjFRLUhlYWRl
ciAodGFnZ2VkIFZMQU4pIGludG8gdGhlIFN3aXRjaHBvcnQsIEkgc2VlIHRoZW0gaW5jbHVkaW5n
IHRoZSA4MDIuMVEtSGVhZGVyIG9uIGV0aDEuDQo+IFRoZXkgYWxzbyBhcHBlYXIgb24gbGFuMSwg
YnV0IHdpdGggdGhlIDgwMi4xUS1IZWFkZXIgbWlzc2luZy4NCj4gV2hlbiBJIGNyZWF0ZSBhbiBW
TEFOLUludGVyZmFjZSBvdmVyIGxhbjEgKGUuZy4gbGFuMS4yMSksIG5vdGhpbmcgYXJyaXZlcyB0
aGVyZS4NCj4gVGhlIG90aGVyIHdheSBhcm91bmQsIGV2ZXJ5dGhpbmcgd29ya3MgZmluZTogUGFj
a2V0cyB0cmFuc21pdHRlZCBpbnRvIGxhbjEuMjEgYXJlIGFwcGVhcmluZyBpbiA4MDIuMVEtVkxB
TiAyMSBvbiB0aGUgU3dpdGNocG9ydCAxLg0KPg0KPiBJIGFzc3VtZSB0aGF0IGlzIG5vdCB0aGUg
aW50ZW5kZWQgYmVoYXZpb3IuDQo+IEkgaGF2ZW4ndCBmb3VuZCBhbiBvYnZpb3VzIHJlYXNvbiBm
b3IgdGhpcyBiZWhhdmlvciB5ZXQsIGJ1dCBJIHN1c3BlY3QgdGhlIFZMQU4tSGVhZGVyIGdldHMg
c3RyaXBwZWQgb2YgYW55d2hlcmUgYXJvdW5kICJkc2Ffc3dpdGNoX3JjdiIgaW4gbmV0L2RzYS9k
c2EuYyBvciAia3N6OTQ3N19yY3YiIGluIG5ldC9kc2EvdGFnX2tzei5jLg0KDQpOb3Qgc3VyZSBo
b3cgdGhvdWdoLCBrc3o5NDc3X3JjdigpIG9ubHkgcmVtb3ZlcyB0aGUgdHJhaWwgdGFnLCB0aGlz
IHNob3VsZCBsZWF2ZSBhbnkgaGVhZGVyIGludGFjdC4gSXQgc2VlbXMgdG8gbWUgdGhhdCB0aGUg
c3dpdGNoIGlzIGluY29ycmVjdGx5IGNvbmZpZ3VyZWQgYW5kIGlzIG5vdCBWTEFOIGF3YXJlIGF0
IGFsbCwgbm9yIHBhc3NpbmcgVkxBTiB0YWdnZWQgZnJhbWVzIHRocm91Z2ggb24gaW5ncmVzcyB0
byBDUFUgd2hlbiBpdCBzaG91bGQuDQotLQ0KRmxvcmlhbg0KDQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KDQpUZXNhdC1TcGFjZWNvbSBHbWJIICYgQ28uIEtHDQpTaXR6OiBCYWNr
bmFuZzsgUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQgSFJBIDI3MDk3Nw0K
UGVyc29lbmxpY2ggaGFmdGVuZGVyIEdlc2VsbHNjaGFmdGVyOiBUZXNhdC1TcGFjZWNvbSBHZXNj
aGFlZnRzZnVlaHJ1bmdzIEdtYkg7DQpTaXR6OiBCYWNrbmFuZzsgUmVnaXN0ZXJnZXJpY2h0OiBB
bXRzZ2VyaWNodCBTdHV0dGdhcnQgSFJCIDI3MTY1ODsNCkdlc2NoYWVmdHNmdWVocnVuZzogRHIu
IE1hcmMgU3RlY2tsaW5nLCBLZXJzdGluIEJhc2NoZSwgUmFsZiBaaW1tZXJtYW5uDQoNCltiYW5u
ZXJdDQo=
