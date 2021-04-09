Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C445735A496
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhDIRYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:24:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:33971 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234163AbhDIRYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 13:24:38 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-48-ln2KbiuqPvaZzMYR95nVZQ-1; Fri, 09 Apr 2021 18:24:21 +0100
X-MC-Unique: ln2KbiuqPvaZzMYR95nVZQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 9 Apr 2021 18:24:14 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Fri, 9 Apr 2021 18:24:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sven Van Asbroeck' <thesven73@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     George McCollister <george.mccollister@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
Thread-Topic: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
Thread-Index: AQHXLKX9yeMJ8Y9FRkulXregE9xpyqqsb2bw
Date:   Fri, 9 Apr 2021 17:24:14 +0000
Message-ID: <55ddacc3b51347ebb439c3f134344a21@AcuMS.aculab.com>
References: <20210408172353.21143-1-TheSven73@gmail.com>
 <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
 <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com>
 <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
 <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
In-Reply-To: <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com>
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

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sNCj4gU2VudDogMDggQXByaWwgMjAyMSAxOTozNQ0KLi4u
DQo+IC0gICAgICAgYnVmZmVyX2xlbmd0aCA9IG5ldGRldi0+bXR1ICsgRVRIX0hMRU4gKyA0ICsg
UlhfSEVBRF9QQURESU5HOw0KPiArICAgICAgIGJ1ZmZlcl9sZW5ndGggPSBuZXRkZXYtPm10dSAr
IEVUSF9ITEVOICsgRVRIX0ZDU19MRU4gKyBSWF9IRUFEX1BBRERJTkc7DQoNCkknZCB0cnkgdG8g
d3JpdGUgdGhlIGxlbmd0aHMgaW4gdGhlIG9yZGVyIHRoZXkgaGFwcGVuLCBzbzoNCglidWZmZXJf
bGVuZ3RoID0gUlhfSEVBRF9QQURESU5HICsgRVRIX0hMRU4gKyBuZXRkZXYtPm10dSArIEVUSF9G
Q1NfTEVOOw0KDQpUaGUgY29tcGlsZXIgc2hvdWxkIGFkZCBhbGwgdGhlIGNvbnN0YW50cyB0b2dl
dGhlciwNCnNvIHRoZSBnZW5lcmF0ZWQgY29kZSBvdWdodCB0byBiZSB0aGUgc2FtZS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

