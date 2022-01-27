Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D34749DCB4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbiA0In7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:43:59 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53425 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiA0In6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:43:58 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20R8gwA73008070, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20R8gwA73008070
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jan 2022 16:42:58 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 16:42:58 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 16:42:58 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Thu, 27 Jan 2022 16:42:58 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Aaron Ma <aaron.ma@canonical.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Henning Schild <henning.schild@siemens.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough address
Thread-Topic: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Thread-Index: AQHYAkb+XWXmurlfvUCud8k7wjo3mqxUKRoAgABIlgCAAAqXAIAAPjsAgAC9QoCAANKOgIAACHCAgATH5wCAAN82AIAAluGAgADbvICAABjvgIAAAeSAgAAC1gCAAAMVAIAAA1gAgAABIwCAAbbOgIAAAcsAgACE9wCAFfeygIAA2/Vg//996wCAAIngEA==
Date:   Thu, 27 Jan 2022 08:42:57 +0000
Message-ID: <fe97d50054484f4f8299bc340166a625@realtek.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
 <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
 <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
 <edff6219-b1f7-dec5-22ea-0bde9a3e0efb@canonical.com>
 <5b94f064bd5c48589ea856f68ac0e930@realtek.com>
 <e52f8155-61a8-0cea-b96c-a05b83cdfff9@canonical.com>
In-Reply-To: <e52f8155-61a8-0cea-b96c-a05b83cdfff9@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMjcg5LiK5Y2IIDA0OjA1OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWFyb24gTWEgPGFhcm9uLm1hQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKYW51
YXJ5IDI3LCAyMDIyIDQ6MTMgUE0NClsuLi5dDQo+ID4gSSBkb24ndCB0aGluayB0aGUgZmVhdHVy
ZSBvZiBNQUMgcGFzc3Rocm91Z2ggYWRkcmVzcyBpcyBtYWludGFpbmVkDQo+ID4gYnkgUmVhbHRl
ay4gRXNwZWNpYWxseSwgdGhlcmUgaXMgbm8gdW5pZm9ybSB3YXkgYWJvdXQgaXQuIFRoZQ0KPiA+
IGRpZmZlcmVudCBjb21wYW5pZXMgaGF2ZSB0byBtYWludGFpbiB0aGVpciBvd24gd2F5cyBieSB0
aGVtc2VsdmVzLg0KPiA+DQo+ID4gUmVhbHRlayBjb3VsZCBwcm92aWRlIHRoZSBtZXRob2Qgb2Yg
ZmluZGluZyBvdXQgdGhlIHNwZWNpZmljIGRldmljZQ0KPiA+IGZvciBMZW5vdm8uIFlvdSBjb3Vs
ZCBjaGVjayBVU0IgT0NQIDB4RDgxRiBiaXQgMy4gRm9yIGV4YW1wbGUsDQo+ID4NCj4gPiAJb2Nw
X2RhdGEgPSBvY3BfcmVhZF9ieXRlKHRwLCBNQ1VfVFlQRV9VU0IsIFVTQl9NSVNDXzEpOw0KPiA+
IAlpZiAodHAtPnZlcnNpb24gPT0gUlRMX1ZFUl8wOSAmJiAob2NwX2RhdGEgJiBCSVQoMykpKSB7
DQo+ID4gCQkvKiBUaGlzIGlzIHRoZSBSVEw4MTUzQiBmb3IgTGVub3ZvLiAqLw0KPiA+IAl9DQo+
ID4NCj4gDQo+IE1heSBJIHVzZSB0aGUgY29kZSBmcm9tIFJlYWx0ZWsgT3V0Ym94IGRyaXZlciB0
byBpbXBsZW1lbnQgdGhlIE1BUFQ/DQo+IA0KPiBJZiBzbywgYWxsb3cgbWUgdG8gd3JpdGUgYSBw
YXRjaCBhbmQgc2VuZCBoZXJlIHRvIHJldmlldy4NCg0KU3VyZS4NCg0KSG93ZXZlciwgdGhlIG91
dGJveCBkcml2ZXIgaGFzIGEgbWlzdGFrZS4NClRoZSBtYWNfb2JqX25hbWUgd2l0aCAiXFxfU0Iu
QU1BQyIgaXMgdXNlZCBieSBEZWxsLg0KSSB0aGluayB0aGUgZGV2aWNlIG9mIExlbm92byBzaG91
bGQgdXNlICJcXE1BQ0EiIG9ubHkuIFJpZ2h0Pw0KDQpUaGUgZWFzaWVzdCB3YXkgaXMgdG8gc2V0
IHRwLT5sZW5vdm9fbWFjcGFzc3RocnUgZm9yIFJUTDgxNTNCTC4NCkZvciBleGFtcGxlLA0KDQoJ
b2NwX2RhdGEgPSBvY3BfcmVhZF9ieXRlKHRwLCBNQ1VfVFlQRV9VU0IsIFVTQl9NSVNDXzEpOw0K
CWlmICh0cC0+dmVyc2lvbiA9PSBSVExfVkVSXzA5ICYmIChvY3BfZGF0YSAmIEJJVCgzKSkpDQoJ
CXRwLT5sZW5vdm9fbWFjcGFzc3RocnUgPSAxOw0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQoN
Cg==
