Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14874294480
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409896AbgJTVYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:24:11 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:34611 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388189AbgJTVYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:24:08 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 52B6B806B7;
        Wed, 21 Oct 2020 10:24:05 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603229045;
        bh=0ivsRHeT+t3HrWxbqemy5pdAuw1H/86srNARdUIHiP4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=rGL0GJJRZLZFLUzqci7nUrRLxmykpLbs+lJrl25qAnxUZveMn805gX8DuitX4AYI3
         L7l93PhYXfnlKPyKMxPum8whdiywVkHhBqVpWm9YaB5jySK3AQ2t8vc7XYBbDdtnIl
         jCfISaCVUD+kcQcZY7BIlq/+MiuuSfzFpTCbBdChng7R30N4LFWGSu0hRsSFl7qarS
         DPdUlBGoxPkVLSYSK/k0HLtXodPFY0O0VkZjPy5wTK9An+pTrJMKbRaJL0m9l/4ZQ1
         l1/2elykpFFV1G5yBKHjoAxWVmZknZ3JvGj6PLpWbVegVv7dpvIDIf1rtyPa6jwO5W
         SM1nKtFGQVo0g==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8f55760001>; Wed, 21 Oct 2020 10:24:06 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct 2020 10:24:04 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Wed, 21 Oct 2020 10:24:04 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Thread-Topic: [PATCH v3 3/3] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Thread-Index: AQHWppOIHo6sjfIsxk6UhS3TBwc3O6mfbbqAgAC53AA=
Date:   Tue, 20 Oct 2020 21:24:04 +0000
Message-ID: <d4f6fab0-8099-7cc2-dfce-bd7a3363c131@alliedtelesis.co.nz>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-4-chris.packham@alliedtelesis.co.nz>
 <20201020101851.GC1551@shell.armlinux.org.uk>
In-Reply-To: <20201020101851.GC1551@shell.armlinux.org.uk>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <46F921CF8320284AB2383F39140BC84E@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMC8xMC8yMCAxMToxOCBwbSwgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIHdy
b3RlOg0KPiBPbiBUdWUsIE9jdCAyMCwgMjAyMCBhdCAwNDo0NTo1OFBNICsxMzAwLCBDaHJpcyBQ
YWNraGFtIHdyb3RlOg0KPj4gK3ZvaWQgbXY4OGU2MTIzX3NlcmRlc19nZXRfcmVncyhzdHJ1Y3Qg
bXY4OGU2eHh4X2NoaXAgKmNoaXAsIGludCBwb3J0LCB2b2lkICpfcCkNCj4+ICt7DQo+PiArCXUx
NiAqcCA9IF9wOw0KPj4gKwl1MTYgcmVnOw0KPj4gKwlpbnQgaTsNCj4+ICsNCj4+ICsJaWYgKG12
ODhlNnh4eF9zZXJkZXNfZ2V0X2xhbmUoY2hpcCwgcG9ydCkgPT0gMCkNCj4+ICsJCXJldHVybjsN
Cj4+ICsNCj4+ICsJZm9yIChpID0gMDsgaSA8IDI2OyBpKyspIHsNCj4+ICsJCW12ODhlNnh4eF9w
aHlfcmVhZChjaGlwLCBwb3J0LCBpLCAmcmVnKTsNCj4gU2hvdWxkbid0IHRoaXMgZGVhbCB3aXRo
IGEgZmFpbGVkIHJlYWQgaW4gc29tZSB3YXksIHJhdGhlciB0aGFuIGp1c3QNCj4gYXNzaWduaW5n
IHRoZSBsYXN0IG9yIHBvc3NpYmx5IHVuaW5pdGlhbGlzZWQgdmFsdWUgdG8gcFtpXSA/DQoNCm12
ODhlNjM5MF9zZXJkZXNfZ2V0X3JlZ3MoKSBhbmQgbXY4OGU2MzUyX3NlcmRlc19nZXRfcmVncygp
IGFsc28gaWdub3JlIA0KdGhlIGVycm9yLiBUaGUgZ2VuZXJpYyBtdjg4ZTZ4eHhfZ2V0X3JlZ3Mo
KSBtZW1zZXRzIHBbXSB0byAweGZmIHNvIGlmIA0KdGhlIHNlcmRlc19nZXRfcmVncyBmdW5jdGlv
bnMganVzdCBsZWZ0IGl0IGFsb25lIHdlJ2QgcmV0dXJuIDB4ZmZmZiANCndoaWNoIGlzIHByb2Jh
Ymx5IGJldHRlciB0aGFuIHJlcGVhdGluZyB0aGUgbGFzdCB2YWx1ZSBhbHRob3VnaCBpdCdzIA0K
c3RpbGwgYW1iaWd1b3VzIGJlY2F1c2UgMHhmZmZmIGlzIGEgdmFsaWQgdmFsdWUgZm9yIHBsZW50
eSBvZiB0aGVzZSANCnJlZ2lzdGVycy4NCg0KU2luY2UgaXQgbG9va3MgbGlrZSBJIG5lZWQgdG8g
Y29tZSB1cCB3aXRoIGFuIGFsdGVybmF0aXZlIHRvIHBhdGNoICMxIA0KSSdsbCBjb25jZW50cmF0
ZSBvbiB0aGF0IGJ1dCBtYWtpbmcgdGhlIHNlcmRlc19nZXRfcmVncygpIGEgbGl0dGxlIG1vcmUg
DQplcnJvciB0b2xlcmFudCBpcyBhIGNsZWFudXAgSSBjYW4gZWFzaWx5IHRhY2sgb24gb250byB0
aGlzIHNlcmllcy4NCg==
