Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24772215030
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgGEWba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:31:30 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:51378 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:31:29 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2ED9B891B0;
        Mon,  6 Jul 2020 10:31:26 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593988286;
        bh=TqEWnjH6epoIDYsLN1Vn1x9frVtAn9euvR2ZctAOVNs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=QuNoNlMd4rIvNvfyajz+sACU3FJ1HaeiVt287rUC0FAG4P+rxakilcVWBJmdZrbGK
         gQU+ddFfGGcFSkQ53jlFhKzwz1OV9URjTdn4z3uXNfsjVicAPF2BFWhCVpE0xLS1gF
         0zZKt+5rHGeW6tUKjfrfIiLepjwSkEFsCQV1uzPQmKagZ1ttgA/RdYhhMdhlNBxA8d
         cPhPkDUH1We9RFKPnNkFpopBP8IY6ke0WZAGKHfMhvDiaxCkDuPCX9FPlvYLH+kMR6
         iZmwwZnuarrFebBUwjAwEwOTjNWraq1yUzX/AtGg9hHtIwUWpPnNpEL0vKmqV53eqp
         4mESDG02NGxrA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f0254bc0001>; Mon, 06 Jul 2020 10:31:24 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 6 Jul 2020 10:31:25 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 6 Jul 2020 10:31:25 +1200
From:   Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
To:     "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
Thread-Topic: [PATCH 0/5] RFC: connector: Add network namespace awareness
Thread-Index: AQHWUAeZm1sYS5RHpkWGl2iqUbu926j0pzwVgAQnkoA=
Date:   Sun, 5 Jul 2020 22:31:25 +0000
Message-ID: <94defa61204731d7dce37edeb98069c8647722c2.camel@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
         <87k0zlspxs.fsf@x220.int.ebiederm.org>
In-Reply-To: <87k0zlspxs.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:2e4d:54ff:fe4c:9ff0]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCB490D546836C4A83811EF4083AFC9F@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTAyIGF0IDEzOjU5IC0wNTAwLCBFcmljIFcuIEJpZWRlcm1hbiB3cm90
ZToNCj4gTWF0dCBCZW5uZXR0IDxtYXR0LmJlbm5ldHRAYWxsaWVkdGVsZXNpcy5jby5uej4gd3Jp
dGVzOg0KPiANCj4gPiBQcmV2aW91c2x5IHRoZSBjb25uZWN0b3IgZnVuY3Rpb25hbGl0eSBjb3Vs
ZCBvbmx5IGJlIHVzZWQgYnkgcHJvY2Vzc2VzIHJ1bm5pbmcgaW4gdGhlDQo+ID4gZGVmYXVsdCBu
ZXR3b3JrIG5hbWVzcGFjZS4gVGhpcyBtZWFudCB0aGF0IGFueSBwcm9jZXNzIHRoYXQgdXNlcyB0
aGUgY29ubmVjdG9yIGZ1bmN0aW9uYWxpdHkNCj4gPiBjb3VsZCBub3Qgb3BlcmF0ZSBjb3JyZWN0
bHkgd2hlbiBydW4gaW5zaWRlIGEgY29udGFpbmVyLiBUaGlzIGlzIGEgZHJhZnQgcGF0Y2ggc2Vy
aWVzIHRoYXQNCj4gPiBhdHRlbXB0cyB0byBub3cgYWxsb3cgdGhpcyBmdW5jdGlvbmFsaXR5IG91
dHNpZGUgb2YgdGhlIGRlZmF1bHQgbmV0d29yayBuYW1lc3BhY2UuDQo+ID4gDQo+ID4gSSBzZWUg
dGhpcyBoYXMgYmVlbiBkaXNjdXNzZWQgcHJldmlvdXNseSBbMV0sIGJ1dCBhbSBub3Qgc3VyZSBo
b3cgbXkgY2hhbmdlcyByZWxhdGUgdG8gYWxsDQo+ID4gb2YgdGhlIHRvcGljcyBkaXNjdXNzZWQg
dGhlcmUgYW5kL29yIGlmIHRoZXJlIGFyZSBhbnkgdW5pbnRlbmRlZCBzaWRlDQo+ID4gZWZmZWN0
cyBmcm9tIG15IGRyYWZ0DQo+IA0KPiBJbiBhIHF1aWNrIHNraW0gdGhpcyBwYXRjaHNldCBkb2Vz
IG5vdCBsb29rIGxpa2UgaXQgYXBwcm9hY2hlcyBhIGNvcnJlY3QNCj4gY29udmVyc2lvbiB0byBo
YXZpbmcgY29kZSB0aGF0IHdvcmtzIGluIG11bHRpcGxlIG5hbWVzcGFjZXMuDQo+IA0KPiBJIHdp
bGwgdGFrZSB0aGUgY2hhbmdlcyB0byBwcm9jX2lkX2Nvbm5lY3RvciBmb3IgZXhhbXBsZS4NCj4g
WW91IHJlcG9ydCB0aGUgdmFsdWVzIGluIHRoZSBjYWxsZXJzIGN1cnJlbnQgbmFtZXNwYWNlcy4N
Cj4gDQo+IFdoaWNoIG1lYW5zIGFuIHVucHJpdmlsZWdlZCB1c2VyIGNhbiBjcmVhdGUgYSB1c2Vy
IG5hbWVzcGFjZSBhbmQgZ2V0DQo+IGNvbm5lY3RvciB0byByZXBvcnQgd2hpY2hldmVyIGlkcyB0
aGV5IHdhbnQgdG8gdXNlcnMgaW4gYW5vdGhlcg0KPiBuYW1lc3BhY2UuICBBS0EgbGllLg0KPiAN
Cj4gU28gdGhpcyBhcHBlYXJzIHRvIG1ha2UgY29ubmVjdG9yIGNvbXBsZXRlbHkgdW5yZWxpYWJs
ZS4NCj4gDQo+IEVyaWMNCj4gDQoNCkhpIEVyaWMsDQoNClRoYW5rIHlvdSBmb3IgdGFraW5nIHRo
ZSB0aW1lIHRvIHJldmlldy4gSSB3cm90ZSB0aGVzZSBwYXRjaGVzIGluIGFuIGF0dGVtcHQgdG8g
c2hvdyB0aGF0IEkgd2FzIHdpbGxpbmcgdG8gZG8gdGhlIHdvcmsgbXlzZWxmIHJhdGhlciB0aGFu
IHNpbXBseQ0KYXNraW5nIGZvciBzb21lb25lIGVsc2UgdG8gZG8gaXQgZm9yIG1lLiBUaGUgY2hh
bmdlcyB3b3JrZWQgZm9yIG15IHVzZSBjYXNlcyB3aGVuIEkgdGVzdGVkIHRoZW0sIGJ1dCBJIGV4
cGVjdGVkIHRoYXQgc29tZSBvZiB0aGUgY2hhbmdlcyB3b3VsZCBiZQ0KaW5jb3JyZWN0IGFuZCB0
aGF0IEkgd291bGQgbmVlZCBzb21lIGd1aWRhbmNlLiBJIGNhbiBzcGVuZCBzb21lIHRpbWUgdG8g
cmVhbGx5IGRpZyBpbiBhbmQgZnVsbHkgdW5kZXJzdGFuZCB0aGUgY2hhbmdlcyBJIGFtIHRyeWlu
ZyB0byBtYWtlIChJIGhhdmUNCmxpbWl0ZWQga2VybmVsIGRldmVsb3BtZW50IGV4cGVyaWVuY2Up
IGJ1dCBiYXNlZCBvbiB0aGUgcmVzdCBvZiB0aGUgZGlzY3Vzc2lvbiB0aHJlYWRzIGl0IHNlZW1z
IHRoYXQgdGhlcmUgaXMgbGlrZWx5IG5vIGFwcGV0aXRlIHRvIGV2ZXIgc3VwcG9ydA0KbmFtZXNw
YWNlcyB3aXRoIHRoZSBjb25uZWN0b3IuDQoNCkJlc3QgcmVnYXJkcywNCk1hdHQNCg==
