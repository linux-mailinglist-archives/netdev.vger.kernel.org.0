Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF48C33106E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCHOLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:11:17 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:56068 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhCHOKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 09:10:50 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-63-Qmd1VIVuOpeiqYiz2g6OAQ-1; Mon, 08 Mar 2021 14:10:46 +0000
X-MC-Unique: Qmd1VIVuOpeiqYiz2g6OAQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Mar 2021 14:10:46 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Mar 2021 14:10:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alex Elder' <elder@linaro.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "stranche@codeaurora.org" <stranche@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "sharathv@codeaurora.org" <sharathv@codeaurora.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel test robot" <lkp@intel.com>
Subject: RE: [PATCH net-next v2 6/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum header
Thread-Topic: [PATCH net-next v2 6/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum header
Thread-Index: AQHXEjc7/Zo1a5kRlEyGQ6znWO97Lap545RAgAA+dgCAAAB3MA==
Date:   Mon, 8 Mar 2021 14:10:46 +0000
Message-ID: <8452678da3a647249780b60e857bb32a@AcuMS.aculab.com>
References: <20210306031550.26530-1-elder@linaro.org>
 <20210306031550.26530-7-elder@linaro.org>
 <498c301f517749fdbc9d3ff5529d71a6@AcuMS.aculab.com>
 <cc8e3bb0-81f0-070b-5b70-342dc172a1a2@linaro.org>
In-Reply-To: <cc8e3bb0-81f0-070b-5b70-342dc172a1a2@linaro.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li4uDQo+IFNvcnQgb2YgcmVsYXRlZCwgSSBoYXZlIGJlZW4gbWVhbmluZyB0byBlbGltaW5hdGUg
dGhlDQo+IHBvaW50bGVzcyBfX2FsaWduZWQoMSkgdGFncyBvbiBybW5ldCBzdHJ1Y3R1cmVzIGRl
ZmluZWQNCj4gaW4gPGxpbnV4L2lmX3JtbmV0Lmg+LiAgSXQgd291bGRuJ3QgaHVydCB0byB1c2Ug
X19wYWNrZWQsDQo+IHRob3VnaCBJIHRoaW5rIHRoZXkncmUgYWxsIDQgb3IgOCBieXRlcyBuYXR1
cmFsbHkgYW55d2F5Lg0KPiBQZXJoYXBzIG1hcmtpbmcgdGhlbSBfX2FsaWduZWQoNCkgd291bGQg
aGVscCBpZGVudGlmeQ0KPiBwb3RlbnRpYWwgdW5hbGlnbmVkIGFjY2Vzc2VzPw0KDQpEb24ndCB1
c2UgX19wYWNrZWQgKGV0YykgdW5sZXNzIHRoZSBkYXRhIG1pZ2h0IGJlIG1pc2FsaWduZWQuDQpJ
ZiB0aGUgYXJjaGl0ZWN0dXJlIGRvZXNuJ3Qgc3VwcG9ydCBtaXNhbGlnbmVkIG1lbW9yeQ0KYWNj
ZXNzZXMgdGhlbiB0aGUgY29tcGlsZXIgaGFzIHRvIGdlbmVyYXRlIGNvZGUgdGhhdA0KZG9lcyBi
eXRlIGFjY2Vzc2VzIGFuZCBzaGlmdHMuDQoNCl9fYWxpZ25lZCg0KSBpcyBtb3N0bHkgdXNlZnVs
IGZvciBzdHJ1Y3R1cmVzIHRoYXQgaGF2ZQ0KdG8gaGF2ZSBhbiA4LWJ5dGUgZmllbGQgb24gYSA0
LWJ5dGUgYm91bmRhcnkuDQooQXMgaGFwcGVucyBpbiB0aGUgeDg2IGNvbXBhdDMyIGNvZGUuKQ0K
DQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQs
IE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86
IDEzOTczODYgKFdhbGVzKQ0K

