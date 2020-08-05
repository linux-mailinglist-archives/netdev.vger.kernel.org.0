Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2776923C535
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 07:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHEFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 01:46:04 -0400
Received: from tmail.tesat.de ([62.156.180.249]:48155 "EHLO tmail.tesat.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHEFqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 01:46:03 -0400
Received: from bk99pgp.bk.local (unknown [10.62.64.217]) by tmail.tesat.de with smtp
        (TLS: TLSv1/SSLv3,256bits,ECDHE-RSA-AES256-GCM-SHA384)
         id 6b05_023d_7e34b3fb_7a1b_406b_842d_73a3a81354c0;
        Wed, 05 Aug 2020 07:45:52 +0200
Received: from bk99pgp.bk.local (localhost [127.0.0.1])
        by bk99pgp.bk.local (Postfix) with ESMTP id 4D84318E082;
        Wed,  5 Aug 2020 07:45:52 +0200 (CEST)
Received: from BK99MAIL02.bk.local (autodiscover.tesat.com [10.62.64.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by bk99pgp.bk.local (Postfix) with ESMTPS id 3461D18E059;
        Wed,  5 Aug 2020 07:45:52 +0200 (CEST)
Received: from BK99MAIL02.bk.local (10.62.64.169) by BK99MAIL02.bk.local
 (10.62.64.169) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 Aug
 2020 07:45:52 +0200
Received: from BK99MAIL02.bk.local ([fe80::8824:afc:c78e:5807]) by
 BK99MAIL02.bk.local ([fe80::8824:afc:c78e:5807%13]) with mapi id
 15.00.1497.006; Wed, 5 Aug 2020 07:45:52 +0200
From:   "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Thread-Topic: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Thread-Index: AQHWapkPCHhqTfSBo0WnStFbZ+TZ76koQqaAgAC9HYA=
Date:   Wed, 5 Aug 2020 05:45:51 +0000
Message-ID: <0c963932e9174ef1a58f684cd5754a1a@BK99MAIL02.bk.local>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <800bbbe8-2c51-114c-691b-137fd96a6ccd@gmail.com>
 <20200804195423.ixeevhsviap535on@skbuf>
 <b4a859cc-1e17-67c2-a619-968e9fcfaf10@gmail.com>
In-Reply-To: <b4a859cc-1e17-67c2-a619-968e9fcfaf10@gmail.com>
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
X-TBoneOriginalTo: Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
        <olteanv@gmail.com>
X-TBoneOriginalCC: Woojung Huh <woojung.huh@microchip.com>, Microchip Linux Driver Support
        <UNGLinuxDriver@microchip.com>, "netdev@vger.kernel.org"
        <netdev@vger.kernel.org>
X-TBoneDomainSigned: false
X-TBoneMailStatus: PLAIN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQpJJ20gdXNpbmcgdGhlIHVwc3RyZWFtIGRyaXZlciBWbGFkaW1pciBtZW50aW9uZWQs
IGFzIG9mIDUuNC41MS4NCg0KQmVzdCByZWdhcmRzDQpNYXJ2aW4gR2F1YmUNCg0KLS0tLS1VcnNw
csO8bmdsaWNoZSBOYWNocmljaHQtLS0tLQ0KVm9uOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5l
bGxpQGdtYWlsLmNvbT4NCkdlc2VuZGV0OiBEaWVuc3RhZywgNC4gQXVndXN0IDIwMjAgMjI6MjAN
CkFuOiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPg0KQ2M6IEdhdWJlLCBNYXJ2
aW4gKFRIU0UtVEwxKSA8TWFydmluLkdhdWJlQHRlc2F0LmRlPjsgV29vanVuZyBIdWggPHdvb2p1
bmcuaHVoQG1pY3JvY2hpcC5jb20+OyBNaWNyb2NoaXAgTGludXggRHJpdmVyIFN1cHBvcnQgPFVO
R0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQpCZXRy
ZWZmOiBSZTogUFJPQkxFTTogKERTQS9NaWNyb2NoaXApOiA4MDIuMVEtSGVhZGVyIGxvc3Qgb24g
S1NaOTQ3Ny1EU0EgaW5ncmVzcyB3aXRob3V0IGJyaWRnZQ0KDQoNCg0KT24gOC80LzIwMjAgMTI6
NTQgUE0sIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gT24gVHVlLCBBdWcgMDQsIDIwMjAgYXQg
MDg6NTE6MDBBTSAtMDcwMCwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToNCj4+ICJJIGxvb2tlZCBp
bnRvIGl0IGRlZXBlciwgdGhlIGRyaXZlciBkb2VzIHJ4dmxhbiBvZmZsb2FkaW5nLiINCj4+DQo+
PiBJcyB0aGlzIHBhcnQgb2YgdGhlIGRyaXZlciB1cHN0cmVhbSBvciBhcmUgeW91IHVzaW5nIGEg
dmVuZG9yIHRyZWUNCj4+IGZyb20gRnJlZXNjYWxlIHdoaWNoIGhhcyB0aGF0IGNoYW5nZSBpbmNs
dWRlZD8NCj4+DQo+DQo+IERvZXMgaXQgbWF0dGVyPw0KDQpJZiB0aGlzIHdhcyBhIGRvd25zdHJl
YW0gcHJvYmxlbSB5ZXMsIHRoZXJlIHdvdWxkIG5vdCBuZWNlc3NhcmlseSBiZSBhIHByZXNzaW5n
IG5lZWQgdG8gYWRkcmVzcyBpdCB3aXRoIGEgcGF0Y2ggdGFyZ2V0aW5nICduZXQnIGZvciBpbnN0
YW5jZS4NClRoaXMgaXMgbm90IHRoZSBjYXNlLCB0aGVyZWZvcmUgaXQgc2hvdWxkIGJlIGFkZHJl
c3NlZC4NCg0KPiBGV0lXLCBtYWlubGluZSBmZWMgZG9lcyBkZWNsYXJlIE5FVElGX0ZfSFdfVkxB
Tl9DVEFHX1JYOg0KPiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC9sYXRlc3Qvc291
cmNlL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyDQo+IGVlc2NhbGUvZmVjX21haW4uYyNMMzMxNyBh
bmQgbW92ZSBpdCB0byB0aGUgaHdhY2NlbCBhcmVhIG9uIFJYOg0KPiBodHRwczovL2VsaXhpci5i
b290bGluLmNvbS9saW51eC9sYXRlc3Qvc291cmNlL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyDQo+
IGVlc2NhbGUvZmVjX21haW4uYyNMMTUxMw0KPg0KDQotLQ0KRmxvcmlhbg0KDQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXw0KDQpUZXNhdC1TcGFjZWNvbSBHbWJIICYgQ28uIEtHDQpT
aXR6OiBCYWNrbmFuZzsgUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQgSFJB
IDI3MDk3Nw0KUGVyc29lbmxpY2ggaGFmdGVuZGVyIEdlc2VsbHNjaGFmdGVyOiBUZXNhdC1TcGFj
ZWNvbSBHZXNjaGFlZnRzZnVlaHJ1bmdzIEdtYkg7DQpTaXR6OiBCYWNrbmFuZzsgUmVnaXN0ZXJn
ZXJpY2h0OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQgSFJCIDI3MTY1ODsNCkdlc2NoYWVmdHNmdWVo
cnVuZzogRHIuIE1hcmMgU3RlY2tsaW5nLCBLZXJzdGluIEJhc2NoZSwgUmFsZiBaaW1tZXJtYW5u
DQoNCltiYW5uZXJdDQo=
