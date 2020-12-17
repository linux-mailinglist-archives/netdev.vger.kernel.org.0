Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691362DCA35
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgLQA4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:56:12 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40697 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgLQA4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 19:56:12 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0BH0tCqzD015933, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0BH0tCqzD015933
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Dec 2020 08:55:12 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 17 Dec 2020 08:55:12 +0800
Received: from RTEXDAG02.realtek.com.tw ([fe80::89de:3ef2:d607:5db5]) by
 RTEXDAG02.realtek.com.tw ([fe80::89de:3ef2:d607:5db5%10]) with mapi id
 15.01.2106.004; Thu, 17 Dec 2020 08:55:12 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "zhengyongjun3@huawei.com" <zhengyongjun3@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH wireless -next] rtw88: Delete useless kfree code
Thread-Topic: [PATCH wireless -next] rtw88: Delete useless kfree code
Thread-Index: AQHW06wufMk6AY6elEmDiuhimIySVan58QiA
Date:   Thu, 17 Dec 2020 00:55:12 +0000
Message-ID: <1608166499.2560.0.camel@realtek.com>
References: <20201216130442.13869-1-zhengyongjun3@huawei.com>
In-Reply-To: <20201216130442.13869-1-zhengyongjun3@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD0CF813C7FD8447A8AAD43163028802@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTEyLTE2IGF0IDEzOjA0ICswMDAwLCBaaGVuZyBZb25nanVuIHdyb3RlOg0K
PiBUaGUgcGFyYW1ldGVyIG9mIGtmcmVlIGZ1bmN0aW9uIGlzIE5VTEwsIHNvIGtmcmVlIGNvZGUg
aXMgdXNlbGVzcywgZGVsZXRlIGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1
biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxw
a3NoaWhAcmVhbHRlay5jb20+DQoNCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9tYWluLmMgfCAxIC0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
bWFpbi5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9tYWluLmMNCj4g
aW5kZXggNTY1ZWZkODgwNjI0Li4xNTU2OGNkNjcwYTMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5jDQo+IEBAIC0xMjQ5LDcgKzEyNDksNiBAQCBzdGF0
aWMgdm9pZCBydHdfc2V0X3N1cHBvcnRlZF9iYW5kKHN0cnVjdCBpZWVlODAyMTFfaHcNCj4gKmh3
LA0KPiDCoA0KPiDCoGVycl9vdXQ6DQo+IMKgCXJ0d19lcnIocnR3ZGV2LCAiZmFpbGVkIHRvIHNl
dCBzdXBwb3J0ZWQgYmFuZFxuIik7DQo+IC0Ja2ZyZWUoc2JhbmQpOw0KPiDCoH0NCj4gwqANCj4g
wqBzdGF0aWMgdm9pZCBydHdfdW5zZXRfc3VwcG9ydGVkX2JhbmQoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsDQoNCg0K
