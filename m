Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9990F216302
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgGGAao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:30:44 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:53824 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgGGAan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:30:43 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 80FC5891AC
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:30:35 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1594081835;
        bh=MYaPMDUNDL5Xop3NmhTaDFq0rwHQEkn8jSC33IhMtVE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=b/bDtqJpxJrlRVJpuhhwvfX3bSbBVO6a/Xh2rYhDu3W9vMv2Kjo7VJQoGzHeQ5nJi
         YH1+DW61pWkODHfes+SAhw0H2KxjqIa8wJ2AgVFhBjzJcgA0VBW7OYhchIXbl4lWV5
         RrEh1Ow6CJtS45ZzK1l4le1QT8Anj7xlN0bj2TCUTzfevxDOcijzD5hpNgZONVjrKO
         2mkABeRMA5b2bBuwojbgp/DuXPr4C4r74clP6sRUEJKhT+z0rsJQMwEI7jrtO5ZGdF
         0sBMkDFXmADhhi+VT2mkZfYXKD/9mwRU/fY4PLjQ1Imq0ANUsguxYyrQu6zajUBWLG
         K3I+2KIHib9QA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f03c22a0001>; Tue, 07 Jul 2020 12:30:34 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 7 Jul 2020 12:30:35 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Tue, 7 Jul 2020 12:30:35 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next 7/7] net: phy: mdio-octeon: Cleanup module
 loading dependencies
Thread-Topic: [PATCH net-next 7/7] net: phy: mdio-octeon: Cleanup module
 loading dependencies
Thread-Index: AQHWUvp9Kwp3deUNNki0J1SWHp9C46j6fIgA
Date:   Tue, 7 Jul 2020 00:30:34 +0000
Message-ID: <29b3f2da-1d5d-ae83-4e85-41615f43f467@alliedtelesis.co.nz>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-8-andrew@lunn.ch>
In-Reply-To: <20200705182921.887441-8-andrew@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <41FD3F21BD0E004697C2A07DCB6E4397@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3DQoNCk9uIDYvMDcvMjAgNjoyOSBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRv
IGVuc3VyZSB0aGF0IHRoZSBvY3RvZW4gTURJTyBkcml2ZXIgaGFzIGJlZW4gbG9hZGVkLCB0aGUg
Q2F2aXVtDQo+IGV0aGVybmV0IGRyaXZlcnMgcmVmZXJlbmNlIGEgZHVtbXkgc3ltYm9sIGluIHRo
ZSBNRElPIGRyaXZlci4gVGhpcw0KPiBmb3JjZXMgaXQgdG8gYmUgbG9hZGVkIGZpcnN0LiBBbmQg
dGhpcyBzeW1ib2wgaGFzIG5vdCBiZWVuIGNsZWFubHkNCj4gaW1wbGVtZW50ZWQsIHJlc3VsdGlu
ZyBpbiB3YXJuaW5ncyB3aGVuIGJ1aWxkIFc9MSBDPTEuDQo+DQo+IFNpbmNlIGRldmljZSB0cmVl
IGlzIGJlaW5nIHVzZWQsIGFuZCBhIHBoYW5kbGUgcG9pbnRzIHRvIHRoZSBQSFkgb24NCj4gdGhl
IE1ESU8gYnVzLCB3ZSBjYW4gbWFrZSB1c2Ugb2YgZGVmZXJyZWQgcHJvYmluZy4gSWYgdGhlIFBI
WSBmYWlscyB0bw0KPiBjb25uZWN0LCBpdCBzaG91bGQgYmUgYmVjYXVzZSB0aGUgTURJTyBidXMg
ZHJpdmVyIGhhcyBub3QgbG9hZGVkDQo+IHlldC4gUmV0dXJuIC1FUFJPQkVfREVGRVIgc28gaXQg
d2lsbCBiZSB0cmllZCBhZ2FpbiBsYXRlci4NCj4NCj4gQ2M6IFN1bmlsIEdvdXRoYW0gPHNnb3V0
aGFtQG1hcnZlbGwuY29tPg0KPiBDYzogUm9iZXJ0IFJpY2h0ZXIgPHJyaWNodGVyQG1hcnZlbGwu
Y29tPg0KPiBDYzogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxlc2lzLmNv
Lm56Pg0KPiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
Zz4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KDQpHYXZl
IHRoaXMgYSBxdWljayBzcGluIG9uIG9uZSBvZiBvdXIgYm9hcmRzIHVzaW5nIHRoZSBPY3Rlb24g
U29DLiBMb29rcyANCmdvb2QgdG8gbWUNCg0KVGVzdGVkLWJ5OiBDaHJpcyBQYWNraGFtIDxjaHJp
cy5wYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+DQoNCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2F2aXVtL29jdGVvbi9vY3Rlb25fbWdtdC5jIHwgNiArLS0tLS0NCj4gICBkcml2
ZXJzL25ldC9waHkvbWRpby1vY3Rlb24uYyAgICAgICAgICAgICAgICAgICAgfCA2IC0tLS0tLQ0K
PiAgIGRyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJuZXQtbWRpby5jICAgICAgICAgICB8IDIg
Ky0NCj4gICBkcml2ZXJzL3N0YWdpbmcvb2N0ZW9uL2V0aGVybmV0LW1kaW8uaCAgICAgICAgICAg
fCAyIC0tDQo+ICAgZHJpdmVycy9zdGFnaW5nL29jdGVvbi9ldGhlcm5ldC5jICAgICAgICAgICAg
ICAgIHwgMiAtLQ0KPiAgIDUgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxNiBkZWxl
dGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9v
Y3Rlb24vb2N0ZW9uX21nbXQuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9vY3Rlb24v
b2N0ZW9uX21nbXQuYw0KPiBpbmRleCBjYmFhMTkyNGFmYmUuLjRiZjAyMzdlZTUyZSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2F2aXVtL29jdGVvbi9vY3Rlb25fbWdtdC5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9vY3Rlb24vb2N0ZW9uX21nbXQu
Yw0KPiBAQCAtOTYxLDcgKzk2MSw3IEBAIHN0YXRpYyBpbnQgb2N0ZW9uX21nbXRfaW5pdF9waHko
c3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCj4gICAJCQkJUEhZX0lOVEVSRkFDRV9NT0RFX01J
SSk7DQo+ICAgDQo+ICAgCWlmICghcGh5ZGV2KQ0KPiAtCQlyZXR1cm4gLUVOT0RFVjsNCj4gKwkJ
cmV0dXJuIC1FUFJPQkVfREVGRVI7DQo+ICAgDQo+ICAgCXJldHVybiAwOw0KPiAgIH0NCj4gQEAg
LTE1NTQsMTIgKzE1NTQsOCBAQCBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RyaXZlciBvY3Rlb25f
bWdtdF9kcml2ZXIgPSB7DQo+ICAgCS5yZW1vdmUJCT0gb2N0ZW9uX21nbXRfcmVtb3ZlLA0KPiAg
IH07DQo+ICAgDQo+IC1leHRlcm4gdm9pZCBvY3Rlb25fbWRpb2J1c19mb3JjZV9tb2RfZGVwZW5j
ZW5jeSh2b2lkKTsNCj4gLQ0KPiAgIHN0YXRpYyBpbnQgX19pbml0IG9jdGVvbl9tZ210X21vZF9p
bml0KHZvaWQpDQo+ICAgew0KPiAtCS8qIEZvcmNlIG91ciBtZGlvYnVzIGRyaXZlciBtb2R1bGUg
dG8gYmUgbG9hZGVkIGZpcnN0LiAqLw0KPiAtCW9jdGVvbl9tZGlvYnVzX2ZvcmNlX21vZF9kZXBl
bmNlbmN5KCk7DQo+ICAgCXJldHVybiBwbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXIoJm9jdGVvbl9t
Z210X2RyaXZlcik7DQo+ICAgfQ0KPiAgIA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5
L21kaW8tb2N0ZW9uLmMgYi9kcml2ZXJzL25ldC9waHkvbWRpby1vY3Rlb24uYw0KPiBpbmRleCBh
MmY5Mzk0OGRiOTcuLmQxZTEwMDlkNTFhZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvcGh5
L21kaW8tb2N0ZW9uLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L21kaW8tb2N0ZW9uLmMNCj4g
QEAgLTEwOCwxMiArMTA4LDYgQEAgc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgb2N0ZW9u
X21kaW9idXNfZHJpdmVyID0gew0KPiAgIAkucmVtb3ZlCQk9IG9jdGVvbl9tZGlvYnVzX3JlbW92
ZSwNCj4gICB9Ow0KPiAgIA0KPiAtdm9pZCBvY3Rlb25fbWRpb2J1c19mb3JjZV9tb2RfZGVwZW5j
ZW5jeSh2b2lkKQ0KPiAtew0KPiAtCS8qIExldCBldGhlcm5ldCBkcml2ZXJzIGZvcmNlIHVzIHRv
IGJlIGxvYWRlZC4gICovDQo+IC19DQo+IC1FWFBPUlRfU1lNQk9MKG9jdGVvbl9tZGlvYnVzX2Zv
cmNlX21vZF9kZXBlbmNlbmN5KTsNCj4gLQ0KPiAgIG1vZHVsZV9wbGF0Zm9ybV9kcml2ZXIob2N0
ZW9uX21kaW9idXNfZHJpdmVyKTsNCj4gICANCj4gICBNT0RVTEVfREVTQ1JJUFRJT04oIkNhdml1
bSBPQ1RFT04gTURJTyBidXMgZHJpdmVyIik7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvb2N0ZW9uL2V0aGVybmV0LW1kaW8uYyBiL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJu
ZXQtbWRpby5jDQo+IGluZGV4IGM3OTg2NzJkNjFiMi4uY2ZiNjczYTUyYjI1IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3N0YWdpbmcvb2N0ZW9uL2V0aGVybmV0LW1kaW8uYw0KPiArKysgYi9kcml2
ZXJzL3N0YWdpbmcvb2N0ZW9uL2V0aGVybmV0LW1kaW8uYw0KPiBAQCAtMTYzLDcgKzE2Myw3IEBA
IGludCBjdm1fb2N0X3BoeV9zZXR1cF9kZXZpY2Uoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4g
ICAJb2Zfbm9kZV9wdXQocGh5X25vZGUpOw0KPiAgIA0KPiAgIAlpZiAoIXBoeWRldikNCj4gLQkJ
cmV0dXJuIC1FTk9ERVY7DQo+ICsJCXJldHVybiAtRVBST0JFX0RFRkVSOw0KPiAgIA0KPiAgIAlw
cml2LT5sYXN0X2xpbmsgPSAwOw0KPiAgIAlwaHlfc3RhcnQocGh5ZGV2KTsNCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJuZXQtbWRpby5oIGIvZHJpdmVycy9zdGFn
aW5nL29jdGVvbi9ldGhlcm5ldC1tZGlvLmgNCj4gaW5kZXggZTM3NzFkNDhjNDliLi43ZjY3MTZl
M2ZhZDQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJuZXQtbWRp
by5oDQo+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJuZXQtbWRpby5oDQo+IEBA
IC0yMiw3ICsyMiw1IEBADQo+ICAgDQo+ICAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBldGh0b29sX29w
cyBjdm1fb2N0X2V0aHRvb2xfb3BzOw0KPiAgIA0KPiAtdm9pZCBvY3Rlb25fbWRpb2J1c19mb3Jj
ZV9tb2RfZGVwZW5jZW5jeSh2b2lkKTsNCj4gLQ0KPiAgIGludCBjdm1fb2N0X2lvY3RsKHN0cnVj
dCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBpZnJlcSAqcnEsIGludCBjbWQpOw0KPiAgIGludCBj
dm1fb2N0X3BoeV9zZXR1cF9kZXZpY2Uoc3RydWN0IG5ldF9kZXZpY2UgKmRldik7DQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvb2N0ZW9uL2V0aGVybmV0LmMgYi9kcml2ZXJzL3N0YWdp
bmcvb2N0ZW9uL2V0aGVybmV0LmMNCj4gaW5kZXggZjQyYzM4MTZjZTQ5Li45MjBhYjA4ZTQzMTEg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJuZXQuYw0KPiArKysg
Yi9kcml2ZXJzL3N0YWdpbmcvb2N0ZW9uL2V0aGVybmV0LmMNCj4gQEAgLTY4OSw4ICs2ODksNiBA
QCBzdGF0aWMgaW50IGN2bV9vY3RfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikN
Cj4gICAJbXR1X292ZXJoZWFkICs9IFZMQU5fSExFTjsNCj4gICAjZW5kaWYNCj4gICANCj4gLQlv
Y3Rlb25fbWRpb2J1c19mb3JjZV9tb2RfZGVwZW5jZW5jeSgpOw0KPiAtDQo+ICAgCXBpcCA9IHBk
ZXYtPmRldi5vZl9ub2RlOw0KPiAgIAlpZiAoIXBpcCkgew0KPiAgIAkJcHJfZXJyKCJFcnJvcjog
Tm8gJ3BpcCcgaW4gL2FsaWFzZXNcbiIpOw==
