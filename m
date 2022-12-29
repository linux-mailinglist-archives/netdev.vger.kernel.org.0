Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE626658C22
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 12:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiL2LYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 06:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiL2LYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 06:24:36 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE6286174;
        Thu, 29 Dec 2022 03:24:34 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BTBNRL10019938, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BTBNRL10019938
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 19:23:27 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 29 Dec 2022 19:24:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 19:24:21 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 19:24:21 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
CC:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "macroalpha82@gmail.com" <macroalpha82@gmail.com>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "nitin.gupta981@gmail.com" <nitin.gupta981@gmail.com>
Subject: Re: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics in the power on sequence
Thread-Topic: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics
 in the power on sequence
Thread-Index: AQHZGktC3vnvtmQgSkm40YvvOQDovq6ECyLwgAAgvYCAAAmQAA==
Date:   Thu, 29 Dec 2022 11:24:20 +0000
Message-ID: <97a2efacecd6d6bb7add6e227a68f7d9e1ed9d0b.camel@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
         <20221227233020.284266-14-martin.blumenstingl@googlemail.com>
         <b30273c693fd4868873d9bf4a1b5c0ca@realtek.com>
         <CAFBinCAzmgwRAzAbXM17nmPw0bo9Mzx6gQQQrR3tPDb+n2jDHA@mail.gmail.com>
In-Reply-To: <CAFBinCAzmgwRAzAbXM17nmPw0bo9Mzx6gQQQrR3tPDb+n2jDHA@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.22.50]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI5IOS4iuWNiCAwNzoyNTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD1688A5F4D2034585A1C182CFEF7173@realtek.com>
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

T24gVGh1LCAyMDIyLTEyLTI5IGF0IDExOjQ5ICswMTAwLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBIaSBQaW5nLUtlLA0KPiANCj4gT24gVGh1LCBEZWMgMjksIDIwMjIgYXQgMjoxNSBB
TSBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+ID4g
PiArICAgICAgICAgICAgIGlmIChydHdfc2Rpb19pc19zZGlvMzBfc3VwcG9ydGVkKHJ0d2Rldikp
DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgcnR3X3dyaXRlOF9zZXQocnR3ZGV2LCBSRUdf
SENJX09QVF9DVFJMICsgMiwgQklUKDIpKTsNCj4gPiANCj4gPiBCSVRfVVNCX0xQTV9BQ1RfRU4g
QklUKDEwKSAgIC8vIHJlZ19hZGRyICsyLCBzbyBiaXQgPj4gOA0KPiBUaGUgb25lcyBhYm92ZSBh
cmUgY2xlYXIgdG8gbWUsIHRoYW5rIHlvdS4NCj4gQnV0IGZvciB0aGlzIG9uZSBJIGhhdmUgYSBx
dWVzdGlvbjogZG9uJ3Qgd2UgbmVlZCBCSVQoMTgpIGZvciB0aGlzIG9uZQ0KPiBhbmQgdGhlbiBi
aXQgPj4gMTY/DQo+IHJlZ19hZGRyICsgMDogYml0cyAwLi43DQo+IHJlZ19hZGRyICsgMTogYml0
cyA4Li4xNQ0KPiByZWdfYWRkciArIDI6IGJpdHMgMTYuLjIzDQo+IA0KPiANCg0KU29ycnksIG15
IG1pc3Rha2VzLg0KDQpJdCBzaG91bGQgYmUgICJCSVRfU0RJT19QQURfRTUgQklUKDE4KSIgYW5k
ID4+IDE2Lg0KDQotLQ0KUGluZy1LZQ0KDQo=
