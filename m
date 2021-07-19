Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED23CF27E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 05:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbhGTCmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 22:42:10 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:50829 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348153AbhGSVEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:04:53 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 019E8806B6;
        Tue, 20 Jul 2021 09:44:35 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1626731075;
        bh=arTStlnRLucuQiOyAqdPWMy1jWTooNhp27kK8HT5aGo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=TAPBWMPS5JPCaf7MP02z8Rju9CZ/crjx53q48Fm1Ieb3uHX+glDvQNsKQtNEZujLN
         JEaDMq7PDWn0a5IAzfCGLHhnKgnLshv7Gi2EAsYGP1LZv1R+vnpsmdqKqWycgtw/9S
         XEVCsGHInUqazNbYCUOxqXc5ohd5VzlmFPZTL8HC33ymybEOdoJCrm2IwmEopXA1RY
         ncssO5U96/fSRyC3rbZHIUoXAhmIlzJwn7PU1LDC20awT7sZVaas7wNzIVtex2XCEz
         /o1zlmTSVTIZPpKdj0//i/s7gngCQHhXHzQyZ/0oq5oYYJlvuSPkjiHfDtl2a9Sme9
         TInGV1fYKWs9Q==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60f5f2420001>; Tue, 20 Jul 2021 09:44:34 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.23; Tue, 20 Jul 2021 09:44:34 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.023; Tue, 20 Jul 2021 09:44:34 +1200
From:   Richard Laing <Richard.Laing@alliedtelesis.co.nz>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bus: mhi: pci-generic: configurable network interface MRU
Thread-Topic: [PATCH] bus: mhi: pci-generic: configurable network interface
 MRU
Thread-Index: AQHXePXNQwvlV1kNe0CXQRxG8ENZtqtJUccAgADBqIA=
Date:   Mon, 19 Jul 2021 21:44:33 +0000
Message-ID: <5165a859-1b00-e50e-985e-25044cf0e9ec@alliedtelesis.co.nz>
References: <20210714211805.22350-1-richard.laing@alliedtelesis.co.nz>
 <CAMZdPi-1E5pieVwt_XFF-+PML-cX05nM=PdD0pApD_ym5k_uMQ@mail.gmail.com>
In-Reply-To: <CAMZdPi-1E5pieVwt_XFF-+PML-cX05nM=PdD0pApD_ym5k_uMQ@mail.gmail.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.16.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3218BD5D940284481E061C0BF8A5B60@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=dvql9Go4 c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=8KpF8ikWtqQA:10 a=IkcTkHD0fZMA:10 a=e_q4qTt1xDgA:10 a=893OgPLA04CPpLZ5ZCUA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTG9pYywNCg0KT24gNy8xOS8yMSAxMDoxMSBQTSwgTG9pYyBQb3VsYWluIHdyb3RlOg0KPiBG
b3IgbXkgaW50ZXJlc3QgZG8geW91IGhhdmUgc29tZSBudW1iZXJzIGhlcmUgaGlnaGxpZ2h0aW5n
IGltcHJvdmVtZW50Pw0KVGhlc2UgYXJlIHNvbWUgb2YgdGhlIG51bWJlcnMgd2UgZm91bmQgZnJv
bSBpbml0aWFsIHRlc3RpbmcgdXNpbmcgYW4gDQpleHRlcm5hbCBwYWNrZXQgZ2VuZXJhdG9yOg0K
DQpwYWNrZXQgc2l6ZcKgwqDCoCBwYWNrZXRzIHNlbnTCoCB0aHJvdWdocHV0ICglcHBzKQ0KNjTC
oMKgwqAgwqDCoMKgwqDCoMKgwqDCoCAxMDAwMDAwwqDCoMKgIMKgwqDCoCA2LjIxJQ0KMTI4wqDC
oMKgIMKgwqAgwqAgwqDCoCAxMDAwMDAwwqDCoMKgIMKgwqDCoCA3LjQyJQ0KMjU2wqDCoMKgIMKg
wqDCoMKgwqDCoMKgIDEwMDAwMDDCoMKgwqAgwqDCoMKgIDEwLjc5JQ0KNTEywqDCoMKgIMKgIMKg
IMKgIMKgIDEwMDAwMDDCoMKgwqAgwqDCoMKgIDE2LjQwJQ0KMTAyNMKgwqDCoCDCoMKgwqDCoMKg
wqAgMTAwMDAwMMKgwqDCoCDCoMKgwqAgMzQuMzQlDQoxMjYywqDCoMKgIMKgwqAgwqAgwqAgMTAw
MDAwMMKgwqDCoCDCoMKgwqAgNDMuODIlDQoxMjYzwqDCoMKgIMKgwqAgwqAgwqAgMTAwMDAwMMKg
wqDCoCDCoMKgwqAgMjIuNDUlwqDCoMKgIDwtLQ0KMTI4MMKgwqDCoCDCoMKgIMKgIMKgIDEwMDAw
MDDCoMKgwqAgwqDCoMKgIDIzLjE1JQ0KMTUwMMKgwqDCoCDCoMKgIMKgIMKgIDEwMDAwMDDCoMKg
wqAgwqDCoMKgIDQ2LjMyJQ0KMTUxOMKgwqDCoCDCoMKgIMKgIMKgIDEwMDAwMDDCoMKgwqAgwqDC
oMKgIDQ2Ljg0JQ0KDQpZb3UgY2FuIHNlZSB0aGUgc3VkZGVuIGRyb3Agb2YgYWxtb3N0IDUwJSBi
ZXR3ZWVuIDEyNjIgYW5kIDEyNjMgYnl0ZSANCnBhY2tldHMuIFRoaXMgaXMgd2hhdCBjYXVzZWQg
dXMgdG8gaW52ZXN0aWdhdGUgZnVydGhlci4gRm9sbG93aW5nIHRoZSANCmNoYW5nZSB0byAzMktC
IGJ1ZmZlcnMgdGhlIGRyb3AgaW4gdGhyb3VnaHB1dCBpcyBubyBsb25nZXIgc2Vlbi4NCg0KcGFj
a2V0IHNpemXCoMKgwqAgcGFja2V0cyBzZW50wqAgdGhyb3VnaHB1dCAoJXBwcykNCjY0wqDCoMKg
IMKgwqDCoMKgwqDCoMKgwqAgMTAwMDAwMMKgwqDCoCDCoMKgIDQuNDElDQoxMjjCoMKgwqAgwqAg
wqAgwqAgwqAgMTAwMDAwMMKgwqDCoCDCoMKgIDcuNzAlDQoyNTbCoMKgwqAgwqDCoCDCoCDCoMKg
IDEwMDAwMDDCoMKgwqAgwqDCoCAxNC4yNiUNCjUxMsKgwqDCoCDCoMKgIMKgIMKgwqAgMTAwMDAw
MMKgwqDCoCDCoMKgIDI3LjA2JQ0KMTAyNMKgwqDCoCDCoCDCoCDCoMKgIDEwMDAwMDDCoMKgwqAg
wqDCoCA0OS4zOSUNCjEyODDCoMKgwqAgwqDCoCDCoCDCoCAxMDAwMDAwwqDCoMKgIMKgwqAgNTgu
ODIlDQoxNDI4wqDCoMKgIMKgwqAgwqAgwqAgMTAwMDAwMMKgwqDCoCDCoMKgIDYyLjYzJQ0KDQpJ
biBhbGwgY2FzZXMgd2Ugd2VyZSB0ZXN0aW5nIHdpdGggdGhlIG1vZGVtIGl0c2VsZiBpbiBpbnRl
cm5hbCBsb29wYmFjayANCm1vZGUuDQoNCldlIGhhdmUgbm90ZWQgdGhhdCBvdXIgbW9kZW0gZGVm
YXVsdHMgdG8gMzJLQiBidWZmZXJzIChhbmQgYSBtYXhpbXVtIG9mIA0KMzIgcGFja2V0cyBwZXIg
YnVmZmVyKSBhbmQgYWxzbyB0aGF0IHRoZXNlIHZhbHVlcyBjYW4gYmUgY2hhbmdlZC4gV2UgYXJl
IA0KY29uc2lkZXJpbmcgYWRkaW5nIHRoZSBhYmlsaXR5IHRvIHR1bmUgdGhlIGJ1ZmZlciBzaXpl
LCBwZXJoYXBzIGFkZGluZyBhIA0Kc3lzZnMgZW50cnkgb3IgbmV0bGluayBtZXNzYWdlIHRvIGNo
YW5nZSB0aGUgYnVmZmVyIHNpemUgaW5zdGVhZCBvZiB0aGUgDQpoYXJkIGNvZGVkIHZhbHVlLiBB
bnkgY29tbWVudHMgd291bGQgYmUgYXBwcmVjaWF0ZWQuDQoNClJlZ2FyZHMsDQpSaWNoYXJkDQoN
Cg0KDQo=
