Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BB4544C9F
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 14:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244894AbiFIMw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 08:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiFIMw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 08:52:26 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452D017E13;
        Thu,  9 Jun 2022 05:52:23 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 259CpnrzF023806, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 259CpnrzF023806
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 9 Jun 2022 20:51:50 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 9 Jun 2022 20:51:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 9 Jun 2022 20:51:49 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Thu, 9 Jun 2022 20:51:49 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
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
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>
Subject: Re: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Thread-Topic: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Thread-Index: AQHYdDPI/ma2VkQlBE+TWL8Uknp8la03pxKAgABucQCADm9uAA==
Date:   Thu, 9 Jun 2022 12:51:49 +0000
Message-ID: <8443f8e51774a4f80fed494321fcc410e7174bf1.camel@realtek.com>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
         <20220530135457.1104091-11-s.hauer@pengutronix.de>
         <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
         <20220531074244.GN1615@pengutronix.de>
In-Reply-To: <20220531074244.GN1615@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [125.224.76.119]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzYvOSDkuIrljYggMTA6NTU6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <89046CFEA2994E40A02DFC7EC4D3F71E@realtek.com>
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

T24gVHVlLCAyMDIyLTA1LTMxIGF0IDA5OjQyICswMjAwLCBzLmhhdWVyQHBlbmd1dHJvbml4LmRl
IHdyb3RlOg0KPiBPbiBUdWUsIE1heSAzMSwgMjAyMiBhdCAwMTowNzozNkFNICswMDAwLCBQaW5n
LUtlIFNoaWggd3JvdGU6DQo+ID4gT24gTW9uLCAyMDIyLTA1LTMwIGF0IDE1OjU0ICswMjAwLCBT
YXNjaGEgSGF1ZXIgd3JvdGU6DQo+ID4gPiBUaGUgcG93ZXJzYXZlIG1vZGVzIGRvIG5vdCB3b3Jr
IHdpdGggVVNCIGRldmljZXMgKHRlc3RlZCB3aXRoIGENCj4gPiA+IFJUVzg4MjJDVSkgcHJvcGVy
bHkuIFdpdGggcG93ZXJzYXZlIG1vZGVzIGVuYWJsZWQgdGhlIGRyaXZlciBpc3N1ZXMNCj4gPiA+
IG1lc3NhZ2VzIGxpa2U6DQo+ID4gPiANCj4gPiA+IHJ0d184ODIyY3UgMS0xOjEuMjogZmlybXdh
cmUgZmFpbGVkIHRvIGxlYXZlIGxwcyBzdGF0ZQ0KPiA+ID4gcnR3Xzg4MjJjdSAxLTE6MS4yOiB0
aW1lZCBvdXQgdG8gZmx1c2ggcXVldWUgMw0KPiA+IA0KPiA+IENvdWxkIHlvdSB0cnkgbW9kdWxl
IHBhcmFtZXRlciBydHdfZGlzYWJsZV9scHNfZGVlcF9tb2RlPTEgdG8gc2VlDQo+ID4gaWYgaXQg
Y2FuIHdvcms/DQo+IA0KPiBObywgdGhpcyBtb2R1bGUgcGFyYW1ldGVyIGRvZXNuJ3Qgc2VlbSB0
byBtYWtlIGFueSBkaWZmZXJlbmNlLg0KPiANCj4gIyBjYXQgL3N5cy9tb2R1bGUvcnR3ODhfY29y
ZS9wYXJhbWV0ZXJzL2Rpc2FibGVfbHBzX2RlZXANCj4gWQ0KPiANCj4gU3RpbGwgImZpcm13YXJl
IGZhaWxlZCB0byBsZWF2ZSBscHMgc3RhdGUiIGFuZCBwb29yIHBlcmZvcm1hbmNlLg0KPiANCj4g
QW55IG90aGVyIGlkZWFzIHdoYXQgbWF5IGdvIHdyb25nIGhlcmU/DQo+IA0KDQpUb2RheSwgSSBi
b3Jyb3cgYSA4ODIyY3UsIGFuZCB1c2UgeW91ciBwYXRjaHNldCBidXQgcmV2ZXJ0DQpwYXRjaCAx
MC8xMCB0byByZXByb2R1Y2UgdGhpcyBpc3N1ZS4gV2l0aCBmaXJtd2FyZSA3LjMuMCwNCml0IGxv
b2tzIGJhZC4gQWZ0ZXIgY2hlY2tpbmcgc29tZXRoaW5nIGFib3V0IGZpcm13YXJlLCBJDQpmb3Vu
ZCB0aGUgZmlybXdhcmUgaXMgb2xkLCBzbyB1cGdyYWRlIHRvIDkuOS4xMSwgYW5kIHRoZW4NCml0
IHdvcmtzIHdlbGwgZm9yIDEwIG1pbnV0ZXMsIG5vIGFibm9ybWFsIG1lc3NhZ2VzLg0KDQpQbGVh
c2UgdHJ5IGlmIGl0IGFsc28gd29ya3MgdG8geW91Lg0KDQpQaW5nLUtlDQoNCg0K
