Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B375E22B81D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGWUuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:50:32 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:45918 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgGWUub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:50:31 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 4212B891B2;
        Fri, 24 Jul 2020 08:50:28 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595537428;
        bh=bFGhv4awXiWM6YUSOqX3rx29Y8lX1g9yRojTsB4tHLQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=g1iOIuI9jJ5oxyauQwNSJFEDpXKtdCzlxi5wi88Ygj63ecN00xHOITrLzBlgqlFle
         fq4DCxB5Gt6Y5FGPKMH4nnS+ogj17hgx7rpQmIHE2QngmLbrR1QFYpkBx3IAVPkX9G
         6agTOCGEqDmi9uT91/rOhjX5XTd0GHEhq31uNGPaVtPCMZ2IsphwfGUo3LpogSac5/
         jced6rFzOy0troDmcluWQZWwGqafvXUX4cdMUoCz9cGNbv+SsYn/fi/tZMC9mxiLRR
         GW6W2I2yzZII8d7h83tvloH8lw9+pyhHXeqsqx1Xf6bkdXaaJCMWWxmGq4Ifn/Nsh2
         d6CqqoC0gwtkg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f19f8130000>; Fri, 24 Jul 2020 08:50:27 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 24 Jul 2020 08:50:27 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Fri, 24 Jul 2020 08:50:27 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: dsa: mv88e6xxx: Implement
 .port_change_mtu/.port_max_mtu
Thread-Topic: [PATCH 3/4] net: dsa: mv88e6xxx: Implement
 .port_change_mtu/.port_max_mtu
Thread-Index: AQHWYKW3b1TNxAifGUKdmWah9S8H2akUYKYAgAB6rYA=
Date:   Thu, 23 Jul 2020 20:50:27 +0000
Message-ID: <e10da452-c04a-b519-6c30-c94e60101f92@alliedtelesis.co.nz>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-4-chris.packham@alliedtelesis.co.nz>
 <20200723133122.GB1553578@lunn.ch>
In-Reply-To: <20200723133122.GB1553578@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF49CCFB6891BE45BA8634A70F270D19@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyNC8wNy8yMCAxOjMxIGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gVGh1LCBKdWwg
MjMsIDIwMjAgYXQgMDM6NTk6NDFQTSArMTIwMCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IEFk
ZCBpbXBsZW1lbnRhdGlvbnMgZm9yIHRoZSBtdjg4ZTZ4eHggc3dpdGNoZXMgdG8gY29ubmVjdCB3
aXRoIHRoZQ0KPj4gZ2VuZXJpYyBkc2Egb3BlcmF0aW9ucyBmb3IgY29uZmlndXJpbmcgdGhlIHBv
cnQgTVRVLg0KPiBIaSBDaHJpcw0KPg0KPiBXaGF0IHRyZWUgaXMgdGhpcyBhZ2FpbnN0Pw0KJCBn
aXQgY29uZmlnIHJlbW90ZS5vcmlnaW4udXJsDQpnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0DQokIGdpdCBkZXNjcmliZSBgZ2l0
IG1lcmdlLWJhc2UgSEVBRCBvcmlnaW4vbWFzdGVyYA0KdjUuOC1yYzYtMy1nNGZhNjQwZGM1MjMw
DQoNCj4gY29tbWl0IDJhNTUwYWVjMzY1NDNiMjBmMDg3ZTRiMzA2Mzg4MmU5NDY1ZjcxNzUNCj4g
QXV0aG9yOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IERhdGU6ICAgU2F0IEp1bCAx
MSAyMjozMjowNSAyMDIwICswMjAwDQo+DQo+ICAgICAgbmV0OiBkc2E6IG12ODhlNnh4eDogSW1w
bGVtZW50IE1UVSBjaGFuZ2UNCj4gICAgICANCj4gICAgICBUaGUgTWFydmVsbCBTd2l0Y2hlcyBz
dXBwb3J0IGp1bWJvIHBhY2thZ2VzLiBTbyBpbXBsZW1lbnQgdGhlDQo+ICAgICAgY2FsbGJhY2tz
IG5lZWRlZCBmb3IgY2hhbmdpbmcgdGhlIE1UVS4NCj4gICAgICANCj4gICAgICBTaWduZWQtb2Zm
LWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+ICAgICAgU2lnbmVkLW9mZi1ieTog
RGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPg0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2
eHh4L2NoaXAuYw0KPiBpbmRleCBkOTk1ZjViZjBkNDAuLjZmMDE5OTU1YWU0MiAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCj4gQEAgLTI2OTMsNiArMjY5MywzMSBAQCBzdGF0aWMg
aW50IG12ODhlNnh4eF9zZXR1cF9wb3J0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50
IHBvcnQpDQo+ICAgICAgICAgIHJldHVybiBtdjg4ZTZ4eHhfcG9ydF93cml0ZShjaGlwLCBwb3J0
LCBNVjg4RTZYWFhfUE9SVF9ERUZBVUxUX1ZMQU4sIDApOw0KPiAgIH0NCj4gICANCj4gK3N0YXRp
YyBpbnQgbXY4OGU2eHh4X2dldF9tYXhfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBv
cnQpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwID0gZHMtPnBy
aXY7DQo+ICsNCj4gKyAgICAgICBpZiAoY2hpcC0+aW5mby0+b3BzLT5wb3J0X3NldF9qdW1ib19z
aXplKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIDEwMjQwOw0KPiArICAgICAgIHJldHVybiAx
NTIyOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IG12ODhlNnh4eF9jaGFuZ2VfbXR1KHN0cnVj
dCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsIGludCBuZXdfbXR1KQ0KPiArew0KPiAuLi4NClNu
YXAuIEkgY3JlYXRlZCBteSBzZXJpZXMgYmVjYXVzZSBJIG5lZWQgaXQgb24gYW4gaW50ZXJuYWwg
NS43IGJhc2VkIA0Ka2VybmVsLiBTbyBJJ20gaGFwcHkgdG8gZHJvcCBtaW5lIGFuZCBiYWNrLXBv
cnQgeW91ciBpbXBsZW1lbnRhdGlvbi4=
