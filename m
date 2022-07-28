Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294F45839F2
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbiG1IAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiG1IAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:00:08 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FCEE61721
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:00:05 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26S7xfU13023463, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26S7xfU13023463
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 28 Jul 2022 15:59:41 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 28 Jul 2022 15:59:47 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Jul 2022 15:59:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Thu, 28 Jul 2022 15:59:47 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Oliver Neukum <oneukum@suse.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: question on MAC passthrough and multiple devices in r8152
Thread-Topic: question on MAC passthrough and multiple devices in r8152
Thread-Index: AQHYoabj7AcQFW0O+kKxHgRSgFnG8a2TZjhw
Date:   Thu, 28 Jul 2022 07:59:47 +0000
Message-ID: <837bd96f9d574d3db0a4b71a9a8761a8@realtek.com>
References: <444df45c-ec1d-62a6-eea8-44a0635b2fdf@suse.com>
In-Reply-To: <444df45c-ec1d-62a6-eea8-44a0635b2fdf@suse.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzcvMjgg5LiK5Y2IIDAzOjM3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKdWx5
IDI3LCAyMDIyIDY6NTIgUE0NCj4gVG86IEhheWVzIFdhbmcgPGhheWVzd2FuZ0ByZWFsdGVrLmNv
bT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogcXVlc3Rpb24gb24g
TUFDIHBhc3N0aHJvdWdoIGFuZCBtdWx0aXBsZSBkZXZpY2VzIGluIHI4MTUyDQo+IA0KPiBIaSwN
Cj4gDQo+IEkgYW0gbG9va2luZyBhdCB0aGUgbG9naWMgdGhlIHI4MTUyIGRyaXZlciB1c2VzIHRv
DQo+IGFzc2lnbiBhIHBhc3MgdGhyb3VnaCBNQUMgYW5kIEkgZG8gbm90IHVuZGVyc3RhbmQgaG93
DQo+IHlvdSBtYWtlIHN1cmUgdGhhdCBpdCBpcyBwYXNzZWQgdG8gb25lIGRldmljZSBvbmx5Lg0K
PiBBcyBmYXIgYXMgSSBjYW4gc2VlIHRoZSBNQUMgY29tZXMgZnJvbSBhbiBBQ1BJIG9iamVjdCwN
Cj4gaGVuY2UgdGhlIGRyaXZlciB3aWxsIGhhcHBpbHkgcmVhZCBpdCBvdXQgYW5kIGFzc2lnbg0K
PiBpdCBtdWx0aXBsZSB0aW1lcy4gQW0gSSBvdmVybG9va2luZyBzb21ldGhpbmc/DQoNCllvdSBh
cmUgcmlnaHQuIEFuZCwgdGhlIHBhdGNoZXMgYXJlIG5vdCBzdWJtaXR0ZWQgYnkgbWUuDQpBcyBm
YXIgYXMgSSBrbm93LCBvdXIgY3VzdG9tZXJzIGRvbid0IGNhcmUgdGhlIHNpdHVhdGlvbi4NClRo
ZXkgd291bGQgcHJvdmlkZSB0aGUgZ3VpZGUgdG8gZGVzY3JpYmUgaXQuIEJlc2lkZXMsIHRoZQ0K
ZmVhdHVyZSBjb3VsZCBiZSBkaXNhYmxlZCB0aHJvdWdoIEJJT1MuDQoNCkluIGFkZGl0aW9uLCB0
aGUgRGVsbCBsaW1pdHMgdGhlIHNwZWNpZmljIGRldmljZXMgdG8NCnVzZSB0aGUgZmVhdHVyZSBv
ZiBNQUMgcGFzc3Rocm91Z2guIEl0IGNvdWxkIHJlZHVjZSBzdWNoDQpzaXR1YXRpb24uDQoNCkJl
c3QgUmVnYXJkcywNCkhheWVzDQoNCg==
