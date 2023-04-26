Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5526EEC9E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 05:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbjDZDQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 23:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbjDZDQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 23:16:08 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54F826BD;
        Tue, 25 Apr 2023 20:16:04 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33Q3FekeE015030, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33Q3FekeE015030
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 26 Apr 2023 11:15:40 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 26 Apr 2023 11:15:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 26 Apr 2023 11:15:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 26 Apr 2023 11:15:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull-request: wireless-next-2023-04-21
Thread-Topic: pull-request: wireless-next-2023-04-21
Thread-Index: AQHZdD60u8zT35eBqkOmWCVcBjPBJa81U6EAgAX6SUCAADntO4AAC0MAgAAvgQCAASv6AA==
Date:   Wed, 26 Apr 2023 03:15:41 +0000
Message-ID: <c69f151c77f34ae594dc2106bc68f2ac@realtek.com>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
         <20230421075404.63c04bca@kernel.org>
         <e31dae6daa6640859d12bf4c4fc41599@realtek.com> <87leigr06u.fsf@kernel.org>
         <20230425071848.6156c0a0@kernel.org>
 <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
In-Reply-To: <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyA8
am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCAyNiwg
MjAyMyAxOjA5IEFNDQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgS2Fs
bGUgVmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz4NCj4gQ2M6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJl
YWx0ZWsuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtd2lyZWxlc3NAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBwdWxsLXJlcXVlc3Q6IHdpcmVsZXNzLW5leHQtMjAy
My0wNC0yMQ0KPiANCj4gT24gVHVlLCAyMDIzLTA0LTI1IGF0IDA3OjE4IC0wNzAwLCBKYWt1YiBL
aWNpbnNraSB3cm90ZToNCj4gPiBPbiBUdWUsIDI1IEFwciAyMDIzIDA4OjM4OjE3ICswMzAwIEth
bGxlIFZhbG8gd3JvdGU6DQo+ID4gPiBJSVJDIHdlIGRpc2N1c3NlZCB0aGlzIGJhY2sgaW4gaW5p
dGlhbCBydHc4OCBvciBydHc4OSBkcml2ZXIgcmV2aWV3IChub3QNCj4gPiA+IHN1cmUgd2hpY2gg
b25lKS4gQXQgdGhlIHRpbWUgSSBwdXNoZWQgZm9yIHRoZSBjdXJyZW50IHNvbHV0aW9uIHRvIGhh
dmUNCj4gPiA+IHRoZSBpbml0dmFscyBpbiBzdGF0aWMgdmFyaWFibGVzIGp1c3QgdG8gYXZvaWQg
YW55IGJhY2t3YXJkcw0KPiA+ID4gY29tcGF0aWJpbGl0eSBpc3N1ZXMuIEkgYWdyZWUgdGhhdCB0
aGUgaW5pdHZhbHMgaW4gLmMgZmlsZXMgYXJlIHVnbHkgYnV0DQo+ID4gPiBpcyBpdCB3b3J0aCBh
bGwgdGhlIGV4dHJhIGVmZm9ydCBhbmQgY29tcGxleGl0eSB0byBtb3ZlIHRoZW0gb3V0c2lkZSB0
aGUNCj4gPiA+IGtlcm5lbD8gSSdtIHN0YXJ0aW5nIHRvIGxlYW4gdG93YXJkcyBpdCdzIG5vdCB3
b3J0aCBhbGwgdGhlIGV4dHJhIHdvcmsuDQo+ID4NCj4gPiBJIGRvbid0IHRoaW5rIGl0J3MgdGhh
dCBtdWNoIGV4dHJhIHdvcmssIHRoZSBkcml2ZXIgcmVxdWlyZXMgRlcNCj4gPiBhY2NvcmRpbmcg
dG8gbW9kaW5mbywgYW55d2F5LCBzbyAvbGliL2Zpcm13YXJlIGlzIGFscmVhZHkgcmVxdWlyZWQu
DQo+IA0KPiBJZiB0aGUgZmlybXdhcmUgaXMgc3VmZmljaWVudGx5IHVuaXF1ZSB0byBhIGRldmlj
ZSAod2hpY2ggaXMgbGlrZWx5KSBpdA0KPiBjb3VsZCBldmVuIGp1c3QgYmUgYXBwZW5kZWQgdG8g
dGhhdCBzYW1lIGZpbGUsIGFzc3VtaW5nIHRoZSBmaWxlIGZvcm1hdA0KPiBoYXMgYW55IGtpbmQg
b2YgY29udGFpbmVyIGxheW91dC4gQnV0IGV2ZW4gdGhhdCBjb3VsZCBiZSBkb25lIGZhaXJseQ0K
PiBlYXNpbHkuDQo+IA0KDQpJIHRoaW5rIHRoZSBleHRyYSB3b3JrIEthbGxlIG1lYW50IGlzIHdo
YXQgSSBtZW50aW9uZWQgcHJldmlvdXNseSAtLQ0KbmVlZCBmdW5jdGlvbnMgdG8gY29udmVydCBv
bGQgdGFibGVzIHYxLCB2MiwgLi4uIHRvIGN1cnJlbnQuIExpa2UsDQoNCnN0cnVjdCB0YWJsZV92
MSB7IC8vIGZyb20gZmlsZQ0KICAgX19sZTMyIGRhdGFbMTBdOw0KfTsNCg0Kc3RydWN0IHRhYmxl
X3YyIHsgLy8gZnJvbSBmaWxlDQogICBfX2xlMzIgZGF0YVsyMF07DQp9Ow0KDQpzdHJ1Y3QgdGFi
bGUgeyAgICAvLyBmcm9tIGZpbGUsIHRoZSBsYXRlc3QgdmVyc2lvbiBvZiBjdXJyZW50IHVzZQ0K
ICAgX19sZTMyIGRhdGFbMzBdOw0KfTsNCg0Kc3RydWN0IHRhYmxlX2NwdSB7ICAvLyBjdXJyZW50
IHRhYmxlIGluIGNwdSBvcmRlcg0KICAgdTMyIGRhdGFbMzBdOw0KfTsNCg0KSWYgbG9hZGluZyBh
IHRhYmxlX3YxIHRhYmxlLCBmb3IgZXhhbXBsZSwgd2UgbmVlZCB0byBjb252ZXJ0IHRvIHRhYmxl
X2NwdSBieQ0Kc29tZSBydWxlcy4gQWxzbywgbWF5YmUgd2UgbmVlZCB0byBkaXNhYmxlIHNvbWUg
ZmVhdHVyZXMgcmVsYXkgb24gdGhlIHZhbHVlcw0KaW50cm9kdWNlZCBieSB0YWJsZV9jcHUuIEkg
dGhpbmsgaXQgd2lsbCB3b3JrLCBidXQganVzdCBhZGQgc29tZSBmbGFncyBhbmQNCnJ1bGVzIHRv
IGhhbmRsZSB0aGVtLg0KDQoNCkFub3RoZXIgcXVlc3Rpb24gaXMgYWJvdXQgbnVtYmVyIG9mIGZp
bGVzIGZvciBzaW5nbGUgZGV2aWNlLiBTaW5jZSBmaXJtd2FyZSBhbmQNCnRhYmxlcyAoZS5nLiBU
WCBwb3dlciwgcmVnaXN0ZXJzKSBhcmUgcmVsZWFzZWQgYnkgZGlmZmVyZW50IHBlb3BsZSwgYW5k
IHRoZXkNCm1haW50YWluIHRoZWlyIG93biB2ZXJzaW9uLCBpZiBJIGFwcGVuZCB0YWJsZXMgdG8g
ZmlybXdhcmUsIGl0J3MgYSBsaXR0bGUgaGFyZA0KdG8gaGF2ZSBhIGNsZWFyIHZlcnNpb24gY29k
ZS4gU28sIEkgd291bGQgbGlrZSB0byBrbm93IHRoZSBydWxlIGlmIEkgY2FuIGp1c3QNCmFkZCBh
ZGRpdGlvbmFsIG9uZSBmaWxlIGZvciB0aGVzZSB0YWJsZXM/DQoNClBpbmctS2UNCg0K
