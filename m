Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A3B424921
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbhJFVpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:45:11 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:59884 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhJFVpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:45:07 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 0DF028364F;
        Thu,  7 Oct 2021 10:43:12 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1633556592;
        bh=c/x9lTdYFQc/yL0JBGdByHJWdwq5ShRIb1SwnpnqYe4=;
        h=From:To:CC:Subject:Date;
        b=K8lRc2+vuzrLC8Jh47VGdjRI5pUBEaIaAXFnYP8MlqzoPYEM6O9wmgReOAvbaGnOb
         4uUtiul+FvuEygw7HmhD5VgUwgbrcHoO5Y6lsyTLuv5aUcoIzI8TbMWXDdfDL/Yv8O
         zYvnfbx2HzgoANXl+L691hYTaIKKCWOtCM/gmejBjSynSicrbic1bIN2U0nUFWPj/U
         WzUa8lmrsbNc9hkR6JTVvqMjzKn9ypubXUOLDy6i1lctIRVXPTvEbXPQtL9H2P3vTW
         r5Z7Phqz8y2goA0k2btIyKH0NVghChPrtdSsT679EyJ3QwCn6wbQQBIgIvzikzVBUJ
         Aig1EJMT+/Aew==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B615e186f0001>; Thu, 07 Oct 2021 10:43:11 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 7 Oct 2021 10:43:11 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.023; Thu, 7 Oct 2021 10:43:11 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: strace build error static assertion failed: "XFRM_MSG_MAPPING !=
 0x26"
Thread-Topic: strace build error static assertion failed: "XFRM_MSG_MAPPING !=
 0x26"
Thread-Index: AQHXuvsoJgvltmbs/UGg3CsocPOuZQ==
Date:   Wed, 6 Oct 2021 21:43:11 +0000
Message-ID: <1eb25b8f-09c0-8f5e-3227-f0f318785995@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2428DD897337064BBA8D485F172AC026@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=fKRHIqSe c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=8gfv0ekSlNoA:10 a=bO5IvOJKr4iox5V-56IA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCldoZW4gY29tcGlsaW5nIHN0cmFjZS01LjE0IChhbHRob3VnaCBpdCBsb29rcyBsaWtl
IHRoZSBzYW1lIHByb2JsZW0gDQp3b3VsZCBleGlzdCB3aXRoIGJsZWVkaW5nIGVkZ2Ugc3RyYWNl
KSB3aXRoIGhlYWRlcnMgZnJvbSB0aGUgdGlwIG9mIA0KTGludXMncyB0cmVlICg1LjE1LjAtcmM0
KSBJIGdldCB0aGUgZm9sbG93aW5nIGVycm9yDQoNCnN0cmFjZTogSW4gZmlsZSBpbmNsdWRlZCBm
cm9tIHN0YXRpY19hc3NlcnQuaDoxMSwNCnN0cmFjZTrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGZyb20gcHJpbnRfZmllbGRzLmg6MTIsDQpzdHJhY2U6wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBmcm9tIGRlZnMuaDoxOTAxLA0Kc3RyYWNlOsKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZnJvbSBuZXRsaW5rLmM6MTA6DQpzdHJhY2U6IHhsYXQv
bmxfeGZybV90eXBlcy5oOjE2MjoxOiBlcnJvcjogc3RhdGljIGFzc2VydGlvbiBmYWlsZWQ6IA0K
IlhGUk1fTVNHX01BUFBJTkcgIT0gMHgyNiINCnN0cmFjZTrCoCBzdGF0aWNfYXNzZXJ0KChYRlJN
X01TR19NQVBQSU5HKSA9PSAoMHgyNiksICJYRlJNX01TR19NQVBQSU5HIA0KIT0gMHgyNiIpOw0K
c3RyYWNlOsKgIF5+fn5+fn5+fn5+fn4NCg0KSXQgbG9va3MgbGlrZSBjb21taXQgMmQxNTFkMzkw
NzNhICgieGZybTogQWRkIHBvc3NpYmlsaXR5IHRvIHNldCB0aGUgDQpkZWZhdWx0IHRvIGJsb2Nr
IGlmIHdlIGhhdmUgbm8gcG9saWN5IikgYWRkZWQgc29tZSBYRlJNIG1lc3NhZ2VzIGFuZCB0aGUg
DQpudW1iZXJzIHNoaWZ0ZWQuIElzIHRoaXMgY29uc2lkZXJlZCBhbiBBQkkgYnJlYWthZ2U/DQoN
CkknbSBub3Qgc3VyZSBpZiB0aGlzIGlzIGEgc3RyYWNlIHByb2JsZW0gb3IgYSBsaW51eCBwcm9i
bGVtIHNvIEknbSANCnJlcG9ydGluZyBpdCBpbiBib3RoIHBsYWNlcy4NCg0KVGhhbmtzLA0KQ2hy
aXMNCg==
