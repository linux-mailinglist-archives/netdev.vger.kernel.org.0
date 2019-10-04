Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC4CB372
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 05:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbfJDDK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 23:10:29 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:54700 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbfJDDK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 23:10:28 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x943AHZx023329, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x943AHZx023329
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Oct 2019 11:10:17 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Fri, 4 Oct 2019 11:10:16 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "zhengbin13@huawei.com" <zhengbin13@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Thread-Topic: [PATCH v2] rtlwifi: rtl8192ee: Remove set but not used
 variable 'err'
Thread-Index: AQHVelyPBV9gOxQgBk6ZEuGNsgYqX6dJR6gA
Date:   Fri, 4 Oct 2019 03:10:15 +0000
Message-ID: <1570158616.3603.1.camel@realtek.com>
References: <2ca176f2-e9ef-87cd-7f7d-cd51c67da38b@huawei.com>
In-Reply-To: <2ca176f2-e9ef-87cd-7f7d-cd51c67da38b@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <36AA4F202D83474496CDA9A0445FAFE9@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDEwOjM2ICswODAwLCB6aGVuZ2JpbiAoQSkgd3JvdGU6DQo+
IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZWUvZncuYzogSW4gZnVu
Y3Rpb24NCj4gcnRsOTJlZV9kb3dubG9hZF9mdzoNCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3J0bDgxOTJlZS9mdy5jOjExMTo2OiB3YXJuaW5nOiB2YXJpYWJsZQ0KPiBl
cnIgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4gDQo+IFJl
cG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogemhlbmdiaW4gPHpoZW5nYmluMTNAaHVhd2VpLmNvbT4NCg0KTG9va3MgZ29vZCB0byBtZS4g
VGhhbmsgeW91LsKgDQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNv
bT4NCg0KDQo=
