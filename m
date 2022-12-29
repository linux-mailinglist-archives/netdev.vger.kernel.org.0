Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F153658C56
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 12:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiL2Lmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 06:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiL2Lm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 06:42:29 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6433A13E81;
        Thu, 29 Dec 2022 03:42:25 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BTBfErX5002841, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BTBfErX5002841
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 19:41:15 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 29 Dec 2022 19:42:09 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 19:42:06 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 19:42:06 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Thread-Topic: [PATCH 0/4] rtw88: Four fixes found while working on SDIO
 support
Thread-Index: AQHZGsFtyqvVdb8Ir06VvN9lkSQirK6EmVQw//+PBwCAABEeAA==
Date:   Thu, 29 Dec 2022 11:42:06 +0000
Message-ID: <c29eb85527c6834482ecdbb0946ff9b794fe7cb6.camel@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
         <84e2f2289e964834b1eaf60d4f9f5255@realtek.com>
         <CAFBinCAvSYgnamMCEBGg5+vt6Uvz+AKapJ+dSfSPBbmtERYsBw@mail.gmail.com>
In-Reply-To: <CAFBinCAvSYgnamMCEBGg5+vt6Uvz+AKapJ+dSfSPBbmtERYsBw@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.22.50]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI5IOS4iuWNiCAwNzoyNTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7AE489C41B8D24BBD47138620B88D83@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTI5IGF0IDExOjQwICswMTAwLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBIaSBQaW5nLUtlLA0KPiANCj4gT24gVGh1LCBEZWMgMjksIDIwMjIgYXQgMTA6MjYg
QU0gUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+
ID4gTWFydGluIEJsdW1lbnN0aW5nbCAoNCk6DQo+ID4gPiAgIHJ0dzg4OiBBZGQgcGFja2VkIGF0
dHJpYnV0ZSB0byB0aGUgZUZ1c2Ugc3RydWN0cw0KPiA+IA0KPiA+IEkgdGhpbmsgdGhpcyBwYXRj
aCBkZXBlbmRzIG9uIGFub3RoZXIgcGF0Y2hzZXQgb3Igb3Bwb3NpdGVseS4NCj4gPiBQbGVhc2Ug
cG9pbnQgdGhhdCBvdXQgZm9yIHJldmlld2Vycy4NCj4gVGhlcmUgYXJlIG5vIGRlcGVuZGVuY2ll
cyBmb3IgdGhpcyBzbWFsbGVyIGluZGl2aWR1YWwgc2VyaWVzIG90aGVyDQo+IHRoYW4gTGludXgg
Ni4yLXJjMSAoYXMgdGhpcyBoYXMgVVNCIHN1cHBvcnQpLiBJIG1hZGUgc3VyZSB0byBub3QNCj4g
aW5jbHVkZSBhbnkgb2YgdGhlIFNESU8gY2hhbmdlcyBpbiB0aGlzIHNlcmllcy4NCj4gVGhlIGlk
ZWEgaXMgdGhhdCBpdCBjYW4gYmUgYXBwbGllZCBpbmRpdmlkdWFsbHkgYW5kIG1ha2UgaXQgZWl0
aGVyDQo+IGludG8gNi4yLXJjMiAob3IgbmV3ZXIpIG9yIC1uZXh0ICg2LjMpLg0KPiANCg0KSSB0
aG91Z2h0IHRoaXMgY291bGQgZGVwZW5kIG9uIFNESU8gcGF0Y2hzZXQsIGJlY2F1c2UgeW91IGFk
ZA0Kc3RydWN0IGZvciBlZnVzZSBsYXlvdXQgbmVhcmJ5LCBzbyB0aGVyZSBtYXkgYmUgbWVyZ2Ug
Y29uZmxpY3RzLg0KUGxlYXNlIGlnbm9yZSB0aGlzIGNvbW1lbnQsIHRoZW4uDQoNClBpbmctS2UN
Cg0K
