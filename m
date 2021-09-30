Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B7D41DE90
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349205AbhI3QPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:15:34 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45487 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349113AbhI3QPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 12:15:30 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 18UGDFBc8009853, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 18UGDFBc8009853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 1 Oct 2021 00:13:15 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 00:13:15 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 30 Sep 2021 09:13:15 -0700
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Fri, 1 Oct 2021 00:13:14 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Jason-ch Chen <jason-ch.chen@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] r8152: stop submitting rx for -EPROTO
Thread-Topic: [PATCH] r8152: stop submitting rx for -EPROTO
Thread-Index: AQHXtPF6mRt31KuIqUSf0ySwz113xKu6nqYQ//+g0oCAAYwXgIAAt/FQ
Date:   Thu, 30 Sep 2021 16:13:14 +0000
Message-ID: <9a23368b27bd42299e74235f1f8be3fa@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
 <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
In-Reply-To: <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.192.91.194]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzkvMzAgpFWkyCAwMjozODowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRl
bWJlciAzMCwgMjAyMSA1OjMwIFBNDQpbLi4uXQ0KPiBIaSwNCj4gDQo+IEhheWVzIHByb3Bvc2Vk
IGEgc29sdXRpb24uIEJhc2ljYWxseSB5b3Ugc29sdmUgdGhpcyB0aGUgd2F5IEhJRCBvciBXRE0g
ZG8gaXQNCj4gZGVsYXlpbmcgcmVzdWJtaXNzaW9uLiBUaGlzIG1ha2VzIG1lIHdvbmRlciB3aGV0
aGVyIHRoaXMgcHJvYmxlbSBpcyBzcGVjaWZpYw0KPiB0byBhbnkgZHJpdmVyLiBJZiBpdCBpcyBu
b3QsIGFzIEkgd291bGQgYXJndWUsIGRvIHdlIGhhdmUgYSBkZWZpY2llbmN5DQo+IGluIG91ciBB
UEk/DQoNCkkgdGhpbmsgdGhlIG1ham9yIHF1ZXN0aW9uIGlzIHRoYXQgdGhlIGRyaXZlciBkb2Vz
bid0IGtub3cgd2hldGhlcg0KaXQgaXMgbmVjZXNzYXJ5IHRvIHN0b3Agc3VibWl0dGluZyBidWxr
IHRyYW5zZmVyIG9yIG5vdC4gVGhlcmUgYXJlDQp0d28gc2l0dWF0aW9ucyB3aXRoIHRoZSBzYW1l
IGVycm9yIGNvZGUuIE9uZSBuZWVkcyB0byByZXN1Ym1pdA0KdGhlIGJ1bGsgdHJhbnNmZXIuIFRo
ZSBvdGhlciBuZWVkcyB0byBzdG9wIHRoZSB0cmFuc2Zlci4gVGhlIG9yaWdpbmFsDQppZGVhIGlz
IHRoYXQgdGhlIGRpc2Nvbm5lY3QgZXZlbnQgd291bGQgc3RvcCBzdWJtaXR0aW5nIHRyYW5zZmVy
IGZvcg0KdGhlIHNlY29uZCBzaXR1YXRpb24uIEhvd2V2ZXIsIGZvciB0aGlzIGNhc2UsIHRoZSBk
aXNjb25uZWN0IGV2ZW50DQpjb21lcyB2ZXJ5IGxhdGUsIHNvIHRoZSBzdWJtaXNzaW9uIGNvdWxk
bid0IGJlIHN0b3BwZWQgaW4gdGltZS4NClRoZSBiZXN0IHNvbHV0aW9uIGlzIHRoZSBkcml2ZXIg
Y291bGQgZ2V0IGFub3RoZXIgZXJyb3IgY29kZSB3aGljaA0KaW5kaWNhdGVzIHRoZSBkZXZpY2Ug
aXMgZGlzYXBwZWFyIGZvciB0aGUgc2Vjb25kIHNpdHVhdGlvbi4gIFRoZW4sDQpJIGRvbid0IG5l
ZWQgdG8gZG8gZGVsYXllZCByZXN1Ym1pc3Npb24uDQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQo=
