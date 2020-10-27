Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587FB29A239
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437798AbgJ0B3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:29:54 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50778 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410547AbgJ0B3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 21:29:54 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09R1TJrtC025293, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09R1TJrtC025293
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Oct 2020 09:29:19 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 27 Oct 2020 09:29:19 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 27 Oct 2020 09:29:18 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Tue, 27 Oct 2020 09:29:18 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@kernel.org" <arnd@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "saurav.girepunje@gmail.com" <saurav.girepunje@gmail.com>,
        "zhengbin13@huawei.com" <zhengbin13@huawei.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 06/11] rtlwifi: fix -Wpointer-sign warning
Thread-Topic: [PATCH net-next 06/11] rtlwifi: fix -Wpointer-sign warning
Thread-Index: AQHWq9+Tm3vvNpn170mPpXALIlujyamqIxyA
Date:   Tue, 27 Oct 2020 01:29:18 +0000
Message-ID: <1603762113.2765.1.camel@realtek.com>
References: <20201026213040.3889546-1-arnd@kernel.org>
         <20201026213040.3889546-6-arnd@kernel.org>
In-Reply-To: <20201026213040.3889546-6-arnd@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E56EB1C0789D88419866E78DD4B37A86@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTI2IGF0IDIyOjI5ICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiANCj4gVGhlcmUgYXJlIHRo
b3VzYW5kcyBvZiB3YXJuaW5ncyBpbiBhIFc9MiBidWlsZCBmcm9tIGp1c3Qgb25lIGZpbGU6DQo+
IA0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgyMWFlL3RhYmxl
LmM6Mzc4ODoxNTogd2FybmluZzoNCj4gcG9pbnRlciB0YXJnZXRzIGluIGluaXRpYWxpemF0aW9u
IG9mICd1OCAqJyB7YWthICd1bnNpZ25lZCBjaGFyIConfSBmcm9tICdjaGFyDQo+IConIGRpZmZl
ciBpbiBzaWduZWRuZXNzIFstV3BvaW50ZXItc2lnbl0NCj4gDQo+IENoYW5nZSB0aGUgdHlwZXMg
dG8gY29uc2lzdGVudGx5IHVzZSAnY29uc3QgY2hhciAqJyBmb3IgdGhlDQo+IHN0cmluZ3MuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KDQpBY2tl
ZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCj4gLS0tDQo+IMKgLi4u
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4ODIxYWUvcGh5LmPCoMKgfCA4MSArKysrKysr
KysrLS0tLS0tLS0tDQo+IMKgLi4uL3JlYWx0ZWsvcnRsd2lmaS9ydGw4ODIxYWUvdGFibGUuY8Kg
wqDCoMKgwqDCoMKgwqDCoHzCoMKgNCArLQ0KPiDCoC4uLi9yZWFsdGVrL3J0bHdpZmkvcnRsODgy
MWFlL3RhYmxlLmjCoMKgwqDCoMKgwqDCoMKgwqB8wqDCoDQgKy0NCj4gwqAzIGZpbGVzIGNoYW5n
ZWQsIDQ1IGluc2VydGlvbnMoKyksIDQ0IGRlbGV0aW9ucygtKQ0KPiANCg0KW3NuaXBdDQoNCg0K
DQoNCg==
