Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16666322736
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhBWIpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 03:45:13 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38358 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbhBWIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 03:45:10 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11N8hxrN7002271, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11N8hxrN7002271
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 16:43:59 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 16:43:59 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::a98b:ac3a:714:c542]) by
 RTEXMBS04.realtek.com.tw ([fe80::a98b:ac3a:714:c542%6]) with mapi id
 15.01.2106.006; Tue, 23 Feb 2021 16:43:59 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        Timlee <timlee@realtek.com>,
        "zhanjun@uniontech.com" <zhanjun@uniontech.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "chenhaoa@uniontech.com" <chenhaoa@uniontech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
Thread-Topic: [PATCH v2] rtw88: 8822ce: fix wifi disconnect after S3/S4 on
 HONOR laptop
Thread-Index: AQHXCQAH7RfNyn4HvEexqF5ErvwOdKpj+arv//+MPYCAAc4+d///k8kA
Date:   Tue, 23 Feb 2021 08:43:59 +0000
Message-ID: <1614069836.8409.0.camel@realtek.com>
References: <20210222094638.18392-1-chenhaoa@uniontech.com>
         <87h7m4iefe.fsf@codeaurora.org> <1613993809.2331.12.camel@realtek.com>
         <878s7fi7m5.fsf@codeaurora.org>
In-Reply-To: <878s7fi7m5.fsf@codeaurora.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2CB4A50B810154DB6BCE4872FC157A3@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAyLTIzIGF0IDA5OjA4ICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBQ
a3NoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JpdGVzOg0KPiANCj4gPj4gPiAtLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJjZS5jDQo+ID4+ID4gKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyY2UuYw0KPiA+PiA+IEBA
IC0yNSw3ICsyNSw2IEBAIHN0YXRpYyBzdHJ1Y3QgcGNpX2RyaXZlciBydHdfODgyMmNlX2RyaXZl
ciA9IHsNCj4gPj4gPsKgwqAJLmlkX3RhYmxlID0gcnR3Xzg4MjJjZV9pZF90YWJsZSwNCj4gPj4g
PsKgwqAJLnByb2JlID0gcnR3X3BjaV9wcm9iZSwNCj4gPj4gPsKgwqAJLnJlbW92ZSA9IHJ0d19w
Y2lfcmVtb3ZlLA0KPiA+PiA+IC0JLmRyaXZlci5wbSA9ICZydHdfcG1fb3BzLA0KPiA+PsKgDQo+
ID4+IFdoeSBqdXN0IDg4MjJjZT8gV2h5IG5vdCByZW1vdmUgcnR3X3BtX29wcyBlbnRpcmVseSBp
ZiBpdCBqdXN0IGNyZWF0ZXMNCj4gPj4gcHJvYmxlbXM/DQo+ID4NCj4gPiBJIHRoaW5rIHdlIGNh
bid0IHJlbW92ZSBydHdfcG1fb3BzLCBiZWNhdXNlIHdvd2xhbiB3aWxsIG5vdCB3b3JrLg0KPiAN
Cj4gQWguIEEgY29tbWVudCBjb2RlIGluIHRoZSBjb2RlIHN0YXRpbmcgdGhhdCB3b3VsZCBiZSBu
aWNlLg0KPiANCg0KSSdsbCBkbyBpdC7CoA0KVGhhbmtzLg0K
