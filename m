Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89F722193D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGPBDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:03:33 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:60162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbgGPBDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:03:32 -0400
Received: from dggemi403-hub.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id EC23C799AB3510446CB9;
        Thu, 16 Jul 2020 09:03:30 +0800 (CST)
Received: from DGGEMI521-MBX.china.huawei.com ([169.254.6.174]) by
 dggemi403-hub.china.huawei.com ([10.3.17.136]) with mapi id 14.03.0487.000;
 Thu, 16 Jul 2020 09:03:21 +0800
From:   "Zhouxudong (EulerOS)" <zhouxudong8@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "wensong@linux-vs.org" <wensong@linux-vs.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        "Zhaowei (EulerOS)" <zhaowei23@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBpcHZzOmNsZWFuIGNvZGUgZm9yIGlwX3ZzX3N5bmMu?=
 =?gb2312?Q?c?=
Thread-Topic: [PATCH] ipvs:clean code for ip_vs_sync.c
Thread-Index: AQHWWqIdsRLt5EddQkWnGRF7q9TT+6kIrDIAgAC2fwA=
Date:   Thu, 16 Jul 2020 01:03:20 +0000
Message-ID: <69D1AB391AAC5746B9ECCF192D064D641A79498C@DGGEMI521-MBX.china.huawei.com>
References: <1594815519-37044-1-git-send-email-zhouxudong8@huawei.com>
 <20200715150336.711be40a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715150336.711be40a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.164.155.96]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGZvciBzdWdnZXN0aW9uLg0KRmlyc3RseSwgSSBzaG93IGFuIGV4cGxhbmF0aW9u
IGZvciB0aGUgc2Vjb25kIGVtYWlsLg0KU29ycnksIEkgZm9yZ290IHRvIENDIG15c2VsZiBpbiBz
ZW5kaW5nIGZpcnN0IGVtYWlsLCB3aGljaCBsZWFkIHRvIEkgY2Fubm90IGtub3cgaWYgaXQgc3Vj
Y2Vzc2Z1bGx5Lg0KU28sSSBzZW5kIGl0IGFnYWluLg0KDQpBbmQgbm93LCBJIHdpbGwgYWRkIGEg
c3BhY2UgYWZ0ZXIgaXB2czogaW4gdGhlIHN1YmplY3QgYW5kIGFmdGVyIFNpZ25lZC1vZmYtYnk6
Lg0KDQotLS0tLdPKvP7Urbz+LS0tLS0NCreivP7IyzogSmFrdWIgS2ljaW5za2kgW21haWx0bzpr
dWJhQGtlcm5lbC5vcmddIA0Kt6LLzcqxvOQ6IDIwMjDE6jfUwjE2yNUgNjowNA0KytW8/sjLOiBa
aG91eHVkb25nIChFdWxlck9TKSA8emhvdXh1ZG9uZzhAaHVhd2VpLmNvbT4NCrOty806IHdlbnNv
bmdAbGludXgtdnMub3JnOyBob3Jtc0B2ZXJnZS5uZXQuYXU7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGx2cy1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IENoZW54aWFuZyAoRXVsZXJPUykgPHJvc2Uu
Y2hlbkBodWF3ZWkuY29tPg0K1vfM4jogUmU6IFtQQVRDSF0gaXB2czpjbGVhbiBjb2RlIGZvciBp
cF92c19zeW5jLmMNCg0KT24gV2VkLCAxNSBKdWwgMjAyMCAxMjoxODozOSArMDAwMCB6aG91eHVk
b25nMTk5IHdyb3RlOg0KPiBTaWduZWQtb2ZmLWJ5Onpob3V4dWRvbmcxOTkgPHpob3V4dWRvbmc4
QGh1YXdlaS5jb20+DQoNClRoYW5rIHlvdSBmb3IgdGhlIHBhdGNoLg0KDQpQbGVhc2UgZGVzY3Jp
YmUgdGhlIGNoYW5nZXMgeW91J3JlIG1ha2luZyBpbiB0aGUgY29tbWl0IG1lc3NhZ2UsIGFzIGZh
ciBhcyBJIGNhbiB0ZWxsIHlvdSdyZSBhZGRpbmcgbWlzc2luZyBzcGFjZXM/DQoNClBsZWFzZSBy
ZWFkIHRoaXM6IGh0dHBzOi8va2VybmVsbmV3Ymllcy5vcmcvS2VybmVsSmFuaXRvcnMNCmFuZCBt
YWtlIHN1cmUgdG8gQ0Mga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZw0KDQpQbGVhc2Ug
YWRkIGEgc3BhY2UgYWZ0ZXIgaXB2czogaW4gdGhlIHN1YmplY3QgYW5kIGFmdGVyIFNpZ25lZC1v
ZmYtYnk6DQoNCklmIHlvdSByZXBvc3QgcGxlYXNlIG1ha2Ugc3VyZSB0byBtYXJrIHRoZSBwYXRj
aCBhcyB2Mi4NCg0KPiBAQCAtMTIzMiw3ICsxMjMyLDcgQEAgc3RhdGljIHZvaWQgaXBfdnNfcHJv
Y2Vzc19tZXNzYWdlKHN0cnVjdCBuZXRuc19pcHZzICppcHZzLCBfX3U4ICpidWZmZXIsDQo+ICAJ
CW1zZ19lbmQgPSBidWZmZXIgKyBzaXplb2Yoc3RydWN0IGlwX3ZzX3N5bmNfbWVzZyk7DQo+ICAJ
CW5yX2Nvbm5zID0gbTItPm5yX2Nvbm5zOw0KPiAgDQo+IC0JCWZvciAoaT0wOyBpPG5yX2Nvbm5z
OyBpKyspIHsNCj4gKwkJZm9yIChpPTA7IGkgPCBucl9jb25uczsgaSsrKSB7DQoNCnlvdSBzaG91
bGQgcHJvYmFibHkgcmVwbGFjZSBpPTAgd2l0aCBpID0gMC4NCg0KPiAgCQkJdW5pb24gaXBfdnNf
c3luY19jb25uICpzOw0KPiAgCQkJdW5zaWduZWQgaW50IHNpemU7DQo+ICAJCQlpbnQgcmV0YzsN
Cg==
