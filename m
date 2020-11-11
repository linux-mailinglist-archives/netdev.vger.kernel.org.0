Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99342AFB2A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgKKWNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:13:38 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:41220 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKWNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:13:37 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C92A5806AC
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:13:31 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1605132811;
        bh=vIN1OzWICai1MLpoZ9bCXQAiBRN4ZE0ntuSY3/EiR1Q=;
        h=From:To:CC:Subject:Date;
        b=wWSWfxAlcd8GtAQkCFoPf49wZLzS7oZp9UBMRuPbEypJXMb/l478guU/7lSHu0xkU
         AFZM9EspPayDUE4VuKGfjvjPfy6fUoEJCbv0pfjoUIJjlsWoCdBU0yEd33pamyp6kS
         0N073+54au7kaWSHmvPVTBFqmW11ptRfzqpbM6G6X55NIkk6i/25cY6e/5uwhMxPJQ
         nAZjlHb4C6a1ckZqFQ99bAhxNjC98NN3t5XABetWvyhQLHkhCKdd4t71ONiQyaKulr
         +EImuti9MmJzOg6u8rq1sQZOqFGUxoya1NO/oYJSe2K5Ve2UQ5iksoVF7ixErcADj3
         xOr/ALqq3M5Rg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fac620c0001>; Thu, 12 Nov 2020 11:13:32 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Nov 2020 11:13:31 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.007; Thu, 12 Nov 2020 11:13:31 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "vadym.kochan@plvision.eu" <vadym.kochan@plvision.eu>
CC:     netdev <netdev@vger.kernel.org>
Subject: Marvell Prestera Switchdev driver
Thread-Topic: Marvell Prestera Switchdev driver
Thread-Index: AQHWuHfjzyllr479xke0q4KbHbjsDQ==
Date:   Wed, 11 Nov 2020 22:13:30 +0000
Message-ID: <e83a263f-26e3-7d96-5808-2bbf3e89ead9@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <29BA8A3E5B41BE4FBBDBD2FAE2F2A91F@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmFkeW0sDQoNCldlIChBbGxpZWQgVGVsZXNpcykgaGF2ZSBnb3Qgc29tZSBmdW5kaW5nIGZv
ciBhIHVuaXZlcnNpdHkgc3R1ZGVudCAoaS5lLiANCmFuIGludGVybikgb3ZlciB0aGUgc291dGhl
cm4gaGVtaXNwaGVyZSBzdW1tZXIgKH4gTm92LUZlYikuIEkgd2FzIGdvaW5nIA0KdG8gaGF2ZSB0
aGVtIGRvIGEgbGl0dGxlIHJlc2VhcmNoIGludG8gc3dpdGNoZGV2LCBzcGVjaWZpY2FsbHkgdGhl
IA0KUHJlc3RlcmEgQUMzeCBzdXBwb3J0IHlvdSByZWNlbnRseSBsYW5kZWQgdXBzdHJlYW0uDQoN
CldlJ3ZlIGdvdCBhIE1hcnZlbGwgUkQgYm9hcmQgYW5kIG91ciBvd24gY3VzdG9tIGJvYXJkcyB3
aXRoIEFDM3ggDQpzaWxpY29uLiBQYXJ0IG9mIHRoZSBzdW1tZXIgcHJvamVjdCB3aWxsIGJlIGF0
dGVtcHRpbmcgdG8gZ2V0IHN1cHBvcnQgDQpmb3IgdGhlIGJvYXJkcyB1cHN0cmVhbSAocHJvYmFi
bHkganVzdCBhIGNvdXBsZSBvZiBkdHMgZmlsZXMpLiBJcyB0aGVyZSANCmFueXRoaW5nIG9uIHRo
ZSBzd2l0Y2hkZXYvcHJlc3RlcmEgc2lkZSB0aGF0IHlvdSB0aGluayB3b3VsZCBiZSBnb29kIHRv
IA0Kd29yayBvbj8NCg0KVGhhbmtzLA0KQ2hyaXMNCg==
