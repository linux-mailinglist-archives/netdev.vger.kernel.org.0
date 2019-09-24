Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE828BBFA9
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 03:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392439AbfIXBWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 21:22:10 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51659 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388676AbfIXBWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 21:22:10 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x8O1Luxj008608, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x8O1Luxj008608
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 09:21:56 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 24 Sep
 2019 09:21:56 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Austin Kim <austindh.kim@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable
Thread-Topic: [PATCH] rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable
Thread-Index: AQHVbSQ/IoCU1aThcEGdzSMbu8vWrqc4xuaAgAFKO8A=
Date:   Tue, 24 Sep 2019 01:21:55 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C7088F@RTITMBSVM04.realtek.com.tw>
References: <20190917065044.GA173797@LGEARND20B15>
 <CADLLry5b1RDjXX8Dbc4ebbZOFFaAd0wc3rDCaD-V9RBwrpNyMA@mail.gmail.com>
In-Reply-To: <CADLLry5b1RDjXX8Dbc4ebbZOFFaAd0wc3rDCaD-V9RBwrpNyMA@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEF1c3RpbiBLaW0gW21haWx0
bzphdXN0aW5kaC5raW1AZ21haWwuY29tXQ0KPiBTZW50OiBNb25kYXksIFNlcHRlbWJlciAyMywg
MjAxOSA5OjM1IFBNDQo+IFRvOiBQa3NoaWg7IGt2YWxvQGNvZGVhdXJvcmEub3JnOyBkYXZlbUBk
YXZlbWxvZnQubmV0DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogUmU6IFtQQVRDSF0gcnRsd2lmaTogcnRsODcyM2FlOiBSZW1vdmUgdW51c2VkICdydHN0YXR1
cycgdmFyaWFibGUNCj4gDQo+IEhlbGxvLCBNYWludGFpbmVycy4uLg0KPiBXb3VsZCB5b3UgcGxl
YXNlIHJldmlldyBhYm92ZSBwYXRjaCBpZiB5b3UgYXJlIGF2YWlsYWJsZT8NCj4gDQoNCllvdSBj
YW4gY2hlY2sgc3RhdHVzIG9mIHlvdXIgcGF0Y2ggaGVyZQ0KaHR0cHM6Ly9wYXRjaHdvcmsua2Vy
bmVsLm9yZy9wcm9qZWN0L2xpbnV4LXdpcmVsZXNzL2xpc3QvP3Nlcmllcz0xNzQ4NTkNCklmIHlv
dXIgcGF0Y2ggaXMgZXhpc3RpbmcgaW4gcGF0Y2h3b3JrLCBtYWludGFpbmVyIGRvZXNuJ3QgZm9y
Z2V0IGl0Lg0KDQpBbm90aGVyIHRoaW5nIGlzIHRvIGF2b2lkIHRvcCBwb3N0aW5nIHRoYXQgbWFr
ZXMgbWFpbnRhaW5lciBoYXJkIHRvIHJlYWQgbWFpbC4NCg0KLS0tDQpQSw0KDQo=
