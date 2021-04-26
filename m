Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A436BB2B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 23:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhDZV0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 17:26:33 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:56685 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhDZV0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 17:26:32 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C9161891AE;
        Tue, 27 Apr 2021 09:25:42 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1619472342;
        bh=g2nmzz+iF9AnESqZRCU3eNTJ2vsNP4pPDFPWeqtXgQw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=i7OGZ/jz4GL8AxW+dYkInYJapng7ijHut512W6M8pe0l0jtOD9wfnLdSOwewHjVUy
         v8UVkOvmGwhzHpAm38UN27fLCGLJsin3HZNnx2xKt7+6ZzEp5elgaSggfhEECrzU95
         Qj3WYtnBPwqsGmgE7kiQQLF1Oaa4PSQeOk1qTLhEeYmcb9qqGod8ozR5Sydwpar4fc
         cg1i11IRXXytgdrRRkP2xpRxlLcA+Fzx4RsaHMMcZAqoIuWOiqQOsM52iZrgD6c/vH
         tUBWs5ue4UX7i6ls46tjVBc9vfm9r4wr7zqoPT5NC+1V7jEDkrJmXpa1QaCFDpmJDE
         yvNXLkIf2fCBg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60872fd60001>; Tue, 27 Apr 2021 09:25:42 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 27 Apr 2021 09:25:42 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.015; Tue, 27 Apr 2021 09:25:42 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     =?utf-8?B?5pu554Wc?= <cao88yu@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mv88e6171r and mv88e6161 switch not working properly after commit
 0f3c66a3c7b4e8b9f654b3c998e9674376a51b0f
Thread-Topic: mv88e6171r and mv88e6161 switch not working properly after
 commit 0f3c66a3c7b4e8b9f654b3c998e9674376a51b0f
Thread-Index: AQHXOBZmIGlhuMeONku8NdcHoOSOH6rGjBOA
Date:   Mon, 26 Apr 2021 21:25:42 +0000
Message-ID: <b5768b0e-1c11-b817-b66f-c565c0afb910@alliedtelesis.co.nz>
References: <CACu-5+1X1y-DmbyqB4Tooj+DuARhK_V1F16Pa3hWNF9q0sexbg@mail.gmail.com>
In-Reply-To: <CACu-5+1X1y-DmbyqB4Tooj+DuARhK_V1F16Pa3hWNF9q0sexbg@mail.gmail.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <90D1DE511086194F843E2EAD5EF635B8@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=B+jHL9lM c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=3YhXtTcJ-WEA:10 a=myVwGOACAAAA:8 a=o6mhGMi_7v_8qPRsk9kA:9 a=QEXdDO2ut3YA:10 a=p5cQTkJONggA:10 a=PizmSyiMN4ROI5oN2gJl:22
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIDIzLzA0LzIxIDc6NTcgcG0sIOabueeFnCB3cm90ZToNCj4gSGksDQo+ICAgICAg
SSd2ZSBjb25maXJtZWQgdGhhdCB0aGUgbXY4OGU2MTcxciBhbmQgbXY4OGU2MTYxIHN3aXRjaCBy
dW4gaW50bw0KPiBNVFUgaXNzdWUgYWZ0ZXIgdGhhdCBjb21taXQgKGZyb20ga2VybmVsIDUuOS4w
IHRvIGtlcm5lbCA1LjEyLXJjKToNClNvcnJ5IHRvIGhlYXIgdGhhdC4NCj4gY29tbWl0IDBmM2M2
NmEzYzdiNGU4YjlmNjU0YjNjOTk4ZTk2NzQzNzZhNTFiMGYNCj4gQXV0aG9yOiBDaHJpcyBQYWNr
aGFtIDxjaHJpcy5wYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+DQo+IERhdGU6ICAgRnJpIEp1
bCAyNCAxMToyMToyMCAyMDIwICsxMjAwDQo+DQo+ICAgICAgbmV0OiBkc2E6IG12ODhlNnh4eDog
TVY4OEU2MDk3IGRvZXMgbm90IHN1cHBvcnQganVtYm8gY29uZmlndXJhdGlvbg0KPg0KPiAgICAg
IFRoZSBNVjg4RTYwOTcgY2hpcCBkb2VzIG5vdCBzdXBwb3J0IGNvbmZpZ3VyaW5nIGp1bWJvIGZy
YW1lcy4gUHJpb3IgdG8NCj4gICAgICBjb21taXQgNWY0MzY2NjYwZDY1IG9ubHkgdGhlIDYzNTIs
IDYzNTEsIDYxNjUgYW5kIDYzMjAgY2hpcHMgY29uZmlndXJlZA0KPiAgICAgIGp1bWJvIG1vZGUu
IFRoZSByZWZhY3RvciBhY2NpZGVudGFsbHkgYWRkZWQgdGhlIGZ1bmN0aW9uIGZvciB0aGUgNjA5
Ny4NCj4gICAgICBSZW1vdmUgdGhlIGVycm9uZW91cyBmdW5jdGlvbiBwb2ludGVyIGFzc2lnbm1l
bnQuDQo+DQpEbyB5b3UgbWVhbiBvbmUgb2YgdGhlIG90aGVyIGNvbW1pdHMgaW4gdGhhdCBzZXJp
ZXM/IEkgdGhpbmsgcGVyaGFwcyB0aGUgDQo4OGU2MTYxIGlzIG1pc3NpbmcgZnJvbSBjb21taXQg
MWJhZjBmYWMxMGZiICgibmV0OiBkc2E6IG12ODhlNnh4eDogVXNlIA0KY2hpcC13aWRlIG1heCBm
cmFtZSBzaXplIGZvciBNVFUiKS4gSSB3YXMgZG9pbmcgdGhhdCBtb3N0bHkgZnJvbSB0aGUgDQpk
YXRhc2hlZXRzIEkgaGFkIGF2YWlsYWJsZSBzbyBjb3VsZCBoYXZlIGVhc2lseSBtaXNzZWQgb25l
Lg0KDQo+IEFmdGVyIG15IG1vZGlmeToNCj4NCj4gcmVtb3ZlDQo+IC5wb3J0X3NldF9qdW1ib19z
aXplID0gbXY4OGU2MTY1X3BvcnRfc2V0X2p1bWJvX3NpemUsDQo+DQo+IGFkZA0KPiAuc2V0X21h
eF9mcmFtZV9zaXplID0gbXY4OGU2MTg1X2cxX3NldF9tYXhfZnJhbWVfc2l6ZSwNCj4NCj4gVGhl
IGlzc3VlIGlzIGdvbmUsIHNvIGNvdWxkIHlvdSBwbGVhc2UgY29tbWl0IGEgZml4IGZvciB0aGVz
ZSB0d28gY2hpcHM/DQpJJ20gdHJhdmVsaW5nIHJpZ2h0IG5vdyBidXQgSSBzaG91bGQgYmUgYWJs
ZSB0byB0YWtlIGEgbG9vayBuZXh0IHdlZWsgDQooYXNzdW1pbmcgc29tZW9uZSBlbHNlIGRvZXNu
J3QgYmVhdCBtZSB0byBpdCkuDQo+IFBTOiB0aGVyZSBhcmUgc29tZSBtb3JlIGluZm8gb24gdGhp
cyBwb3N0Og0KPiBodHRwczovL2ZvcnVtLmRvb3phbi5jb20vcmVhZC5waHA/MiwxMTk0NDkNCj4N
Cj4NCj4gUmVnYXJkcyE=
