Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977656EECBD
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 05:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbjDZDbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 23:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239102AbjDZDbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 23:31:22 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1960F113;
        Tue, 25 Apr 2023 20:31:20 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33Q3UsjoE024695, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33Q3UsjoE024695
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 26 Apr 2023 11:30:54 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 26 Apr 2023 11:30:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 26 Apr 2023 11:30:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 26 Apr 2023 11:30:55 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull-request: wireless-next-2023-04-21
Thread-Topic: pull-request: wireless-next-2023-04-21
Thread-Index: AQHZdD60u8zT35eBqkOmWCVcBjPBJa81U6EAgAX6SUCAADntO4AAC0MAgAAvgQCAASv6AIAABsSA
Date:   Wed, 26 Apr 2023 03:30:55 +0000
Message-ID: <1a38a4289ef34672a2bc9a880e8608a8@realtek.com>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
         <20230421075404.63c04bca@kernel.org>
         <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
 <87leigr06u.fsf@kernel.org>         <20230425071848.6156c0a0@kernel.org>
 <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
 <c69f151c77f34ae594dc2106bc68f2ac@realtek.com>
In-Reply-To: <c69f151c77f34ae594dc2106bc68f2ac@realtek.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGluZy1LZSBTaGloIDxw
a3NoaWhAcmVhbHRlay5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjYsIDIwMjMgMTE6
MTYgQU0NCj4gVG86IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ+OyBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgS2FsbGUgVmFsbw0KPiA8a3ZhbG9Aa2Vy
bmVsLm9yZz4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXdpcmVsZXNzQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogcHVsbC1yZXF1ZXN0OiB3aXJlbGVzcy1uZXh0
LTIwMjMtMDQtMjENCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9t
OiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0Pg0KPiA+IFNlbnQ6IFdl
ZG5lc2RheSwgQXByaWwgMjYsIDIwMjMgMTowOSBBTQ0KPiA+IFRvOiBKYWt1YiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPjsgS2FsbGUgVmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz4NCj4gPiBDYzog
UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTdWJqZWN0OiBSZTogcHVsbC1y
ZXF1ZXN0OiB3aXJlbGVzcy1uZXh0LTIwMjMtMDQtMjENCj4gPg0KPiA+IE9uIFR1ZSwgMjAyMy0w
NC0yNSBhdCAwNzoxOCAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gPiBPbiBUdWUs
IDI1IEFwciAyMDIzIDA4OjM4OjE3ICswMzAwIEthbGxlIFZhbG8gd3JvdGU6DQo+ID4gPiA+IElJ
UkMgd2UgZGlzY3Vzc2VkIHRoaXMgYmFjayBpbiBpbml0aWFsIHJ0dzg4IG9yIHJ0dzg5IGRyaXZl
ciByZXZpZXcgKG5vdA0KPiA+ID4gPiBzdXJlIHdoaWNoIG9uZSkuIEF0IHRoZSB0aW1lIEkgcHVz
aGVkIGZvciB0aGUgY3VycmVudCBzb2x1dGlvbiB0byBoYXZlDQo+ID4gPiA+IHRoZSBpbml0dmFs
cyBpbiBzdGF0aWMgdmFyaWFibGVzIGp1c3QgdG8gYXZvaWQgYW55IGJhY2t3YXJkcw0KPiA+ID4g
PiBjb21wYXRpYmlsaXR5IGlzc3Vlcy4gSSBhZ3JlZSB0aGF0IHRoZSBpbml0dmFscyBpbiAuYyBm
aWxlcyBhcmUgdWdseSBidXQNCj4gPiA+ID4gaXMgaXQgd29ydGggYWxsIHRoZSBleHRyYSBlZmZv
cnQgYW5kIGNvbXBsZXhpdHkgdG8gbW92ZSB0aGVtIG91dHNpZGUgdGhlDQo+ID4gPiA+IGtlcm5l
bD8gSSdtIHN0YXJ0aW5nIHRvIGxlYW4gdG93YXJkcyBpdCdzIG5vdCB3b3J0aCBhbGwgdGhlIGV4
dHJhIHdvcmsuDQo+ID4gPg0KPiA+ID4gSSBkb24ndCB0aGluayBpdCdzIHRoYXQgbXVjaCBleHRy
YSB3b3JrLCB0aGUgZHJpdmVyIHJlcXVpcmVzIEZXDQo+ID4gPiBhY2NvcmRpbmcgdG8gbW9kaW5m
bywgYW55d2F5LCBzbyAvbGliL2Zpcm13YXJlIGlzIGFscmVhZHkgcmVxdWlyZWQuDQo+ID4NCj4g
PiBJZiB0aGUgZmlybXdhcmUgaXMgc3VmZmljaWVudGx5IHVuaXF1ZSB0byBhIGRldmljZSAod2hp
Y2ggaXMgbGlrZWx5KSBpdA0KPiA+IGNvdWxkIGV2ZW4ganVzdCBiZSBhcHBlbmRlZCB0byB0aGF0
IHNhbWUgZmlsZSwgYXNzdW1pbmcgdGhlIGZpbGUgZm9ybWF0DQo+ID4gaGFzIGFueSBraW5kIG9m
IGNvbnRhaW5lciBsYXlvdXQuIEJ1dCBldmVuIHRoYXQgY291bGQgYmUgZG9uZSBmYWlybHkNCj4g
PiBlYXNpbHkuDQo+ID4NCj4gDQo+IEkgdGhpbmsgdGhlIGV4dHJhIHdvcmsgS2FsbGUgbWVhbnQg
aXMgd2hhdCBJIG1lbnRpb25lZCBwcmV2aW91c2x5IC0tDQo+IG5lZWQgZnVuY3Rpb25zIHRvIGNv
bnZlcnQgb2xkIHRhYmxlcyB2MSwgdjIsIC4uLiB0byBjdXJyZW50LiBMaWtlLA0KPiANCg0Kc3Ry
dWN0IHRhYmxlX3YxIHsgLy8gZnJvbSBmaWxlDQogICBfX2xlMzIgY2hhbm5lbF90eF9wb3dlclsx
MF07DQp9Ow0KDQpzdHJ1Y3QgdGFibGVfdjIgeyAvLyBmcm9tIGZpbGUNCiAgIF9fbGUzMiBjaGFu
bmVsX3R4X3Bvd2VyWzIwXTsNCn07DQoNCnN0cnVjdCB0YWJsZSB7ICAgIC8vIGZyb20gZmlsZSwg
dGhlIGxhdGVzdCB2ZXJzaW9uIG9mIGN1cnJlbnQgdXNlDQogICBfX2xlMzIgY2hhbm5lbF90eF9w
b3dlclszMF07DQp9Ow0KDQpzdHJ1Y3QgdGFibGVfY3B1IHsgIC8vIGN1cnJlbnQgdGFibGUgaW4g
Y3B1IG9yZGVyDQogICB1MzIgY2hhbm5lbF90eF9wb3dlclszMF07DQp9Ow0KDQpUbyBtYWtlIGV4
YW1wbGUgY2xlYXJlciwgSSBjaGFuZ2UgdGhlIG5hbWUgb2YgZmllbGRzLCBiZWNhdXNlIHRoZSB0
aGluZyBJDQp3YW50IHRvIG1lbnRpb24gaXMgbm90IHJlZ2lzdGVyIHRhYmxlIHRoYXQgd291bGRu
J3QgbmVlZCBjb252ZXJzaW9uLg0KDQo+IA0KPiBJZiBsb2FkaW5nIGEgdGFibGVfdjEgdGFibGUs
IGZvciBleGFtcGxlLCB3ZSBuZWVkIHRvIGNvbnZlcnQgdG8gdGFibGVfY3B1IGJ5DQo+IHNvbWUg
cnVsZXMuIEFsc28sIG1heWJlIHdlIG5lZWQgdG8gZGlzYWJsZSBzb21lIGZlYXR1cmVzIHJlbGF5
IG9uIHRoZSB2YWx1ZXMNCj4gaW50cm9kdWNlZCBieSB0YWJsZV9jcHUuIEkgdGhpbmsgaXQgd2ls
bCB3b3JrLCBidXQganVzdCBhZGQgc29tZSBmbGFncyBhbmQNCj4gcnVsZXMgdG8gaGFuZGxlIHRo
ZW0uDQo+IA0KPiANCj4gQW5vdGhlciBxdWVzdGlvbiBpcyBhYm91dCBudW1iZXIgb2YgZmlsZXMg
Zm9yIHNpbmdsZSBkZXZpY2UuIFNpbmNlIGZpcm13YXJlIGFuZA0KPiB0YWJsZXMgKGUuZy4gVFgg
cG93ZXIsIHJlZ2lzdGVycykgYXJlIHJlbGVhc2VkIGJ5IGRpZmZlcmVudCBwZW9wbGUsIGFuZCB0
aGV5DQo+IG1haW50YWluIHRoZWlyIG93biB2ZXJzaW9uLCBpZiBJIGFwcGVuZCB0YWJsZXMgdG8g
ZmlybXdhcmUsIGl0J3MgYSBsaXR0bGUgaGFyZA0KPiB0byBoYXZlIGEgY2xlYXIgdmVyc2lvbiBj
b2RlLiBTbywgSSB3b3VsZCBsaWtlIHRvIGtub3cgdGhlIHJ1bGUgaWYgSSBjYW4ganVzdA0KPiBh
ZGQgYWRkaXRpb25hbCBvbmUgZmlsZSBmb3IgdGhlc2UgdGFibGVzPw0KPiANCj4gUGluZy1LZQ0K
PiANCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHBy
aW50aW5nIHRoaXMgZS1tYWlsLg0K
