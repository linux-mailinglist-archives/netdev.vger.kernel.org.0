Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EB2659361
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 00:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiL2Xrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 18:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbiL2Xru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 18:47:50 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B1F89590;
        Thu, 29 Dec 2022 15:47:48 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BTNkVNp9026558, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BTNkVNp9026558
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 30 Dec 2022 07:46:31 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 30 Dec 2022 07:47:25 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 30 Dec 2022 07:47:25 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 30 Dec 2022 07:47:25 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZG4P3zjPChgp7d0KhVH0EqXLg7a6FApoA
Date:   Thu, 29 Dec 2022 23:47:25 +0000
Message-ID: <deb574a080e603e9dd5eee36c1a3fe7c88588d59.camel@realtek.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
         <20221229124845.1155429-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221229124845.1155429-2-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.22.50]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI5IOS4i+WNiCAwNzozNDowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC259354C82C7E4CAC123BB7FBA59E4E@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTI5IGF0IDEzOjQ4ICswMTAwLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBUaGUgZUZ1c2UgZGVmaW5pdGlvbnMgaW4gdGhlIHJ0dzg4IGFyZSB1c2luZyBzdHJ1
Y3RzIHRvIGRlc2NyaWJlIHRoZQ0KPiBlRnVzZSBjb250ZW50cy4gQWRkIHRoZSBwYWNrZWQgYXR0
cmlidXRlIHRvIGFsbCBzdHJ1Y3RzIHVzZWQgZm9yIHRoZQ0KPiBlRnVzZSBkZXNjcmlwdGlvbiBz
byB0aGUgY29tcGlsZXIgZG9lc24ndCBhZGQgZ2FwcyBvciByZS1vcmRlcg0KPiBhdHRyaWJ1dGVz
Lg0KPiANCj4gQWxzbyBzcGxpdCB0aGUgcmVzMiBlRnVzZSBmaWVsZCAod2hpY2ggZm9yIHNvbWUg
cmVhc29uIGhhcyBwYXJ0cyBvZiBpdCdzDQo+IGRhdGEgaW4gdHdvIHNlcGFyYXRlIHU4IGZpZWxk
cykgdG8gYXZvaWQgdGhlIGZvbGxvd2luZyB3YXJuaW5nLCBub3cgdGhhdA0KPiB0aGVpciBzdXJy
b3VuZGluZyBzdHJ1Y3QgaGFzIHRoZSBwYWNrZWQgYXR0cmlidXRlOg0KPiAgIG5vdGU6IG9mZnNl
dCBvZiBwYWNrZWQgYml0LWZpZWxkICdyZXMyJyBoYXMgY2hhbmdlZCBpbiBHQ0MgNC40DQo+IA0K
PiBGaXhlczogZTMwMzc0ODVjNjhlICgicnR3ODg6IG5ldyBSZWFsdGVrIDgwMi4xMWFjIGRyaXZl
ciIpDQo+IEZpeGVzOiBhYjBhMDMxZWNmMjkgKCJydHc4ODogODcyM2Q6IEFkZCByZWFkX2VmdXNl
IHRvIHJlY29nbml6ZSBlZnVzZSBpbmZvIGZyb20gbWFwIikNCj4gRml4ZXM6IDc2OWEyOWNlMmFm
NCAoInJ0dzg4OiA4ODIxYzogYWRkIGJhc2ljIGZ1bmN0aW9ucyIpDQo+IEZpeGVzOiA4N2NhZWVm
MDMyZmMgKCJ3aWZpOiBydHc4ODogQWRkIHJ0dzg3MjNkdSBjaGlwc2V0IHN1cHBvcnQiKQ0KPiBG
aXhlczogYWZmNWZmZDcxOGRlICgid2lmaTogcnR3ODg6IEFkZCBydHc4ODIxY3UgY2hpcHNldCBz
dXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogTWFydGluIEJsdW1lbnN0aW5nbCA8bWFydGluLmJs
dW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFBpbmctS2UgU2hpaCA8
cGtzaGloQHJlYWx0ZWsuY29tPg0KDQpUaGFua3MgZm9yIHlvdXIgd29yayENCg0KDQo=
