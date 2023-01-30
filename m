Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAFC680F48
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbjA3Nsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjA3Nsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:48:30 -0500
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF8739B8E;
        Mon, 30 Jan 2023 05:48:27 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 30 Jan
 2023 16:48:24 +0300
Received: from Ex16-01.fintech.ru (10.0.10.18) by Ex16-01.fintech.ru
 (10.0.10.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 30 Jan
 2023 16:48:24 +0300
Received: from Ex16-01.fintech.ru ([fe80::2534:7600:5275:d3f9]) by
 Ex16-01.fintech.ru ([fe80::2534:7600:5275:d3f9%7]) with mapi id
 15.01.2242.004; Mon, 30 Jan 2023 16:48:24 +0300
From:   =?utf-8?B?0JbQsNC90LTQsNGA0L7QstC40Ycg0J3QuNC60LjRgtCwINCY0LPQvtGA0LU=?=
         =?utf-8?B?0LLQuNGH?= <n.zhandarovich@fintech.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Thread-Topic: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Thread-Index: AQHZNKePV9Tuf82zRk2tMrTfyN8UZK62u2sAgAA3O6D//9G7AIAANNZg
Date:   Mon, 30 Jan 2023 13:48:24 +0000
Message-ID: <e17c785dbacf4605a726cc939bee6533@fintech.ru>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
 <Y9fAkt/5BRist//g@kroah.com> <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
 <Y9fIFirNHNP06e1L@kroah.com>
In-Reply-To: <Y9fIFirNHNP06e1L@kroah.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.253.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIEphbiAzMCwgMjAyMyBhdCAwMToyNzoyNlBNICswMDAwLCDQltCw0L3QtNCw0YDQ
vtCy0LjRhyDQndC40LrQuNGC0LAg0JjQs9C+0YDQtdCy0LjRhw0KPiB3cm90ZToNCj4gPiA+IFdo
YXQgaXMgdGhlIGdpdCBjb21taXQgaWQgb2YgdGhpcyB1cHN0cmVhbT8NCj4gPiA+DQo+ID4gPiBB
bmQgSSBjYW4ndCBhcHBseSB0aGlzIGFzLWlzIGZvciB0aGUgb2J2aW91cyByZWFzb24gaXQgd291
bGQgbWVzcyB1cA0KPiA+ID4gdGhlIGNoYW5nZWxvZywgaG93IGRpZCB5b3UgY3JlYXRlIHRoaXM/
DQo+ID4gPg0KPiA+ID4gY29uZnVzZWQsDQo+ID4gPg0KPiA+ID4gZ3JlZyBrLWgNCj4gPg0KPiA+
IENvbW1pdCBpbiBxdWVzdGlvbiBpcyBiNjcxZGEzM2QxYzU5NzNmOTBmMDk4ZmY2NmE5MTk1MzY5
MWRmNTgyDQo+ID4gdXBzdHJlYW0uIEkgd2Fzbid0IGNlcnRhaW4gaXQgbWFrZXMgc2Vuc2UgdG8g
YmFja3BvcnQgdGhlIHdob2xlIHBhdGNoDQo+ID4gYXMgb25seSBhIHNtYWxsIHBvcnRpb24gb2Yg
aXQgcGVydGFpbnMgdG8gdGhlIGZhdWx0IGF0IHF1ZXN0aW9uLg0KPiANCj4gV2hhdCBpcyB0aGUg
ImZhdWx0Ij8NCg0KSW4gNS4xMC55ICJtdDc2MTVfaW5pdF90eF9xdWV1ZXMoKSByZXR1cm5zIDAg
cmVnYXJkbGVzcyBvZiBob3cgZmluYWwNCm10NzYxNV9pbml0X3R4X3F1ZXVlKCkgcGVyZm9ybXMu
IElmIG10NzYxNV9pbml0X3R4X3F1ZXVlKCkgZmFpbHMgKGR1ZSB0bw0KbWVtb3J5IGlzc3Vlcywg
Zm9yIGluc3RhbmNlKSwgcGFyZW50IGZ1bmN0aW9uIHdpbGwgc3RpbGwgZXJyb25lb3VzbHkNCnJl
dHVybiAwLiINCg0KVGhpcyB3YXMgZml4ZWQgdXBzdHJlYW0sIGFsdGhvdWdoIHRoYXQgcGFydGlj
dWxhciBjb21taXQncyBzY29wZSB3YXMgYnJvYWRlci4NCg0KPiBBbmQgd2h5IG5vdCB0YWtlIHRo
ZSB3aG9sZSB0aGluZz8gIFdoYXQncyB3cm9uZyB3aXRoIHRoYXQ/ICBXZSBhbG1vc3QNCj4gYWx3
YXlzIHdhbnQgdG8gdGFrZSB3aGF0ZXZlciBpcyBpbiBMaW51cydzIHRyZWUgYmVjYXVzZSB3aGVu
IHdlIGRvIG5vdCwgd2UNCj4gYWxtb3N0IGFsd2F5cyBjYXVzZSBidWdzIG9yIG90aGVyIHByb2Js
ZW1zIChsYXRlciBtZXJnZSBpc3N1ZXMuKQ0KPiANCj4gU28gYWx3YXlzIHRha2UgdGhlIG9yaWdp
bmFsIGZpeCBwbGVhc2UuDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0KDQpUaGF0IG1h
a2VzIHNlbnNlLCBvZiBjb3Vyc2UuIFRoYW5rcyBmb3IgeW91ciBwYXRpZW5jZSwgd2lsbCB3b3Jr
IHRvd2FyZCBiYWNrcG9ydGluZyB0aGUgd2hvbGUgdGhpbmcuDQoNCnJlZ2FyZHMsDQoNCk5pa2l0
YQ0K
