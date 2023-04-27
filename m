Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B446EFE90
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242847AbjD0AjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242821AbjD0AjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:39:05 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA2830D3;
        Wed, 26 Apr 2023 17:39:01 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33R0chtI7022256, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33R0chtI7022256
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 27 Apr 2023 08:38:43 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 27 Apr 2023 08:38:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 27 Apr 2023 08:38:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Thu, 27 Apr 2023 08:38:45 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull-request: wireless-next-2023-04-21
Thread-Topic: pull-request: wireless-next-2023-04-21
Thread-Index: AQHZdD60u8zT35eBqkOmWCVcBjPBJa81U6EAgAX6SUCAADntO4AAC0MAgAAvgQCAASv6AIAABsSA///NM4CAAY5GoA==
Date:   Thu, 27 Apr 2023 00:38:45 +0000
Message-ID: <ecaaf616d04d4e0b9303e1c680eefea7@realtek.com>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
         <20230421075404.63c04bca@kernel.org>
         <e31dae6daa6640859d12bf4c4fc41599@realtek.com> <87leigr06u.fsf@kernel.org>
                 <20230425071848.6156c0a0@kernel.org>
         <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
         <c69f151c77f34ae594dc2106bc68f2ac@realtek.com>
         <1a38a4289ef34672a2bc9a880e8608a8@realtek.com>
 <7214a6a800e4af80b9319c30b13cc52286bba50a.camel@sipsolutions.net>
In-Reply-To: <7214a6a800e4af80b9319c30b13cc52286bba50a.camel@sipsolutions.net>
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
MjAyMyA0OjI1IFBNDQo+IFRvOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT47IEph
a3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBLYWxsZSBWYWxvIDxrdmFsb0BrZXJuZWwu
b3JnPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtd2lyZWxlc3NAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBwdWxsLXJlcXVlc3Q6IHdpcmVsZXNzLW5leHQtMjAy
My0wNC0yMQ0KPiANCj4gT24gV2VkLCAyMDIzLTA0LTI2IGF0IDAzOjMwICswMDAwLCBQaW5nLUtl
IFNoaWggd3JvdGU6DQo+ID4gPiA+DQo+IA0KPiA+ID4NCj4gPiA+IEkgdGhpbmsgdGhlIGV4dHJh
IHdvcmsgS2FsbGUgbWVhbnQgaXMgd2hhdCBJIG1lbnRpb25lZCBwcmV2aW91c2x5IC0tDQo+ID4g
PiBuZWVkIGZ1bmN0aW9ucyB0byBjb252ZXJ0IG9sZCB0YWJsZXMgdjEsIHYyLCAuLi4gdG8gY3Vy
cmVudC4gTGlrZSwNCj4gPiA+DQo+ID4NCj4gPiBzdHJ1Y3QgdGFibGVfdjEgeyAvLyBmcm9tIGZp
bGUNCj4gPiAgICBfX2xlMzIgY2hhbm5lbF90eF9wb3dlclsxMF07DQo+ID4gfTsNCj4gPg0KPiA+
IHN0cnVjdCB0YWJsZV92MiB7IC8vIGZyb20gZmlsZQ0KPiA+ICAgIF9fbGUzMiBjaGFubmVsX3R4
X3Bvd2VyWzIwXTsNCj4gPiB9Ow0KPiA+DQo+ID4gc3RydWN0IHRhYmxlIHsgICAgLy8gZnJvbSBm
aWxlLCB0aGUgbGF0ZXN0IHZlcnNpb24gb2YgY3VycmVudCB1c2UNCj4gPiAgICBfX2xlMzIgY2hh
bm5lbF90eF9wb3dlclszMF07DQo+ID4gfTsNCj4gPg0KPiA+IHN0cnVjdCB0YWJsZV9jcHUgeyAg
Ly8gY3VycmVudCB0YWJsZSBpbiBjcHUgb3JkZXINCj4gPiAgICB1MzIgY2hhbm5lbF90eF9wb3dl
clszMF07DQo+ID4gfTsNCj4gPg0KPiA+IFRvIG1ha2UgZXhhbXBsZSBjbGVhcmVyLCBJIGNoYW5n
ZSB0aGUgbmFtZSBvZiBmaWVsZHMsIGJlY2F1c2UgdGhlIHRoaW5nIEkNCj4gPiB3YW50IHRvIG1l
bnRpb24gaXMgbm90IHJlZ2lzdGVyIHRhYmxlIHRoYXQgd291bGRuJ3QgbmVlZCBjb252ZXJzaW9u
Lg0KPiANCj4gUmlnaHQsIHRoZSBmaWxlIGZvcm1hdCB3b3VsZCBoYXZlIHRvIGJlIF9fbGUzMiAo
b3IgX19iZTMyKSwgYnV0IHRoYXQncw0KPiBwcmV0dHkgZWFzeSB0byBoYW5kbGUgd2hpbGUgd3Jp
dGluZyBpdCB0byB0aGUgZGV2aWNlPw0KPiANCj4gTm90IHN1cmUgSSB1bmRlcnN0YW5kIHRoZSBv
dGhlciB0aGluZyBhYm91dCBjb252ZXJzaW9uLg0KDQpSaWdodC4gSWYgYWxsIGVsZW1lbnRzIGFy
ZSB0aGUgc2FtZSB0eXBlIChlLmcuIF9fbGUzMiksIGl0IHdvdWxkIGJlIG11Y2ggZWFzaWVyLg0K
VGhlIGRpZmZpY3VsdHkgSSB3YW50IHRvIHNheSBpcyBiYWNrd2FyZCBjb21wYXRpYmlsaXR5Lg0K
DQo+IA0KPiA+ID4gSWYgbG9hZGluZyBhIHRhYmxlX3YxIHRhYmxlLCBmb3IgZXhhbXBsZSwgd2Ug
bmVlZCB0byBjb252ZXJ0IHRvIHRhYmxlX2NwdSBieQ0KPiA+ID4gc29tZSBydWxlcy4gQWxzbywg
bWF5YmUgd2UgbmVlZCB0byBkaXNhYmxlIHNvbWUgZmVhdHVyZXMgcmVsYXkgb24gdGhlIHZhbHVl
cw0KPiA+ID4gaW50cm9kdWNlZCBieSB0YWJsZV9jcHUuIEkgdGhpbmsgaXQgd2lsbCB3b3JrLCBi
dXQganVzdCBhZGQgc29tZSBmbGFncyBhbmQNCj4gPiA+IHJ1bGVzIHRvIGhhbmRsZSB0aGVtLg0K
PiANCj4gQnV0IHdvdWxkbid0IHRoaXMgYmFzaWNhbGx5IGJlIHRpZWQgdG8gYSBkcml2ZXI/IEkg
bWVhbiB5b3UgY291bGQgaGF2ZSBhDQo+IGZpbGUgY2FsbGVkICJydGx3aWZpL3J0bHh5ei52MS50
YWJsZXMiIHRoYXQgdGhlIGRyaXZlciBpbiBrZXJuZWwgNi40DQo+IGxvYWRzLCBhbmQgLi4udjIu
Li4gdGhhdCB0aGUgZHJpdmVyIGluIDYuNSBsb2FkcywgYW5kIHJlcXVpcmVzIGZvcg0KPiBvcGVy
YXRpb24/DQo+IA0KPiBUaGVuIGFnYWluIC0gaXQnZCBiZSBiZXR0ZXIgaWYgdGhlIGRyaXZlciBp
biA2LjUgY2FuIGRlYWwgd2l0aCBpdCBpZiBhDQo+IHVzZXIgZGlkbid0IGluc3RhbGwgdGhlIHYy
IGZpbGUgeWV0LCBpcyB0aGF0IHdoYXQgeW91IG1lYW50Pw0KDQpZZXMsIHRoaXMgaXMgbXkgcG9p
bnQsIGFuZCBJIHRoaW5rIDYuNSBfbXVzdF8gZGVhbCB3aXRoIHYxIGZpbGUuDQoNCkNvbnNpZGVy
aW5nIGJlbG93IGFydGlmaWNpYWwgZHJhbWE6IA0KDQoxLiBrZXJuZWwgNi40LCBkcml2ZXIgc3Vw
cG9ydCAyR0h6IGNoYW5uZWxzIG9ubHkgKHRhYmxlIHYxKQ0KICAgX19sZTMyIGNoYW5uZWxfdHhf
cG93ZXJfdjFbMkdIel9OVU1dDQoNCjIuIGtlcm5lbCA2LjUsIGRyaXZlciBzdXBwb3J0IDIgKyA1
R0h6IGNoYW5uZWxzICh0YWJsZSB2MikNCiAgIF9fbGUzMiBjaGFubmVsX3R4X3Bvd2VyX3YyWzJH
SHpfTlVNICsgNUdIel9OVU1dDQoNCiAgIEEgdXNlciBjb3VsZCBub3QgaW5zdGFsbCB2Miwgc28g
SSBuZWVkIGEgY29udmVyc2lvbiwgbGlrZQ0KICAgY29udmVydF92MV90b192MihzdHJ1Y3QgdGFi
bGVfdjEgKnYxLCBzdHJ1Y3QgdGFibGVfdjIgKnYyKSAvLyBhbHNvIGRpc2FibGUgNUdIeiBjaGFu
bmVscw0KDQozLiBrZXJuZWwgNi42LCBkcml2ZXIgc3VwcG9ydCAyICsgNSArIDZHSHogY2hhbm5l
bHMgKHRhYmxlIHYzKQ0KICAgX19sZTMyIGNoYW5uZWxfdHhfcG93ZXJfdjJbMkdIel9OVU0gKyA1
R0h6X05VTSArIDZHSHpfTlVNXQ0KICAgQSB1c2VyIGNvdWxkIG5vdCBpbnN0YWxsIHYzLCBzbyBJ
IG5lZWQgYW4gYWRkaXRpb25hbCBjb252ZXJzaW9uLCBsaWtlDQogICBjb252ZXJ0X3YyX3RvX3Yz
KHN0cnVjdCB0YWJsZV92MiAqdjIsIHN0cnVjdCB0YWJsZV92MyAqdjMpIC8vIGFsc28gZGlzYWJs
ZSA2R0h6IGNoYW5uZWxzDQoNCklmIG1vcmUgdGFibGUgdmVyc2lvbnMgYXJlIGludHJvZHVjZWQs
IG1vcmUgY29udmVyc2lvbnMgYXJlIG5lZWRlZC4gQWxzbywNCkknbSBub3Qgc3VyZSBob3cgdGhl
c2UgdGFibGVzIGNhbiBjaGFuZ2UgaW4gdGhlIGZ1dHVyZSwgc28gdGhlIGNvbnZlcnNpb24NCm1h
eSBiZSBjb21wbGljYXRlZCBpZiB0aGV5IGhhdmUgYSBiaWcgY2hhbmdlIGZvciBjZXJ0YWluIHJl
YXNvbi4gDQoNCk15IHBvaW50IGlzIHRoYXQgdGhpcyB3b3JrIGlzIHBvc3NpYmxlLCBidXQgaW50
cm9kdWNlIHNvbWUgZXh0cmEgd29ya3MgdGhhdA0KbWF5YmUgbG9vayBhIGxpdHRsZSBkaXJ0eS4g
DQoNClBpbmctS2UNCg0K
