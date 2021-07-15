Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB03C9792
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbhGOEj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:39:59 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:46278 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhGOEj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:39:58 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16F4aqL43020378, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16F4aqL43020378
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Jul 2021 12:36:52 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Jul 2021 12:36:51 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Jul 2021 12:36:51 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Thu, 15 Jul 2021 12:36:51 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Takashi Iwai <tiwai@suse.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH 0/2] r8152: Fix a couple of PM problems
Thread-Topic: [PATCH 0/2] r8152: Fix a couple of PM problems
Thread-Index: AQHXePudExHDWobuaEuHpSMDHUndr6tDcygA
Date:   Thu, 15 Jul 2021 04:36:51 +0000
Message-ID: <e6cf8c26165a489bbf704946765ac3bd@realtek.com>
References: <20210714170022.8162-1-tiwai@suse.de>
 <162630000449.32220.17532101783175093246.git-patchwork-notify@kernel.org>
In-Reply-To: <162630000449.32220.17532101783175093246.git-patchwork-notify@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMTUg5LiK5Y2IIDAxOjA3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/15/2021 04:22:21
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165043 [Jul 14 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;realtek.com:7.1.1;git.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/15/2021 04:25:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIDAvMl0gcjgxNTI6IEZpeCBhIGNvdXBsZSBvZiBQTSBwcm9i
bGVtcw0KWy4uLl0NCj4gDQo+IEhlcmUgaXMgdGhlIHN1bW1hcnkgd2l0aCBsaW5rczoNCj4gICAt
IFsxLzJdIHI4MTUyOiBGaXggcG90ZW50aWFsIFBNIHJlZmNvdW50IGltYmFsYW5jZQ0KPiAgICAg
aHR0cHM6Ly9naXQua2VybmVsLm9yZy9uZXRkZXYvbmV0L2MvOWMyM2FhNTE0NzdhDQo+ICAgLSBb
Mi8yXSByODE1MjogRml4IGEgZGVhZGxvY2sgYnkgZG91Ymx5IFBNIHJlc3VtZQ0KPiAgICAgaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9uZXRkZXYvbmV0L2MvNzc2YWM2M2E5ODZkDQoNCkkgdGhpbmsg
c2V0X2V0aGVybmV0X2FkZHIoKSBzaG91bGRuJ3QgYmUgY2FsbGVkIGF0IHJlc2V0LXJlc3VtZS4N
ClRoZSBNQUMgYWRkcmVzcyBzaG91bGQgYmUgcmVzdG9yZWQgdG8gdGhlIGN1cnJlbnQgb25lLCBu
b3QgdGhlDQpkZWZhdWx0IHZhbHVlLiBTb21lb25lIG1heSBjaGFuZ2UgdGhlIE1BQyBhZGRyZXNz
IGJlZm9yZSBzdXNwZW5kaW5nLg0KQW5kIHRoZSBNQUMgYWRkcmVzcyB3b3VsZCBiZWNvbWUgdGhl
IGRlZmF1bHQgdmFsdWUgYWZ0ZXIgcmVzZXQtcmVzdW1lLA0KaWYgc2V0X2V0aGVybmV0X2FkZHIo
KSBpcyBjYWxsZWQuDQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg==
