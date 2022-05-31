Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B727538967
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 03:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiEaBIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 21:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiEaBIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 21:08:02 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF2644DE;
        Mon, 30 May 2022 18:08:00 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24V17bXV2031448, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24V17bXV2031448
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 31 May 2022 09:07:37 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 31 May 2022 09:07:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 31 May 2022 09:07:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Tue, 31 May 2022 09:07:36 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Thread-Topic: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Thread-Index: AQHYdDPI/ma2VkQlBE+TWL8Uknp8la03pxKA
Date:   Tue, 31 May 2022 01:07:36 +0000
Message-ID: <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
         <20220530135457.1104091-11-s.hauer@pengutronix.de>
In-Reply-To: <20220530135457.1104091-11-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.20.31]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMzAg5LiL5Y2IIDEwOjE3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D2C143BB3E8C14582EEC0B09CCBD37F@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA1LTMwIGF0IDE1OjU0ICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IFRoZSBwb3dlcnNhdmUgbW9kZXMgZG8gbm90IHdvcmsgd2l0aCBVU0IgZGV2aWNlcyAodGVzdGVk
IHdpdGggYQ0KPiBSVFc4ODIyQ1UpIHByb3Blcmx5LiBXaXRoIHBvd2Vyc2F2ZSBtb2RlcyBlbmFi
bGVkIHRoZSBkcml2ZXIgaXNzdWVzDQo+IG1lc3NhZ2VzIGxpa2U6DQo+IA0KPiBydHdfODgyMmN1
IDEtMToxLjI6IGZpcm13YXJlIGZhaWxlZCB0byBsZWF2ZSBscHMgc3RhdGUNCj4gcnR3Xzg4MjJj
dSAxLTE6MS4yOiB0aW1lZCBvdXQgdG8gZmx1c2ggcXVldWUgMw0KDQpDb3VsZCB5b3UgdHJ5IG1v
ZHVsZSBwYXJhbWV0ZXIgcnR3X2Rpc2FibGVfbHBzX2RlZXBfbW9kZT0xIHRvIHNlZQ0KaWYgaXQg
Y2FuIHdvcms/DQoNCklmIGl0IHdvcmtzLCBJIHN1Z2dlc3QgdG8gYXBwbHkgYmVsb3cgY29kZTog
DQoNCmRpZmYgLS1naXQgYS9tYWluLmMgYi9tYWluLmMNCmluZGV4IDNmN2E1ZDU0Li4zYmIwNzg5
OCAxMDA2NDQNCi0tLSBhL21haW4uYw0KKysrIGIvbWFpbi5jDQpAQCAtMTM0NSw2ICsxMzQ1LDkg
QEAgc3RhdGljIGVudW0gcnR3X2xwc19kZWVwX21vZGUgcnR3X3VwZGF0ZV9scHNfZGVlcF9tb2Rl
KHN0cnVjdCBydHdfZGV2ICpydHdkZXYsDQogew0KICAgICAgICBzdHJ1Y3QgcnR3X2NoaXBfaW5m
byAqY2hpcCA9IHJ0d2Rldi0+Y2hpcDsNCiANCisgICAgICAgaWYgKHJ0d19oY2lfdHlwZShydHdk
ZXYpID09IFJUV19IQ0lfVFlQRV9VU0IpDQorICAgICAgICAgICAgICAgcmV0dXJuIExQU19ERUVQ
X01PREVfTk9ORTsNCisNCiAgICAgICAgaWYgKHJ0d19kaXNhYmxlX2xwc19kZWVwX21vZGUgfHwg
IWNoaXAtPmxwc19kZWVwX21vZGVfc3VwcG9ydGVkIHx8DQogICAgICAgICAgICAhZnctPmZlYXR1
cmUpDQogICAgICAgICAgICAgICAgcmV0dXJuIExQU19ERUVQX01PREVfTk9ORTsNCg0KLS0NClBp
bmctS2UNCg0KDQo=
