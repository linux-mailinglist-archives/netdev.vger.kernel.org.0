Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65334EBEC6
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 12:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245379AbiC3Kat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 06:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiC3Kar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 06:30:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EFA8260C5C
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:29:02 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-235-odnfOeKaNFm2zEKx4yvXug-1; Wed, 30 Mar 2022 11:28:59 +0100
X-MC-Unique: odnfOeKaNFm2zEKx4yvXug-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 30 Mar 2022 11:28:57 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 30 Mar 2022 11:28:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Artem Savkov' <asavkov@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] Upper bound kernel timers
Thread-Topic: [PATCH v3 0/2] Upper bound kernel timers
Thread-Index: AQHYRA8gGsbmhEkh50e1T/PVRZXMJqzXtvmg
Date:   Wed, 30 Mar 2022 10:28:57 +0000
Message-ID: <4975eaf09eae43dc964f879f343e5a2b@AcuMS.aculab.com>
References: <87zglcfmcv.ffs@tglx>
 <20220330082046.3512424-1-asavkov@redhat.com>
In-Reply-To: <20220330082046.3512424-1-asavkov@redhat.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXJ0ZW0gU2F2a292DQo+IFNlbnQ6IDMwIE1hcmNoIDIwMjIgMDk6MjENCj4gDQo+IEFz
IHByZXZpb3VzbHkgZGlzY3Vzc2VkIFsxXSB3ZSBoYWQgYSByZXBvcnQgb2YgYSByZWdyZXNzaW9u
IGluIFRDUCBrZWVwYWxpdmUNCj4gdGltZXIgd2hlcmUgdGltZXJzIHdlcmUgdXAgdG8gNCBtaW51
dGVzIGxhdGUgcmVzdWx0aW5nIGluIGRpc2Nvbm5lY3RzLg0KPiANCj4gVGhpcyBwYXRjaHNldCB0
cmllcyB0byBmaXggdGhlIHByb2JsZW0gYnkgaW50cm9kdWNpbmcgdXBwZXIgYm91bmQga2VybmVs
IHRpbWVycw0KPiBhbmQgbWFraW5nIHRjcCBrZWVwYWxpdmUgdGltZXIgdXNlIHRob3NlLg0KDQpX
aHkgbm90IGp1c3QgZml4IHRoZSB0aW1lciBjb2RlIHRvIHdvcmsgcHJvcGVybHkgKGFzIGl0IHVz
ZWQgdG8pIHNvIHRoYXQgdGhlDQp0aW1lcnMgZXhwaXJlIHdpdGhpbiBhIHNob3J0IHRpbWUgb2Yg
dGhlIHJlcXVlc3RlZCBpbnRlcnZhbC4NCg0KVGhpcyBqdXN0IHJlcXVpcmVzIHRoYXQgZXhwaXJp
bmcgJ2xvbmcnIHRpbWVycyBnZXQgbW92ZWQgaW50byB0aGUNCmhpZ2hlciBwcmVjaXNpb24gJ3do
ZWVscycgKG9yIHdoYXRldmVyKSBiZWZvcmUgdGhleSBhY3R1YWxseSBleHBpcmUuDQoNClRoZSBi
dXJkZW4gZm9yIHRoaXMgaXMgbWluaW1hbCAtIGl0IG9ubHkgYWZmZWN0cyBsb25nIGR1cmF0aW9u
IHRpbWVycw0KdGhhdCBhY3R1YWxseSBleHBpcmUsIGFuZCBlYWNoIHRpbWVyIG9ubHkgZ2V0cyBt
b3ZlZCBvbmNlIGZvciBlYWNoDQpsZXZlbCBvZiB0aW1lciBwcmVjaXNpb24uDQoNClBlcmhhcHMg
eW91IG9ubHkgbmVlZCB0byBtb3ZlIHRoZW0gdHdvIG9yIHRocmVlIHRpbWVzIGluIG9yZGVyIHRv
DQpnZXQgYSByZWFzb25hYmxlIGFjY3VyYWN5Lg0KTm8gb25lIGlzIGdvaW5nIHRvIG1pbmQgaWYg
YSA1IG1pbnV0ZSB0aW1lciBpcyBhIHNlY29uZCBsYXRlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

