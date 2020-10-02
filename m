Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18787280C9A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 06:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgJBENV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 00:13:21 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:41041 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBENV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 00:13:21 -0400
X-Greylist: delayed 98887 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2020 00:13:20 EDT
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 7AF9383640;
        Fri,  2 Oct 2020 17:13:18 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1601611998;
        bh=4oz/oKoF+lZpfXkTSL8gENBk4/Z/ClPql25fmVsmNqw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=CIGkEyRBG2+ThaU537abtygQi7FbSRNzFerdT4pzyyyUgcb6Yoz+A8xMabdYLdkbR
         2Br9Puyb8Xz5l73KpdqmwAC+6zw7/Mfp0cn9gtoWUcanJGNEhCJkEcKgePFv3wDuCW
         pAUS6iIwaHVzfyysoF7tYVMqHAiRNtGPTGMCgVqFMm1UfCipdzVUhfyG0CdCbW71cY
         vNUweUMkrmsJL8kCd2j8jxooQkIM4bUTVYQfvKbsCCLtEIgEMwtX8HM1h5ml9bZvq/
         odxPgUrrHFhEre4dAjnfyTTfl6jc16G1sXLHC+FsnAoPWEpk17Uxv45PvPNl7va6bo
         1tOCk46Ni5AvQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f76a8d70000>; Fri, 02 Oct 2020 17:13:11 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 2 Oct 2020 17:13:05 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Fri, 2 Oct 2020 17:13:05 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King <linux@armlinux.org.uk>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dsa: mv88e6xxx: serdes link without phy
Thread-Topic: dsa: mv88e6xxx: serdes link without phy
Thread-Index: AQHWl4wd1x9X1OqsB0SXADYVDL5/gKmBGhoAgAARowCAAKpMgIABBZeA
Date:   Fri, 2 Oct 2020 04:13:05 +0000
Message-ID: <5789dbdb-da65-f3be-a65d-038750acde43@alliedtelesis.co.nz>
References: <72e8e25a-db0d-275f-e80e-0b74bf112832@alliedtelesis.co.nz>
 <20201001012410.GA4050473@lunn.ch>
 <e2c1196a-3a0f-6527-2ae0-8d53af2912df@alliedtelesis.co.nz>
 <20201001123649.GC4050473@lunn.ch>
In-Reply-To: <20201001123649.GC4050473@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6303FFD0BF9B44183178889C6DD8D21@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzEwLzIwIDE6MzYgYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+IENhbiB5b3UgcnVu
IDEwMDBCYXNlLVggb3ZlciB0aGVzZSBsaW5rcz8NCj4+IFdpdGggc29tZSByZWFkaW5nICIxMDAw
YmFzZS14IiBkb2VzIHNlZW0gdGhlIHJpZ2h0IHRoaW5nIHRvIHNheSBoZXJlLg0KPj4gSXQncyBl
dmVuIHdoYXQgaXMgcmVmbGVjdGVkIGluIHRoZSBDTU9ERSBmaWVsZCBmb3IgdGhvc2UgcG9ydHMu
DQo+IE9uZSBtb3JlIHRoaW5nIHlvdSBtaWdodCBuZWVkIGlzDQo+DQo+IG1hbmFnZWQgPSAiaW4t
YmFuZC1zdGF0dXMiOw0KPg0KPj4+IElmIHlvdSBjYW4sIGl0IGlzIHByb2JhYmx5DQo+Pj4gd29y
dGggY2hhdHRpbmcgdG8gUnVzc2VsbCBLaW5nIGFib3V0IHVzaW5nIGluYmFuZC1zaWduYWxsaW5n
LCBhbmQgd2hhdA0KPj4+IGlzIG5lZWRlZCB0byBtYWtlIGl0IHdvcmsgd2l0aG91dCBoYXZpbmcg
YmFjayB0byBiYWNrIFNGUHMuIElmIGkNCj4+PiByZW1lbWJlciBjb3JyZWN0bHksIFJ1c3NlbGwg
aGFzIHNhaWQgbm90IG11Y2ggaXMgYWN0dWFsbHkgbmVlZGVkLg0KPj4gVGhhdCdkIGJlIGlkZWFs
LiBUaGUgc3RpY2tpbmcgcG9pbnQgc2VlbXMgdG8gYmUgYWxsb3dpbmcgaXQgdG8gaGF2ZSBubyBQ
SFkuDQo+IEkgdGhpbmsgdGhlcmUgaXMgbW9yZSB0byBpdCB0aGFuIHRoYXQuIFRoaXMgaXMgbmV3
IGdyb3VuZCB0byBzb21lDQo+IGV4dGVudC4NCg0KbWFuYWdlZCA9ICJpbi1iYW5kLXN0YXR1cyI7
IGhlbHBzIHRvIGNvbnZpbmNlIHRoaW5ncyB0aGF0IHRoZXJlIGlzbid0IGEgDQpQSFkuIEkgbmVl
ZCB0byB1cGRhdGUgbXY4OGU2eHh4X21hY19saW5rX3VwIHRvIG5vdCBmb3JjZSB0aGUgbGluayB3
aGVuIA0KbW9kZSA9PSBNTE9fQU5fSU5CQU5ELg0KDQpJIGFsc28gaGF2ZSBhIHByb2JsZW0gd2l0
aCBtdjg4ZTZ4eHhfc2VyZGVzX3Bjc19nZXRfc3RhdGUgZXhwZWN0aW5nIA0KbXY4OGU2eHh4X3Nl
cmRlc19nZXRfbGFuZSgpIHRvIHJldHVybiBhIGxhbmUgbnVtYmVyLiBJbXBsZW1lbnRpbmcgDQpt
djg4ZTZ4eHhfc2VyZGVzX2dldF9sYW5lKCkgZm9yIHRoZSBtdjg4ZTYwOTcgY2F1c2VzIGEgbG90
IG9mIG90aGVyIGNvZGUgDQpwYXRocyB0byB0cmlnZ2VyIHdoaWNoIGRpZG4ndCBiZWZvcmUuIEkg
dGhpbmsgSSdtIGNsb3NlIHRvIGdldHRpbmcgDQpzb21ldGhpbmcgc2Vuc2libGUgd29ya2luZyBm
b3IgbXkgaGFyZHdhcmUgYnV0IEknbSBvZmYgb24gbGVhdmUgZm9yIGEgDQp3ZWVrIHNvIEkganVz
dCB3YW50ZWQgdG8gZ2V0IHRoaXMgb3V0IGJlZm9yZSBJIGdvLg0K
