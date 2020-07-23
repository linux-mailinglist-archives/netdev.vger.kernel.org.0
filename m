Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439E422A4FB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbgGWCC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:02:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2586 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731394AbgGWCC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 22:02:27 -0400
Received: from nkgeml704-chm.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 55C91BF14529E52228C9;
        Thu, 23 Jul 2020 10:02:26 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml704-chm.china.huawei.com (10.98.57.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 23 Jul 2020 10:02:26 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.1913.007;
 Thu, 23 Jul 2020 10:02:26 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0gsdjJdIGlwdmxhbjogYWRkIHRoZSBjaGVjayBvZiBp?=
 =?utf-8?Q?p_header_checksum?=
Thread-Topic: [PATCH,v2] ipvlan: add the check of ip header checksum
Thread-Index: AQHWYAm+rUNsYHTSi0meLRdQUe+OMKkTRHyAgAEWvLA=
Date:   Thu, 23 Jul 2020 02:02:25 +0000
Message-ID: <5cb165d14bf146e38a11afe1c2ebfcab@huawei.com>
References: <1595409499-25008-1-git-send-email-geffrey.guo@huawei.com>
 <CANn89iKKSOFSvtoFamuG1S1e5qb_WNpEdFgtQ-UtgkfWa0-WxA@mail.gmail.com>
In-Reply-To: <CANn89iKKSOFSvtoFamuG1S1e5qb_WNpEdFgtQ-UtgkfWa0-WxA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.164.122.165]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QmVjYXVzZSBpcHZsYW4gd2lsbCBkbyB0aGUgaXAgZm9yd2FyZCwgaXQgd2lsbCBkbyBhIHJvdXRl
IGxvb2t1cC5pZiB0aGUgaWhsIG9mIHRoZSBpcCBoZWFkZXIgaXMgc21hbGxlciB0aGFuIDUsIHRo
aXMgY2F1c2UgaXBfZmFzdF9jc3VtIGFjY2VzcyB0aGUgaWxsZWdhbCBhZGRyZXNzLg0KDQotLS0t
LemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBbbWFpbHRvOmVkdW1h
emV0QGdvb2dsZS5jb21dIA0K5Y+R6YCB5pe26Ze0OiBUaHVyc2RheSwgSnVseSAyMywgMjAyMCAw
OjMwDQrmlLbku7bkuro6IEd1b2RlcWluZyAoQSkgPGdlZmZyZXkuZ3VvQGh1YXdlaS5jb20+DQrm
ioTpgIE6IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+OyBNYWhlc2ggQmFuZGV3YXIgPG1haGVzaGJAZ29vZ2xlLmNvbT47
IG5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCuS4u+mimDogUmU6IFtQQVRDSCx2Ml0g
aXB2bGFuOiBhZGQgdGhlIGNoZWNrIG9mIGlwIGhlYWRlciBjaGVja3N1bQ0KDQpPbiBXZWQsIEp1
bCAyMiwgMjAyMCBhdCAyOjIzIEFNIGd1b2RlcWluZyA8Z2VmZnJleS5ndW9AaHVhd2VpLmNvbT4g
d3JvdGU6DQo+DQo+IFRoZSBpcCBoZWFkZXIgY2hlY2tzdW0gY2FuIGJlIGVycm9yIGluIHRoZSBm
b2xsb3dpbmcgc3RlcHMuDQo+ICQgaXAgbmV0bnMgYWRkIG5zMQ0KPiAkIGlwIGxpbmsgYWRkIGd3
IGxpbmsgZXRoMCB0eXBlIGlwdmxhbiAkIGlwIGFkZHIgYWRkIDE2OC4xNi4wLjEvMjQgZGV2IA0K
PiBndyAkIGlwIGxpbmsgc2V0IGRldiBndyB1cCAkIGlwIGxpbmsgYWRkIGlwMSBsaW5rIGV0aDAg
dHlwZSBpcHZsYW4gJCANCj4gaXAgbGluayBzZXQgaXAxIG5ldG5zIG5zMSAkIGlwIG5ldG5zIGV4
ZWMgbnMxIGlwIGxpbmsgc2V0IGlwMSB1cCAkIGlwIA0KPiBuZXRucyBleGVjIG5zMSBpcCBhZGRy
IGFkZCAxNjguMTYuMC4yLzI0IGRldiBpcDEgJCBpcCBuZXRucyBleGVjIG5zMSANCj4gdGMgcWRp
c2MgYWRkIGRldiBpcDEgcm9vdCBuZXRlbSBjb3JydXB0IDUwJSAkIGlwIG5ldG5zIGV4ZWMgbnMx
IHBpbmcgDQo+IDE2OC4xNi4wLjENCj4NCj4gVGhpcyBpcyBiZWNhdXNlIHRoZSBuZXRlbSB3aWxs
IG1vZGlmeSB0aGUgcGFja2V0IHJhbmRvbWx5LiB0aGUgDQo+IGNvcnJ1cHRlZCBwYWNrZXRzIHNo
b3VsZCBiZSBkcm9wcGVkIGRlcmVjdGx5LCBvdGhlcndpc2UgaXQgbWF5IGNhdXNlIGEgDQo+IHBy
b2JsZW0uDQoNCg0KQW5kIHdoeSB3b3VsZCBpcHZsYW4gYmUgc28gc3BlY2lhbCA/DQoNCldoYXQg
YWJvdXQgYWxsIG90aGVyIGRyaXZlcnMgPw0KDQpNeSBhZHZpY2UgOiBEbyBub3QgdXNlIG5ldGVt
IGNvcnJ1cHQgaWYgeW91IGRvIG5vdCB3YW50IHRvIHNlbmQgY29ycnVwdGVkIHBhY2tldHMgLg0K
DQo+DQo+DQo+IEhlcmUgSSBhZGQgdGhlIGNoZWNrIG9mIGlwIGhlYWRlciBjaGVja3N1bSBhbmQg
ZHJvcCB0aGUgaWxsZWdhbCANCj4gcGFja2V0cyBpbiBsMy9sM3MgbW9kZS4NCj4NCg0KVGhpcyBw
YXRjaCBtYWtlcyBubyBzZW5zZSByZWFsbHkuDQoNCj4NCj4gU2lnbmVkLW9mZi1ieTogZ3VvZGVx
aW5nIDxnZWZmcmV5Lmd1b0BodWF3ZWkuY29tPg0KPiAtLS0NCg==
