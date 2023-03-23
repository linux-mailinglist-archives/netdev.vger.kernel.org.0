Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA56C5BA0
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjCWA77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 20:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCWA76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 20:59:58 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEF5AF17;
        Wed, 22 Mar 2023 17:59:48 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32N0xMzJ5002829, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32N0xMzJ5002829
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 08:59:22 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 23 Mar 2023 08:59:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 23 Mar 2023 08:59:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 23 Mar 2023 08:59:36 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jonas Gorski <jonas.gorski@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
Thread-Topic: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
Thread-Index: AQHZXNa3MLbDic+okUWUZsB7esnCtq8GfvKAgABBsICAAMlp0A==
Date:   Thu, 23 Mar 2023 00:59:36 +0000
Message-ID: <e4f8e55f843041978098f57ecb7e558b@realtek.com>
References: <ZBskz06HJdLzhFl5@hyeyoo>
 <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
 <CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com>
In-Reply-To: <CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
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
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9uYXMgR29yc2tpIDxq
b25hcy5nb3Jza2lAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMjMsIDIwMjMg
NDo1MiBBTQ0KPiBUbzogTGFycnkgRmluZ2VyIDxMYXJyeS5GaW5nZXJAbHdmaW5nZXIubmV0Pg0K
PiBDYzogSHllb25nZ29uIFlvbyA8NDIuaHlleW9vQGdtYWlsLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgUGluZy1LZQ0KPiBTaGlo
IDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IFN1YmplY3Q6IFJlOiBbQlVHIHY2LjIuN10gSGl0dGlu
ZyBCVUdfT04oKSBvbiBydHc4OSB3aXJlbGVzcyBkcml2ZXIgc3RhcnR1cA0KPiANCj4gT24gV2Vk
LCAyMiBNYXIgMjAyMyBhdCAxODowMywgTGFycnkgRmluZ2VyIDxMYXJyeS5GaW5nZXJAbHdmaW5n
ZXIubmV0PiB3cm90ZToNCj4gPg0KPiA+IE9uIDMvMjIvMjMgMTA6NTQsIEh5ZW9uZ2dvbiBZb28g
d3JvdGU6DQo+ID4gPg0KPiA+ID4gSGVsbG8gZm9sa3MsDQo+ID4gPiBJJ3ZlIGp1c3QgZW5jb3Vu
dGVyZWQgd2VpcmQgYnVnIHdoZW4gYm9vdGluZyBMaW51eCB2Ni4yLjcNCj4gPiA+DQo+ID4gPiBj
b25maWc6IGF0dGFjaGVkDQo+ID4gPiBkbWVzZzogYXR0YWNoZWQNCj4gPiA+DQo+ID4gPiBJJ20g
bm90IHN1cmUgZXhhY3RseSBob3cgdG8gdHJpZ2dlciB0aGlzIGlzc3VlIHlldCBiZWNhdXNlIGl0
J3Mgbm90DQo+ID4gPiBzdGFibHkgcmVwcm9kdWNpYmxlLiAoanVzdCBoYXZlIGVuY291bnRlcmVk
IHJhbmRvbWx5IHdoZW4gbG9nZ2luZyBpbikNCj4gPiA+DQo+ID4gPiBBdCBxdWljayBsb29rIGl0
IHNlZW1zIHRvIGJlIHJlbGF0ZWQgdG8gcnR3ODkgd2lyZWxlc3MgZHJpdmVyIG9yIG5ldHdvcmsg
c3Vic3lzdGVtLg0KPiA+DQo+ID4gWW91ciBidWcgaXMgd2VpcmQgaW5kZWVkLCBhbmQgaXQgZG9l
cyBjb21lIGZyb20gcnR3ODlfODg1MmJlLiBNeSBkaXN0cm8gaGFzIG5vdA0KPiA+IHlldCByZWxl
YXNlZCBrZXJuZWwgNi4yLjcsIGJ1dCBJIGhhdmUgbm90IHNlZW4gdGhpcyBwcm9ibGVtIHdpdGgg
bWFpbmxpbmUNCj4gPiBrZXJuZWxzIHRocm91Z2hvdXQgdGhlIDYuMiBvciA2LjMgZGV2ZWxvcG1l
bnQgc2VyaWVzLg0KPiANCj4gTG9va2luZyBhdCB0aGUgcnR3ODkgZHJpdmVyJ3MgcHJvYmUgZnVu
Y3Rpb24sIHRoZSBidWcgaXMgcHJvYmFibHkgYQ0KPiBzaW1wbGUgcmFjZSBjb25kaXRpb246DQo+
IA0KPiBpbnQgcnR3ODlfcGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1
Y3QgcGNpX2RldmljZV9pZCAqaWQpDQo+IHsNCj4gICAgIC4uLg0KPiAgICAgcmV0ID0gcnR3ODlf
Y29yZV9yZWdpc3RlcihydHdkZXYpOyA8LSBjYWxscyBpZWVlODAyMTFfcmVnaXN0ZXJfaHcoKTsN
Cj4gICAgIC4uLg0KPiAgICAgcnR3ODlfY29yZV9uYXBpX2luaXQocnR3ZGV2KTsNCj4gICAgIC4u
Lg0KPiB9DQo+IA0KPiBzbyBpdCByZWdpc3RlcnMgdGhlIHdpZmkgZGV2aWNlIGZpcnN0LCBtYWtp
bmcgaXQgdmlzaWJsZSB0byB1c2Vyc3BhY2UsDQo+IGFuZCB0aGVuIGluaXRpYWxpemVzIG5hcGku
DQo+IA0KPiBTbyB0aGVyZSBpcyBhIHdpbmRvdyB3aGVyZSBhIGZhc3QgdXNlcnNwYWNlIG1heSBh
bHJlYWR5IHRyeSB0bw0KPiBpbnRlcmFjdCB3aXRoIHRoZSBkZXZpY2UgYmVmb3JlIHRoZSBkcml2
ZXIgZ290IGFyb3VuZCB0byBpbml0aWFsaXppbmcNCj4gdGhlIG5hcGkgcGFydHMsIGFuZCB0aGVu
IGl0IGV4cGxvZGVzLiBBdCBsZWFzdCB0aGF0IGlzIG15IHRoZW9yeSBmb3INCj4gdGhlIGlzc3Vl
Lg0KPiANCj4gU3dpdGNoaW5nIHRoZSBvcmRlciBvZiB0aGVzZSB0d28gZnVuY3Rpb25zIHNob3Vs
ZCBhdm9pZCBpdCBpbiB0aGVvcnksDQo+IGFzIGxvbmcgYXMgcnR3ODlfY29yZV9uYXBpX2luaXQo
KSBkb2Vzbid0IGRlcGVuZCBvbiBhbnl0aGluZw0KPiBydHc4OV9jb3JlX3JlZ2lzdGVyKCkgZG9l
cy4NCj4gDQo+IEZXSVcsIHJlZ2lzdGVyaW5nIHRoZSBpcnEgaGFuZGxlciBvbmx5IGFmdGVyIHJl
Z2lzdGVyaW5nIHRoZSBkZXZpY2UNCj4gYWxzbyBzZWVtcyBzdXNwZWN0LCBhbmQgc2hvdWxkIHBy
b2JhYmx5IGFsc28gaGFwcGVuIGJlZm9yZSB0aGF0Lg0KDQpBZGRpbmcgYSAxMCBzZWNvbmRzIHNs
ZWVwIGJldHdlZW4gcnR3ODlfY29yZV9yZWdpc3RlcigpIGFuZA0KcnR3ODlfY29yZV9uYXBpX2lu
aXQoKSwgYW5kIEkgY2FuIHJlcHJvZHVjZSB0aGlzIGlzc3VlOg0KDQppbnQgcnR3ODlfcGNpX3By
b2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQp
DQp7DQogICAgLi4uDQogICAgcmV0ID0gcnR3ODlfY29yZV9yZWdpc3RlcihydHdkZXYpOw0KICAg
IC4uLg0KCW1zbGVlcCgxMCAqIDEwMCk7DQoJLi4uDQogICAgcnR3ODlfY29yZV9uYXBpX2luaXQo
cnR3ZGV2KTsNCiAgICAuLi4NCn0NCg0KQW5kLCBhcyB5b3VyIHN1Z2dlc3Rpb24sIEkgbW92ZSB0
aGUgcnR3ODlfY29yZV9yZWdpc3RlcigpIHRvIHRoZSBsYXN0IHN0ZXANCm9mIFBDSSBwcm9iZS4g
VGhlbiwgaXQgbG9va3MgbW9yZSByZWFzb25hYmxlIHRoYXQgd2UgcHJlcGFyZSBOQVBJIGFuZA0K
aW50ZXJydXB0IGhhbmRsZXJzIGJlZm9yZSByZWdpc3RlcmluZyBuZXRkZXYuIENvdWxkIHlvdSBn
aXZlIGl0IGEgdHJ5IHdpdGgNCmJlbG93IGZpeD8NCg0KZGlmZiAtLWdpdCBhL3BjaS5jIGIvcGNp
LmMNCmluZGV4IGZlNmMwZWZjLi4wODdkZTJlMCAxMDA2NDQNCi0tLSBhL3BjaS5jDQorKysgYi9w
Y2kuYw0KQEAgLTM4NzksMjUgKzM4NzksMjYgQEAgaW50IHJ0dzg5X3BjaV9wcm9iZShzdHJ1Y3Qg
cGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQ0KICAgICAgICBy
dHc4OV9wY2lfbGlua19jZmcocnR3ZGV2KTsNCiAgICAgICAgcnR3ODlfcGNpX2wxc3NfY2ZnKHJ0
d2Rldik7DQoNCi0gICAgICAgcmV0ID0gcnR3ODlfY29yZV9yZWdpc3RlcihydHdkZXYpOw0KLSAg
ICAgICBpZiAocmV0KSB7DQotICAgICAgICAgICAgICAgcnR3ODlfZXJyKHJ0d2RldiwgImZhaWxl
ZCB0byByZWdpc3RlciBjb3JlXG4iKTsNCi0gICAgICAgICAgICAgICBnb3RvIGVycl9jbGVhcl9y
ZXNvdXJjZTsNCi0gICAgICAgfQ0KLQ0KICAgICAgICBydHc4OV9jb3JlX25hcGlfaW5pdChydHdk
ZXYpOw0KDQogICAgICAgIHJldCA9IHJ0dzg5X3BjaV9yZXF1ZXN0X2lycShydHdkZXYsIHBkZXYp
Ow0KICAgICAgICBpZiAocmV0KSB7DQogICAgICAgICAgICAgICAgcnR3ODlfZXJyKHJ0d2Rldiwg
ImZhaWxlZCB0byByZXF1ZXN0IHBjaSBpcnFcbiIpOw0KLSAgICAgICAgICAgICAgIGdvdG8gZXJy
X3VucmVnaXN0ZXI7DQorICAgICAgICAgICAgICAgZ290byBlcnJfZGVpbml0X25hcGk7DQorICAg
ICAgIH0NCisNCisgICAgICAgcmV0ID0gcnR3ODlfY29yZV9yZWdpc3RlcihydHdkZXYpOw0KKyAg
ICAgICBpZiAocmV0KSB7DQorICAgICAgICAgICAgICAgcnR3ODlfZXJyKHJ0d2RldiwgImZhaWxl
ZCB0byByZWdpc3RlciBjb3JlXG4iKTsNCisgICAgICAgICAgICAgICBnb3RvIGVycl9mcmVlX2ly
cTsNCiAgICAgICAgfQ0KDQogICAgICAgIHJldHVybiAwOw0KDQotZXJyX3VucmVnaXN0ZXI6DQor
ZXJyX2ZyZWVfaXJxOg0KKyAgICAgICBydHc4OV9wY2lfZnJlZV9pcnEocnR3ZGV2LCBwZGV2KTsN
CitlcnJfZGVpbml0X25hcGk6DQogICAgICAgIHJ0dzg5X2NvcmVfbmFwaV9kZWluaXQocnR3ZGV2
KTsNCi0gICAgICAgcnR3ODlfY29yZV91bnJlZ2lzdGVyKHJ0d2Rldik7DQogZXJyX2NsZWFyX3Jl
c291cmNlOg0KICAgICAgICBydHc4OV9wY2lfY2xlYXJfcmVzb3VyY2UocnR3ZGV2LCBwZGV2KTsN
CiBlcnJfZGVjbGFpbV9wY2k6DQoNCi0tDQpQaW5nLUtlDQoNCg0K
