Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC566C98FF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 02:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjC0Afr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 20:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC0Afq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 20:35:46 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C8846AF;
        Sun, 26 Mar 2023 17:35:45 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32R0Z65Q0032635, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32R0Z65Q0032635
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 27 Mar 2023 08:35:06 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 27 Mar 2023 08:35:22 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 27 Mar 2023 08:35:22 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 27 Mar 2023 08:35:22 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH][next] rtlwifi: Replace fake flex-array with flex-array member
Thread-Topic: [PATCH][next] rtlwifi: Replace fake flex-array with flex-array
 member
Thread-Index: AQHZXe2MpAp+x0rAE0KunPVbPDAU3a8Ny/9A
Date:   Mon, 27 Mar 2023 00:35:22 +0000
Message-ID: <3190a6c23f9a468d90688f2704d36fa1@realtek.com>
References: <ZBz4x+MWoI/f65o1@work>
In-Reply-To: <ZBz4x+MWoI/f65o1@work>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3VzdGF2byBBLiBSLiBT
aWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIE1hcmNoIDI0LCAy
MDIzIDk6MTIgQU0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgS2Fs
bGUgVmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD47DQo+IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtp
Y2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+
DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEd1c3Rhdm8gQS4gUi4NCj4gU2ls
dmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz47IGxpbnV4LWhhcmRlbmluZ0B2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogW1BBVENIXVtuZXh0XSBydGx3aWZpOiBSZXBsYWNlIGZha2UgZmxleC1h
cnJheSB3aXRoIGZsZXgtYXJyYXkgbWVtYmVyDQo+IA0KPiBaZXJvLWxlbmd0aCBhcnJheXMgYXMg
ZmFrZSBmbGV4aWJsZSBhcnJheXMgYXJlIGRlcHJlY2F0ZWQgYW5kIHdlIGFyZQ0KPiBtb3Zpbmcg
dG93YXJkcyBhZG9wdGluZyBDOTkgZmxleGlibGUtYXJyYXkgbWVtYmVycyBpbnN0ZWFkLg0KPiAN
Cj4gQWRkcmVzcyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgZm91bmQgd2l0aCBHQ0MtMTMgYW5kDQo+
IC1mc3RyaWN0LWZsZXgtYXJyYXlzPTMgZW5hYmxlZDoNCj4gSW4gZnVuY3Rpb24g4oCYZm9ydGlm
eV9tZW1zZXRfY2hr4oCZLA0KPiAgICAgaW5saW5lZCBmcm9tIOKAmHJ0bF91c2JfcHJvYmXigJkg
YXQgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3VzYi5jOjEwNDQ6MjoNCj4g
Li9pbmNsdWRlL2xpbnV4L2ZvcnRpZnktc3RyaW5nLmg6NDMwOjI1OiB3YXJuaW5nOiBjYWxsIHRv
IOKAmF9fd3JpdGVfb3ZlcmZsb3dfZmllbGTigJkgZGVjbGFyZWQgd2l0aA0KPiBhdHRyaWJ1dGUg
d2FybmluZzogZGV0ZWN0ZWQgd3JpdGUgYmV5b25kIHNpemUgb2YgZmllbGQgKDFzdCBwYXJhbWV0
ZXIpOyBtYXliZSB1c2Ugc3RydWN0X2dyb3VwKCk/DQo+IFstV2F0dHJpYnV0ZS13YXJuaW5nXQ0K
PiAgIDQzMCB8ICAgICAgICAgICAgICAgICAgICAgICAgIF9fd3JpdGVfb3ZlcmZsb3dfZmllbGQo
cF9zaXplX2ZpZWxkLCBzaXplKTsNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICBe
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gDQo+IFRoaXMgaGVs
cHMgd2l0aCB0aGUgb25nb2luZyBlZmZvcnRzIHRvIHRpZ2h0ZW4gdGhlIEZPUlRJRllfU09VUkNF
DQo+IHJvdXRpbmVzIG9uIG1lbWNweSgpIGFuZCBoZWxwIHVzIG1ha2UgcHJvZ3Jlc3MgdG93YXJk
cyBnbG9iYWxseQ0KPiBlbmFibGluZyAtZnN0cmljdC1mbGV4LWFycmF5cz0zIFsxXS4NCj4gDQo+
IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy8yMQ0KPiBMaW5rOiBo
dHRwczovL2dpdGh1Yi5jb20vS1NQUC9saW51eC9pc3N1ZXMvMjc3DQo+IExpbms6IGh0dHBzOi8v
Z2NjLmdudS5vcmcvcGlwZXJtYWlsL2djYy1wYXRjaGVzLzIwMjItT2N0b2Jlci82MDI5MDIuaHRt
bCBbMV0NCj4gU2lnbmVkLW9mZi1ieTogR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0Br
ZXJuZWwub3JnPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+
DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvd2lmaS5o
IHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZp
L3dpZmkuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS93aWZpLmgNCj4g
aW5kZXggMzFmOWU5ZTVjNjgwLi4wODJhZjIxNjc2MGYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS93aWZpLmgNCj4gKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3dpZmkuaA0KPiBAQCAtMjgzMSw3ICsyODMxLDcgQEAg
c3RydWN0IHJ0bF9wcml2IHsNCj4gICAgICAgICAgKiBiZXlvbmQgIHRoaXMgc3RydWN0dXJlIGxp
a2U6DQo+ICAgICAgICAgICogcnRsX3BjaV9wcml2IG9yIHJ0bF91c2JfcHJpdg0KPiAgICAgICAg
ICAqLw0KPiAtICAgICAgIHU4IHByaXZbMF0gX19hbGlnbmVkKHNpemVvZih2b2lkICopKTsNCj4g
KyAgICAgICB1OCBwcml2W10gX19hbGlnbmVkKHNpemVvZih2b2lkICopKTsNCj4gIH07DQo+IA0K
PiAgI2RlZmluZSBydGxfcHJpdihodykgICAgICAgICAgICgoKHN0cnVjdCBydGxfcHJpdiAqKSho
dyktPnByaXYpKQ0KPiAtLQ0KPiAyLjM0LjENCj4gDQo+IA0KPiAtLS0tLS1QbGVhc2UgY29uc2lk
ZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
