Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B4899397
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbfHVMbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:31:40 -0400
Received: from mx21.baidu.com ([220.181.3.85]:59145 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbfHVMbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:31:39 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.40.49])
        by Forcepoint Email with ESMTPS id C80A1A8990199;
        Thu, 22 Aug 2019 20:31:32 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.40.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 22 Aug 2019 20:31:33 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 22 Aug 2019 20:31:33 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVtuZXQtbmV4dF0gbmV0OiBkcm9wX21vbml0b3I6IGNo?=
 =?gb2312?B?YW5nZSB0aGUgc3RhdHMgdmFyaWFibGUgdG8gdTY0IGluIG5ldF9kbV9zdGF0?=
 =?gb2312?Q?s=5Fput?=
Thread-Topic: [PATCH][net-next] net: drop_monitor: change the stats variable
 to u64 in net_dm_stats_put
Thread-Index: AQHVWOEdXXTcs9XKS02SWSF/fxbtAqcHGAKg
Date:   Thu, 22 Aug 2019 12:31:33 +0000
Message-ID: <84063fe4df95437d81beb0d18f4043a5@baidu.com>
References: <1566454953-29321-1-git-send-email-lirongqing@baidu.com>
 <20190822115946.GA25090@splinter>
In-Reply-To: <20190822115946.GA25090@splinter>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.20]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-08-22 20:31:33:789
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-08-22
 20:31:33:773
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSWRvIFNjaGltbWVsIFttYWlsdG86
aWRvc2NoQGlkb3NjaC5vcmddDQo+ILeiy83KsbzkOiAyMDE5xOo41MIyMsjVIDIwOjAwDQo+IMrV
vP7IyzogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiCzrcvNOiBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBpZG9zY2hAbWVsbGFub3guY29tDQo+INb3zOI6IFJlOiBbUEFUQ0hd
W25ldC1uZXh0XSBuZXQ6IGRyb3BfbW9uaXRvcjogY2hhbmdlIHRoZSBzdGF0cyB2YXJpYWJsZSB0
bw0KPiB1NjQgaW4gbmV0X2RtX3N0YXRzX3B1dA0KPiANCj4gT24gVGh1LCBBdWcgMjIsIDIwMTkg
YXQgMDI6MjI6MzNQTSArMDgwMCwgTGkgUm9uZ1Fpbmcgd3JvdGU6DQo+ID4gb25seSB0aGUgZWxl
bWVudCBkcm9wIG9mIHN0cnVjdCBuZXRfZG1fc3RhdHMgaXMgdXNlZCwgc28gc2ltcGxpZnkgaXQN
Cj4gPiB0byB1NjQNCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHBhdGNoLCBidXQgSSBkb24ndCByZWFs
bHkgc2VlIHRoZSB2YWx1ZSBoZXJlLiBUaGUgc3RydWN0IGFsbG93cyBmb3INCj4gZWFzeSBleHRl
bnNpb25zIGluIHRoZSBmdXR1cmUuIFdoYXQgZG8geW91IGdhaW4gZnJvbSB0aGlzIGNoYW5nZT8g
V2UgbWVyZWx5DQo+IHJlYWQgc3RhdHMgYW5kIHJlcG9ydCB0aGVtIHRvIHVzZXIgc3BhY2UsIHNv
IEkgZ3Vlc3MgaXQncyBub3QgYWJvdXQNCj4gcGVyZm9ybWFuY2UgZWl0aGVyLg0KPiANCg0KSSB0
aGluayB1NjQgY2FuIHJlZHVjZSB0byBjYWxsIG1lbXNldCBhbmQgZGVyZWZlcmVuY2Ugc3RhdHMu
ZHJvcA0KDQpJZiBpdCBpcyBmb3IgZnV0dXJlLCBrZWVwIGl0DQoNCi1Sb25nUWluZw0K
