Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA74B9502
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 01:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiBQA0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 19:26:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiBQA0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 19:26:18 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248CB2AA3A5;
        Wed, 16 Feb 2022 16:26:02 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 21H0PmYF2001412, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 21H0PmYF2001412
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Feb 2022 08:25:48 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 08:25:47 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 16:25:47 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Thu, 17 Feb 2022 08:25:47 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH][next] tw89: core.h: Replace zero-length array with flexible-array member
Thread-Topic: [PATCH][next] tw89: core.h: Replace zero-length array with
 flexible-array member
Thread-Index: AQHYI21xs7IWblHw1kuwBXNwuuxMCKyWHIIAgADGQ2A=
Date:   Thu, 17 Feb 2022 00:25:47 +0000
Message-ID: <36638534535441fb8faf587305acfa78@realtek.com>
References: <20220216195047.GA904198@embeddedor>
 <202202161235.0C91ED227@keescook>
In-Reply-To: <202202161235.0C91ED227@keescook>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzIvMTYg5LiL5Y2IIDEwOjE4OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEtlZXMgQ29vayA8a2Vlc2Nv
b2tAY2hyb21pdW0ub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMTcsIDIwMjIgNDoz
NiBBTQ0KPiBUbzogR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPg0K
PiBDYzogUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBLYWxsZSBWYWxvIDxrdmFsb0BrZXJu
ZWwub3JnPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9y
ZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgbGludXgtaGFyZGVuaW5nQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
XVtuZXh0XSB0dzg5OiBjb3JlLmg6IFJlcGxhY2UgemVyby1sZW5ndGggYXJyYXkgd2l0aCBmbGV4
aWJsZS1hcnJheSBtZW1iZXINCj4gDQo+IE9uIFdlZCwgRmViIDE2LCAyMDIyIGF0IDAxOjUwOjQ3
UE0gLTA2MDAsIEd1c3Rhdm8gQS4gUi4gU2lsdmEgd3JvdGU6DQo+ID4gVGhlcmUgaXMgYSByZWd1
bGFyIG5lZWQgaW4gdGhlIGtlcm5lbCB0byBwcm92aWRlIGEgd2F5IHRvIGRlY2xhcmUNCj4gPiBo
YXZpbmcgYSBkeW5hbWljYWxseSBzaXplZCBzZXQgb2YgdHJhaWxpbmcgZWxlbWVudHMgaW4gYSBz
dHJ1Y3R1cmUuDQo+ID4gS2VybmVsIGNvZGUgc2hvdWxkIGFsd2F5cyB1c2Ug4oCcZmxleGlibGUg
YXJyYXkgbWVtYmVyc+KAnVsxXSBmb3IgdGhlc2UNCj4gPiBjYXNlcy4gVGhlIG9sZGVyIHN0eWxl
IG9mIG9uZS1lbGVtZW50IG9yIHplcm8tbGVuZ3RoIGFycmF5cyBzaG91bGQNCj4gPiBubyBsb25n
ZXIgYmUgdXNlZFsyXS4NCj4gPg0KPiA+IFsxXSBodHRwczovL2VuLndpa2lwZWRpYS5vcmcvd2lr
aS9GbGV4aWJsZV9hcnJheV9tZW1iZXINCj4gPiBbMl0gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9k
b2MvaHRtbC92NS4xNi9wcm9jZXNzL2RlcHJlY2F0ZWQuaHRtbCN6ZXJvLWxlbmd0aC1hbmQtb25l
LWVsZW1lbnQtYXJyYXlzDQo+ID4NCj4gPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vS1NQUC9s
aW51eC9pc3N1ZXMvNzgNCj4gPiBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZvIEEuIFIuIFNpbHZhIDxn
dXN0YXZvYXJzQGtlcm5lbC5vcmc+DQo+IA0KPiBSZXZpZXdlZC1ieTogS2VlcyBDb29rIDxrZWVz
Y29va0BjaHJvbWl1bS5vcmc+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFs
dGVrLmNvbT4NCg0KLS0NClBpbmctS2UNCg0K
