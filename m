Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5FC2920DF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgJSBfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 21:35:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3645 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728042AbgJSBfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 21:35:43 -0400
Received: from dggemi404-hub.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 70FBFD05F2E52ECA3DB0;
        Mon, 19 Oct 2020 09:35:41 +0800 (CST)
Received: from DGGEMI422-HUB.china.huawei.com (10.1.199.151) by
 dggemi404-hub.china.huawei.com (10.3.17.142) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 19 Oct 2020 09:35:41 +0800
Received: from DGGEMI532-MBX.china.huawei.com ([169.254.7.245]) by
 dggemi422-hub.china.huawei.com ([10.1.199.151]) with mapi id 14.03.0487.000;
 Mon, 19 Oct 2020 09:35:32 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        David Ahern <dsahern@gmail.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBydG5ldGxpbms6IGZpeCBkYXRhIG92ZXJmbG93IGlu?=
 =?gb2312?Q?_rtnl=5Fcalcit()?=
Thread-Topic: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Thread-Index: AQHWo2B2wcLrrPLeR0ifPF37QbJD4qmaO+6AgAPmgtA=
Date:   Mon, 19 Oct 2020 01:35:32 +0000
Message-ID: <0DCA8173C37AD8458D6BA40EB0C660918CA671@DGGEMI532-MBX.china.huawei.com>
References: <20201016020238.22445-1-zhudi21@huawei.com>
 <20201016143625.00005f4e@intel.com>
In-Reply-To: <20201016143625.00005f4e@intel.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ICJpcCBhZGRyIHNob3ciIGNvbW1hbmQgZXhlY3V0ZSBlcnJvciB3aGVuIHdlIGhhdmUgYSBw
aHlzaWNhbCBuZXR3b3JrDQo+ID4gY2FyZCB3aXRoIG51bWJlciBvZiBWRnMgbGFyZ2VyIHRoYW4g
MjQ3Lg0KPiANCj4gT2ggbWFuLCB0aGlzIGJ1ZyBoYXMgYmVlbiBodXJ0aW5nIHVzIGZvcmV2ZXIg
YW5kIEkndmUgdHJpZWQgdG8gZml4IGl0IHNldmVyYWwNCj4gdGltZXMgd2l0aG91dCBtdWNoIGx1
Y2ssIHNvIHRoYW5rcyBmb3Igd29ya2luZyBvbiBpdCENCj4gDQo+IENDOiBEYXZpZCBBaGVybiA8
ZHNhaGVybkBnbWFpbC5jb20+DQo+IA0KPiBBcyBoZSdzIG1lbnRpb25lZCB0aGlzIGJ1Zy4NCj4g
Li4uLi4uIA0KPiBLZXJuZWwgZG9jdW1lbnRhdGlvbiBzYXlzIGZvciB5b3UgdG8gdXNlIHlvdXIg
cmVhbCBuYW1lLCBwbGVhc2UgZG8gc28sDQo+IHVubGVzcyB5b3UncmUgYSByb2NrIHN0YXIgYW5k
IGhhdmUgb2ZmaWNpYWxseSBjaGFuZ2VkIHlvdXIgbmFtZSB0byB6aHVkaS4NCj4gDQoNCk1heSBi
ZSBJIHNob3VsZCB1c2UgbmFtZSBzdWNoIGFzIGRpLnpodSAgdG8gYXZvaWQgdW5uZWNlc3Nhcnkg
cHJvYmxlbSA6KQ0KDQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvbGludXgvbmV0bGluay5oIHwgMiAr
LQ0KPiA+ICBuZXQvY29yZS9ydG5ldGxpbmsuYyAgICB8IDggKysrKy0tLS0NCj4gPiAgMiBmaWxl
cyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBEb2VzIGl0
IHdvcmsgd2l0aG91dCBhbnkgY2hhbmdlcyB0byBpcHJvdXRlMj8NCg0KVGhlIHBhdGNoIG9ubHkg
Y2hhbmdlIHRoZSBpbnRlcm5hbCBkYXRhIHN0cnVjdCBjdXJyZW50bHkgb25seSB1c2VkIGJ5IG5l
dGxpbmtfZHVtcF9zdGFydCgpIGZ1bmN0aW9uLg0KU28gSSB0aGluayB0aGlzIHBhdGNoICBoYXMg
bm90IGVmZmVjdHMgb24gaXByb3V0ZTIgb3Igb3RoZXIgcGFja2FnZXMNCg0K
