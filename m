Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8A561D9B9
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKELdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 07:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKELdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 07:33:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A36C77C
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 04:33:19 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-30-4wcUQw_FMGibDF-WEUvPHw-1; Sat, 05 Nov 2022 11:33:16 +0000
X-MC-Unique: 4wcUQw_FMGibDF-WEUvPHw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 5 Nov
 2022 11:33:15 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Sat, 5 Nov 2022 11:33:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nick Child' <nnac123@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nick.child@ibm.com" <nick.child@ibm.com>,
        "bjking1@linux.ibm.com" <bjking1@linux.ibm.com>,
        "ricklind@us.ibm.com" <ricklind@us.ibm.com>,
        "dave.taht@gmail.com" <dave.taht@gmail.com>
Subject: RE: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Thread-Topic: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Thread-Index: AQHY8Hl7OCrR5SpRK0uxUaoUb2UJuK4wMKrA
Date:   Sat, 5 Nov 2022 11:33:15 +0000
Message-ID: <26dc5891a0244f5f834cfd95f74ee8b4@AcuMS.aculab.com>
References: <20221102183837.157966-1-nnac123@linux.ibm.com>
 <20221103205945.40aacd90@kernel.org>
 <4f84f10b-9a79-17f6-7e2e-f65f0d2934cb@linux.ibm.com>
 <20221104105955.2c3c74a7@kernel.org>
 <a2924a54-7e44-952d-8544-d14e44d9d8f5@linux.ibm.com>
In-Reply-To: <a2924a54-7e44-952d-8544-d14e44d9d8f5@linux.ibm.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmljayBDaGlsZA0KPiBTZW50OiAwNCBOb3ZlbWJlciAyMDIyIDE4OjE2DQouLi4NCj4g
WWVzLCBhbmQgRGF2ZSBjYW4ganVtcCBpbiBoZXJlIGlmIEkgYW0gd3JvbmcsIGJ1dCwgZnJvbSBt
eQ0KPiB1bmRlcnN0YW5kaW5nLCBpZiB0aGUgTklDIGNhbm5vdCBzZW5kIHBhY2tldHMgYXQgdGhl
IHJhdGUgdGhhdA0KPiB0aGV5IGFyZSBxdWV1ZWQgdGhlbiB0aGVzZSBxdWV1ZXMgd2lsbCBpbmV2
aXRhYmx5IGZpbGwgdG8gdHhxdWV1ZWxlbi4NCj4gSW4gdGhpcyBjYXNlLCBoYXZpbmcgbW9yZSBx
dWV1ZXMgd2lsbCBub3QgbWVhbiBiZXR0ZXIgdGhyb3VnaHB1dCBidXQNCj4gd2lsbCByZXN1bHQg
aW4gYSBsYXJnZSBudW1iZXIgb2YgYWxsb2NhdGlvbnMgc2l0dGluZyBpbiBxdWV1ZXMNCj4gKGJ1
ZmZlcmJsb2F0KS4gSSBiZWxpZXZlIERhdmUncyBwb2ludCB3YXMsIGlmIG1vcmUgcXVldWVzIGRv
ZXMgbm90DQo+IGFsbG93IGZvciBiZXR0ZXIgcGVyZm9ybWFuY2UgKGFuZCBjYW4gcmlzayBidWZm
ZXJibG9hdCkgdGhlbiB3aHkNCj4gaGF2ZSBzbyBtYW55IGF0IGFsbC4NCg0KSXNuJ3QgdGhlcmUg
YW5vdGhlciBpc3N1ZSAobm90ZWQgaW4gdGhlIHRnMyBkcml2ZXIpIHRoYXQgaWYgdGhlDQp1bmRl
cmx5aW5nIGhhcmR3YXJlIChvciBvdGhlciBjb25zdW1lcikgaXMgZG9pbmcgYSByb3VuZC1yb2Jp
bg0Kc2NhbiBvZiB0aGUgdHJhbnNtaXQgcXVldWVzIHRoZW4gKElJUkMpIGEgbG90IG9mIHNtYWxs
IHBhY2tldA0KZ29pbmcgdGhyb3VnaCBvbmUgcXVldWUgY2FuIHN0YXJ2ZSBxdWV1ZXMgc2VuZGlu
ZyBiaWcgcGFja2V0cy4NCkNlcnRhaW5seSB0ZzMgaGFzIG11bHRpcGxlIHR4IHF1ZXVlcyBkaXNh
YmxlZC4NCg0KVGhlcmUgaXMgYW4gYXNzb2NpYXRlZCBwcm9ibGVtIHdpdGggZHJpdmVycyB0aGF0
IGZvcmNlIHRoZQ0KbnVtYmVyIG9mIHRyYW5zbWl0IGFuZCByZWNlaXZlIHJpbmdzIChvciB3aGF0
ZXZlcikgdG8gYmUgdGhlIHNhbWUuDQpUaGUgcmVjZWl2ZSBwcm9jZXNzaW5nIGlzIGZhciBtb3Jl
IGV4cGVuc2l2ZSB0aGFuIHRyYW5zbWl0DQooaXQgaXMgYWxzbyBtdWNoIG1vcmUgY3JpdGljYWwg
LSBpdCBkb2Vzbid0IHJlYWxseSBtYXR0ZXIgaWYNCnRyYW5zbWl0cyBnZXQgc2xpZ2h0bHkgZGVs
YXllZCwgYnV0IGRyb3BwaW5nIHJ4IHBhY2tldHMgaXMgYSBQSVRBKS4NCklmIHRocmVhZGVkIE5B
UEkgaXMgZW5hYmxlZCAodG8gYXZvaWQgaXNzdWVzIHdpdGggc29mdGludA0KcHJvY2Vzc2luZykg
dGhlbiB5b3UgZG9uJ3QgcmVhbGx5IG5lZWQgbG90cyBvZiB0aHJlYWRzIGZvcg0KdHJhbnNtaXQg
cXVldWVzLCBidXQgZG8gbmVlZCBvbmVzIGZvciB0aGUgcnggcXVldWVzLg0KSSBoYWQgdG8gdXNl
IHRocmVhZGVkIE5BUEkgd2l0aCB0aGUgdGhyZWFkcyBydW5uaW5nIHVuZGVyDQp0aGUgUlQgc2No
ZWR1bGVyIHRvIGF2b2lkIHBhY2tldCBsb3NzIChhdCA1MDAsMDAwIHBrZy9zZWMpLg0KDQpXaXRo
IHRnMyBmb3VyIHJ4IHF1ZXVlcyBhbmQgb25lIHR4IHdvcmtlZCBmaW5lLg0KDQoJRGF2aWQgKG5v
dCBEYXZlKQ0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwg
TW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzog
MTM5NzM4NiAoV2FsZXMpDQo=

