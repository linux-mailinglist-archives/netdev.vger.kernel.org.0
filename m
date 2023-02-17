Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DCC69AACC
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjBQLvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjBQLvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:51:43 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05C67444;
        Fri, 17 Feb 2023 03:51:29 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31HBopgvF026651, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31HBopgvF026651
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Fri, 17 Feb 2023 19:50:51 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 17 Feb 2023 19:50:54 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 17 Feb 2023 19:50:53 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Fri, 17 Feb 2023 19:50:53 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "arnd@kernel.org" <arnd@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH] wifi: rtl8xxxu: add LEDS_CLASS dependency
Thread-Topic: [PATCH] wifi: rtl8xxxu: add LEDS_CLASS dependency
Thread-Index: AQHZQraBhj2wCFnV30qvBoiE79Yoja7SgHkA
Date:   Fri, 17 Feb 2023 11:50:53 +0000
Message-ID: <4e88fae65e85366bfc5d728c0e4c47133c7b9523.camel@realtek.com>
References: <20230217095910.2480356-1-arnd@kernel.org>
In-Reply-To: <20230217095910.2480356-1-arnd@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.16.9]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzIvMTcg5LiK5Y2IIDEwOjE0OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC81A48035D3F046AB44DA0BA9FABCFD@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTE3IGF0IDEwOjU5ICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiANCj4gcnRsOHh4eHUgbm93
IHVuY29uZGl0aW9uYWxseSB1c2VzIExFRFNfQ0xBU1MsIHNvIGEgS2NvbmZpZyBkZXBlbmRlbmN5
DQo+IGlzIHJlcXVpcmVkIHRvIGF2b2lkIGxpbmsgZXJyb3JzOg0KPiANCj4gYWFyY2g2NC1saW51
eC1sZDogZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9ydGw4eHh4dV9jb3Jl
Lm86IGluIGZ1bmN0aW9uDQo+IGBydGw4eHh4dV9kaXNjb25uZWN0JzoNCj4gcnRsOHh4eHVfY29y
ZS5jOigudGV4dCsweDczMCk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYGxlZF9jbGFzc2Rldl91
bnJlZ2lzdGVyJw0KPiANCj4gRVJST1I6IG1vZHBvc3Q6ICJsZWRfY2xhc3NkZXZfdW5yZWdpc3Rl
ciIgW2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvcnRsOHh4eHUua29dDQo+
IHVuZGVmaW5lZCENCj4gRVJST1I6IG1vZHBvc3Q6ICJsZWRfY2xhc3NkZXZfcmVnaXN0ZXJfZXh0
IiBbZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9ydGw4eHh4dS5rb10NCj4g
dW5kZWZpbmVkIQ0KPiANCj4gRml4ZXM6IDNiZTAxNjIyOTk1YiAoIndpZmk6IHJ0bDh4eHh1OiBS
ZWdpc3RlciB0aGUgTEVEIGFuZCBtYWtlIGl0IGJsaW5rIikNCj4gU2lnbmVkLW9mZi1ieTogQXJu
ZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0bDh4eHh1L0tjb25maWcgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsOHh4eHUvS2NvbmZpZw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
OHh4eHUvS2NvbmZpZw0KPiBpbmRleCAwOTFkM2FkOTgwOTMuLjJlZWQyMGIwOTg4YyAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9LY29uZmlnDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvS2NvbmZpZw0KPiBA
QCAtNSw2ICs1LDcgQEANCj4gIGNvbmZpZyBSVEw4WFhYVQ0KPiAgICAgICAgIHRyaXN0YXRlICJS
ZWFsdGVrIDgwMi4xMW4gVVNCIHdpcmVsZXNzIGNoaXBzIHN1cHBvcnQiDQo+ICAgICAgICAgZGVw
ZW5kcyBvbiBNQUM4MDIxMSAmJiBVU0INCj4gKyAgICAgICBkZXBlbmRzIG9uIExFRFNfQ0xBU1MN
Cg0KV2l0aCAnZGVwZW5kcyBvbicsIHRoaXMgaXRlbSB3aWxsIGRpc2FwcGVhciBpZiBMRURTX0NM
QVNTIGlzbid0IHNlbGVjdGVkLg0KV291bGQgaXQgdXNlICdzZWxlY3QnIGluc3RlYWQ/DQoNClBp
bmctS2UNCg0KDQo=
