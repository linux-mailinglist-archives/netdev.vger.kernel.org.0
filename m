Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C530E1965
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 13:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405130AbfJWLxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 07:53:14 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:36377 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732092AbfJWLxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 07:53:14 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9NBqkls003476, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9NBqkls003476
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 23 Oct 2019 19:52:46 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Wed, 23 Oct
 2019 19:52:45 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: RE: [PATCH net-next] r8152: support request_firmware for RTL8153
Thread-Topic: [PATCH net-next] r8152: support request_firmware for RTL8153
Thread-Index: AQHVg84yG1svvwJLbEa5ZZ4zq0Zj+qdnd3YAgACNnOD//4TeAIAAm7jA
Date:   Wed, 23 Oct 2019 11:52:45 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18ED47C@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-329-Taiwan-albertk@realtek.com>
        <CGME20191023091648eucas1p12dcc4e9041169e3c7ae43f4ea525dd7f@eucas1p1.samsung.com>
        <44261242-ff44-0067-bbb9-2241e400ad53@samsung.com>
        <0835B3720019904CB8F7AA43166CEEB2F18ED3FA@RTITMBSVM03.realtek.com.tw>
 <c20abd08-5f22-2cc8-15fa-956d06b5b8af@samsung.com>
In-Reply-To: <c20abd08-5f22-2cc8-15fa-956d06b5b8af@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFyZWsgU3p5cHJvd3NraSBbbWFpbHRvOm0uc3p5cHJvd3NraUBzYW1zdW5nLmNvbV0NCj4gU2Vu
dDogV2VkbmVzZGF5LCBPY3RvYmVyIDIzLCAyMDE5IDY6MjMgUE0NClsuLi5dDQo+ID4+IFRoaXMg
cGF0Y2ggKHdoaWNoIGxhbmRlZCBpbiBsaW51eC1uZXh0IGxhc3QgZGF5cykgY2F1c2VzIGEgZm9s
bG93aW5nDQo+ID4+IGtlcm5lbCBvb3BzIG9uIHRoZSBBUk0gMzJiaXQgRXh5bm9zNTQyMiBTb0Mg
YmFzZWQgT2Ryb2lkIFhVNCBib2FyZDoNCj4gPiBQbGVhc2UgdHJ5IHRoZSBmb2xsb3dpbmcgcGF0
Y2guDQo+IA0KPiBZZXMsIHRoaXMgZml4ZXMgdGhlIGlzc3VlLiBJJ3ZlIGFwcGxpZWQgdGhvc2Ug
Y2hhbmdlcyBtYW51YWxseSBvbiB0b3Agb2YNCj4gTGludXggbmV4dC0yMDE5MTAyMiwgZHVlIHRv
IHNvbWUgZGlmZmVyZW5jZXMgaW4gdGhlIGNvbnRleHQuIFdoZW4geW91DQo+IHByZXBhcmUgYSBm
aW5hbCBwYXRjaCwgZmVlbCBmcmVlIHRvIGFkZDoNCj4gDQo+IFJlcG9ydGVkLWJ5OiBNYXJlayBT
enlwcm93c2tpIDxtLnN6eXByb3dza2lAc2Ftc3VuZy5jb20+DQo+IEZpeGVzOiA5MzcwZjJkMDVh
MmEgKCJyODE1Mjogc3VwcG9ydCByZXF1ZXN0X2Zpcm13YXJlIGZvciBSVEw4MTUzIikNCj4gVGVz
dGVkLWJ5OiBNYXJlayBTenlwcm93c2tpIDxtLnN6eXByb3dza2lAc2Ftc3VuZy5jb20+DQoNClRo
YW5rcw0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQoNCg0K
