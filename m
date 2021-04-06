Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84D1354E55
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhDFINb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:13:31 -0400
Received: from smtpout6.r2.mail-out.ovh.net ([54.36.141.6]:45989 "EHLO
        smtpout6.r2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232131AbhDFIN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:13:28 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 04:13:27 EDT
Received: from ex2.mail.ovh.net (unknown [10.108.16.119])
        by mo511.mail-out.ovh.net (Postfix) with ESMTPS id C1F951328A5C2
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 10:07:28 +0200 (CEST)
Received: from EX10.indiv2.local (172.16.2.10) by EX9.indiv2.local
 (172.16.2.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.2106.2; Tue, 6 Apr
 2021 10:07:28 +0200
Received: from EX10.indiv2.local ([fe80::62:7b97:e069:79e]) by
 EX10.indiv2.local ([fe80::62:7b97:e069:79e%13]) with mapi id 15.01.2106.013;
 Tue, 6 Apr 2021 10:07:28 +0200
From:   =?utf-8?B?Q2hyaXN0aWFuIFDDtnNzaW5nZXI=?= <christian@poessinger.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: iproute2 ERSPAN version 2 JSON output shows valueless key
Thread-Topic: iproute2 ERSPAN version 2 JSON output shows valueless key
Thread-Index: Adcqu+Gmk9XhWFtSTZyDpyxwJOKrWg==
Date:   Tue, 6 Apr 2021 08:07:28 +0000
Message-ID: <3ac544c09842410fb863b332917a03ad@poessinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [84.167.156.165]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Ovh-Tracer-Id: 1639310268003815839
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudejgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvufhtfffkihgtgfggsehtsghjtddttdejnecuhfhrohhmpeevhhhrihhsthhirghnucfrnphsshhinhhgvghruceotghhrhhishhtihgrnhesphhovghsshhinhhgvghrrdgtohhmqeenucggtffrrghtthgvrhhnpeduhfdtudffgfeuieejheeugfehkedvhfehheevgffgjefhueeiiedvhedvtddutdenucfkpheptddrtddrtddrtddpkeegrdduieejrdduheeirdduieehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepvgigvddrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegthhhrihhsthhirghnsehpohgvshhsihhnghgvrhdrtghomhdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBNYWludGFpbmVycywNCg0KSSBhbSBuZXcgdG8gdGhlIHJlcG9ydGluZyBwcm9jZXNzIGZv
ciBpcHJvdXRlMiB0aHVzIHBsZWFzZSBiZWFyIHdpdGggbWUuDQoNCkkgYW0gcGxheWluZyBhcm91
bmQgd2l0aCBFUlNQQU4gdmVyc2lvbiAyIGFuZCBub3RpY2VkIGEgdmFsdWVsZXNzIGtleSBvbiB0
aGUNCkpTT04gb3V0cHV0IGZvciBpcHJvdXRlMi4gV2hlbiBjcmVhdGluZyBhbiBFUlNQQU4gaW50
ZXJmYWNlIHVzaW5nIHRoZSBmb2xsb3dpbmcNCmNvbW1hbmQ6DQoNCiQgaXAgbGluayBhZGQgZGV2
IG15ZXJzcGFuIHR5cGUgZXJzcGFuIHNlcSBrZXkgMzAgbG9jYWwgMTkyLjE2OC4xLjQgXA0KICBy
ZW1vdGUgMTkyLjE2OC4xLjEgZXJzcGFuX3ZlciAyIGVyc3Bhbl9kaXIgaW5ncmVzDQogICANClRo
ZSBpbnRlcmZhY2UgaXMgY3JlYXRlZCAtIGFzIGV4cGVjdGVkIC0gYW5kIGFsc28gdGhlIGluZm9y
bWF0aW9uIGNhbiBiZSByZWFkDQpiYWNrIGluICJodW1hbiByZWFkYWJsZSIgZm9ybWF0IGJ5Og0K
DQoNCiQgaXAgLWQgbGluayBzaG93IG15ZXJzcGFuDQoyMTE6IG15ZXJzcGFuQE5PTkU6IDxCUk9B
RENBU1QsTVVMVElDQVNUPiBtdHUgMTQ2MCBxZGlzYyBub29wIHN0YXRlIERPV04gbW9kZSBERUZB
VUxUDQogICAgZ3JvdXAgZGVmYXVsdCBxbGVuIDEwMDANCiAgICBsaW5rL2V0aGVyIGI2OmU1OjI4
Ojc4OmZhOjU0IGJyZCBmZjpmZjpmZjpmZjpmZjpmZiBwcm9taXNjdWl0eSAwIG1pbm10dSA2OCBt
YXhtdHUgMA0KICAgIGVyc3BhbiByZW1vdGUgMTkyLjE2OC4xLjEgbG9jYWwgMTkyLjE2OC4xLjQg
dHRsIGluaGVyaXQgaWtleSAwLjAuMC4zMCBva2V5DQoJMC4wLjAuMzAgaXNlcSBvc2VxIGVyc3Bh
bl92ZXIgMiBlcnNwYW5fZGlyIGluZ3Jlc3MgZXJzcGFuX2h3aWQgMCBhZGRyZ2VubW9kZQ0KCW5v
bmUgbnVtdHhxdWV1ZXMgMSBudW1yeHF1ZXVlcyAxIGdzb19tYXhfc2l6ZSA2NTUzNiBnc29fbWF4
X3NlZ3MgNjU1MzUNCg0KDQpUaGlzIHByb3BlciBsaXN0cyB0aGUga2V5L3ZhbHVlIHBhaXIgb2Yg
ImVyc3Bhbl9kaXIgaW5ncmVzcyIuDQoNCldoZW4gbm93IHN3aXRjaGluZyB0byBKU09OIG91dHB1
dCBtb2RlLCB0aGUgImVyc3Bhbl9kaXIiIGtleSB3b24ndCBoYXZlIGENCnZhbHVlLiBPdXRwdXQg
aGFzIGJlZW4gc3RyaXBwZWQgdG8gb25seSBjb250YWluIHRoZSByZWxldmFudCBrZXlzIGluIHRo
aXMgc3RydWN0dXJlOg0KDQokIGlwIC1kIC1qIGxpbmsgc2hvdyBteWVyc3Bhbg0KW3suLi4gImVy
c3Bhbl92ZXIiOjIsImVyc3Bhbl9kaXIiOiJlcnNwYW5faHdpZCI6IjAiIC4uLiB9XQ0KDQpCb3Ro
IGVyc3Bhbl92ZXIgYW5kIGVyc3Bhbl9od2lkIGFyZSBwb3B1bGF0ZWQgd2l0aCB0aGUgcHJvcGVy
IHZhbHVlcywgYnV0IA0KZXJzcGFuX2RpciBpcyBhIHZhbHVlbGVzcyBrZXkgd2hpY2ggd2lsbCBi
cmVhayBtb3N0IEpTT04gcGFyc2VzIChlLmcuIHRoZSBvbmUNCmZyb20gUHl0aG9uKQ0KDQpJIGhh
dmUgdGVzdGVkIHRoaXMgd2l0aCB0aGUgZm9sbG93aW5nIGlwcm91dGUyIHZlcnNpb25zOg0KDQpp
cHJvdXRlMi01LjExLjANCmlwcm91dGUyLTUuOS4wDQoNCklmIHlvdSBjYW4gcG9pbnQgbWUgdG8g
dGhlIGxvY2F0aW9uIHdoaWNoIGNvdWxkIGJlIHJlc3BvbnNpYmxlIGZvciB0aGlzIGlzc3VlLA0K
SSBhbSBoYXBweSB0byBzdWJtaXQgYSBmaXggdG8gdGhlIG5ldCB0cmVlLg0KDQpUaGFua3MgaW4g
YWR2YW5jZSwNCkNocmlzdGlhbiBQb2Vzc2luZ2VyDQo=
