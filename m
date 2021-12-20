Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C414847A402
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 04:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhLTDwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 22:52:50 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4307 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbhLTDwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 22:52:49 -0500
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JHQXx1dbhz67l04;
        Mon, 20 Dec 2021 11:48:17 +0800 (CST)
Received: from lhreml744-chm.china.huawei.com (10.201.108.194) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 04:52:47 +0100
Received: from fraeml704-chm.china.huawei.com (10.206.15.53) by
 lhreml744-chm.china.huawei.com (10.201.108.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 03:52:46 +0000
Received: from fraeml704-chm.china.huawei.com ([10.206.112.182]) by
 fraeml704-chm.china.huawei.com ([10.206.112.182]) with mapi id
 15.01.2308.020; Mon, 20 Dec 2021 04:52:45 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
CC:     yusongping <yusongping@huawei.com>,
        Artem Kuzin <artem.kuzin@huawei.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: RE: [RFC PATCH 0/2] Landlock network PoC implementation
Thread-Topic: [RFC PATCH 0/2] Landlock network PoC implementation
Thread-Index: AQHX7/uQOxxQo4G2OECEIp7P5i26MqwxPnBQgACSyYCABJH+gIABge7ggAAnR4CAArn98A==
Date:   Mon, 20 Dec 2021 03:52:45 +0000
Message-ID: <dc1866cec3134c51939a5fa104359b6c@huawei.com>
References: <20211210072123.386713-1-konstantin.meskhidze@huawei.com>
 <b50ed53a-683e-77cf-9dc2-f4ae1b5fa0fd@digikod.net>
 <12467d8418f04fbf9fd4a456a2a999f1@huawei.com>
 <b535d1d4-3564-b2af-a5e8-3ba6c0fa86c9@digikod.net>
 <c8588051-8795-9b8a-cb36-f5440b590581@digikod.net>
 <a1769c4239ee4e8aadb65f9ebb6061d8@huawei.com>
 <c325e5f6-d8d5-b085-fd2d-7f454629a1ec@digikod.net>
In-Reply-To: <c325e5f6-d8d5-b085-fd2d-7f454629a1ec@digikod.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.146.86.144]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIE1pY2th0ZFsIQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogTWlja2HD
q2wgU2FsYcO8biA8bWljQGRpZ2lrb2QubmV0PiANClNlbnQ6IFNhdHVyZGF5LCBEZWNlbWJlciAx
OCwgMjAyMSA3OjAxIFBNDQpUbzogS29uc3RhbnRpbiBNZXNraGlkemUgPGtvbnN0YW50aW4ubWVz
a2hpZHplQGh1YXdlaS5jb20+DQpDYzogeXVzb25ncGluZyA8eXVzb25ncGluZ0BodWF3ZWkuY29t
PjsgQXJ0ZW0gS3V6aW4gPGFydGVtLmt1emluQGh1YXdlaS5jb20+OyBsaW51eC1zZWN1cml0eS1t
b2R1bGUgPGxpbnV4LXNlY3VyaXR5LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmc+OyBOZXR3b3JrIERl
dmVsb3BtZW50IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgbmV0ZmlsdGVyQHZnZXIua2VybmVs
Lm9yZzsgV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4N
ClN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIDAvMl0gTGFuZGxvY2sgbmV0d29yayBQb0MgaW1wbGVt
ZW50YXRpb24NCg0KDQpPbiAxOC8xMi8yMDIxIDA5OjI2LCBLb25zdGFudGluIE1lc2toaWR6ZSB3
cm90ZToNCj4gSGksIE1pY2th0ZFsDQo+IFRoYW5rcyBhZ2FpbiBmb3IgeW91ciBvcGluaW9uIGFi
b3V0IG1pbmltYWwgTGFuZGxvY2sgSVB2NCBuZXR3b3JrIHZlcnNpb24uDQo+IEkgaGF2ZSBhbHJl
YWR5IHN0YXJ0ZWQgcmVmYWN0b3JpbmcgdGhlIGNvZGUuDQo+IEhlcmUgYXJlIHNvbWUgYWRkaXRp
b25hbCB0aG91Z2h0cyBhYm91dCB0aGUgZGVzaWduLg0KDQpbLi4uXQ0KDQo+Pj4NCj4+PiBBY2Nl
c3Nlcy9zdWZmaXhlcyBzaG91bGQgYmU6DQo+Pj4gLSBDUkVBVEUNCj4+PiAtIEFDQ0VQVA0KPj4+
IC0gQklORA0KPj4+IC0gTElTVEVODQo+Pj4gLSBDT05ORUNUDQo+Pj4gLSBSRUNFSVZFIChSRUNF
SVZFX0ZST00gYW5kIFNFTkRfVE8gc2hvdWxkIG5vdCBiZSBuZWVkZWQpDQo+Pj4gLSBTRU5EDQo+
Pj4gLSBTSFVURE9XTg0KPj4+IC0gR0VUX09QVElPTiAoR0VUU09DS09QVCkNCj4+PiAtIFNFVF9P
UFRJT04gKFNFVFNPQ0tPUFQpDQo+IA0KPj4+IEZvciBub3csIHRoZSBvbmx5IGFjY2VzcyByaWdo
dHMgc2hvdWxkIGJlIExBTkRMT0NLX0FDQ0VTU19ORVRfQklORF9UQ1AgYW5kIExBTkRMT0NLX0FD
Q0VTU19ORVRfQ09OTkVDVF9UQ1AgKHRpZSB0byB0d28gTFNNIGhvb2tzIHdpdGggc3RydWN0IHNv
Y2thZGRyKS4NCj4gDQo+Pj4gVGhlc2UgYXR0cmlidXRlIGFuZCBhY2Nlc3MgcmlnaHQgY2hhbmdl
cyByZWR1Y2UgdGhlIHNjb3BlIG9mIHRoZSANCj4+PiBuZXR3b3JrIGFjY2VzcyBjb250cm9sIGFu
ZCBtYWtlIGl0IHNpbXBsZXIgYnV0IHN0aWxsIHJlYWxseSB1c2VmdWwuIERhdGFncmFtIChlLmcu
IFVEUCwgd2hpY2ggY291bGQgYWRkIEJJTkRfVURQIGFuZCBTRU5EX1VEUCkgc29ja2V0cyB3aWxs
IGJlIG1vcmUgY29tcGxleCB0byByZXN0cmljdCBjb3JyZWN0bHkgYW5kIHNob3VsZCB0aGVuIGNv
bWUgaW4gYW5vdGhlciBwYXRjaCBzZXJpZXMsIG9uY2UgVENQIGlzIHN1cHBvcnRlZC4NCj4gDQo+
IEkgdGhpbmsgdGhhdCBoYXZpbmcgYWNjZXNzIHJpZ2h0cyBsaWtlIExBTkRMT0NLX0FDQ0VTU19O
RVRfQ1JFQVRFX1RDUF9TT0NLRVRfREVOWS9MQU5ETE9DS19BQ0NFU1NfTkVUX0NSRUFURV9VRFBf
U09DS0VUX0RFTlkgbWlnaHQgYmUgdXNlZnVsIGR1cmluZyBpbml0aWFsaXphdGlvbiBwaGFzZSBv
ZiBjb250YWluZXIvc2FuZGJveCwgY2F1c2UgYSB1c2VyIGNvdWxkIGhhdmUgdGhlIHBvc3NpYmls
aXR5IHRvIHJlc3RyaWN0IHRoZSBjcmVhdGlvbiBvZiBzb21lIHR5cGUgb2Ygc29ja2V0cyBhdCBh
bGwsIGFuZCB0byByZWR1Y2UgdGhlIGF0dGFjayBzdXJmYWNlIHJlbGF0ZWQgdG8gc2VjdXJpdHkg
YXNwZWN0Lg0KPiBTbyB0aGUgbG9naWMgY291bGQgYmUgdGhlIGZvbGxvd2luZzoNCj4gCTEuIFBy
b2Nlc3MgcmVzdHJpY3RzIGNyZWF0aW9uIFVEUCBzb2NrZXRzLCBhbGxvd3MgVENQIG9uZS4NCj4g
CQktIExBTkRMT0NLX0FDQ0VTU19ORVRfQ1JFQVRFXypfU09DS0VUX0RFTlkgcnVsZXMgYXJlIHRp
ZWQgdG8gcHJvY2VzcyB0YXNrX3N0cnVjdCBjYXVzZSB0aGVyZSBhcmUgbm8gc29ja2V0cyBpbm9k
ZXMgY3JlYXRlZCBhdCB0aGlzIG1vbWVudC4NCj4gCTIuIENyZWF0ZXMgbmVjZXNzYXJ5IG51bWJl
ciBvZiBzb2NrZXRzLg0KPiAJMy4gUmVzdHJpY3RzIHNvY2tldHMnIGFjY2VzcyByaWdodHMuDQo+
IAkJLSBMQU5ETE9DS19BQ0NFU1NfTkVUX0JJTkRfKiAvIExBTkRMT0NLX0FDQ0VTU19ORVRfQ09O
TkVDVF8qIGFjY2VzcyByaWdodHMgYXJlIHRpZWQgdG8gc29ja2V0cyBpbm9kZXMgaW5kaXZpZHVh
bGx5LgkNCj4gDQoNCj4gIFJlZHVjaW5nIHRoZSBhdHRhY2sgc3VyZmFjZSBvbiB0aGUga2VybmVs
IGlzIHZhbHVhYmxlIGJ1dCBub3QgdGhlIHByaW1hcnkgZ29hbCBvZiBMYW5kbG9jay4gc2VjY29t
cCBpcyBkZXNpZ25lZCBmb3IgdGhpcyB0YXNrIGFuZCBhIHNlY2NvbXAgZmlsdGVycyBjYW4gZWFz
aWx5IGZvcmJpZCBjcmVhdGlvbiBvZiBzcGVjaWZpYyBzb2NrZXRzLiBXZSBzaG91bGQgY29uc2lk
ZXIgdXNpbmcgPiBib3RoIExhbmRsb2NrIGFuZCBzZWNjb21wLCBhbmQgeW91ciB1c2UgY2FzZSBv
ZiBkZW55aW5nIFVEUCB2cy4gVENQIGlzIGdvb2QuDQoNCj4gQW55d2F5LCB0aGUgTEFORExPQ0tf
QUNDRVNTX05FVF9DUkVBVEVfVENQX1NPQ0tFVF9ERU5ZIG5hbWUgaW4gbm90IGFwcHJvcHJpYXRl
LiBJbmRlZWQsIG1peGluZyAiYWNjZXNzIiBhbmQgImRlbnkiIGRvZXNuJ3QgbWFrZSBzZW5zZS4g
QSBMQU5ETE9DS19BQ0NFU1NfTkVUX0NSRUFURV9UQ1AgYWNjZXNzIGNvdWxkIGJlIHVzZWZ1bCBp
ZiA+ID4gd2UgY2FuIGRlZmluZSBzdWNoIFRDUCBzb2NrZXQgc2VtYW50aWMsIGUuZy4gd2l0aCBh
IHBvcnQsIHdoaWNoIGlzIG5vdCBwb3NzaWJsZSB3aGVuIGNyZWF0aW5nIGEgc29ja2V0LCBhbmQg
aXQgaXMgT0suDQoNCkkgdGhpbmsgd2UgY2FuIGRlZmluZSBpZiBpdOKAmXMgYSBUQ1Agb3IgVURQ
IHNvY2tldCBpbiB0aGUgbW9tZW50IG9mIGl0cyBjcmVhdGluZyB1c2luZyBUWVBFIGZpZWxkIGlu
IHNvY2tldChkb21haW4sIFRZUEUsIHByb3RvY29sKSBmdW5jdGlvbjoNCgktIFRDUCBzZXJ2aWNl
cyB1c2UgU09DS19TVFJFQU0gdHlwZS4NCgktIFVEUCBvbmVzIHVzZSBTT0NLX0RHUkFNIHR5cGUu
DQpTbyB3ZSBjYW4gaGF2ZSBMQU5ETE9DS19BQ0NFU1NfTkVUX0NSRUFURV9UQ1AgYWNjZXNzIHJ1
bGUgaW4gVENQIHNvY2tldCBzZW1hbnRpYywgYW5kIHRoZXJlZm9yZSBjaGVjayBzb2NrZXRfY3Jl
YXRlKGRvbWFpbiwgU09DS19TVFJFQU0sIHByb3RvY29sKSBob29rLg0KVGhlIHNpbWlsYXIgcnVs
ZSggTEFORExPQ0tfQUNDRVNTX05FVF9DUkVBVEVfVVBEKSBjb3VsZCBiZSB1c2VkIGZvciByZWNv
Z25pemluZyBVRFAgc29ja2V0cyBpbiBmdXR1cmUgcGF0Y2hlcy4NCg==
