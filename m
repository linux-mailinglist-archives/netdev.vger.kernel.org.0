Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60D952E8B2
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347688AbiETJXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 05:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347627AbiETJXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 05:23:42 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4669191573;
        Fri, 20 May 2022 02:23:40 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K9NB920026777, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K9NB920026777
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 17:23:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 17:23:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 20 May 2022 17:23:11 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 17:23:11 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "neo_jou@realtek.com" <neo_jou@realtek.com>
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
Thread-Topic: [PATCH 06/10] rtw88: Add common USB chip support
Thread-Index: AQHYapDiqxMx5uVh8U2fFMFwvLZZx60m3hOAgAAUZgCAAAixAA==
Date:   Fri, 20 May 2022 09:23:11 +0000
Message-ID: <a0c7fb57d0e9c1a36f328f4e523643ba6009630f.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-7-s.hauer@pengutronix.de>
         <e9ca08c6facb8916fb9e5cbad05447321d3d0f43.camel@realtek.com>
         <20220520085156.GE25578@pengutronix.de>
In-Reply-To: <20220520085156.GE25578@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjAg5LiK5Y2IIDA3OjI3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <876FF89BFAA1BE468B922ECF02786C6C@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTA1LTIwIGF0IDEwOjUxICswMjAwLCBzLmhhdWVyQHBlbmd1dHJvbml4LmRl
IHdyb3RlOg0KPiBPbiBGcmksIE1heSAyMCwgMjAyMiBhdCAwNzozOTowM0FNICswMDAwLCBQa3No
aWggd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIyLTA1LTE4IGF0IDEwOjIzICswMjAwLCBTYXNjaGEg
SGF1ZXIgd3JvdGU6DQo+ID4gPiBBZGQgdGhlIGNvbW1vbiBiaXRzIGFuZCBwaWVjZXMgdG8gYWRk
IFVTQiBzdXBwb3J0IHRvIHRoZSBSVFc4OCBkcml2ZXIuDQo+ID4gPiBUaGlzIGlzIGJhc2VkIG9u
IGh0dHBzOi8vZ2l0aHViLmNvbS91bGxpLWtyb2xsL3J0dzg4LXVzYi5naXQgd2hpY2gNCj4gPiA+
IGl0c2VsZiBpcyBmaXJzdCB3cml0dGVuIGJ5IE5lbyBKb3UuDQo+ID4gPiANCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IG5lb19qb3UgPG5lb19qb3VAcmVhbHRlay5jb20+DQo+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBIYW5zIFVsbGkgS3JvbGwgPGxpbnV4QHVsbGkta3JvbGwuZGU+DQo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBTYXNjaGEgSGF1ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU+DQo+ID4gPiAtLS0N
Cj4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L0tjb25maWcgIHwgICAg
MyArDQo+ID4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9NYWtlZmlsZSB8
ICAgIDIgKw0KPiA+ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFjLmMg
ICAgfCAgICAzICsNCj4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L21h
aW4uYyAgIHwgICAgNSArDQo+ID4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OC9tYWluLmggICB8ICAgIDQgKw0KPiA+ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvcmVnLmggICAgfCAgICAxICsNCj4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0dzg4L3R4LmggICAgIHwgICAzMSArDQo+ID4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OC91c2IuYyAgICB8IDEwNTEgKysrKysrKysrKysrKysrKysrKw0KPiA+ID4g
IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvdXNiLmggICAgfCAgMTA5ICsrDQo+
ID4gPiAgOSBmaWxlcyBjaGFuZ2VkLCAxMjA5IGluc2VydGlvbnMoKykNCj4gPiA+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC91c2IuYw0KPiA+
ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4
L3VzYi5oDQo+ID4gPiANCj4gPiANCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiArc3RhdGljIHZv
aWQgcnR3X3VzYl9jYW5jZWxfcnhfYnVmcyhzdHJ1Y3QgcnR3X3VzYiAqcnR3dXNiKQ0KPiA+ID4g
K3sNCj4gPiA+ICsJc3RydWN0IHJ4X3VzYl9jdHJsX2Jsb2NrICpyeGNiOw0KPiA+ID4gKwl1bnNp
Z25lZCBsb25nIGZsYWdzOw0KPiA+ID4gKw0KPiA+ID4gKwlzcGluX2xvY2tfaXJxc2F2ZSgmcnR3
dXNiLT5yeF9kYXRhX2xpc3RfbG9jaywgZmxhZ3MpOw0KPiA+ID4gKw0KPiA+ID4gKwl3aGlsZSAo
dHJ1ZSkgew0KPiA+ID4gKwkJcnhjYiA9IGxpc3RfZmlyc3RfZW50cnlfb3JfbnVsbCgmcnR3dXNi
LT5yeF9kYXRhX3VzZWQsDQo+ID4gPiArCQkJCQkJc3RydWN0IHJ4X3VzYl9jdHJsX2Jsb2NrLCBs
aXN0KTsNCj4gPiA+ICsNCj4gPiA+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnJ0d3VzYi0+
cnhfZGF0YV9saXN0X2xvY2ssIGZsYWdzKTsNCj4gPiA+ICsNCj4gPiA+ICsJCWlmICghcnhjYikN
Cj4gPiA+ICsJCQlicmVhazsNCj4gPiA+ICsNCj4gPiA+ICsJCXVzYl9raWxsX3VyYihyeGNiLT5y
eF91cmIpOw0KPiA+ID4gKw0KPiA+ID4gKwkJc3Bpbl9sb2NrX2lycXNhdmUoJnJ0d3VzYi0+cnhf
ZGF0YV9saXN0X2xvY2ssIGZsYWdzKTsNCj4gPiA+ICsJCWxpc3RfbW92ZSgmcnhjYi0+bGlzdCwg
JnJ0d3VzYi0+cnhfZGF0YV9mcmVlKTsNCj4gPiA+ICsJfQ0KPiA+ID4gK30NCj4gPiANCj4gPiBU
aGUgc3Bpbl9sb2NrIHBhaXJzIGFyZSBub3QgaW50dWl0aXZlLg0KPiA+IENhbiB3ZSBjaGFuZ2Ug
dGhpcyBjaHVuayB0bw0KPiA+IA0KPiA+IHdoaWxlICh0cnVlKSB7DQo+ID4gICAgICBzcGluX2xv
Y2soKTsNCj4gPiAgICAgIHJ4Y2IgPSBsaXN0X2ZpcnN0X2VudHJ5X29yX251bGwoKTsNCj4gPiAg
ICAgIHNwaW5fdW5sb2NrKCkNCj4gPiANCj4gPiAgICAgIGlmICghcnhjYikNCj4gPiAgICAgICAg
IHJldHVybjsNCj4gPiANCj4gPiAgICAgIHVzYl9mcmVlX3VyYigpOw0KPiA+IA0KPiA+ICAgICAg
c3Bpbl9sb2NrKCk7DQo+ID4gICAgICBsaXN0X2RlbCgpOw0KPiA+ICAgICAgc3Bpbl91bmxvY2so
KTsNCj4gPiB9DQo+ID4gDQo+ID4gVGhlIGRyYXdiYWNrIGlzIGxvY2svdW5sb2NrIHR3aWNlIGlu
IHNpbmdsZSBsb29wLg0KPiANCj4gWWVzLCB0aGF0J3Mgd2h5IEkgZGlkIGl0IHRoZSB3YXkgSSBk
aWQgOykNCj4gDQo+IEhvdyBhYm91dDoNCj4gDQo+IAl3aGlsZSAodHJ1ZSkgew0KPiAJCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7DQo+IA0KPiAJCXNwaW5fbG9ja19pcnFzYXZlKCZydHd1c2ItPnJ4X2Rh
dGFfbGlzdF9sb2NrLCBmbGFncyk7DQo+IA0KPiAJCXJ4Y2IgPSBsaXN0X2ZpcnN0X2VudHJ5X29y
X251bGwoJnJ0d3VzYi0+cnhfZGF0YV9mcmVlLA0KPiAJCQkJCQlzdHJ1Y3QgcnhfdXNiX2N0cmxf
YmxvY2ssIGxpc3QpOw0KPiAJCWlmIChyeGNiKQ0KPiAJCQlsaXN0X2RlbCgmcnhjYi0+bGlzdCk7
DQo+IA0KPiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnJ0d3VzYi0+cnhfZGF0YV9saXN0X2xv
Y2ssIGZsYWdzKTsNCj4gDQo+IAkJaWYgKCFyeGNiKQ0KPiAJCQlicmVhazsNCj4gDQo+IAkJdXNi
X2ZyZWVfdXJiKHJ4Y2ItPnJ4X3VyYik7DQo+IAl9DQo+IA0KDQpXaXRoIHRoZSBuZXcgb25lLCBJ
IGNhbiBlYXNpbHkgY2hlY2sgc3Bpbl9sb2NrL191bmxvY2sgaXMgcGFpcmVkLCBzbw0KSSB2b3Rl
IGl0Lg0KDQotLQ0KUGluZy1LZQ0KDQoNCg==
