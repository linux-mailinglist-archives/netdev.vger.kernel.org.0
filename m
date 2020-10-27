Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9DB29A353
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504996AbgJ0D3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:29:13 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47487 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443825AbgJ0D3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 23:29:13 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09R3SrI52005632, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09R3SrI52005632
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Oct 2020 11:28:53 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.36) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 27 Oct 2020 11:28:52 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 27 Oct 2020 11:28:52 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Tue, 27 Oct 2020 11:28:52 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "WeitaoWang-oc@zhaoxin.com" <WeitaoWang-oc@zhaoxin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "CobeChen@zhaoxin.com" <CobeChen@zhaoxin.com>,
        "tonywwang@zhaoxin.com" <tonywwang@zhaoxin.com>,
        "weitaowang@zhaoxin.com" <weitaowang@zhaoxin.com>,
        "TimGuo@zhaoxin.com" <TimGuo@zhaoxin.com>,
        "wwt8723@163.com" <wwt8723@163.com>
Subject: Re: [PATCH] rtlwifi: Fix non-canonical address access issues
Thread-Topic: [PATCH] rtlwifi: Fix non-canonical address access issues
Thread-Index: AQHWrA+S0JbIDKfd1Ee3HJBnxIpYYKmqRCSA
Date:   Tue, 27 Oct 2020 03:28:52 +0000
Message-ID: <1603769287.14269.0.camel@realtek.com>
References: <1603768580-2798-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
In-Reply-To: <1603768580-2798-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.1.1]
Content-Type: text/plain; charset="utf-8"
Content-ID: <62F3B27AEA3BDF4FAF41F96C09BE7D5D@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTI3IGF0IDExOjE2ICswODAwLCBXZWl0YW9XYW5nb2Mgd3JvdGU6DQo+
IER1cmluZyByZWFsdGVrIFVTQiB3aXJlbGVzcyBOSUMgaW5pdGlhbGl6YXRpb24sIGl0J3MgdW5l
eHBlY3RlZA0KPiBkaXNjb25uZWN0aW9uIHdpbGwgY2F1c2UgdXJiIHN1bWJtaXQgZmFpbC4gT24g
dGhlIG9uZSBoYW5kLA0KPiBfcnRsX3VzYl9jbGVhbnVwX3J4IHdpbGwgYmUgY2FsbGVkIHRvIGNs
ZWFuIHVwIHJ4IHN0dWZmLCBlc3BlY2lhbGx5IGZvcg0KPiBydGxfd3EuIE9uIHRoZSBvdGhlciBo
YW5kLCBkaXNjb25uZWN0aW9uIHdpbGwgY2F1c2UgcnRsX3VzYl9kaXNjb25uZWN0DQo+IGFuZCBf
cnRsX3VzYl9jbGVhbnVwX3J4IHRvIGJlIGNhbGxlZC4gU28sIHJ0bF93cSB3aWxsIGJlIGZsdXNo
L2Rlc3Ryb3kNCj4gdHdpY2UsIHdoaWNoIHdpbGwgY2F1c2Ugbm9uLWNhbm9uaWNhbCBhZGRyZXNz
IDB4ZGVhZDAwMDAwMDAwMDEyMiBhY2Nlc3MNCj4gYW5kIGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVs
dC4NCj4gDQo+IEZpeGVkIHRoaXMgaXNzdWUgYnkgcmVtb3ZlIF9ydGxfdXNiX2NsZWFudXBfcngg
d2hlbiB1cmIgc3VtYm1pdCBmYWlsLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogV2VpdGFvV2FuZ29j
IDxXZWl0YW9XYW5nLW9jQHpoYW94aW4uY29tPg0KDQpUaGFua3MgZm9yIHlvdXIgcGF0Y2guDQoN
CkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KPiAtLS0NCj4g
wqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvdXNiLmMgfCAxIC0NCj4gwqAx
IGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS91c2IuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS91c2IuYw0KPiBpbmRleCAwNmUwNzNkLi5kNjJiODdmIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvdXNiLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3VzYi5jDQo+IEBAIC03
MzEsNyArNzMxLDYgQEAgc3RhdGljIGludCBfcnRsX3VzYl9yZWNlaXZlKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3KQ0KPiDCoA0KPiDCoGVycl9vdXQ6DQo+IMKgCXVzYl9raWxsX2FuY2hvcmVkX3Vy
YnMoJnJ0bHVzYi0+cnhfc3VibWl0dGVkKTsNCj4gLQlfcnRsX3VzYl9jbGVhbnVwX3J4KGh3KTsN
Cj4gwqAJcmV0dXJuIGVycjsNCj4gwqB9DQo+IMKgDQo=
