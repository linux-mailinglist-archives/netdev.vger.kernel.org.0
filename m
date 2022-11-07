Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009EC61EFFD
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 11:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiKGKLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 05:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiKGKK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 05:10:59 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38FDFEA
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 02:10:58 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-16-wQOysc-VNOOXGYA0WGSC2A-1; Mon, 07 Nov 2022 10:10:49 +0000
X-MC-Unique: wQOysc-VNOOXGYA0WGSC2A-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 7 Nov
 2022 10:10:45 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Mon, 7 Nov 2022 10:10:45 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jens Axboe' <axboe@kernel.dk>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCHSET v3 0/5] Add support for epoll min_wait
Thread-Topic: [PATCHSET v3 0/5] Add support for epoll min_wait
Thread-Index: AQHY8T2KT+hcAn2hREu69xxFvk5GCa4zPkBQ
Date:   Mon, 7 Nov 2022 10:10:45 +0000
Message-ID: <a31ac5f723f44deab35b93c31263f5b5@AcuMS.aculab.com>
References: <20221030220203.31210-1-axboe@kernel.dk>
 <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
 <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
 <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
 <88353f13-d1d8-ef69-bcdc-eb2aa17c7731@kernel.dk>
 <CA+FuTSdEKsN_47RtW6pOWEnrKkewuDBdsv_qAhR1EyXUr3obrg@mail.gmail.com>
 <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk>
 <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
In-Reply-To: <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
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

RnJvbTogSmVucyBBeGJvZQ0KPiBTZW50OiAwNSBOb3ZlbWJlciAyMDIyIDE3OjM5DQo+IA0KPiA+
PiBGV0lXLCB3aGVuIGFkZGluZyBuc2VjIHJlc29sdXRpb24gSSBpbml0aWFsbHkgb3B0ZWQgZm9y
IGFuIGluaXQtYmFzZWQNCj4gPj4gYXBwcm9hY2gsIHBhc3NpbmcgYSBuZXcgZmxhZyB0byBlcG9s
bF9jcmVhdGUxLiBGZWVkYmFjayB0aGVuIHdhcyB0aGF0DQo+ID4+IGl0IHdhcyBvZGQgdG8gaGF2
ZSBvbmUgc3lzY2FsbCBhZmZlY3QgdGhlIGJlaGF2aW9yIG9mIGFub3RoZXIuIFRoZQ0KPiA+PiBm
aW5hbCB2ZXJzaW9uIGp1c3QgYWRkZWQgYSBuZXcgZXBvbGxfcHdhaXQyIHdpdGggdGltZXNwZWMu
DQo+ID4NCj4gPiBJJ20gZmluZSB3aXRoIGp1c3QgZG9pbmcgYSBwdXJlIHN5c2NhbGwgdmFyaWFu
dCB0b28sIGl0IHdhcyBteSBvcmlnaW5hbA0KPiA+IHBsYW4uIE9ubHkgY2hhbmdlZCBpdCB0byBh
bGxvdyBmb3IgZWFzaWVyIGV4cGVyaW1lbnRhdGlvbiBhbmQgYWRvcHRpb24sDQo+ID4gYW5kIGJh
c2VkIG9uIHRoZSBmYWN0IHRoYXQgbW9zdCB1c2UgY2FzZXMgd291bGQgbGlrZWx5IHVzZSBhIGZp
eGVkIHZhbHVlDQo+ID4gcGVyIGNvbnRleHQgYW55d2F5Lg0KPiA+DQo+ID4gSSB0aGluayBpdCdk
IGJlIGEgc2hhbWUgdG8gZHJvcCB0aGUgY3RsLCB1bmxlc3MgdGhlcmUncyBzdHJvbmcgYXJndW1l
bnRzDQo+ID4gYWdhaW5zdCBpdC4gSSdtIHF1aXRlIGhhcHB5IHRvIGFkZCBhIHN5c2NhbGwgdmFy
aWFudCB0b28sIHRoYXQncyBub3QgYQ0KPiA+IGJpZyBkZWFsIGFuZCB3b3VsZCBiZSBhIG1pbm9y
IGFkZGl0aW9uLiBQYXRjaCA2IHNob3VsZCBwcm9iYWJseSBjdXQgb3V0DQo+ID4gdGhlIGN0bCBh
ZGRpdGlvbiBhbmQgbGVhdmUgdGhhdCBmb3IgYSBwYXRjaCA3LCBhbmQgdGhlbiBhIHBhdGNoIDgg
Zm9yDQo+ID4gYWRkaW5nIGEgc3lzY2FsbC4NCj4NCj4gSSBzcGxpdCB0aGUgY3RsIHBhdGNoIG91
dCBmcm9tIHRoZSBjb3JlIGNoYW5nZSwgYW5kIHRoZW4gdG9vayBhIGxvb2sgYXQNCj4gZG9pbmcg
YSBzeXNjYWxsIHZhcmlhbnQgdG9vLiBCdXQgdGhlcmUgYXJlIGEgZmV3IGNvbXBsaWNhdGlvbnMg
dGhlcmUuLi4NCj4gSXQgd291bGQgc2VlbSB0byBtYWtlIHRoZSBtb3N0IHNlbnNlIHRvIGJ1aWxk
IHRoaXMgb24gdG9wIG9mIHRoZSBuZXdlc3QNCj4gZXBvbGwgd2FpdCBzeXNjYWxsLCBlcG9sbF9w
d2FpdDIoKS4gQnV0IHdlJ3JlIGFscmVhZHkgYXQgdGhlIG1heCBudW1iZXINCj4gb2YgYXJndW1l
bnRzIHRoZXJlLi4uDQo+IA0KPiBBcmd1YWJseSBwd2FpdDIgc2hvdWxkJ3ZlIGJlZW4gY29udmVy
dGVkIHRvIHVzZSBzb21lIGtpbmQgb2YgdmVyc2lvbmVkDQo+IHN0cnVjdCBpbnN0ZWFkLiBJJ20g
Z29pbmcgdG8gdGFrZSBhIHN0YWIgYXQgcHdhaXQzIHdpdGggdGhhdCBraW5kIG9mDQo+IGludGVy
ZmFjZS4NCg0KQWRkaW5nIGFuIGV4dHJhIGNvcHlfZnJvbV91c2VyKCkgYWRkcyBhIG1lYXN1cmFi
bGUgb3ZlcmhlYWQNCnRvIGEgc3lzdGVtIGNhbGwgLSBzbyB5b3UgcmVhbGx5IGRvbid0IHdhbnQg
dG8gZG8gaXQgdW5sZXNzDQphYnNvbHV0ZWx5IG5lY2Vzc2FyeS4NCg0KSSB3YXMgd29uZGVyaW5n
IGlmIHlvdSBhY3R1YWxseSBuZWVkIHR3byB0aW1lb3V0IHBhcmFtZXRlcnM/DQpDb3VsZCB5b3Ug
anVzdCB1c2UgYSBzaW5nbGUgYml0IChJIHByZXN1bWUgb25lIGlzIGF2YWlsYWJsZSkNCnRvIHJl
cXVlc3QgdGhhdCB0aGUgdGltZW91dCBiZSByZXN0YXJ0ZWQgd2hlbiBoZSBmaXJzdCBtZXNzYWdl
DQphcnJpdmVzIGFuZCB0aGUgc3lzY2FsbCB0aGVuIHJldHVybiB3aGVuIGVpdGhlciB0aGUgdGlt
ZXINCmV4cGlyZXMgb3IgdGhlIGZ1bGwgbnVtYmVyIG9mIGV2ZW50cyBoYXMgYmVlbiByZXR1cm5l
ZC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

