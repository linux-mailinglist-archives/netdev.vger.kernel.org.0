Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5501547D00
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 02:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbiFMADR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 20:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiFMADP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 20:03:15 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BB317058;
        Sun, 12 Jun 2022 17:03:13 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 25D02OD60026571, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 25D02OD60026571
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Jun 2022 08:02:24 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 08:02:24 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 08:02:24 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Mon, 13 Jun 2022 08:02:24 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>
Subject: Re: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Thread-Topic: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Thread-Index: AQHYdDPI/ma2VkQlBE+TWL8Uknp8la03pxKAgABucQCADm9uAIABp+uAgAPWPgA=
Date:   Mon, 13 Jun 2022 00:02:23 +0000
Message-ID: <5ee547c352caee7c2ba8c0f541a305abeef0af9c.camel@realtek.com>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
         <20220530135457.1104091-11-s.hauer@pengutronix.de>
         <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
         <20220531074244.GN1615@pengutronix.de>
         <8443f8e51774a4f80fed494321fcc410e7174bf1.camel@realtek.com>
         <20220610132627.GO1615@pengutronix.de>
In-Reply-To: <20220610132627.GO1615@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.16.131]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzYvMTIg5LiL5Y2IIDEwOjAyOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A5BC8E3DA58764F86E9A18EA082EF29@realtek.com>
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

T24gRnJpLCAyMDIyLTA2LTEwIGF0IDE1OjI2ICswMjAwLCBzLmhhdWVyQHBlbmd1dHJvbml4LmRl
IHdyb3RlOg0KPiBPbiBUaHUsIEp1biAwOSwgMjAyMiBhdCAxMjo1MTo0OVBNICswMDAwLCBQaW5n
LUtlIFNoaWggd3JvdGU6DQo+ID4gDQo+ID4gVG9kYXksIEkgYm9ycm93IGEgODgyMmN1LCBhbmQg
dXNlIHlvdXIgcGF0Y2hzZXQgYnV0IHJldmVydA0KPiA+IHBhdGNoIDEwLzEwIHRvIHJlcHJvZHVj
ZSB0aGlzIGlzc3VlLiBXaXRoIGZpcm13YXJlIDcuMy4wLA0KPiA+IGl0IGxvb2tzIGJhZC4gQWZ0
ZXIgY2hlY2tpbmcgc29tZXRoaW5nIGFib3V0IGZpcm13YXJlLCBJDQo+ID4gZm91bmQgdGhlIGZp
cm13YXJlIGlzIG9sZCwgc28gdXBncmFkZSB0byA5LjkuMTEsIGFuZCB0aGVuDQo+ID4gaXQgd29y
a3Mgd2VsbCBmb3IgMTAgbWludXRlcywgbm8gYWJub3JtYWwgbWVzc2FnZXMuDQo+IA0KPiBJIG9y
aWdpbmFsbHkgdXNlZCBmaXJtd2FyZSA1LjAuMC4gVGhlbiBJIGhhdmUgdHJpZWQgOS45LjYgSSBo
YXZlIGx5aW5nDQo+IGFyb3VuZCBoZXJlIGZyb20gbXkgZGlzdHJvLiBUaGF0IHZlcnNpb24gYmVo
YXZlcyBsaWtlIHRoZSBvbGQgNS4wLjANCj4gdmVyc2lvbi4gRmluYWxseSBJIHN3aXRjaGVkIHRv
IDkuOS4xMSBmcm9tIGN1cnJlbnQgbGludXgtZmlybXdhcmUNCj4gcmVwb3NpdG9yeS4gVGhhdCBk
b2Vzbid0IHdvcmsgYXQgYWxsIGZvciBtZSB1bmZvcnR1bmF0ZWx5Og0KPiANCj4gWyAgMjIxLjA3
NjI3OV0gcnR3Xzg4MjJjdSAyLTE6MS4yOiBGaXJtd2FyZSB2ZXJzaW9uIDkuOS4xMSwgSDJDIHZl
cnNpb24gMTUNCj4gWyAgMjIxLjA3ODQwNV0gcnR3Xzg4MjJjdSAyLTE6MS4yOiBGaXJtd2FyZSB2
ZXJzaW9uIDkuOS40LCBIMkMgdmVyc2lvbiAxNQ0KPiBbICAyMzkuNzgzMjYxXSB3bGFuMDogYXV0
aGVudGljYXRlIHdpdGggNzY6ODM6YzI6Y2U6ODM6MGINCj4gWyAgMjQyLjM5ODQzNV0gd2xhbjA6
IHNlbmQgYXV0aCB0byA3Njo4MzpjMjpjZTo4MzowYiAodHJ5IDEvMykNCj4gWyAgMjQyLjQwMjk5
Ml0gd2xhbjA6IGF1dGhlbnRpY2F0ZWQNCj4gWyAgMjQyLjQyMDczNV0gd2xhbjA6IGFzc29jaWF0
ZSB3aXRoIDc2OjgzOmMyOmNlOjgzOjBiICh0cnkgMS8zKQ0KPiBbICAyNDIuNDM3MDk0XSB3bGFu
MDogUlggQXNzb2NSZXNwIGZyb20gNzY6ODM6YzI6Y2U6ODM6MGIgKGNhcGFiPTB4MTQxMSBzdGF0
dXM9MCBhaWQ9NCkNCj4gWyAgMjQyLjQ4NTUyMV0gd2xhbjA6IGFzc29jaWF0ZWQNCj4gWyAgMjQy
LjU2NDg0N10gd2xhbjA6IENvbm5lY3Rpb24gdG8gQVAgNzY6ODM6YzI6Y2U6ODM6MGIgbG9zdA0K
PiBbICAyNDQuNTc3NjE3XSB3bGFuMDogYXV0aGVudGljYXRlIHdpdGggNzY6ODM6YzI6Y2Q6ODM6
MGINCj4gWyAgMjQ0LjU3ODI1N10gd2xhbjA6IGJhZCBWSFQgY2FwYWJpbGl0aWVzLCBkaXNhYmxp
bmcgVkhUDQo+IA0KPiBUaGlzIGdvZXMgb24gZm9yZXZlci4gSSBmaW5hbGx5IHRyaWVkIDkuOS4x
MCBhbmQgOS45LjksIHRoZXkgYWxzbyBiZWhhdmUNCj4gbGlrZSA5LjkuMTEuDQo+IA0KDQpQbGVh
c2UgaGVscCBkbyBtb3JlIGV4cGVyaWVtZW50cyBvbiB5b3VyIDg4MjJjdSB3aXRoIHRoZQ0KbGF0
ZXN0IGZpcm13YXJlIDkuOS4xMS4NCg0KMS4gd2hpY2ggbW9kdWxlIFJGRSB0eXBlIHlvdSBhcmUg
dXNpbmc/DQogICBNeSA4ODIyY3UgaXMgUkZFIHR5cGUgNC4NCiAgIEdldCB0aGlzIGluZm9ybWF0
aW9uIGZyb20gDQoNCiAgIGNhdCAvc3lzL2tlcm5lbC9kZWJ1Zy9pZWVlODAyMTEvcGh5WFhYL3J0
dzg4L2NvZXhfaW5mbw0KDQogICBUaGUgNHRoIGxpbmU6DQogICBNZWNoLyBSRkUgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgID0gTm9uLVNoYXJlZC8gNCAgIA0KDQo0LiBEaXNhYmxlIHBv
d2VyIHNhdmUgdG8gc2VlIGlmIGl0IHN0aWxsIGRpc2Nvbm5lY3QgZnJvbSBBUA0KDQogICBpdyB3
bGFuMCBzZXQgcG93ZXJfc2F2ZSBvZmYNCg0KICAgSWYgdGhpcyBjYW4gd29yayB3ZWxsLCBzdGls
bCBwb3dlciBzYXZlIG1vZGUgd29ya3MgYWJub3JtYWwuDQoNCjMuIERpc2FibGUga2VlcC1hbGl2
ZS4gKHdpdGggcG93ZXJfc2F2ZSBvbikNCg0KLS0tIGEvbWFpbi5jDQorKysgYi9tYWluLmMNCkBA
IC0yMTk5LDYgKzIxOTksNyBAQCBpbnQgcnR3X3JlZ2lzdGVyX2h3KHN0cnVjdCBydHdfZGV2ICpy
dHdkZXYsIHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KICAgICAgICBpZWVlODAyMTFfaHdfc2V0
KGh3LCBIQVNfUkFURV9DT05UUk9MKTsNCiAgICAgICAgaWVlZTgwMjExX2h3X3NldChodywgVFhf
QU1TRFUpOw0KICAgICAgICBpZWVlODAyMTFfaHdfc2V0KGh3LCBTSU5HTEVfU0NBTl9PTl9BTExf
QkFORFMpOw0KKyAgICAgICBpZWVlODAyMTFfaHdfc2V0KGh3LCBDT05ORUNUSU9OX01PTklUT1Ip
Ow0KDQogICBUaGlzIGNhbiBtYWtlIGl0IHN0aWxsIGNvbm5lY3RlZCBldmVuIGl0IGRvZXNuJ3Qg
cmVjZWl2ZSBhbnl0aGluZy4NCiAgIENoZWNrIGlmIGl0IGNhbiBsZWF2ZSBwb3dlciBzYXZlIHdp
dGhvdXQgYWJub3JtYWwgbWVzc2FnZXMuDQoNCjQuIFVTQiBpbnRlcmZlcmVuY2UNCg0KICAgVmVy
eSBsb3cgcG9zc2liaWxpdHksIGJ1dCBzaW1wbHkgdHJ5IFVTQiAyLjAgYW5kIDMuMCBwb3J0cy4N
Cg0KNS4gVHJ5IGFub3RoZXIgQVAgd29ya2luZyBvbiBkaWZmZXJlbnQgYmFuZCAoMi40R0h6IG9y
IDVHaHopDQoNCg0KSSB3aXNlIHRoZXNlIGNhbiBuYXJyb3cgZG93biB0aGUgcHJvYmxlbSB5b3Ug
bWV0Lg0KDQpQaW5nLUtlDQoNCg0K
