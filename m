Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726A45310DF
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbiEWLkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiEWLk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:40:29 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2265045F;
        Mon, 23 May 2022 04:40:26 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24NBdo8uB012846, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24NBdo8uB012846
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 May 2022 19:39:50 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 23 May 2022 19:39:50 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 23 May 2022 19:39:50 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Mon, 23 May 2022 19:39:49 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
Thread-Topic: [PATCH 00/10] RTW88: Add support for USB variants
Thread-Index: AQHYapDZwMHGDOiyz0ihhLmh/UE9+a0rWe8AgAAuhwCAAE/oAA==
Date:   Mon, 23 May 2022 11:39:49 +0000
Message-ID: <68a979f3fe3c80a460528605f03d85c2a265ff50.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <55f569899e4e894970b826548cd5439f5def2183.camel@ulli-kroll.de>
         <20220523065348.GK25578@pengutronix.de>
In-Reply-To: <20220523065348.GK25578@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [114.26.229.84]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjMg5LiK5Y2IIDA5OjIyOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA3557C8A58552428DEEED4E61485A01@realtek.com>
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

T24gTW9uLCAyMDIyLTA1LTIzIGF0IDA4OjUzICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IEhpIEhhbnMgVWxsaSwNCj4gDQo+IE9uIE1vbiwgTWF5IDIzLCAyMDIyIGF0IDA2OjA3OjE2QU0g
KzAyMDAsIEhhbnMgVWxsaSBLcm9sbCB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMjItMDUtMTggYXQg
MTA6MjMgKzAyMDAsIFNhc2NoYSBIYXVlciB3cm90ZToNCj4gPiA+IFRoaXMgc2VyaWVzIGFkZHMg
c3VwcG9ydCBmb3IgdGhlIFVTQiBjaGlwIHZhcmlhbnRzIHRvIHRoZSBSVFc4OCBkcml2ZXIuDQo+
ID4gPiANCj4gPiANCj4gPiBIaSBTYXNjaGENCj4gPiANCj4gPiBnbGFkIHlvdSBmb3VuZCBzb21l
ICp3b3JraW5nKiBkZXZpY2VzIGZvciBydHc4OCAhDQo+IA0KPiBXZWxsLCBub3QgZnVsbHkuIEkg
aGFkIHRvIGFkZCBbM10gPSBSVFdfREVGX1JGRSg4ODIyYywgMCwgMCksIHRvIHRoZQ0KPiBydHc4
ODIyY19yZmVfZGVmcyBhcnJheS4NCj4gDQo+ID4gSSBzcGVuZCBzb21lIG9mIHRoZSB3ZWVrZW5k
IHRlc3RpbmcgeW91ciBkcml2ZXIgc3VibWlzc2lvbi4NCj4gPiANCj4gPiBmb3IgcnRsODgyMWN1
IGRldmljZXMgSSBnZXQgZm9sbG93aW5nIG91dHB1dA0KPiA+IA0KPiA+IHNvbWUgTG9naWxpbmsg
ZGV2aWNlDQo+ID4gDQo+ID4gWyAxNjg2LjYwNTU2N10gdXNiIDEtNS4xLjI6IE5ldyBVU0IgZGV2
aWNlIGZvdW5kLCBpZFZlbmRvcj0wYmRhLCBpZFByb2R1Y3Q9YzgxMSwgYmNkRGV2aWNlPQ0KPiA+
IDIuMDANCj4gPiBbIDE2ODYuNjE0MTg2XSB1c2IgMS01LjEuMjogTmV3IFVTQiBkZXZpY2Ugc3Ry
aW5nczogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTMNCj4gPiBbIDE2ODYuNjIxNzIx
XSB1c2IgMS01LjEuMjogUHJvZHVjdDogODAyLjExYWMgTklDDQo+ID4gWyAxNjg2LjYyNjIyN10g
dXNiIDEtNS4xLjI6IE1hbnVmYWN0dXJlcjogUmVhbHRlaw0KPiA+IFsgMTY4Ni42MzA2OTVdIHVz
YiAxLTUuMS4yOiBTZXJpYWxOdW1iZXI6IDEyMzQ1Ng0KPiA+IFsgMTY4Ni42NDA0ODBdIHJ0d184
ODIxY3UgMS01LjEuMjoxLjA6IEZpcm13YXJlIHZlcnNpb24gMjQuNS4wLCBIMkMgdmVyc2lvbiAx
Mg0KPiA+IFsgMTY4Ni45MzI4MjhdIHJ0d184ODIxY3UgMS01LjEuMjoxLjA6IGZhaWxlZCB0byBk
b3dubG9hZCBmaXJtd2FyZQ0KPiA+IFsgMTY4Ni45NDUyMDZdIHJ0d184ODIxY3UgMS01LjEuMjox
LjA6IGZhaWxlZCB0byBzZXR1cCBjaGlwIGVmdXNlIGluZm8NCj4gPiBbIDE2ODYuOTUxNTM4XSBy
dHdfODgyMWN1IDEtNS4xLjI6MS4wOiBmYWlsZWQgdG8gc2V0dXAgY2hpcCBpbmZvcm1hdGlvbg0K
PiA+IFsgMTY4Ni45NTg0MDJdIHJ0d184ODIxY3U6IHByb2JlIG9mIDEtNS4xLjI6MS4wIGZhaWxl
ZCB3aXRoIGVycm9yIC0yMg0KPiA+IA0KPiA+IGFib3ZlIGlzIHNhbWUgd2l0aCBzb21lIGZyb20g
Q29tZmFzdA0KPiA+IA0KPiA+IFRoZSB3b3JzdCBpbiB0aGUgbGlzdCBpcyBvbmUgZnJvbSBFRFVQ
DQo+ID4gDQo+ID4gWyAxODE3Ljg1NTcwNF0gcnR3Xzg4MjFjdSAxLTUuMS4yOjEuMjogRmlybXdh
cmUgdmVyc2lvbiAyNC41LjAsIEgyQyB2ZXJzaW9uIDEyDQo+ID4gWyAxODE4LjE1MzkxOF0gcnR3
Xzg4MjFjdSAxLTUuMS4yOjEuMjogcmZlIDI1NSBpc24ndCBzdXBwb3J0ZWQNCj4gPiBbIDE4MTgu
MTY1MTc2XSBydHdfODgyMWN1IDEtNS4xLjI6MS4yOiBmYWlsZWQgdG8gc2V0dXAgY2hpcCBlZnVz
ZSBpbmZvDQo+ID4gWyAxODE4LjE3MTUwNV0gcnR3Xzg4MjFjdSAxLTUuMS4yOjEuMjogZmFpbGVk
IHRvIHNldHVwIGNoaXAgaW5mb3JtYXRpb24NCj4gDQo+IERvIHRoZXNlIGNoaXBzIHdvcmsgd2l0
aCB5b3VyIG91dCBvZiB0cmVlIHZhcmlhbnQgb2YgdGhpcyBkcml2ZXI/DQo+IA0KPiBJcyB0aGUg
ZWZ1c2UgaW5mbyBjb21wbGV0ZWx5IDB4ZmYgb3Igb25seSB0aGUgZmllbGQgaW5kaWNhdGluZyB0
aGUgcmZlDQo+IG9wdGlvbj8NCg0KSSBjaGVjayBSRkUgYWxsb2NhdGlvbiBvZiA4ODIxYy4gMjU1
IGlzbid0IGRlZmluZWQuDQpJZiBlZnVzZSBpbmZvIGlzbid0IGNvbXBsZXRlIDB4ZmYsIHRyeSB0
byBmb3JjZSBSRkUgMCB0byBzZWUgaWYgaXQgd29ya3MuDQoNCj4gDQo+ID4gcnRsODgyMmJ1IGRl
dmljZXMgYXJlIHdvcmtpbmcgZmluZSAuLi4NCj4gDQo+IE5pY2UuIERpZCB5b3UgdGVzdCBhIHJ0
dzg3MjNkdSBkZXZpY2UgYXMgd2VsbD8NCj4gDQoNCkkgaGF2ZSBhIDg3MjNEVSBtb2R1bGUuDQoN
CldpdGggdGhpcyBwYXRjaHNldCwgaXQgY2FuIGZpbmQgQVAsIGJ1dCBjYW4ndCBlc3RpYWJsaXNo
IGNvbm5lY3Rpb24uDQpJIGNoZWNrIGFpciBjYXB0dXJlLCBidXQgbm8gVFggcGFja2V0cyBmb3Vu
ZC4NClRoYXQgc2F5cyBSWCB3b3JrcywgYnV0IFRYIGRvZXNuJ3QuDQoNCldpdGggbWFzdGVyIGJy
YW5jaCBvZiBIYW5zIFVsbGkgR2l0SHViLCBpdCBzaG93cyBtYW55ICJhdG9taWMgc2NoZWR1bGlu
ZyINCndhcm5pbmdzIHdoZW4gSSBpbnNlcnQgdGhlIFVTQiBkb25nbGUuDQpXaGVuIEkgZG8gJ2l3
IHNjYW4nLCBpdCBpcyBnb2luZyB0byBnZXQgc3R1Y2ssIGFuZCBJIGNhbiBvbmx5IHB1c2gNCnBv
d2VyIGJ1dHRvbiB0byB0dXJuIG9mZiBteSBsYXB0b3AuDQoNClBpbmctS2UNCg0KDQo=
