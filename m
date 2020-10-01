Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3F27F7FA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgJAC1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgJAC1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 22:27:24 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF88C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 19:27:23 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9FE6C891B0;
        Thu,  1 Oct 2020 15:27:19 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1601519239;
        bh=3q7aujyn5aL4eaHXCx1VapiKJR7f3QT246G8DzGsvfU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=Zr+yQ4K6zBjWDAJvU9ragAM8RQguacrEdWWpqtH7DbzoGvesYuWWS8+F5Dj0AmNnw
         M77qpbJ8G9gkwhZWbtw5xoGTEgMEsc5WqO9dFQhapawcQzcTQG4TO5jJZhH4TDUSlv
         9esc2eUTrSpl68s5nuQ/7qe4G/6w4Y1oblcBc3+C5+KszVYH9xBygXsTdHvXQT3MdM
         vnbZPPEtks+udMjQxSccmwyN5EdM7rUMQC/hgEBsWAL+4FEOLqnjUm5TkTh3TKYe5A
         BQE4b4oeLJZsOaEoqLm1dUF537emqG6sxsq/x5CDD6QuP7S1Nchn0tNacLyg4ERmjn
         SH64Lb00WO1/g==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f753e870001>; Thu, 01 Oct 2020 15:27:19 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 1 Oct 2020 15:27:19 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 1 Oct 2020 15:27:19 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dsa: mv88e6xxx: serdes link without phy
Thread-Topic: dsa: mv88e6xxx: serdes link without phy
Thread-Index: AQHWl4wd1x9X1OqsB0SXADYVDL5/gKmBGhoAgAARowA=
Date:   Thu, 1 Oct 2020 02:27:18 +0000
Message-ID: <e2c1196a-3a0f-6527-2ae0-8d53af2912df@alliedtelesis.co.nz>
References: <72e8e25a-db0d-275f-e80e-0b74bf112832@alliedtelesis.co.nz>
 <20201001012410.GA4050473@lunn.ch>
In-Reply-To: <20201001012410.GA4050473@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <55011007F62D2545A9F95AE6D2A04BCF@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzEwLzIwIDI6MjQgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4gICDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBvcnRAOCB7DQo+PiAgIMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJlZyA9IDw4PjsNCj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGFiZWwgPSAiaW50ZXJuYWw4IjsNCj4+ICAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cGh5LW1vZGUgPSAicmdtaWktaWQiOw0KPj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmaXhlZC1saW5rIHsNCj4+ICAgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNwZWVkID0gPDEwMDA+Ow0KPj4gICDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZnVsbC1kdXBsZXg7DQo+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH07DQo+PiAgIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfTsNCj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwb3J0QDkgew0KPj4gICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSA8
OT47DQo+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGxhYmVsID0gImludGVybmFsOSI7DQo+PiAgIMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBoeS1tb2Rl
ID0gInJnbWlpLWlkIjsNCj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZml4ZWQtbGluayB7DQo+PiAgIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBzcGVlZCA9IDwxMDAwPjsNCj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZ1
bGwtZHVwbGV4Ow0KPj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Ow0KPj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIH07DQo+PiBUaGUgcHJvYmxlbSBpcyB0aGF0IGJ5IGRlY2xh
cmluZyBwb3J0cyA4ICYgOSBhcyBmaXhlZCBsaW5rIHRoZSBkcml2ZXINCj4+IHNldHMgdGhlIEZv
cmNlZExpbmsgaW4gdGhlIFBDUyBjb250cm9sIHJlZ2lzdGVyLiBXaGljaCBtb3N0bHkgd29ya3Mu
DQo+PiBFeGNlcHQgaWYgSSBhZGQgYSBjaGFzc2lzIGNvbnRyb2xsZXIgd2hpbGUgdGhlIHN5c3Rl
bSBpcyBydW5uaW5nIChvciBvbmUNCj4+IGlzIHJlYm9vdGVkKSB0aGVuIHRoZSBuZXdseSBhZGRl
ZCBjb250cm9sbGVyIGRvZXNuJ3Qgc2VlIGEgbGluayBvbiB0aGUNCj4+IHNlcmRlcy4NCj4gSGkg
Q2hyaXMNCj4NCj4gWW91IHNheSBTRVJERVMgaGVyZSwgYnV0IGluIERUIHlvdSBoYXZlIHJnbWlp
LWlkPw0KWWVhaCB0aGF0J3MgbW9zdGx5IGJlY2F1c2UgaXQgd2FzIGNvcGllZCBmcm9tIHRoZSBD
UFUgcG9ydCAod2hpY2ggaXMgDQpSR01JSSB3aXRoIGludGVybmFsIGRlbGF5KS4gVGhlIE1hcnZl
bGwgZGF0YXNoZWV0IHNheXMgIlNFUkRFUyIgc28gSSANCndhc24ndCByZWFsbHkgc3VyZSB3aGF0
IHRvIHB1dCBoZXJlDQo+IENhbiB5b3UgcnVuIDEwMDBCYXNlLVggb3ZlciB0aGVzZSBsaW5rcz8N
CldpdGggc29tZSByZWFkaW5nICIxMDAwYmFzZS14IiBkb2VzIHNlZW0gdGhlIHJpZ2h0IHRoaW5n
IHRvIHNheSBoZXJlLiANCkl0J3MgZXZlbiB3aGF0IGlzIHJlZmxlY3RlZCBpbiB0aGUgQ01PREUg
ZmllbGQgZm9yIHRob3NlIHBvcnRzLg0KPiBJZiB5b3UgY2FuLCBpdCBpcyBwcm9iYWJseQ0KPiB3
b3J0aCBjaGF0dGluZyB0byBSdXNzZWxsIEtpbmcgYWJvdXQgdXNpbmcgaW5iYW5kLXNpZ25hbGxp
bmcsIGFuZCB3aGF0DQo+IGlzIG5lZWRlZCB0byBtYWtlIGl0IHdvcmsgd2l0aG91dCBoYXZpbmcg
YmFjayB0byBiYWNrIFNGUHMuIElmIGkNCj4gcmVtZW1iZXIgY29ycmVjdGx5LCBSdXNzZWxsIGhh
cyBzYWlkIG5vdCBtdWNoIGlzIGFjdHVhbGx5IG5lZWRlZC4NCg0KVGhhdCdkIGJlIGlkZWFsLiBU
aGUgc3RpY2tpbmcgcG9pbnQgc2VlbXMgdG8gYmUgYWxsb3dpbmcgaXQgdG8gaGF2ZSBubyBQSFku
DQo=
