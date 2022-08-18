Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C838E59838E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244850AbiHRM7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244842AbiHRM7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:59:02 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21D1B5A836;
        Thu, 18 Aug 2022 05:58:57 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27ICwCR51029865, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27ICwCR51029865
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 18 Aug 2022 20:58:12 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 18 Aug 2022 20:58:25 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 18 Aug 2022 20:58:24 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Thu, 18 Aug 2022 20:58:24 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "arnd@kernel.org" <arnd@kernel.org>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gary Chang <gary.chang@realtek.com>,
        "nathan@kernel.org" <nathan@kernel.org>
Subject: Re: build failure of next-20220818 due to 341dd1f7de4c ("wifi: rtw88: add the update channel flow to support setting by parameters")
Thread-Topic: build failure of next-20220818 due to 341dd1f7de4c ("wifi:
 rtw88: add the update channel flow to support setting by parameters")
Thread-Index: AQHYsvdH+VODKjoKikSt5m62qYeAPq20BvSAgAARZQA=
Date:   Thu, 18 Aug 2022 12:58:24 +0000
Message-ID: <d707e413e8dc3a615b64ca2e8941072f41143184.camel@realtek.com>
References: <Yv4lFKIoek8Fhv44@debian>
         <CAK8P3a2_YDCS0Ate7b_nBibsbinjNqvMj9h5foA83NJjq8nE0g@mail.gmail.com>
In-Reply-To: <CAK8P3a2_YDCS0Ate7b_nBibsbinjNqvMj9h5foA83NJjq8nE0g@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [125.224.85.133]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzgvMTgg5LiK5Y2IIDExOjAzOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <59B3755ACDCB28419BB1E779583124BD@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA4LTE4IGF0IDEzOjU2ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBPbiBUaHUsIEF1ZyAxOCwgMjAyMiBhdCAxOjQwIFBNIFN1ZGlwIE11a2hlcmplZSAoQ29kZXRo
aW5rKQ0KPiA8c3VkaXBtLm11a2hlcmplZUBnbWFpbC5jb20+IHdyb3RlOg0KPiA+IEhpIEFsbCwN
Cj4gPiANCj4gPiBOb3Qgc3VyZSBpZiBpdCBoYXMgYmVlbiByZXBvcnRlZCwgY2xhbmcgYnVpbGRz
IG9mIGFybTY0IGFsbG1vZGNvbmZpZyBoYXZlDQo+ID4gZmFpbGVkIHRvIGJ1aWxkIG5leHQtMjAy
MjA4MTggd2l0aCB0aGUgZXJyb3I6DQo+ID4gDQo+ID4gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9tYWluLmM6NzMxOjI6IGVycm9yOiB2YXJpYWJsZSAncHJpbWFyeV9jaGFubmVs
X2lkeCcgaXMgdXNlZA0KPiA+IHVuaW5pdGlhbGl6ZWQgd2hlbmV2ZXIgc3dpdGNoIGRlZmF1bHQg
aXMgdGFrZW4gWy1XZXJyb3IsLVdzb21ldGltZXMtdW5pbml0aWFsaXplZF0NCj4gPiAgICAgICAg
IGRlZmF1bHQ6DQo+ID4gICAgICAgICBefn5+fn5+DQo+ID4gZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OC9tYWluLmM6NzU0OjM5OiBub3RlOiB1bmluaXRpYWxpemVkIHVzZSBvY2N1
cnMgaGVyZQ0KPiA+ICAgICAgICAgaGFsLT5jdXJyZW50X3ByaW1hcnlfY2hhbm5lbF9pbmRleCA9
IHByaW1hcnlfY2hhbm5lbF9pZHg7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fg0KPiA+IA0KPiA+IGdpdCBiaXNlY3Qg
cG9pbnRlZCB0byAzNDFkZDFmN2RlNGMgKCJ3aWZpOiBydHc4ODogYWRkIHRoZSB1cGRhdGUgY2hh
bm5lbCBmbG93IHRvIHN1cHBvcnQgc2V0dGluZw0KPiA+IGJ5IHBhcmFtZXRlcnMiKS4NCj4gPiBB
bmQsIHJldmVydGluZyB0aGF0IGNvbW1pdCBoYXMgZml4ZWQgdGhlIGJ1aWxkIGZhaWx1cmUuDQo+
ID4gDQo+ID4gSSB3aWxsIGJlIGhhcHB5IHRvIHRlc3QgYW55IHBhdGNoIG9yIHByb3ZpZGUgYW55
IGV4dHJhIGxvZyBpZiBuZWVkZWQuDQo+IA0KPiBIaSBTdWRlZXAsDQo+IA0KPiBpbiBteSBleHBl
cmllbmNlLCB5b3UgZ2V0IHRoZSBiZXN0IHJlc3VsdHMgYnkgcG9zdGluZyBhIHBhdGNoIGluc3Rl
YWQNCj4gb2YgYSBidWcgcmVwb3J0DQo+IHdoZW4geW91IHNwb3QgYSBuZXcgd2FybmluZy4gSWYg
eW91IGFyZSB1bnN1cmUgaXQncyB0aGUgcmlnaHQgZml4LA0KPiBqdXN0IHN0YXRlIHRoYXQNCj4g
aW4gdGhlIGRlc2NyaXB0aW9uLiBUaGUgbWFpbnRhaW5lcnMgd2lsbCB0aGVuIGVpdGhlciBiZSBh
YmxlIHRvIGp1c3QNCj4gcGljayBpdCB1cCBpZg0KPiBpdCBsb29rcyBjb3JyZWN0LCBvciBiZSBt
b3RpdmF0ZWQgdG8gZG8gYSBiZXR0ZXIgcGF0Y2ggaWYgdGhleSBkb24ndA0KPiBsaWtlIGl0LiA7
LSkNCj4gDQo+IEluIHRoaXMgY2FzZSwgSSB0aGluayB0aGUgYmVzdCBmaXggd291bGQgYmUgdG8g
bWVyZ2VkIHRoZSAnZGVmYXVsdCcNCj4gd2l0aCB0aGUgJ2Nhc2UNCj4gUlRXX0NIQU5ORUxfV0lE
VEhfMjAnIGluIHRoZSBzd2l0Y2ggc3RhdGVtZW50LCBhbmQgdXNlDQo+IFJUV19TQ19ET05UX0NB
UkUuIE9mIGNvdXJzZSwgSSBoYXZlIG5vIGlkZWEgaWYgdGhhdCBpcyB0aGUgcmlnaHQgZml4LA0K
PiBidXQgaXQgd291bGQgbWFrZSBzZW5zZS4NCj4gDQo+IEp1c3QgdHJ5IHRvIGF2b2lkIGFkZGlu
ZyBpbml0aWFsaXphdGlvbnMgdG8gdGhlIHZhcmlhYmxlIGRlY2xhcmF0aW9uLCBhcyB0aGF0DQo+
IHdvdWxkIHByZXZlbnQgdGhlIGNvbXBpbGVyIGZyb20gd2FybmluZyBpZiB0aGVyZSBpcyBhIG5l
dyB1bmluaXRpYWxpemVkIHVzZS4NCj4gDQoNCkkgaGF2ZSBzZW50IGEgcGF0Y2ggdG8gZml4IHRo
aXM6IA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtd2lyZWxlc3MvMjAyMjA4MTUwNjIw
MDQuMjI5MjAtMS1wa3NoaWhAcmVhbHRlay5jb20vVC8jdQ0KDQpQaW5nLUtlDQoNCg0K
