Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832113E3307
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 05:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhHGDvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 23:51:13 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49930 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhHGDvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 23:51:12 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1773onvI7027306, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1773onvI7027306
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 7 Aug 2021 11:50:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 7 Aug 2021 11:50:48 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 7 Aug 2021 11:50:47 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Sat, 7 Aug 2021 11:50:47 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "koba.ko@canonical.com" <koba.ko@canonical.com>
Subject: RE: [PATCH net-next 2/2] r8169: change the L0/L1 entrance latencies for RTL8106e
Thread-Topic: [PATCH net-next 2/2] r8169: change the L0/L1 entrance latencies
 for RTL8106e
Thread-Index: AQHXiqPUBB936oECW06D4tOEh+kMGKtmeFwAgADuiUA=
Date:   Sat, 7 Aug 2021 03:50:47 +0000
Message-ID: <95d8ea6b2b814bb9932961360ccd2061@realtek.com>
References: <20210806091556.1297186-374-nic_swsd@realtek.com>
 <20210806091556.1297186-376-nic_swsd@realtek.com>
 <3cfd64a9-dff2-6e60-1524-ddbd1c388c01@gmail.com>
In-Reply-To: <3cfd64a9-dff2-6e60-1524-ddbd1c388c01@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzgvNiDkuIvljYggMTE6MDI6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/07/2021 03:41:31
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165456 [Aug 06 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/07/2021 03:44:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogU2F0dXJkYXks
IEF1Z3VzdCA3LCAyMDIxIDU6MjggQU0NClsuLi5dDQo+IE1vc3QgY2hpcCB2ZXJzaW9ucyB1c2Ug
cnRsX3NldF9kZWZfYXNwbV9lbnRyeV9sYXRlbmN5KCkgdGhhdCBzZXRzDQo+IHRoZSB2YWx1ZSB0
byAweDI3LiBEb2VzIHRoaXMgdmFsdWUgYWxzbyB3b3JrIGZvciBSVEw4MTA2ZT8NCg0KTm8sIGl0
IGRvZXNuJ3Qgd29yay4NCg0KPiBDYW4geW91IGV4cGxhaW4gaG93IHRoZSBMMCBhbmQgTDEgdGlt
ZXMgaW4gdXMgbWFwIHRvIHRoZQ0KPiByZWdpc3RlciB2YWx1ZT8gVGhlbiB3ZSBjb3VsZCBhZGQg
YSBmdW5jdGlvbiB0aGF0IGRvZXNuJ3Qgd29yaw0KPiB3aXRoIGEgbWFnaWMgdmFsdWUgYnV0IHRh
a2VzIHRoZSBMMCBhbmQgTDEgdGltZXMgaW4gdXMgYXMNCj4gcGFyYW1ldGVyLg0KDQpMMCAoYml0
IDB+Mik6DQoJMDogMXVzDQoJMTogMnVzDQoJMjogM3VzDQoJMzogNHVzDQoJNDogNXVzDQoJNTog
NnVzDQoJNjogN3VzDQoJNzogN3VzIChUaGUgbWF4aW11bSBpcyA3dXMpDQoNCkwxIChiaXQgM341
KToNCgkwOiAxdXMNCgkxOiAydXMNCgkyOiA0dXMNCgkzOiA4dXMNCgk0OiAxNnVzDQoJNTogMzJ1
cw0KCTY6IDY0dXMNCgk3OiA2NHVzIChUaGUgbWF4aW11bSBpcyA2NHVzKQ0KDQpCZXN0IFJlZ2Fy
ZHMsDQpIYXllcw0KDQo=
